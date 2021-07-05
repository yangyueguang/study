import UIKit
import Foundation

// 水平对齐方式
enum Alignment {case left, right, center}
// 垂直对齐方式
enum Valign {case top, middle, bottom}
enum specialCode: String {
    case lt = "<"
    case gt = ">"
    case nbsp = " "
    case copy = "©"
    case trade = "™"
    case reg = "®"
}
class HtmlID: NSObject {}
// 区块元素 单独占一行
class Block: NSObject {}
// 内联元素 跟其他元素可以共用一行
class Inline: NSObject {}

class HTML: NSObject {
    var lang = "en" // 语言
    var xmlns: String? // 命名空间
    // 头部
    class head: NSObject {
        // 元数据，数据字典说明
        class meta: NSObject {
            var charset = "utf-8"
            var name = ""// author  keywords  description ……
            var content = ""
            var http_quiv = "Content-Type"// content="text/html;charset=UTF-8"

        }

        // 标题
        class title: NSObject {
        }
        
        // 交互
        class script: NSObject {
            var type = "javascript"
        }

        // 样式
        class style: NSObject {
            var type = "text/css"
        }

        // 链接样式表标记
        class link: NSObject {
            var src: String?
        }
    }

    // 内容
    class body: NSObject {

    }

    // 尾部
    class foot: NSObject {

    }

    //FIXME: 标签语言
    // 标题
    struct header {
        var h1: String?
        var h2: String?
        var h3: String?
        var h4: String?
        var h5: String?
        var h6: String?
    }

    // 标签
    class label: NSObject {
        var For: HtmlID?

    }



    // 简单的inline元素
    class span: NSObject {

    }

    // 横线
    class hr: NSObject {
        var width: Float?
        var size: Float?
        var color: UIColor?
        var align: Alignment?
    }

    // division 简单的区块元素 层 可以多层叠加在一起
    class div: Block {

    }



    // 列表
    class list: NSObject {
        // 列表元素
        class li: NSObject {

        }
        // order list
        class ol: NSObject {
            enum olType {// 数字，字母，罗马数字
                case a1, a, A, i, I
            }
            var type: olType?
            var start: Int = 0 // 从第几个顺序开始
            
        }
        // unorder list
        class ul: NSObject {
            enum ulType {
                case disc, circle, square
            }
            var type: ulType?
        }
        // define list
        class dl: NSObject {
            // define item title
            class dt: NSObject {

            }
            // define item detail
            class dd: NSObject {

            }

        }
    }

    // 表单
    class form: NSObject {
        var action: String?
        var method: inputMethod?
        var enctype: String = "multipart/form-data"//text/plain  application/x-www-form-urlencoded
        enum inputMethod {
            case get, post
        }
        class input: NSObject {
            enum inputType {
                case text, submit, password, radio, file, hidden, phone
            }
            var type: inputType?
            var name: String?
            var value = "请输入用户名"
            var style: script?
            var maxlenght: Int? // 最大输入长度
            var disabled: bool? // 不可修改不可提交
            var readOnly: bool? // 不可修改可以提交
            var checked: bool? // radio才有的
        }
    }

    // 标签框 输入域集合
    class fieldset: NSObject {
        // div ...
        // 标签框文本
        class legend: NSObject {

        }
    }

    // 文本输入
    class textarea: NSObject {
        var name: String?
        var rows: Int? // 行数
        var cols: Int? // 列数
        var readOnly: bool?
        var disabled: bool?

    }
    //MARK 富文本编辑器——可使用第三方工具(KindEdtitor / FCKEdtior / CuteEditor)

    // 下拉框
    class select: NSObject {
        var name: String?
        var size: Int?// 行数 不设可以点击展开
        var multiple: bool? // 多选

        class optgroup: NSObject {
            var label: String?

            class option: NSObject {
                var value: String?
                var selected: bool?
            }
        }
    }

    // 嵌入网页
    class iframe: UIWebview {
        var src: String?
        var width: Float?
        var height: Float?
    }

    // 度量元素进度条
    class meter: NSObject {
        var title: String?
        var min: Int?
        var max: Int?
        var value: Int?
    }

    // 时间元素
    class time: NSObject {
        var datetime: Date? // = "2018-8-8T8:00"

    }


    // 显示源码中的样子
    class pre: NSObject {
        /*<pre>function myFunction() {alert("hello");}</pre>*/
    }

    // 图片请求
    class img: Inline {
        var src: String?
        var width: Float?
        var height: Float?
        var alt: String?// 没有图片的替代文字

    }

    // 超链接
    class a: NSObject {// <a href="5.html#ch3">
        var href: String?//#：跳到name为某某某的地方
        var target: String?// _blank, _self 打开新的网页还是原有网页跳转
        var name: String?
    }

    // 表格
    class table: NSObject {
        var width: Float?
        var height: Float?
        var align: Alignment?
        var border: Float?
        var cellpadding: Float? // 内边距
        var cellspacing: Float? // 外边距
        var bgcolor: UIColor?
        // 表格名称
        class caption: NSObject {

        }
        // 表头
        class thead: NSObject {

        }

        // 表主题
        class tbody: NSObject {

        }

        // 表尾
        class tfoot: NSObject {

        }

        // tableType 行
        class tr: NSObject {
            var align: Alignment?
            var valign: Valign?
            var bgcolor: UIColor?

            // 标题加粗的cell
            class th: NSObject {

            }

            // tableDetail cell
            class td: NSObject {
                var align: Alignment?
                var valign: Valign?
                var width: Float?
                var height: Float?
                var colspan: Int? // 跨列
                var rowspan: Int? // 跨行
            }
        }
    }


    // 包含展开收缩的细节
    class details: NSObject {
        // 细节头信息
        class summary: NSObject {
        }
        // div ...
    }

    // 定义文档其他部分的内容
    class article: NSObject {
        // div ...
    }

}

// 字体样式
class textStyle: NSObject {
    // 上标字
    class sup: NSObject {

    }

    // 下标字
    class sub: NSObject {

    }
    // 高亮显示
    class mark: NSObject {

    }
    // 加粗
    class b: NSObject {

    }
    // 加粗
    class Strong: NSObject {

    }
    // 斜体
    class i: NSObject {

    }
    // 斜体强调
    class em: NSObject {

    }
    // 删除线
    class s: NSObject {

    }
    // 下划线
    class u: NSObject {

    }
    // 段落
    class p: Block {

    }


}

// 框架布局
class Framework: NSObject {
    // 侧边栏
    class aside: NSObject {

    }
    // 导航
    class nav: NSObject {

    }
    // 主题
    class section: NSObject {

    }
    // 头部
    class header: NSObject {

    }
    // 尾部
    class footer: NSObject {

    }
}
//FIXME: 单标签
// 指定当前页面的相对地址的资源的URL基准值
class base: NSObject {
    var href: String?

}
