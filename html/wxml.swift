import UIKit
import Foundation
typealias Event = (() _> Void)?
enum Space {
    case ensp // 中文字符空格一半大小
    case emsp // 中文字符空格大小
    case nbsp // 根据字体设置的空格大小
}
class Nodes: NSObject {
    var name:String?// 标签名 string // 支持部分受信任的 HTML 节点
    var attrs: Any? // 属性 object // 支持部分受信任的属性，遵循 Pascal 命名法
    var children:[Nodes] = []// 子节点列表 // 结构和 nodes 一致
}
/*
 视图容器
 */
class View: NSObject {

    // 图片视图
    class coverImage: NSObject {
        // 图标路径
        var src: String?
        // 图片加载成功时触发
        var bindload: Event?
        // 图片加载失败时触发
        var binderror: Event?
    }

    // 覆盖在原生组件之上的文本视图
    class coverView: NSObject {
        //顶部滚动偏移量
        var scroll_top: Int?
    }
    //的可移动区域
    class movableArea: NSObject {
        // 当里面的movable_view设置为支持双指缩放时，设置此值可将缩放手势生效区域修改为整个movable_area
        var scale_area: Bool?
    }
    // 可移动的视图容器
    class movableView: NSObject {

        var direction:String?// none //movable_view的移动方向，属性值有all、vertical、horizontal、none
        var inertia = false// movable_view是//带有惯性
        var out_of_bounds = false // 超过可移动区域后，movable_view是//还可以移动
        var x: Int? // 定义x轴方向的偏移，如果x的值不在可移动范围内，会自动移动到可移动范围；改变x的值会触发动画
        var y: Int? // 定义y轴方向的偏移，如果y的值不在可移动范围内，会自动移动到可移动范围；改变y的值会触发动画
        var damping: Int? // 阻尼系数，用于控制x或y改变时的动画和过界回弹的动画，值越大移动越快
        var friction: Int? // 摩擦系数，用于控制惯性滑动的动画，值越大摩擦力越大，滑动越快停止；必须大于0，//则会被设置成默认值
        var disabled = false // 是//禁用
        var scale = false // 是//支持双指缩放，默认缩放手势生效区域是在movable_view内
        var scale_min: Float? // 定义缩放倍数最小值
        var scale_max: Float? // 定义缩放倍数最大值
        var scale_value: Float? // 定义缩放倍数，取值范围为 0.5 _ 10
        var animation = true // 是//使用动画
        var bindchange: Event? // 拖动过程中触发的事件，event.detail = {x, y, source}
        var bindscale:Event? // 缩放过程中触发的事件，event.detail = {x, y, scale}，x和y字段在之后支持
        var htouchmove:Event? // 初次手指触摸后移动为横向的移动时触发，如果catch此事件，则意味着touchmove事件也被catch
        var vtouchmove:Event? // 初次手指触摸后移动为纵向的移动时触发，如果catch此事件，则意味着touchmove事件也被catch
    }
    //可滚动视图区域
    class scrollView: NSObject {
        var scroll_x = false // 允许横向滚动
        var scroll_y = false // 允许纵向滚动
        var upper_threshold:Int?//string // 距顶部/左边多远时，触发 scrolltoupper 事件
        var lower_threshold:Int?//string // 距底部/右边多远时，触发 scrolltolower 事件
        var scroll_top:Int?//string // 设置竖向滚动条位置
        var scroll_left:Int?//string // 设置横向滚动条位置
        var scroll_into_view:String? // 值应为某子元素id（id不能以数字开头）。设置哪个方向可滚动，则在哪个方向滚动到该元素
        var scroll_with_animation = false // 在设置滚动条位置时使用动画过渡
        var enable_back_to_top = false // iOS点击顶部状态栏、安卓双击标题栏时，滚动条返回顶部，只支持竖向
        var bindscrolltoupper:Event? // 滚动到顶部/左边时触发
        var bindscrolltolower:Event? // 滚动到底部/右边时触发
        var bindscroll:Event? // 滚动时触发，event.detail = {scrollLeft, scrollTop, scrollHeight, scrollWidth, deltaX, deltaY}

    }
    // 滑块视图容器
    class swiper: NSObject {
        var indicator_dots = false // 是//显示面板指示点
        var indicator_color:UIColor?// rgba(0, 0, 0, .3) // 指示点颜色
        var indicator_active_color:UIColor?// #000000//// 当前选中的指示点颜色
        var autoplay = false // 是//自动切换
        var current:Int? //0 // 当前所在滑块的 index
        var interval:Int?// 5000 // 自动切换时间间隔
        var duration:Int?// 500 // 滑动动画时长
        var circular = false // 是//采用衔接滑动
        var vertical = false // 滑动方向是//为纵向
        var previous_margin:String// "0px" // 前边距，可用于露出前一项的一小部分，接受 px 和 rpx 值
        var next_margin:String // "0px" // 后边距，可用于露出后一项的一小部分，接受 px 和 rpx 值
        var display_multiple_items:Int?// 1 // 同时显示的滑块数量
        var skip_hidden_item_layout = false // 是//跳过未显示的滑块布局，设为 true 可优化复杂情况下的滑动性能，但会丢失隐藏状态滑块的布局信息
        var easing_function:String?// "default" // 指定 swiper 切换缓动动画类型 2.6.5
        var bindchange:Event? // current 改变时会触发 change 事件，event.detail = {current, source}
        var bindtransition:Event? // swiper_item 的位置发生改变时会触发 transition 事件，event.detail = {dx: dx, dy: dy} 2.4.3
        var bindanimationfinish:Event? // 动画结束时会触发 animationfinish 事件，event.detail 同上


        class swiperItem: NSObject {
            var item_id:String?
        }
    }

    class view: NSObject {
        var hover_classs:String?// none // 指定按下去的样式类。当 hover_class="none" 时，没有点击态效果
        var hover_stop_propagation = false // 指定是//阻止本节点的祖先节点出现点击态
        var hover_start_time:Int?// 50 // 按住后多久出现点击态，单位毫秒
        var hover_stay_time:Int?// 400 // 手指松开后点击态保留时间，单位毫秒

    }

}
/*
 基础内容
 */
class Base: NSObject {
    // 图标
    class icon: NSObject {
        var type:String? // icon的类型，有效值：success, success_no_circle, info, warn, waiting, cancel, download, search, clear
        var size:Int?// 23 // icon的大小
        var color:String? // icon的颜色，同css的color

    }
    // 进度条
    class progress: NSObject {
        var percent:Int? // 百分比0~100
        var show_info = false // 在进度条右侧显示百分比
        var border_radius:Double?//string 0 // 圆角大小
        var font_size:Int?// 16 // 右侧百分比字体大小
        var stroke_width:Int? 6 // 进度条线的宽度
        var color:UIColor? // 进度条颜色（请使用activeColor）
        var activeColor:UIColor? // 已选择的进度条的颜色
        var backgroundColor:UIColor? // 未选择的进度条的颜色
        var active = false // 进度条从左往右的动画
        var active_mode:String?// backwards // backwards: 动画从头播；forwards：动画从上次结束点接着播
        var bindactiveend:Event? // 动画完成事件

    }
    // 富文本
    class richText: NSObject {
        var nodes:[Nodes]= [] // 节点列表/HTML String
        var space:Space? // 显示连续空格 


    }
    // 文本
    class text: NSObject {
        var selectable = false // 文本是//可选
        var space:String? // 显示连续空格
        var decode = false // 是//解码
        var space: Space?

    }
}
/*
 表单组件
 */
class Form: NSObject {
    //按钮
    class button: NSObject {
        enum Size {
            case `default`// 默认大小
            case mini // 小尺寸
        }
        enum Type {
            case primary // 绿色
            case `default` // 白色
            case warn// 红色
        }
        enum FormType {
            case submit// 提交表单
            case reset // 重置表单
        }
        enum OpenType {
            case contact // 打开客服会话，如果用户在会话中点击消息卡片后返回小程序，可以从 bindcontact 回调中获得具体信息，具体说明
            case share // 触发用户转发，使用前建议先阅读使用指引
            case getPhoneNumber // 获取用户手机号，可以从bindgetphonenumber回调中获取到用户信息，具体说明
            case getUserInfo // 获取用户信息，可以从bindgetuserinfo回调中获取到用户信息
            case launchApp // 打开APP，可以通过app_parameter属性设定向APP传的参数具体说明
            case openSetting // 打开授权设置页
            case feedback // 打开“意见反馈”页面，用户可提交反馈内容并上传日志，开发者可以登录小程序管理后台后进入左侧菜单“客服反馈”页面获取到反馈内容
        }
        enum Lang {
            case en // 英文
            case zh_CN // 简体中文
            case zh_TW // 繁体中文
        }

        var size:Size?  // 按钮的大小
        var type:Type?  // 按钮的样式类型
        var plain = false //背景色透明
        var disabled = false // 是//禁用
        var loading = false // 名称前是//带 loading 图标
        var form_type:FormType? // 用于 <form> 组件，点击分别会触发 <form> 组件的 submit/reset 事件
        var open_type: OpenType? // 微信开放能力
        var hoverClass:String? //button_hover // 指定按钮按下去的样式类。当 hover_class="none" 时，没有点击态效果
        var hover_stop_propagation = false // 指定是//阻止本节点的祖先节点出现点击态
        var hover_start_time:Int?  // 按住后多久出现点击态，单位毫秒
        var hover_stay_time:Int?  // 手指松开后点击态保留时间，单位毫秒
        var lang:Lang?// en // 指定返回用户信息的语言，zh_CN 简体中文，zh_TW 繁体中文，en 英文。
        var session_from:String? // 会话来源，open_type="contact"时有效
        var send_message_title:String? // 当前标题 // 会话内消息卡片标题，open_type="contact"时有效
        var send_message_path:String? // 当前分享路径 // 会话内消息卡片点击跳转小程序路径，open_type="contact"时有效
        var send_message_img:String? //截图 // 会话内消息卡片图片，open_type="contact"时有效
        var app_parameter:String? // 打开 APP 时，向 APP 传递的参数，open_type=launchApp时有效
        var show_message_card = false // 是//显示会话内消息卡片，设置此参数为 true，用户进入客服会话会在右下角显示"可能要发送的小程序"提示，用户点击后可以快速发送小程序消息，open_type="contact"时有效
        var bindgetuserinfo:Event? // 用户点击该按钮时，会返回获取到的用户信息，回调的detail数据与wx.getUserInfo返回的一致，open_type="getUserInfo"时有效
        var bindcontact:Event? // 客服消息回调，open_type="contact"时有效
        var bindgetphonenumber:Event? // 获取用户手机号回调，open_type=getPhoneNumber时有效
        var binderror:Event? // 当使用开放能力时，发生错误的回调，open_type=launchApp时有效
        var bindopensetting:Event? // 在打开授权设置页后回调，open_type=openSetting时有效
        var bindlaunchapp:Event? // 打开 APP 成功的回调，open_type=launchApp时有效

    }
    //多选项目
    class checkbox: NSObject {
        var value:String // <checkbox>标识，选中时触发<checkbox_group>的 change 事件，并携带 <checkbox> 的 value
        var disabled = false // 是//禁用
        var checked = false // 当前是//选中，可用来设置默认选中
        var color:UIColor? # // checkbox的颜色，同css的color
    }
    //多项选择器
    class checkboxGroup: NSObject {
        var bindchange: Event?
    }
    //表单
    class form: NSObject {
        var report_submit = false // 是//返回 formId 用于发送模板消息
        var report_submit_timeout: Int?//number 0 // 等待一段时间（毫秒数）以确认 formId 是//生效。如果未指定这个参数，formId 有很小的概率是无效的（如遇到网络失败的情况）。指定这个参数将可以检测 formId 是//有效，以这个参数的时间作为这项检测的超时时间。如果失败，将返回 requestFormId:fail 开头的 formId
        var bindsubmit:Event? // 携带 form 中的数据触发 submit 事件，event.detail = {value: {'name': 'value'} , formId: ''}
        var bindreset:Event? // 表单重置时会触发 reset 事件

    }
    //输入框
    class input: NSObject {
        enum Type {
            case text // 文本输入键盘
            case number // 数字输入键盘
            case idcard // 身份证输入键盘
            case digit // 带小数点的数字键盘
        }
        enum ConfirmType {
            case send // 右下角按钮为“发送”
            case search // 右下角按钮为“搜索”
            case next // 右下角按钮为“下一个”
            case go //右下角按钮为“前往”
            case done // 右下角按钮为“完成”
        }
        var value:String? 是 输入框的初始内容
        var type:String? text // input 的类型
        var password = false // 是//是密码类型
        var placeholder:String? // 输入框为空时占位符
        var placeholder_style:String? // 指定 placeholder 的样式
        var placeholder_class:String?// input_placeholder // 指定 placeholder 的样式类
        var disabled = false // ////禁用
        var maxlength:Int? 140 // 最大输入长度，设置为 _1 的时候不限制最大长度
        var cursor_spacing:Int? 0 // 指定光标与键盘的距离，取 input 距离底部的距离和 cursor_spacing 指定的距离的最小值作为光标与键盘的距离
        var auto_focus = false // (即将废弃，请直接使用 focus )自动聚焦，拉起键盘
        var focus = false // 获取焦点
        var confirm_type:String? done // 设置键盘右下角按钮的文字，仅在type='text'时生效
        var confirm_hold:String? false // 点击键盘右下角按钮时////保持键盘不收起
        var cursor:Float? // 指定focus时的光标位置
        var selection_start:Float? _1 // 光标起始位置，自动聚集时有效，需与selection_end搭配使用
        var selection_end:Float? _1 // 光标结束位置，自动聚集时有效，需与selection_start搭配使用
        var adjust_position = true // 键盘弹起时，////自动上推页面
        var bindinput:Event? // 键盘输入时触发，event.detail = {value, cursor, keyCode}，keyCode 为键值， 起支持，处理函数可以直接 return 一个字符串，将替换输入框的内容。
        var bindfocus:Event? // 输入框聚焦时触发，event.detail = { value, height }，height 为键盘高度，在基础库  起支持
        var bindblur:Event? // 输入框失去焦点时触发，event.detail = {value: value}
        var bindconfirm:Event? // 点击完成按钮时触发，event.detail = {value: value}


    }
    //用来改进表单组件的可用性
    class label: NSObject {
        var `for`:String? // 绑定控件的 id

    }
    //从底部弹起的滚动选择器
    class picker: NSObject {
        var mode string selector // 选择器类型
        var disabled boolean false // ////禁用
        var bindcancel:Event?// // 取消选择时触发
        enum mode {
            case selector// 普通选择器
            case multiSelector// 多列选择器
            case time// 时间选择器
            case date// 日期选择器
            case region// 省市区选择器
        }

        // 普通选择器：mode = selector
        var range:[String] = []// array/object array [] mode 为 selector 或 multiSelector 时，range 有效
        var range_key:String?// 当 range //一个 Object Array 时，通过 range_key 来指定 Object 中 key 的值作为选择器显示内容
        var value:Int?// 0 表示选择了 range 中的第几个（下标从 0 开始）
        var bindchange:Event?// value 改变时触发 change 事件，event.detail = {value}

        // 时间选择器：mode = time
        var value:String?// 表示选中的时间，格式为"hh:mm"
        var start:String?// 表示有效时间范围的开始，字符串格式为"hh:mm"
        var end:String?// 表示有效时间范围的结束，字符串格式为"hh:mm"
        var bindchange:Event?// value 改变时触发 change 事件，event.detail = {value}


        // 日期选择器：mode = date
        var value:String?// 0 表示选中的日期，格式为"YYYY_MM_DD"
        var start:String?// 表示有效日期范围的开始，字符串格式为"YYYY_MM_DD"
        var end:String?// 表示有效日期范围的结束，字符串格式为"YYYY_MM_DD"
        var fields:String?// day 有效值 year,month,day，表示选择器的粒度
        var bindchange:Event?// value 改变时触发 change 事件，event.detail = {value}
        enum fields {
            case year// 选择器粒度为年
            case month// 选择器粒度为月份
            case day// 选择器粒度为天
        }
        // 省市区选择器：mode = region

        var value:[String] = []// array [] 表示选中的省市区，默认选中每一列的第一个值
        var custom_item:String?// 可为每一列的顶部添加一个自定义的项
        var bindchange:Event?// value 改变时触发 change 事件，event.detail = {value, code, postcode}，其中字段 code //统计用区划代码，postcode 是邮政编码


    }
    //嵌入页面的滚动选择器
    class pickerView: NSObject {
        var value:[Int] = []// Array.<number> // 数组中的数字依次表示 picker_view 内的 picker_view_column 选择的第几项（下标从 0 开始），数字大于 picker_view_column 可选项长度时，选择最后一项。
        var indicator_style:String?// // 设置选择器中间选中框的样式
        var indicator_class:String?// // 设置选择器中间选中框的类名
        var mask_style:String?// // 设置蒙层的样式
        var mask_class:String?// // 设置蒙层的类名
        var bindchange:Event?// // 滚动选择时触发change事件，event.detail = {value}；value为数组，表示 picker_view 内的 picker_view_column 当前选择的是第几项（下标从 0 开始）
        var bindpickstart:Event?// // 当滚动选择开始时候触发事件
        var bindpickend:Event?// // 当滚动选择结束时候触发事件

    }
    //滚动选择器子项
    class pickerViewColumn: NSObject {

    }
    //单选项目
    class radio: NSObject {
        var value:String?// // <radio> 标识。当该<radio> 选中时，<radio_group> 的 change 事件会携带<radio>的value
        var checked = false // 当前是//选中
        var disabled = false // 是//禁用
        var color:String?// #09BB07 // radio的颜色，同css的color

    }
    //单项选择器
    class radioGroup: NSObject {
        var bindchange
    }
    //滑动选择器
    class slider: NSObject {
        var min:Float?// 0 // 最小值
        var max:Float?// 100 // 最大值
        var step:Float?// 1 // 步长，取值必须大于 0，并且可被(max _ min)整除
        var disabled = false // 是//禁用
        var value:Float?// 0 // 当前取值
        var color:UIColor?// #e9e9e9 // 背景条的颜色（请使用 backgroundColor）
        var selected_color:UIColor?// #1aad19 // 已选择的颜色（请使用 activeColor）
        var activeColor:UIColor?// #1aad19 // 已选择的颜色
        var backgroundColor:UIColor?//// #e9e9e9 // 背景条的颜色
        var block_size:Float?// 28 // 滑块的大小，取值范围为 12 _ 28
        var block_color:UIColor?// #ffffff // 滑块的颜色
        var show_value = false // 是//显示当前 value
        var bindchange:Event?// // 完成一次拖动后触发的事件，event.detail = {value}
        var bindchanging:Event?// // 拖动过程中触发的事件，event.detail = {value}

    }
    //开关选择器
    class switchwx: NSObject {
        var checked = false // 是//选中
        var disabled = false // 是//禁用
        var type:String?// switch // 样式，有效值：switch, checkbox
        var colo:UIColor?// #04BE02 // switch 的颜色，同 css 的 color
        var bindchange: Event?
    }
    //多行输入框
    class textarea: NSObject {
        var value:String?// // 输入框的内容
        var placeholder:String?// // 输入框为空时占位符
        var placeholder_style:String?// // 指定 placeholder 的样式，目前仅支持color,font_size和font_weight
        var placeholder_class:String?// textarea_placeholder // 指定 placeholder 的样式类
        var disabled = false // 是//禁用
        var maxlength number 140 // 最大输入长度，设置为 _1 的时候不限制最大长度
        var auto_focus = false // 自动聚焦，拉起键盘。
        var focus = false // 获取焦点
        var auto_height = false // 是//自动增高，设置auto_height时，style.height不生效
        var fixed = false // 如果 textarea 是在一个 position:fixed 的区域，需要显示指定属性 fixed 为 true
        var cursor_spacing:Int?// 0 // 指定光标与键盘的距离。取textarea距离底部的距离和cursor_spacing指定的距离的最小值作为光标与键盘的距离
        var cursor number _1 // 指定focus时的光标位置
        var show_confirm_bar = true // 是//显示键盘上方带有”完成“按钮那一栏
        var selection_start:Int?// _1 // 光标起始位置，自动聚集时有效，需与selection_end搭配使用
        var selection_end:Int?// _1 // 光标结束位置，自动聚集时有效，需与selection_start搭配使用
        var adjust_position = true // 键盘弹起时，是//自动上推页面
        var bindfocus:Event?// // 输入框聚焦时触发，event.detail = { value, height }，height 为键盘高度，在基础库  起支持
        var bindblur:Event?// // 输入框失去焦点时触发，event.detail = {value, cursor}
        var bindlinechange:Event?// // 输入框行数变化时调用，event.detail = {height: 0, heightRpx: 0, lineCount: 0}
        var bindinput:Event?// // 当键盘输入时，触发 input 事件，event.detail = {value, cursor, keyCode}，keyCode 为键值，目前工具还不支持返回keyCode参数。bindinput 处理函数的返回值并不会反映到 textarea 上
        var bindconfirm:Event?// // 点击完成时， 触发 confirm 事件，event.detail = {value: value}

    }
}

/*
 导航
 */
class Navi: NSObject {
    //仅在插件中有效，用于跳转到插件功能页
    class functionalPageNavigator: NSObject {
        enum version {
            case develop //开发版
            case trial //体验版
            case release // 正式版
        }
        enum name {
            case loginAndGetUserInfo // 用户信息功能页
            case requestPayment //支付功能页
        }
        var version: version? //string release // 跳转到的小程序版本，线上版本必须设置为 release
        var name: name? // string // 要跳转到的功能页
        var args:Any?// object // 功能页参数，参数格式与具体功能页相关
        var bindsuccess:Event?//r // 功能页返回，且操作成功时触发， detail 格式与具体功能页相关
        var bindfail:Event?//r // 功能页返回，且操作失败时触发， detail 格式与具体功能页相关


    }
    // 页面链接
    class navigator: NSObject {
        var target:String?// self // 在哪个目标上发生跳转，默认当前小程序
        var url:String?// string // 当前小程序内的跳转链接
        var open_type:String?// string navigate // 跳转方式
        var delta:Float?// number 1 // 当 open_type 为 'navigateBack' 时有效，表示回退的层数
        var app_id:String?// // 当target="miniProgram"时有效，要打开的小程序 appId
        var path:String?// // 当target="miniProgram"时有效，打开的页面路径，如果为空则打开首页
        var extra_data:Any?// // 当target="miniProgram"时有效，需要传递给目标小程序的数据，目标小程序可在 App.onLaunch()，App.onShow() 中获取到这份数据。详情
        var version:String?// release // 当target="miniProgram"时有效，要打开的小程序版本
        var hoverClass:String?// navigator_hover // 指定点击时的样式类，当hover_class="none"时，没有点击态效果
        var hover_stop_propagation = false // 指定是//阻止本节点的祖先节点出现点击态
        var hover_start_time:Float?// 50 // 按住后多久出现点击态，单位毫秒
        var hover_stay_time:Float??// 600 // 手指松开后点击态保留时间，单位毫秒
        var bindsuccess:String?// // 当target="miniProgram"时有效，跳转小程序成功
        var bindfail:String?// // 当target="miniProgram"时有效，跳转小程序失败
        var bindcomplete:String?// // 当target="miniProgram"时有效，跳转小程序完成
        enum target {
            case `self`// 当前小程序
            case miniProgram // 其它小程序
        }
        enum open_type {
        case navigate // 对应 wx.navigateTo 或 wx.navigateToMiniProgram 的功能
        case redirect // 对应 wx.redirectTo 的功能
        case switchTab // 对应 wx.switchTab 的功能
        case reLaunch // 对应 wx.reLaunch 的功能
        case navigateBack // 对应 wx.navigateBack 的功能
        case exit // 退出小程序，target="miniProgram"时生效
        }
        enum version {
            case develop // 开发版
            case trial // 体验版
            case release // 正式版，仅在当前小程序为开发版或体验版时此参数有效；如果当前小程序是正式版，则打开的小程序必定是正式版。
        }
    }
}
/*
 媒体组件
 */
class Media: NSObject {
    //音频
    class audio: NSObject {
        var id:String?// // audio 组件的唯一标识符
        var src:String?// // 要播放音频的资源地址
        var loop = false // 是//循环播放
        var controls = false // 是//显示默认控件
        var poster:String?// // 默认控件上的音频封面的图片资源地址，如果 controls 属性值为 false 则设置 poster 无效
        var name:String?// 未知音频 // 默认控件上的音频名字，如果 controls 属性值为 false 则设置 name 无效
        var author:String?// 未知作者 // 默认控件上的作者名字，如果 controls 属性值为 false 则设置 author 无效
        var binderror:Event?// // 当发生错误时触发 error 事件，detail = {errMsg:MediaError.code}
        var bindplay:Event?// // 当开始/继续播放时触发play事件
        var bindpause:Event?// // 当暂停播放时触发 pause 事件
        var bindtimeupdate:Event?// // 当播放进度改变时触发 timeupdate 事件，detail = {currentTime, duration}
        var bindended:Event?// // 当播放到末尾时触发 ended 事件

    }//系统相机
    class camera: NSObject {
        var mode:String?// normal // 应用模式
        var device_position:String?// back // 摄像头朝向
        var flash:String?// auto // 闪光灯，值为auto, on, off
        var bindstop:Event?// // 摄像头在非正常终止时触发，如退出后台等情况
        var binderror:Event?// // 用户不允许使用摄像头时触发
        var bindscancode:Event?// // 在扫码识别成功时触发，仅在 mode="scanCode" 时生效
        enum mode {
            case normal // 相机模式
            case scanCode // 扫码模式
        }
        enum device_position {
        case front //前置
        case back //后置
        }
        enum flash {
            case auto //自动
            case on //打开
            case off // 关闭
        }
    }
    //图片
    class image: NSObject {
        var src:String? // 图片资源地址
        var mode:mode?// scaleToFill // 图片裁剪、缩放的模式
        var lazy_load = false // 图片懒加载，在即将进入一定范围（上下三屏）时才开始加载
        var binderror:Event?// // 当错误发生时触发，，event.detail = {errMsg}
        var bindload:Event?// // 当图片载入完毕时触发，event.detail = {height, width}
        enum mode {
            case scaleToFill // 缩放模式，不保持纵横比缩放图片，使图片的宽高完全拉伸至填满 image 元素
            case aspectFit // 缩放模式，保持纵横比缩放图片，使图片的长边能完全显示出来。也就是说，可以完整地将图片显示出来。
            case aspectFill // 缩放模式，保持纵横比缩放图片，只保证图片的短边能完全显示出来。也就是说，图片通常只在水平或垂直方向是完整的，另一个方向将会发生截取。
            case widthFix // 缩放模式，宽度不变，高度自动变化，保持原图宽高比不变
            case top // 裁剪模式，不缩放图片，只显示图片的顶部区域
            case bottom // 裁剪模式，不缩放图片，只显示图片的底部区域
            case center //裁剪模式，不缩放图片，只显示图片的中间区域
            case left // 裁剪模式，不缩放图片，只显示图片的左边区域
            case right // 裁剪模式，不缩放图片，只显示图片的右边区域
            case topLeft // 裁剪模式，不缩放图片，只显示图片的左上边区域
            case topRight // 裁剪模式，不缩放图片，只显示图片的右上边区域
            case bottomLeft // 裁剪模式，不缩放图片，只显示图片的左下边区域
            case bottomRight //裁剪模式，不缩放图片，只显示图片的右下边区域
        }
    }
    //实时音视频播放
    class livePlayer: NSObject {
        var src:String?// // 音视频地址。目前仅支持 flv, rtmp 格式
        var mode:String?// live // 模式
        var autoplay = false // 自动播放
        var muted = false // 是//静音
        var orientation:String?// vertical // 画面方向
        var object_fit:String?// contain // 填充模式，可选值有 contain，fillCrop
        var background_mute = false // 进入后台时是//静音（已废弃，默认退台静音）
        var min_cache:Float?// 1 // 最小缓冲区，单位s（RTC 模式推荐 0.2s）
        var max_cache:Float?// 3 // 最大缓冲区，单位s（RTC 模式推荐 0.8s）
        var sound_mode:String?// speaker // 声音输出方式
        var auto_pause_if_navigate = true // 当跳转到其它小程序页面时，是//自动暂停本页面的实时音视频播放
        var auto_pause_if_open_native = true // 当跳转到其它微信原生页面时，是//自动暂停本页面的实时音视频播放
        var bindstatechange:Event?// // 播放状态变化事件，detail = {code}
        var bindfullscreenchange:Event?// // 全屏变化事件，detail = {direction, fullScreen}
        var bindnetstatus:Event?// // 网络状态通知，detail = {info}
        enum mode {
            case live // 直播
            case RTC // 实时通话，该模式时延更低
        }
        enum orientation {
            case vertical // 竖直
            case horizontal // 水平
        }
        enum sound_mode {
            case speaker //扬声器
            case ear //听筒
        }
        var videoBitrate:Float? //当前视频编/码器输出的比特率，单位 kbps
        var audioBitrate:Float? // //当前音频编/码器输出的比特率，单位 kbps
        var videoFPS:Float? // 当前视频帧率
        var videoGOP:Float? // 当前视频 GOP,也就是每两个关键帧(I帧)间隔时长，单位 s
        var netSpeed:Float? //当前的发送/接收速度
        var netJitter:Float? // 网络抖动情况，抖动越大，网络越不稳定
        var videoWidth:Float? // 视频画面的宽度
        var videoHeight:Float? // 视频画面的高度

    }
    //实时音视频录制
    class livePusher: NSObject {
        var url:Float? // // 推流地址。目前仅支持 flv, rtmp 格式
        var mode:Float? // RTC // SD（标清）, HD（高清）, FHD（超清）, RTC（实时通话）
        var autopush = false // 自动推流
        var muted = false // 是//静音
        var enable_camera = true // 开启摄像头
        var auto_focus true // 自动聚集
        var orientation:Float? // vertical // 画面方向
        var beauty:Int?// 0 // 美颜，取值范围 0_9 ，0 表示关闭
        var whiteness:Int?// 0 // 美白，取值范围 0_9 ，0 表示关闭
        var aspect:Float? // 9:16 // 宽高比，可选值有 3:4, 9:16
        var min_bitrate:Int? // 200 // 最小码率
        var max_bitrate:Int?// 1000 // 最大码率
        var waiting_image:Float? // // 进入后台时推流的等待画面
        var waiting_image_hash:Float? // // 等待画面资源的MD5值
        var zoom = false // 调整焦距
        var device_position:Float? // front // 前置或后置，值为front, back
        var background_mute = false // 进入后台时是//静音
        var bindstatechange:Event?// // 状态变化事件，detail = {code}
        var bindnetstatus:Event?// // 网络状态通知，detail = {info}
        var binderror:Event?// // 渲染错误事件，detail = {errMsg, errCode} 1.7.4
        var bindbgmstart:Event?// // 背景音开始播放时触发
        var bindbgmprogress:Event?// // 背景音进度变化时触发，detail = {progress, duration}
        var bindbgmcomplete:Event?// // 背景音播放完成时触发
        enum orientation {
            case vertical // 竖直
            case horizontal // 水平
        }

    }
    //视频
    class video: NSObject {
        var src:Float? // 是 要播放视频的资源地址，支持云文件ID（）
        var duration:Int? // 指定视频时长
        var controls = true // 是//显示默认播放控件（播放/暂停按钮、播放进度、时间）
        var danmu_list:[String] = []//.<object> // 弹幕列表
        var danmu_btn = false // 是//显示弹幕按钮，只在初始化时有效，不能动态变更
        var enable_danmu = false // 是//展示弹幕，只在初始化时有效，不能动态变更
        var autoplay = false // 是//自动播放
        var loop = false // 是//循环播放
        var muted = false // 是//静音播放
        var initial_time:Int?// 0 // 指定视频初始播放位置
        var page_gesture = false // 在非全屏模式下，是//开启亮度与音量调节手势（废弃，见 vslide_gesture）
        var direction:Int? // 设置全屏时视频的方向，不指定则根据宽高比自动判断
        var show_progress = true // 若不设置，宽度大于240时才会显示
        var show_fullscreen_btn = true // 是//显示全屏按钮
        var show_play_btn = true // 是//显示视频底部控制栏的播放按钮
        var show_center_play_btn = true // 是//显示视频中间的播放按钮
        var enable_progress_gesture = true // 是//开启控制进度的手势
        var object_fit:String? // contain // 当视频大小与 video 容器大小不一致时，视频的表现形式
        var poster:String? // // 视频封面的图片网络资源地址或云文件ID（）。若 controls 属性值为 false 则设置 poster 无效
        var show_mute_btn = false // 是//显示静音按钮
        var title:String? // // 视频的标题，全屏时在顶部展示
        var play_btn_position:String? // bottom // 播放按钮的位置
        var enable_play_gesture = false // 是//开启播放手势，即双击切换播放/暂停
        var auto_pause_if_navigate = true // 当跳转到其它小程序页面时，是//自动暂停本页面的视频
        var auto_pause_if_open_native = true // 当跳转到其它微信原生页面时，是//自动暂停本页面的视频
        var vslide_gesture boolean false // 在非全屏模式下，是//开启亮度与音量调节手势（同 page_gesture）
        var vslide_gesture_in_fullscreen = true // 在全屏模式下，是//开启亮度与音量调节手势
        var bindplay:Event?// // 当开始/继续播放时触发play事件
        var bindpause:Event?// // 当暂停播放时触发 pause 事件 var
        var bindended:Event?// // 当播放到末尾时触发 ended 事件
        var bindtimeupdate:Event?// // 播放进度变化时触发，event.detail = {currentTime, duration} 。触发频率 250ms 一次
        var bindfullscreenchange:Event?// // 视频进入和退出全屏时触发，event.detail = {fullScreen, direction}，direction 有效值为 vertical 或 horizontal
        var bindwaiting:Event?// // 视频出现缓冲时触发
        var binderror:Event?// // 视频播放出错时触发
        var bindprogress:Event?// // 加载进度变化时触发，只支持一段加载。event.detail = {buffered}，百分比
        enum direction {
            case 0 //正常竖向
            case 90 // 屏幕逆时针90度
            case _90 //屏幕顺时针90度
        }
        enum object_fit {
        case contain // 包含
        case fill //填充
        case cover //覆盖
        }
        enum play_btn_position {
        case bottom // controls bar上
        case center //视频中间
        }

    }

}
/*
 地图
 */
class Map: NSObject {
    var longitude:Float? // // 中心经度
    var latitude:Float? // // 中心纬度
    var scale:Float? // 16 // 缩放级别，取值范围为5_18
    var markers:[Any] = []// Array.<marker> // 标记点
    var covers:[Any] = []// Array.<cover> // 即将移除，请使用 markers
    var polyline:[Any] = []// Array.<polyline> // 路线
    var circles:[Any] = []// Array.<circle> // 圆
    var controls:[Any] = []// Array.<control> // 控件（即将废弃，建议使用 cover_view 代替）
    var include_points:[Any] = []// Array.<point> // 缩放视野以包含所有给定的坐标点
    var show_location = false // 显示带有方向的当前定位点
    var polygons:[Any] = []// Array.<polygon> // 多边形
    var subkey:String? // // 个性化地图使用的key，仅初始化地图时有效
    var enable_3D = false // 展示3D楼块(工具暂不支持）
    var show_compass = false // 显示指南针
    var enable_overlooking = false // 开启俯视
    var enable_zoom = true // 是//支持缩放
    var enable_scroll = true // 是//支持拖动
    var enable_rotate = false // 是//支持旋转
    var bindtap:Event?// // 点击地图时触发
    var bindmarkertap:Event?// // 点击标记点时触发，会返回marker的id
    var bindcontroltap:Event?// // 点击控件时触发，会返回control的id
    var bindcallouttap:Event?// // 点击标记点对应的气泡时触发，会返回marker的id
    var bindupdated:Event?// // 在地图渲染更新完成时触发
    var bindregionchange:Event?// // 视野发生变化时触发
    var bindpoitap:Event?// // 点击地图poi点时触发
    var marker: String?//标记点用于在地图上显示标记的位置
    var id: Int? // 标记点 id number // marker 点击事件回调会返回此 id。建议为每个 marker 设置上 number 类型 id，保证更新 marker 时有更好的性能。
    var latitude:Double?//纬度 number // 浮点数，范围 _90 ~ 90
    var longitude:Double?// 经度 number // 浮点数，范围 _180 ~ 180
    var title:String?// 标注点名 string //
    var zIndex:Int?// 显示层级 number //
    var iconPath:String?// 显示的图标 string // 项目目录下的图片路径，支持相对路径写法，以'/'开头则表示相对小程序根目录；也支持临时路径和网络图片（）
    var rotate:Int?// 旋转角度 number // 顺时针旋转的角度，范围 0 ~ 360，默认为 0
    var alpha:Int?//标注的透明度 number // 默认 1，无透明，范围 0 ~ 1
    var width:Float?// 标注图标宽度 number/string // 默认为图片实际宽度
    var height:Float?// 标注图标高度 number/string // 默认为图片实际高度
    var callout:Any? //自定义标记点上方的气泡窗口 Object // 支持的属性见下表，可识别换行符。
    var label:Any?// 为标记点旁边增加标签 Object // 支持的属性见下表，可识别换行符。
    var anchor:Any?// 经纬度在标注图标的锚点，默认底边中点 Object // {x, y}，x 表示横向(0_1)，y 表示竖向(0_1)。{x: .5, y: 1} 表示底边中点
    var aria_label:String?// 无障碍访问，（属性）元素的额外描述 string //
    var marker: Any?// 上的气泡 callout
    // 属性 说明 类型 最低版本
    var content: String? // 文本 string
    var color: String? // 文本颜色 string
    var fontSize: Int? // 文字大小 number
    var borderRadius: Float? // 边框圆角 number
    var borderWidth: Float? // 边框宽度 number
    var borderColor: String? // 边框颜色 string
    var bgColor: String? // 背景色 string
    var padding: Int? // 文本边缘留白 number
    var display: String? // 'BYCLICK':点击显示; 'ALWAYS':常显 string
    var textAlign: String? // 文本对齐方式。有效值: left, right, center string
    var marker: label? //上的气泡 label
    // 属性 说明 类型 最低版本
    var content: String? // 文本 string
    var color: String? // 文本颜色 string
    var fontSize: String? // 文字大小 number
    var x: String? // label的坐标（废弃） number
    var y: String? // label的坐标（废弃） number
    var anchorX: String? // label的坐标，原点是 marker 对应的经纬度 number
    var anchorY: String? // label的坐标，原点是 marker 对应的经纬度 number
    var borderWidth: String? // 边框宽度 number
    var borderColor: String? // 边框颜色 string
    var borderRadius: String? // 边框圆角 number
    var bgColor: String? // 背景色 string
    var padding: String? // 文本边缘留白 number
    var textAlign: String? // 文本对齐方式。有效值: left, right, center string
    var polyline: String? //指定一系列坐标点，从数组第一项连线至最后一项

    // 属性 说明 类型 必填 备注 最低版本
    var points: String? // 经纬度数组 array 是 [{latitude: 0, longitude: 0}]
    var color: String? // 线的颜色 string // 十六进制
    var width: String? // 线的宽度 number //
    var dottedLine: String? // 是//虚线 boolean // 默认 false
    var arrowLine: String? // 带箭头的线 boolean // 默认 false，开发者工具暂不支持该属性
    var arrowIconPath: String? // 更换箭头图标 string // 在 arrowLine 为 true 时生效
    var borderColor: String? // 线的边框颜色 string //
    var borderWidth: String? // 线的厚度 number //
    var polygon: String? //指定一系列坐标点，根据 points 坐标数据生成闭合多边形

    // 属性 说明 类型 必填 备注 最低版本
    var points: String? // 经纬度数组 array 是 [{latitude: 0, longitude: 0}]
    var strokeWidth: String? // 描边的宽度 number //
    var strokeColor: String? // 描边的颜色 string // 十六进制
    var fillColor: String? // 填充颜色 string // 十六进制
    var zIndex: String? // 设置多边形Z轴数值 number //
    var circle: String? //在地图上显示圆

    // 属性 说明 类型 必填 备注
    var latitude: String? // 纬度 number 是 浮点数，范围 _90 ~ 90
    var longitude: String? // 经度 number 是 浮点数，范围 _180 ~ 180
    var color: String? // 描边的颜色 string // 十六进制
    var fillColor: String? // 填充颜色 string // 十六进制
    var radius: String? // 半径 number 是
    var strokeWidth: String? // 描边的宽度 number //
    var control: String? //在地图上显示控件，控件不随着地图移动。即将废弃，请使用 cover_view

    // 属性 说明 类型 必填 备注
    var id: String? // 控件id number // 在控件点击事件回调会返回此id
    var position: String? // 控件在地图的位置 object 是 控件相对地图位置
    var iconPath: String? // 显示的图标 string 是 项目目录下的图片路径，支持相对路径写法，以'/'开头则表示相对小程序根目录；也支持临时路径
    var clickable: String? // 是//可点击 boolean // 默认不可点击
    var position: String? //
    // 属性 说明 类型 必填 备注
    var left: String? // 距离地图的左边界多远 number // 默认为0
    var top: String? //距离地图的上边界多远 number // 默认为0
    var width: String? // 控件宽度 number // 默认为图片宽度
    var height: String? // 控件高度 number // 默认为图片高度
    var bindregionchange: String? //返回值
    // 属性 说明 类型 备注
    var type: String? // 视野变化开始、结束时触发 string 视野变化开始为begin，结束为end
    var causedBy: String? // 导致视野变化的原因 string 拖动地图导致(drag)、缩放导致(scale)、调用接口导致(update)

}
/*
 画布
 */
class Canvas: NSObject {
    var canvas_id:String? // 是 canvas 组件的唯一标识符
    var disable_scroll = false // 当在 canvas 中移动时且有绑定手势事件时，禁止屏幕滚动以及下拉刷新
    var bindtouchstart:Event?// // 手指触摸动作开始
    var bindtouchmove:Event?// // 手指触摸后移动
    var bindtouchend:Event?// // 手指触摸动作结束
    var bindtouchcancel:Event?// // 手指触摸动作被打断，如来电提醒，弹窗
    var bindlongtap:Event?// // 手指长按 500ms 之后触发，触发了长按事件后进行移动不会触发屏幕的滚动
    var binderror:Event?// // 当发生错误时触发 error 事件，detail = {errMsg}

}


