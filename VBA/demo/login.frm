VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} 系统登录 
   Caption         =   "Login"
   ClientHeight    =   5892
   ClientLeft      =   100
   ClientTop       =   460
   ClientWidth     =   8960.001
   OleObjectBlob   =   "login.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "系统登录"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'点击登陆按钮===========================================================
Private Sub LoginBtn_Click()
If UserNameBox.Text = "" Or PassWordBox.Text = "" Then
     MsgBox "请填写齐全！", 1 + 64, "系统登录"
     UserNameBox.SetFocus
Else
     If gotPassWordFromUserName(UserNameBox.Text) = PassWordBox.Text Then
     Unload Me
     MsgBox UserNameBox.Text & "你好！欢迎你进入本系统。", 1 + 64, "欢迎界面"
     Application.Visible = True
     ActiveWorkbook.Author = "Super"
     ActiveWorkbook.Unprotect Password:="521sfiq"
     Sheets("LOVE").Visible = True
     Sheets("LOVE").Activate
     ActiveWorkbook.Protect Password:="521sfiq"
Else
     MsgBox "对不起登录密码错误，请重新输入！"
     
 End If
 End If
End Sub
'点击退出按钮===========================================================
Private Sub LogoutBtn_Click()
     Unload Me
     Application.Visible = True
     ActiveWorkbook.Close savechanges:=False
     ThisWorkbook.Close False
End Sub
'点击重置按钮===========================================================
Private Sub ResetBtn_Click()
UserNameBox = ""
PassWordBox = ""
VerificationBox = ""
End Sub
'窗体初始化============================================================
Private Sub UserForm_Initialize()
     Dim x As Integer, Y As Integer
     x = Sheets("LOVE").Range("A65536").End(xlUp).Row
     UserNameBox.AddItem "Luna"
     UserNameBox.AddItem "Super"
     UserNameBox.AddItem "123456"
     gotVerificationCode
End Sub
Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
     If CloseMode = 0 Then Cancel = 1
End Sub
'生成验证码==============================================================
Sub gotVerificationCode()
Code = Int(Rnd() * 9000 + 1000)
VerificationLabel.Caption = Code
End Sub

Private Sub UserNameBox_Change()

End Sub

'点击验证码则重新获取验证码===============================================
Private Sub VerificationLabel_Click()
gotVerificationCode
End Sub
