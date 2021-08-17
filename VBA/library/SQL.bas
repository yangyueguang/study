Attribute VB_Name = "SQL"
'引用Microsoft ActiveX Data Objects 2.x Library
Dim cnn As ADODB.Connection '声明模块级变量，启动窗体后不必重复连接数据库
Dim rs As ADODB.Recordset
Dim ary(1) As String

Public Function ExecuteSQL(ByVal SQLcommand As String, MsgString As String) As ADODB.Recordset
    Dim MyCnn As ADODB.Connection
    Dim MyRecordset As ADODB.Recordset
    Dim sTokens() As String
    On Error GoTo ExecuteSQL_Error
    sTokens = Splits(SQLcommand)
    Set MyCnn = New ADODB.Connection
    MyCnn.Open MyConnectString
    If InStr("INSERT,DELETE,UPDATE", UCase(sTokens(0))) Then
        MyCnn.Execute SQLcommand
        MsgString = sTokens(0) & "Query successful"
    Else
        Set MyRecordset = New ADODB.Recordset
        MyRecordset.Open Trim(SQLcommand), MyCnn, adOpenKeyset, adLockOptimistic
        Set ExecuteSQL = MyRecordset
        MsgString = "共查询到" & MyRecordset.RecordCount & "条记录"
    End If
ExecuteSQL_Exit:
    Set MyRecordset = Nothing
    Set MyCnn = Nothing
    Exit Function
ExecuteSQL_Error:
    MsgString = "查询错误：" & Err.Description
    Resume ExecuteSQL_Exit
End Function

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer) '退出窗体时释放内存
    cnn.Close
    Set rs = Nothing
    Set cnn = Nothing
End Sub

'数组法，速度稍慢，导出的工作表电话号码是常规型
Private Sub output_to_excel()
    If rs.RecordCount = 0 Then Exit Sub '没有记录则退出
    Dim arr(), i&, j&
    On Error Resume Next
    ReDim arr(rs.Fields.Count - 1)
    For i = 0 To rs.Fields.Count - 1 '逐个字段
        arr(i) = rs.Fields(i).name '取字段名
    Next i
    With Workbooks.Add(xlWBATWorksheet).ActiveSheet '新建只有一张工作表的工作簿
        With .Cells(1, 1).Resize(, rs.Fields.Count) '表头区域
            .Value = arr '写表头
            .Font.Bold = True '黑体
            .HorizontalAlignment = xlCenter '垂直居中
        End With
        ReDim arr(1 To rs.RecordCount, rs.Fields.Count - 1) '重新声名记录数组
        For i = 1 To rs.RecordCount '逐条记录
            For j = 0 To rs.Fields.Count - 1 '逐个字段
                arr(i, j) = rs.Fields(j) '数据写入数组
            Next j
            rs.MoveNext '显示下一条记录
        Next i
        With .Cells(2, 1).Resize(rs.RecordCount, rs.Fields.Count) '数据区域
            .Value = arr '写数据
            .EntireColumn.AutoFit '自动调整列宽
        End With
    End With
End Sub

Private Sub 添加记录_Click()
    Dim rst As ADODB.Recordset
    Dim i&, SQL$, temp$
    For i = 1 To 6 Step 5 '这里设置姓名和工作部门字段不能为空
        If Me.Controls("TextBox" & i).Text = "" Then
            MsgBox rs.Fields(i - 1).name & "不能为空！", vbCritical
            Me.Controls("TextBox" & i).SetFocus
            Exit Sub
        End If
        temp = temp & " and " & rs.Fields(i - 1).name & " = " & "'" & Me.Controls("TextBox" & i).Text & "'" '姓名和工作部门都相同的视为同一个人
    Next i
    On Error Resume Next
    Set rst = New ADODB.Recordset
    SQL = "select * from 数据库 where " & Mid(temp, 5)
    rst.Open SQL, cnn, adOpenKeyset, adLockOptimistic
    If rst.RecordCount > 0 Then '同一个部门中不能出现重名
        MsgBox "数据库中已经存在该记录！", vbInformation, "添加失败"
        Set rst = Nothing
        Exit Sub
    End If
    Set rst = New ADODB.Recordset
    SQL = "select * from 数据库"
    rst.Open SQL, cnn, adOpenKeyset, adLockOptimistic
    '开始添加数据
    With rst
        .AddNew    '添加各个字段的数据
        For i = 0 To rst.Fields.Count - 1
            .Fields(i) = Me.Controls("TextBox" & i + 1).Text
        Next i
        .Update    '更新数据表
    End With
    Set rst = Nothing
    If 模糊查询.Text = "" Then Call 显示数据(SQL) Else 模糊查询.Text = "" '刷新ListView1数据
    MsgBox "已经将新人员数据添加到数据库！", vbInformation, "添加记录"
End Sub

Private Sub 删除记录_Click()
    Dim rst As ADODB.Recordset
    Dim i&, SQL$, temp$
    For i = 1 To 6 Step 5 '这里设置姓名和工作部门字段不能为空
        If Me.Controls("TextBox" & i).Text = "" Then
            MsgBox rs.Fields(i - 1).name & "不能为空！", vbCritical
            Me.Controls("TextBox" & i).SetFocus
            Exit Sub
        End If
    Next
'    For i = 1 To 6 '逐个文本框
'       temp = temp & " and " & rs.Fields(i - 1).Name & " = " & "'" & Me.Controls("TextBox" & i).Text & "'" '所有数据必须全匹配
'    Next i
    For i = 1 To 6 Step 5
       temp = temp & " and " & rs.Fields(i - 1).name & " = " & "'" & Me.Controls("TextBox" & i).Text & "'" '姓名和工作部门都相同的视为同一个人
    Next i
    On Error Resume Next
    Set rst = New ADODB.Recordset
    SQL = "select * from 数据库 where " & Mid(temp, 5)
    rst.Open SQL, cnn, adOpenKeyset, adLockOptimistic
    If rst.RecordCount = 0 Then
        MsgBox "没有查到该记录！", vbInformation, "删除记录"
        Set rst = Nothing
        Exit Sub
    End If
    Set rst = New ADODB.Recordset
    SQL = "delete from  数据库 where " & Mid(temp, 5) '删除记录语句
    Set rst = cnn.Execute(SQL) '执行删除语句
    Set rst = Nothing
    SQL = "select * from 数据库 "
    If 模糊查询.Text = "" Then Call 显示数据(SQL) Else 模糊查询.Text = "" '刷新ListView1数据
    Call 清空文本框
    MsgBox "已将该记录从数据库中删除！", vbInformation, "删除记录"
End Sub

Private Sub 修改记录_Click()
    If TextBox1.Text = "" Or TextBox6.Text = "" Then
        MsgBox "姓名和工作部门不能为空！", vbInformation, "修改记录"
        Exit Sub '姓名或工作部门为空则退出
    End If
    Dim rst As New ADODB.Recordset
    Dim SQL$, temp$, i&, j&, s$
    For i = 0 To rs.Fields.Count - 1 '逐个字段
        temp = temp & rs.Fields(i).name & " = '" & Me.Controls("TextBox" & i + 1).Text & "'," '更新记录字符串
    Next i
    On Error Resume Next
    SQL = "update 数据库 set " & Left(temp, Len(temp) - 1) & " where " & rs.Fields(0).name & "='" & ary(0) & "' and " & rs.Fields(i - 1).name & "='" & ary(1) & "'"  '姓名和工作部门都相同的视为同一个人
    rst.Open SQL, cnn, adOpenKeyset, adLockOptimistic '执行更新
    Set rst = Nothing
    SQL = "select * from 数据库 "
    If 模糊查询.Text = "" Then Call 显示数据(SQL) Else 模糊查询.Text = "" '刷新ListView1数据
    Call 清空文本框
    MsgBox "已在数据库中将该记录修改！", vbInformation, "修改记录"
End Sub

Private Sub 模糊查询_Change() '模糊查询
    Dim SQL$, temp$, i&, j&, s$
    temp = 模糊查询.Text
    SQL = "select * from 数据库 "
    If temp <> "" Then '模糊查询.Text不为空
        For i = 0 To rs.Fields.Count - 1 '逐个字段
            s = s & " or " & rs.Fields(i).name & " like '%" & temp & "%'" '查询字符串
        Next i
        SQL = SQL & " where " & Mid(s, 4)
    End If
    If temp <> ComboBox1.Value Then ComboBox1.ListIndex = -1 '清除ComboBox1可能显示的部门
    Call 显示数据(SQL) '刷新ListView1数据
'    模糊查询.SetFocus
    Call 清空文本框
End Sub

Private Sub UserForm_Initialize()
    Dim SQL$, i&, j&, arr, a
    a = Array(55.5, 67.5, 81, 72.78, 67.5, 83.28) 'ListView1列宽
    Set cnn = New ADODB.Connection
    cnn.Open "provider=Microsoft.jet.OLEDB.4.0;data source=" & ThisWorkbook.Path & "\电话号码.mdb"
    SQL = "select * from 数据库 "
    Set rs = New ADODB.Recordset
    rs.Open SQL, cnn, adOpenKeyset, adLockOptimistic
    On Error Resume Next
    With ListView1
        '设置ListView1的标题、显示类型、整行选择和网格线属性
        .ColumnHeaders.Clear
        .View = lvwReport        '   listivew的显示格式为报表格式
        .FullRowSelect = True    '   允许整行选中
        .Gridlines = True        '   显示网格线
        '为ListView1设置标题
        For i = 0 To rs.Fields.Count - 1
            If i > 0 Then
                .ColumnHeaders.Add , , rs.Fields(i).name, a(i), lvwColumnCenter '从第2列起居中
            Else
                .ColumnHeaders.Add , , rs.Fields(i).name, a(i)
            End If
        Next i
    End With
    Call 显示数据(SQL) '为ListView1设置各行数据
    arr = cnn.Execute("select distinct " & rs.Fields(i - 1).name & " from 数据库 where " & rs.Fields(i - 1).name & " is not null ").GetRows '不重复的工作部门，为了修改字段名后不受影响使用了rs.Fields(i - 1).Name来代替“工作部门”
    ComboBox1.list = WorksheetFunction.Transpose(arr) '不重复的工作部门赋值给组合框
    模糊查询.SetFocus
End Sub

Private Sub ListView1_ItemClick(ByVal Item As MSComctlLib.ListItem) 'ListView1单击事件
    Dim i&
    TextBox1.Text = Item '首列数据赋给姓名文本框
    ary(0) = Item '姓名存放到数组作为删除记录的姓名查询条件
    With ListView1
        For i = 1 To 5 '逐列数据写入文本框
            Controls("TextBox" & i + 1) = .ListItems(Item.index).SubItems(i)
        Next i
        ary(1) = .ListItems(Item.index).SubItems(i - 1) '工作单位存放到数组作为删除记录的工作单位查询条件
    End With
End Sub

Public Sub 显示数据(strsql As String) '为ListView1设置各行数据
    Dim i&, j&
    On Error Resume Next
    Set rs = New ADODB.Recordset
    rs.Open strsql, cnn, adOpenKeyset, adLockOptimistic
    With ListView1
        .ListItems.Clear
        For i = 1 To rs.RecordCount
            .ListItems.Add , , rs.Fields(0).Value
            For j = 1 To rs.Fields.Count - 1
                .ListItems(i).SubItems(j) = rs.Fields(j).Value
            Next j
            rs.MoveNext
        Next i
    End With
    rs.MoveFirst
    Label2.Caption = "共查到 " & ListView1.ListItems.Count & " 条记录"
End Sub

Public Sub 清空文本框()
    Dim i%
    For i = 1 To 6
       Me.Controls("TextBox" & i).Text = ""
    Next i
End Sub

'Run SQL command without warning msg
Public Sub RunSQL_CmdWithoutWarning(SQL_cmd As String)
    DoCmd.SetWarnings False
    Application.SetOption "Confirm Action Queries", False
    DoCmd.RunSQL SQL_cmd
    Application.SetOption "Confirm Action Queries", True
    DoCmd.SetWarnings True
End Sub

'To create an expression that consists of a set of vector columns aggregated in a specified pattern
Public Function CreateSqlSeg_VectorColAgg(col_pattern As String, str_agg As String, Idx_start As Integer, Idx_end As Integer, Optional wildcard As String = "#") As String
    On Error GoTo Err_CreateSqlSeg_VectorColAgg
    Dim SQL_Seg As String
    Dim col_idx As Integer
    For col_idx = Idx_start To Idx_end
        SQL_Seg = SQL_Seg & Replace(col_pattern, wildcard, col_idx) & " " & str_agg & " "
    Next col_idx
    SQL_Seg = Left(SQL_Seg, Len(SQL_Seg) - 2)
Exit_CreateSqlSeg_VectorColAgg:
    CreateSqlSeg_VectorColAgg = SQL_Seg
    Exit Function
Err_CreateSqlSeg_VectorColAgg:
    ShowMsgBox (Err.Description)
    Resume Exit_CreateSqlSeg_VectorColAgg
End Function

'Re-Select table columns
Public Sub ModifyTbl_ReSelect(Tbl_name, str_select)
    Dim Tbl_T_name As String
    Tbl_T_name = Tbl_name & "_temp"
    DelTable (Tbl_T_name)
    SQL_cmd = "SELECT " & str_select & " " & vbCrLf & _
                "INTO [" & Tbl_T_name & "]" & vbCrLf & _
                "FROM [" & Tbl_name & "]" & vbCrLf & _
                ";"
    RunSQL_CmdWithoutWarning (SQL_cmd)
    DelTable (Tbl_name)
    DoCmd.Rename Tbl_name, acTable, Tbl_T_name
End Sub

'Update multiple columns of a table under the same condition
Public Function UpdateTblColBatchly(Tbl_src_name As String, Str_Col_Update As String, SQL_Format_Set As String, SQL_Format_Where As String) As String
    On Error GoTo Err_UpdateTblColBatchly
    Dim FailedReason As String
    If TableExist(Tbl_src_name) = False Then
        FailedReason = Tbl_src_name & "does not exist!"
        GoTo Exit_UpdateTblColBatchly
    End If
    Str_Col_Update = Trim(Str_Col_Update)
    If Str_Col_Update = "*" Then
        With CurrentDb
            Dim RS_Tbl_src As Recordset
            Set RS_Tbl_src = .OpenRecordset(Tbl_src_name)
            Dim fld_idx As Integer
            With RS_Tbl_src
                For fld_idx = 0 To .Fields.count - 1
                    Call UpdateTblCol(Tbl_src_name, .Fields(fld_idx).Name, SQL_Format_Set, SQL_Format_Where)
                Next fld_idx
                .Close
            End With 'RS_Tbl_src
            .Close
        End With 'CurrentDb
    Else
        Dim Col_Update As Variant
        Col_Update = SplitStrIntoArray(Str_Col_Update, ",")
        Dim Col_Idx As Integer
        Dim ColName As String
        For Col_Idx = 0 To UBound(Col_Update)
            ColName = Col_Update(Col_Idx)
            Call UpdateTblCol(Tbl_src_name, ColName, SQL_Format_Set, SQL_Format_Where)
        Next Col_Idx
    End If
Exit_UpdateTblColBatchly:
    UpdateTblColBatchly = FailedReason
    Exit Function
Err_UpdateTblColBatchly:
    FailedReason = Err.Description
    Resume Exit_UpdateTblColBatchly
End Function

'Update a column of a table under a specified condition
Public Function UpdateTblCol(Tbl_src_name As String, ColName As String, SQL_Format_Set, SQL_Format_Where As String) As String
    On Error GoTo Err_UpdateTblCol
    Dim FailedReason As String
    If TableExist(Tbl_src_name) = False Then
        FailedReason = Tbl_src_name & "does not exist!"
        GoTo Exit_UpdateTblCol
    End If
    Dim SQL_Seg_Set As String
    Dim SQL_Seg_Where As String
    Dim SQL_cmd As String
    SQL_Seg_Set = "SET [" & ColName & "] = " & Replace(SQL_Format_Set, "*", "[" & ColName & "]") & " "
    If SQL_Format_Where <> "" Then
        SQL_Seg_Where = "WHERE " & Replace(SQL_Format_Where, "*", "[" & ColName & "]")
    End If
    SQL_cmd = "UPDATE " & Tbl_src_name & " " & vbCrLf & _
                SQL_Seg_Set & " " & vbCrLf & _
                SQL_Seg_Where & " " & vbCrLf & _
                ";"
    RunSQL_CmdWithoutWarning (SQL_cmd)
Exit_UpdateTblCol:
    UpdateTblCol = FailedReason
    Exit Function
Err_UpdateTblCol:
    FailedReason = Err.Description
    Resume Exit_UpdateTblCol
End Function

'Create Table with dedicated Column and Expressions from a source table
Public Function CreateTbl_ColAndExpr(Tbl_src_name As String, Str_Col_Id As String, Str_Col_Order As String, SQL_Seg_ColAndExpr As String, SQL_Seg_Where As String, Tbl_output_name As String) As String
    On Error GoTo Err_CreateTbl_ColAndExpr
    Dim FailedReason As String
    If TableExist(Tbl_src_name) = False Then
        FailedReason = Tbl_src_name & "does not exist!"
        GoTo Exit_CreateTbl_ColAndExpr
    End If
    Dim Col_Id As Variant
    Dim Col_Order As Variant
    Col_Id = SplitStrIntoArray(Str_Col_Id, ",")
    Col_Order = SplitStrIntoArray(Str_Col_Order, ",")
    DelTable (Tbl_output_name)
    Dim SQL_Seg_Select As String
    Dim SQL_Seg_OrderBy As String
    SQL_Seg_Select = "SELECT "
    SQL_Seg_OrderBy = ""
    Dim Col_Idx As Integer
    For Col_Idx = 0 To UBound(Col_Id)
        SQL_Seg_Select = SQL_Seg_Select & "[" & Col_Id(Col_Idx) & "], "
    Next Col_Idx
    If SQL_Seg_ColAndExpr <> "" Then
        SQL_Seg_Select = SQL_Seg_Select & SQL_Seg_ColAndExpr
    Else
        SQL_Seg_Select = Left(SQL_Seg_Select, Len(SQL_Seg_Select) - 2)
    End If
    SQL_Seg_Select = SQL_Seg_Select & SQL_Seg_ColAndExpr
    If UBound(Col_Order) >= 0 Then
        SQL_Seg_OrderBy = "ORDER BY "
        For Col_Idx = 0 To UBound(Col_Order)
            SQL_Seg_OrderBy = SQL_Seg_OrderBy & "[" & Col_Order(Col_Idx) & "], "
        Next Col_Idx
        SQL_Seg_OrderBy = Left(SQL_Seg_OrderBy, Len(SQL_Seg_OrderBy) - 2)
    End If
    If SQL_Seg_Where <> "" Then
        SQL_Seg_Where = "WHERE " & SQL_Seg_Where
    End If
    Dim SQL_cmd As String
    SQL_cmd = SQL_Seg_Select & " " & vbCrLf & _
                "INTO [" & Tbl_output_name & "] " & vbCrLf & _
                "FROM [" & Tbl_src_name & "] " & vbCrLf & _
                SQL_Seg_Where & " " & vbCrLf & _
                SQL_Seg_OrderBy & " " & vbCrLf & _
                ";"
    'MsgBox SQL_cmd
    RunSQL_CmdWithoutWarning (SQL_cmd)
Exit_CreateTbl_ColAndExpr:
    CreateTbl_ColAndExpr = FailedReason
    Exit Function
Err_CreateTbl_ColAndExpr:
    FailedReason = Err.Description
    Resume Exit_CreateTbl_ColAndExpr
End Function

'Create Table of group function, there is a default Group function for all columns, columns can be specified to different group fucntion
Public Function CreateTbl_Group(Tbl_input_name As String, Tbl_output_name As String, Str_Col_Group As String, Optional Str_GroupFunc_all As String = "", Optional GF_all_dbTypes As Variant = "", Optional Str_Col_UnSelected As String = "", Optional ByVal GroupFunc_Col_Pairs As Variant = "", Optional SQL_Seg_Where As String = "", Optional Str_Col_Order As String = "") As String
    On Error GoTo Err_CreateTbl_Group
    Dim FailedReason As String
    If TableValid(Tbl_input_name) = False Then
        FailedReason = Tbl_input_name & " is not valid!"
        GoTo Exit_CreateTbl_Group
    End If
    If Len(Str_Col_Group) = 0 Then
        FailedReason = "No Any Group Columns"
        GoTo Exit_CreateTbl_Group
    End If
    If Str_GroupFunc_all <> "" Then
        If UBound(GF_all_dbTypes) < 0 Then
            FailedReason = "No db Type is assigned for the general group function"
            GoTo Exit_CreateTbl_Group
        End If
    End If
    If VarType(GroupFunc_Col_Pairs) <> vbArray + vbVariant Then
        If Str_GroupFunc_all = "" Then
            FailedReason = "No Any Group Functions for all or specified columns"
            GoTo Exit_CreateTbl_Group
        Else
            GroupFunc_Col_Pairs = Array()
        End If
    End If
    Dim GF_C_P_idx As Integer
    For GF_C_P_idx = 0 To UBound(GroupFunc_Col_Pairs)
        GroupFunc_Col_Pairs(GF_C_P_idx)(1) = SplitStrIntoArray(GroupFunc_Col_Pairs(GF_C_P_idx)(1) & "", ",")
    Next GF_C_P_idx
    Str_GroupFunc_all = Trim(Str_GroupFunc_all)
    Dim col_idx As Integer
    Dim Col_Group As Variant
    Dim Col_UnSelected As Variant
    Dim Col_Order As Variant
    Col_Group = SplitStrIntoArray(Str_Col_Group, ",")
    Col_UnSelected = SplitStrIntoArray(Str_Col_UnSelected, ",")
    Col_Order = SplitStrIntoArray(Str_Col_Order, ",")
    DelTable (Tbl_output_name)
    With CurrentDb
        Dim RS_Tbl_input As Recordset
        Set RS_Tbl_input = .OpenRecordset(Tbl_input_name)
        With RS_Tbl_input
            Dim SQL_Seg_Select As String
            Dim SQL_Seg_GroupBy As String
            Dim SQL_Seg_OrderBy As String
            SQL_Seg_Select = "SELECT "
            SQL_Seg_GroupBy = "GROUP BY "
            SQL_Seg_OrderBy = ""
            Dim fld_idx As Integer
            Dim fld_name As String
            Dim IsColForGroupBy As Boolean
            Dim NumOfCol_Group_found As Integer
            NumOfCol_Group_found = 0
            Dim Col_GroupBy As Variant
            Dim GroupFunc_Col_Pair As Variant
            Dim GroupFunc As String
            For fld_idx = 0 To .Fields.count - 1
                fld_name = .Fields(fld_idx).Name
                IsColForGroupBy = False
                If NumOfCol_Group_found <= UBound(Col_Group) Then
                    If FindStrInArray(Col_Group, fld_name) > -1 Then
                        SQL_Seg_GroupBy = SQL_Seg_GroupBy & "[" & fld_name & "], "
                        IsColForGroupBy = True
                        NumOfCol_Group_found = NumOfCol_Group_found + 1
                    End If
                End If
                If IsColForGroupBy = True Then
                    SQL_Seg_Select = SQL_Seg_Select & "[" & fld_name & "], "
                ElseIf FindStrInArray(Col_UnSelected, fld_name) < 0 Then
                    GroupFunc = ""
                    For Each GroupFunc_Col_Pair In GroupFunc_Col_Pairs
                        If FindStrInArray(GroupFunc_Col_Pair(1), fld_name) > -1 Then
                            GroupFunc = GroupFunc_Col_Pair(0)
                        End If
                    Next GroupFunc_Col_Pair
                    If GroupFunc = "" And Str_GroupFunc_all <> "" Then
                        For Each GF_all_dbType In GF_all_dbTypes
                            If .Fields(fld_idx).Type = GF_all_dbType Then
                                GroupFunc = Str_GroupFunc_all
                            End If
                        Next GF_all_dbType
                    End If
                    If GroupFunc <> "" Then
                        SQL_Seg_Select = SQL_Seg_Select & GroupFunc & "([" & Tbl_input_name & "].[" & fld_name & "]) AS [" & fld_name & "], "
                    End If
                End If
Next_CreateTbl_Group_1:
            Next fld_idx
            SQL_Seg_Select = Left(SQL_Seg_Select, Len(SQL_Seg_Select) - 2)
            SQL_Seg_GroupBy = Left(SQL_Seg_GroupBy, Len(SQL_Seg_GroupBy) - 2)
            .Close
        End With 'RS_Tbl_input
        If UBound(Col_Order) >= 0 Then
            SQL_Seg_OrderBy = "ORDER BY "
            For col_idx = 0 To UBound(Col_Order)
                SQL_Seg_OrderBy = SQL_Seg_OrderBy & "[" & Col_Order(col_idx) & "], "
            Next col_idx
            SQL_Seg_OrderBy = Left(SQL_Seg_OrderBy, Len(SQL_Seg_OrderBy) - 2)
        End If
        If SQL_Seg_Where <> "" Then
            SQL_Seg_Where = "WHERE " & SQL_Seg_Where
        End If
        Dim SQL_cmd As String
        SQL_cmd = SQL_Seg_Select & " " & vbCrLf & _
                    "INTO [" & Tbl_output_name & "] " & vbCrLf & _
                    "FROM [" & Tbl_input_name & "] " & vbCrLf & _
                    SQL_Seg_Where & " " & vbCrLf & _
                    SQL_Seg_GroupBy & " " & vbCrLf & _
                    SQL_Seg_OrderBy & " " & vbCrLf & _
                    ";"
        'MsgBox SQL_cmd
        RunSQL_CmdWithoutWarning (SQL_cmd)
        .Close
    End With 'CurrentDb
Exit_CreateTbl_Group:
    CreateTbl_Group = FailedReason
    Exit Function
Err_CreateTbl_Group:
    FailedReason = Err.Description
    Resume Exit_CreateTbl_Group
End Function


'Create a set of grouped table, the grouping config is set in a specified table
Public Function CreateTbls_Group(Tbl_MT_name As String) As String
    On Error GoTo Err_CreateTbls_Group
    Dim FailedReason As String
    If TableExist(Tbl_MT_name) = False Then
        FailedReason = Tbl_MT_name & " does not exist!"
        GoTo Exit_CreateTbls_Group
    End If
    With CurrentDb
        Dim RS_Tbl_MT As Recordset
        Set RS_Tbl_MT = .OpenRecordset(Tbl_MT_name)
        With RS_Tbl_MT
            Dim FailedReason_1 As String
            Dim Tbl_src_name As String
            Dim Tbl_Group_name As String
            Dim Str_Col_Group As String
            Dim Str_Col_UnSelected As String
            Dim Str_GroupFunc_all As String
            Dim GF_all_dbTypes As Variant
            Dim GroupFunc_Col_Pairs As Variant
            Dim SQL_Seg_Where As String
            Dim Str_Col_Order As String
            .MoveFirst
            Do Until .EOF
                If .Fields("Enable").Value = False Then
                    GoTo Loop_CreateTbls_Group_1
                End If
                Tbl_src_name = .Fields("Tbl_src").Value
                If TableExist(Tbl_src_name) = False Then
                    GoTo Loop_CreateTbls_Group_1
                End If
                Tbl_Group_name = .Fields("Tbl_Group").Value
                If Len(Tbl_Group_name) = 0 Then
                    GoTo Loop_CreateTbls_Group_1
                End If
                If IsNull(.Fields("Col_Group").Value) = True Then
                    GoTo Loop_CreateTbls_Group_1
                End If
                If IsNull(.Fields("GroupFunc_all").Value) = True Then
                    Str_GroupFunc_all = ""
                Else
                    Str_GroupFunc_all = .Fields("GroupFunc_all").Value
                End If
                GF_all_dbTypes = Array(dbInteger, dbLong, dbSingle, dbDouble, dbDecimal)
                If IsNull(.Fields("Col_Sum").Value) = True Then
                    Str_Col_Sum = ""
                Else
                    Str_Col_Sum = .Fields("Col_Sum").Value
                End If
                If IsNull(.Fields("Col_Avg").Value) = True Then
                    Str_Col_Avg = ""
                Else
                    Str_Col_Avg = .Fields("Col_Avg").Value
                End If
                If IsNull(.Fields("Col_Max").Value) = True Then
                    Str_Col_Max = ""
                Else
                    Str_Col_Max = .Fields("Col_Max").Value
                End If
                GroupFunc_Col_Pairs = Array(Array("SUM", Str_Col_Sum), Array("AVG", Str_Col_Avg), Array("MAX", Str_Col_Max))
                If IsNull(.Fields("Col_Order").Value) = True Then
                    Str_Col_Order = ""
                Else
                    Str_Col_Order = .Fields("Col_Order").Value
                End If
                If IsNull(.Fields("Cond").Value) = True Then
                    SQL_Seg_Where = ""
                Else
                    SQL_Seg_Where = .Fields("Cond").Value
                End If
                FailedReason_1 = CreateTbl_Group(Tbl_src_name, Tbl_Group_name, .Fields("Col_Group").Value, Str_GroupFunc_all:=Str_GroupFunc_all, GF_all_dbTypes:=GF_all_dbTypes, GroupFunc_Col_Pairs:=GroupFunc_Col_Pairs, Str_Col_Order:=Str_Col_Order)
                If FailedReason_1 <> "" Then
                    FailedReason = FailedReason & Tbl_Group_name & ": " & FailedReason_1 & vbCrLf
                End If
Loop_CreateTbls_Group_1:
                .MoveNext
            Loop
            .Close
        End With 'RS_Tbl_MT
        .Close
    End With 'CurrentDb
Exit_CreateTbls_Group:
    CreateTbls_Group = FailedReason
    Exit Function
Err_CreateTbls_Group:
    FailedReason = Err.Description
    Resume Exit_CreateTbls_Group
End Function

'Create table which are joined from two tables
Public Function CreateTbl_JoinTwoTbl(Tbl_src_1_name As String, Tbl_src_2_name As String, JoinCond As String, ColSet_Join_1 As Variant, ColSet_Join_2 As Variant, Tbl_des_name As String, Optional ColSet_src_1 As Variant = Null, Optional ColSet_src_2 As Variant = Null, Optional ColSet_Order As Variant = Null) As String
    On Error GoTo Err_CreateTbl_JoinTwoTbl
    Dim FailedReason As String
    If TableExist(Tbl_src_1_name) = False Then
        FailedReason = Tbl_src_1_name & "does not exist!"
        GoTo Exit_CreateTbl_JoinTwoTbl
    End If
    If TableExist(Tbl_src_2_name) = False Then
        FailedReason = Tbl_src_2_name & "does not exist!"
        GoTo Exit_CreateTbl_JoinTwoTbl
    End If
    If IsNull(ColSet_Join_1) = True Then
        GoTo Exit_CreateTbl_JoinTwoTbl
    End If
    If IsNull(ColSet_Join_2) = True Then
        GoTo Exit_CreateTbl_JoinTwoTbl
    End If
    DelTable (Tbl_des_name)
    Dim Col_Idx As Integer
    With CurrentDb
        If IsNull(ColSet_src_1) = True Then
            Dim RS_Tbl_src As Recordset
            Set RS_Tbl_src = .OpenRecordset(Tbl_src_1_name)
            Dim fld_idx As Integer
            Dim fld_name As String
            ColSet_src_1 = Array()
            With RS_Tbl_src
                For fld_idx = 0 To .Fields.count - 1
                    fld_name = .Fields(fld_idx).name
                    Call AppendArray(ColSet_src_1, Array("[" & fld_name & "]"))
                Next fld_idx
                .Close
            End With 'RS_Tbl_src
        End If
        If IsNull(ColSet_src_2) = True Then
            Set RS_Tbl_src = .OpenRecordset(Tbl_src_2_name)
            With RS_Tbl_src
                Dim NumOfColSet_Join_found As Integer
                NumOfColSet_Join_found = 0
                ColSet_src_2 = Array()
                For fld_idx = 0 To .Fields.count - 1
                    fld_name = .Fields(fld_idx).name
                    If NumOfColSet_Join_found <= UBound(ColSet_Join_2) And FindStrInArray(ColSet_Join_2, fld_name) > -1 Then
                        NumOfColSet_Join_found = NumOfColSet_Join_found + 1
                    Else
                        Call AppendArray(ColSet_src_2, Array("[" & fld_name & "]"))
                    End If
                Next fld_idx
                .Close
            End With 'RS_Tbl_src
        End If
    End With 'CurrentDb
    Dim SQL_Seg_Select As String
    SQL_Seg_Select = "SELECT " & "[" & Tbl_src_1_name & "]." & Join(ColSet_src_1, ", [" & Tbl_src_1_name & "].") & ", " & "[" & Tbl_src_2_name & "]." & Join(ColSet_src_2, ", [" & Tbl_src_2_name & "].")
    Dim SQL_Seg_JoinOn As String
    SQL_Seg_JoinOn = "("
    For Col_Idx = LBound(ColSet_Join_1) To UBound(ColSet_Join_1)
        SQL_Seg_JoinOn = SQL_Seg_JoinOn & "[" & Tbl_src_1_name & "].[" & ColSet_Join_1(Col_Idx) & "] = [" & Tbl_src_2_name & "].[" & ColSet_Join_2(Col_Idx) & "] AND "
    Next Col_Idx
    SQL_Seg_JoinOn = Left(SQL_Seg_JoinOn, Len(SQL_Seg_JoinOn) - 4) & ")"
    Dim SQL_Seg_OrderBy As String
    SQL_Seg_OrderBy = ""
    If IsNull(ColSet_Order) = False Then
        SQL_Seg_OrderBy = "ORDER BY "
        For Col_Idx = LBound(ColSet_Order) To UBound(ColSet_Order)
            SQL_Seg_OrderBy = SQL_Seg_OrderBy & "[" & Tbl_src_1_name & "].[" & ColSet_Order(Col_Idx) & "], "
        Next Col_Idx
        SQL_Seg_OrderBy = Left(SQL_Seg_OrderBy, Len(SQL_Seg_OrderBy) - 2)
    End If
    Dim SQL_cmd As String
    SQL_cmd = SQL_Seg_Select & " " & vbCrLf & _
                "INTO [" & Tbl_des_name & "] " & vbCrLf & _
                "FROM [" & Tbl_src_1_name & "] " & JoinCond & " JOIN [" & Tbl_src_2_name & "] " & vbCrLf & _
                "ON " & SQL_Seg_JoinOn & vbCrLf & _
                SQL_Seg_OrderBy & " " & vbCrLf & _
                ";"
    RunSQL_CmdWithoutWarning (SQL_cmd)
Exit_CreateTbl_JoinTwoTbl:
    CreateTbl_JoinTwoTbl = FailedReason
    Exit Function
Err_CreateTbl_JoinTwoTbl:
    FailedReason = Err.Description
    Resume Exit_CreateTbl_JoinTwoTbl
End Function

'Create table which is cancatenated from multiple tables of the same structure
Public Function CreateTbl_ConcatTbls(Tbl_src_Set As Variant, Tbl_des_name As String, Optional Type_Set As Variant = "") As String
    On Error GoTo Err_CreateTbl_ConcatTbls
    Dim FailedReason As String
    If UBound(Tbl_src_Set) < 0 Then
        FailedReason = "No table in the table set"
        GoTo Exit_CreateTbl_ConcatTbls
    End If
    Dim Tbl_src_name As Variant
    For Each Tbl_src_name In Tbl_src_Set
        If TableExist(Tbl_src_name & "") = False Then
            FailedReason = Tbl_src_name & " does not exist!"
            GoTo Exit_CreateTbl_ConcatTbls
        End If
    Next
    DelTable (Tbl_des_name)
    Dim SQL_cmd As String
    Tbl_src_name = Tbl_src_Set(0)
    SQL_cmd = "SELECT " & Chr(34) & "null" & Chr(34) & " AS [Type], " & Tbl_src_name & ".* " & vbCrLf & _
                "INTO " & Tbl_des_name & " " & vbCrLf & _
                "FROM " & Tbl_src_name & " " & vbCrLf & _
                "WHERE 1 = 0 " & vbCrLf & _
                ";"
    RunSQL_CmdWithoutWarning (SQL_cmd)
    Dim tbl_idx As Integer
    Dim SQL_Seq_Type As String
    For tbl_idx = 0 To UBound(Tbl_src_Set)
        Tbl_src_name = Tbl_src_Set(tbl_idx)
        If VarType(Type_Set) > vbArray And Type_Set(tbl_idx) = "" Then
            SQL_Seq_Type = ""
        Else
            SQL_Seq_Type = Chr(34) & Type_Set(tbl_idx) & Chr(34) & " AS [Type], "
        End If
        SQL_cmd = "INSERT INTO " & Tbl_des_name & " " & vbCrLf & _
                    "SELECT " & SQL_Seq_Type & "[" & Tbl_src_name & "].* " & vbCrLf & _
                    "FROM [" & Tbl_src_name & "] " & vbCrLf & _
                    ";"
        RunSQL_CmdWithoutWarning (SQL_cmd)
    Next
    If UBound(Type_Set) < 0 Then
        SQL_cmd = "ALTER TABLE [" & Tbl_des_name & "] " & vbCrLf & _
                    "DROP COLUMN [Type]" & vbCrLf & _
                    ";"
        RunSQL_CmdWithoutWarning (SQL_cmd)
    End If
Exit_CreateTbl_ConcatTbls:
    CreateTbl_ConcatTbls = FailedReason
    Exit Function
Err_CreateTbl_ConcatTbls:
    FailedReason = Err.Description
    Resume Exit_CreateTbl_ConcatTbls
End Function

'Execute SQLite Command Set
Public Function ExecuteSQLiteCmdSet(SQLiteDb_path As String, CmdSet As String) As String
    On Error GoTo Err_ExecuteSQLiteCmdSet
    Dim FailedReason As String
    If FileExists(SQLiteDb_path) = False Then
        FailedReason = SQLiteDb_path
        GoTo Exit_ExecuteSQLiteCmdSet
    End If
    'Create a SQLite Command file, and then parse it into the Python SQLite Command Parser for execution
    Dim SQLiteCmdFile_path As String
    Dim iFileNum_SQLiteCmd As Integer
    SQLiteCmdFile_path = [CurrentProject].[Path] & "\" & "SQLiteCmd.txt"
    iFileNum_SQLiteCmd = FreeFile()
    If FileExists(SQLiteCmdFile_path) = True Then
        Kill SQLiteCmdFile_path
    End If
    Open SQLiteCmdFile_path For Output As iFileNum_SQLiteCmd
    Print #iFileNum_SQLiteCmd, CmdSet
    Close #iFileNum_SQLiteCmd
    Dim SQLiteCmdLog_path As String
    SQLiteCmdLog_path = [CurrentProject].[Path] & "\SQLiteCmd.log"
    If FileExists(SQLiteCmdLog_path) = True Then
        Kill SQLiteCmdLog_path
    End If
    ShellCmd = "python " & [CurrentProject].[Path] & "\SQLiteCmdParser.py " & SQLiteDb_path & " " & SQLiteCmdFile_path & " " & SQLiteCmdLog_path
    Call ShellAndWait(ShellCmd, vbHide)
    If FileExists(SQLiteCmdLog_path) = False Then
        FailedReason = "SQLiteCmdParser"
        GoTo Exit_ExecuteSQLiteCmdSet
    End If
    Dim iFileNum_SQLiteCmdLog As Integer
    Dim SQLiteCmdLog_line As String
    iFileNum_SQLiteCmdLog = FreeFile()
    Open SQLiteCmdLog_path For Input As iFileNum_SQLiteCmdLog
    If Not EOF(iFileNum_SQLiteCmdLog) Then
        Line Input #iFileNum_SQLiteCmdLog, SQLiteCmdLog_line
    End If
    If SQLiteCmdLog_line <> "done" Then
        FailedReason = SQLiteCmdLog_path
        GoTo Exit_ExecuteSQLiteCmdSet
    End If
    Close iFileNum_SQLiteCmdLog
    Kill SQLiteCmdFile_path
    Kill SQLiteCmdLog_path
Exit_ExecuteSQLiteCmdSet:
    ExecuteSQLiteCmdSet = FailedReason
    Exit Function
Err_ExecuteSQLiteCmdSet:
    Call ShowMsgBox(Err.Description)
    Resume Exit_ExecuteSQLiteCmdSet
End Function

'Append Table into a SQLite database
Public Function AppendTblToSQLite(Tbl_src_name As String, Tbl_des_name As String) As String
    On Error GoTo Err_AppendTblToSQLite
    Dim FailedReason As String
    If TableExist(Tbl_src_name) = False Then
        FailedReason = Tbl_src_name
        GoTo Exit_AppendTblToSQLite
    End If
    If TableExist(Tbl_des_name) = False Then
        FailedReason = Tbl_des_name
        GoTo Exit_AppendTblToSQLite
    End If
    'Create Db
    Dim TempDb_path As String
    TempDb_path = [CurrentProject].[Path] & "\TempDb.mdb"
    If FileExists(TempDb_path) = True Then
        Kill TempDb_path
    End If
    Call CreateDatabase(TempDb_path, dbLangGeneral)
    'Copy Table into the TempDb
    Dim SQL_cmd As String
    SQL_cmd = "SELECT * " & vbCrLf & "INTO [" & Tbl_des_name & "]" & vbCrLf & "IN '" & TempDb_path & "'" & vbCrLf & "FROM [" & Tbl_src_name & "] " & vbCrLf & ";"
    RunSQL_CmdWithoutWarning (SQL_cmd)
    'Convert TempDb into SQLite
    Dim SQLiteDb_path As String
    SQLiteDb_path = [CurrentProject].[Path] & "\TempDb.sqlite"
    If FileExists(SQLiteDb_path) = True Then
        Kill SQLiteDb_path
    End If
    Dim ShellCmd As String
    ShellCmd = "java -jar " & [CurrentProject].[Path] & "\mdb-sqlite.jar " & TempDb_path & " " & SQLiteDb_path
    Call ShellAndWait(ShellCmd, vbHide)
    SQL_cmd = "ATTACH """ & SQLiteDb_path & """ AS TempDb;" & vbCrLf & "INSERT INTO [" & Tbl_des_name & "] SELECT * FROM TempDb.[" & Tbl_des_name & "];"
    FailedReason = ExecuteSQLiteCmdSet(GetLinkTblConnInfo(Tbl_des_name, "DATABASE"), SQL_cmd)
    If FailedReason <> "" Then
        GoTo Exit_AppendTblToSQLite
    End If
    Kill SQLiteDb_path
    Kill TempDb_path
Exit_AppendTblToSQLite:
    AppendTblToSQLite = FailedReason
    Exit Function
Err_AppendTblToSQLite:
    Call ShowMsgBox(Err.Description)
    Resume Exit_AppendTblToSQLite
End Function