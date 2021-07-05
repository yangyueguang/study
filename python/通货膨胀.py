import os
import sys
print('贷款30年翻倍')
a = 1.06
sum = 0
for i in range(30):
    sum += a ** i
print(sum)  # 40.55

print('通货膨胀率，十年前1块等于现在多少钱')
a = 1.1748
sum = a ** 10
print(sum)

print('贷款140万，每个月还8500，每年还102000，还30年')
a = 1.06
sum = 0
res = 0
for i in range(30):
    sum += (8500 * 12) * (a ** i)
res = 1400000 * (a ** 30)
print(sum)
print(res)

print('十年前的1块相放现在还剩多少钱')
a = 0.8517
sum = a ** 10
print(sum)

print('现在定期存款两年以上年利率约为2%')
b = 1.02
sum = b ** 10
print(sum)

print('存款的通胀情况')
sum = (a*b) ** 10
print(a*b)
print(sum)
