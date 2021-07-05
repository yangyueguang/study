Attribute VB_Name = "HTML"

Sub testVBA()
    'Dim listDataArr As Collection   'excel显示所需的数组数据
    Dim urlstr As String        'API
    Dim originalStr As String   '网络请求后的原始字符串数据
    Dim dataDic As Dictionary   '字符串转化为的json，即dic
    Dim keyword As String
    keyword = Application.InputBox("请输入需查询的关键字：")
    '随意使用的一个免费API用于下面的练习
    urlstr = "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_length=600&bk_key=" & keyword
    Debug.Print (urlstr)
    '执行get请求
    originalStr = XNetManager.XHttpGET(urlstr)
    Debug.Print (originalStr)
    If Len(originalStr) = 2 Then
        MsgBox ("请输入有效的关键字，如：vba、互联网、app等")
        Exit Sub
    End If
    Set dataDic = JsonConverter.ParseJson(originalStr)
    Dim list As Collection
    Set list = dataDic("card")
    Call updatemyExcelData(list)
End Sub

'更新excel数据
Sub updatemyExcelData(ByRef listDataArr As Collection)
    ActiveSheet.Cells.ClearContents
    '将数据更新到excel指定的cell中
    Dim Item As Dictionary
    Dim i As Integer
    For i = 1 To listDataArr.Count
        Set Item = listDataArr.Item(i)
        ActiveSheet.Cells(3 + i, 1) = Item("name")
        ActiveSheet.Cells(3 + i, 3) = Item("format")(1)
        ActiveSheet.Cells(3 + i, 1).Font.Color = RGB(0, 200, 50)
    Next
End Sub



Sub 下载()
    Dim url As String
    Dim httpreq As Object
    Sheet1.Activate
    Set httpreq = CreateObject("htmlfile")
    url = "http://odds.500.com/fenxi/yazhi-253687.shtml"
    With CreateObject("msxml2.xmlhttp")
        .Open "GET", url, False
        .send
        httpreq.body.innerhtml = .responsetext
        Set tb = httpreq.all.tags("table")(8).rows
        For i = 0 To tb.Length - 1
            For j = 0 To tb(i).Cells.Length - 1
                Cells(i + 1, j + 1) = tb(i).Cells(j).innerText
            Next
        Next
    End With
End Sub


'下载网页的数据并解析
Sub ff()
    Dim oDocm As New HTMLDocument
    Dim oDocm2 As HTMLDocument
    Set oDocm2 = oDocm.createDocumentFromUrl("http://www.baidu.com", vbNullString)
    While oDocm2.readyState <> "complete"
       DoEvents
    Wend
    For Each a In oDocm2.getElementsByTagName("a")
        Debug.Print (a.innerText)
        If a.className = "newslist_style" Then
        Set oDocm2 = oDocm.createDocumentFromUrl(a.href, vbNullString)
        While oDocm2.readyState <> "complete"
            DoEvents
        Wend
        For Each t In oDocm2.getElementsByTagName("td")
            If t.className = "content" Then
                MsgBox t.innerText
                Exit Sub
            End If
        Next
       End If
    Next
End Sub

'从网页上下载解析数据到excell里面=========================================================================
Public Sub GetTableFromInternet()
    Dim loIE As Variant
    Set loIE = CreateObject("InternetExplorer.Application")
    loIE.navigate ("file://" & ActiveWorkbook.Path & "\web_data.html")
    While Left(loIE.statusText, 2) <> "完毕"
    Wend
    Dim loTable, loRow, loCell As Variant
    Dim r, c As Integer
    For Each loTable In loIE.document.body.getElementsByTagName("Table")
        Sheets.Add
        If loTable.id <> "" Then
            Sheets(1).name = loTable.id
        End If
        r = 0
        For Each loRow In loTable.rows
            r = r + 1
            c = 0
            For Each loCell In loRow.Cells
                c = c + 1
                Sheets(1).Cells(r, c) = loCell.innerText
            Next
        Next
        Sheets(1).Cells.EntireColumn.AutoFit
        Sheets(1).Cells.EntireRow.AutoFit
        Sheets(1).Cells(1, 1).Activate
    Next
    Sheets(1).Activate
    loIE.Quit
End Sub

Sub Test()
 Dim func As New cls_func
 Dim strurl As String
 Dim strCookie As String
 Dim strConnection As String
 Dim strReferer As String
 Dim strHost As String
 Dim strAccept As String
 Dim strAcceptEncoding As String
 Dim strAcceptLanguage As String
 Dim strUserAgent As String
 Dim strContentType As String
 Dim urlstr As String
 Dim strCharset As String
 strurl = "https://freeway.ju.taobao.com/sellerreport/activityAnalyse.htm"
 strHost = "freeway.ju.taobao.com"
 strUserAgent = "Mozilla/5.0 (Windows NT 6.1; rv:47.0) Gecko/20100101 Firefox/47.0"
 strAccept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
 strAcceptLanguage = "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3"
 strConnection = "keep-alive"
 strAcceptEncoding = "gzip, deflate, br"
 strReferer = "https://freeway.ju.taobao.com/sellerreport/juBaseInfo.htm"
 strContentType = ""
 strCookie = "**********************************隐私*****************"
 strCharset = "gbk"
 urlstr = GetUrlContentFromBody(strCharset, strurl, strCookie, strConnection, strReferer, strHost, strAccept, _
 strAcceptEncoding, strAcceptLanguage, strUserAgent, strContentType)
 With CreateObject("new:{1C3B4210-F441-11CE-B9EA-00AA006B1A69}")
.SetText urlstr
.PutInClipboard
 End With
End Sub

Function GetUrlContentFromBody(strCharset As String, strurl As String, strCookie As String, strConnection As String, _
    strReferer As String, strHost As String, strAccept As String, strAcceptEncoding As String, strAcceptLanguage As String, strUserAgent As String, strContentType As String)
    If http Is Nothing Then
        Set http = New WinHttpRequest
    End If
    With http
        Do
            .Open "GET", strurl, False
            .SetRequestHeader "Connection", strConnection
            .SetRequestHeader "Accept", strAccept
            .SetRequestHeader "Host", strHost
            .SetRequestHeader "Accept-Encoding", strAcceptEncoding
            .SetRequestHeader "Accept-Language", strAcceptLanguage
            .SetRequestHeader "Referer", strReferer
            .SetRequestHeader "User-Agent", strUserAgent
            .SetRequestHeader "Cookie", strCookie
            If strContentType <> "" Then
                .SetRequestHeader "Content-Type", strContentType
            End If
            .send
            .waitforresponse
        Loop While .Status <> 200
        GetUrlContentFromBody = BytesToBstr(.ResponseBody, strCharset)
    End With
End Function

'根据元素的ID,Name,TagName,Calss属性访问元素
Sub getid()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<h1 id='myHeader'>This is a header</h1>"
    MsgBox oDom.getElementById("myHeader").innerText
End Sub

Sub getTagName()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<h1 class='myHeader'>This is a header</h1><h1>这是另一个标题</h1>"
    MsgBox oDom.getElementsByTagName("h1")(0).innerText
    MsgBox oDom.getElementsByTagName("h1")(1).innerText
End Sub

Sub getTagName2()
'    此例必须使用前期引用
    Dim oDom As New HTMLDocument
    oDom.body.innerhtml = "<h1 class='myHeader'>This is a header</h1><h1>这是另一个标题</h1>"
    MsgBox oDom.getElementsByClassName("myHeader")(0).innerText '本例前期引用仍不能识别Class(类)
End Sub

Sub getAttr()
    'Set oDom = CreateObject("htmlfile")
    Dim oDom As New HTMLDocument
    oDom.body.innerhtml = "<a id='myAnchor' href='http://www.microsoft.com'>Microsoft</a>"
    MsgBox oDom.getElementById("myAnchor").href
End Sub

'根据节点的方法与属性访问元素
Sub jdTest()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<ul id='myList'><li>Coffee</li><li>Tea</li></ul>"
    MsgBox oDom.getElementById("myList").FirstChild.innerText
    MsgBox oDom.getElementById("myList").LastChild.innerText
End Sub

Sub jdTest2()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<ul id='myList'><li>Coffee</li><li>Tea</li></ul>"
    Set listNode = oDom.getElementById("myList").ChildNodes
    MsgBox listNode.Length '获取子节点数
    MsgBox listNode(0).innerhtml '索引法获取第一个子节点的内容.
End Sub

Sub pjdTest()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<ul><li>Coffee</li><li>Tea</li></ul>"
    Set parNode = oDom.getElementsByTagName("li")(0).ParentNode
    MsgBox parNode.nodeName
    MsgBox parNode.innerText
    MsgBox parNode.innerhtml
End Sub

Sub sibTest()
    Dim id
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<ul id='myList'><li id='item1'>Coffee</li><li id='item2'>Tea</li></ul>"
    Set nexNode = oDom.getElementById("item1").NextSibling
    MsgBox nexNode.id
    MsgBox nexNode.innerText

    Set preNode = oDom.getElementById("item2").PreviousSibling
    MsgBox preNode.id
    MsgBox preNode.innerText
End Sub

Sub 访问第二个a元素()
    s = "<div id='nav' class='nav'><ul><li><a href='/newindexSpace.aspx?id=7cbf5455-d3cc-42ba-b27a-377ebd3b31fb&type=gw' target='_blank' >OA办公中心</a></li><li><a href='../ShowLv2.aspx?dis=%e6%a0%a1%e5%9b%ad%e5%9b%be%e4%b9%a6%e4%b8%ad%e5%bf%83&type=79e18d1f-ed03-4cf7-9a4f-47a282fb54a6' target='_blank' >校园图书中心</a></li><li><a href='/newindexSpace.aspx?id=96f81bd6-d833-4d74-a07c-8f85496d0c88&type=xy' target='_blank' >校园管理中心</a></li><li><a href='/admini/zp/YiRuiTe.aspx' target='_blank' >实验活动评选</a></li><li><a href='../ShowLv2.aspx?dis=%e8%bf%90%e7%bb%b4%e7%ae%a1%e7%90%86%e4%b8%ad%e5%bf%83&type=9dc96093-7912-4b15-86da-3196b4fa38c3' target='_blank' >运维管理中心</a></li></ul></div>"
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = s
    MsgBox oDom.getElementById("nav").getElementsByTagName("a")(1).innerText
    MsgBox oDom.getElementById("nav").getElementsByTagName("a")(1).href
End Sub

'获取元素(或标签)的属性值
Sub atTest()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<a href='/jsref/dom_obj_attributes.asp' target='_blank'>Attr 对象</a>"
    Set aNode = oDom.getElementsByTagName("a")(0)
    MsgBox aNode.href
    MsgBox aNode.target
End Sub

Sub atTest1()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<a href='/jsref/dom_obj_attributes.asp' target='_blank'>Attr 对象</a>"
    Set aNode = oDom.getElementsByTagName("a")(0)
    MsgBox aNode.getAttribute("href")
    MsgBox aNode.getAttribute("target")
End Sub

'应用Table对象读取表数据
Sub atTest2()
    Set oDom = CreateObject("htmlfile")
    oDom.body.innerhtml = "<table id='myTable' border='1'><tr><td>Row1 cell1</td><td>Row1 cell2</td></tr><tr><td>Row2 cell1</td><td>Row2 cell2</td></tr></table>"
    Set aNode = oDom.getElementById("myTable")
    rn = aNode.Rows.Length '表总行数
    ReDim arr(1 To rn, 1 To 2)
    For Each r In aNode.Rows
        i = i + 1: j = 0
        For Each c In r.Cells
            j = j + 1
            arr(i, j) = c.innerText
        Next
    Next
    Range("a1").Resize(rn, 2) = arr
End Sub

'jquery============================================================================='
Sub 获取图书信息()
'On Error Resume Next
    sURL1 = "http://www.queshu.com/search/?c=9787121098284"  '
    Set xmlhttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
    'oDom.write "<script src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    'oDom.write "<script src='http://www.w3school.com.cn/jquery/jquery.js'></script>" '出错
    With xmlhttp
        .Open "GET", sURL1, False
        .send
        stext = .responseText
    End With
    'oWindow.clipBoardData.setData "text", stext '写入剪贴板,粘贴在记事本中查看
        oDom.body.innerhtml = stext
    '网页中显示该书号共包含多少种书
    n = Mid(oWindow.eval("$('.main_b_crumbs strong').eq(0).text()"), 2, 1)
    'MsgBox oWindow.eval("$('.main_b_crumbs strong').eq(0).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs strong').eq(1).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span').eq(0).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span').eq(0).text()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span span').eq(0).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span span').eq(1).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span span span').eq(0).html()")
    'MsgBox oWindow.eval("$('.main_b_crumbs span').size()")
    For j = 1 To Val(n) '遍历每图书的各项信息
        '读取定价
        jg = oWindow.eval("$('.dingjia').eq(" & j - 1 & ").text()")
        '读取作者及出版日期等信息
        pcy = oWindow.eval("$('.left').parent().prev().eq(" & j - 1 & ").text()")
        'pcy = oWindow.eval("$('.dingjia').parent().parent().prev().eq(" & j - 1 & ").text()")
        '读取出版社
        cps = oDom.getElementById("class_left").innerText
        'cps = oWindow.eval("$('#class_left').eq(0).text()")
        'cps = oWindow.eval("$('#class_left').children().eq(0).text()")
        '读取书名
        sm = oWindow.eval("$('.img120').eq(" & j - 1 & ").attr('alt')")
        Cells(j, 1) = jg: Cells(j, 2) = pcy: Cells(j, 3) = cps: Cells(j, 4) = sm
    Next
End Sub

Sub 获取图书信息2()
Dim HTML, dv, sp
Dim n, j, i As Integer, jg, pcy, sm As String
Set HTML = CreateObject("htmlfile")

'On Error Resume Next
Range("a:d").Clear
With CreateObject("msxml2.xmlhttp")
    .Open "GET", "http://www.queshu.com/search/?c=9787121098284", False
    .send
    HTML.body.innerhtml = .responseText
    '网页中显示该书号共包含多少种书
    n = HTML.getElementsByTagName("strong")(0).innerText
    For j = 1 To n '遍历每图书的各项信息
        '读取定价及作者及出版日期等信息
        'i = 0 '以下注释掉的For循环代码也可实现
        'For Each sp In HTML.all.tags("span")
            'If Mid(sp.innerText, 1, 4) = "定　价：" Then i = i + 1
            'If i = 2 * j Then '连续2个span("left"、"dingjia")开头4字符均含为"定　价："，故需乘以2
                'jg = sp.innerText
                'pcy = sp.ParentNode.ParentNode.PreviousSibling.innerText
                'Exit For
            'End If
        'Next
        i = 0
        For Each dv In HTML.all.tags("div")
            If Mid(dv.innerText, 1, 4) = "定　价：" Then i = i + 1
            If i = j Then
                jg = dv.FirstChild.FirstChild.innerText
                pcy = dv.PreviousSibling.innerText
                Exit For
            End If
        Next
        '读取出版社
        cps = HTML.getElementById("class_left").innerText
        '读取书名
        'sm = HTML.getElementsByClassName("img120")(j - 1).getAttribute("alt") '本例前期引用仍不能识别Class(类)
        'i = 0 '以下注释掉的For循环代码也可实现
        'For Each dv In HTML.all.tags("div")
            'If dv.id = "class_book_right" Then i = i + 1
            'If i = j Then
                'sm = dv.PreviousSibling.FirstChild.FirstChild.getAttribute("alt")
                'Exit For
            'End If
        'Next
        i = 0
        For Each sp In HTML.all.tags("span")
            If sp.id = "hui_12" Then i = i + 1
            If i = j Then
                sm = sp.NextSibling.getAttribute("title")
                Exit For
            End If
        Next
        Cells(j, 1) = jg: Cells(j, 2) = pcy: Cells(j, 3) = cps: Cells(j, 4) = sm
    Next
End With
End Sub

Sub 获取图书信息3()
    Dim HTML, dv, sp, a
    Dim n, j, i, r As Integer, jg, pcy, sm As String
    Set HTML = CreateObject("htmlfile")
    'On Error Resume Next
    Range("a:d").Clear
    With CreateObject("msxml2.xmlhttp")
        .Open "GET", "http://www.queshu.com/search/?c=9787121098284", False
        .send
        HTML.body.innerhtml = .responseText
        For Each dv In HTML.all.tags("div")
            If Mid(dv.innerText, 1, 4) = "所有图书" Then
                n = dv.ChildNodes(0).ChildNodes(0).ChildNodes(4).innerText
                Exit For
            End If
        Next
        For j = 1 To n
            i = 0
            For Each sp In HTML.all.tags("span")
                If Mid(sp.innerText, 1, 4) = "定　价：" Then i = i + 1
                If i = j * 2 Then
                    jg = sp.innerText
                    Exit For
                End If
            Next

            i = 0
            For r = 0 To HTML.all.tags("div").Length
                If Mid(HTML.all.tags("div")(r).innerText, 1, 4) = "定　价：" Then i = i + 1
                If i = j Then
                    pcy = HTML.all.tags("div")(r - 1).innerText
                    Exit For
                End If
            Next
            cps = HTML.getElementById("class_left").innerText
            i = 0
            For Each a In HTML.all.tags("a")
                If InStr(a.innerhtml, "img120") > 0 Then i = i + 1
                If i = j Then
                    sm = Split(Split(a.innerhtml, "alt=")(1), "src=")(0)
                    Exit For
                End If
            Next
            Cells(j, 1) = jg: Cells(j, 2) = pcy: Cells(j, 3) = cps: Cells(j, 4) = sm
        Next
    End With
End Sub

'选择器
Sub jTest()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script>"
    oDom.write "<p id='myid' name='test'>这是一个段落</p>"
    MsgBox oDom.DocumentElement.innerhtml  '你可以看到你写入的HTML文档
    MsgBox oWindow.eval("$('#myid').text()")
End Sub

  Sub jTest2()
    Set oDom = CreateObject("htmlfile")
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    oDom.body.innerhtml = "<p id='myid'>这是一个段落</p>"
    MsgBox oDom.parentWindow.eval("$('#myid').text()")
  End Sub

'元素选择器
Sub sel()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    oDom.body.innerhtml = "<html><body><h1 class='intro'>这是一个标题</h1><p>这是第一个段落</p><p id='myid' class='intro'>这是第二个段落</p><p class='intro'>这是第三个段落</p></body></html>"
    MsgBox oDom.DocumentElement.innerhtml  '你可以看到你写入的HTML文档
    MsgBox oWindow.eval("$('#myid').text()")   'id为"myid"元素的文本内容
    MsgBox oWindow.eval("$('p').size()")       '文档中所有p元素的个数
    MsgBox oWindow.eval("$('.intro').size()")  '文档中所有class为intro为HTML元素个数
    MsgBox oWindow.eval("$('p.intro').size()") 'class为intro的所有p元素.
End Sub

'属性选择器
Sub sell()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script  src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
    oDom.body.innerhtml = "<a href='http://news.ifeng.com/'>资讯</a><a href='http://finance.ifeng.com/' >财经</a>"
    MsgBox oWindow.eval("$('[href]').size()")
    MsgBox oWindow.eval("$(""[href='http://news.ifeng.com/']"").eq(0).text()") 'eq()是一个用索引号过滤的函数
    MsgBox oWindow.eval("$(""[href!='http://news.ifeng.com/']"").eq(0).text()") '这个结果出乎意料,貌似不支持该形式.
End Sub

'选择器组合
Sub 价格()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
    oDom.body.innerhtml = "<div class='p-price'><strong class='J_627913' data-price='86.90'><em>&yen;</em><i>86.90</i></strong></div>"
    MsgBox oWindow.eval("$('.p-price i').eq(0).text()")
End Sub

'过滤型选择器
Sub selll()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    oDom.body.innerhtml = "<html><body><h1 class='intro'>这是一个标题</h1><p>这是第一个段落</p><p id='myid' class='intro'>这是第二个段落</p><p class='intro'>这是第三个段落</p></body></html>"
    MsgBox oWindow.eval("$('p:eq(0)').text()")     '第一个p元素. 语法: 冒号eq(索引)    '
    MsgBox oWindow.eval("$('.intro:eq(1)').text()")
    '与上面等价方式
    MsgBox oWindow.eval("$('p').eq(0).text()")
End Sub

'内容选择器
Sub containsTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><h1>Welcome to My Homepage</h1><p class='intro'>My name is Donald</p><p>I live in Duckburg</p><p>My best friend is Mickey</p><div id='choose'>Who is your favourite:<ul><li>Goofy</li><li>Mickey</li><li>Pluto</li></ul></div></body></html>"
  MsgBox oWindow.eval("$('p:contains(is)').size()")     '文本内容包含"is"的P元素.
  MsgBox oWindow.eval("$('p:contains(is)').eq(0).text()")
End Sub

'Type选择器
Sub typeTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><form action=''>Name: <input type='text' name='user' /><br />Password: <input type='password' name='password' /><br /><button type='button'>Useless Button</button><input type='button' value='Another useless button' /><br /><input type='reset' value='Reset' /><input type='submit' value='Submit' /><br /></form></body></html>"
  MsgBox oWindow.eval("$(':text').attr('name')")
  MsgBox oWindow.eval("$(':password').attr('name')")
  MsgBox oWindow.eval("$(':reset').val()")
End Sub

'过滤器
Sub jTest3()
    Set oDom = CreateObject("htmlfile")
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    oDom.body.innerhtml = "<h1>欢迎来到我的主页</h1><div><p>这是 div 中的一个段落。</p></div><div><p>这是 div 中的另一个段落。</p></div><p>这也是段落。</p>"
    MsgBox oDom.parentWindow.eval("$('div p').first().text()")
    MsgBox oDom.parentWindow.eval("$('div p').last().text()")
    MsgBox oDom.parentWindow.eval("$('div p').eq(1).text()")
    MsgBox oDom.parentWindow.eval("$('p').eq(2).text()")
End Sub

Sub filterT()
    Set oDom = CreateObject("htmlfile")
    oDom.write "<script  src='http://www.w3school.com.cn/jquery/jquery.js'></script><body></body>"
    oDom.body.innerhtml = "<h1>欢迎来到我的主页</h1><p>我是唐老鸭。</p><p class='intro'>我住在 Duckburg。</p><p class='intro'>我爱 Duckburg。</p><p>我最好的朋友是 Mickey。</p>"
    MsgBox oDom.parentWindow.eval("$('p').filter('.intro').eq(0).text()")
    MsgBox oDom.parentWindow.eval("$('p').not('.intro').eq(0).text()")
End Sub

'遍历祖先
Sub parentTest()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
    oDom.body.innerhtml = "<div class='ancestors'>??<div style='width:500px;'>div (曾祖父)? ? <ul>ul (祖父)? ?? ???<li>li (直接父)? ?? ???<span>span</span>? ?? ?</li>? ? </ul>? ???</div>??<div style='width:500px;'>div (祖父)? ?? ? <p>p (直接父)? ?? ???<span>span</span>? ?? ?</p>? ?</div></div>"
    MsgBox oWindow.eval("$('span').parent().size()")
    MsgBox oWindow.eval("$('span').parent().eq(0).html()")
End Sub

Sub parentsTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='ancestors'>body (曾曾祖父)  <div style='width:500px;'>div (曾祖父)    <ul>ul (祖父)        <li>li (直接父)        <span>span</span>      </li>    </ul>     </div></body></html>"
  MsgBox oWindow.eval("$('span').parents().size()")
  MsgBox oWindow.eval("$('span').parents('ul').eq(0).html()") '您也可以使用可选参数来过滤对祖先元素的搜索。
End Sub

Sub parentsUTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='ancestors'>body (曾曾祖父)  <div style='width:500px;'>div (曾祖父)    <ul>ul (祖父)        <li>li (直接父)        <span>span</span>      </li>    </ul>     </div></body></html>"
  MsgBox oWindow.eval("$('span').parentsUntil('div').size()")  '元素span与div之间的元素
  MsgBox oWindow.eval("$('span').parentsUntil('div').eq(0).html()")
  MsgBox oWindow.eval("$('div').parentsUntil('span').size()")  '元素span与div之间的元素
  MsgBox oWindow.eval("$('div').parentsUntil('span').eq(0).html()")
End Sub

'遍历后代
Sub childrenTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><div class='descendants' style='width:500px;'>div (当前元素)<p class='1'>p (子)<span>span (孙)</span></p><p class='2'>p (子)<span>span (孙)</span></p> </div></body></html>"
  MsgBox oWindow.eval("$('div').children().size()")
  MsgBox oWindow.eval("$('div').children('p.1').html()") '可以使用可选参数来过滤对子元素的搜索。
End Sub

Sub findTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><div class='descendants' style='width:500px;'>div (当前元素)<p class='1'>p (子)<span>span (孙)</span></p><p class='2'>p (子)<span>span (孙)</span></p> </div></body></html>"
  MsgBox oWindow.eval("$('div').find('span').size()")
  MsgBox oWindow.eval("$('div').find('span:eq(0)').text()")
  MsgBox oWindow.eval("$('div').find('*').size()") '返回 <div> 的所有后代
End Sub

'遍历同胞
Sub siblingsTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='siblings'><div>div (父)<p>p</p><span>span</span><h2>h2</h2><h3>h3</h3><p>p</p></div></body></html>"
  MsgBox oWindow.eval("$('h2').siblings().size()")   '返回 <h2> 的所有同胞元素
  MsgBox oWindow.eval("$('h2').siblings('p').size()") '返回属于 <h2> 的同胞元素的所有 <p> 元素
  MsgBox oWindow.eval("$('h2').siblings('p:eq(0)').text()")
End Sub

Sub siblingsTest2()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='siblings'><div>div (父)<p>p</p><span>span</span><h2>h2</h2><h3>h3</h3><p>p</p></div></body></html>"
  MsgBox oWindow.eval("$('h2').next().text()") '只返回一个元素
End Sub

Sub nextaTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='siblings'><div>div (父)<p>p</p><span>span</span><h2>h2</h2><h3>h3</h3><p>p</p></div></body></html>"
  MsgBox oWindow.eval("$('h2').nextAll().size()")
  MsgBox oWindow.eval("$('h2').nextAll().eq(0).text()")
End Sub

Sub nextUTest2()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body class='siblings'><div>div (父)  <p>p</p>  <span>span</span>  <h2>h2</h2>  <h3>h3</h3>  <h4>h4</h4>  <h5>h5</h5>  <h6>h6</h6>  <p>p</p></div></body></html>"
  MsgBox oWindow.eval("$('h2').nextUntil('h6').size()") '返回介于 <h2> 与 <h6> 元素之间的所有同胞元素
End Sub

'把当前元素包含在选择集合中
Sub andSelfTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><ul>   <li>list item 1</li>   <li>list item 2</li>   <li class='third-item'>list item 3</li>   <li>list item 4</li>   <li>list item 5</li></ul></body></html>"
  MsgBox oWindow.eval("$('li.third-item').nextAll().size()")
  MsgBox oWindow.eval("$('li.third-item').nextAll().andSelf().size()")
  MsgBox oWindow.eval("$('li.third-item').nextAll().andSelf().eq(0).text()")
End Sub

'返回距当前元素最近的祖先元素
Sub closestTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body>  <ul> <li><b>Click me!</b></li><li>You can also <b>Click me!</b></li>  </ul></body></html>"
  MsgBox oWindow.eval("$('b').closest('li').html()")
End Sub

'将匹配元素集合缩减为指定范围的子集
Sub sliceTest1()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><p>This is a paragraph1.</p><p>This is a paragraph2.</p><p>This is a paragraph3.</p><p>This is a paragraph4.</p><p>This is a paragraph5.</p><p>This is a paragraph6.</p></body></html>"
  MsgBox oWindow.eval("$('p').slice(0,2).size()")
  MsgBox oWindow.eval("$('p').slice(0,2).eq(0).text()")
End Sub

Sub sliceTest2()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><p>This is a paragraph1.</p><p>This is a paragraph2.</p><p>This is a paragraph3.</p><p>This is a paragraph4.</p><p>This is a paragraph5.</p><p>This is a paragraph6.</p></body></html>"
  MsgBox oWindow.eval("$('p').slice(2).size()")  '如果省略end,则选择直到最后一个p元素
  MsgBox oWindow.eval("$('p').slice(2).eq(0).text()")
End Sub

Sub sliceTest3()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><p>This is a paragraph1.</p><p>This is a paragraph2.</p><p>This is a paragraph3.</p><p>This is a paragraph4.</p><p>This is a paragraph5.</p><p>This is a paragraph6.</p></body></html>"
  MsgBox oWindow.eval("$('p').slice(2,4).size()")
  MsgBox oWindow.eval("$('p').slice(2,4).eq(0).text()")
End Sub

Sub sliceTest4()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><body><p>This is a paragraph1.</p><p>This is a paragraph2.</p><p>This is a paragraph3.</p><p>This is a paragraph4.</p><p>This is a paragraph5.</p><p>This is a paragraph6.</p></body></html>"
  MsgBox oWindow.eval("$('p').slice(-2,-1).size()")
  MsgBox oWindow.eval("$('p').slice(-2,-1).eq(0).text()")
End Sub

'对 jQuery 对象进行迭代，为每个匹配元素执行函数
Sub eachTest()
  Set oDom = CreateObject("htmlfile")
  Set oWindow = oDom.parentWindow
  oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
  oDom.body.innerhtml = "<html><head><body><ul><li>Coffee</li><li>Milk</li><li>Soda</li></ul></body></html>"
  MsgBox oWindow.eval("a=[];$('li').each(function(){a.push($(this).text())});a")
End Sub

Sub eachTest1()
Set oDom = CreateObject("htmlfile")
Set oWindow = oDom.parentWindow
oDom.write "<script src='http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js'></script><body></body>"
oDom.body.innerhtml = "<html><head><body><ul><li>Coffee</li><li>Milk</li><li>Soda</li></ul></body></html>"
MsgBox oWindow.eval("a=[];$('li').each(function(i,o){if(i!=1){a.push($(o).text())}});a")
End Sub

'json================================================================================='
'execScript方法和eval函数
Sub execScript()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "var d=new Date();t=d.getTime()" '把JavaScript代码放入双引号内。
    t = oWindow.t '请重视这种用法: 如何从javaScript执行语句中获得变量值
    MsgBox "从 1970/01/01 至今已过去 " & t & " 毫秒"
End Sub

Sub evala()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "str='abcdef'"
    strLength = oWindow.eval("str.length")
    MsgBox "字符串str的长度为: " & strLength
End Sub

Sub evalb()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oDom.write "<Script></Script>"
    strLength = oWindow.eval("str='abcdef';str.length")
    MsgBox "字符串str的长度为: " & strLength
End Sub

Sub evalc()
  Set oDom = CreateObject("HTMLFILE")

  Set oWindow = oDom.parentWindow
  oDom.write "<Script>str='abcdef';l=str.length</Script>"
  strLength = oWindow.l
  MsgBox "字符串str的长度为: " & strLength
End Sub

'执行JavaScript的全局函数
Sub GFuna()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oDom.write "<Script></Script>"  '如果文档中已经含Scirpt标签,就不用写入这句.
    stext = "中国"
    MsgBox oWindow.encodeURIComponent(stext)
End Sub

Sub GFunb()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oDom.write "<Script></Script>"  '如果文档中已经含Scirpt标签,就不用写入这句.
    stext = "中国"
    MsgBox oWindow.eval("encodeURIComponent('" & stext & "')") '%E4%B8%AD%E5%9B%BE
End Sub

'执行JavaScript的全局函数
Sub GFuna2()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oDom.write "<Script></Script>"  '如果文档中已经含Scirpt标签,就不用写入这句.
    stext = "%E4%B8%AD%E5%9B%BE"
    MsgBox oWindow.decodeURI(stext)
End Sub

Sub GFunb2()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oDom.write "<Script></Script>"  '如果文档中已经含Scirpt标签,就不用写入这句.
    stext = "%E4%B8%AD%E5%9B%BE"
    MsgBox oWindow.decodeURI(stext)
End Sub

'执行自定义函数
Sub a()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "function a(){var s=5+6;return s}"
    MsgBox oWindow.eval("a()")
End Sub

Sub aa()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oDom.write "<script>function a(){var s=5+6;return s}</script>"
    MsgBox oWindow.eval("a()")
End Sub

Sub aaa()
    b1 = 5
    b2 = 6
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "function a(x,y){s=x+y;return s}"
    MsgBox oWindow.eval("a(" & b1 & "," & b2 & ")")  '就是执行函数a(b1,b2)
End Sub

'JavaScript的数组和对象
Sub jArr1()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "a=['a','b','c',1,2,3];"
    MsgBox oWindow.eval("a[0]")
    MsgBox oWindow.eval("a.length")
End Sub

Sub jArr2()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "a=['a','b','c',1,2,3];"
    MsgBox oWindow.eval("s='';for(k in a){s=s+' ' +a[k];};s")
End Sub

Sub jObjA()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "o={'name': '张三','xb': '男', 'age':20}"
    MsgBox oWindow.o.xb '或下句方法
    MsgBox oWindow.eval("o.name")
End Sub

Sub jObjB()
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    oWindow.execScript "o={name: '张三',xb: '男', age:20}"
    MsgBox oWindow.eval("s=''; for(k in o){s=s+' '+o[k]};s")  '遍历值
    MsgBox oWindow.eval("s='';for(k in o){s=s+' '+k};s")       '遍历键
End Sub

'将网页文本写入剪贴板—clipboardData对象
Sub JsonArr()
    Set oHTML = CreateObject("htmlfile")
    Set oWindow = oHTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://pv.sohu.com/cityjson", False
    http.send
    strHtml = http.responseText
    oWindow.clipboardData.SetData "text", strHtml  '这句代码是把文本strHtml写入剪贴板
    MsgBox strHtml
End Sub

'什么是Json
Sub Json1()
    Set oHTML = CreateObject("htmlfile")
    Set oWindow = oHTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://pv.sohu.com/cityjson", False
    http.send
    strHtml = http.responseText
    'oWindow.clipboardData.SetData "text", strHtml
    '得到 var returnCitySN = {"cip": "218.72.14.14", "cid": "330100", "cname": "浙江省杭州市"}; 这就一个json文本。
    oWindow.execScript strHtml
    MsgBox oWindow.returnCitySN.cip
End Sub

Sub Json2()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    'Window.clipboardData.SetData "text", strHtml '写入剪贴板
    Window.execScript "var js= " & strHtml  ' 改写成对象创建语句
    Set kuwo = Window.js ' 获取解析后的对象
    MsgBox "访问量:" & kuwo.View
End Sub

'遍历对象或数组的方法
Sub Json3()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    Window.execScript "var js= " & strHtml  ' 解析 json
    ar = Array("work", "fans", "fortune", "view", "listen") '数组列出需要提取的项目
    For Each k In ar
        MsgBox Window.eval("js." & k)
    Next
End Sub

Sub Json4A()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    Window.execScript "var js= " & strHtml & ";s='';for(k in js){s=s+' '+k}"  'for语句得到由空格分隔的键名字符串对象s
    ar = Split(Trim(Window.s), " ")  '注意字符串s前有一个空格
    For Each k In ar
        MsgBox Window.eval("js." & k)
    Next
End Sub

Sub Json4B()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    Window.execScript "var js= " & strHtml & ";a=[];for(k in js){a.push(k)}"  'for语句得到键名数组a
    ar = Split(Window.a, ",")  '数组a到VBA环境中自动转换为由逗号分隔的字符串
    For Each k In ar
        MsgBox Window.eval("js." & k)
    Next
End Sub

Sub Json4C()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    Window.execScript "var js= " & strHtml & ";a=[];for(k in js){a.push(js[k])}"  'for语句得到键值数组a
    ar = Split(Window.a, ",")
    For Each k In ar
        MsgBox k
    Next
End Sub

Sub Json4D()
    Set HTML = CreateObject("htmlfile")
    Set Window = HTML.parentWindow
    Set http = CreateObject("Msxml2.XMLHTTP")
    http.Open "GET", "http://kzone.kuwo.cn/mlog/UserVal?uid=1237357&from=profile", False
    http.send
    strHtml = http.responseText ' 得到数据
    Window.execScript "var js= " & strHtml & ";a=[];for(k in js){a.push(js[k])};s=a.join('@')"  'join把数组a转换为"@"分隔的字符串s
    ar = Split(Window.s, "@")
    For Each k In ar
        MsgBox k
    Next
End Sub

'Jsonp解析方法
Sub jsonp1()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    strHtml = "cb({mobile:'13012345456',province:'重庆',isp:'中国联通',stock:'1',amount:'10000',maxprice:'0',minprice:'0'});"
    oWindow.execScript "function cb(o){ js=o };"
    oWindow.execScript strHtml
    MsgBox oWindow.js.mobile
End Sub

'数组和对象自身嵌套或相互嵌套的Json/Jsonp实例
Sub aaaa()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    strHtml = "[['张三','男',23],['李四','女',20],['王五','男',22]]"
    oWindow.execScript "a=" & strHtml
    MsgBox oWindow.eval("a[0][0]")  '第一个成员的姓名
End Sub

Sub ao()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    strHtml = "[{'name':'张三','sex':'男','age':23}, {'name':'李四','sex':'女','age':20}, {'name':'王五','sex':'男','age':22}]"
    oWindow.execScript "a=" & strHtml
    MsgBox oWindow.eval("a[0].name")  '第一个成员的姓名
    MsgBox oWindow.eval("a[2].age")  '第三个成员的年龄
End Sub

Sub aoo()
    Set oDom = CreateObject("htmlfile")
    Set oWindow = oDom.parentWindow
    strHtml = "{'dw':'宇宙公司','zb1': [{'name':'张三','sex':'男','age':23}, {'name':'李四','sex':'女','age':20}, {'name':'王五','sex':'男','age':22}],'zb2':[{'name':'刘六','sex':'男','age':24}, {'name':'风车车','sex':'女','age':18}, {'name':'汪麻','sex':'男','age':21}],'total':6}"
    oWindow.execScript "a=" & strHtml
    Debug.Print oWindow.a.dw                           '公司名称
    Debug.Print oWindow.eval("a.total")              '公司总人数. 想想为什么不用上一句方式读取total值呢？
    Debug.Print oWindow.eval("a.zb1[0].name")  '第一工作组的第一位成员姓名
    Debug.Print oWindow.eval("a.zb2[2].age")     '第二工作组的第三位成员年龄
End Sub

Sub js()
    Dim arr(1 To 100, 1 To 5)
    sURL = "http://comment.10jqka.com.cn/tzrl/getTzrlData.php?callback=callback_dt&type=data&date=201608"
    Set oDom = CreateObject("HTMLFILE")
    Set oWindow = oDom.parentWindow
    Set oHTML = CreateObject("MSXML2.XMLHTTP")
    oHTML.Open "GET", sURL, False
    oHTML.send
    oWindow.execScript oHTML.responseText & ";function callback_dt(o){oj=o};n=oj.data.length"
    For i = 0 To oWindow.n - 1
        r = r + 1
        arr(r, 1) = oWindow.eval("var oi=oj.data[" & i & "]; oi.date+oi.week;")
        imt = oWindow.eval("s=0;for(x in oi){s+=1;if(s==3){imt=oi[x]}};imt")
        arr(r, 2) = String(imt, "★")
        For j = 0 To oWindow.eval("oi.events.length") - 1
            arr(r, 3) = oWindow.eval("oi.events[" & j & "][0]")
            For Each u In Array("field", "concept")
            arr(r, 4) = arr(r, 4) & "," & oWindow.eval("ar=[];k=oi." & u & "[" & j & "];for(x in k){ar.push(k[x].name);ar}")
            Next
            arr(r, 4) = Trim(Replace(arr(r, 4), ",", " "))
            arr(r, 5) = oWindow.eval("ar=[]'';k=oi.stocks[" & j & "];for(x in k){ar.push(k[x].name);ar}")
            arr(r, 5) = Replace(arr(r, 5), ",", " ")
            r = r + 1
        Next
        r = r - 1
    Next
    Range("a2").Resize(r, 5) = arr
End Sub

'xml====================================================================================='
'访问元素文本内容和属性
Sub loadxmla1()
    Text = "<bookstore>"
    Text = Text + "<book>"
    Text = Text + "<title>Harry Potter</title>"
    Text = Text + "<author>J K. Rowling</author>"
    Text = Text + "<year>2005</year>"
    Text = Text + "</book>"
    Text = Text + "</bookstore>"
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.loadXML (Text)
    MsgBox xmlDoc.getElementsByTagName("title")(0).ChildNodes(0).NodeValue
    MsgBox xmlDoc.getElementsByTagName("title")(0).ChildNodes(0).Text
    MsgBox xmlDoc.getElementsByTagName("title")(0).Text
End Sub

Sub loadXMLb()
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.Load ("http://www.w3school.com.cn/example/xdom/books.xml")
    Set x = xmlDoc.getElementsByTagName("book")
    '下面三个等价方式
    MsgBox x(0).Attributes(0).Text
    MsgBox x(0).Attributes(0).NodeValue
    MsgBox x(0).Attributes.getNamedItem("category").NodeValue
End Sub

'访问节点总结
Sub loadXML()
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.Load ("http://www.w3school.com.cn/example/xdom/books.xml")
    Set x = xmlDoc.getElementsByTagName("title")
    MsgBox x(2).ChildNodes(0).NodeValue
End Sub

Sub 访问2()
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.Load ("http://www.w3school.com.cn/example/xdom/books.xml")
    Set x = xmlDoc.getElementsByTagName("title")
    For i = 0 To x.Length - 1
        MsgBox x(i).ChildNodes(0).NodeValue
    Next
End Sub

Sub 访问3()
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.Load ("http://www.w3school.com.cn/example/xdom/books.xml")
    Set x = xmlDoc.DocumentElement.ChildNodes
    For Each k In x
        MsgBox k.nodeName
    Next
End Sub

Sub 访问4()
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.Load ("http://www.w3school.com.cn/example/xdom/books.xml")
    Set x = xmlDoc.getElementsByTagName("book")(0).ChildNodes
    Set y = xmlDoc.getElementsByTagName("book")(0).FirstChild
    For i = 0 To x.Length - 1
        If y.NodeType = 1 Then
            MsgBox y.nodeName
        End If
        Set y = y.NextSibling
    Next
End Sub

'XML DOM中使用xPath
Sub xPathXMLb()
    Text = "<?xml version='1.0' encoding='ISO-8859-1'?><bookstore><book>  <title lang='eng'>Harry Potter</title>  <price>29.99</price></book><book>  <title lang='eng'>Learning XML</title>  <price>39.95</price></book></bookstore>"
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.loadXML (Text)
    Set x = xmlDoc.SelectSingleNode("/bookstore/book/title")    '第一个book节点的首个title节点
    Set y = xmlDoc.SelectSingleNode("/bookstore/book[1]/title") '第二个Book节点的首个title节点
    MsgBox x.ChildNodes(0).NodeValue    'x.FirstChild.nodevalue
    MsgBox x.Attributes(0).NodeValue
    MsgBox y.FirstChild.NodeValue
End Sub

Sub xPathXMLa()
    Text = "<?xml version='1.0' encoding='ISO-8859-1'?><bookstore><book>  <title lang='eng'>Harry Potter</title>  <price>29.99</price></book><book>  <title lang='eng'>Learning XML</title>  <price>39.95</price></book></bookstore>"
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.loadXML (Text)
    Set x = xmlDoc.SelectNodes("/bookstore/book/title")
    MsgBox x.Length
    MsgBox x(0).FirstChild.NodeValue
End Sub

Sub test()
    s = "<caseItemLog><WL B='9073185407748296660' I='9073185407748296660' N='14700356538634' P='4053418715206535326' PN='寮 涓' ICD='1470819508317' IUD='1470819508317' AS='0'/><WL B='7981047663275560771' I='7981047663275560771' N='14700356538637' P='5471147329064354838' PN='浜' ICD='1470819508317' IUD='1474212600407' AS='0,26,5'/></caseItemLog>"
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
    xmlDoc.async = "false"
    xmlDoc.loadXML (s)
    For Each k In xmlDoc.getElementsByTagName("WL")(0).Attributes '第一个WL元素的属性
       MsgBox k.Text
    Next
End Sub