# VBA
## 运算符与表达式
1. 算术运算符和表达式
`+：加法  -：减法 *：乘法  /：浮点除法  \：整数除法  ^：乘方  MOD：模运算。优先级如下：（从高到低） ^  *  /  \  MOD  +或-`
2. 关系运算符和表达式
`=：等于  >：大于  <：小于  >=：大于或等于  <=：小于或等于  <>：不等于`
3. 逻辑运算符和表达式
`And：与  Or：或  Not：非  Xor：异或  Eqv：逻辑等于  Imp：逻辑蕴含。优先级如下：（从高到低） Not  And  Or  Xor  Eqv  Imp`
4. 字符串运算符和表达式
`“+”运算符  “&”运算符`
5. 数据类型
`String Byte Boolean Integer Long Single Double Date Currency Decimal Variant Object`
6. 变量类型修饰符
`Dim Private Public Global Static`

## 对话框对象
1. VB提供了多种输出数据的方法，以下是主要几种：A用对象Print方法输出数据  B用标签Label控件输出文本  C用文本框TextBox控件输出文件  D用MsgBox函数输出数据。
2. Print 方法用于在窗体、立即窗体、图片框、打印机等对象上显示文本字符串或表达式的值。Print方法的格式为：[对象名.]Print [表达式表][，|；]（表达式可能有问题）
3. VB提供了多种输入数据的方法，以下是主要几种：A用文本框TextBox控件输入数据  B用列表框、组合框控件输入数据  C用复选框、单选框控件输入数据的选择  D用InputBox函数输入数据。
4. InputBox函数用“输入对话框”的形式满足输入文本数据的基本需求。语法格式为：变量名=IntputBox(提示内容，[对话框标题]，[默认输入值])
5. 输入对话框InputBox函数，其格式为：返回值变量=InputBox（text，title）
6. 消息对话框MsgBox函数，其格式为：返回值变量=Msgbox text，buttons，title
`Button：vbOkOnly vbOkCanle vbAbortRetryIgone vbYesNoCancel vbYesNo vbRetryCancel vbCritical vbQuestion vbExclamation vbInformation`
7. 公共对话框CommonDialog控件  
CommonDialog控件：公共对话框名.ShowOpen、公共对话框名.ShowSave、公共对话框名.ShowFont、公共对话框名.ShowColor、公共对话框名.ShowPrinter。  
“打开”对话框的属性：对话框标题（DialogTitle）文件名称（FileName）初始化路径（InitDir）过滤器（Filter）格式为：“所有文件(*.*)|*.*” 或者“所有文件(*.*)|*.*|Word文档(.*)|*.doc”。
* 使用打开对话框的步骤：
在窗体上拖放“公共对话框”控件。在“公共对话框”控件上单击鼠标右键，选择“属性”命令，打开“属性页”对话框，如同所示。在“属性页”对话框中选择“打开/另存为”标签，打开“打开/另存为”选项卡。
在“打开/另存为”选项卡中设置相关属性。在过程代码中，使用CommonDialog控件的ShowOpen方法来显示“打开/另存为”对话框，语法格式为：公共对话框名.ShowOpen

## 语句
### 判断语句
* If…Then…Else语句
```
If Number < 10 Then
    Digits = 1
ElseIf Number < 100 Then
    Digits = 2
Else
    Digits = 3
End If
```
* Select Case…Case…End Case语句
```
Select Case Pid
Case “A101”
Price=200
……
Case Else
Price=900
End Case
```
* Choose 函数 choose(index, choce-1,choice-2,…,choice-n)
`GetChoice = Choose(Ind, "Speedy", "United", "Federal")`
* Switch函数 Switch(expr-1, value-1[, expr-2, value-2 _ [, expr-n,value-n]])switch函数和Choose函数类似，但它是以两个一组的方式返回所要的值

### 循环语句
* For Next语句 以指定次数来重复执行一组语句 
```
For Words = 10 To 1 Step -1   			' 建立 10 次循环
    For Chars = 0 To 9    				' 建立 10 次循环
        MyString = MyString & Chars    	' 将数字添加到字符串中
    Next Chars    						' Increment counter
    MyString = MyString & " "   		' 添加一个空格
Next Words
```
* For Each…Next语句  主要功能是对一个数组或集合对象进行，让所有元素重复执行一次语句
```
For Each rang2 In range1
With range2.interior
.colorindex=6
.pattern=xlSolid
End with
Next
```
* Do…loop语句 在条件为true时，重复执行区块命令
```
Do {while |until} condition
Statements
Exit do
Statements
Loop
```
或者使用下面语法
```
Do							
Statements
Exit do
Statements
Loop {while |until} condition
```

### 其他类语句和错误语句处理
* On Error Goto Line   ‘当错误发生时，会立刻转移到line行去
* On Error Resume Next ‘当错误发生时，会立刻转移到发生错误的下一行去
* On Erro Goto 0	     ‘当错误发生时，会立刻停止过程中任何错误处理过程
* Goto line 该语句为跳转到line语句行
* On expression gosub destinatioinlist 或者 on expression goto destinationlist 
* Gosub line…line…Return语句， Return 返回到 Gosub line行，如下例：
```
Sub gosubtry()
Dim num
Num=inputbox(“输入一个数字，此值将会被判断循环”)
If num>0 then Gosub Routine1 
Debug.print num
Exit sub
Routine1:
Num=num/5 
Return
End sub
```
*	while…wend语句，只要条件为TRUE，循环就执行
```
while I<50
I=I+1
Wend
```

## 过程和函数
[private|public][static] function/sub 过程名称（参数表）[as 数据类型]
语句块
End function
### Sub过程
```
Sub password (ByVal x as integer, ByRef y as integer)
If y=100 then y=x+y else y=x-y:x=x+100
End sub
```
### Function函数
```
Function password(ByVal x as integer, byref y as integer) as boolean
If y=100 then y=x+y else y=x-y:x=x+100
if y=150 then password=true else password=false
End Function
```
### 内部函数
1. 测试函数  
`IsNumeric(x)  IsDate(x)  IsEmpty（x）  IsArray(x) IsError(expression) IsNull(expression)	 IsObject(identifier)`
2. 数学函数  
`Sin(X)、Cos(X)、Tan(X)、Atan(x) Log(x) Exp(x) Abs(x) Int(number)、Fix(number) Sgn(number)  Sqr(number)  VarType(varname) Rnd（x)`
3. 字符串函数  
`Trim(string) Ltrim(string) Rtrim(string) Len(string)  Left(string, x)  Right(string, x)  Mid(string, start,x) `
`Ucase(string)  Lcase(string) Space(x)  Asc(string)  Chr(charcode)`
4. 转换函数  
`CBool(expression) CByte(expression) CCur(expression) CDate(expression) CDbl(expression)  CDec(expression) 	`
`CInt(expression) CLng(expression) CSng(expression) CStr(expression)  CVar(expression)  Val(string)	 Str(number)`	
5. 时间函数  
`Now  Date  Time Timer TimeSerial(hour, minute, second)  DateDiff(interval, date1, date2[, firstdayofweek[, firstweekofyear]])`
`Second(time) Minute(time) Hour(time) Day(date) Month(date)  Year(date)  Weekday(date, [firstdayofweek]) `

### 文件操作
    LOF(filenumber)文件的大小，EOF(filenumber)文件的结尾。Loc(filenumber)读/写位置
    Dir[(pathname[, attributes])] ；pathname及驱动器。如果没有找到 pathname，则会返回零长度字符串 (""); 
    Kill pathname 	从磁盘中删除文件, pathname 参数是用来指定一个文件名
    RmDir pathname	从磁盘中删除删除目录，pathname 参数是用来指定一个文件夹
    application.getopenfilename([filefilter,filterindex,title,buttontxt,multiselect])
    Application.getsaveasfilename([initialfilename.filefilter,filterindex,title,buttontxt])
    Open pathname For mode[Append、Binary、Input、Output、Random] Access[Read、Write、或 Read Write] As [#]filenumber [Len=reclength] 能够对文件输入/输出 (I/O)。
```
Sub openfiles()
Dim strotherwb as variant,strfilter$,strcaption$
Strfilter=”excel97-2003工作簿(*.xls),*.xls,”&”excel2007工作簿(*.xlsx),*.xlsx,”&”excel工作簿(*.xls;*xlsx),*.xls;*.xlsx,”&”所有的文件(*.*),*.*”
Strcaption=”打开含有“原始数据”工作表的工作簿”
Strotherwb=application.getopenfilename(strfilter,3,strcaption,,true) ‘打开对话框
If strotherwb=false then exit sub
For i=1 to ubound(strotherwb) ’遍历所有打开文件
Workbooks.open(strotherwb(i))  ‘打开第i个工作簿文件
Next
End sub
```

## 界面设计
    ActiveX控件：按钮，组合框，复选框，数值调节钮，列表框，文本框，单选扭，标签，滚动条和切换按钮。
    窗体，控件与字体的一些属性：
    size,width,top,left,font,height,underline,italic,bold,color,name,operation,visible,enable,locked
    窗体和控件的一些方法：move,load,unload,show,hide
    范例：privat useform_initialize():load useform2:useform2.show:end sub
    控件的一些事件：initialize,load,resize,activate,paint,deactivate,queryunload,unload,change,getfocus,lostfocus
    命令按钮的属性：caption,cancel,default(当为真的时候为enter自动),pictue（style为1-graphical的时候，设置pictue为按键上要显示的图片即可）
    文本框的属性：text,maxlength,multiline,locked,passwordchar,scrollbars(是否有滚动条)，hideselection
    文本框的事件：change,keypress,keyup,keydown 引用方式例如：private sub object_keydown……
    单选钮与复选框：选中为true 否则为false
    列表框与组合框的text属性，列表框的multiselect属性（0-单选，1-多选，2-扩选）
    列表框与组合框的方法和事件：aditem方法：additem item[,index]  clear方法，removeitem方法：object.removeitem index   组合框的dropdown事件：private sub object_dropdown(index as integer) 组合框的scroll事件。翻译：item选项，index序号，sroll滚动条。
    范例：Private Sub CommandButton1_Click():Dim i As Integer: For i = 1 To 2008
    ComboBox2.AddItem i: ComboBox3.AddItem i: ComboBox4.AddItem i: Next
    ListBox2.AddItem ComboBox2 + ComboBox3 + ComboBox4:End Sub
    Private Sub CommandButton2_Click(): ListBox2.RemoveItem ListBox2.ListIndex:End Sub
 
 ## 开发技巧
     对象：excel>工作簿>工作表>区域>单元格     application>workbooks>worksheet>range>cells
    Application方法：getopenfilename   getsaveasfilename   macrooptions（函数）onkeys（快捷键）sendkeys
    Application属性：activecell  activechart  activeprinter  activesheet  activewindow  activeworkbook
    Application对象：workbooks  worksheets  range  commandbars  dialogs  names等
    限定单元格的移动范围：worksheets(1).scrollarea=”a2:g10”)
    隐藏行和列：表达式.hidden
    插入行和列：表达式.insert(xlshifttoright|xlshiftdown,copy起点)     activesheet.rows(irows).insert
    设置行高和列宽：activesheet.rows(irow).rowheight=30     width
    隐藏显示工作表：sheets(1).visible=xlsheetveryhidden     xlsheethidden    xlsheetvisible
    修改工作表名字：.name=……
    移动复制或删除工作表：worksheets(“sheet1”).copy before:=worksheets(“sheet2”)
    删除：application.displayalerts=false: sh.delete: application.displayalerts=true
    有趣的：Workbook.fullname
    锁定工作表不能编辑：sheets(1).enableselection=xlunlockedcells: activesheet.protect drawingobjects:=true,contents:=true,scenarios:=true
    判断指定工作表存在否：if worksheets(1).name=shizhanqianyan then ……
    表达式.cells(rowindex,columnindex)
    表达式.range(cell)   表达式.range(cell1,cell2)
    Worksheets(“sheet1”).range(“a1”).value         worksheets(“sheet1”).range(“a1:d10”)
    Worksheets(“sht1”).range(cells(1,1),cells(2,5))   worksheets(“sht1”).range(“c5:d9,g9:h16,b3:j8”).clearcontents
    Offset偏移量：表达式.offset(rowoffset,columnoffset)
    单元格向右偏移3列下偏移3行处的所有单元格：activecell.offset(rowoffset:=3,columnoffset:=3).activate
    合并单元格区域：表达式.union(arg1,arg2,arg3,……)  下面用rand公式填充到r1,r2两块区域的合并区域：
    Dim r1,r2,hebing as range: set r1=sheets(“sheet1”).range(“a1:b2”): set r2=sheets(“sheet1”).range(“c3:d4”)
    Set hebing=union(r1,r2): hebing.formula=”=rand()”
    多个子区域的集合：表达式.areas
    扩展单元格区域：表达式.resize(rowsize,columnsize)   下例使选中区域增加一行和一列：
    Sub setrange(): worksheets(“sheet1”).activate: numrows=selection.rows.count:numcolumns=selection.columns.count
    Selection.resize(numrows+1,numcolumns+1).select : end sub
    引用交叉区域：表达式.intersect(arg1,arg2,arg3,……)  如：
    worksheets(“sheet1”).activate:set isect=application.intersect(range(“rg1”),range(“rg2”)).select
    引用当前区域即以空行和空列的组合为边界的区域：表达式.Currentregion 如activecell.currentregion.select
    引用已使用区域即工作表中非空区域集合：如：activesheet.usedrange.select
    返回与指定类型和值匹配的所有单元格：表达式.specialcells(type,value)  参数都为可选参数。
    计算选中单元格数目：msgbox selection.count
    合并与拆分单元格：
    合并：表达式.merge   range(“a1:g2”).merge 拆分：with range(“e3”):if .mergecells then:.mergearea.unmerge
    设置公式：sheet1.cells(2,10).formula=”=sum(c2:i2)”或sheet1.cells(1,10).formular1c1=”=sum(rc[-7]:rc[-1])”
    复制与剪切单元格区域：表达式.copy(目标区域可选)  如：sheet1.range(“a1:e4”).copy sheet2.range(“g6”)
    删除单元格：表达式.delete(xlshifttoleft|xlshiftup)  参数都是可选
    若是将单元格区域的内容复制到剪贴板，还需要用到range对象的pastespecial方法。Pastespecial方法可将剪贴板中的内容黏贴到指定区域中，其语法格式如下：
    表达式.pastespecial(paste,operation,skipblanks,transpose)
    其中，参数paste用来设置要粘贴的区域部分，可设置的常量如表所示：
    Xlpasteall	Xlpasteallexceptborders	Xlpasteallusingsourcetheme	Xlpastecolumnwidths
    粘帖全部内容	除边框外的全部内容	使用源主题粘贴全部内容	粘贴复制的列宽
    Xlpastecomments	Xlpasteformats	Xlpasteformulas	Xlpasteformulasandnumberformats
    粘贴批注	粘贴复制的源格式	粘贴公式	粘贴公式和数字格式
    Xlpastevalideation	Xlpastevalues	Xlpastevaluesandnumberformats	
    粘贴有效性	粘贴值	粘贴值和数字格式	
    参数operation设置具体的粘贴操作，参数及其说明：
    Xlpastespecialoperationadd复制的数据与目标单元格中的值相加
    Xlpastespecialoperationdivide复制的数据除以目标单元格中的值
    Xlpastespecialoperationmultiply复制的数据乘以目标单元格中的值
    Xlpastespecialoperationnone直接粘帖
    Xlpastespecialoperationsubtract复制的数据减去目标单元格中的值
    Transpose若为ture则转置粘贴
    设置条件格式：表达式.add(type,operactor,值1，值2)
    常见的type有：xlcellvalue   xltop10  xluniquevalues
    常见的operactor有：xlbetween xlequeal xlgreater xlgreaterequal xlless xllessequal xlnotbetween xlnotequal
    范例：sub addformat(): dim mg1 as range:set m1=sheet1.range(“c2:i23”)
    With mg1.formatconditions.add(xlcellvalue,xlless,60): .font.bold=true:end with:end sub
    有用：.color=RGB(0,90,210)
    设置对齐方式：有水平方向属性：horizontalalignment 竖直方向属性：verticalalignment
    xlcenter居中xldistributed分散对齐xljustify两端xlleft xlright xlbottom靠下xltop 范例：
    Selection.horzontalalignment=xlcenter:selection.verticalalignment=xlcenter
    自动换行格式：selection.wraptext=true
    判断单元格是否含公式：set mg=activesheet.range(“a1”).currentregion:for each onecell in mg.cells
    If c.hasformula then: msgbox”onecell.address&”含有公式”：end if :next
    自动填充公式：表达式.autofill(destination目标区域包含源区域，type)
    Type有：xlfillcopy填充值和格式 xlfilldefault让excel确定用于填充目标区域值和格式
    Xlfillformats格式  xlfillseries值扩展  xlfillvalues值复制到  xlgrowthtrend倍增  xllineartrend加法扩展
    范例：range(“J3”).autofill destination:=range(cells(2,10),cells(12,10))或destination:=range(cells(2,10),cells(2,23))
    锁定和隐藏单元格公式：locked属性与formulahidden属性。下例锁定不允许修改并且隐藏看不到公式：
    Sub getformala():if activesheet.protectcontents=true then activesheet.unprotect:end if
    Worksheets(“sheet1”).range(“a1”).currentregion.select: selection.locked=false: selection.formulahidden=false
    Selection.specialcells(xlcelltypeformulas).select: selection.locked=true:selection.formulahidden=true
    Worksheets(“sheet1”).protect drawingobjects:=true,contents:=true,scenarios:=true
    Worksheets(“sheet1”).enableselection=xlnorestrictions:end sub
    将公式转为数值：mg.value=mg.value下例表示将a1当前区域的单元格都转为数值形式
    Sub getnumber():dim mg as range,c as range:set mg=activesheet.range(“a1”).currentregion
    For each c in mg.cells: if c.hasformula then c.value=c.value:end if:next:end sub
    查找指定的值：
    表达式.find(what,after,lookin,lookat,searchorder,searchdirection,matchcase,matchbyte,serchformate)
    我简化：表达式.find(what,lookin类型,searchorder[xlbyrows|xlbycolumns],matchcase[大小写true|false])
    范例：set c=.find(3,lookin:=xlvalues):if not c is nothing then: do c.value=6:set c=.findnext(c):loop while not c is nothing:end if
    屏蔽屏幕显示：application.screenupdating=false 屏蔽excel警告和消息：application.displayalerts=false
    图表对象
    Chart1.name=”student”
    Chart1.setsourcedate.source:=sheet1.range(“b1:e9”),plotby:=xlrows ’数据系列在行中
    Chart1.charttype=xlcolumnclustered
    Chart1.hastitle=true
    Chart1.charttitle.text=”学生“
    其中，设置图表数据源语法格式为：表达式.setsourcedate(source,plotby)
    创建嵌入式图表：表达式.add(left,top,width,height)   chartobjects(index)中的index是图表的索引号或名称
    范例：set co=sheets(“sheet1”).chartobjects.add(190,10,350,150)
    Co.chart.chartwizard source:worksheets(“sheet1”).range(“b1:e9”)
    Gallery:xlcolumn,format:=6,plotby:=xlcolumns,categorylabels:=1,serieslables:=1,haslegend:=1
    转换图表类型：表达式.location(where[xllocationasobject],name)
    图表的删除：activesheet.chartobjects.delet删除所有嵌入式图表activesheet.chartobjects(“chart1”).delet
    有用：mg.address是$a$1而mg.address(rowabsolut:=false)是$a1
    创建右键的快捷菜单项：
    Dim newitem as commandbarcontrol :set newitem=commandbars(“cell”).control.add
    With newitem : .caption=”新快捷菜单项“: .onaction=”methodforcell” : .begingroup=true: end with
    禁用相关快捷菜单项：Commandbars(“column”).controls(“hide”).enabled=false
    范例2：commandbars(“cell”).controls(“hide”).enabled=false
    禁用所有快捷菜单：commandbars(“cell”).enabled=false
    
    Set sht = ThisWorkbook.Sheets(strItemName)
    If Err > 0 Then MsgBox "未找到对应工作表:" & strItemName: Exit Sub
    MsgBox "信息已发布成功！", vbYes + vbQuestion, "恭喜"
    For i = 1 To ActiveSheet.UsedRange.Rows.Count
            ActiveSheet.Hyperlinks.Add Anchor:=Cells(i, 2), Address:=Cells(i, 2).Value, TextToDisplay:=Cells(i, 2).Value
        Next i
       delay 2
      Dim temp, s
    For i = 1 To 720
        Cells(2 + i, 1) = Date + Time - (720 - i) / 24
    Next i
    [a2:bs2] = Split("时间,干球温度,雨量,最高温度,最高温度出现时间,最低温度,最低温度出现时间,能见度,相对湿度,最小相对湿度,最小相对湿度出现时间,水气压,露点温度,本站气压,海平面气压,最高本站气压,最高本站气压出现时间,最低本站气压,最低本站气压出现时间,2分钟风向,10分钟风向,2分钟风速,10分钟风速,最大风速,极大风速,最大风速的风向,极大风速的风向,最大风速出现的时间,极大风速出现的时间,瞬时风速,瞬时风向,地面0cm温度,云高,地面最高温度,地面最高温度出现时间,地面最低温度,地面最低温度出现时间,5cm地温,10cm地温,15cm地温,20cm地温,40cm地温,80cm地温,160cm地温,320cm地温,大型蒸发,云总量,低云量,云状,日照,空气混浊度,总辐射,总辐射曝幅量,总辐射最大值,总辐射最大值出现时间,净辐射,净辐射曝幅量,净辐射最大值,净辐射最大值出现时间,反射辐射,反射辐射曝辐量,反射辐射最大值,反射辐射最大值出现时间,散射辐射,散射辐射曝辐量,散射辐射最大值,散射辐射最大值出现时间,直接辐射,直接辐射曝辐量,直接辐射最大值,直接辐射最大值出现时间", ",")
  
    Set r = CreateObject("Scripting.Dictionary")
    r("jsonrpc") = "2.0"
    If r.Exists("error") Or Not r.Exists("result") Then
    MsgBox "Error " & Err.Number & ": " & Err.Description & " in ", vbOKOnly, "Error"
    pText = toString(r)

    Nextcol=Cells(1,255).End(xlToLeft).Column 
    Nextcol=Cells(1,1).End(xlToright).Column 
    Nextcol=Cells(65536,1).End(xlup).row 
    Nextcol=Cells(1,1).End(xldown).row 
    Range("a20").Hyperlinks(1).Follow
    
    Filename = Application.GetOpenFilename("Excel文件（*.xls & *.xla & *.xlt）,*.xls;*.xla;*.xlt",)
    If Dir(Filename) = "" Then MsgBox "没找到相关文件,清重新设置。"
    列号的字母a=function zhzm(range.column)
    前面行号的字母b=function zhzm(range.row)
    末行行号c= worksheets(“原始数据”).Range("a65536").End(xlUp).Row
    末列列号d= worksheets(“原始数据”).Cells(1,1).End(xlToright).Column
    Set cli = CreateObject("MSXML2.XMLHTTP.6.0")
    ' Set cli = New MSXML2.XMLHTTP60
    If Len(user) > 0 Then   ' If Not IsMissing(user) Then
       cli.Open "POST", url, False, user, pwd
 
## 内置对话框 
* 方法：Application.Dialogs(代码).Show 或者 Application.Dialogs(xlDialogType).Show  

代码     |   对话框名称     |   代码     | 对话框名称    |    代码     |  对话框名称
---     | -------------  | --------  | --------    |  ---------- | ----------
1       |  打开           |   132     |   定位条件   |   381       |    单元格格式-字体
5       |  另存为         |   134     |   字体       |   384       |    取消隐藏
6       |  删除文档       |    137     |  拆分       |   386        |    重命名工作表
7       |  页面设置       |   142      |  设置       |   415        |    分类汇总
8       |  打印内容       |   145      |  另存为      |   417       |    保护工作簿
9       |  打印机设置     |   150      |   字体       |   447       |    自动筛选
12      |   重排窗口      |   154      |  插入批注     |  450        |   插入函数
17      |   宏           |   161      |  选项-颜色    |  458       |    选项-自定义序列
23      |   设置打印标题   |   190      |  字体        |   472       |   标准列宽
26      |   字体         |    191     |  合并计算     |    473      |   合并方案
27      |   显示选项      |    192     |  排序        |    474      |   工作簿属性
28      |   保护工作表    |    198     |   单变量求解   |   475       |   打开
32      |   重算选项      |   199      |   编辑成组工作表|  476        |  单元格格式-字体
39      |   排序         |    203     |   创建组      |   481       |   共享工作簿
40      |   序列         |    212     |   样式        |   485       |  自动更正
41      |   模拟运算表    |    220     |   自定义      |   493        |  视图管理器
42      |   单元格格式-数字|    222     |   打印预览    |   494        |  添加视图
43      |   单元格格式-对齐|    229     |   样式       |   496        |  标签区域
44      |   字体         |    256     |   显示比例    |   509        |  工作表背景
45      |   单元格格式-边框|    259     |   对象       |   525        |   数据有效性
46      |   单元格格式-保护|    269     |   自动套用格式 |   583       |   条件格式
47      |   列宽         |    276     |   自定义      |   596       |  插入超链接
52      |   清除         |    281     |   移动或复制工作表| 620       |  保护共享工作簿
53      |   选择性粘贴    |    282     |   移动或复制工作表| 647       |   选项-国际
54      |   删除单元格    |    283     |   移动或复制工作表| 653       |   发布为网页
55      |   插入         |    284     |   重命名工作表  |   656      |   拼音属性
61      |   定义名称      |    285     |   保存工作区   |   666      |   导入文本文件
62      |   指定名称      |    302     |   插入        |   667      |   新建-Web_查询
63      |   定位         |    305     |   方案管理器   |   674      |   Web-选项-常规
64      |   查找         |    307     |   添加方案     |   683      |  Web-选项-浏览器
84      |   单元格格式-图案|    312     |   数据透视表   |   684      |   Web-选项-文件
91      |   分列         |    318     |   选项-重新计算 |   685      |  Web-选项-图片
94      |   取消隐藏      |    319     |   选项-编辑    |   686      |  Web-选项-编码
95      |   工作区选项    |    320     |   选项-视图     |  687      |  Web-选项-字体
103     |    激活        |    321     |   加载宏       |   709     |   公式求值
108     |    复制图片     |    323     |   附加工具栏   |   731      |  基本文件搜索
110     |    定义名称     |    342     |   插入图片     |   753      |  选项-保存
111     |    单元格格式-数字|   354     |   插入        |   755      |  选项-拼写检查
119     |    新建        |    355     |   选项-123的帮助|  771      |  符号
127     |    行高        |    356     |   选项-常规    |   773      |  Web-选项-浏览器
130     |    替换        |    370     |   高级筛选     |   796/817  |  创建列表/信息检索 
                                
* 对话框xlDialogType枚举类型 如xlDialogOpen

名称	                | 值    |      对话框描述     | 名称        	    |    值 | 对话框描述
------------------- | ----- | ---------------- | ------------------ | ----- | -------
Activate            |103    |激活               |ActiveCellFont      |476    |活动单元格字体
AddChartAutoformat  |390    |添加图表自动套用格式  |AddinManager        |321	|加载项管理器
Alignment           |43	    |对齐方式            |ApplyNames          |133	|应用名称
ApplyStyle          |212	|应用样式            |AppMove             |170	|AppMove
AppSize             |171	|AppSize           |ArrangeAll          |12	    |全部重排
AssignToObject      |213	|给对象指定宏         |AssignToTool        |293	|给工具指定宏
AttachText          |80	    |附加文本            |AttachToolbars      |323	|附加工具栏
AutoCorrect         |485	|自动校正            |Axes                |78	    |坐标轴
Border              |45	    |边框               |Calculation         |32	    |计算
CellProtection      |46	    |单元格保护          |ChangeLink          |166	|更改链接
ChartAddData        |392	|图表添加数据         |ChartLocation       |527	|图表位置
Zoom                |256	|缩放               |ChartOptionsDataLabels|505	|图表选项数据标签
ChartOptionsDataTable|506	|图表选项数据表       |ChartSourceData     |540	|图表源数据
ChartTrend          |350	|图表趋势            |ChartType           |526	|图表类型
ChartWizard         |288	|图表向导            |CheckboxProperties  |435	|复选框属性
Clear               |52	    |清除               |ColorPalette        |161	|调色板
ColumnWidth         |47	    |列宽               |Combination         |73	    |组合图
ConditionalFormatting|583	|条件格式            |Consolidate         |191	|合并计算
CopyChart           |147	|复制图表            |CopyPicture         |108	|复制图片
CreateList          |796	|创建列表            |CreateNames         |62	    |创建名称
CreatePublisher     |217	|创建发布者          |CustomizeToolbar    |276	|自定义工具栏
CustomViews         |493	|自定义视图          |DataDelete          |36	    |数据删除
DataLabel           |379	|数据标签            |DataLabelMultiple   |723	|多个数据标签
DataSeries          |40	    |数据系列            |DataValidation      |525	|数据有效性
DefineName          |61	    |定义名称            |DefineStyle         |229	|定义样式
DeleteFormat        |111	|删除格式            |DeleteName          |110	|删除名称
Demote              |203	|降级               |Display             |27	    |显示
DocumentInspector   |862	|文档检查器          |EditboxProperties   |438	|编辑框属性
EditColor           |223	|编辑颜色            |EditDelete          |54	    |编辑删除
EditionOptions      |251	|编辑选项            |EditSeries          |228	|编辑数据系列
ErrorbarX           |463	|误差线 X            |ErrorbarY           |464	|误差线 Y
ErrorChecking       |732	|错误检查            |EvaluateFormula     |709	|公式求值
ExternalDataProperties|530	|外部数据属性         |Extract             |35	|提取
FileDelete          |6	    |文件删除            |FileSharing         |481	|文件共享
FillGroup           |200	|填充组              |FillWorkgroup       |301	|填充工作组
Filter              |447	|对话框筛选           |FilterAdvanced      |370	|高级筛选
FindFile            |475	|查找文件            |Font                |26 	|字体
FontProperties      |381	|字体属性            |FormatAuto          |269	|自动套用格式
FormatChart         |465	|设置图表格式         |FormatCharttype     |423	|设置图表类型格式
FormatFont          |150	|设置字体格式         |FormatLegend        |88	|图例格式
FormatMain          |225	|设置主要格式         |FormatMove          |128	|设置移动格式
FormatNumber        |42 	|设置数字格式         |FormatOverlay       |226	|设置重叠格式
FormatSize          |129	|设置大小            |FormatText          |89	    |设置文本格式
FormulaFind         |64	    |查找公式            |FormulaGoto         |63	    |转到公式
FormulaReplace      |130	|替换公式            |FunctionWizard      |450	|函数向导
Gallery3dArea       |193	|三维面积图库         |Gallery3dBar        |272	|三维条形图库
Gallery3dColumn     |194	|三维柱形图库         |Gallery3dLine       |195	|三维折线图库
Gallery3dPie        |196	|三维饼图库           |Gallery3dSurface    |273	|三维曲面图库
GalleryArea         |67	    |面积图库             |GalleryBar          |68    |条形图库
GalleryColumn       |69	    |柱形图库             |GalleryCustom       |388	|自定义库
GalleryDoughnut     |344	|圆环图库             |GalleryLine         |70    |折线图库
GalleryPie          |71	    |饼图库              |GalleryRadar        |249	|雷达图库
GalleryScatter      |72	    |散点图库             |GoalSeek            |198	|单变量求解
Gridlines           |76	    |网格线              |ImportTextFile      |666	|导入文本文件
Insert              |55	    |插入                |InsertHyperlink     |596	|插入超链接
InsertNameLabel     |496	|插入名称标志          |InsertObject        |259	|插入对象
InsertPicture       |342	|插入图片             |InsertTitle         |380	|插入标题
LabelProperties     |436	|标签属性             |ListboxProperties   |437	|列表框属性
MacroOptions        |382	|宏选项               |MailEditMailer      |470	|编辑邮件发件人
MailLogon           |339	|邮件登录             |MailNextLetter      |378	|发送下一信函
MainChart           |85	    |主要图               |MainChartType       |185	|图表类型
MenuEditor          |322	|菜单编辑器            |Move                |262	|移动
MyPermission        |834	|我的权限              |New                 |119	|新建
NewWebQuery         |667	|新建 Web 查询         |Note                |154	|注意
ObjectProperties    |207	|对象属性              |ObjectProtection    |214	|对象保护
Open                |1	    |打开                 |OpenLinks           |2    |打开链接
OpenMail            |188	|打开邮件              |OpenText            |441	|打开文本
OptionsCalculation  |318	|计算选项              |OptionsChart        |325	|图表选项
OptionsEdit         |319	|编辑选项              |OptionsGeneral      |356	|常规选项
OptionsListsAdd     |458	|添加列表选项           |OptionsME           |647 |ME 选项
OptionsTransition   |355	|转换选项              |OptionsView         |320	|视图选项
Outline             |142	|大纲                 |Overlay             |86  |覆盖图
OverlayChartType    |186	|覆盖图图表类型         |PageSetup           |7   |页面设置
Parse               |91	    |分列                 |PasteNames          |58  |粘贴名称
PasteSpecial        |53	    |选择性粘贴            |Patterns            |84  |图案
Permission          |832	|权限                 |Phonetic            |656	|拼音
PivotCalculatedField|570	|数据透视表计算字段      |PivotCalculatedItem |572	|数据透视表计算项
PivotClientServerSet|689	|设置数据透视表客户机服务器|PivotFieldGroup     |433|组合数据透视表字段
PivotFieldProperties|313	|数据透视表字段属性      |PivotFieldUngroup   |434	|取消组合数据透视表字段
PivotShowPages      |421	|数据透视表显示页       |PivotSolveOrder     |568   |数据透视表求解次序
PivotTableOptions   |567	|数据透视表选项         |PivotTableWizard    |312  |数据透视表向导
Placement           |300	|位置                 |Print               |8	|打印
PrinterSetup        |9	    |打印机设置            |PrintPreview        |222   |打印预览
Promote             |202	|升级                 |Properties          |474   |属性
PropertyFields      |754	|属性字段              |ProtectDocument     |28	 |保护文档
ProtectSharing      |620	|保护共享              |PublishAsWebPage    |653    |发布为网页
PushbuttonProperties|445	|按钮属性              |ReplaceFont         |134    |替换字体
RoutingSlip         |336	|传送名单              |RowHeight           |127    |行高
Run                 |17	    |运行                 |SaveAs              |5     |另存为
SaveCopyAs          |456	|副本另存为            |SaveNewObject       |208  |保存新对象
SaveWorkbook        |145	|保存工作簿            |SaveWorkspace       |285  |保存工作区
Scale               |87	    |缩放                 |ScenarioAdd         |307	|添加方案
ScenarioCells       |305	|单元格方案            |ScenarioEdit        |308	|编辑方案
ScenarioMerge       |473	|合并方案              |ScenarioSummary     |311	|方案摘要
ScrollbarProperties |420	|滚动条属性            |Search              |731	|搜索
SelectSpecial       |132	|特殊选定              |SendMail            |189	|发送邮件
SeriesAxes          |460	|系列坐标轴             |SeriesOptions       |557	|系列选项
SeriesOrder         |466	|系列次序              |SeriesShape         |504	|系列形状
SeriesX             |461	|系列 X               |SeriesY             |462	|系列 Y
SetBackgroundPicture|509	|设置背景图片           |SetPrintTitles      |23   |设置打印标题
SetUpdateStatus     |159	|设置更新状态           |ShowDetail          |204	|显示明细数据
ShowToolbar         |220	|显示工具栏            |Size                |261	|大小
Sort                |39	    |排序                 |SortSpecial         |192	|选择性排序
Split               |137	|拆分                 |StandardFont        |190	|标准字体
StandardWidth       |472	|标准宽度              |Style               |44 	|样式
SubscribeTo         |218	|订阅                 |SubtotalCreate      |398	|创建分类汇总
SummaryInfo         |474	|摘要信息              |Table               |41    |表
TabOrder            |394	|Tab 键次序           |TextToColumns       |422	 |分列
Unhide              |94	    |取消隐藏              |UpdateLink          |201	    |更新链接
VbaInsertFile       |328	|VBA 插入文件          |VbaMakeAddin        |478	    |VBA 创建加载项
VbaProcedureDefinition|330	|VBA 过程定义          |View3d              |197	    |三维视图
WebOptionsBrowsers  |773	|Web 浏览器选项        |WebOptionsEncoding  |686	    |Web 编码选项
WebOptionsFiles     |684	|Web 文件选项          |WebOptionsFonts     |687   	|Web 字体选项
WebOptionsGeneral   |683	|Web 常规选项          |WebOptionsPictures  |685   	|Web 图片选项
WindowMove          |14	    |窗口移动              |WindowSize          |13      |窗口大小
WorkbookAdd         |281	|添加工作簿            |WorkbookCopy        |283	    |复制工作簿
WorkbookInsert      |354	|插入工作簿            |WorkbookMove        |282	    |移动工作簿
WorkbookName        |386	|命名工作簿            |WorkbookNew         |302	    |新建工作簿
WorkbookOptions     |284	|工作簿选项            |WorkbookProtect     |417	    |保护工作簿
WorkbookTabSplit    |415	|拆分工作簿标签         |WorkbookUnhide      |384	    |取消隐藏工作簿
Workgroup           |199	|工作组               |Workspace           |95       |工作区

