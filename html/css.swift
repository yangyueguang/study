import UIKit
import Foundation
//元素的定位
//1.流/静态定位:默认/position:static; 不能指定位置
//2.浮动定位:float:left/right; 不能严格指定位置
//3.相对定位:position:relative; 使用left/top/right/bottom进行定位，仍占用页面空间
//4.绝对定位:position:ablolute; 使用left/top/right/bottom进行定位，不占用页面空间
//5.固定定位:position:fixed; 使用left/top/right/bottom进行定位，不占用页面空间
/*
 CSS选择器
 */
class picker: NSObject {
    /*
    .class .intro 选择所有class="intro"的元素 1
    #id #firstname 选择所有id="firstname"的元素 1
    * * 选择所有元素 2
    element p 选择所有<p>元素 1
    element,element div,p 选择所有<div>元素和<p>元素 1
    element element div p 选择<div>元素内的所有<p>元素 1
    element>element div>p subviews 选择所有父级是 <div> 元素的 <p> 元素 2
    element+element div+p firstView 选择所有紧接着<div>元素之后的<p>元素 2
    [attribute] [target] 选择所有带有target属性元素 2
    [attribute=value] [target=-blank] 选择所有使用target="-blank"的元素 2
    [attribute~=value] [title~=flower] 选择标题属性包含单词"flower"的所有元素 2
    :link a:link 选择所有未访问链接 1
    :visited a:visited 选择所有访问过的链接 1
    :active a:active 选择活动链接 1
    :hover a:hover 选择鼠标在链接上面时 1
    :first-letter p:first-letter 选择每一个<P>元素的第一个字母 1
    :first-line p:first-line 选择每一个<P>元素的第一行 1
    :first-child p:first-child 指定只有当<p>元素是其父级的第一个子级的样式。 2
    :before p:before 在每个<p>元素之前插入内容 2
    :after p:after 在每个<p>元素之后插入内容
    element1~element2 p~ul 选择p元素之后的每一个ul元素 3
    [attribute^=value] a[src^="https"] 选择每一个src属性的值以"https"开头的元素 3
    [attribute$=value] a[src$=".pdf"] 选择每一个src属性的值以".pdf"结尾的元素 3
    :root :root 选择文档的根元素 3
    :empty p:empty 选择每个没有任何子级的p元素（包括文本节点） 3
    :not(selector) :not(p) 选择每个并非p元素的元素 3
    :required :required 用于匹配设置了 "required" 属性的元素 3
 */
}
/*
 CSS属性
 */
class CSS: NSObject {
    // 显示方式
    enum Display {
        case none// 此元素不会被显示。
        case block// 此元素将显示为块级元素，此元素前后会带有换行符。
        case inline// 默认。此元素会被显示为内联元素，元素前后没有换行符。
        case inline-block// 行内块元素。（CSS2.1 新增的值）
        case list-item// 此元素会作为列表显示。
        case table// 此元素会作为块级表格来显示（类似 <table>），表格前后带有换行符。
        case table-row-group// 此元素会作为一个或多个行的分组来显示（类似 <tbody>）。
        case table-column-group// 此元素会作为一个或多个列的分组来显示（类似 <colgroup>）。
        case table-cell// 此元素会作为一个表格单元格显示（类似 <td> 和 <th>）
        case inherit// 规定应该从父元素继承 display 属性的值。
    }

    // 尺寸
    enum Size {
        case px
        case percent // %
        case em
        case auto
        case inherit
    }

    enum LineType {
        case solid, dotted
    }

    // 列数
    enum Columns {
        case column-count// 指定元素应该被分割的列数。
        case column-fill// 指定如何填充列
        case column-gap// 指定列与列之间的间隙
        case column-rule// 所有 column-rule-* 属性的简写
        case column-rule-color// 指定两列间边框的颜色
        case column-rule-style// 指定两列间边框的样式
        case column-rule-width// 指定两列间边框的厚度
        case column-span// 指定元素要跨越多少列
        case column-width// 指定列的宽度
        case columns// 设置 column-width 和 column-count 的简写
    }

    // 背景 包括图片，颜色等
    enum Background {
//        background: #00ff00 url('smiley.gif') left top no-repeat fixed center;
//        background:bg-color bg-image position/bg-size bg-repeat bg-origin bg-clip bg-attachment initial|inherit;
//        background-image: url(img_flwr.gif), url(paper.gif);
//        background-position: right bottom, left top;
//        background-repeat: no-repeat, repeat;
//        background-origin:content-box padding-box border-box;
//        background-size:100% 100%;
//        background: linear-gradient(to bottom right, red , blue,yellow, green);
//        background: linear-gradient(180deg, red, blue);
//        background: radial-gradient(red 5%, green 15%, blue 60%)
    }

    // 边框
    class Border: NSObject {
        var radius: CGRect?
        var type: LineType?
        var color: UIColor?
        var image: URL?

    }

    // 阴影
    class BoxShadow: NSObject {
        var x: Size?
        var y: Size?
        var z: Size?
        var color: UIColor?
    }

    class transform: NSObject {
        //        transform: rotate(30deg);
        //        transform: translate(50px,100px);
        //        transform: scale(2,3);
        //        transform: skew(30deg,20deg);倾斜
        //        matrix 方法有六个参数，包含旋转，缩放，移动（平移）和倾斜功能
        //        translate3d(x,y,z)
        //        scale3d(x,y,z)
        //        rotate3d(x,y,z,angle)
    }

    // 内容对齐方式
    enum Align-content {
        case stretch, center, flex-start, flex-end, space-between, space-around, initial, inherit
    }
    // 子元素对齐方式
    enum Align-items {
        case stretch, center, flex-start, flex-end, baseline, initial, inherit
    }
    // 子元素换行方式
    enum Flex-wrap {
        case nowrap, wrap, wrap-reverse, initial, inherit
    }
    // 浮动方式
    enum CSFloat {
        case left, right, center
    }
    // 超出区域的处理方式
    enum OverFlow {
        case scroll, hidden
    }


    var display: Display?
    var width  : Size?
    var height  : Size?
    var top  : Size?
    var bottom   : Size?
    var left   : Size?
    var right   : Size?
    var fontsize : Size?
    var marging : CGRect?
    var padding : CGRect?
    var columns : Columns?
    var background: Background?
    var border : Border?
    var font: Size?
    var color: UIColor?
    var box-shadow: BoxShadow?

    /* 不常用的 */
    //    func animation: name duration timing-function delay iteration-count direction fill-mode play-state;
    var align-items: Align-items?
    var flex-flow: NSObject?
    var align-content: Align-content?
    var animation: NSObject?
    var flex: Int?
    var float: CSFloat?
    var overflow: OverFlow?
    var text-decoration = "underline"
    var box-sizing = "border-box"//考虑了padding和bord之后的尺寸大小

    /*弹性盒子*/
    var display: CSS.Display?
    var flex-direction = "row"
    var justify-content: Align-content?
    var align-items: Align-items?
    var flex-wrap: Flex-wrap?
    var align-content: Align-content?
    var flex: Int?// 比例比重

    /*文字特效*/
    var text-shadow: CSS.BoxShadow?
    var text-wrap = "break-word"//   break-all;
    var white-space = "nowrap"// 不换行
    var text-align: Align-content?
    var font-size: Size?

}
