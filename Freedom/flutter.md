# Flutter 项目

## 1 环境准备
1. [下载Android Studio  在其上安装flutter插件和Dart插件。](https://developer.android.com/studio)
2. [下载flutterSDK，解压、安装、配置环境。](https://flutter.dev/docs/get-started/install/macos)
3. AndroidStudio/File/New/NewFlutterProject/Run
- [flutter基础](https://www.jianshu.com/p/f8dce248a474)
- [通过简写自动生成代码块模版](https://www.jianshu.com/p/4184745d6983)
- [常用库与命令](https://github.com/AweiLoveAndroid/Flutter-learning)
``` bash
 cd ~/Documents
 url=https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.12.13+hotfix.8-stable.zip
 wget $url -o flutter_sdk.zip
 unzip flutter_sdk.zip
 # git clone https://github.com/flutter/flutter.git -b stable
 export PATH=$PATH:`pwd`/flutter/bin
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.6.jdk/Contents/Home
 echo $PATH
 which flutter
 flutter precache
 sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
 sudo xcodebuild -runFirstLaunch
 open -a Simulator
 flutter doctor
 flutter create my_app
 cd my_app
 flutter run
 sudo gem install cocoapods
 pod setup
 ```

## 2 代码实验
 1. Flutter 可以在 Android 和 iOS 系统里自动适应不同的 UI 体系
 2. Flutter 工程/项目的基本结构
 3. 查找和使用[packages](https://pub.dev/flutter/)来扩展功能pubspec.yaml/Packages get
 4. 熟悉IDK界面与功能的使用，热重载加快开发周期⚡️
 5. 断点调试点击查看对象的所有属性信息
 6. 修改应用的名称 android/app/src/main/AndroidManifest.xml  ios/Runner/info.plist
 7. Dart语法尝试 var {} [] extends implements with 代码格式化：右键ReformatCode
 8. [替换应用图标](https://flutterchina.club/assets-and-images/#更新app-图标)
 - Android: android/app/src/main/res/ic_launcher.png   launch_background.xml
 - ios: ios/Runner/Assets/AppIcon   LaunchImage

## 3 开发框架搭建
 1. 创建目录结构
 2. 导航到第二个页面
 3. 界面传值 https://www.jianshu.com/p/e00071c582a3
 4. 如何创建一个无限的、延迟加载的列表
 5. 在 stateful widget 上添加交互
 ```
 Navigator.push(context, new MaterialPageRoute(builder: (_)=> new Me())).then((name){
        print('这是从上个界面返回的值$name');
 });
 Navigator.pop(context, '返回上个界面的值');
 Navigator.of(context).pop('返回上个界面传递的值');
```
```
├── android         # 安卓包忽略
├── assets          # 资源文件 文件：json，image，…………
├── build           # 编译结果忽略
├── ios             # iOS包忽略
├── lib             # 源代码文件夹
│   ├── base        # 基本类集合
│   ├── config      # 配置集合 配置全部路由和全局样式
│   ├── custom      # 用户自定义视图
│   ├── main        # 主项目结构
│   │   ├── find
│   │   ├── friends
│   │   ├── home      
│   │   └── me
│   ├── main.dart   # 项目启动入口文件
│   ├── models      # 模型集合
│   └── utils       # 工具类集合
└── pubspec.yaml    # 第三方库依赖
└── .gitignore      # git忽略文件
```


## 5 语言学习

### 注释:
 1. 单行 //
 2. 多行 /**/
### 关键字
- 33个保留字
```
if  super  do switch  assert  else    in  this    enum    typedef
is  throw   true    break   new try     case    extends     null
catch   var     class   false    void    const  final   rethrow
while   continue        finally return      with    for default
```
- 17个内置标志符
```
abstract deferred  as   dynamic  covariant   part  set  static operator 
export external factory get  implements  import  typedef library         
```
- 6个支持异步功能的关键字
```
async    async*    await    sync*   yield    yield*
```
- 25个Dart特有的关键字
```
deferred    as      assert  dynamic     sync*   in      is
await       export      library     external    async   async*
typedef     factory     operator    var const final set     yield       
part    const       rethrow     covariant   get     yield*

```
### 数据类型
 ```
 int double String bool List Set Map Runes
 Map map = {1: 'helium',2: 'neon'};
 List list = [1,2,3];
 Set set = {1,2,3};
 ```
### 操作符:
 1. 算术运算符：+ - * / ~/ %
 2. 等式和关系运算符:== !=  > < >= <=  += -+ /= *=
 3. 类型测试操作符 as  is   is!
 5. 逻辑运算符: && || !  &  |  ^  <<  >>
 6. 操作符 ++  --
 7. 条件表达式 ? :   ??   ?:
 8. 级联符号(..)

### 控制流:
 1. if else
 2. for  for in  .forEach
 3. while / do-while
 4. break and continue
 5. switch and case
 6. asset

### 函数:
```
    String test(String name) => 'the result is $name'
    void test({this.name,this.age}) {};
    static say(String name,[int age, bool sex]) {};
    test(var x, var y) : assert(x >= 0) {}
    // 闭包
    typedef TypedefFuns = int Function(Object a, Object b);
    void main() {
        var result = test();
        print(result(2.0));//结果为：12.56
    }
    Function test(){
        const PI = 3.14;
        return (double r) => r * r * PI;
    }
```
### 异常处理:
 ```try throw catch finally```

### 类:
    extends   implements  with  @override  
```
    class Student {
        var _name = ""; // _ 代表私有
        String na, uu;
        //  Student(this.name, this.na, this.uu);
        Student({this.na,this.name,this.uu});
        Student.shared(){
            this.name = "";
            this.na = "";
            this.uu = "";
        }
    
        String printNumber(String a) {
            print(a);
            return a;
        }
        void say(String name,[String age, String uu]) {
            print(name);
        }
    }
    
    class Human {
        var age = 2;
        String test() {
            return "";
        }
        //  Human(this.age);
    }
    
    class Man extends Student with Human {
        var cs = "";
        Man.sharedd() {
            this.na = "";
            this.name = "";
            this.uu = "";
            this.cs = "";
        }
        //  Man(String name, String na, String uu) : super(name, na, uu);
        @override
        String printNumber(String a) {
            return super.printNumber(a);
        }
    
        @override
        int age;
        eat() {
            var a = this.test();
            print(a);
            var stu = Student(na: "ad", uu: "");
            stu.say('nihao','2');
        }
    }
    
    class Some extends Student implements Human {
        @override
        int age;
    
        @override
        String test() {
            // TODO: implement test
            return null;
        }
    }
```

### 泛型:
```
    abstract class Cache<T> {
        T getByKey(String key);
    }
    class Foo<T extends BaseClass> {}
    T first<T>(List<T> data) {
        T tmp = data[0];
        return tmp;
    }
    var lambda =  <T>(T thing) => thing;
    
```
### 库和可见性:
    import 'libs/mylib.dart';
    import 'libs/mylib.dart' as test3;
    import 'libs/mylib.dart' show test2;
    import 'libs/mylib.dart' hide test2;
    import 'libs/mylib.dart' deferred as tests;{
        await tests.loadLibrary();
        tests.test2();
    }

### 异步支持:
```
    Future checkVersion() async {
        var version = await lookUpVersion();
    }
    Future<String> lookUpVersion() async{
        await for (var request in requestServer) {
            handleRequest(request);
        }
        return '版本号：v1.0';
    }
    Future asyncDemo() async{
        Future<Null> future = new Future(() => null);
            await  future.then((_){
            print("then");
        }).then((){
            print("whenComplete");
        }).catchError((_){
            print("catchError");
        });
    }
```

## help
- [官方文档](https://flutterchina.club/setup-macos)
- [官方开发文档](https://flutter.cn/docs)
- [官方库](https://pub.dev/flutter/packages)
- [基础教程](https://www.jianshu.com/p/4184745d6983)
- [学习笔记](https://github.com/AweiLoveAndroid/Flutter-learning)
- [widgets](https://itsallwidgets.com)
- [项目列表](https://github.com/Solido/awesome-flutter)
- [购买的实战教程](https://study.163.com/course/courseMain.htm?courseId=1209014817)
- [Dart语法](https://www.dartlang.org/guides/language/language-tour)
- [搜索三方库](https://pub.dartlang.org/flutter/)
- [Flutter 所有布局](https://flutter.io/docs/development/ui/widgets/layout)
- [FlutterStudio](https://flutterstudio.app/)

## Flutter框架
``` swift
class MaterialApp: NSObject {
    /// 程序结构 它提供了默认的导航栏、标题和包含主屏幕 widget 树的 body 属性
    class Scaffold: NSObject {
        /// 视图
        class widget: NSObject {

        }
    }
}
/// Flutter 元素开发
class Flutter: NSObject {
    /// 图标
    class Icons: NSObject {

    }
    /// 界面
    class State<T>: NSObject {
        var value: T?
    }
    /// 视图
    class Widget: UIView {

        /// 可变视图
        class StatefulWidget: Widget {
            /// 底部TabBar
            class BottomAppBar: StatefulWidget {

            }
            /// 顶部导航栏
            class BottomNavigationBar: StatefulWidget {

            }
            /// 底部弹框
            class BottomSheet: StatefulWidget {

            }
            /// 按钮
            class RawMaterialButton: StatefulWidget {

            }
            /// 滑块
            class Slider: StatefulWidget {

            }
            /// 开关视图
            class Switch: StatefulWidget {

            }
            /// 步进视图
            class Stepper: StatefulWidget {

            }
            /// 文本输入框
            class TextField: StatefulWidget {

            }
            /// 复选框
            class Checkbox: StatefulWidget {

            }
        }


        /// 不可变视图
        class StatelessWidget: Widget {
            /// 主题风格
            class Theme: StatelessWidget {

            }
            /// 弹框
            class Dialog: StatelessWidget {

            }
            /// 图标
            class FlutterLogo: StatelessWidget {

            }
        }
    }
}
```