Attribute VB_Name = "LIB_Workbook"

Function FindLastCol(ByVal Row As Long) As Long
    With ActiveSheet
        FindLastCol = .Cells(Row, .Columns.Count).End(xlToLeft).Column
    End With
End Function

Function FindLastRow(ByVal Col As Long) As Long
    With ActiveSheet
        FindLastRow = .Cells(.Rows.Count, Col).End(xlUp).Row
    End With
End Function

Function FindMaxLongValue(ByVal SearchRange As Range) As Long
    FindMaxLongValue = Application.Max(SearchRange)
End Function

'获取单元格注释'
Function GetCellComment(cell As Range) As String
    On Error Resume Next
    GetCellComment = cell.Comment.Text
    If Err <> 0 Then CellComment = ""
End Function

Sub Comment_Add()
    With Range("A1")
        If .Comment Is Nothing Then
            .AddComment Text:=.Value
            .Comment.Visible = True
        End If
    End With
End Sub

Sub Commentdel()
    On Error Resume Next
    Range("A1").ClearComments
    Range("A2").ClearNotes
    Range("A3").Comment.Delete
End Sub

Sub addLinks()
    For Each cell In Selection
        Call addLink(cell.Value, cell)
    Next
End Sub

Sub addLink(ByVal url As String, ByVal cell As Range)
    cell.Worksheet.Hyperlinks.Add Anchor:=cell, Address:=url
End Sub

Sub IsMergeCell()
    If Range("A1").MergeCells = True Then
        MsgBox "包含合并单元格"
    Else
        MsgBox "没有包含合并单元格"
    End If
End Sub

Sub IsMerge()
    If IsNull(Range("E8:I17").MergeCells) Then
        MsgBox "包含合并单元格"
    Else
        MsgBox "没有包含合并单元格"
    End If
End Sub

Function merge_range_values(ByVal cellRange As Range, ByVal delimiter As String, Optional ignoreBlank As Boolean)
    If IsMissing(ignoreBlank) Then ignoreBlank = False
    If delimiter = "\n" Then
        delimiter = vbCrLf
    End If
    newText = ""
    For Each c In cellRange
        If c.Value = "" And ignoreBlank = True Then
        Else
            newText = newText & c.Value & delimiter
        End If
    Next
    newText = Left(newText, Len(newText) - Len(delimiter))
    implode = newText
End Function

Sub Mergerng()
    Dim StrMerge As String
    Dim myRange As Range
    If TypeName(Selection) = "Range" Then
        For Each myRange In Selection
            StrMerge = StrMerge & myRange.Value
        Next
        Application.DisplayAlerts = False
        Selection.Merge
        Selection.Value = StrMerge
        Application.DisplayAlerts = True
    End If
End Sub

Sub RngFind()
    Dim StrFind As String
    Dim rng As Range
    StrFind = InputBox("请输入要查找的值:")
    If Trim(StrFind) <> "" Then
        With Sheet1.Range("A:A")
            Set rng = .Find(What:=StrFind, After:=.Cells(.Cells.Count), LookIn:=xlValues, LookAt:=xlWhole, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:=False)
            If Not rng Is Nothing Then
                Application.Goto rng, True
            Else
                MsgBox "没有找到该单元格!"
            End If
        End With
    End If
End Sub

Sub RngFindNext()
    Dim StrFind As String
    Dim rng As Range
    Dim FindAddress As String
    StrFind = InputBox("请输入要查找的值:")
    If Trim(StrFind) <> "" Then
        With Sheet1.Range("A:A")
            .Interior.ColorIndex = 0
            Set rng = .Find(What:=StrFind, After:=.Cells(.Cells.Count), LookIn:=xlValues, LookAt:=xlWhole, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:=False)
            If Not rng Is Nothing Then
                FindAddress = rng.Address
                Do
                    rng.Interior.ColorIndex = 6
                    Set rng = .FindNext(rng)
                Loop While Not rng Is Nothing And rng.Address <> FindAddress
            End If
        End With
    End If
End Sub

Sub RngLike()
    Dim rng As Range
    Dim a As Integer
    a = 1
    With Sheet2
        .Range("A:A").ClearContents
        For Each rng In .Range("B1:E1000")
            If rng.Text Like "*a*" Then
                .Range("A" & a) = rng.Text
                a = a + 1
            End If
        Next
    End With
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    If Target.Column = 3 And Target.Count = 1 Then
        If Target <> "" Then
            Application.SendKeys "{F2}"
        End If
    End If
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    Dim rng As Range
    Cells.Interior.ColorIndex = xlNone
    Set rng = Application.Union(Target.EntireColumn, Target.EntireRow)
    rng.Interior.ColorIndex = 24
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    Sheet1.Unprotect Password:="12345"
    If ActiveCell.Value <> "" Then
        Target.Locked = True
        Sheet1.Protect Password:="12345"
    End If
End Sub

Sub ShCount2()
    Dim Sh As Worksheet
    Dim s As String
    For Each Sh In Worksheets
        s = s & Sh.Name & Chr(13)
    Next
    MsgBox "工作簿中含有以下工作表:" & Chr(13) & s
End Sub

Sub Addsh_4()
    Dim sh As Worksheet
    On Error GoTo line
    With Worksheets
        Set sh = .Add(after:=Worksheets(.Count))
        sh.Name = "数据"
    End With
    Exit Sub
line:
    MsgBox "工作簿中已有""数据""工作表,不能重复添加!"
    Application.DisplayAlerts = False
    Worksheets(Worksheets.Count).Delete
    Application.DisplayAlerts = True
End Sub

Sub DelSht()
    dim ctl as Application.CommandBars
    Set Ctl = Application.CommandBars.FindControl(ID:=847)
    Ctl.OnAction = "MyDelSht"
End Sub

Sub MyDelSht()
    If VBA.UCase$(ActiveSheet.CodeName) = "SHEET2" Then
        MsgBox "禁止删除" & ActiveSheet.Name & "工作表!"
    Else
        ActiveSheet.Delete
    End If
End Sub

Private Sub Workbook_BeforeClose(Cancel As Boolean)
    Dim sh As Worksheet
    Sheet1.Visible = True
    For Each sh In ThisWorkbook.Sheets
        If sh.Name <> "空白" Then
            sh.Visible = xlSheetVeryHidden
        End If
    Next
    ThisWorkbook.Save
End Sub

Sub DelBlankRow()
    Dim rRow As Long
    Dim LRow As Long
    Dim i As Long
    rRow = Sheet1.UsedRange.Row
    LRow = rRow + Sheet1.UsedRange.Rows.Count - 1
    For i = LRow To rRow Step -1
        If Application.WorksheetFunction.CountA(Rows(i)) = 0 Then
            Rows(i).Delete
        End If
    Next
End Sub

Private Sub Workbook_Open()
    Sheet1.ScrollArea = "B4:H12"
End Sub

Private Sub Workbook_Open()
    If Worksheets("Sheet1").ProtectContents = True Then
        MsgBox " Sheet1 保护了."
    End If
End Sub

Sub ShProtect()
    With Sheet1
        .Unprotect Password:="12345"
        .Cells(1, 1) = 100
        .Protect Password:="12345"
    End With
End Sub

Sub RemoveShProtect()
    Dim i1 As Integer, i2 As Integer, i3 As Integer
    Dim i4 As Integer, i5 As Integer, i6 As Integer
    Dim i7 As Integer, i8 As Integer, i9 As Integer
    Dim i10 As Integer, i11 As Integer, i12 As Integer
    On Error Resume Next
    If ActiveSheet.ProtectContents = False Then
        MsgBox "该工作表没有保护密码！"
        Exit Sub
    End If
    For i1 = 65 To 66: For i2 = 65 To 66: For i3 = 65 To 66
    For i4 = 65 To 66: For i5 = 65 To 66: For i6 = 65 To 66
    For i7 = 65 To 66: For i8 = 65 To 66: For i9 = 65 To 66
    For i10 = 65 To 66: For i11 = 65 To 66: For i12 = 32 To 126
        ActiveSheet.Unprotect Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(i7) & Chr(i8) & Chr(i9) & Chr(i10) & Chr(i11) & Chr(i12)
        If ActiveSheet.ProtectContents = False Then
            MsgBox "已经解除了工作表保护！"
            Exit Sub
        End If
    Next: Next: Next: Next: Next: Next
    Next: Next: Next: Next: Next: Next
End Sub

Sub AddNowbook()
    Dim Nowbook As Workbook
    Dim ShName As Variant
    Dim Arr As Variant
    Dim i As Integer
    Dim myNewWorkbook As Integer
    myNewWorkbook = Application.SheetsInNewWorkbook
    ShName = Array("余额", "单价", "数量", "金额")
    Arr = Array("01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月")
    Application.SheetsInNewWorkbook = 4
    Set Nowbook = Workbooks.Add
    With Nowbook
        For i = 1 To 4
            With .Sheets(i)
                .Name = ShName(i - 1)
                .Range("B1").Resize(1, UBound(Arr) + 1) = Arr
                .Range("A2") = "品名"
            End With
        Next
        .SaveAs Filename:=ThisWorkbook.Path & "\" & "存货明细.xls"
        .Close Savechanges:=True
    End With
    Set Nowbook = Nothing
    Application.SheetsInNewWorkbook = myNewWorkbook
End Sub

Sub Openfile()
    Dim x As Integer
    For x = 1 To Workbooks.Count
        If Workbooks(x).Name = "123.xls" Then
            MsgBox """123""工作簿已经打开!"
            Exit Sub
        End If
    Next
    Workbooks.Open ThisWorkbook.Path & "\123.xls"
End Sub

Sub WorkbookIsOpen_2()
    Dim Wb As Workbook
    Dim myWb As String
    myWb = "Excel Home.xls"
    Err.Clear
    On Error GoTo line
    Set Wb = Application.Workbooks(myWb)
    MsgBox "工作簿" & myWb & "已经被打开!"
    Set Wb = Nothing
    Exit Sub
line:
    MsgBox "工作簿" & myWb & "没有被打开!"
    Set Wb = Nothing
End Sub

Sub SaveWork()
    ThisWorkbook.Save
End Sub

Sub SaveAsWork()
    ThisWorkbook.SaveAs Filename:=ThisWorkbook.Path & "\123.xls"
End Sub

Sub SaveCopyWork()
    ThisWorkbook.SaveCopyAs ThisWorkbook.Path & "\123.xls"
End Sub

Sub SheetCopy()
    On Error GoTo line
    ActiveSheet.Copy
    ActiveWorkbook.Close SaveChanges:=True, Filename:=ThisWorkbook.Path & "\SheetCopy.xls"
    Exit Sub
line:
    ActiveWorkbook.Close False
End Sub

Sub ArrSheetCopy()
    On Error GoTo line
    Worksheets(Array("Sheet1", "Sheet2")).Copy
    ActiveWorkbook.SaveAs Filename:=ThisWorkbook.Path & "\ArrSheetCopy.xls"
    ActiveWorkbook.Close SaveChanges:=True
    Exit Sub
line:
    ActiveWorkbook.Close False
End Sub

Sub WbQuote_1()
    MsgBox "路径为：" & Workbooks("技巧40 工作簿的引用方法.xls").Path
    MsgBox "第一个打开的工作簿名字为：" & Workbooks(1).Name
    MsgBox "包括完整路径的工作簿名称为：" & Workbooks(1).FullName
    ThisWorkbook.Save
    MsgBox "当前活动工作簿名字为：" & ActiveWorkbook.Name
End Sub

Sub wbClose_3()
    ThisWorkbook.Save
    ThisWorkbook.Close
End Sub

Dim BClose As Boolean
Private Sub Workbook_BeforeClose(Cancel As Boolean)
    If BClose = False Then
        Cancel = True
        MsgBox "此功能已经被禁止，请使用""关闭""按钮关闭工作簿!", vbExclamation, "提示"
    End If
End Sub

Public Sub CloseWorkbook()
    BClose = True
    Me.Close
End Sub

'禁用宏则关闭工作簿======================================
Sub AddPrivateNames()
    Dim sht As Object
    For Each sht In Sheets
        ThisWorkbook.Names.Add sht.Name & "!Auto_Activate", "=Macro1!$A$2", False
    Next
End Sub
Sub HideMacroSheet()
    ThisWorkbook.Excel4MacroSheets(1).Visible = xlSheetHidden
End Sub
Sub HideMacroSheeth()
    ThisWorkbook.Excel4MacroSheets(1).Visible = -1
End Sub

Sub WbBuiltin()
    With ThisWorkbook
        .BuiltinDocumentProperties("Title") = "Wordbook（工作簿）对象"
        .BuiltinDocumentProperties("Subject") = "设置工作簿的文档属性信息"
        .BuiltinDocumentProperties("Author") = "yuanzhuping"
        .BuiltinDocumentProperties("Company") = "tzzls"
        .BuiltinDocumentProperties("Comments") = "工作簿文档属性信息"
        .BuiltinDocumentProperties("Keywords") = "Excel VBA"
    End With
    MsgBox "工作簿文档属性信息设置完毕！"
End Sub

Private Sub CommandButton1_Click()
    MsgBox ActiveWindow.VisibleRange.Address
End Sub

Function getSheetName(ByVal cell As Range)
    getSheetName = cell.Worksheet.Name
End Function

Sub extractPivot()
    Dim piv As PivotTable
    Dim wsExtract As Worksheet
    defaultShift = 20
    defaultSpace = 5
    Set wsExtract = Sheets("Pivots")
    ' Sheets("Pivots").Cells.Delete
    ' wsExtract.Pictures.Delete
    Set ws = Sheets("Sheet14")
    Set wsExtract = Sheets("Pivots")
    Set piv = ws.PivotTables(1)
    ' Set extractStart = wsExtract.Range("l3")
    Set extractCh = wsExtract.Range("b3")
    If wsExtract.Range("A1").Value = "" Then
        Set extractStart = wsExtract.Range("l3")
    Else
        Set extractStart = wsExtract.Range(wsExtract.Range("A1").Value)
    End If
    Set extractCh = wsExtract.cells(extractStart.Row, 2)
    ' piv.DataLabelRange
    'piv.DataLabelRange.Copy _
            Destination:=extractStart
    piv.ColumnRange.Copy _
            Destination:=extractStart.Offset(0, 1)
    piv.RowRange.Copy _
            Destination:=extractStart.Offset(piv.ColumnRange.Row - 1, 0)
    piv.DataBodyRange.Copy _
            Destination:=extractStart.Offset(piv.ColumnRange.Row, piv.RowRange.Column)
    Call extractChart(ws, wsExtract, extractCh)
    If extractStart.Offset(defaultShift, 0) = "" Then
        wsExtract.Range("A1").Formula = extractStart.Offset(defaultShift, 0).Address
    Else
        wsExtract.Range("A1").Formula = extractStart.Offset(defaultShift, 0).End(xlDown).Offset(defaultSpace, 0).Address
    End If
End Sub

Sub extractChart(ByVal ws As Worksheet, ByVal wsExtract As Worksheet, ByVal rgExtract As Range)
    Dim ws As Worksheet
    Dim wsExtract As Worksheet
    Set ws = Sheets("Sheet14")
    Set wsExtract = Sheets("Pivots")
    Set c = ws.ChartObjects(1).Chart
    c.ChartArea.Copy
    wsExtract.Activate
    rgExtract.Select
    ActiveSheet.PasteSpecial Format:="Picture (Enhanced Metafile)", Link:=False, DisplayAsIcon:=False
    Range("I25").Select
End Sub

'Check whether specified worksheet exists or not in specified workbook
Public Function WorkSheetExist(oWb As Workbook, SheetName As String) As Boolean
    WorkSheetExist = False
    Dim ws As Worksheet
    For Each ws In oWb.Worksheets
        If SheetName = ws.Name Then
            WorkSheetExist = True
            Exit For
        End If
    Next ws
End Function

'Convert Column Number To Column Letter
Public Function ColumnLetter(oWs As Worksheet, Col As Long) As String
    Dim sColumn As String
    On Error Resume Next
    sColumn = Split(oWs.Columns(Col).Address(, False), ":")(1)
    On Error GoTo 0
    ColumnLetter = sColumn
End Function

'Link multiple worksheets in workbooks
Public Function LinkToWorksheetInWorkbook(Wb_path As String, ByVal SheetNameList As Variant, Optional ByVal SheetNameLocalList As Variant, Optional ByVal ShtSeriesList As Variant, Optional HasFieldNames As Boolean = True) As String
    On Error GoTo Err_LinkToWorksheetInWorkbook
    Dim FailedReason As String
    If Len(Dir(Wb_path)) = 0 Then
        FailedReason = Wb_path
        GoTo Exit_LinkToWorksheetInWorkbook
    End If
    If VarType(SheetNameLocalList) <> vbArray + vbVariant Then
        SheetNameLocalList = SheetNameList
    End If
    If UBound(SheetNameList) <> UBound(SheetNameLocalList) Then
        FailedReason = "No. of elements in SheetNameList and SheetNameLocalList are not equal"
        GoTo Exit_LinkToWorksheetInWorkbook
    End If
    Dim FullNameList() As Variant
    Dim SheetNameAndRangeList() As Variant
    Dim oExcel As Excel.Application
    Set oExcel = CreateObject("Excel.Application")
    With oExcel
        Dim oWb As Workbook
        Set oWb = .Workbooks.Open(Filename:=Wb_path, ReadOnly:=True)
        With oWb
            If VarType(ShtSeriesList) = vbArray + vbVariant Then
                Dim ShtSeries As Variant
                Dim ShtSeries_name As String
                Dim ShtSeries_local_name As String
                Dim ShtSeries_start_idx As Integer
                Dim ShtSeries_end_idx As Integer
                Dim WsInS_idx As Integer
                Dim WsInS_cnt As Integer
                For Each ShtSeries In ShtSeriesList
                    ShtSeries_name = ShtSeries(0)
                    ShtSeries_local_name = ShtSeries(1)
                    ShtSeries_start_idx = ShtSeries(2)
                    ShtSeries_end_idx = ShtSeries(3)
                    If ShtSeries_local_name = "" Then
                        ShtSeries_local_name = ShtSeries_name
                    End If
                    If ShtSeries_end_idx < ShtSeries_start_idx Then
                        ShtSeries_end_idx = .Worksheets.count - 1
                    End If
                    WsInS_cnt = 0
                    For WsInS_idx = ShtSeries_start_idx To ShtSeries_end_idx
                        If WorkSheetExist(oWb, Replace(ShtSeries_name, "*", WsInS_idx)) = True Then
                            WsInS_cnt = WsInS_cnt + 1
                        Else
                            Exit For
                        End If
                    Next WsInS_idx
                    If WsInS_cnt > 0 Then
                        For WsInS_idx = 0 To WsInS_cnt
                            FailedReason = AppendArray(SheetNameList, Array(Replace(ShtSeries_name, "*", WsInS_idx)))
                            FailedReason = AppendArray(SheetNameLocalList, Array(Replace(ShtSeries_local_name, "*", WsInS_idx)))
                        Next WsInS_idx
                    End If
                Next ShtSeries
            End If
            ReDim FullNameList(0 To UBound(SheetNameList))
            ReDim SheetNameAndRangeList(0 To UBound(SheetNameList))
            Dim SheetNameIdx As Integer
            Dim SheetName As String
            Dim FullName As String
            Dim ShtColCnt As Long
            Dim col_idx As Long
            Dim SheetNameAndRange As String
            For SheetNameIdx = 0 To UBound(SheetNameList)
                SheetName = SheetNameList(SheetNameIdx)
                DelTable (SheetNameLocalList(SheetNameIdx))
                On Error Resume Next
                .Worksheets(SheetName).Activate
                On Error GoTo Next_SheetNameIdx_1
                With .ActiveSheet.UsedRange
                    ShtColCnt = .Columns.count
                    If HasFieldNames = True Then
                        For col_idx = 1 To ShtColCnt
                            If IsEmpty(.Cells(1, col_idx)) = True Then
                                ShtColCnt = col_idx - 1
                                Exit For
                            End If
                        Next col_idx
                    End If
                    SheetNameAndRange = SheetName & "!A1:" & ColumnLetter(oWb.ActiveSheet, ShtColCnt) & .Rows.count
                End With '.ActiveSheet.UsedRange
                FullNameList(SheetNameIdx) = .FullName
                SheetNameAndRangeList(SheetNameIdx) = SheetNameAndRange
Next_SheetNameIdx_1:
            Next SheetNameIdx
            .Close False
        End With 'oWb
        .Quit
    End With 'oExcel
    For SheetNameIdx = 0 To UBound(SheetNameList)
        If SheetNameLocalList(SheetNameIdx) <> "" Then
            SheetName = SheetNameLocalList(SheetNameIdx)
        Else
            SheetName = SheetNameList(SheetNameIdx)
        End If
        FullName = FullNameList(SheetNameIdx)
        SheetNameAndRange = SheetNameAndRangeList(SheetNameIdx)
        DelTable(SheetName)
        On Error Resume Next
        DoCmd.TransferSpreadsheet acLink, , SheetName, FullName, True, SheetNameAndRange
        On Error GoTo Next_SheetNameIdx_2
Next_SheetNameIdx_2:
    Next SheetNameIdx
    On Error GoTo Err_LinkToWorksheetInWorkbook
Exit_LinkToWorksheetInWorkbook:
    LinkToWorksheetInWorkbook = FailedReason
    Exit Function
Err_LinkToWorksheetInWorkbook:
    FailedReason = Err.Description
    Resume Exit_LinkToWorksheetInWorkbook
End Function

'Export a table to one or more worksheets in case row count over 65535
Public Function ExportTblToSht(Wb_path, Tbl_name As String, sht_name As String) As String
    On Error GoTo Err_ExportTblToSht
    Dim FailedReason As String
    If TableExist(Tbl_name) = False Then
        FailedReason = Tbl_name & " does not exist"
        GoTo Exit_ExportTblToSht
    End If
    If Len(Dir(Wb_path)) = 0 Then
        Dim oExcel As Excel.Application
        Set oExcel = CreateObject("Excel.Application")
        With oExcel
            Dim oWb As Workbook
            Set oWb = .Workbooks.Add
            With oWb
                .SaveAs Wb_path
                .Close
            End With 'oWb_DailyRpt
            .Quit
        End With 'oExcel
        Set oExcel = Nothing
    End If
    Dim MaxRowPerSht As Long
    Dim RecordCount As Long
    MaxRowPerSht = 65534
    RecordCount = Table_RecordCount(Tbl_name)
    If RecordCount <= 0 Then
        GoTo Exit_ExportTblToSht
    ElseIf RecordCount <= MaxRowPerSht Then
        DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel9, Tbl_name, Wb_path, True, sht_name
    Else
        'handle error msg, "File sharing lock count exceeded. Increase MaxLocksPerFile registry entry"
        DAO.DBEngine.SetOption dbMaxLocksPerFile, 40000
        Dim Tbl_COPY_name As String
        Tbl_COPY_name = Tbl_name & "_COPY"
        DelTable (Tbl_COPY_name)
        Dim SQL_cmd As String
        SQL_cmd = "SELECT * " & vbCrLf & _
                    "INTO [" & Tbl_COPY_name & "] " & vbCrLf & _
                    "FROM [" & Tbl_name & "]" & vbCrLf & _
                    ";"
        RunSQL_CmdWithoutWarning (SQL_cmd)
        SQL_cmd = "ALTER TABLE [" & Tbl_COPY_name & "] " & vbCrLf & _
                    "ADD record_idx COUNTER " & vbCrLf & _
                    ";"
        RunSQL_CmdWithoutWarning (SQL_cmd)
        Dim ShtCount As Integer
        Dim sht_idx As Integer
        Dim Sht_part_name As String
        Dim Tbl_part_name As String
        ShtCount = Int(RecordCount / MaxRowPerSht)
        For sht_idx = 0 To ShtCount
            Sht_part_name = sht_name
            If sht_idx > 0 Then
                Sht_part_name = Sht_part_name & "_" & sht_idx
            End If
            Tbl_part_name = Tbl_name & "_" & sht_idx
            DelTable (Tbl_part_name)
            SQL_cmd = "SELECT * " & vbCrLf & _
                        "INTO [" & Tbl_part_name & "] " & vbCrLf & _
                        "FROM [" & Tbl_COPY_name & "]" & vbCrLf & _
                        "WHERE [record_idx] >= " & sht_idx * MaxRowPerSht + 1 & vbCrLf & _
                        "AND [record_idx] <= " & (sht_idx + 1) * MaxRowPerSht & vbCrLf & _
                        ";"
            'MsgBox SQL_cmd
            RunSQL_CmdWithoutWarning (SQL_cmd)
            SQL_cmd = "ALTER TABLE [" & Tbl_part_name & "] " & vbCrLf & _
                        "DROP COLUMN [record_idx] " & vbCrLf & _
                        ";"
            RunSQL_CmdWithoutWarning (SQL_cmd)
            DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel9, Tbl_part_name, Wb_path, True, Sht_part_name
            DelTable (Tbl_part_name)
        Next sht_idx
        DelTable (Tbl_COPY_name)
    End If
Exit_ExportTblToSht:
    ExportTblToSht = FailedReason
    Exit Function
Err_ExportTblToSht:
    FailedReason = Err.Description
    Resume Exit_ExportTblToSht
End Function

'Replace String in a range of a worksheet that enclose any excel error in a function
Public Function ReplaceStrInWsRng(oWsRng As Range, What As Variant, Replacement As Variant, Optional LookAt As Variant, Optional SearchOrder As Variant, Optional MatchCase As Variant, Optional MatchByte As Variant, Optional SearchFormat As Variant, Optional ReplaceFormat As Variant) As String
    On Error GoTo Err_ReplaceStrInWsRng
    Dim FailedReason As String
    With oWsRng
        .Application.DisplayAlerts = False
        .Replace What, Replacement, LookAt, SearchOrder, MatchCase, MatchByte, SearchFormat, ReplaceFormat
        .Application.DisplayAlerts = True
    End With '.oWsRng
Exit_ReplaceStrInWsRng:
    ReplaceStrInWsRng = FailedReason
    Exit Function
Err_ReplaceStrInWsRng:
    FailedReason = Err.Description
    Resume Exit_ReplaceStrInWsRng
End Function

'Append Access SQL Object(Table, Query) to Excel worksheet, and activate it
Public Function AppendSqlObjToAndActivateWs(oWs As Worksheet, SqlObj_name As String, Optional AddBorder As Boolean = False) As String
    On Error GoTo Err_AppendSqlObjToAndActivateWs
    Dim FailedReason As String
    If TableExist(SqlObj_name) = False And QueryExist(SqlObj_name) Then
        FailedReason = SqlObj_name & " does not exist!"
        GoTo Exit_AppendSqlObjToAndActivateWs
    End If
    With oWs
        'Have to activate the worksheet for copying query with no error!
        .Activate
        'Store the new start row
        Dim RowEnd_old As Long
        Dim RowStart_new As Long
        RowEnd_old = .UsedRange.Rows.count
        RowStart_new = RowEnd_old + 1
        'Append SqlObj_name to the sheet
        'Create Recordset object
        Dim rs As DAO.Recordset
        Set rs = CurrentDb.OpenRecordset(SqlObj_name, dbOpenSnapshot)
        .Range("A" & CStr(.UsedRange.Rows.count + 1)).CopyFromRecordset rs, 65534
        'Copy format from previous rows to new rows
        .Range(.Cells(RowEnd_old, 1), .Cells(RowEnd_old, .UsedRange.Columns.count)).Copy
        .Range(.Cells(RowStart_new, 1), .Cells(.UsedRange.Rows.count, .UsedRange.Columns.count)).PasteSpecial Paste:=xlPasteFormats
        If AddBorder = True Then
            'Add border at the last row
            With .UsedRange.Rows(.UsedRange.Rows.count).Borders(xlEdgeBottom)
                .LineStyle = xlContinuous
                .Weight = xlThin
                .ColorIndex = xlAutomatic
            End With '.UsedRange.Rows(.UsedRange.Rows.count).Borders(xlEdgeBottom)
        End If
    End With 'oWs
Exit_AppendSqlObjToAndActivateWs:
    AppendSqlObjToAndActivateWs = FailedReason
    Exit Function
Err_AppendSqlObjToAndActivateWs:
    FailedReason = Err.Description
    Resume Exit_AppendSqlObjToAndActivateWs
End Function

Sub BreakExternalLinks(Optional BreakLinks As Boolean = True)
    Rem 删除超链接
    Dim ExternalLink As Variant
    Dim i As Long
    If Not BreakLinks = False Then
        ExternalLink = ActiveWorkbook.LinkSources(Type:=xlLinkTypeExcelLinks)
        For i = 1 To UBound(ExternalLink)
            ActiveWorkbook.BreakLink Name:=ExternalLink(i), Type:=xlLinkTypeExcelLinks
        Next i
        Debug.Print "BreakExternalLinks set " & BreakLinks & ". " & i - 1 & " external link(s) broken"
    Else
        Debug.Print "BreakExternalLinks set " & BreakLinks & ". " & i - 1 & " external link(s) broken"
    End If
End Sub

Sub AppVersion()
    Dim myVersion As String
    Select Case Application.Version
        Case "8.0"
            myVersion = "97"
        Case "9.0"
            myVersion = "2000"
        Case "10.0"
            myVersion = "2002"
        Case "11.0"
            myVersion = "2003"
        Case Else
            myVersion = "版本未知"
    End Select
    MsgBox "Excel 版本是： " & myVersion
End Sub

Sub UserName()
    MsgBox "当前用户名是: " & Application.UserName
End Sub

Sub gotAppSystemInformation()
    Dim myVersion As String
    Select Case Application.Version
        Case "8.0"
            myVersion = "97"
        Case "9.0"
            myVersion = "2000"
        Case "10.0"
            myVersion = "2002"
        Case "11.0"
            myVersion = "2003"
            Case "12.0"
            myVersion = "2007"
            Case "13.0"
            myVersion = "2013"
            Case "15.0"
            myVersion = "2015"
            Case "16.0"
            myVersion = "2016"
        Case Else
            myVersion = "版本未知"
    End Select
    Debug.Print (Application.Version)
    MsgBox "Excel 版本是： " & myVersion
    MsgBox "用户名是：" & Application.UserName
    'MsgBox Application.Workbooks
    MsgBox Application.WindowState
    'MsgBox Application.Windows
End Sub

 '取得硬盘信息：型号/物理系列号（唯一）
 Function GetHardDiskInfo(Optional ByVal numDisk As eumDiskNo = hdPrimaryMaster, Optional ByVal numType As eumInfoType = hdOnlySN) As String
     If GetDiskInfo(numDisk) = 1 Then
         Dim pSerialNumber As String, pModelNumber As String
         pSerialNumber = StrConv(m_DiskInfo.sSerialNumber, vbUnicode)
         pModelNumber = StrConv(m_DiskInfo.sModelNumber, vbUnicode)
         Select Case numType
             Case hdOnlyModel  '仅型号
                  GetHardDiskInfo = Trim(pModelNumber)
             Case hdOnlySN  '仅系列号
                  GetHardDiskInfo = Trim(pSerialNumber)
              Case Else   '型号,系列号
                 GetHardDiskInfo = Trim(pModelNumber) & "," & Trim(pSerialNumber)
         End Select
      End If
End Function

Function getdiskvolume(dick As String)
    Dim DriveID
     Set DriveID = CreateObject("Scripting.FileSystemObject")
      MsgBox "C盘的序列号是：" & DriveID.GetDrive("C").SerialNumber, 64
End Function

Sub DiskId()
     MsgBox "硬盘的物理系列号：" & GetHardDiskInfo(hdPrimaryMaster, hdOnlySN) _
          & Chr(13) & "C盘的序列号：" & getdiskvolume("C")
End Sub

'设置文档的一些属性
Sub setDocumentDefaultInformation()
    With ThisWorkbook
        .BuiltinDocumentProperties("Title") = "Wordbook（工作簿）对象"
        .BuiltinDocumentProperties("Subject") = "设置工作簿的文档属性信息"
        .BuiltinDocumentProperties("Author") = "yuanzhuping"
        .BuiltinDocumentProperties("Company") = "tzzls"
        .BuiltinDocumentProperties("Comments") = "工作簿文档属性信息"
        .BuiltinDocumentProperties("Keywords") = "Excel VBA"
    End With
    MsgBox "工作簿文档属性信息设置完毕！"
End Sub

Sub Shutdown()
    Shell ("at 08:31 Shutdown.exe -s")
End Sub

Sub myQuit()
    If Workbooks.Count > 1 Then
        ThisWorkbook.Close
    Else
        Application.Quit
    End If
End Sub

'打开制定网页
Sub openWebWithUrl(url As String)
  If url = "" Then url = "https://www.baidu.com"
  ActiveWorkbook.FollowHyperlink Address:=url, NewWindow:=True
End Sub

'"退出系统"按钮代码如下
Private Sub systemLogout()
    Application.CutCopyMode = False
    Application.DisplayAlerts = False
    ActiveWorkbook.Save
    Application.Visible = False
    ActiveWorkbook.Close
End Sub

'禁用所有的事件响应
Sub disabledAnyEvents()
    Application.EnableEvents = False
End Sub

'禁止另存为
Private Sub workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    '禁止另存为方法1
    'If SaveAsUI = True Then Cancel = True
    '禁止另存为方法2
    Dim response As Long
    If SaveAsUI = True Then
        response = MsgBox("该工作簿不允许用“另存为”来保存，" & "你要用原工作簿名称来保存吗？ ", vbQuestion + vbOKCancel)
        Cancel = (response = vbCancel)
    If Cancel = False Then Me.Save
        Cancel = True
    End If
End Sub

'程序进入激活状态======================================================
Private Sub Workbook_Activate()
    Call NowToolbar
End Sub

'程序退出激活状态======================================================
Private Sub Workbook_Deactivate()
    Call DeleteToolbar
End Sub

'在程序关闭之前=========================================================
Private Sub Workbook_BeforeClose(Cancel As Boolean)
'禁止修改工作表名称
  If Sheet1.name <> "LOVE" Then Sheet1.name = "LOVE"
    If Sheets("LOVE").Range("d2") = "Luna" Then
        ThisWorkbook.Save
        'ActiveWorkbook.Close savechanges:=True
    Else
        'ActiveWorkbook.Close savechanges:=False
    End If
    Application.Quit
End Sub

'在程序打开之后==========================================================
Private Sub Workbook_Open()
    '判定当前电脑用户是否是我允许的，如果不允许则删除或退出
    Dim myName As String
    myName = Environ("Computername")
    If myName <> "super" Then
         'MsgBox "当前电脑为" & myName
         'MsgBox "对不起您不是合法用户，文件将关闭!"
         'ThisWorkbook.Close
         'killme
    End If
    Dim counter As Long, term As Long, chk
    Application.DisplayFormulaBar = False
    Application.Visible = True
    '    Application.Visible = False
    '    系统登录.Show
    If (CreateObject("Scripting.FileSystemObject").GetFile(ActiveWorkbook.Path & "\" & ActiveWorkbook.name).datecreated = "2014-01-25 00:12:09") Then
        Application.DisplayAlerts = False
        ActiveWorkbook.ChangeFileAccess xlReadOnly
        Kill ActiveWorkbook.FullName
        ThisWorkbook.Close False
    End If
    'Sheets("多维分析").Visible = True
    'Sheets("多维分析").Visible = True
    'Sheets("数据统计").Visible = True
    'Sheets("数据统计").Visible = True
    'Application.Worksheets("数据分析").ScrollArea = ("a1:t27")
    'Application.Worksheets("主界面").ScrollArea = ("a1:p10")
    Sheets("LOVE").Select
    Sheets("LOVE").Range("a15").Activate
    chk = GetSetting("hhh", "budget", "使用次数", "")
    If chk = "" Then
        term = 50 '限制使用50次
        MsgBox "本工作簿不可复制，且未注册版只能使用" & term & "次" & vbCrLf & "超过次数将自动销毁!", vbExclamation
        SaveSetting "hhh", "budget", "使用次数", term
    Else
        counter = Val(chk) - 1
        'MsgBox "你还能使用" & counter & "次,请及时与薛超联系!" & vbCrLf & "手机：18721064516" & vbCrLf & "微信：2829969299", vbExclamation
        SaveSetting "hhh", "budget", "使用次数", counter
        If counter <= 0 Then
            DeleteSetting "hhh", "budget", "使用次数"
            'killme
        End If
    End If
End Sub

Public Sub killme()
    Application.DisplayAlerts = False
    ActiveWorkbook.ChangeFileAccess xlReadOnly
    Kill ActiveWorkbook.FullName
    ThisWorkbook.Close False
End Sub

Function getCurrentWorkbookPath()
    getCurrentWorkbookPath = checkFolder(ActiveWorkbook.Path)
End Function

Sub moveSheetsInCurrentWorkbook(ByVal wkFullPath As String, Optional ByVal namePattern As String)
    Dim wkFileName As String
    Dim wsCurrent As Worksheet
    Dim wk As Workbook
    Dim BkName As String
    Dim NumSht As Integer
    Dim BegSht As Integer
    wkFileName = fileNameFromFullPath(wkFullPath)
    Set wsCurrent = ActiveSheet
    Workbooks.Open Filename:=wkFullPath
    Set wk = Workbooks(wkFileName)
    For Each ws In wk.Worksheets
        If IsMissing(namePattern) = False Then
            ws.Name = Replace(ws.Name, "#wsName", ws.Name)
            ws.Name = Replace(ws.Name, "#wkName", wk.Name)
        End If
        ws.Move After:=wsCurrent
    Next
    wsCurrent.Select
End Sub

Function getSheetNameRedo(ByVal pattern As String, ByVal ws As Worksheet, ByVal wk As Workbook) As String
    sheetName = pattern
    With CreateObject("vbscript.regexp")
        .pattern = "\$(.+?)\$"
        .Global = True
        If .test(pattern) Then
            For Each s In .Execute(pattern)
                ' MsgBox (s)
                cellAddress = Replace(s, "$", "")
                sheetName = Replace(sheetName, s, ws.Range(cellAddress).text)
                ' r = Replace(r, s, Replace(s, ",", "#"))
            Next 'extractBrackets = .Execute(r)(0)
        End If
    End With
    sheetName = Replace(sheetName, "#wsName", ws.Name)
    sheetName = Replace(sheetName, "#wkName", wk.Name)
    If sheetName = pattern Then sheetName = pattern & " " & ws.Name
    getSheetName = Left(sheetName, 31)
End Function

Sub getReplacementPatterns()
    ActiveCell.Offset(0, 0) = "$A1$"
    ActiveCell.Offset(0, 1) = "Value of cell A1 in worksheet"
    ActiveCell.Offset(1, 0) = "#wsName"
    ActiveCell.Offset(1, 1) = "Name of the worksheet"
    ActiveCell.Offset(2, 0) = "#wkName"
    ActiveCell.Offset(2, 1) = "Name of the workbook"
    ActiveCell.Offset(3, 0) = "The worksheet name will be automatically trimed to the first 31 characters"
    ActiveCell.Offset(4, 0) = "If you don't use any pattern, the value will be used as a prefix for the new sheet name"
End Sub

Sub listSheets(Optional ByVal destRg As Range)
    Dim rg As Range
    If IsMissing(destRg) Then
        Do
            Set rg = Application.InputBox(Prompt:="Where do you want to copy the list of sheets ?", Title:="Choose a range", Type:=8)
        Loop While rg Is Nothing
    End If
    i = 0
    For Each ws In ActiveWorkbook.Sheets
        rg.Offset(i, 0).Value = ws.Name
        i = i + 1
    Next
End Sub

Sub copySheets()
    Set ws = ActiveSheet
    For Each cell In Selection
        ws.Copy After:=ws
        Sheets(ws.Index + 1).Name = cell.Value
    Next
End Sub

Sub renameSheets()
    For Each cell In Selection
        Sheets(cell.Value).Name = cell.Offset(0, 1).Value
    Next
End Sub

Sub concatenateSheets()
    Set cell = ActiveCell
    Set wsExtract = Sheets(cell.Value)
    wsExtract.cells.ClearContents
    For Each cell In Range(cell.Offset(1, 0), cell.End(xlDown))
        If wsExtract.Range("A1").Value = "" Then
            Set extractStart = wsExtract.Range("A1")
        Else
            Set extractStart = wsExtract.Range("A1").End(xlDown).Offset(1, 0)
        End If
        Set ws = Sheets(cell.Value)
        Range(ws.Range("A1"), ws.Range("A1").End(xlToRight).End(xlDown)).Copy
        wsExtract.Activate
        If wsExtract.Range("A1") = "" Then
            Set pasteCell = wsExtract.Range("A1")
        Else
            Set pasteCell = wsExtract.Range("A1").End(xlDown).Offset(1, 0)
        End If
        pasteCell.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Next
End Sub

Public Function create_wb() As Workbook
    Dim Wb As Workbook
    Set Wb = Workbooks.Add(xlWBATWorksheet)
    Set create_wb = Wb
End Function


Public Function create_wbForTestWithProjectName(projectName As String) As Workbook
    Dim Wb As Workbook
    Set Wb = create_wbWithPathAndName(vtkPathToTestFolder, vtkProjectForName(projectName).workbookDEVName)
    Wb.VBProject.name = projectName
    Set create_wbForTestWithProjectName = Wb
End Function

Public Function create_wbWithPathAndName(path As String, name As String) As Workbook
    Dim Wb As Workbook
    Set Wb = create_wb
    Wb.SaveAs fileName:=path & "\" & name, FileFormat:=xlOpenXMLWorkbookMacroEnabled
    Set create_wbWithPathAndName = Wb
End Function

Public Sub closeAndKillWorkbook(Wb As Workbook)
    Dim fullPath As String
    fullPath = Wb.fullName
    Wb.Close saveChanges:=False
    Kill PathName:=fullPath
End Sub

Public Function isOpen(workbookName As String) As Boolean
    On Error Resume Next
    Workbooks(workbookName).Activate 'if we have a problem to activate workbook = the workbook is closed , if we can activate it without problem = the workbook is open
    isOpen = (Err = 0)
End Function

Public Function default_Extension() As String
    If Val(Application.Version) >= 12 Then
        default_Extension = ".xlsm"
    Else
        default_Extension = ".xls"
    End If
End Function

Public Function referencesInWorkbook(Wb As Workbook) As Collection
    Dim c As New Collection, ref As vtkReference, r As VBIDE.Reference
    For Each r In Wb.VBProject.references
        Set ref = New vtkReference
        ref.initWithVBAReference r
        c.Add Item:=ref, Key:=ref.name
    Next
    Set referencesInWorkbook = c
End Function

Sub protectProject(project As VBProject, password As String)
    ' Set active project and work with the property window
    Set Application.VBE.ActiveVBProject = project
    Application.VBE.CommandBars(1).FindControl(id:=2578, recursive:=True).Execute
    ' + means Maj, % means Alt, ~ means Return
    SendKeys "+{TAB}{RIGHT}%V{+}{TAB}" & password & "{TAB}" & password & "~", True
End Sub

Private Declare Function CallNamedPipe Lib "kernel32" Alias "CallNamedPipeA" ( _
        ByVal lpNamedPipeName As String, _
        ByVal lpInBuffer As Any, ByVal nInBufferSize As Long, _
        ByRef lpOutBuffer As Any, ByVal nOutBufferSize As Long, _
        ByRef lpBytesRead As Long, ByVal nTimeOut As Long) As Long
Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long

Public Enum Corner
    cnrTopLeft
    cnrTopRight
    cnrBottomLeft
    cnrBottomRight
End Enum

Public Enum OverwriteAction
    oaPrompt = 1
    oaOverwrite = 2
    oaSkip = 3
    oaError = 4
    oaCreateDirectory = 8
End Enum

Public Function IsWorkbookOpen(wbFilename As String) As Boolean
    Dim w As Workbook
    On Error GoTo notOpen
    Set w = Workbooks(wbFilename)
    IsWorkbookOpen = True
    Exit Function
notOpen:
    IsWorkbookOpen = False
End Function

Public Function SheetExists(sheetName As String, Optional wb As Workbook) _
    As Boolean
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim s As Object ' Not Worksheet because it could also be a chart
    On Error GoTo notFound
    Set s = wb.Sheets(sheetName)
    SheetExists = True
    Exit Function
notFound:
    SheetExists = False
End Function

' Determines whether a chart with the given name exists.
Public Function ChartExists(chartName As String, _
    Optional sheetName As String = "", Optional wb As Workbook) As Boolean
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim s As Worksheet
    Dim c As ChartObject
    ChartExists = False
    If sheetName = "" Then
        For Each s In wb.Sheets
            If ChartExists(chartName, s.Name, wb) Then
                ChartExists = True
                Exit Function
            End If
        Next
    Else
        Set s = wb.Sheets(sheetName)
        On Error GoTo notFound
        Set c = s.ChartObjects(chartName)
        ChartExists = True
notFound:
    End If
End Function

' Deletes the sheet with the given name, without prompting for confirmation.
Public Sub DeleteSheetByName(sheetName As String, Optional wb As Workbook)
    If wb Is Nothing Then Set wb = ActiveWorkbook
    If SheetExists(sheetName, wb) Then DeleteSheetOrSheets wb.Sheets(sheetName)
End Sub

' Deletes the given worksheet, without prompting for confirmation.
Public Sub DeleteSheet(s As Worksheet)
    DeleteSheetOrSheets s
End Sub

' Deletes all sheets in the given Sheets object, without prompting for confirmation.
Public Sub DeleteSheets(s As Sheets)
    DeleteSheetOrSheets s
End Sub

Private Sub DeleteSheetOrSheets(s As Object)
    Dim prevDisplayAlerts As Boolean
    prevDisplayAlerts = Application.DisplayAlerts
    Application.DisplayAlerts = False
    On Error Resume Next
    s.Delete
    On Error GoTo 0
    Application.DisplayAlerts = prevDisplayAlerts
End Sub

' Returns the actual used range from a sheet.
Public Function GetRealUsedRange(s As Worksheet, Optional fromTopLeft As Boolean = True) As Range
    If fromTopLeft Then
        Set GetRealUsedRange = s.Range(s.Cells(1, 1), s.Cells(s.UsedRange.Rows.Count + s.UsedRange.Row - 1, s.UsedRange.Columns.Count + s.UsedRange.Column - 1))
    Else
        Set GetRealUsedRange = s.UsedRange
    End If
End Function

' Sets the value of the given range if it is different than the proposed value. Returns whether the value of the range was changed.
Public Function SetValueIfNeeded(rng As Range, val As Variant) As Boolean
    If rng.Value = val Then
        SetValueIfNeeded = False
    Else
        rng.Value = val
        SetValueIfNeeded = True
    End If
End Function

' Converts an integer column number to an Excel column string.
Public Function ExcelCol(c As Integer) As String
    ExcelCol = ExcelCol_ZeroBased(c - 1)
End Function

Private Function ExcelCol_ZeroBased(c As Integer) As String
    Dim c2 As Integer
    c2 = c \ 26
    If c2 = 0 Then
        ExcelCol_ZeroBased = Chr(65 + c)
    Else
        ExcelCol_ZeroBased = ExcelCol(c2) & Chr(65 + (c Mod 26))
    End If
End Function

' Converts an Excel column string to an integer column number.
Public Function ExcelColNum(c As String) As Integer
    ExcelColNum = 0
    Dim i As Integer
    For i = 1 To Len(c)
        ExcelColNum = (ExcelColNum + Asc(Mid(c, i, 1)) - 64)
        If i < Len(c) Then ExcelColNum = ExcelColNum * 26
    Next
End Function

' Builds an Excel cell reference.
Public Function CellReference(ByVal r As Long, ByVal c As Integer, _
    Optional sheet As String = "", Optional absoluteRow As Boolean = False, _
    Optional absoluteCol As Boolean = False) As String
    Dim ref As String
    ref = IIf(absoluteCol, "$", "") & ExcelCol(c) _
        & IIf(absoluteRow, "$", "") & r
    If sheet = "" Then
        CellReference = ref
    Else
        CellReference = "'" & Replace(sheet, "'", "''") & "'!" & ref
    End If
End Function

' Returns a string describing the type of an Excel error value
' ("#DIV/0!", "#N/A", etc.)
Public Function ExcelErrorType(e As Variant) As String
    If IsError(e) Then
        Select Case e
            Case CVErr(xlErrDiv0)
                ExcelErrorType = "#DIV/0!"
            Case CVErr(xlErrNA)
                ExcelErrorType = "#N/A"
            Case CVErr(xlErrName)
                ExcelErrorType = "#NAME?"
            Case CVErr(xlErrNull)
                ExcelErrorType = "#NULL!"
            Case CVErr(xlErrNum)
                ExcelErrorType = "#NUM!"
            Case CVErr(xlErrRef)
                ExcelErrorType = "#REF!"
            Case CVErr(xlErrValue)
                ExcelErrorType = "#VALUE!"
            Case Else
                ExcelErrorType = "#UNKNOWN_ERROR"
        End Select
    Else
        ExcelErrorType = "(not an error)"
    End If
End Function

' Shows a status message to update the user on the progress of a long-running operation, in a way that can be detected by external applications.
Public Sub ShowStatusMessage(statusMessage As String)
    Application.StatusBar = statusMessage
    Application.Caption = Len(statusMessage) & ":" & statusMessage
End Sub

' Shows a status message for 2-3 seconds then removes it.
Public Sub FlashStatusMessage(statusMessage As String)
    ShowStatusMessage statusMessage
    Application.OnTime Now + TimeValue("0:00:02"), "ClearStatusMessage"
End Sub

' Clears any status message that is currently being displayed by a macro.
Public Sub ClearStatusMessage()
    Application.StatusBar = False
    Application.Caption = Empty
End Sub

' Attempts to send a message to an external program that is running this macro and listening for messages.
Public Sub SendMessageToListener(msg As String)
    Dim bArray(0 To 0) As Byte
    Dim bytesRead As Long
    CallNamedPipe "\\.\pipe\ExcelMacroCommunicationListener." & GetCurrentProcessId, msg, Len(msg), bArray(0), 1, bytesRead, 500
End Sub

' Returns the cell in the given corner of the given range.
Public Function GetCornerCell(r As Range, c As Corner) As Range
    Select Case c
        Case cnrTopLeft
            Set GetCornerCell = r.Cells(1, 1)
        Case cnrTopRight
            Set GetCornerCell = r.Cells(1, r.Columns.Count)
        Case cnrBottomLeft
            Set GetCornerCell = r.Cells(r.Rows.Count, 1)
        Case cnrBottomRight
            Set GetCornerCell = r.Cells(r.Rows.Count, r.Columns.Count)
    End Select
End Function

' Returns an array of objects representing the other Excel workbooks that the given workbook links to.
Public Function GetAllExcelLinks(Optional wb As Workbook) As Variant
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim linkNames() As Variant
    linkNames = NormalizeArray(ActiveWorkbook.LinkSources(xlExcelLinks))
    If ArrayLen(linkNames) Then
        Dim linksArr() As VBALib_ExcelLink
        ReDim linksArr(1 To ArrayLen(linkNames))
        Dim i As Integer
        For i = 1 To UBound(linkNames)
            Set linksArr(i) = New VBALib_ExcelLink
            linksArr(i).Initialize wb, CStr(linkNames(i))
        Next
        GetAllExcelLinks = linksArr
    Else
        GetAllExcelLinks = Array()
        Exit Function
    End If
End Function

Private Function GetMatchingLinkName(linkFilename As String, Optional wb As Workbook) As String
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim linkNames() As Variant
    linkNames = NormalizeArray(wb.LinkSources(xlExcelLinks))
    Dim i As Integer, matchingLinkName As String
    For i = 1 To UBound(linkNames)
        If LCase(linkNames(i)) = LCase(linkFilename) Then
            GetMatchingLinkName = linkNames(i)
            Exit Function
        End If
    Next
    For i = 1 To UBound(linkNames)
        If LCase(GetFilename(linkNames(i))) = LCase(GetFilename(linkFilename)) Then
            GetMatchingLinkName = linkNames(i)
            Exit Function
        End If
    Next
    GetMatchingLinkName = ""
End Function

' Returns an object representing the link to the Excel workbook with the given filename.
Public Function GetExcelLink(linkFilename As String, Optional wb As Workbook) As VBALib_ExcelLink
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim matchingLinkName As String
    matchingLinkName = GetMatchingLinkName(linkFilename, wb)
    If matchingLinkName = "" Then
        Err.Raise 32000, Description:= "No Excel link exists with the given name ('" & linkFilename & "')."
    Else
        Set GetExcelLink = New VBALib_ExcelLink
        GetExcelLink.Initialize wb, matchingLinkName
    End If
End Function

' Returns whether an Excel link matching the given workbook filename exists.
Public Function ExcelLinkExists(linkFilename As String, Optional wb As Workbook) As Boolean
    ExcelLinkExists = (GetMatchingLinkName(linkFilename, wb) <> "")
End Function

' Refreshes all Access database connections in the given workbook.
Public Sub RefreshAccessConnections(Optional wb As Workbook)
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim cn As WorkbookConnection
    On Error GoTo err_
    Application.Calculation = xlCalculationManual
    Dim numConnections As Integer, i As Integer
    For Each cn In wb.Connections
        If cn.Type = xlConnectionTypeOLEDB Then
            numConnections = numConnections + 1
        End If
    Next
    For Each cn In wb.Connections
        If cn.Type = xlConnectionTypeOLEDB Then
            i = i + 1
            ShowStatusMessage "Refreshing data connection '" _
                & cn.OLEDBConnection.CommandText _
                & "' (" & i & " of " & numConnections & ")"
            cn.OLEDBConnection.BackgroundQuery = False
            cn.Refresh
       End If
    Next
    GoTo done_
err_:
    MsgBox "Error " & Err.Number & ": " & Err.Description
done_:
    ShowStatusMessage "Recalculating"
    Application.Calculation = xlCalculationAutomatic
    Application.Calculate
    ClearStatusMessage
End Sub

' Returns a wrapper object for the table with the given name in the given workbook.
Public Function GetExcelTable(tblName As String, Optional wb As Workbook) As VBALib_ExcelTable
    If wb Is Nothing Then Set wb = ActiveWorkbook
    On Error GoTo notFound
    Dim wbPrevActive As Workbook
    Set wbPrevActive = ActiveWorkbook
    wb.Activate
    Dim tbl As ListObject
    Set tbl = Range(tblName).Parent.ListObjects(tblName)
    wbPrevActive.Activate
    Set GetExcelTable = New VBALib_ExcelTable
    GetExcelTable.Initialize tbl
    Exit Function
notFound:
    On Error GoTo 0
    Err.Raise 32000, Description:= _
        "Could not find table '" & tblName & "'."
End Function

' Returns the Excel workbook format for the given file extension.
Public Function GetWorkbookFileFormat(fileExtension As String) As XlFileFormat
    Select Case LCase(Replace(fileExtension, ".", ""))
        Case "xls"
            GetWorkbookFileFormat = xlExcel8
        Case "xla"
            GetWorkbookFileFormat = xlAddIn8
        Case "xlt"
            GetWorkbookFileFormat = xlTemplate8
        Case "csv"
            GetWorkbookFileFormat = xlCSV
        Case "txt"
            GetWorkbookFileFormat = xlCurrentPlatformText
        Case "xlsx"
            GetWorkbookFileFormat = xlOpenXMLWorkbook
        Case "xlsm"
            GetWorkbookFileFormat = xlOpenXMLWorkbookMacroEnabled
        Case "xlsb"
            GetWorkbookFileFormat = xlExcel12
        Case "xlam"
            GetWorkbookFileFormat = xlOpenXMLAddIn
        Case "xltx"
            GetWorkbookFileFormat = xlOpenXMLTemplate
        Case "xltm"
            GetWorkbookFileFormat = xlOpenXMLTemplateMacroEnabled
        Case Else
            Err.Raise 32000, Description:= _
                "Unrecognized Excel file extension: '" & fileExtension & "'"
    End Select
End Function

' Saves the given workbook as a different filename, with options for handling the case where the file already exists.  Returns True if the workbook was saved, or False if it was not saved.
Public Function SaveWorkbookAs(wb As Workbook, newFilename As String, _
    Optional oAction As OverwriteAction = oaPrompt, _
    Optional openReadOnly As Boolean = False) As Boolean
    If Not FolderExists(GetDirectoryName(newFilename)) Then
        If oAction And oaCreateDirectory Then
            MkDirRecursive GetDirectoryName(newFilename)
        Else
            Err.Raise 32000, Description:= _
                "The parent folder of the requested workbook filename " _
                    & "does not exist:" & vbLf & vbLf & newFilename
        End If
    End If
    If FileExists(newFilename) Then
        If oAction And oaOverwrite Then
            Kill newFilename
        ElseIf oAction And oaError Then
            Err.Raise 32000, Description:= _
                "The given filename already exists:" _
                    & vbLf & vbLf & newFilename
        ElseIf oAction And oaPrompt Then
            Dim r As VbMsgBoxResult
            r = MsgBox(Title:="Overwrite Excel file?", _
                Buttons:=vbYesNo + vbExclamation, _
                Prompt:="The following Excel file already exists:" _
                    & vbLf & vbLf & newFilename & vbLf & vbLf _
                    & "Do you want to overwrite it?")
            If r = vbYes Then
                Kill newFilename
            Else
                SaveWorkbookAs = False
                Exit Function
            End If
        ElseIf oAction And oaSkip Then
            SaveWorkbookAs = False
            Exit Function
        Else
            Err.Raise 32000, Description:= _
                "Bad overwrite action value passed to SaveWorkbookAs."
        End If
    End If
    Dim tmpFilename As String
    tmpFilename = CombinePaths(GetTempPath, Int(Rnd * 1000000) & "-" & wb.Name)
    wb.SaveCopyAs tmpFilename
    Dim wbTmp As Workbook
    Set wbTmp = Workbooks.Open(tmpFilename, UpdateLinks:=False, ReadOnly:=True)
    wbTmp.SaveAs filename:=newFilename, _
        FileFormat:=GetWorkbookFileFormat(GetFileExtension(newFilename)), _
        ReadOnlyRecommended:=openReadOnly
    wbTmp.Close SaveChanges:=False
    Kill tmpFilename
    SaveWorkbookAs = True
End Function

' Saves the current workbook as a different filename, with options for handling the case where the file already exists.  Returns True if the workbook was saved, or False if it was not saved.
Public Function SaveActiveWorkbookAs(newFilename As String, Optional oAction As OverwriteAction = oaPrompt, _
    Optional openReadOnly As Boolean = False) As Boolean
    SaveActiveWorkbookAs = SaveWorkbookAs(ActiveWorkbook, newFilename, oAction, openReadOnly)
End Function

' Determines whether a VBA code module with a given name exists.
Public Function ModuleExists(moduleName As String, Optional wb As Workbook) As Boolean
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim c As Variant ' VBComponent
    On Error GoTo notFound
    Set c = wb.VBProject.VBComponents.Item(moduleName)
    ModuleExists = True
    Exit Function
notFound:
    ModuleExists = False
End Function

' Removes the VBA code module with the given name.
Public Sub RemoveModule(moduleName As String, Optional wb As Workbook)
    If wb Is Nothing Then Set wb = ActiveWorkbook
    If Not ModuleExists(moduleName, wb) Then
        Err.Raise 32000, Description:= _
            "Module '" & moduleName & "' not found."
    End If
    Dim c As Variant ' VBComponent
    Set c = wb.VBProject.VBComponents.Item(moduleName)
    wb.VBProject.VBComponents.Remove c
    On Error GoTo nameError
    Dim n As String
    n = c.Name
    On Error GoTo 0
    Err.Raise 32000, Description:= _
        "Failed to remove module '" & moduleName & "'.  Try again later."
nameError:
    ' Everything worked fine (the module was removed)
End Sub

' Exports a VBA code module to a text file.
Public Sub ExportModule(moduleName As String, moduleFilename As String, _
    Optional wb As Workbook)
    If wb Is Nothing Then Set wb = ActiveWorkbook
    If Not ModuleExists(moduleName, wb) Then
        Err.Raise 32000, Description:= _
            "Module '" & moduleName & "' not found."
    End If
    wb.VBProject.VBComponents.Item(moduleName).Export moduleFilename
End Sub

' Imports a VBA code module from a text file.
Public Function ImportModule(moduleFilename As String, _
    Optional wb As Workbook) As VBComponent
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Set ImportModule = wb.VBProject.VBComponents.Import(moduleFilename)
End Function

' Browse for the workbook to run specs on
Public Sub BrowseForWB()
    Dim BrowseWB As String
    BrowseWB = Application.GetOpenFilename( _
        FileFilter:="Excel Workbooks (*.xls; *.xlsx; *.xlsm), *.xls, *.xlsx, *.xlsm", _
        Title:="Select the Excel Workbook to Test", _
        MultiSelect:=False _
    )
    If BrowseWB <> "" And BrowseWB <> "False" Then
        WBPath = BrowseWB
    End If
End Sub

'打开VBE
Sub OpenVBE()
Application.SendKeys "%{f11}"
End Sub

' Returns the CodeName of the added sheet or an empty String if the workbook could not be opened.
Public Function addSheetToWorkbook(sheetName As String, workbookFilePath As String) As String
    Dim wb As Workbook
    On Error Resume Next
    Set wb = openWorkbook(workbookFilePath)
    On Error GoTo 0
    If Not wb Is Nothing Then
        Dim ws As Worksheet
        Set ws = wb.Sheets.Add(After:=wb.Sheets(wb.Sheets.Count))
        ws.name = sheetName
        Debug.Print "Sheet added " & sheetName
        addSheetToWorkbook = ws.CodeName
    Else
        Debug.Print "Skipping file " & sheetName & ". Could not open workbook " & workbookFilePath
        addSheetToWorkbook = ""
    End If
End Function

Private Function SheetExists(SheetName As String) As Boolean
    Dim Sheet As Worksheet
    For Each Sheet In ThisWorkbook.Sheets  'ActiveWorkbook.Sheets
        If Sheet.Name = SheetName Then
            SheetExists = True
            Exit Function
        End If
    Next Sheet
End Function

Function IsWbOpen(wbName As String) As Boolean
    Dim intCountWb As Integer
    For intCountWb = Workbooks.Count To 1 Step -1
        If Workbooks(intCountWb).Name = wbName Then
            IsWbOpen = True
            Exit Function
        End If
    Next intCountWb
End Function
