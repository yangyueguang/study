import pytesseract
from PIL import Image

# 图片降噪处理 standard:阀值
def convert_Image(img, standard=127.5):
    image = img.convert('L')
    pixels = image.load()
    for x in range(image.width):
        for y in range(image.height):
            if pixels[x, y] > standard:
                pixels[x, y] = 255
            else:
                pixels[x, y] = 0
    image.show()
    return image

def main():
    base_img = Image.open('vcode.jpg')
    img = convert_Image(base_img)
    num_conf = '--psm 6 --oem 3 -c tessedit_char_whitelist=0123456789'
    str_conf = ''
    textCode = pytesseract.image_to_string(img, lang='eng', config=str_conf)
    print('识别的结果：', textCode)

if __name__ == '__main__':
    main()
