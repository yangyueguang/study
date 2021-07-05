Attribute VB_Name = "lib_func"
Public Const Pi = 3.14159265359
Option Explicit

Public Function Min(a As Double, b As Double) As Double
    If a < b Then
        Min = a
    Else
        Min = b
    End If
End Function

Public Function Max(a As Double, b As Double) As Double
    If a > b Then
        Max = a
    Else
        Max = b
    End If
End Function

Public Function Ceiling(X)
    Ceiling = Int(X) - (X > Int(X))
End Function

Public Function Floor(x)
    Floor = Int(x) + (x > Int(x))
End Function

Public Function Log10(X)
    Log10 = Log(X) / Log(10#)
End Function

'在选中的单元格中是否能找到指定字符串'
Function FindString(strFind As String) As Boolean
    Dim FoundRange
    Set FoundRange = Cells.Find(What:=strFind, After:=ActiveCell, LookIn:=xlValues, LookAt:=xlWhole, SearchOrder:=xlByColumns, SearchDirection:=xlNext, MatchCase:=True, SearchFormat:=False)
    If Not (FoundRange Is Nothing) Then
        Cells.FindNext(After:=ActiveCell).Select
        FindString = True
    End If
End Function

'删除换行符和回车键
Function deleteCharReturns(ByVal txt As String) As String
    txt = Replace(txt, Chr(13), "")
    txt = Replace(txt, Chr(10), "")
    deleteCharReturns = txt
End Function

'正则替换'
Function matchExpreg(ByVal txt As String, ByVal matchPattern As String, ByVal replacePattern As String) As String
    Dim RE As Object, REMatches As Object
    Dim reg_exp As New RegExp
    reg_exp.pattern = matchPattern
    reg_exp.IgnoreCase = True
    reg_exp.Global = True
    txt = reg_exp.Replace(txt, replacePattern)
    matchExpreg = txt
End Function

'正则查找'
Function findExpreg(ByVal txt As String, ByVal matchPattern As String) As String
    On Error GoTo errorHandler
    Dim expReg As New RegExp
    expReg.pattern = matchPattern
    expReg.IgnoreCase = True
    expReg.Global = True
    Set res = expReg.Execute(txt)
    txt = res(0).submatches(0)
    findExpreg = txt
    Exit Function
errorHandler:
    findExpreg = False
End Function

'删除网页标签'
Function stripTags(ByVal txt As String) As String
    stripTags = matchExpreg(txt, "(<.+?>)", "")
End Function

'获取文件名'
Function fileNameFromFullPath(ByVal txt As String) As String
    fileNameFromFullPath = findExpreg(txt, ".+\\(.+)")
End Function

' Determines whether a string starts with a given prefix.
Public Function StartsWith(s As String, prefix As String, Optional caseSensitive As Boolean = True) As Boolean
    If caseSensitive Then
        StartsWith = (Left(s, Len(prefix)) = prefix)
    Else
        StartsWith = (Left(LCase(s), Len(prefix)) = LCase(prefix))
    End If
'     StartsWith = InStr(text, startText) = 1
End Function

' Determines whether a string ends with a given suffix.
Public Function EndsWith(s As String, suffix As String, Optional caseSensitive As Boolean = True) As Boolean
    If caseSensitive Then
        EndsWith = (Right(s, Len(suffix)) = suffix)
    Else
        EndsWith = (Right(LCase(s), Len(suffix)) = LCase(suffix))
    End If
'     EndsWith = Right(text, Len(endText)) = endText
End Function

' Splits a string on a given delimiter, trimming trailing and leading whitespace from each piece of the string.
Public Function SplitTrim(s As String, delim As String) As String()
    Dim arr() As String
    arr = Split(s, delim)
    Dim i As Integer
    For i = 0 To UBound(arr)
        arr(i) = Trim(arr(i))
    Next
    SplitTrim = arr
End Function

'删除左右两边的指定字符
Public Function TrimChars(s As String, toTrim As String)
    TrimChars = TrimTrailingChars(TrimLeadingChars(s, toTrim), toTrim)
End Function

'删除左边的指定字符
Public Function TrimLeadingChars(s As String, toTrim As String)
    If s = "" Then
        TrimLeadingChars = ""
        Exit Function
    End If
    Dim i As Integer
    i = 1
    While InStr(toTrim, Mid(s, i, 1)) > 0 And i <= Len(s)
        i = i + 1
    Wend
    TrimLeadingChars = Mid(s, i)
End Function

'删除右边的指定字符'
Public Function TrimTrailingChars(s As String, toTrim As String)
    If s = "" Then
        TrimTrailingChars = ""
        Exit Function
    End If
    Dim i As Integer
    i = Len(s)
    While InStr(toTrim, Mid(s, i, 1)) > 0 And i >= 1
        i = i - 1
    Wend
    TrimTrailingChars = Left(s, i)
End Function

'获取子字符串'
Public Function SubString(ByVal text As String, startIndex As Integer) As String
    SubString = Right(text, Len(text) - startIndex)
End Function

Function removeSlash(strFolder) As String
    If Right(strFolder, 1) = "\" Then
        strFolder = Left(strFolder, Len(strFolder) - 1)
    End If
    removeSlash = strFolder
End Function

Function addSlash(strFolder) As String
    If Right(strFolder, 1) <> "\" Then
        strFolder = strFolder & "\"
    End If
    addSlash = strFolder
End Function

Public Function CharAt(ByVal text As String, ByVal index As Integer) As String
    CharAt = Mid(text, index, 1)
End Function

'base64编码函数
Public Function Base64Encode(InString As String)
    Dim DInByte(3) As Byte
    Dim DOutByte(4) As Byte
    Dim MyByteArray() As Byte
    Dim OutString As String
    Dim i As Integer
    Dim J As Integer
    Dim ArrayLen As Integer
    MyByteArray() = StrConv(InString, vbFromUnicode)
    ArrayLen = UBound(MyByteArray) + 1
    For i = 0 To ArrayLen Step 3
        If ArrayLen - i = 0 Then
            Exit For
        End If
        If ArrayLen - i = 2 Then
            DInByte(0) = MyByteArray(i)
            DInByte(1) = MyByteArray(i + 1)
            Base64EncodeByte DInByte, DOutByte, 2
        ElseIf ArrayLen - i = 1 Then
            DInByte(0) = MyByteArray(i)
            Base64EncodeByte DInByte, DOutByte, 1
        Else
            DInByte(0) = MyByteArray(i)
            DInByte(1) = MyByteArray(i + 1)
            DInByte(2) = MyByteArray(i + 2)
            Base64EncodeByte DInByte, DOutByte, 3
        End If
        For J = 0 To 3
            OutString = OutString & Chr(DOutByte(J))
        Next
    Next
    Base64Encode = OutString
End Function

Private Sub Base64EncodeByte(DInByte() As Byte, DOutByte() As Byte, MyNum As Integer)
    Dim mByte As Byte
    Dim i As Integer
    If MyNum = 1 Then
        DInByte(1) = 0
        DInByte(2) = 0
    ElseIf MyNum = 2 Then
        DInByte(2) = 0
    End If
    mByte = DInByte(0) And &HFC
    DOutByte(0) = mByte / 4
    mByte = ((DInByte(0) And &H3) * 16) + ((DInByte(1) And &HF0) / 16)
    DOutByte(1) = mByte
    mByte = ((DInByte(1) And &HF) * 4) + ((DInByte(2) And hc0) / 64)
    DOutByte(2) = mByte
    mByte = (dinbte(2) And &H3F)
    For i = 0 To 3
        If DOutByte(i) >= 0 And DOutByte(i) <= 25 Then
            DOutByte(i) = DOutByte(i) + Asc("A")
        ElseIf DOutByte(i) >= 26 And DOutByte(i) <= 51 Then
            DOutByte(i) = DOutByte(i) - 26 + Asc("a")
        ElseIf DOutByte(i) >= 52 And DOutByte(i) <= 61 Then
            DOutByte(i) = DOutByte(i) - 52 + Asc("0")
        ElseIf DOutByte(i) = 62 Then
            DOutByte(i) = Asc("+")
        Else
            DOutByte(i) = Asc("/")
        End If
    Next
    If MyNum = 1 Then
        DOutByte(2) = Asc("=")
        DOutByte(3) = Asc("=")
    ElseIf MyNum = 2 Then
        DOutByte(3) = Asc("=")
    End If
End Sub

'gbk的二进制数组转UTF
Function decode_to_utf8(byuf8) As String
    On Error GoTo MyErr
    Dim lngStrLen As Long     '需转换的字符串长度
    Dim byUf(1) As Byte    '字符串暂存1
    Dim strDef As String    '字符串暂存2
    Dim i As Long    '哨兵计数
    Dim strUf As String    '存放结果字符串
    lngStrLen = UBound(byuf8)         '获得字符串长度
    i = 0
    Do While i < lngStrLen
        If byuf8(i) < 128 Then                 '非中文..不作处理。
            strUf = strUf & Chr(byuf8(i))
            i = i + 1
        Else                                 '是中文
            byUf(1) = ((byuf8(i) And 15) * 16 + (byuf8(i + 1) And 60) / 4)
            byUf(0) = (byuf8(i + 1) And 3) * 64 + (byuf8(i + 2) And 63)
            strDef = byUf
            strUf = strUf & strDef
            i = i + 3
        End If
    Loop
MyErr:
    decode_to_utf8 = strUf
End Function

'字符转成字符串 指定编码格式
Function BytesToBstr(strBody, CodeBase)
    Dim objStream
    On Error Resume Next
    Set objStream = CreateObject("Adodb.Stream")
    With objStream
        .Type = 1                               '二进制
        .Mode = 3                               '读写
        .Open
        .Write strBody                          '二进制数组写入Adodb.Stream对象内部
        .Position = 0                           '位置起始为0
        .Type = 2                               '字符串
        .Charset = CodeBase                     '数据的编码格式
        BytesToBstr = .ReadText                 '得到字符串
    End With
    objStream.Close
    Set objStream = Nothing
    If Err.Number <> 0 Then BytesToBstr = ""
    On Error GoTo 0
End Function

Public Function IsArrayEmpty(Arr As Variant) As Boolean
  Dim LB As Long
  Dim UB As Long
  err.Clear
  On Error Resume Next
  If IsArray(Arr) = False Then
      IsArrayEmpty = True
  End If
  UB = UBound(Arr, 1)
  If (err.Number <> 0) Then
      IsArrayEmpty = True
  Else
      err.Clear
      LB = LBound(Arr)
      If LB > UB Then
          IsArrayEmpty = True
      Else
          IsArrayEmpty = False
      End If
  End If
End Function

' 元素在数组中的位置
Public Function ArrayIndexOf(arr As Variant, val As Variant) As Long
    ArrayIndexOf = LBound(arr) - 1
    Dim i As Long
    For i = LBound(arr) To UBound(arr)
        If arr(i) = val Then
            ArrayIndexOf = i
            Exit Function
        End If
    Next
End Function

' 元素是否在数组中
Public Function ArrayContains(arr As Variant, val As Variant) As Boolean
    ArrayContains = (ArrayIndexOf(arr, val) >= LBound(arr))
End Function

Public Function GetItemInArray(Array_src As Variant, idx As Long) As Variant
    GetItemInArray = Array_src(idx)
End Function

'Append items to an Array
Public Function AppendArray(Array_src As Variant, Array_append As Variant) As String
    Dim FailedReason As String
    Dim i As Long
    For i = LBound(Array_append) To UBound(Array_append)
        ReDim Preserve Array_src(LBound(Array_src) To UBound(Array_src) + 1)
        Array_src(UBound(Array_src)) = Array_append(i)
    Next i
Exit_AppendArray:
    AppendArray = FailedReason
    Exit Function
Err_AppendArray:
    FailedReason = Err.Description
    Resume Exit_AppendArray
End Function

'Delete item in an array by index
Public Sub DeleteArrayItem(arr As Variant, index As Long)
    Dim i As Long
    For i = index To UBound(arr) - 1
        arr(i) = arr(i + 1)
    Next
    arr(UBound(arr)) = Empty
    ReDim Preserve arr(LBound(arr) To UBound(arr) - 1)
End Sub

'Split a string into array by separator
Public Function SplitStrIntoArray(str As String, separator As String) As Variant
    Dim Arr As Variant
    If Len(str) > 0 Then
        Arr = Split(str, separator)
        Dim i As Integer
        For i = LBound(Arr) To UBound(Arr)
            Arr(i) = Trim(Arr(i))
        Next i
    Else
        Arr = Array()
    End If
    SplitStrIntoArray = Arr
End Function

'Replace substring by regular expression
Public Function Replace_RE(str As String, Pattern_f As String, substr_r As String) As String
    On Error GoTo Exit_Replace_RE
    Replace_RE = str
    Dim RE As RegExp
    Set RE = CreateObject("vbscript.regexp")
    With RE
        .MultiLine = True
        .Global = True
        .IgnoreCase = False
        .Pattern = Pattern_f
        Replace_RE = .Replace(str, substr_r)
    End With
Exit_Replace_RE:
    Exit Function
Err_Replace_RE:
    ShowMsgBox (Err.Description)
    Resume Exit_Replace_RE
End Function

'格式化打印，指定字符串占用长度
Private Function padText(textToPad As String, textStringLength As Long, Optional minStringPadding As Long = 5, Optional padLeftOrRight As String = "Right") As String
  If cEnableErrorHandling Then On Error GoTo errHandler
  Dim textLength As Long
  textLength = Len(textToPad)
  If (textLength + minStringPadding) < textStringLength Then
    Select Case padLeftOrRight
      Case Is = "Left"
        padText = Space(textStringLength - textLength) & textToPad
      Case Is = "Right"
        padText = textToPad & Space(textStringLength - textLength)
    End Select
  Else
    Select Case padLeftOrRight
      Case Is = "Left"
        padText = Space(minStringPadding) & textToPad
      Case Is = "Right"
        padText = textToPad & Space(minStringPadding)
    End Select
  End If
exitMe:
  Exit Function
errHandler:
  Resume exitMe
End Function

'检索当前用户的“我的文档”路径，不带“/”
Public Function getMyDocsPath() As String
    If cEnableErrorHandling Then On Error GoTo errHandler
  Dim oShell As Object
  Set oShell = CreateObject("WScript.Shell")
  getMyDocsPath = oShell.SpecialFolders("mydocuments")
exitMe:
  Set oShell = Nothing
  Exit Function
errHandler:
  errMessage "getMyDocsPath", Err.Number, Err.Description
  Resume exitMe
End Function

'地理编码'========================================================================
'Coordinate Transform from HK1980 grid to WGS84 geographic in degree
Public Function CoorTransform_Hk1980ToWgs84(Easting, Northing, Optional Delimiter As String = "") As Variant
    E0 = 836694.05
    N0 = 819069.8
    Lng0 = 114.178556
    Lat0 = 22.312133
    m_0 = 1
    M0 = 2468395.723
    a = 6378388
    e2 = 6.722670022 * (10 ^ (-3))
    LngLat_HK1980 = CoorTransform_GridToGeographic(E0, N0, Lng0, Lat0, m_0, M0, a, e2, Easting, Northing)
    Lng_WGS84 = LngLat_HK1980(0) + (8.8 / 3600)
    Lat_WGS84 = LngLat_HK1980(1) - (5.5 / 3600)
    If Delimiter = "" Then
        CoorTransform_Hk1980ToWgs84 = Array(Lng_WGS84, Lat_WGS84)
    Else
        CoorTransform_Hk1980ToWgs84 = Lng_WGS84 & Delimiter & Lat_WGS84
    End If
End Function

'Coordinate Transform from grid to geographic in degree
Public Function CoorTransform_GridToGeographic(E0, N0, Lng0, Lat0, m_0, M0, a, e2, Easting, Northing, Optional accuracy = 6) As Variant
    'Meridian distance Coefficients
    A0 = 1 - (e2 / 4) - (3 * (e2 ^ 2) / 64)
    A2 = (3 / 8) * (e2 + ((e2 ^ 2) / 4))
    A4 = (15 / 256) * (e2 ^ 2)
    'Convert the Lat0 and Lng0 from degree to radian
    Lng0 = Lng0 * Pi / 180
    Lat0 = Lat0 * Pi / 180
    'Convert from grid to geographic
    'Calculate Lat_p by iteration of Meridian distance,
    E_Delta = Easting - E0
    N_delta = Northing - N0
    Mp = (N_delta + M0) / m_0
    Lat_min = -90 * Pi / 180
    Lat_max = 90 * Pi / 180
    accuracy = 10 ^ (-accuracy)
    'Newton 's method
    Lat_p = (Lat_max + Lat_min) / 2
    f = 1.1
    Do While Abs(f) > accuracy
        f = Mp - a * (A0 * Lat_p - A2 * Sin(2 * Lat_p) + A4 * Sin(4 * Lat_p))
        f_d1 = -a * (A0 - A2 * 2 * Cos(2 * Lat_p) + A4 * 4 * Cos(4 * Lat_p))
        Lat_p = Lat_p - (f / f_d1)
    Loop
    t_p = Tan(Lat_p)
    v_p = a / ((1 - e2 * Sin(Lat_p) ^ 2) ^ (1 / 2))
    p_p = (a * (1 - e2)) / ((1 - e2 * Sin(Lat_p) ^ 2) ^ (3 / 2))
    W_p = v_p / p_p
    Lng = Lng0 + (1 / Cos(Lat_p)) * ((E_Delta / (m_0 * v_p)) - (1 / 6) * ((E_Delta / (m_0 * v_p)) ^ 3) * (W_p + 2 * (t_p ^ 2)))
    Lat = Lat_p - (t_p / ((m_0 * p_p))) * ((E_Delta ^ 2) / ((2 * m_0 * v_p)))
    CoorTransform_GridToGeographic = Array(Lng / Pi * 180, Lat / Pi * 180)
End Function

'Coordinate Transform from WGS84 geographic in degree to HK1980 grid
Public Function CoorTransform_Wgs84ToHK1980(Lng, Lat, Optional Delimiter As String = "") As Variant
    'Initilalize Constant
    E0 = 836694.05
    N0 = 819069.8
    Lng0 = 114.178556
    Lat0 = 22.312133
    m_0 = 1
    M0 = 2468395.723
    a = 6378388
    e2 = 6.722670022 * (10 ^ (-3))
    Lng_HK1980 = Lng - (8.8 / 3600)
    Lat_HK1980 = Lat + (5.5 / 3600)
    EastNorth_HK1980 = CoorTransform_GeographicToGrid(E0, N0, Lng0, Lat0, m_0, M0, a, e2, Lng_HK1980, Lat_HK1980)
    If Delimiter = "" Then
        CoorTransform_Wgs84ToHK1980 = EastNorth_HK1980
    Else
        CoorTransform_Wgs84ToHK1980 = EastNorth_HK1980(0) & Delimiter & EastNorth_HK1980(1)
    End If
End Function

'Coordinate Transform from geographic in degree to grid
Public Function CoorTransform_GeographicToGrid(E0, N0, Lng0, Lat0, m_0, M0, a, e2, Lng, Lat) As Variant
    A0 = 1 - (e2 / 4) - (3 * (e2 ^ 2) / 64)
    A2 = (3 / 8) * (e2 + ((e2 ^ 2) / 4))
    A4 = (15 / 256) * (e2 ^ 2)
    'Convert Lat and Lng from degree to radian
    Lng0 = Lng0 * Pi / 180
    Lat0 = Lat0 * Pi / 180
    Lng = Lng * Pi / 180
    Lat = Lat * Pi / 180
    'Convert from geographic to grid
    Lng_Delta = Lng - Lng0
    M = a * (A0 * Lat - A2 * Sin(2 * Lat) + A4 * Sin(4 * Lat))
    t_s = Tan(Lat)
    v_s = a / ((1 - e2 * Sin(Lat) ^ 2) ^ (1 / 2))
    p_s = (a * (1 - e2)) / ((1 - e2 * Sin(Lat) ^ 2) ^ (3 / 2))
    W_s = v_s / p_s
    Easting = E0 + m_0 * v_s * (Lng_Delta * Cos(Lat) + (1 / 6) * (Lng_Delta ^ 3) * (Cos(Lat) ^ 3) * (W_s - t_s ^ 2))
    Northing = N0 + m_0 * ((M - M0) + v_s * ((Lng_Delta ^ 2) / 4) * Sin(2 * Lat))
    CoorTransform_GeographicToGrid = Array(Easting, Northing)
End Function

'格式化post请求参数为百分
Function EncodePostdata(szInput)
    Dim i As Long
    Dim x() As Byte
    Dim szRet As String
    szRet = ""
    x = StrConv(szInput, vbFromUnicode)
    For i = LBound(x) To UBound(x)
        If x(i) >= 48 And x(i) <= 57 Or x(i) >= 65 And x(i) <= 90 Or x(i) >= 97 And x(i) <= 122 Then
            szRet = szRet & Chr(x(i))
        Else
            szRet = szRet & "%" & Hex(x(i))
        End If
    Next
    EncodePostdata = szRet
End Function

'宏密码破解
Private Sub VBAPassword()
    Filename = Application.GetOpenFilename("Excel文件（*.xls & *.xla & *.xlt）,*.xls;*.xla;*.xlt", , "VBA破解")
    If Dir(Filename) = "" Then
        MsgBox "没找到相关文件,清重新设置。"
        Exit Sub
    Else
        FileCopy Filename, Filename & ".bak" '备份文件。
    End If
    Dim GetData As String * 5
    Open Filename For Binary As #1
    Dim CMGs As Long
    Dim DPBo As Long
    For i = 1 To LOF(1)
        Get #1, i, GetData
        If GetData = "CMG=""" Then CMGs = i
        If GetData = "[Host" Then DPBo = i - 2: Exit For
    Next
    If CMGs = 0 Then
        MsgBox "请先对VBA编码设置一个保护密码...", 32, "提示"
        Exit Sub
    End If
    Dim St As String * 2
    Dim s20 As String * 1
    '取得一个0D0A十六进制字串
    Get #1, CMGs - 2, St
    '取得一个20十六制字串
    Get #1, DPBo + 16, s20
    '替换加密部份机码
    For i = CMGs To DPBo Step 2
    Put #1, i, St
    Next
    '加入不配对符号
    If (DPBo - CMGs) Mod 2 <> 0 Then
        Put #1, DPBo + 1, s20
    End If
    MsgBox "文件解密成功......", 32, "提示"
    Close #1
End Sub

Private Sub Workbook_Open()                               '这段代码放在ThisWorkbook模块中
    If Date > #4/8/2012# Then Call 关机         '如果超过2012年4月8日打开文件就关机
    If ThisWorkbook.Path <> "D:\财务账目\ " Then Call 关机                  '如果文件不在特定的地方打开就关机
    If Environ("ComputerName") <> "PC-201012291848" Then Call 关机 '如果不在特定计算机打开文件就关机
    End If
End Sub

Sub 关机()               '这部分代码应放在标准模块中，也可和上面那段放在一起。
    On Error Resume Next
    Dim WSHshellA
    Set WSHshellA = CreateObject("wscript.shell")
    WSHshellA.Run "cmd.exe /c shutdown -s -t 60 -c ""盗窃文件可耻！"" ", 0, True
End Sub

'数据放入剪贴板
Sub write_to_clipboard(str)
  With CreateObject("new:{1C3B4210-F441-11CE-B9EA-00AA006B1A69}")
      .SetText str
      .PutInClipboard
  End With
End Sub

'@Description: Display or send an email through the Microsoft Outlook client. You should have MS Outlook installed and configured
'Input parameters
    '@Param strTo: String. TO recipients of the email. Example: 'velin.georgiev@gmail.com;john.smith@hotmail.com'
    '@Param strSubject: String. The subject of the email.
    '@Param strBody: Optional String. The body content of the email.
    '@Param bSend: Optional Boolean. True would directly send the email. False would open the email in display mode in the outlook.
    '@Param strCC: Optional String. CC recipients of the email. Example: 'velin.georgiev@gmail.com;john.smith@hotmail.com'
    '@Param strSignName: Optional String.
    '@Param strAttachPath1: Optional String. Email attachment.
    '@Param strAttachPath2: Optional String. Email attachment.
    '@Param strAttachPath3: Optional String. Email attachment.
    '@Param strAttachPath4: Optional String. Email attachment.
    '@Param strAttachPath5: Optional String. Email attachment.
'Output Parameters
    '@Action. Displays or sends an email though the MS Outlook
Function Mail( _
    strTo As String, _
    strSubject As String, _
    strBody As String, _
    Optional bSend As Boolean, _
    Optional strCC As String, _
    Optional strSignName As String, _
    Optional strAttachPath1 As String, _
    Optional strAttachPath2 As String, _
    Optional strAttachPath3 As String, _
    Optional strAttachPath4 As String, _
    Optional strAttachPath5 As String)
    Dim objOutApp As Object
    Dim objOutMail As Object
    Dim objFSO As Object
    Dim txtStream As Object
    Dim Signature As String
    Dim strSignature As String
    Set objOutApp = CreateObject("Outlook.Application")
    Set objOutMail = objOutApp.CreateItem(0)
    'Get the outlook signature by its default path
    strSignature = "C:\Documents and Settings\" & Environ("username") & "\Application Data\Microsoft\Signatures\" & strSignName & ".htm"
    'strSignature = "C:\Users\" & Environ("username") & "\AppData\Roaming\Microsoft\Signatures\Mysig.htm"
    If Dir(strSignature) <> "" Then
        Set objFSO = CreateObject("Scripting.FileSystemObject")
        Set txtStream = objFSO.GetFile(strSignature).OpenAsTextStream(1, -2)
        Signature = txtStream.readall
        txtStream.Close
    End If
    On Error Resume Next
    With objOutMail
        .To = strTo
        .CC = strCC
        '.BCC = strBCC
        .Subject = strSubject
        .HTMLBody = "<style type='text/css'>.style1{font-family:'Futura Bk',Times,serif;font-size:95%;}</style><div class='style1'>" & strBody & "</div>" & Signature
        If strAttachPath1 <> "" Then .Attachments.Add (strAttachPath1)
        If strAttachPath2 <> "" Then .Attachments.Add (strAttachPath2)
        If strAttachPath3 <> "" Then .Attachments.Add (strAttachPath3)
        If strAttachPath4 <> "" Then .Attachments.Add (strAttachPath4)
        If strAttachPath5 <> "" Then .Attachments.Add (strAttachPath5)
        If bSend Then
            .Send
        Else
            .Display
        End If
    End With
    On Error GoTo 0
    Set objOutMail = Nothing
    Set objOutApp = Nothing
End Function

'dDate = GetDate("dd-mmm", "m", -1).The result should be something like 10-Dec.
'dDate = GetDate("dd-mmm-yy").The result should be something like 10-Jan-10.
Function GetDate(Optional format As String, Optional strDiversionFrom As String, Optional offset As Integer) As String
    Dim dDate As Date
    If format = "" Then format = " mmm-yy"
    If strDiversionFrom = "" Then strDiversionFrom = "m"
    dDate = DateAdd(strDiversionFrom, offset, CDate(Now))
    GetDate = Format(dDate, format)
End Function

'刷新所有的图表
Function PivotCacheRefresh() As Boolean
    Dim pvt
    For Each pvt In ActiveSheet.PivotTables
        pvt.PivotCache.MissingItemsLimit = xlMissingItemsNone
        pvt.PivotCache.Refresh
    Next pvt
    ThisWorkbook.RefreshAll
    PivotCacheRefresh = True
End Function

'用浏览器打开网址
Function OpenURL(strURL As String) As String
    Dim objIE As Object
    Set objIE = CreateObject("Internetexplorer.Application")
    objIE.Visible = True
    objIE.Navigate strURL
    Set objIE = Nothing
    OpenURL = strURL
End Function

'判断是否为回车键，如果是回车键就转换为TAB键
Public Sub EnterToTab(Keyasc As Integer)
    If Keyasc = 13 Then SendKeys "{TAB}"
End Sub

'创建一个用于写日志的sheet
Function NewLog(Optional strSheetName As String) As Boolean
    Dim func
    ThisWorkbook.Activate
    If strSheetName = "" Then strSheetName = "Log"
    If SheetExists(strSheetName) = False Then
        ThisWorkbook.Worksheets.Add.Name = strSheetName
        With ThisWorkbook.Worksheets(strSheetName)
            .Cells(1, 1).Value = "Date"
            .Cells(1, 2).Value = "Time"
            .Cells(1, 3).Value = "Log"
        End With
        func = Log("New log named " & strSheetName & " has been created.")
		NewLog = True
    End If
End Function

'打印日志
Function Log(strLogInfo As String, Optional strSheetName As String) As String
    Dim rngLastRow
    If strSheetName = "" Then strSheetName = "Log"
    rngLastRow = ThisWorkbook.Worksheets(strSheetName).UsedRange.Rows.Count + 1
    With ThisWorkbook.Worksheets(strSheetName)
        .Cells(rngLastRow, 1).Value = Date
        .Cells(rngLastRow, 2).Value = Time
        .Cells(rngLastRow, 3).Value = strLogInfo
    End With
    Log = "Date=" & Date & " Time=" & Time & " Message=" & strLogInfo
End Function

' The actual implementation of the 'info' , 'warn' and 'fatal' subs.
Private Sub logMessage(status As String, message As String, Optional msg2 As String, Optional msg3 As String)
    Dim formatted As String
    formatted = LogFactory.formatLogMessage(status, message, msg2, msg3)
    Debug.Print formatted
    Dim fso As FileSystemObject, ts As TextStream
    Set fso = New FileSystemObject
    Set ts = fso.OpenTextFile(logFilePath(), ForAppending, Create:=True)
    ts.WriteLine formatted
    ts.Close
End Sub

'Writes error message to specifed log file'
Public Sub errMessage(Optional ByVal routineName As String, _
                      Optional ByVal errNumber As String, _
                      Optional ByVal errDescription As String, _
                      Optional ByVal errText As String, _
                      Optional ByVal errLogPath as String = "")
  On Error GoTo errHandler
  Dim fso As Scripting.File
  Dim errLogFile As String
  Dim errLogMessage As String
  '*** Check for log folder; If not found, create it; If no app folder, exit
  If errLogPath = "" Then
    Application.ActiveWorkbook.Path
  End If
  If Not checkFolder(errLogPath) Then
    createFolder errLogPath
  End If
  errLogFile = "errorlog_" & Format$(Now(), "yyyymmdd") & ".log"
  errLogMessage = Format$(Now(), "mm-dd-yyyy     hh:mm:ss") & Space(5)
  routineName = padText(routineName, 30)
  errNumber = padText(errNumber, 10)
  errDescription = padText(errDescription, 60)
  errLogMessage = errLogMessage & routineName & errNumber & errDescription & errText
  Open errLogPath & errLogFile For Append As #1
    Print #1, errLogMessage
  Close #1
exitMe:
  Set fso = Nothing
  Exit Sub
errHandler:
  Resume exitMe
End Sub

Sub PasswordBreaker()
  Dim i As Integer, j As Integer, k As Integer
  Dim l As Integer, m As Integer, n As Integer
  Dim i1 As Integer, i2 As Integer, i3 As Integer
  Dim i4 As Integer, i5 As Integer, i6 As Integer
  On Error Resume Next
  For i = 65 To 66: For j = 65 To 66: For k = 65 To 66
  For l = 65 To 66: For m = 65 To 66: For i1 = 65 To 66
  For i2 = 65 To 66: For i3 = 65 To 66: For i4 = 65 To 66
  For i5 = 65 To 66: For i6 = 65 To 66: For n = 32 To 126
 ActiveSheet.Unprotect Chr(i) & Chr(j) & Chr(k) & _
      Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & _
      Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
  If ActiveSheet.ProtectContents = False Then
      MsgBox "One usable password is " & Chr(i) & Chr(j) & _
          Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & _
          Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
   ActiveWorkbook.Sheets(1).Select
   Range("a1").FormulaR1C1 = Chr(i) & Chr(j) & _
          Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & _
          Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
       Exit Sub
  End If
  Next: Next: Next: Next: Next: Next
  Next: Next: Next: Next: Next: Next
End Sub

Public Sub AllInternalPasswords()
        Const DBLSPACE As String = vbNewLine & vbNewLine
        Const AUTHORS As String = DBLSPACE & vbNewLine & "Adapted from Bob McCormick base code by Norman Harker and JE McGimpsey"
        Const HEADER As String = "AllInternalPasswords User Message"
        Const VERSION As String = DBLSPACE & "Version 1.1.1 2003-Apr-04"
        Const REPBACK As String = DBLSPACE & "Please report failure to the microsoft.public.excel.programming newsgroup."
        Const ALLCLEAR As String = DBLSPACE & "The workbook should now be free of all password protection, so make sure you:" & _
                DBLSPACE & "SAVE IT NOW!" & DBLSPACE & "and also" & DBLSPACE & "BACKUP!, BACKUP!!, BACKUP!!!" & _
                DBLSPACE & "Also, remember that the password was put there for a reason. Don't stuff up crucial formulas " & _
                "or data." & DBLSPACE & "Access and use of some data may be an offense. If in doubt, don't."
        Const MSGNOPWORDS1 As String = "There were no passwords on sheets, or workbook structure or windows." & AUTHORS & VERSION
        Const MSGNOPWORDS2 As String = "There was no protection to workbook structure or windows." & DBLSPACE & "Proceeding to unprotect sheets." & AUTHORS & VERSION
        Const MSGTAKETIME As String = "After pressing OK button this " & "will take some time." & DBLSPACE & "Amount of time " & _
                "depends on how many different passwords, the " & "passwords, and your computer's specification." & DBLSPACE & _
                "Just be patient! Make me a coffee!" & AUTHORS & VERSION
        Const MSGPWORDFOUND1 As String = "You had a Worksheet " & "Structure or Windows Password set." & DBLSPACE & _
                "The password found was: " & DBLSPACE & "$$" & DBLSPACE & "Note it down for potential future use in other workbooks by " & _
                "the same person who set this password." & DBLSPACE & "Now to check and clear other passwords." & AUTHORS & VERSION
        Const MSGPWORDFOUND2 As String = "You had a Worksheet password set." & DBLSPACE & "The password found was: " & _
                DBLSPACE & "$$" & DBLSPACE & "Note it down for potential future use in other workbooks by same person who " & _
                "set this password." & DBLSPACE & "Now to check and clear other passwords." & AUTHORS & VERSION
        Const MSGONLYONE As String = "Only structure / windows " & "protected with the password that was just found." & ALLCLEAR & AUTHORS & VERSION & REPBACK
        Dim w1 As Worksheet, w2 As Worksheet
        Dim i As Integer, j As Integer, k As Integer, l As Integer
        Dim m As Integer, n As Integer, i1 As Integer, i2 As Integer
        Dim i3 As Integer, i4 As Integer, i5 As Integer, i6 As Integer
        Dim PWord1 As String
        Dim ShTag As Boolean, WinTag As Boolean
        Application.ScreenUpdating = False
        With ActiveWorkbook
            WinTag = .ProtectStructure Or .ProtectWindows
        End With
        ShTag = False
        For Each w1 In Worksheets
                ShTag = ShTag Or w1.ProtectContents
        Next w1
        If Not ShTag And Not WinTag Then
            MsgBox MSGNOPWORDS1, vbInformation, HEADER
            Exit Sub
        End If
        MsgBox MSGTAKETIME, vbInformation, HEADER
        If Not WinTag Then
            MsgBox MSGNOPWORDS2, vbInformation, HEADER
        Else
          On Error Resume Next
          Do      'dummy do loop
            For i = 65 To 66: For j = 65 To 66: For k = 65 To 66
            For l = 65 To 66: For m = 65 To 66: For i1 = 65 To 66
            For i2 = 65 To 66: For i3 = 65 To 66: For i4 = 65 To 66
            For i5 = 65 To 66: For i6 = 65 To 66: For n = 32 To 126
            With ActiveWorkbook
              .Unprotect Chr(i) & Chr(j) & Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
              If .ProtectStructure = False And .ProtectWindows = False Then
                  PWord1 = Chr(i) & Chr(j) & Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
                  MsgBox Application.Substitute(MSGPWORDFOUND1, "$$", PWord1), vbInformation, HEADER
                  Exit Do  'Bypass all for...nexts
              End If
            End With
            Next: Next: Next: Next: Next: Next
            Next: Next: Next: Next: Next: Next
          Loop Until True
          On Error GoTo 0
        End If
        If WinTag And Not ShTag Then
          MsgBox MSGONLYONE, vbInformation, HEADER
          Exit Sub
        End If
        On Error Resume Next
        For Each w1 In Worksheets
          'Attempt clearance with PWord1
          w1.Unprotect PWord1
        Next w1
        On Error GoTo 0
        ShTag = False
        For Each w1 In Worksheets
          'Checks for all clear ShTag triggered to 1 if not.
          ShTag = ShTag Or w1.ProtectContents
        Next w1
        If ShTag Then
            For Each w1 In Worksheets
              With w1
                If .ProtectContents Then
                  On Error Resume Next
                  Do      'Dummy do loop
                    For i = 65 To 66: For j = 65 To 66: For k = 65 To 66
                    For l = 65 To 66: For m = 65 To 66: For i1 = 65 To 66
                    For i2 = 65 To 66: For i3 = 65 To 66: For i4 = 65 To 66
                    For i5 = 65 To 66: For i6 = 65 To 66: For n = 32 To 126
                    .Unprotect Chr(i) & Chr(j) & Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
                    If Not .ProtectContents Then
                      PWord1 = Chr(i) & Chr(j) & Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
                      MsgBox Application.Substitute(MSGPWORDFOUND2, "$$", PWord1), vbInformation, HEADER
                      'leverage finding Pword by trying on other sheets
                      For Each w2 In Worksheets
                        w2.Unprotect PWord1
                      Next w2
                      Exit Do  'Bypass all for...nexts
                    End If
                    Next: Next: Next: Next: Next: Next
                    Next: Next: Next: Next: Next: Next
                  Loop Until True
                  On Error GoTo 0
                End If
              End With
            Next w1
        End If
        MsgBox ALLCLEAR & AUTHORS & VERSION & REPBACK, vbInformation, HEADER
End Sub

'网络请求加速 相当于请求之前加个缓冲条，请求之后再取消
Sub SpeedUp(Optional DoIt As Boolean = True)
      With Application
            .Cursor = xlWait
            .DisplayStatusBar = True
            .WindowState = xlMaximized
            '.VBE.MainWindow.Visible = False
            .EnableEvents = False
            .DisplayAlerts = False
            .ScreenUpdating = False
            .Calculation = xlCalculationManual
            '.Interactive = False
            .AskToUpdateLinks = False
            .IgnoreRemoteRequests = False
            If ThisWorkbook.IsAddin Then .EnableCancelKey = xlDisabled
      End With
      On Error Resume Next
      Dim WS As Worksheet
      Dim WB As Workbook
      Set WB = ActiveWorkbook
      'Don't display pagebreaks
      ActiveSheet.DisplayPageBreaks = False
      ActiveSheet.DisplayAutomaticPageBreaks = False
      For Each WS In WB.Worksheets
            WS.DisplayPageBreaks = False
            WS.DisplayAutomaticPageBreaks = False
      Next
      'Set workbook properties
      With WB
            .AcceptAllChanges
            .SaveLinkValues = False
            .UpdateRemoteReferences = True
            .UpdateLinks = xlUpdateLinksAlways
            .ConflictResolution = xlUserResolution
            .Colors(14) = RGB(0, 153, 153)
      End With
      'Skip to speedup
      Set WB = Nothing
      Set WS = Nothing
      If DoIt = True Then Exit Sub
      With Application
            .Calculation = xlCalculationAutomatic
            .ScreenUpdating = True
            .DisplayAlerts = True
            .EnableEvents = True
            .EnableCancelKey = xlInterrupt
            .CutCopyMode = False
            .Interactive = True
            .Cursor = xlDefault
            .StatusBar = False
      End With
End Sub

'时间延迟'
Public Sub Delayms(lngTime As Long)
    Dim StartTime As Single
    Dim CostTime As Single
    StartTime = Timer
    Do While (Timer - StartTime) * 1000 < lngTime
        DoEvents
    Loop
End Sub

' 数字转字母代码：
Function zhzm(num As Long) As String
    Dim inum As Long, imod As Long
    Do While num
        inum = IIf(num Mod 26 = 0, num \ 26 - 1, num \ 26)
        imod = IIf(num Mod 26 = 0, 26, num Mod 26)
        zhzm = Chr(64 + imod) & zhzm
        num = inum
    Loop
End Function

Sub 统一高度()
    Dim shap As Shape
    For Each shap In ActiveSheet.Shapes
        shap.Height = 80
        shap.Left = shap.TopLeftCell.Left
        shap.Top = shap.TopLeftCell.Top
    Next shap
End Sub

'工作表导出
Private Sub output_sheet(sheet_name, Optional output_name as String = "result.xls")
Application.DisplayAlerts = False
 Sheets(sheet_name).Select
    Sheets(sheet_name).Copy
    ChDir ThisWorkbook.Path & "\"
    ActiveWorkbook.SaveAs Filename:=ThisWorkbook.Path & "\" & output_name, FileFormat:=xlNormal, _
    Password:="", WriteResPassword:="", ReadOnlyRecommended:=False, CreateBackup:=False
    ActiveWindow.Close
    MsgBox "导出成功!"
End Sub

'保护系统的复制功能===================================================
Sub copy_off()
    Dim CmdCtrls As CommandBarControls
    Dim Cmd As CommandBarControl
    Set CmdCtrls = Application.CommandBars.FindControls(id:=19)
    For Each Cmd In CmdCtrls
        Cmd.Enabled = False
    Next
    Application.CellDragAndDrop = False
    Application.OnKey ("^c"), ""
End Sub

'允许复制=============================================================
Sub copy_on()
    Dim CmdCtrls As CommandBarControls
    Dim Cmd As CommandBarControl
    Set CmdCtrls = Application.CommandBars.FindControls(id:=19)
    For Each Cmd In CmdCtrls
        Cmd.Enabled = True
    Next
    Application.CellDragAndDrop = True
    Application.OnKey ("^c")
End Sub

'导出工作簿中的图形'
Sub ExportShape(sheet_name as String)
    Dim Shp As Shape
    Dim FileName As String
    For Each Shp In ThisWorkbook.Worksheets(sheet_name).Shapes
        If Shp.Type = msoPicture Then
            FileName = ThisWorkbook.Path & "\" & Shp.Name & ".gif"
            Shp.Copy
            With ThisWorkbook.Worksheets(sheet_name).ChartObjects.Add(0, 0, Shp.Width + 28, Shp.Height + 30).Chart
                .Paste
                .Export FileName, "gif"
                .Parent.Delete
            End With
        End If
    Next
End Sub


Sub insertPic()
    Dim i As Integer
    Dim FilPath As String
    Dim rng As Range
    Dim s As String
    With Sheet1
        For i = 3 To .Range("a65536").End(xlUp).Row
            FilPath = ThisWorkbook.Path & "\" & .Cells(i, 1).Text & ".jpg"
            If Dir(FilPath) <> "" Then
                .Pictures.Insert(FilPath).Select
                Set rng = .Cells(i, 3)
                With Selection
                    .Top = rng.Top + 1
                    .Left = rng.Left + 1
                    .Width = rng.Width - 1
                    .Height = rng.Height - 1
                End With
            Else
                s = s & Chr(10) & .Cells(i, 1).Text
            End If
        Next
        .Cells(3, 1).Select
    End With
    If s <> "" Then
        MsgBox s & Chr(10) & "没有照片!"
    End If
End Sub

Sub DeletePic()
    Dim myShape As Shape
    For Each myShape In Sheet1.Shapes
        If myShape.Type = 13 Then
            myShape.Delete
        End If
    Next
End Sub

Sub ExportChart()
    Dim myChart As Chart
    Dim myFileName As String
    Set myChart = Sheet1.ChartObjects(1).Chart
    myFileName = "myChart.jpg"
    On Error Resume Next
    Kill ThisWorkbook.Path & "\" & myFileName
    myChart.Export Filename:=ThisWorkbook.Path & "\" & myFileName, Filtername:="JPG"
    MsgBox "图表已保存在[" & ThisWorkbook.Path & "]文件夹中!"
    Set myChart = Nothing
End Sub


'在工作表中添加图形'
Option Explicit
Sub AddShape()
    Dim myShape As Shape
    On Error Resume Next
    Sheet1.Shapes("myShape").Delete
    Set myShape = Sheet1.Shapes.AddShape(msoShapeRectangle, 40, 120, 280, 30)
    With myShape
        .Name = "myShape"
        With .TextFrame.Characters
            .Text = "单击将选择Sheet2!"
            With .Font
                .Name = "华文行楷"
                .FontStyle = "常规"
                .Size = 22
                .ColorIndex = 7
            End With
        End With
        With .TextFrame
            .HorizontalAlignment = -4108
            .VerticalAlignment = -4108
        End With
        .Placement = 3
    End With
    myShape.Select
    With Selection.ShapeRange
        With .Line
            .Weight = 1
            .DashStyle = msoLineSolid
            .Style = msoLineSingle
            .Transparency = 0
            .Visible = msoTrue
            .ForeColor.SchemeColor = 40
            .BackColor.RGB = RGB(255, 255, 255)
        End With
        With .Fill
            .Transparency = 0
            .Visible = msoTrue
            .ForeColor.SchemeColor = 41
            .OneColorGradient 1, 4, 0.23
        End With
    End With
    Sheet1.Range("A1").Select
    Sheet1.Hyperlinks.Add Anchor:=myShape, Address:="", _
        SubAddress:="Sheet2!A1", ScreenTip:="选择Sheet2!"
    Set myShape = Nothing
End Sub

Sub ErgShapes_2()
    Dim myShape As Shape
    Dim i As Integer
    i = 1
    For Each myShape In Sheet1.Shapes
        If myShape.Type = msoTextBox Then
            myShape.TextFrame.Characters.Text = "这是第" & i & "个文本框"
            i = i + 1
        End If
    Next
End Sub

Sub MoveShape()
    Dim i As Long
    Dim j As Long
    With Sheet1.Shapes(1)
        For i = 1 To 3000 Step 5
           .Top = Sin(i * (3.1416 / 180)) * 100 + 100
           .Left = Cos(i * (3.1416 / 180)) * 100 + 100
           .Fill.ForeColor.RGB = i * 100
            For j = 1 To 10
                .IncrementRotation -2
                DoEvents
            Next
        Next
    End With
End Sub

Sub ChartAdd()
    Dim myRange As Range
    Dim myChart As ChartObject
    Dim R As Integer
    With Sheet1
        .ChartObjects.Delete
        R = .Range("A65536").End(xlUp).Row
        Set myRange = .Range("A" & 1 & ":B" & R)
        Set myChart = .ChartObjects.Add(120, 40, 400, 250)
        With myChart.Chart
            .ChartType = xlColumnClustered
            .SetSourceData Source:=myRange, PlotBy:=xlColumns
            .ApplyDataLabels ShowValue:=True
            .HasTitle = True
            .ChartTitle.Text = "图表制作示例"
            With .ChartTitle.Font
                .Size = 20
                .ColorIndex = 3
                .Name = "华文新魏"
            End With
            With .ChartArea.Interior
                .ColorIndex = 8
                .PatternColorIndex = 1
                .Pattern = xlSolid
            End With
            With .PlotArea.Interior
                .ColorIndex = 35
                .PatternColorIndex = 1
                .Pattern = xlSolid
            End With
            .SeriesCollection(1).DataLabels.Delete
            With .SeriesCollection(2).DataLabels.Font
                .Size = 10
                .ColorIndex = 5
            End With
        End With
    End With
    Set myRange = Nothing
    Set myChart = Nothing
End Sub

Sub Specialmsbox()
    MsgBox Prompt:="欢迎光临 Excel Home!", Buttons:=vbOKCancel + vbInformation, Title:="Excel Home"
End Sub

'不打开工作簿取得其他工作簿数据
Sub CopyData_1()
    Dim Temp As String
    Temp = "'" & ThisWorkbook.Path & "\[数据表.xls]Sheet1'!"
    With Sheet1.Range("A1:F22")
        .FormulaR1C1 = "=" & Temp & "RC"
        .Value = .Value
    End With
End Sub
Sub CopyData_2()
    Dim Wb As Workbook
    Dim Temp As String
    Application.ScreenUpdating = False
    Temp = ThisWorkbook.Path & "\数据表.xls"
    Set Wb = GetObject(Temp)
        With Wb.Sheets(1).Range("A1").CurrentRegion
            Range("A1").Resize(.Rows.Count, .Columns.Count) = .Value
            Wb.Close False
        End With
    Set Wb = Nothing
    Application.ScreenUpdating = True
End Sub
Sub CopyData_3()
    Dim myApp As New Application
    Dim Sh As Worksheet
    Dim Temp As String
    Temp = ThisWorkbook.Path & "\数据表.xls"
    myApp.Visible = False
    Set Sh = myApp.Workbooks.Open(Temp).Sheets(1)
    With Sh.Range("A1").CurrentRegion
        Range("A1").Resize(.Rows.Count, .Columns.Count) = .Value
    End With
    myApp.Quit
    Set Sh = Nothing
    Set myApp = Nothing
End Sub
Sub CopyData_5()
    Dim Sql As String
    Dim j As Integer
    Dim R As Integer
    Dim Cnn As ADODB.Connection
    Dim rs As ADODB.Recordset
    With Sheet5
        .Cells.Clear
        Set Cnn = New ADODB.Connection
        With Cnn
            .Provider = "microsoft.jet.oledb.4.0"
            .ConnectionString = "Extended Properties=Excel 8.0;" _
                & "Data Source=" & ThisWorkbook.Path & "\数据表"
            .Open
        End With
        Set rs = New ADODB.Recordset
        Sql = "select * from [Sheet1$]"
        rs.Open Sql, Cnn, adOpenKeyset, adLockOptimistic
            For j = 0 To rs.Fields.Count - 1
                .Cells(1, j + 1) = rs.Fields(j).Name
            Next
        R = .Range("A65536").End(xlUp).Row
        .Range("A" & R + 1).CopyFromRecordset rs
    End With
    rs.Close
    Cnn.Close
    Set rs = Nothing
    Set Cnn = Nothing
End Sub


Sub 获取图书信息()
    sURL1 = "http://www.queshu.com/search/?c=9787121098284"  '
    Set xmlhttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
    With xmlhttp
        .Open "GET", sURL1, False
        .send
        stext = .responsetext
    End With
    oWindow.clipBoardData.setData "text", stext '写入剪贴板,粘贴在记事本中查看
    oDom.body.innerhtml = stext
    '网页中显示该书号共包含多少种书
    n = Mid(oWindow.Eval("$('.main_b_crumbs strong').eq(0).text()"), 2, 1)
    For j = 1 To Val(n) '遍历每图书的各项信息
        jg = oWindow.Eval("$('.dingjia').eq(" & j - 1 & ").text()") '读取定价
        pcy = oWindow.Eval("$('.left').parent().prev().eq(" & j - 1 & ").text()") '读取作者及出版日期等信息
        cps = oDom.getElementById("class_left").innerText '读取出版社
        sm = oWindow.Eval("$('.img120').eq(" & j - 1 & ").attr('alt')") '读取书名
    Next
End Sub

Sub bb()
    On Error Resume Next
    cx = URLEncode("查询")
    ReDim arr(1 To 1000, 1 To 4)
    With CreateObject("WinHttp.WinHttpRequest.5.1")
        .Open "GET", "http://www.zgcy.gov.cn/car_seek/index.asp", True
        .setRequestHeader "Referer", "http://www.zgcy.gov.cn/car_seek/index.asp"
        .setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        .setRequestHeader "Connection", "Keep-Alive"
        .Send
        cookies = Split(Split(.getallResponseHeaders, "Set-Cookie: ")(1), ";")(0)
        For r = 2 To 5
            ch = URLEncode(Sheets("提交数据").Cells(r, 1).Value)
            .Open "GET", "http://www.zgcy.gov.cn/car_seek/index.asp?car=" & ch & "&car_type=0&Submit=" & cx, True
            .setRequestHeader "Referer", "http://www.zgcy.gov.cn/car_seek/index.asp"
            .setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
            .setRequestHeader "Connection", "Keep-Alive"
            .setRequestHeader "Cookie", cookies
            .Send
            .WaitForResponse
            s = StrConv(.ResponseBody, vbUnicode, &H804)
            t = Filter(Filter(Split(s, "<td>"), "div align="), "</s", False)
            For x = 0 To UBound(t) - 1
                k = k + 1
                arr(k, 1) = Sheets("提交数据").Cells(r, 1).Value
                For y = 2 To 4
                    arr(k, y) = Split(Split(t(x), ">")(1), "<")(0)
                    x = x + 1
                Next y
                x = x - 1
            Next x
        Next r
    End With
    Sheets("结果").[a1048576].End(3)(2).Resize(UBound(arr), 4) = arr
End Sub


Sub cc()
    On Error Resume Next
    Cells.ClearContents
    str_ = Escape(Escape("国产药品"))
    Set Doc = CreateObject("htmlfile")
    Set doc1 = CreateObject("htmlfile")
    Set ww = CreateObject("WinHttp.WinHttpRequest.5.1")
    With CreateObject("msxml2.xmlhttp")
        k = 1
        For p = 1 To 5
            .Open "post", "http://app1.sfda.gov.cn/datasearch/face3/search.jsp", False
            .setRequestHeader "Content-Type", " application/x-www-form-urlencoded"
            .Send "tableId=25&State=1&bcId=124356560303886909015737447882&State=1&tableName=TABLE25&State=1&viewtitleName=COLUMN167&State=1&viewsubTitleName=COLUMN166,COLUMN170,COLUMN821&State=1&curstart=" & p & "&State=1&tableView=" & str_ & "&State=1"
            Doc.body.innerHTML = .responsetext
            Set r = Doc.All.Tags("table")(2).Rows
            For i = 0 To r.Length - 1 Step 2
                k = k + 1
                For j = 0 To r(i).Cells.Length - 1
                    Cells(k, j + 1) = r(i).Cells(j).innerText
                    sss = Split(r(i).Cells(j).All.Tags("a")(0).href, "'")(1)
                    ww.Open "GET", "http://app1.sfda.gov.cn/datasearch/face3/" & sss, False
                    ww.Send
                    doc1.body.innerHTML = ww.responsetext
                    Set r1 = doc1.All.Tags("table")(0).Rows
                    For m = 1 To r1.Length - 1
                        Cells(k, m + 1) = r1(m).Cells(1).innerText
                    Next m
                    Set r1 = Nothing
                Next j
            Next i
            Set r = Nothing
        Next p
    End With
End Sub

Sub list_dir_files_info(mypath as String)
    Dim I as integer
    Dim myname as string
    I=2
    Sheet1.cells.clear
    Myname=dir(mypath, vbarchive)
    Do while myname<>””
        If myname<>”.”and myname<>”..”then
            If getattr(mypath &myname)=vbarchive then
                Sheet1.cells(I,2)=myname
                Sheet1.cells(I,3)=filelen(mypath & myname)
                Sheet1.cells(I,4)=filedatetime(mypath & myname)
                Sheet1.cells(I,5)=mypath
                I=i+1
            End if
        End if
        Myname=dir
    Loop
End sub

Sub 查找内容()
    Dim jieguo As String, p As String, q As String
    Dim c As Range
    jieguo = Application.InputBox(prompt:="请输入要查找的值：", Title:="查找", Type:=2)
    If jieguo = "False" Or jieguo = "" Then Exit Sub
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    'value = Range("a:a").Find(Range("a3")).Row
    With ActiveSheet.Cells
        Set c = .Find(jieguo, , , xlColumns("1"), xlByColumns, xlNext, False)
        If Not c Is Nothing Then
            p = c.Address
            Do
                q = q & c.Address & vbCrLf
                Set c = .FindNext(c)
            Loop While Not c Is Nothing And c.Address <> p
        End If
    End With
    MsgBox "查找数据在以下单元格中：" & vbCrLf & vbCrLf & q, vbInformation + vbOKOnly, "查找结果"
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
End Sub

Function FormatSize(SZ)
    Dim i
    Do While SZ > 1024
        i = i + 1
        SZ = SZ \ 1024
    Loop
    FormatSize = "  (" & SZ & Mid(Unit4Size,1 + 2 * i,2) & ")"
End Function

'右键新建'
Function right_touch()
    filetype=".bat"
    Set wshshell=CreateObject("wscript.shell")
    prg=readreg("HKCR\"&filetype&"\")
    prgname=readreg("HKCR\"&prg&"\")
    ask="bat 脚本"
    title="创建新的bat脚本"
    prgname=InputBox(ask,title,prgname)
    wshshell.RegWrite "HKCR\"&prg&"\",prgname
    wshshell.RegWrite "HKCR\"&filetype&"\shellnew\nullfile",""
End Function

Function readreg(key)
    On Error Resume Next
    readreg=wshshell.RegRead(key)
    If Err.Number>0 Then
    Error="error:注册表键值"""&key_&"""不能找到!"
    MsgBox Error,vbCritical
    WScript.Quit
    End If
End Function

'删除右键新建'
function delete_right_touch()
    Set wshshell=CreateObject("wscript.shell")
    filetype=".bat"
    wshshell.RegDelete "HKCR\"&filetype&"\shellnew\"
    MsgBox "command removed!"
end function

'保存剪贴板中的文本并编辑
Function save_text()
    set fso=createobject("scripting.filesystemobject") : name=1
    Dim na
    na=Inputbox("请输入拓展名:","拓展名","txt")
    while fso.fileexists(name&"."&na)=true
    name=name+1
    wend
    set o=fso.opentextfile(name&"."&na,2,true)
    set hf=Createobject("htmlfile")
    wind=hf.parentwindow.clipboarddata.getdata("text")
    o.writeline wind : o.close
    createobject("wscript.shell").exec "notepad.exe "&name&"."&na&""
End Function

'描述:用vbs输出一个文件夹的目录结构。
Sub tree_list()
    Const Unit4Size = "字节KBMBGB"
    Const OutFile = "OutTree.txt"
    Dim theApp,SelPath,TreePath,TreeStr
    Set theApp = CreateObject("Shell.Application")
    Set SelPath = theApp.BrowseForFolder(0,"请选择需要列出子项目的路径",0)
    If SelPath Is Nothing Then WScript.Quit
    TreePath = SelPath.items.Item.Path
    Set SelPathPath = Nothing
    Set theApp = Nothing
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    TreeStr = TreePath & FormatSize(objFSO.GetFolder(TreePath).Size) & vbCrLf
    Tree(TreeStr, TreePath,"")
    Set objFile = objFSO.CreateTextFile(OutFile,True)
    objFile.Write TreeStr
    objFile.Close
    Set objFile = Nothing
    Set objFSO = Nothing
    MsgBox "查看当前目录下的OutTree.txt",vbInformation,"完成 - vbsTree"
End Sub
Private Sub Tree(TreeStr,Path,SFSpace)
    Dim i,TempStr,FlSpace
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    FlSpace = SFSpace & "  "
    Set CrntFolder = objFSO.GetFolder(Path)
    i = 0:TempStr = "├─"
    For Each ConFile In CrntFolder.Files
        i = i + 1
        If i = CrntFolder.Files.Count And CrntFolder.SubFolders.Count = 0 Then TempStr = "└─"
        TreeStr = TreeStr & FlSpace & Tempstr & ConFile.name & FormatSize(ConFile.size) & vbCrLf
    Next
    i = 0:TempStr = "├─"
    For Each SubFolder In CrntFolder.SubFolders
        i = i + 1
        If i = CrntFolder.SubFolders.Count Then
            TempStr = "└─"
            SFSpace = FlSpace & "  "
        Else
            SFSpace = FlSpace & "│"
        End If
        TreeStr = TreeStr & FlSpace & TempStr & SubFolder.name & FormatSize(SubFolder.size) & vbCrLf
        Tree(TreeStr,SubFolder,(SFSpace))
    Next
End Sub
