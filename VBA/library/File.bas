Attribute VB_Name = "LIB_File"
Option Explicit
Public Const ZipTool_local_path = "\7za\7za"
Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Declare Function GetTempPathA Lib "kernel32" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long

Function FileExists(strFileFullPath As String) As Boolean
    Dim objFSO As Object
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(strFileFullPath) Then FileExists = True
    Set objFSO = Nothing
End Function

Public Function FileExists(ByVal testFilename As String, Optional findFolders As Boolean = False) As Boolean
    ' Include read-only files, hidden files, system files.
    Dim attrs As Long
    attrs = (vbReadOnly Or vbHidden Or vbSystem)
    If findFolders Then
        attrs = (attrs Or vbDirectory) ' Include folders as well.
    End If
    FileExists = False
    On Error Resume Next
    FileExists = (Dir(TrimTrailingChars(testFilename, "/\"), attrs) <> "")
End Function

'Check whether a file exists
Function FileExists(ByVal strFile As String, Optional bFindFolders As Boolean) As Boolean
    Dim lngAttributes As Long
    lngAttributes = (vbReadOnly Or vbHidden Or vbSystem)
    If bFindFolders Then
        lngAttributes = (lngAttributes Or vbDirectory) 'Include folders as well.
    Else
        Do While Right$(strFile, 1) = "\"
            strFile = Left$(strFile, Len(strFile) - 1)
        Loop
    End If
    On Error Resume Next
    FileExists = (Len(Dir(strFile, lngAttributes)) > 0)
End Function

Function FileExist(ByVal FilePath As String, ByVal FileName As String, Optional ByVal FileType As String = "NotGiven") As Boolean
    Dim fName As String
    FileExist = False
    FilePath = IIf(Right(FilePath, 1) <> "\", FilePath & "\", FilePath)
    If FileType <> "NotGiven" Then
        If Right(FileName, 1) = "." Then
            FileName = Left(FileName, Len(FileName) - 1)
        End If
        If Left(FileType, 1) <> "." Then
            FileType = "." & FileType
        End If
        fName = FilePath & FileName & FileType
    Else
        fName = FilePath & FileName
    End If
    If Dir(fName) <> "" Then
        FileExist = True
    End If
End Function

Sub FileExistList()
    'Define all the variables/options.
    Dim i As Long           'Iteration counter
    Dim LastRow As Long     'Last row to evaluate
    Dim FirstRow As Long    'First row to evaluate
    Dim fPath As String     'Directory where files should be
    Dim fName As String     'File name (pulled from spreadsheet)
    Dim fType As String     'File type (required by FileExist; can be used as array)
    Dim nCol As Long        'Column where file names live
    Dim rCol As Long        'Column where results are printed
    Dim rTrue As String     'Text to return if file exists
    Dim rFalse As String    'Text to return if file does not exist
    FirstRow = 2
    LastRow = FindLastRow(3)
    nCol = 3
    rCol = 2
    fPath = "V:\Corporate\Tax\Public\Axip\Tx_Audit\Invoices\"
    rTrue = "Y"
    rFalse = "File not found"
    For i = FirstRow To LastRow
        fName = Cells(i, nCol)
        If FileExist(fPath, fName) Then
            Cells(i, rCol) = rTrue
        Else
            Cells(i, rCol) = rFalse
        End If
    Next i
End Sub

'递归创建文件夹
Public Sub MkDirRecursive(folderName As String)
    MkDirRecursiveInternal folderName, folderName
End Sub
Private Sub MkDirRecursiveInternal(folderName As String, _
    originalFolderName As String)
    If folderName = "" Then
        Err.Raise 32000, _
            Description:="Failed to create folder: " & originalFolderName
    End If
    Dim parentFolderName As String
    parentFolderName = GetDirectoryName(folderName)
    If Not FolderExists(parentFolderName) Then
        MkDirRecursiveInternal parentFolderName, originalFolderName
    End If
    If Not FolderExists(folderName) Then
        MkDir folderName
    End If
End Sub

' Lists all files matching the given pattern.- C:\Path\to\Folder\ExcelFiles.xl*
Public Function ListFiles(filePattern As String) As Variant()
    ListFiles = ListFiles_Internal(filePattern, vbReadOnly Or vbHidden Or vbSystem)
End Function

' Lists all folders matching the given pattern.- C:\Path\to\Folder\OtherFolder_*
Public Function ListFolders(folderPattern As String) As Variant()
    ListFolders = ListFiles_Internal(folderPattern, vbReadOnly Or vbHidden Or vbSystem Or vbDirectory)
End Function

'列举所有复核该规则的文件
Private Function ListFiles_Internal(filePattern As String, attrs As Long) As Variant()
    Dim filesList As New VBALib_List
    Dim folderName As String
    If FolderExists(filePattern) Then
        filePattern = NormalizePath(filePattern) & "\"
        folderName = filePattern
    Else
        folderName = GetDirectoryName(filePattern) & "\"
    End If
    Dim currFilename As String
    currFilename = Dir(filePattern, attrs)
    While currFilename <> ""
        If (attrs And vbDirectory) = vbDirectory Then
            If FolderExists(folderName & currFilename) _
                And currFilename <> "." And currFilename <> ".." Then
                filesList.Add folderName & currFilename
            End If
        Else
            filesList.Add folderName & currFilename
        End If
        currFilename = Dir
    Wend
    ListFiles_Internal = filesList.Items
End Function

Sub ListFiles(ByVal strPath As String, ByVal cellDestination As Range)
    Dim counter As Integer
    Dim File As String
    strPath = checkFolder(strPath)
    File = Dir$(strPath & Extention)
    Do While Len(File)
        File = Dir$
        counter = counter + 1
    Loop
    If (counter = 0) Then Exit Sub
    ReDim filesTab(counter - 1)
    counter = 0
    File = Dir$(strPath & Extention)
    ' List the files and display them in the cells
    Do While Len(File) And counter <= UBound(filesTab)
        cellDestination.Offset(counter, 0) = File
        cellDestination.Offset(counter, 1) = strPath & File
        File = Dir$
        counter = counter + 1
    Loop
End Sub

'Example: ListFilesInFolder "C:\FolderName\", True
Sub ListFilesInFolder(ByVal SourceFolderName As String, Optional ByVal IncludeSubfolders As Boolean)
    On Error GoTo ExitSub
    Dim FSO As Object
    Dim SourceFolder As Object
    Dim SubFolder As Object
    Dim FileItem As Object
    Dim r As Long
    Set FSO = CreateObject("Scripting.FileSystemObject")
    Set SourceFolder = FSO.GetFolder(SourceFolderName)
    r = Range("A65536").End(xlUp).Row + 1
    For Each FileItem In SourceFolder.Files
        'display file properties
        Cells(r, 1).Formula = FileItem.Name
        '***** Remove the ' character in lines below to get information *****
        'Cells(r, 2).Formula = FileItem.Path
        'Cells(r, 3).Formula = FileItem.Size
        'Cells(r, 4).Formula = FileItem.DateCreated
        'Cells(r, 5).Formula = FileItem.DateLastModified
        'Cells(r, 6).Formula = GetFileOwner(SourceFolder.Path, FileItem.Name)
        r = r + 1 ' next row number
        'X = SourceFolder.Path
    Next FileItem
    If IncludeSubfolders Then
        For Each SubFolder In SourceFolder.SubFolders
            ListFilesInFolder SubFolder.Path, True
        Next SubFolder
    End If
    '***** Remove the single ' character in the below lines to adjust the column windths
    'Columns("A:G").ColumnWidth = 4
    'Columns("H:I").AutoFit
    'Columns("J:L").ColumnWidth = 12
    'Columns("M:P").ColumnWidth = 8
ExitSub:
    Set FileItem = Nothing
    Set SourceFolder = Nothing
    Set FSO = Nothing
End Sub

' Add a trailing slash if needed
Function checkFolder(ByVal strPath As String) As String
    If Right$(strPath, 1) <> "\" Then strPath = strPath & "\"
    strPath = Replace(strPath, "/", "\")
    strPath = Replace(strPath, "\\", "\")
    createDirs (strPath)
    checkFolder = strPath
End Function

' Description:  Check if folder path exists
Public Function checkFolder(strFolderPath As String) As Boolean
  If cEnableErrorHandling Then: On Error GoTo errHandler
  Dim fso As Scripting.FileSystemObject
  Set fso = New FileSystemObject
  If fso.FolderExists(strFolderPath) <> 0 Then: checkFolder = True
exitMe:
  Set fso = Nothing
  Exit Function
errHandler:
  errMessage "checkFolder", Err.Number, Err.Description
  Resume exitMe
End Function

Function folderExists(ByVal fullPath As String) As String
    Dim fs
    Set fs = CreateObject("Scripting.FileSystemObject")
    folderExists = fs.folderExists(fullPath)
End Function

' Determines whether a folder with the given name exists.
Public Function FolderExists(folderName As String) As Boolean
    On Error Resume Next
    FolderExists = ((GetAttr(folderName) And vbDirectory) = vbDirectory)
End Function

'Returns the selected folder path as a string value
Function getFolder(Optional dialogTitle As String = vbNullString, _
                   Optional dialogButtonName As String = vbNullString, _
                   Optional dialogStartFolder As String = vbNullString, _
                   Optional dialogView As MsoFileDialogView = msoFileDialogViewList) As String
  If cEnableErrorHandling Then On Error Resume Next
  Dim folderSelection As Variant
  With Application.FileDialog(msoFileDialogFolderPicker)
    If dialogTitle <> vbNullString Then: .Title = dialogTitle
    If dialogButtonName <> vbNullString Then: .ButtonName = dialogButtonName
    .InitialView = dialogView
    .AllowMultiSelect = False
    If dialogStartFolder <> vbNullString Then
      If Dir(dialogStartFolder, vbDirectory) <> vbNullString Then
        If Right(dialogStartFolder, 1) <> "\" Then
          dialogStartFolder = dialogStartFolder & "\"
          .InitialFileName = dialogStartFolder
        End If
      Else
        .InitialFileName = CurDir
      End If
    End If
    .Show
    Err.Clear
    '*** Set to selected item; if cancel will cause error
    folderSelection = .SelectedItems(1)
    If Err.Number <> 0 Then: folderSelection = vbNullString
  End With
  '*** Set function to string value of folderSelection
  getFolder = CStr(folderSelection)
End Function

Sub ListFolder(sFolderPath As String, ByVal cellDestination As Range)
    Dim fs As New FileSystemObject
    Dim FSfolder As Folder
    Dim subfolder As Folder
    Dim i As Integer
    Set FSfolder = fs.GetFolder(sFolderPath)
    i = 0
    For Each subfolder In FSfolder.SubFolders
        DoEvents
        i = i + 1
        cellDestination.Offset(i, 0) = subfolder.Name
    Next subfolder
    Set FSfolder = Nothing
End Sub

Function createFolder(ByVal fullPath As String) As Boolean
    If (folderExists(fullPath) = False) Then MkDir (fullPath)
End Function

Function createDirs(ByVal fullPath As String) As String
    fullPath = checkFolder(fullPath)
    paths = Split(fullPath, "\")
    currentPath = paths(0) & "\"
    folderCreated = 0
    For i = 1 To UBound(paths) - 1
        currentPath = currentPath & paths(i) & "\"
        If folderExists(currentPath) = False Then
            createFolder (currentPath)
            folderCreated = folderCreated + 1
        End If
    Next
    createDirs = folderCreated & " folder(s) has/have been generated"
End Function

' Sub TestListFolders()
'     Application.ScreenUpdating = False
'     cells.Delete
'     With Range("A1")
'         .Formula = "Folder contents:"
'         .Font.Bold = True
'         .Font.Size = 12
'     End With
'     Range("A3").Formula = "Folder Path:"
'     Range("B3").Formula = "Folder Name:"
'     Range("C3").Formula = "Size:"
'     Range("D3").Formula = "Subfolders:"
'     Range("E3").Formula = "Files:"
'     Range("F3").Formula = "Short Name:"
'     Range("G3").Formula = "Short Path:"
'     Range("A3:G3").Font.Bold = True
'     listFoldersFullInfo "H:\User\02. Projects\", False
'     Application.ScreenUpdating = True
' End Sub
' lists information about the folders in SourceFolder example: ListFolders "C:\", True
Sub listFoldersFullInfo(SourceFolderName As String, IncludeSubfolders As Boolean)
    Dim FSO As Scripting.FileSystemObject
    Dim SourceFolder As Scripting.Folder, subfolder As Scripting.Folder
    Dim r As Long
    Set FSO = New Scripting.FileSystemObject
    Set SourceFolder = FSO.GetFolder(SourceFolderName)
    On Error Resume Next
     ' display folder properties
    r = Range("A65536").End(xlUp).Row + 1
    cells(r, 1).Formula = SourceFolder.Path
    cells(r, 2).Formula = SourceFolder.Name
    cells(r, 3).Formula = SourceFolder.Size
    cells(r, 4).Formula = SourceFolder.SubFolders.Count
    cells(r, 5).Formula = SourceFolder.Files.Count
    cells(r, 6).Formula = SourceFolder.ShortName
    cells(r, 7).Formula = SourceFolder.ShortPath
    If IncludeSubfolders Then
        For Each subfolder In SourceFolder.SubFolders
            listFolders subfolder.Path, True
        Next subfolder
        Set subfolder = Nothing
    End If
    Columns("A:G").AutoFit
    Set SourceFolder = Nothing
    Set FSO = Nothing
End Sub

'路径拼接
Public Function CombinePaths(p1 As String, p2 As String) As String
    CombinePaths = TrimTrailingChars(p1, "/\") & "\" & TrimLeadingChars(p2, "/\")
End Function

' 格式化路径
Public Function NormalizePath(ByVal p As String) As String
    Dim isUNC As Boolean
    isUNC = StartsWith(p, "\\")
    p = Replace(p, "/", "\")
    While InStr(p, "\\") > 0
        p = Replace(p, "\\", "\")
    Wend
    If isUNC Then p = "\" & p
    NormalizePath = TrimTrailingChars(p, "\")
End Function

' Returns the folder name of a path (removes the last component of the path).
Public Function GetDirectoryName(ByVal p As String) As String
    p = NormalizePath(p)
    Dim i As Integer
    i = InStrRev(p, "\")
    If i = 0 Then
        GetDirectoryName = ""
    Else
        GetDirectoryName = Left(p, i - 1)
    End If
End Function

' Returns the filename of a path (the last component of the path).
Public Function GetFilename(ByVal p As String) As String
    p = NormalizePath(p)
    Dim i As Integer
    i = InStrRev(p, "\")
    GetFilename = Mid(p, i + 1)
End Function

' Returns the extension of a filename (including the dot).
Public Function GetFileExtension(ByVal p As String) As String
    Dim i As Integer
    i = InStrRev(p, ".")
    If i > 0 Then
        GetFileExtension = Mid(p, i)
    Else
        GetFileExtension = ""
    End If
End Function

' 返回可用于存储临时文件的文件夹的路径
Public Function GetTempPath() As String
    Const MAX_PATH = 256
    Dim folderName As String
    Dim ret As Long
    folderName = String(MAX_PATH, 0)
    ret = GetTempPathA(MAX_PATH, folderName)
    If ret <> 0 Then
        GetTempPath = Left(folderName, InStr(folderName, Chr(0)) - 1)
    Else
        Err.Raise 32000, Description:= "Error getting temporary folder."
    End If
End Function

Function GetOutputFolder(Optional startFolder As Variant = -1) As Variant
    Dim fldr As FileDialog
    Dim vItem As Variant
    Set fldr = Application.FileDialog(msoFileDialogFolderPicker)
    With fldr
        .Title = "Select a Folder"
        .AllowMultiSelect = False
        If startFolder = -1 Then
            .InitialFileName = Application.DefaultFilePath
        Else
            If Right(startFolder, 1) <> "\" Then
                .InitialFileName = startFolder & "\"
            Else
                .InitialFileName = startFolder
            End If
        End If
        If .Show <> -1 Then GoTo NextCode
        vItem = .SelectedItems(1)
    End With
NextCode:
    GetOutputFolder = vItem
    Set fldr = Nothing
End Function

Function GetFileOwner(ByVal FilePath As String, ByVal FileName As String)
    On Error GoTo ExitSub
    Dim objFolder As Object
    Dim objFolderItem As Object
    Dim objShell As Object
    FileName = StrConv(FileName, vbUnicode)
    FilePath = StrConv(FilePath, vbUnicode)
    Set objShell = CreateObject("Shell.Application")
    Set objFolder = objShell.Namespace(StrConv(FilePath, vbFromUnicode))
    If Not objFolder Is Nothing Then
        Set objFolderItem = objFolder.ParseName(StrConv(FileName, vbFromUnicode))
    End If
    If Not objFolderItem Is Nothing Then
        GetFileOwner = objFolder.GetDetailsOf(objFolderItem, 8)
    Else
        GetFileOwner = ""
    End If
ExitSub:
    Set objShell = Nothing
    Set objFolder = Nothing
    Set objFolderItem = Nothing
End Function

Function getFileUpdateTime(ByVal file As String) As Double
    getFileUpdateTime = FileDateTime(file)
End Function

Function GetFileName(strFilePath As String) As String
    Dim strFileName As String
    GetFileName = ""
    If InStr(1, strFilePath, "\") > 0 Then
        strFileName = Split(strFilePath, "\")(UBound(Split(strFilePath, "\")))
        GetFileName = strFileName
    ElseIf InStr(1, strFilePath, "/") > 0 Then
        strFileName = Split(strFilePath, "/")(UBound(Split(strFilePath, "/")))
        GetFileName = strFileName
    End If
End Function

'查找文件夹中文件创建时间最早的文件
Function getOldestFileInDir(ByVal path As String, ByVal fileNameMask As String) As Date
    Dim FileName As String, FileDir As String, FileSearch As String
    Dim MaxDate As Date, interDate As Date, dteFile As Date
    MaxDate = DateSerial(1900, 1, 1)
    FileDir = path
    FileName = fileNameMask
    FileSearch = Dir(FileDir & FileName)
    While Len(FileSearch) > 0
        dteFile = FileDateTime(FileDir & FileSearch)
        If dteFile > MaxDate Then
            MaxDate = dteFile
        End If
        FileSearch = Dir()
    Wend
    getOldestFileInDir = MaxDate
End Function

Function SelectFile() As String
    With Application.FileDialog(msoFileDialogOpen)
        .AllowMultiSelect = False
        .Show
        If .SelectedItems.Count <> 0 Then
            SelectFileName = .SelectedItems(1)
        End If
    End With
End Function

'带头斜线'
Private Function stripLeadingSlashes(ByVal strText As String) As String
    Dim lngCounter As Long
    Dim lngStringLength As Long
    lngStringLength = Len(strText)              'Define string length
    For lngCounter = 1 To Len(strText)
        Select Case Left(strText, 1)            'Loop through string
            Case "\", "/"                       'If char is slash, strip it
                strText = Right(strText, lngStringLength - 1)
                lngStringLength = lngStringLength - 1
            Case Else                           'If char is not slash, exit
                stripLeadingSlashes = strText
                GoTo exitMe
        End Select
    Next lngCounter
exitMe:
                                                'Nothing to clean up
End Function

Private Function stripTrailingSlashes(ByVal strText As String) As String
    Dim lngCounter As Long
    Dim lngStringLength As Long
    lngStringLength = Len(strText)              'Define string length
    For lngCounter = 1 To Len(strText)
        Select Case Right(strText, 1)            'Loop through string
            Case "\", "/"                       'If char is slash, strip it
                strText = Left(strText, lngStringLength - 1)
                lngStringLength = lngStringLength - 1
            Case Else                           'If char is not slash, exit
                stripTrailingSlashes = strText
                GoTo exitMe
        End Select
    Next lngCounter
exitMe:
                                                'Nothing to clean up
End Function

Function writeFile(ByVal File As String, ByVal content As String) As String
   Open File For Output As #1
   Print #1, content
   Close #1
   writeFile = "File updated yet"
End Function

'写入内容到文件'
Private Sub write_to_file(inputed_string As String, log_path As String)
   Dim objFSO, logfile, logtext
   Set objFSO = CreateObject("Scripting.FileSystemObject")
   On Error Resume Next
   If objFSO.FileExists(log_path) = 0 Then
       Set logfile = objFSO.CreateTextFile(log_path, True, -1)
   End If
   Set logfile = Nothing
   Set logtext = objFSO.OpenTextFile(log_path, 2, True, -1)
   logtext.Write inputed_string
   logtext.Close
   Set objFSO = Nothing
End Sub

Function SaveFileAs(FileName as String, FilePath as string, Optional WorkbookName as Workbook = ActiveWorkbook.Name) as Boolean
  Workbooks(WorkBookName).SaveAs FileName:=FileName
    ActiveWorkbook.SaveAs Filename:=thisWb.Path & "\new workbook.xls"
    ActiveWorkbook.Close savechanges:=False
End Sub

'读取文件内容
Private Function ReadOut(FullPath)
    On Error Resume Next
    Dim Fso, FileText
    Set Fso = CreateObject("scRiPTinG.fiLEsysTeMoBjEcT")
    Set FileText = Fso.OpenTextFile(FullPath, 1, True)
    ReadOut = FileText.ReadAll
    FileText.Close
End Function

'Copy("C:/*.xlsx", "D:/")
Function Copy(strSourceFullPath As String, strCopyToDestination As String) As String
    Dim objFSO As Object
    If Right(strCopyToDestination, 1) <> "\" Then strCopyToDestination = strCopyToDestination & "\"
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If GetFileName(strSourceFullPath) <> "" And objFSO.FolderExists(strCopyToDestination) Then
        objFSO.CopyFile Source:=strSourceFullPath, Destination:=strCopyToDestination, overwritefiles:=True
    End If
    Set objFSO = Nothing
    Copy = "CopyFile performed. Source=" & strSourceFullPath & " Destination=" & strCopyToDestination
End Function

'Copy File without error msg
Public Sub CopyFile(Src As String, des As String)
    Dim objFSO As Object
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    'object.copyfile,source,destination,file over right (True is default)
    objFSO.CopyFile Src, des, True
    Set objFSO = Nothing
End Sub

Sub Clear_All_data_In_Folder(MyPath As String)
    If Right(MyPath, 1) = "\" Then
        MyPath = Left(MyPath, Len(MyPath) - 1)
    End If
    Dim FSO As Object
    Set FSO = CreateObject("scripting.filesystemobject")
    If FSO.FolderExists(MyPath) = False Then
        MsgBox MyPath & " doesn't exist"
        Exit Sub
    End If
    On Error Resume Next
    FSO.DeleteFile MyPath & "\*.*", True
    FSO.DeleteFolder MyPath & "\*.*", True
    On Error GoTo 0
End Sub

Function readFile(ByVal File As String, Optional createFile As Boolean) As String
    If (IsMissing(createFile)) Then createFile = False
    If (fileExists(File) = False) Then
        If (createFile = True) Then
            temp = writeFile(File, "")
        Else
            readFile = "Error : File does not exists"
            Exit Function
        End If
    End If
    Dim MyString, MyNumber
    Open File For Input As #1 ' Open file for input.
    fileContent = ""
    Do While Not EOF(1) ' Loop until end of file.
        Line Input #1, MyString
        Debug.Print MyString
        fileContent = fileContent & MyString & " "
    Loop
    Close #1 ' Close file.
    readFile = fileContent
End Function

'Count Row Number of a text file
Public Function CountRowsInText(file_name As String) As Long
    On Error GoTo Err_CountRowsInText
    Dim fso As Object
    Dim File As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set File = fso.OpenTextFile(file_name, 1)
    Dim RowCnt As Long
    Dim str_line As String
    RowCnt = 0
    Do Until File.AtEndOfStream = True
        RowCnt = RowCnt + 1
        str_line = File.ReadLine
    Loop
    File.Close
Exit_CountRowsInText:
    CountRowsInText = RowCnt
    Exit Function
Err_CountRowsInText:
    RowCnt = -1
    Call ShowMsgBox(Err.Description)
    Resume Exit_CountRowsInText
End Function

'Split a Text File into multiple text files of specified row count(default: 65535)
Public Function SplitTextFile(src As String, Optional des_fmt As String, Optional RowCntPerFile As Long = 65535, Optional file_idx_start As Integer = 0, Optional NumOfHdrRows As Long = 0, Optional DeleteSrc As Boolean = False) As String
    On Error GoTo Err_SplitTextFile
    Dim FailedReason As String
    If Len(Dir(src)) = 0 Then
        FailedReason = src
        GoTo Exit_SplitTextFile
    End If
    If RowCntPerFile < NumOfHdrRows + 1 Then
        FailedReason = "RowCntPerFile < NumOfHdrRows + 1"
        GoTo Exit_SplitTextFile
    End If
    'if no need to split, return
    Dim RowCnt_src As Long
    RowCnt_src = CountRowsInText(src)
    If RowCnt_src <= RowCntPerFile Then
        GoTo Exit_SplitTextFile
    End If
    'Check whether there exists files which name is same to the splitted files
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim des_dir As String
    Dim des_name As String
    Dim des_ext As String
    Dim des_path As String
    des_dir = fso.GetParentFolderName(src)
    des_name = fso.GetFileName(src)
    des_ext = fso.GetExtensionName(src)
    If des_fmt = "" Then
        des_fmt = Left(des_name, Len(des_name) - Len("." & des_ext)) & "_*"
    End If
    Dim NumOfSplit As Integer
    If RowCnt_src <= RowCntPerFile Then
        NumOfSplit = 0
    Else
        NumOfSplit = Int((RowCnt_src - RowCntPerFile) / (RowCntPerFile + 1 - NumOfHdrRows)) + 1
    End If
    Dim file_idx_end As Integer
    file_idx_end = file_idx_start + NumOfSplit 'Int(RowCnt_src / (RowCntPerFile + 1 - NumOfHdrRows))
    Dim file_idx As Integer
    For file_idx = file_idx_start To file_idx_end
        des_path = des_dir & "\" & Replace(des_fmt, "*", str(file_idx)) & "." & des_ext
    If Len(Dir(des_path)) > 0 Then
            Exit For
        End If
    Next file_idx
    If Len(Dir(des_path)) > 0 Then
        FailedReason = des_path
        GoTo Exit_SplitTextFile
    End If
    'Obtain header rows for later files and create the first splitted file
    Dim File_src As Object
    Dim FileNum_des As Integer
    Dim str_line As String
    Dim HdrRows As String
    Set File_src = fso.OpenTextFile(src, 1)
    des_path = des_dir & "\" & Replace(des_fmt, "*", str(file_idx_start)) & "." & des_ext
    FileNum_des = FreeFile
    Open des_path For Output As #FileNum_des
    RowCnt = 0
    Do Until RowCnt >= NumOfHdrRows Or File_src.AtEndOfStream = True
        RowCnt = RowCnt + 1
        str_line = File_src.ReadLine
        Print #FileNum_des, str_line
        HdrRows = HdrRows & str_line
    Loop
    Do Until RowCnt >= RowCntPerFile Or File_src.AtEndOfStream = True
        RowCnt = RowCnt + 1
        Print #FileNum_des, File_src.ReadLine
    Loop
    Close #FileNum_des
    'Start to split
    For file_idx = file_idx_start + 1 To file_idx_end
        If File_src.AtEndOfStream = True Then
            Exit For
        End If
        des_path = des_dir & "\" & Replace(des_fmt, "*", str(file_idx)) & "." & des_ext
        FileNum_des = FreeFile
        Open des_path For Output As #FileNum_des
        RowCnt = NumOfHdrRows
        Print #FileNum_des, HdrRows
        Do Until RowCnt >= RowCntPerFile Or File_src.AtEndOfStream = True
            RowCnt = RowCnt + 1
            Print #FileNum_des, File_src.ReadLine
        Loop
        Close #FileNum_des
        Next file_idx
    File_src.Close
    If DeleteSrc = True Then
        Kill src
    End If
Exit_SplitTextFile:
    SplitTextFile = FailedReason
    Exit Function
Err_SplitTextFile:
    FailedReason = Err.Description
    Resume Exit_SplitTextFile
End Function

'Delete rows in a text file
Public Function DeleteRowInText(file_name As String, StartRow As Long, EndRow As Long) As String
    On Error GoTo Err_DeleteRowInText
    Dim FailedReason As String
    If EndRow < StartRow Then
        EndRow = StartRow
    End If
    Dim temp_file_name As String
    temp_file_name = file_name & "_temp"
    On Error Resume Next
    Kill temp_file_name
    On Error GoTo Err_DeleteRowInText
    Dim temp_file_PortNum As Integer
    temp_file_PortNum = FreeFile
    Open temp_file_name For Output As #temp_file_PortNum
    Dim fso As Object
    Dim File As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set File = fso.OpenTextFile(file_name, 1)
    Dim row As Long
    Dim str_line As String
    row = 0
    Do Until File.AtEndOfStream = True 'EOF(2)
        row = row + 1
        str_line = File.ReadLine
        If row >= StartRow And row <= EndRow Then
            GoTo Loop_DeleteRowInText_1
        End If
        Print #temp_file_PortNum, str_line
        Loop_DeleteRowInText_1:
    Loop
    File.Close
    Close #temp_file_PortNum
    Kill file_name
    Name temp_file_name As file_name
Exit_DeleteRowInText:
    DeleteRowInText = FailedReason
    Exit Function
Err_DeleteRowInText:
    FailedReason = Err.Description
    GoTo Exit_DeleteRowInText
End Function

'Replace multiple strings in a file
Function ReplaceStrInFile(file_name As String, Arr_f As Variant, Arr_r As Variant, Optional StartRow As Long = 0) As String
    On Error GoTo Err_ReplaceStrInFile
    Dim FailedReason As String
    Dim temp_file_name As String
    temp_file_name = file_name & "_temp"
    On Error Resume Next
    Kill temp_file_name
    On Error GoTo Err_ReplaceStrInFile
    Dim iFileNum As String
    iFileNum = FreeFile()
    Open temp_file_name For Output As #iFileNum
    Dim fso As Object
    Dim File As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set File = fso.OpenTextFile(file_name, 1)
    Dim row As Long
    Dim str_line As String
    Dim i As Integer
    Dim str_f As String
    Dim str_r As String
    row = 0
    Do Until File.AtEndOfStream = True 'EOF(2)
        row = row + 1
        str_line = File.ReadLine
        If row < StartRow Then
            GoTo Loop_ReplaceStrInFile_1
        End If
        For i = 0 To UBound(Arr_f)
            str_f = Arr_f(i)
            str_r = Arr_r(i)
        str_line = Replace(str_line, str_f, str_r)
        Next i
        Loop_ReplaceStrInFile_1:
        Print #iFileNum, str_line
    Loop
    File.Close
    Close iFileNum
    Kill file_name
    Name temp_file_name As file_name
    Exit_ReplaceStrInFile:
    ReplaceStrInFile = FailedReason
    Exit Function
Err_ReplaceStrInFile:
    FailedReason = Err.Description
    GoTo Exit_ReplaceStrInFile
End Function

'Unzip multiple files in directory
Public Function ExtractZipInDir(SrcDir As String, DesDir As String, Optional DeleteZipFile As Boolean = False) As String
    On Error GoTo Err_ExtractZip
    Dim FailedReason As String
    Dim Result As String
    Result = Dir(SrcDir)
    Do While Len(Result) > 0
        Call ExtractZip(SrcDir & Result, DesDir, DeleteZipFile)
        Result = Dir
    Loop
Exit_ExtractZip:
    ExtractZipInDir = FailedReason
    Exit Function
Err_ExtractZip:
    FailedReason = Err.Description
    Resume Exit_ExtractZip
End Function

'Unzip a file
Public Function ExtractZip(Src As String, DesDir As String, Optional DeleteZipFile As Boolean = False) As String
    On Error GoTo Err_ExtractZip
    Dim FailedReason As String
    Dim ZipTool_path As String
    ZipTool_path = [CurrentProject].[Path] & ZipTool_local_path
    Dim ShellCmd As String
    Dim Success As Boolean
    ShellCmd = ZipTool_path & " x " & Src & " -o" & DesDir & " -ry"
    'MsgBox ShellCmd
    Success = ShellAndWait(ShellCmd, vbHide)
    If Success = True And DeleteZipFile = True Then
        Kill Src
    End If
Exit_ExtractZip:
    ExtractZip = FailedReason
    Exit Function
Err_ExtractZip:
    FailedReason = Err.Description
    Resume Exit_ExtractZip
End Function

'Create empty Zip File
Sub NewZip(sPath)
    If Len(Dir(sPath)) > 0 Then Kill sPath
    Open sPath For Output As #1
    Print #1, Chr$(80) & Chr$(75) & Chr$(5) & Chr$(6) & String(18, 0)
    Close #1
End Sub

Function Zip(strZipPath As String, strFilePath As String, Optional strZipFileName As String) As String
    Dim objApp As Object
    Dim intCount As Integer
    Dim arryFiles, ZipFile
    arryFiles = Array(strFilePath) 'You can add additional param strFilePath2 as function input and add it to the array so it would zip two files...
    If Right(strZipPath, 1) <> "\" Then strZipPath = strZipPath & "\"
    If strZipFileName <> "" Then
        ZipFile = strZipPath & strZipFileName & ".zip"
    Else
        ZipFile = strZipPath & GetFileName(strFilePath) & ".zip"
    End If
    If IsArray(arryFiles) Then
        If Len(Dir(ZipFile)) > 0 Then Kill ZipFile
        Open ZipFile For Output As #1
        Print #1, Chr$(80) & Chr$(75) & Chr$(5) & Chr$(6) & String(18, 0)
        Close #1
        Set objApp = CreateObject("Shell.Application")
        For intCount = LBound(arryFiles) To UBound(arryFiles)
            objApp.Namespace(ZipFile).CopyHere arryFiles(intCount)
        Next intCount
    End If
    Set objApp = Nothing
    Zip = ZipFile
End Function

Sub Zip_All_Files_in_Folder(FolderName As Variant, FileNameZip As Variant)
    'Code modified from example found here: http://www.rondebruin.nl/win/s7/win001.htm
    Dim strDate As String, DefPath As String
    Dim oApp As Object
    NewZip (FileNameZip)
    Set oApp = CreateObject("Shell.Application")
    'Copy the files to the compressed folder
    oApp.Namespace("" & FileNameZip).CopyHere oApp.Namespace("" & FolderName).Items             '""& added due to bug in VBA
    'Keep script waiting until Compressing is done
    On Error Resume Next
    Do Until oApp.Namespace("" & FileNameZip).Items.Count = _
        oApp.Namespace("" & FolderName).Items.Count
        Application.Wait (Now + TimeValue("0:00:01"))
    Loop
    On Error GoTo 0
End Sub

Sub Unzip(Fname As Variant, DefPath As String)
    Dim FSO As Object
    Dim oApp As Object
    Dim FileNameFolder As Variant
    If Fname = False Then
        'Do nothing
    Else
        DefPath = addSlash(DefPath)
        FileNameFolder = DefPath
        On Error Resume Next
        Clear_All_Files_And_SubFolders_In_Folder (DefPath)
        On Error GoTo 0
        Set oApp = CreateObject("Shell.Application")
        oApp.Namespace("" & FileNameFolder).CopyHere oApp.Namespace("" & Fname).Items 'The ""&  is to address a bug - for some reason VBA doesn't like to use the passed strings in this situation. Found discussion on this here: http://forums.codeguru.com/showthread.php?443782-CreateObject(-quot-Shell-Application-quot-)-Error
        On Error Resume Next
        Set FSO = CreateObject("scripting.filesystemobject")
        FSO.DeleteFolder Environ("Temp") & "\Temporary Directory*", True
    End If
End Sub

'search file with name
Function BrowseForFile(Optional strWindowMsg As String) As String
    Dim strWindowFilter As String
    If strWindowMsg = "" Then strWindowMsg = "Please select file."
    strWindowFilter = "All Files (*.*),*.*,Excel 2007 Files (*.xlsx),*.xlsx,Excel Files (*.xls),*.xls,Excel Macro Enabled Files (*.xlsm),*.xlsm"
    BrowseForFile = Application.GetOpenFilename(strWindowFilter, , strWindowMsg, , False)
End Function

'// objFolder = objShell.BrowseForFolder(Hwnd, sTitle, BIF_Options [, vRootFolder])
Public Function BrowseForFolder( _
    Optional Hwnd As Long = 0, _
    Optional sTitle As String = "Please, select a folder", _
    Optional BIF_Options As Integer, _
    Optional vRootFolder As Variant) As String
    Dim objShell As Object
    Dim objFolder As Variant
    Dim strFolderFullPath As String
    Set objShell = CreateObject("Shell.Application")
    Set objFolder = objShell.BrowseForFolder(Hwnd, sTitle, BIF_Options, vRootFolder)
    If (Not objFolder Is Nothing) Then
        On Error Resume Next
        If IsError(objFolder.Items.Item.Path) Then strFolderFullPath = CStr(objFolder): GoTo GotIt
        On Error GoTo 0
        If Len(objFolder.Items.Item.Path) > 3 Then
            strFolderFullPath = objFolder.Items.Item.Path & Application.PathSeparator
        Else
            strFolderFullPath = objFolder.Items.Item.Path
        End If
    Else
        GoTo XitProperly
    End If
GotIt:
    BrowseForFolder = strFolderFullPath
XitProperly:
    Set objFolder = Nothing
    Set objShell = Nothing
End Function


'Ftp upload file
Public Function FTPUpload(Site, sUsername, sPassword, sLocalFile, sRemotePath, Optional Delay As Integer = 1000) As String
    On Error GoTo Err_FTPUpload
    Dim FailedReason As String
    Dim oFTPScriptFSO As Object
    Dim oFTPScriptShell As Object
    Set oFTPScriptFSO = CreateObject("Scripting.FileSystemObject")
    Set oFTPScriptShell = CreateObject("WScript.Shell")
    sRemotePath = Trim(sRemotePath)
    sLocalFile = Trim(sLocalFile)
    If InStr(sRemotePath, " ") > 0 Then
        If Left(sRemotePath, 1) <> """" And Right(sRemotePath, 1) <> """" Then
            sRemotePath = """" & sRemotePath & """"
        End If
    End If
    If InStr(sLocalFile, " ") > 0 Then
        If Left(sLocalFile, 1) <> """" And Right(sLocalFile, 1) <> """" Then
            sLocalFile = """" & sLocalFile & """"
        End If
    End If
    If Len(sRemotePath) = 0 Then
        sRemotePath = "\"
    End If
    If InStr(sLocalFile, "*") Then
        If InStr(sLocalFile, " ") Then
            FailedReason = "Error: Wildcard uploads do not work if the path contains a space." & vbCrLf
            FailedReason = FailedReason & "This is a limitation of the Microsoft FTP client."
            GoTo Exit_FTPUpload
        End If
    ElseIf Len(sLocalFile) = 0 Or Not oFTPScriptFSO.FileExists(sLocalFile) Then
        'nothing to upload
        FailedReason = "Error: File Not Found."
        GoTo Exit_FTPUpload
    End If
    'build input file for ftp command
    Dim sFTPScript As String
    sFTPScript = sFTPScript & "USER " & sUsername & vbCrLf
    sFTPScript = sFTPScript & sPassword & vbCrLf
    sFTPScript = sFTPScript & "cd " & sRemotePath & vbCrLf
    sFTPScript = sFTPScript & "binary" & vbCrLf
    sFTPScript = sFTPScript & "prompt n" & vbCrLf
    sFTPScript = sFTPScript & "put " & sLocalFile & vbCrLf
    sFTPScript = sFTPScript & "quit" & vbCrLf & "quit" & vbCrLf & "quit" & vbCrLf
    Dim sFTPTemp As String
    Dim sFTPTempFile As String
    Dim sFTPResults As String
    sFTPTemp = oFTPScriptShell.ExpandEnvironmentStrings("%TEMP%")
    sFTPTempFile = sFTPTemp & "\" & oFTPScriptFSO.GetTempName
    sFTPResults = sFTPTemp & "\" & oFTPScriptFSO.GetTempName
    Dim fFTPScript As Object
    Set fFTPScript = oFTPScriptFSO.CreateTextFile(sFTPTempFile, True)
    fFTPScript.WriteLine (sFTPScript)
    fFTPScript.Close
    Set fFTPScript = Nothing
    oFTPScriptShell.Run "%comspec% /c FTP -n -s:" & sFTPTempFile & " " & Site & " > " & sFTPResults, 0, True
    Sleep Delay
    'Check results of transfer.
    Dim fFTPResults As Object
    Dim sResults As String
    Const OpenAsDefault = -2
    Const FailIfNotExist = 0
    Const ForReading = 1
    Const ForWriting = 2
    Set fFTPResults = oFTPScriptFSO.OpenTextFile(sFTPResults, ForReading, FailIfNotExist, OpenAsDefault)
    sResults = fFTPResults.ReadAll
    fFTPResults.Close
    If InStr(sResults, "226 Transfer complete.") > 0 Then
        FailedReason = ""
    ElseIf InStr(sResults, "File not found") > 0 Then
        FailedReason = "Error: File Not Found"
    ElseIf InStr(sResults, "cannot log in.") > 0 Then
        FailedReason = "Error: Login Failed."
    Else
        FailedReason = "Error: Unknown."
    End If
    oFTPScriptFSO.DeleteFile (sFTPTempFile)
    oFTPScriptFSO.DeleteFile (sFTPResults)
    Set oFTPScriptFSO = Nothing
    oFTPScriptShell.CurrentDirectory = sOriginalWorkingDirectory
    Set oFTPScriptShell = Nothing
Exit_FTPUpload:
    FTPUpload = FailedReason
    Exit Function
Err_FTPUpload:
    FailedReason = Err.Description
    Resume Exit_FTPDownload
End Function

'Ftp download file
Function FTPDownload(Site, sUsername, sPassword, sLocalPath, sRemotePath, sRemoteFile, Optional Delay As Integer = 1000) As String
    On Error GoTo Err_FTPDownload
    Dim FailedReason As String
    Dim oFTPScriptFSO As Object
    Dim oFTPScriptShell As Object
    Set oFTPScriptFSO = CreateObject("Scripting.FileSystemObject")
    Set oFTPScriptShell = CreateObject("WScript.Shell")
    sRemotePath = Trim(sRemotePath)
    sLocalPath = Trim(sLocalPath)
    If InStr(sRemotePath, " ") > 0 Then
        If Left(sRemotePath, 1) <> """" And Right(sRemotePath, 1) <> """" Then
            sRemotePath = """" & sRemotePath & """"
        End If
    End If
    If Len(sRemotePath) = 0 Then
        sRemotePath = "\"
    End If
    If Len(sLocalPath) = 0 Then
        sLocalPath = oFTPScriptShell.CurrentDirectory
    End If
    If Not oFTPScriptFSO.FolderExists(sLocalPath) Then
        FailedReason = "Error: Local Folder Not Found."
        GoTo Exit_FTPDownload
    End If
    Dim sOriginalWorkingDirectory As String
    sOriginalWorkingDirectory = oFTPScriptShell.CurrentDirectory
    oFTPScriptShell.CurrentDirectory = sLocalPath
    'build input file for ftp command
    Dim sFTPScript As String
    sFTPScript = ""
    sFTPScript = sFTPScript & "USER " & sUsername & vbCrLf
    sFTPScript = sFTPScript & sPassword & vbCrLf
    sFTPScript = sFTPScript & "cd " & sRemotePath & vbCrLf
    sFTPScript = sFTPScript & "binary" & vbCrLf
    sFTPScript = sFTPScript & "prompt n" & vbCrLf
    sFTPScript = sFTPScript & "mget " & sRemoteFile & vbCrLf
    sFTPScript = sFTPScript & "quit" & vbCrLf & "quit" & vbCrLf & "quit" & vbCrLf
    Dim sFTPTemp As String
    Dim sFTPTempFile As String
    Dim sFTPResults As String
    sFTPTemp = oFTPScriptShell.ExpandEnvironmentStrings("%TEMP%")
    sFTPTempFile = sFTPTemp & "\" & oFTPScriptFSO.GetTempName
    sFTPResults = sFTPTemp & "\" & oFTPScriptFSO.GetTempName
    'Write the input file for the ftp command to a temporary file.
    Dim fFTPScript As Object
    Set fFTPScript = oFTPScriptFSO.CreateTextFile(sFTPTempFile, True)
    fFTPScript.WriteLine (sFTPScript)
    fFTPScript.Close
    Set fFTPScript = Nothing
    oFTPScriptShell.Run "%comspec% /c FTP -n -s:" & sFTPTempFile & " " & Site & " > " & sFTPResults, 0, True
    Sleep Delay
    'Check results of transfer.
    Dim fFTPResults As Object
    Dim sResults As String
    Const OpenAsDefault = -2
    Const FailIfNotExist = 0
    Const ForReading = 1
    Const ForWriting = 2
    Set fFTPResults = oFTPScriptFSO.OpenTextFile(sFTPResults, ForReading, FailIfNotExist, OpenAsDefault)
    sResults = fFTPResults.ReadAll
    fFTPResults.Close
    If InStr(sResults, "226 Transfer complete.") > 0 Then
        FailedReason = ""
    ElseIf InStr(sResults, "File not found") > 0 Then
        FailedReason = "Error: File Not Found"
    ElseIf InStr(sResults, "cannot log in.") > 0 Then
        FailedReason = "Error: Login Failed."
    Else
        FailedReason = "Error: Unknown."
    End If
    oFTPScriptFSO.DeleteFile (sFTPTempFile)
    oFTPScriptFSO.DeleteFile (sFTPResults)
    Set oFTPScriptFSO = Nothing
    oFTPScriptShell.CurrentDirectory = sOriginalWorkingDirectory
    Set oFTPScriptShell = Nothing
Exit_FTPDownload:
    FTPDownload = FailedReason
    Exit Function
Err_FTPDownload:
    FailedReason = Err.Description
    Resume Exit_FTPDownload
End Function


' Sub test_rebuildXML()
'     Dim destinationFolder As String, containingFolderName As String, errorFlag As Boolean, errorMessage As String
'     destinationFolder = "C:\_files\Git\vbaDeveloper"
'     containingFolderName = "C:\_files\Git\vbaDeveloper\src\tempDevFile.xlsm"
'     errorFlag = False
'     Call rebuildXML(destinationFolder, containingFolderName, errorFlag, errorMessage)
'     If errorFlag = True Then
'         MsgBox (errorMessage)
'     Else
'         MsgBox ("Done!")
'     End If
' End Sub
Public Sub rebuildXML(destinationFolder As String, containingFolderName As String, errorFlag As Boolean, errorMessage As String)
    containingFolderName = removeSlash(containingFolderName)
    destinationFolder = removeSlash(destinationFolder)
    'Make sure that the containingFolderName has an XML subfolder
    Dim xmlFolderName As String
    xmlFolderName = containingFolderName & "\" & XML_FOLDER_NAME
    Set FSO = CreateObject("scripting.filesystemobject")
    If FSO.FolderExists(xmlFolderName) = False Then
        errorMessage = "We couldn't find XML data in that folder. Make sure you pick the folder under /src that is named the same as the Excel to be rebuilt, and that it contains XML data."
        errorFlag = True
        Exit Sub
    End If
    'Set what some items should be named
    Dim fileExtension As String, strDate As String, fileShortName As String, fileName As String, zipFileName As String
    strDate = VBA.format(Now, " yyyy-mm-dd hh-mm-ss")
    fileExtension = "." & Right(containingFolderName, Len(containingFolderName) - InStrRev(containingFolderName, "."))  'The containing folder is the folder that is under \src and that is named the same thing as the target file (folder is filename.xlsx) - can parse file ending out of folder
    fileShortName = Right(containingFolderName, Len(containingFolderName) - InStrRev(containingFolderName, "\"))        'This should be just the final folder name
    fileShortName = Left(fileShortName, Len(fileShortName) - (Len(fileShortName) - InStr(fileShortName, ".")) - 1)                            'remove the extension, since we've saved that separately.
    fileName = destinationFolder & "\" & fileShortName & "-rebuilt" & strDate & fileExtension
    zipFileName = containingFolderName & "\" & TEMP_ZIP_NAME
    'Make sure we're not accidentally overwriting anything - this should be rare
    If FSO.FileExists(zipFileName) Then
        errorMessage = "There is already a file named " & TEMP_ZIP_NAME & " in the folder " & containingFolderName & ". This file needs to be removed before continuing."
        errorFlag = True
        Exit Sub
    End If
    'Zip the folder into the FileNameZip
    Call Zip_All_Files_in_Folder(xmlFolderName, zipFileName)
    'Rename the zipFileName to be the fileName (this effectively removes the zip file)
    Name zipFileName As fileName
    errorFlag = False
End Sub
' Sub test_unpackXML()
'     Call unpackXML("tempDevFile.xlsm")
'     MsgBox ("Done")
' End Sub
'执行之前确保该文件是打开的'
Public Sub unpackXML(fileShortName As String)
    Dim fileName As String, exportPath As String, exportPathXML As String
    fileName = Workbooks(fileShortName).FullName
    exportPath = getSourceDir(fileName, createIfNotExists:=True)
    exportPathXML = exportPath & XML_FOLDER_NAME
    Dim FSO As New Scripting.FileSystemObject
    If Not FSO.FolderExists(exportPathXML) Then
        FSO.CreateFolder exportPathXML
        Debug.Print "Created Folder " & exportPathXML
    End If
    Dim tempZipFileName As String
    tempZipFileName = exportPath & TEMP_ZIP_NAME
    FSO.CopyFile fileName, tempZipFileName, True
    Call Unzip(tempZipFileName, exportPathXML)
    Kill tempZipFileName
End Sub
