import re
import time
import numpy as np
import cv2
import base64
import matplotlib.pyplot as plt


class Translator(object):
    def __init__(self, width=1000, each=10):
        self.width = width
        self.each = each

    def encode(self, s, o=' '):
        res = [bin(ord(c)).replace('0b', '') for c in s]
        return o.join([(8 - len(i)) * '0' + i for i in res])

    def decode(self, s):
        s = s.replace(' ', '')
        res = [s[i:i + 8] for i in range(0, (len(s)//8)*8, 8)]
        return ''.join([chr(int(i, 2)) for i in res])

    def file_to_base64(self, file_data: bytes):
        return base64.b64encode(file_data).decode('utf-8')

    def base64_to_data(self, content: bytes):
        return base64.b64decode(content)

    def make_ercode(self, codes):
        w = self.width // self.each
        if len(codes) > w * w:
            print('超出')
        white = [255, 255, 255]
        black = [0, 0, 0]
        e = self.each
        output = np.zeros((self.width + 4 * e, self.width + 4 * e, 3), np.uint8)
        output[e:2 * e, e:-e] = output[-2 * e:-e, e:-e] = white
        output[e:-e, e:2 * e] = output[e:-e, -2 * e:-e] = white
        for i, c in enumerate(codes):
            col = i % w
            row = i // w
            if row >= w:
                break
            output[(2 + row) * e:(row + 3) * e, (col + 2) * e:(col + 3) * e] = white if c == '1' else black
        return output

    def file_to_video(self, file_path, output=None):
        with open(file_path, 'rb') as buf:
            content = 's' * 50 + 'start' + self.file_to_base64(buf.read()) + 'end' + 'd' * 50
        content = self.encode(content, '')
        rows = self.width // self.each
        print(f'need about {len(content) // (rows * rows * 60)} minute')
        video = cv2.VideoWriter(output, cv2.VideoWriter_fourcc(*'XVID'), 1, (self.width + 4*self.each, self.width+4*self.each)) if output else None
        nump = (rows * rows) // 8 * 8
        pages = [content[i * nump:(i + 1) * nump] for i in range(len(content) // nump + 1)]
        for p in pages:
            img = self.make_ercode(p)
            cv2.imshow('Live', img)
            cv2.waitKey(1)
            # time.sleep(0.5)
            if video:
                video.write(img)
        video.release()

    def live_to_file(self, video_path=None):
        out_str = []
        pre_res = ''
        capture = cv2.VideoCapture(video_path if video_path else 0)
        while capture.isOpened():
            rval, frame = capture.read()
            if not rval or cv2.waitKey(1) in [27, ord('q')]:
                break
            h, w, deep = frame.shape
            # 旋转
            # matRotate = cv2.getRotationMatrix2D((w/2, h), -90, 1)  # mat rotate 1 center 2 angle 3 缩放系数
            # frame = cv2.warpAffine(frame, matRotate, (w+h, max(w, h)))
            # 平移
            # M = np.float32([[1, 0, -w/2], [0, 1, 0]])
            # frame = cv2.warpAffine(frame, M, (h, w))
            # 左右反转
            # frame = cv2.flip(frame, 1)
            res = self.get_img_codes(frame)
            cv2.imshow('live', frame)
            if not re.match(r'^[A-Za-z0-9=]+$', res) or res == pre_res:
                continue
            print(res)
            pre_res = res
            out_str.append(res)
        capture.release()
        cv2.destroyAllWindows()
        res = ''.join(out_str)
        return res

    def _get_splits(self, code, gap):
        ros = [0, code.shape[-1]]
        for r in code:
            s = np.where(np.diff(r) != 0)[0]+1
            ros.extend(s)
        ros.sort()
        rs = np.array(sorted(list(set(ros))))
        split_rows = np.split(rs, np.where(np.diff(rs) > gap/2)[0] + 1, axis=0)
        slice = []
        pre = 0
        for i in split_rows:
            this = i[0]
            for j in i:
                if ros.count(j) > ros.count(this):
                    this = j
            power = (this - pre) / gap
            if power > 1.8:
                for i in range(round(power)-1):
                    slice.append(pre+gap * (i+1))
                slice.append(this)
            elif this - pre < gap*0.9 and pre != 0:
                continue
            else:
                slice.append(this)
            pre = this
        if len(slice) != (self.width // self.each + 1):
            slice = [i*self.each for i in range(self.width//self.each + 1)]
        return slice

    def transfor_image(self, img, rect1, rect2):
        w, h, deep = img.shape
        if len(rect1) < 4:  # 仿射变换
            M = cv2.getAffineTransform(rect1, rect2)
            return cv2.warpAffine(img, M, (w, h))
        else:  # 透视变换
            M = cv2.getPerspectiveTransform(rect1, rect2)
            return cv2.warpPerspective(img, M, (w, h))

    def get_img_codes(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray = cv2.adaptiveThreshold(~gray, 1, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 15, -10)
        contours, _ = cv2.findContours(gray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        contours.sort(key=lambda c: cv2.contourArea(c), reverse=True)
        if not contours:
            return ''
        # cv2.drawContours(img, contours, -1, (255, 0, 0), 2)
        code_img = None
        for c in contours:
            x, y, w, h = cv2.boundingRect(c)
            if 0.9 < w/h < 1.1 and w > 100:
                code_img = img[y:y + h, x:x + w]
                code_gray = gray[y:y+h, x:x + w]
                c1, _ = cv2.findContours(code_gray, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
                is_start_white = True
                for cc in c1:
                    arclen = cv2.arcLength(cc, True)
                    epsilon = max(3, int(arclen * 0.02))
                    approx = cv2.approxPolyDP(cc, epsilon, True)
                    area = cv2.contourArea(cc)
                    if 0.3 < area/w/h < 0.99 and approx.shape[0] == 4:
                        if not is_start_white:
                            is_start_white = True
                            continue
                        pts = [approx[i][0] for i in range(4)]
                        pts.sort(key=np.sum)
                        if pts[1][0] < pts[1][-1]:
                            pts[1], pts[2] = pts[2], pts[1]
                        pts1 = np.float32(pts)
                        x0, y0, x1, y1 = min(pts1[:, 0]), min(pts1[:, -1]), max(pts1[:, 0]), max(pts1[:, -1])
                        pts2 = np.float32([[x0, y0], [x1, y0], [x0, y1], [x1, y1]])
                        code_img = self.transfor_image(code_img, pts1, pts2)
                        cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 2)
                        break
                break
        if code_img is None:
            return ''
        gray = cv2.cvtColor(code_img, cv2.COLOR_BGR2GRAY)
        gray = np.where(gray > 125, 255, 0)
        x_shadow = np.sum(gray, axis=0)
        y_shadow = np.sum(gray, axis=1)
        x_black = np.where(x_shadow < x_shadow.max(initial=None)/20)[0]
        y_black = np.where(y_shadow < y_shadow.max(initial=None)/20)[0]
        if len(x_black) < 2 or len(y_black) < 2:
            return ''
        gray[:, :x_black[0]+2] = gray[:, x_black[-1]-2:] = gray[:y_black[0]+2, :] = gray[y_black[-1]-2:, :] = 0
        x_shadow = np.sum(gray, axis=0)
        y_shadow = np.sum(gray, axis=1)
        x_white = np.where(x_shadow >= x_shadow.max(initial=None)*0.99)[0]
        y_white = np.where(y_shadow >= y_shadow.max(initial=None)*0.99)[0]
        gapx = len(x_white) // 2
        gapy = len(y_white) // 2
        real_code = gray[y_white[0]+gapy: y_white[-1]-gapy+1, x_white[0]+gapx: x_white[-1]-gapx+1]
        if len(real_code) <= gapx or len(real_code[0]) <= gapy or gapx <= 0 or gapy <= 0 or np.all(real_code==255) or np.all(real_code==0):
            return ''
        x_slice = self._get_splits(real_code, gapx)
        y_slice = self._get_splits(real_code.T, gapy)
        x_sections = [[x_slice[i], x_slice[i + 1]] for i in range(len(x_slice) - 1)]
        y_sections = [[y_slice[i], y_slice[i + 1]] for i in range(len(y_slice) - 1)]
        res = []
        for i in y_sections:
            row = []
            for j in x_sections:
                pix = real_code[i[0]:i[-1], j[0]:j[-1]]
                row.append(1 if np.average(pix) > 125 else 0)
            res.append(row)
        res = ''.join([str(k) for r in res for k in r])
        return self.decode(res)

    def cat(self, img):
        plt.imshow(img)
        plt.show()


if __name__ == '__main__':
    t = Translator(1000, 20)
    t.file_to_video('../Dockerfile_cpu', '../data_result/b.avi')
    res = t.live_to_file('../data_result/b.avi')  # '../data_result/a.avi'
    pat = re.search(r's+tart(.*)end+', res)
    if pat:
        data = t.base64_to_data(bytes(pat.group(1), encoding='utf-8'))
        with open('../data_result/a.txt', 'wb') as f:
            f.write(data)
    print('')

