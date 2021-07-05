Option Explicit
Sub NowToolbar()
    Dim arr As Variant
    Dim id As Variant
    Dim i As Integer
    Dim Toolbar As CommandBar
    On Error Resume Next
    Application.CommandBars("MyToolbar").Delete
    arr = Array("会计凭证", "会计账簿", "会计报表", "凭证打印", "账簿打印", "报表打印")
    id = Array(9893, 284, 9590, 9614, 707, 986)
    Dim myDropdown As Object
    Dim myCap As Variant
    myCap = Array("基础应用", "VBA程序开发", "函数与公式")
     With Application.CommandBars("Formatting").Controls(1)
        If .Caption = "请选择版块" Then .Delete
    End With
    Set myDropdown = Application.CommandBars("Formatting").Controls.Add(Type:=msoControlDropdown, Before:=1)
    With myDropdown
        .Caption = "请选择版块"
        .OnAction = "myOnA"
        .Style = msoComboNormal
        For i = 0 To UBound(myCap)
            .AddItem myCap(i)
        Next
        .ListIndex = 1
    End With
    i = 0
    Set Toolbar = Application.CommandBars.Add("MyToolbar", msoBarTop)
        With Toolbar
            .Protection = msoBarNoResize
            .Visible = True
            For i = 0 To 5
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = arr(i)
                    .FaceId = id(i)
                    .BeginGroup = True
                    .Style = msoButtonIconAndCaptionBelow
                End With
            Next
        End With
    Set Toolbar = Nothing
    AddNowBar
    observeDeleteSheet
End Sub

Sub AddNowBar()
    Dim NewBar As CommandBar
    On Error Resume Next
    With Application
        .CommandBars("Standard").Visible = False
        .CommandBars("Formatting").Visible = True
        .CommandBars("Stop Recording").Visible = False
        .CommandBars("toolbar list").Enabled = False
        .CommandBars.DisableAskAQuestionDropdown = True
        .DisplayFormulaBar = False
        .CommandBars("NewBar").Delete
    End With
    Set NewBar = Application.CommandBars.Add(name:="NewBar", Position:=msoBarTop, MenuBar:=True, Temporary:=True)
    With NewBar
        .Visible = True
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "系统设置(&X)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "保存(&S)"
                .BeginGroup = True
                .FaceId = 1975
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "备份(&B)"
                .BeginGroup = True
                .OnAction = "myOnA"
                .FaceId = 747
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计凭证(&P)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "录入(&L)"
                .BeginGroup = True
                .FaceId = 197
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "审核(&S)"
                .BeginGroup = True
                .FaceId = 714
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计账簿(&Z)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "记账(&L)"
                .BeginGroup = True
                .FaceId = 65
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "结账(&S)"
                .BeginGroup = True
                .FaceId = 47
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计报表(&B)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlPopup)
                .Caption = "资产负债表(&Y)"
                .BeginGroup = True
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "月报(&M)"
                    .BeginGroup = True
                    .FaceId = 1180
                End With
                    With .Controls.Add(Type:=msoControlButton)
                        .Caption = "年报(&Y)"
                        .BeginGroup = True
                        .FaceId = 1188
                    End With
                End With
            With .Controls.Add(Type:=msoControlPopup)
                .Caption = "损益表(&S)"
                .BeginGroup = True
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "月报(&M)"
                    .BeginGroup = True
                    .FaceId = 1180
                End With
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "年报(&Y)"
                    .BeginGroup = True
                    .FaceId = 1188
                End With
            End With
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "退出系统(&C)"
            .BeginGroup = True
            .Style = msoButtonCaption
            .OnAction = "myNetworkTest"
        End With
    End With
    Set NewBar = Nothing
End Sub

'加载自定义图标的工具栏和隐藏 前提是把自定义图标文件放在对用的目录下，这个代码写的是当前文件目录
Sub AddCustomButton()
    Dim xBar As CommandBar
    Dim xButton As CommandBarButton
    On Error Resume Next
    Application.CommandBars("CustomBar").Delete
    Set xBar = CommandBars.Add("CustomBar", msoBarTop)
    Set xButton = xBar.Controls.Add(msoControlButton)
    With xButton
        .Picture = LoadPicture(ThisWorkbook.Path & "\P.BMP")
        .Mask = LoadPicture(ThisWorkbook.Path & "\M.BMP")
        .TooltipText = "Excel Home 论坛"
    End With
    xBar.Visible = True
    Set xBar = Nothing
    Set xButton = Nothing
End Sub
Sub DeleteCustomButton()
    On Error Resume Next
    Application.CommandBars("CustomBar").Delete
End Sub

'展示自定义工具栏和隐藏自定义工具栏
Sub hidCustomToolsBar()
    Dim Cmd As CommandBar
    For Each Cmd In Application.CommandBars
        Cmd.Enabled = False
    Next
End Sub

Sub showCustomToolsBar()
    Dim Cmd As CommandBar
    For Each Cmd In Application.CommandBars
        Cmd.Enabled = True
    Next
End Sub

Private Sub observeDeleteSheet()
Dim Ctl As CommandBarControl
Set Ctl = Application.CommandBars.FindControl(id:=847)
    Ctl.OnAction = "MyDelSht"
End Sub

Sub MyDelSht()
    If VBA.UCase$(ActiveSheet.CodeName) = "Sheet1" Then
        MsgBox "禁止删除" & ActiveSheet.name & "工作表!"
    Else
        ActiveSheet.Delete
    End If
End Sub

'项目关闭记得删除自定义增加的工具栏按钮==========================================================
Sub DeleteToolbar()
    On Error Resume Next
    Application.CommandBars("MyToolbar").Delete
    With Application.CommandBars("Formatting").Controls(1)
        If .Caption = "请选择版块" Then .Delete
    End With
    With Application
        .CommandBars("Standard").Visible = True
        .CommandBars("Formatting").Visible = True
        .CommandBars("Stop Recording").Visible = True
        .CommandBars("toolbar list").Enabled = True
        .CommandBars.DisableAskAQuestionDropdown = False
        .DisplayFormulaBar = True
        .CommandBars("NewBar").Delete
    End With
End Sub

'自定义测试私有函数==============================================================================
Sub myOnA()
    Dim myList As Byte
    myList = Application.CommandBars("Formatting").Controls(1).ListIndex
    ActiveWorkbook.FollowHyperlink Address:="http://club.excelhome.net/forum-" & myList & "-1.html", NewWindow:=True
End Sub
Sub myNetworkTest()
Debug.Print ("开始网络测试了")
XNetManager.testVBA
End Sub

Private Sub UserForm_Initialize()
    Dim Itm As ListItem
    Dim r As Integer
    Dim c As Integer
    Dim Img As ListImage
    With ListView1
        .ColumnHeaders.Add , , "人员编号 ", 50, 0
        .ColumnHeaders.Add , , "技能工资 ", 50, 1
        .ColumnHeaders.Add , , "岗位工资 ", 50, 1
        .ColumnHeaders.Add , , "工龄工资 ", 50, 1
        .ColumnHeaders.Add , , "浮动工资 ", 50, 1
        .ColumnHeaders.Add , , "其他  ", 50, 1
        .ColumnHeaders.Add , , "应发合计", 50, 1
        .View = lvwReport
        .Gridlines = True
        .FullRowSelect = True
        Set Img = ImageList1.ListImages.Add(, , LoadPicture(ThisWorkbook.Path & "\" & "1×25.bmp"))
        .SmallIcons = ImageList1
        For r = 2 To Sheet1.[A65536].End(xlUp).Row - 1
            Set Itm = .ListItems.Add()
            Itm.Text = Space(2) & Sheet1.Cells(r, 1)
            For c = 1 To 6
                Itm.SubItems(c) = Format(Sheet1.Cells(r, c + 1), "##,#,0.00")
            Next
        Next
    End With
    Set Itm = Nothing
    Set Img = Nothing
End Sub

Private Sub CommandButton1_Click()
    Dim i As Integer
    UserForm1.Show 0
    With UserForm1.ProgressBar1
        .Min = 1
        .Max = 10000
        .Scrolling = 0
        For i = 1 To 10000
            Cells(i, 1) = i
            .Value = i
            UserForm1.Caption = "正在运行,已完成" & i / 100 & "%,请稍候!"
        Next
    End With
    Unload UserForm1
    Columns(1).ClearContents
End Sub

Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function SetMenu Lib "user32" (ByVal hwnd As Long, ByVal hMenu As Long) As Long
Private Declare Function CreateMenu Lib "user32" () As Long
Private Declare Function AppendMenu Lib "user32" Alias "AppendMenuA" (ByVal hMenu As Long, ByVal wFlags As Long, ByVal wIDNewItem As Long, ByVal lpNewItem As Any) As Long
Private Declare Function DestroyMenu Lib "user32" (ByVal hMenu As Long) As Long
Private Declare Function CreatePopupMenu Lib "user32" () As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Const GWL_WNDPROC = (-4)
Private Const MF_STRING = &H0&
Private Const MF_POPUP = &H10&
Private Const MF_SEPARATOR = &H800&
Dim MenuWnd As Long, Dump As Long, PopupMenuID As Long, PopupMenuWnd As Long, MenuID As Long
Private Sub TextBox1_Change()
    StatusBar1.Panels(1).Text = "正在录入:" & TextBox1.Text
End Sub

Private Sub Toolbar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Index
        Case 2
            MsgBox "录入"
        Case 3
            MsgBox "审核"
        Case 4
            MsgBox "记账"
        Case 5
            MsgBox "结账"
        Case 6
            MsgBox "资产负债表"
        Case 7
            MsgBox "损益表"
    End Select
End Sub

Private Sub UserForm_Initialize()
    If Val(Application.Version) < 9 Then
        hwnd = FindWindow("ThunderXFrame", Me.Caption)
    Else
        hwnd = FindWindow("ThunderDFrame", Me.Caption)
    End If
    MenuWnd = CreateMenu()
    PopupMenuID = CreatePopupMenu()
    Dump = AppendMenu(MenuWnd, MF_STRING + MF_POPUP, PopupMenuID, "系统设置(&X)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 100, "保存(&S)...")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 101, "备份(&E)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 102, "退出(&X)")
    PopupMenuID = CreatePopupMenu()
    Dump = AppendMenu(MenuWnd, MF_STRING + MF_POPUP, PopupMenuID, "会计凭证(&P)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 110, "录入(&L)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 111, "审核(&C)")
    PopupMenuID = CreatePopupMenu()
    Dump = AppendMenu(MenuWnd, MF_STRING + MF_POPUP, PopupMenuID, "会计账簿(&Z)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 112, "记账(&T)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 113, "结账(&J)")
    PopupMenuID = CreatePopupMenu()
    Dump = AppendMenu(MenuWnd, MF_STRING + MF_POPUP, PopupMenuID, "会计报表(&B)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 114, "资产负债表(&F)")
    Dump = AppendMenu(PopupMenuID, MF_STRING, 115, "损益表(&Y)")
    Dump = SetMenu(hwnd, MenuWnd)
    PreWinProc = GetWindowLong(hwnd, GWL_WNDPROC)
    SetWindowLong hwnd, GWL_WNDPROC, AddressOf MsgProcess
    Dim arr As Variant
    Dim i As Byte
    arr = Array(" 录入 ", " 审核", " 记账 ", " 结账 ", "负债表", "损益表")
    With Toolbar1
        .ImageList = ImageList1
        .Appearance = ccFlat
        .BorderStyle = ccNone
        .TextAlignment = tbrTextAlignBottom
        With .Buttons
            .Add(1, , "").Style = tbrPlaceholder
            For i = 0 To UBound(arr)
                .Add(i + 2, , , , i + 1).Caption = arr(i)
            Next
        End With
    End With
    arr = Array(0, 6, 5)
    With StatusBar1
        .Width = Me.Width - 10
        For i = 1 To 3
            .Panels.Add(i, , "").Style = arr(i - 1)
        Next
        .Panels(1).Text = "准备就绪!"
        .Panels(2).Width = 60
        .Panels(3).Width = 75
        .Panels(1).Width = Me.Width - .Panels(1).Width - .Panels(2).Width
        .Panels(3).Picture = LoadPicture(ThisWorkbook.Path & "\123.BMP")
        For i = 0 To 2
            .Panels(i + 1).Alignment = i
        Next
    End With
End Sub

Private Sub UserForm_Terminate()
    DestroyMenu MenuWnd
    DestroyMenu PopupMenuID
    DestroyMenu PopupMenuWnd
    SetWindowLong hwnd, GWL_WNDPROC, PreWinProc
End Sub

Private ActiveTB As MSForms.TextBox
Public Sub CreateShortCutMenu()
    Dim ShortCutMenu As CommandBar
    Dim ShortCutMenuItem As CommandBarButton
    Dim sCaption As Variant
    Dim iFaceId As Variant
    Dim sAction As Variant
    Dim i As Integer
    sCaption = Array("剪切(&C)", "复制(&T)", "贴粘(&P)", "删除(&D)")
    iFaceId = Array(21, 19, 22, 1786)
    sAction = Array("Action_Cut", "Action_Copy", "Action_Paste", "Action_Delete")
    On Error Resume Next
    Application.CommandBars("ShortCut").Delete
    Set ShortCutMenu = Application.CommandBars.Add("ShortCut", msoBarPopup)
    With ShortCutMenu
        For i = 0 To 3
            Set ShortCutMenuItem = .Controls.Add(msoControlButton)
            With ShortCutMenuItem
                .Caption = sCaption(i)
                .faceID = Val(iFaceId(i))
                .OnAction = sAction(i)
            End With
        Next
    End With
End Sub

Public Sub ShowPopupMenu(txtCtr As MSForms.TextBox)
    Dim Action As Variant
    Set ActiveTB = txtCtr
    With Application.CommandBars("ShortCut")
        .Controls(1).Enabled = txtCtr.SelLength > 0
        .Controls(2).Enabled = .Controls(1).Enabled
        .Controls(3).Enabled = txtCtr.CanPaste
        .Controls(4).Enabled = .Controls(1).Enabled
        .ShowPopup
    End With
End Sub

Private Sub TextBox1_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    With TextBox1
        If Len(Trim(.Value)) > 0 Then
            If KeyCode = vbKeyReturn Then
                Sheet1.Range("A65536").End(xlUp).Offset(1, 0) = .Value
                .Text = ""
            End If
        End If
    End With
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode <> 1 Then
        Cancel = True
        MsgBox "请点击按钮关闭窗体!"
    End If
End Sub

Private Sub CommandButton1_Click()
    Dim myForm As VBComponent
    Dim myTextBox As Control
    Dim myButton As Control
    Dim i As Integer
    Set myForm = ThisWorkbook.VBProject.VBComponents.Add(vbext_ct_MSForm)
    With myForm
        .Properties("Name") = "Formtest"
        .Properties("Caption") = "演示窗体"
        .Properties("Height") = "180"
        .Properties("Width") = "240"
        Set myTextBox = .Designer.Controls.Add("Forms.CommandButton.1")
        With myTextBox
            .Name = "myTextBox"
            .Caption = "新建文本框"
            .Top = 40
            .Left = 138
            .Height = 20
            .Width = 70
        End With
        Set myButton = .Designer.Controls.Add("Forms.CommandButton.1")
        With myButton
            .Name = "myButton"
            .Caption = "删除文本框"
            .Top = 70
            .Left = 138
            .Height = 20
            .Width = 70
        End With
        With .CodeModule
            i = .CreateEventProc("Click", "myTextBox")
            .ReplaceLine i + 1, Space(4) & "Dim myTextBox As Control" & Chr(10) & Space(4) & "Dim i As Integer" & Chr(10) & Space(4) & "Dim k As Integer" _
                & Chr(10) & Space(4) & "k = 10" & Chr(10) & Space(4) & "For i = 1 To 5" & Chr(10) & Space(8) & "Set myTextBox = Me.Controls.Add(bstrprogid:=""Forms.TextBox.1"")" _
                & Chr(10) & Space(8) & "With myTextBox" & Chr(10) & Space(12) & ".Name = ""myTextBox"" & i" & Chr(10) & Space(12) & ".Left = 20" _
                & Chr(10) & Space(12) & ".Top = k" & Chr(10) & Space(12) & ".Height = 18" & Chr(10) & Space(12) & ".Width = 80" _
                & Chr(10) & Space(12) & "k = .Top + 28" & Chr(10) & Space(8) & "End With" & Chr(10) & Space(4) & "Next"
            i = .CreateEventProc("Click", "myButton")
            .ReplaceLine i + 1, Space(4) & "Dim i As Integer" & Chr(10) & Space(4) & "On Error Resume Next" & Chr(10) & Space(4) & "For i = 1 To 5" & Chr(10) & Space(8) & "Formtest.Controls.Remove ""myTextBox"" & i" & Chr(10) & Space(4) & "Next"
        End With
    End With
End Sub

Sub rngSum()
    Dim rng As Range
    Dim d As Double
    Set rng = Range("A1:F7")
    d = Application.WorksheetFunction.Sum(rng)
    MsgBox rng.Address(0, 0) & "单元格的和为" & d
End Sub

Sub seeks()
    Dim rng As Range
    Dim myRng As Range
    Dim k1 As Integer, k2 As Integer
    Dim max As Double, min As Double
    Set myRng = Sheet1.Range("A1:F30")
    For Each rng In myRng
        If rng.Value = WorksheetFunction.max(myRng) Then
            rng.Interior.ColorIndex = 3
            k1 = k1 + 1
            max = rng.Value
        ElseIf rng.Value = WorksheetFunction.min(myRng) Then
            rng.Interior.ColorIndex = 5
            k2 = k2 + 1
            min = rng.Value
        Else
            rng.Interior.ColorIndex = 0
        End If
    Next
    MsgBox "最大值是：" & max & " ，共有 " & k1 & "个。" & Chr(13) & "最小值是：" & min & " ，共有 " & k2 & "个。"
End Sub

Private Sub CommandButton读Word表_Click()
    Dim 当前路径, 文件名, 表名
    Dim i%, j%, k%, r%, c%, m%, cend%
    Dim mWord As New Word.Application
    Dim mDoc As Word.Document 'WORD文档
    Dim mTab As Word.Table 'WORD表格
    cend = Range("iv10").End(xlToLeft).Column '字段名长度
    rend = Range("b65536").End(xlUp).Row
    Range(Cells(11, 1), Cells(rend, cend)).ClearContents
    当前路径 = ThisWorkbook.Path
    文件名 = Dir(当前路径 & "\" & "*.doc") '获得第一个WORD文档文件名
    k = 1
    r = 10 '存放数据的行号
    Cells(r, 1) = "序号"
    Do While 文件名 <> ""
    ' On Error Resume Next
        Set mDoc = mWord.Documents.Open(当前路径 & "\" & 文件名) '打开这个文档
        Set mTab = mDoc.Tables(1) '指向第一张WORD表格
        r = r + 1 '指向下一行
        Cells(r, 1) = k '序号
        For c = 2 To cend '按照字段名长度
            i = Mid(Cells(9, c), 1, Application.Find(",", Cells(9, c)) - 1)
            j = Mid(Cells(9, c), Application.Find(",", Cells(9, c)) + 1, Application.Find(",", Cells(9, c)) - 1)
            Cells(r, c) = Replace(mTab.Cell(i, j).Range.Text, Chr$(13) & Chr$(7), "") '获得字段值
        Next
        k = k + 1
        mDoc.Close False '关闭这个WORD 文档
        文件名 = Dir '再次获得下个WORD文档
    Loop
    mWord.Quit '退出WORD
    Set mTab = Nothing
    Set mDoc = Nothing
    Set mWord = Nothing
End Sub

Private Sub CommandButton读Word表_Click()
    Dim 当前路径, 文件名, 表名
    Dim i%, j%, k%, r%, c%
    Dim mWord As New Word.Application
    Dim mDoc As Word.Document 'WORD文档
    Dim mTab As Word.Table 'WORD表格
    Range("c10").CurrentRegion.ClearContents
    当前路径 = ThisWorkbook.Path
    文件名 = Dir(当前路径 & "\" & "*.doc") '获得第一个WORD文档文件名
    k = 0
    c = 2 '存放数据的列号
    r = 10 '存放数据的行号
    Do While 文件名 <> ""
    ' On Error Resume Next
        Set mDoc = mWord.Documents.Open(当前路径 & "\" & 文件名) '打开这个文档
        Set mTab = mDoc.Tables(1) '指向第一张WORD表格
        If k = 0 Then '标题栏
            Cells(r, c) = "序号"
            c = 3
            For i = 1 To mTab.Rows.Count Step 2 '按照WORD表格行数步长为2
                For j = 1 To mTab.Rows(i).Range.Cells.Count  '按照WORD 表格某行的列数
                    Cells(r, c) = Replace(mTab.Cell(i, j).Range.Text, Chr$(13) & Chr$(7), "") '获得字段名
                    c = c + 1
                Next
            Next
            r = r + 1 '指向下一行
            c = 2
            k = k + 1
        End If
        Cells(r, c) = k
        c = 3
        For i = 2 To mTab.Rows.Count Step 2
            For j = 1 To mTab.Rows(i).Range.Cells.Count
                Cells(r, c) = Replace(mTab.Cell(i, j).Range.Text, Chr$(13) & Chr$(7), "") '获得字段值
                c = c + 1
            Next
        Next
        r = r + 1
        k = k + 1
        c = 2
        mDoc.Close False '关闭这个WORD 文档
        文件名 = Dir '再次获得下个WORD文档
    Loop
    mWord.Quit '退出WORD
    Set mTab = Nothing
    Set mDoc = Nothing
    Set mWord = Nothing
End Sub



Private Sub CommandButton1_Click()
    Application.Visible = True
    Unload Me
End Sub

'加载宏才运行'
Private Sub Workbook_Open()
    ThisWorkbook.IsAddin = True
    UserForm1.Show
End Sub

Private Sub Workbook_Open()
    Application.OnKey "^{c}", "myOnKey"
End Sub

Private Sub Workbook_Deactivate()
    Application.OnKey "^{c}"
End Sub

Sub myStatusBar()
    Dim rng As Range
    For Each rng In Sheet1.Range("A1:D10000")
        Application.StatusBar = "正在计算单元格 " & rng.Address(0, 0) & " 的数据..."
        rng = 100
    Next
    Application.StatusBar = False
End Sub


Private Sub Workbook_BeforeClose(Cancel As Boolean)
    Dim iMsg As Integer
    iMsg = MsgBox("文件即将关闭,是否保存?", 3 + 32)
    Select Case iMsg
        Case 6
            Me.Save
        Case 7
            Me.Saved = True
        Case 2
            Cancel = True
    End Select
End Sub

Sub RngInput()
    Dim rng As Range
    On Error GoTo line
    Set rng = Application.InputBox("请使用鼠标选择单元格区域：", , , , , , , 8)
    rng.Interior.ColorIndex = 15
line:
End Sub


Sub dInput()
    Dim dInput As Double
    Dim r As Integer
    r = Sheet1.Range("A65536").End(xlUp).Row
    Password = InputBox("请输入密码：", "密码")
    dInput = Application.InputBox(Prompt:="请输入数字：", Type:=1)
    If dInput <> False Then
        Sheet1.Cells(r + 1, 1).Value = dInput
    Else
        MsgBox "你已取消了输入!"
    End If
End Sub

Sub DialogOpen()
    Application.Dialogs(xlDialogOpen).Show arg1:=ThisWorkbook.Path & "\*.xls"
End Sub

Sub OpenFilename()
    Dim Filename As Variant
    Dim mymsg As Integer
    Dim i As Integer
    Filename = Application.GetOpenFilename(Title:="删除文件", MultiSelect:=True)
    If IsArray(Filename) Then
        mymsg = MsgBox("是否删除所选文件?", vbYesNo, "提示")
        If mymsg = vbYes Then
            For i = 1 To UBound(Filename)
                Kill Filename(i)
            Next
        End If
    End If
End Sub

Sub CopyFilename()
    Dim NowWorkbook As Workbook
    Dim FileName As String
    On Error GoTo line
    FileName = Application.GetSaveAsFilename _
        (InitialFileName:="D:\" & Date & " " & ThisWorkbook.Name, fileFilter:="Excel files(*.xls),*.xls,All files (*.*),*.*", Title:="数据备份")
    If FileName <> "False" Then
        Set NowWorkbook = Workbooks.Add
        With NowWorkbook
            .SaveAs FileName
            ThisWorkbook.Sheets("Sheet2").UsedRange.Copy _
            .Sheets("Sheet1").Range ("A1")
            .Save
        End With
        GoTo line
    End If
    Exit Sub
line:
    ActiveWorkbook.Close
End Sub

'调用系统的关于对话框'
Private Sub CommandButton1_Click()
    Dim ApphWnd As Long
    ApphWnd = FindWindow("XLMAIN", Application.Caption)
    ShellAbout ApphWnd, "财务处理系统", "yuanzhuping@yeah.net  0513-86548930", 0
End Sub

Private Sub Workbook_Activate()
    Call AddCustomButton
End Sub

Private Sub Workbook_Deactivate()
    Call DelButton
End Sub

Sub AddCustomButton()
    Dim xBar As CommandBar
    Dim xButton As CommandBarButton
    On Error Resume Next
    Application.CommandBars("CustomBar").Delete
    Set xBar = CommandBars.Add("CustomBar", msoBarTop)
    Set xButton = xBar.Controls.Add(msoControlButton)
    With xButton
        .Picture = LoadPicture(ThisWorkbook.Path & "\P.BMP")
        .Mask = LoadPicture(ThisWorkbook.Path & "\M.BMP")
        .TooltipText = "Excel Home 论坛"
    End With
    xBar.Visible = True
    Set xBar = Nothing
    Set xButton = Nothing
End Sub

Sub DelButton()
    On Error Resume Next
    Application.CommandBars("CustomBar").Delete
End Sub

Private Sub Workbook_Open()
    Dim IStyle As Long
    Dim hIcon As Long
    Dim hWndForm As Long
    hWndForm = FindWindow(vbNullString, Application.Caption)
    hIcon = ExtractIcon(0, ActiveWorkbook.Path & "\p.bmp", 0)
    SendMessage hWndForm, WM_SETICON, True, hIcon
    SendMessage hWndForm, WM_SETICON, False, hIcon
End Sub

Sub myTools()
    Dim myTools As CommandBarPopup
    Dim myCap As Variant
    Dim myid As Variant
    Dim i As Byte
    myCap = Array("基础应用", "VBA程序开发", "函数与公式", "图表与图形", "数据透视表")
    myid = Array(281, 283, 285, 287, 292)
    With Application.CommandBars("Worksheet menu bar")
        .Reset
        Set myTools = .Controls("帮助(&H)").Controls.Add(Type:=msoControlPopup, Before:=1)
        With myTools
            .Caption = "Excel Home 技术论坛"
            .BeginGroup = True
            For i = 1 To 5
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = myCap(i - 1)
                    .FaceId = myid(i - 1)
                    .OnAction = "myC"
            End With
            Next
        End With
    End With
    Set myTools = Nothing
End Sub

Public Sub myC()
    MsgBox "您选择了： " & Application.CommandBars.ActionControl.Caption
End Sub

Sub DelmyTools()
    Application.CommandBars("Worksheet menu bar").Reset
End Sub

Private Sub Workbook_Activate()
    Call AddNewMenu
End Sub

Private Sub Workbook_Deactivate()
    Call DelNewMenu
End Sub

Sub AddNewMenu()
    Dim HelpMenu As CommandBarControl
    Dim NewMenu As CommandBarPopup
    With Application.CommandBars("Worksheet menu bar")
        .Reset
        Set HelpMenu = .FindControl(ID:=.Controls("帮助(&H)").ID)
        If HelpMenu Is Nothing Then
            Set NewMenu = .Controls.Add(Type:=msoControlPopup)
        Else
            Set NewMenu = .Controls.Add(Type:=msoControlPopup, _
                Before:=HelpMenu.Index)
        End If
        With NewMenu
            .Caption = "统计(&S)"
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "输入数据(&D)"
                .FaceId = 162
                .OnAction = ""
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "汇总数据(&T)"
                .FaceId = 590
                .OnAction = ""
            End With
        End With
    End With
    Set HelpMenu = Nothing
    Set NewMenu = Nothing
End Sub

Sub DelNewMenu()
    Application.CommandBars("Worksheet menu bar").Reset
End Sub

Sub Shibar()
    With Application.CommandBars("Worksheet menu bar")
        .Reset
        .Controls("工具(&T)").Controls("宏(&M)").Enabled = False
        .Controls("数据(&D)").Delete
    End With
End Sub

Sub Resbar()
    Application.CommandBars("Worksheet menu bar").Reset
End Sub

Dim WithEvents Saveas As CommandBarButton
Private Sub Workbook_Open()
    Set Saveas = Application.CommandBars("File").Controls("另存为(&A)...")
End Sub

Private Sub Saveas_Click(ByVal Ctrl As Office.CommandBarButton, CancelDefault As Boolean)
    CancelDefault = True
    MsgBox "本工作簿禁止另存!"
End Sub

'定制自己的系统菜单'
Option Explicit
Sub AddNowBar()
    Dim NewBar As CommandBar
    On Error Resume Next
    With Application
        .CommandBars("Standard").Visible = False
        .CommandBars("Formatting").Visible = False
        .CommandBars("Stop Recording").Visible = False
        .CommandBars("toolbar list").Enabled = False
        .CommandBars.DisableAskAQuestionDropdown = True
        .DisplayFormulaBar = False
        .CommandBars("NewBar").Delete
    End With
    Set NewBar = Application.CommandBars.Add(Name:="NewBar", Position:=msoBarTop, MenuBar:=True, Temporary:=True)
    With NewBar
        .Visible = True
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "系统设置(&X)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "保存(&S)"
                .BeginGroup = True
                .FaceId = 1975
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "备份(&B)"
                .BeginGroup = True
                .FaceId = 747
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计凭证(&P)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "录入(&L)"
                .BeginGroup = True
                .FaceId = 197
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "审核(&S)"
                .BeginGroup = True
                .FaceId = 714
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计账簿(&Z)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "记账(&L)"
                .BeginGroup = True
                .FaceId = 65
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "结账(&S)"
                .BeginGroup = True
                .FaceId = 47
            End With
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计报表(&B)"
            .BeginGroup = True
            With .Controls.Add(Type:=msoControlPopup)
                .Caption = "资产负债表(&Y)"
                .BeginGroup = True
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "月报(&M)"
                    .BeginGroup = True
                    .FaceId = 1180
                End With
                    With .Controls.Add(Type:=msoControlButton)
                        .Caption = "年报(&Y)"
                        .BeginGroup = True
                        .FaceId = 1188
                    End With
                End With
            With .Controls.Add(Type:=msoControlPopup)
                .Caption = "损益表(&S)"
                .BeginGroup = True
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "月报(&M)"
                    .BeginGroup = True
                    .FaceId = 1180
                End With
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = "年报(&Y)"
                    .BeginGroup = True
                    .FaceId = 1188
                End With
            End With
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "退出系统(&C)"
            .BeginGroup = True
            .Style = msoButtonCaption
        End With
    End With
    Set NewBar = Nothing
End Sub

Sub DelNowBar()
    On Error Resume Next
    With Application
        .CommandBars("Standard").Visible = True
        .CommandBars("Formatting").Visible = True
        .CommandBars("Stop Recording").Visible = True
        .CommandBars("toolbar list").Enabled = True
        .CommandBars.DisableAskAQuestionDropdown = False
        .DisplayFormulaBar = True
        .CommandBars("NewBar").Delete
    End With
End Sub

'改变菜单按钮图标'
Sub myCbarCnt()
    Dim myCbarCnt As CommandBarControl
    With Sheet1.Shapes.AddShape(17, 1000, 1000, 30, 30)
        .Fill.ForeColor.SchemeColor = 29
        .CopyPicture
        .Delete
    End With
    Set myCbarCnt = Application.CommandBars("Standard").Controls(1)
    myCbarCnt.PasteFace
    Set myCbarCnt = Nothing
End Sub
Sub DelmyCbarCnt()
    Application.CommandBars("Standard").Controls(1).Reset
End Sub

Sub MyCmb()
    Dim MyCmb As CommandBarButton
    With Application.CommandBars("Cell")
        .Reset
        Set MyCmb = .Controls.Add(Type:=msoControlButton, _
            ID:=2521, Before:=.Controls.Count, Temporary:=True)
            MyCmb.BeginGroup = True
        End With
    Set MyCmb = Nothing
End Sub

Sub Mycell()
    With Application.CommandBars.Add("Mycell", msoBarPopup)
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "会计凭证"
            .FaceId = 9893
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "会计账簿"
            .FaceId = 284
        End With
        With .Controls.Add(Type:=msoControlPopup)
            .Caption = "会计报表"
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "月报"
                .FaceId = 9590
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "季报"
                .FaceId = 9591
            End With
            With .Controls.Add(Type:=msoControlButton)
                .Caption = "年报"
                .FaceId = 9592
            End With
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "凭证打印"
            .FaceId = 9614
            .BeginGroup = True
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "账簿打印"
            .FaceId = 707
        End With
        With .Controls.Add(Type:=msoControlButton)
            .Caption = "报表打印"
            .FaceId = 986
        End With
    End With
End Sub

Sub DeleteMycell()
    On Error Resume Next
    Application.CommandBars("Mycell").Delete
End Sub

Sub Mycell()
    Dim arr As Variant
    Dim i As Integer
    Dim Mycell As CommandBar
    On Error Resume Next
    Application.CommandBars("Mycell").Delete
    arr = Array("经理室", "办公室", "生技科", "财务科", "营业部")
    Set Mycell = Application.CommandBars.Add("Mycell", 5)
    For i = 0 To 4
        With Mycell.Controls.Add(1)
            .Caption = arr(i)
            .OnAction = "MyOnAction"
        End With
    Next
End Sub

Sub MyOnAction()
    ActiveCell = Application.CommandBars.ActionControl.Caption
End Sub

Sub DeleteMycell()
    On Error Resume Next
    Application.CommandBars("Mycell").Delete
End Sub

Sub DisBar()
    Dim myBar As CommandBar
    For Each myBar In CommandBars
        If myBar.Type = msoBarTypePopup Then
            myBar.Enabled = False
        End If
    Next
End Sub

Sub EnaBar()
    Dim myBar As CommandBar
    For Each myBar In CommandBars
        If myBar.Type = msoBarTypePopup Then
            myBar.Enabled = True
        End If
    Next
End Sub

'创建自定义工具栏'
Sub NowToolbar()
    Dim arr As Variant
    Dim id As Variant
    Dim i As Integer
    Dim Toolbar As CommandBar
    On Error Resume Next
    Application.CommandBars("MyToolbar").Delete
    arr = Array("会计凭证", "会计账簿", "会计报表", "凭证打印", "账簿打印", "报表打印")
    id = Array(9893, 284, 9590, 9614, 707, 986)
    Set Toolbar = Application.CommandBars.Add("MyToolbar", msoBarTop)
        With Toolbar
            .Protection = msoBarNoResize
            .Visible = True
            For i = 0 To 5
                With .Controls.Add(Type:=msoControlButton)
                    .Caption = arr(i)
                    .FaceId = id(i)
                    .BeginGroup = True
                    .Style = msoButtonIconAndCaptionBelow
                End With
            Next
        End With
    Set Toolbar = Nothing
End Sub

Sub DeleteToolbar()
    On Error Resume Next
    Application.CommandBars("MyToolbar").Delete
End Sub

Private Sub CommandButton1_Click() '移除工作表左上角图标和右上角最小化/最大化/关闭按钮
    ActiveWorkbook.Protect , , True
End Sub

Private Sub CommandButton2_Click() '恢复工作表左上角图标和右上角最小化/最大化/关闭按钮
    ActiveWorkbook.Protect , , False
End Sub

Sub AddDropdown()
    Dim myDropdown As Object
    Dim myCap As Variant
    Dim i As Integer
    myCap = Array("基础应用", "VBA程序开发", "函数与公式")
    Call DeleteButton
    Set myDropdown = Application.CommandBars("Formatting").Controls _
        .Add(Type:=msoControlDropdown, Before:=1)
    With myDropdown
        .Caption = "请选择版块"
        .OnAction = "myOnA"
        .Style = msoComboNormal
        For i = 0 To UBound(myCap)
            .AddItem myCap(i)
        Next
        .ListIndex = 1
    End With
End Sub

Sub DeleteButton()
    With Application.CommandBars("Formatting").Controls(1)
        If .Caption = "请选择版块" Then .Delete
    End With
End Sub

Sub myOnA()
    Dim myList As Byte
    myList = Application.CommandBars("Formatting") _
        .Controls(1).ListIndex
    ActiveWorkbook.FollowHyperlink _
    Address:="http://club.excelhome.net/forum-" & myList & "-1.html", NewWindow:=True
End Sub

Sub nCustomize()
    Application.CommandBars.DisableCustomize = True
End Sub

Sub yCustomize()
    Application.CommandBars.DisableCustomize = False
End Sub

'屏蔽所有的命令栏'
Sub Shielding_1()
    Dim i As Integer
    For i = 1 To Application.CommandBars.Count
        Application.CommandBars(i).Enabled = False
    Next
End Sub

Sub Recovery_1()
    Dim i As Integer
    For i = 1 To Application.CommandBars.Count
        Application.CommandBars(i).Enabled = True
    Next
End Sub

Sub Shielding_2()
    Dim Cmd As CommandBar
    For Each Cmd In Application.CommandBars
        Cmd.Enabled = False
    Next
End Sub

Sub Recovery_2()
    Dim Cmd As CommandBar
    For Each Cmd In Application.CommandBars
        Cmd.Enabled = True
    Next
End Sub

Sub AddChartObjects()
    Dim myButton As Button
    On Error Resume Next
    Sheet1.Shapes("myButton").Delete
    Set myButton = Sheet1.Buttons.Add(108, 72, 108, 27)
    With myButton
        .Name = "myButton"
        .Font.Size = 12
        .Font.ColorIndex = 5
        .Characters.Text = "新建的按钮"
        .OnAction = "myButton"
    End With
End Sub

Sub myButton()
    MsgBox "这是使用Add方法新建的按钮!"
End Sub


Sub 组合框()
    dim rowcount as integer,ws as worksheet
    set ws=worksheets(“sheet1”)
    Recount=ws.range(“a”&rows.count).end(xlup).row
    Range(“a1:a”&rowcount).advancedfilter xlfiltercopy,”.range(“j1”),true
    Rowcount=ws.range(“j”&rows.count).end(xlup).row
    With ws.shapes(“cmbbox”).oleformat.object: .listfillrange=”$j$2:$j$”&rowcount ‘设置组合框的数据源区域
        .linkedcell=”g2” ‘设置组合框的链接单元格
        .dropdownlines=rowcount-1 ’设置组合框下拉框中的项目数
    End with: end sub

' 列表框：插入之后右键指定宏或者设置控件格式。指定宏的代码范例如下：
Sub 列表框()
    dim rowcount as integer, ws as worksheet
    set ws=worksheets(“组合框列表框“)
    ws.[h2]=0 ’初始化
    Rowcount=ws.range(“a”&rows.count).end(xlup).row
    range(“a1:b”&rowcount).advancedfilter xlfitercopy,range(“d1:e2”),range(“l1:m1”),true
    Rowcount=ws.range(“m”&rows.count.end(xlup).row
    With ws.shapes(“lstbox”).oleformat.object
        .listfillrange=”$m$2:$m$”&rowcount ‘设置列表框的数据源区域
        .linkedcell=”h2”  ’设置列表框的连接单元格
    End with
end sub


' 创建自定义菜单：
Sub additems()
    Dim commandbar1 as commandbar,myfirstmenu as object,myfirstmenuitem as object
    Set commandbar1=activesheet.commandbars.activemenubar
    Set myfirstmenu=commandbar1.controls.add type=msocontrolpopup,temporary=true
    Myfirstmenu.caption=”我菜单”
    set myfirstmenuitem=myfirstmenu.controls.add(type:=msocontrolbutton,ID:=1)
    Myfirstmenuitem.caption=”菜单1” :myfirstmenuitem.style=msobuttoncaption :myfirstmenuitem.onaction=”m1”
    Set myfirstmenuitem=myfirstmenu.controls.add(type:=msocontrolbutton,ID:=2)
    Myfirstmenuitem.caption=”菜单2” :myfirstmenuitem.style=msobuttoncaption :myfirstmenuitem.onaction=”m2”
    set myfirstmenuitem=myfirstmenu.controls.add(type:=msocontrolbutton,ID:=3)
    Myfirstmenuitem.caption=”菜单3” :myfirstmenuitem.style=msobuttoncaption :myfirstmenuitem.onaction=”m3”
End sub
Sub m1()
    msgbox”您选择的是”菜单项1”。”，.”创建自定义菜单”
end sub
Sub m2()
    msgbox”您选择的是”菜单项2”。”，.”创建自定义菜单”
end sub
Sub m3()
    msgbox”您选择的是”菜单项3”。”，.”创建自定义菜单”
end sub

Sub Main()
    Dim MyLogin As New frmLogin
    MyLogin.Show vbModal
    If Not MyLogin.LoginSucceeded Then
        End
    End If
    Unload MyLogin
    Set fMainForm = New FrmMain
    fMainForm.Show
End Sub