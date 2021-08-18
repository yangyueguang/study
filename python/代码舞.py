from img import Image

ascil_char = list("$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'. ")
table = ('#8XOHLTI)i=+;:,. ')  # 对于灰度图像效果不错
img = image.open("img\zyh.jpg")
if img.mode != "L":  # 如果不是灰度图像，转换为灰度图像
    im = img.convert("L")
a = img.size[0]
b = img.size[1]
img = img.resize((100, 90))  # 转换图像大小，这个大小是我随意设置的
f = open("img.txt", 'w+')  # 目标文本文件

for i in range(1, b, 2):
    line = ('')
    for j in range(a):
        line += table[int((float(im.getpixel((j, i))) / 256.0) * len(table))]
    line += ("\n")
    f.write(line)
f.close()