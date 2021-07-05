import win32com.client
import time
def excel_VBA():
    xls=win32com.client.Dispatch('Excel.Application')
    xls.Workbooks.Open(r'C:\Users\asus\Desktop\Test.xlsm')
    args = ('陈祉希',20)
    ret = xls.Application.Run("VBASUBTest", '陈祉希',20).upper()
    print(ret)
    xls.DisplayAlerts = 0
    # xls.Application.save()
    xls.Application.Quit()
def hello(name):
    return "Hello, " + name + "!"
if __name__ == '__main__':
    excel_VBA()
    print(hello("World"))
    # 延时关闭windows控制台，使得用户可以看到运行结果
    time.sleep(150)