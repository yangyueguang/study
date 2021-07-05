
var qs = require("qs");
var toNum = function(a){
    var a=a.toString();
    //也可以这样写 var c=a.split(/\./);
    var c=a.split('.');
    var num_place=["","0","00","000","0000"],r=num_place.reverse();
    for (var i=0;i<c.length;i++){
      var len=c[i].length;
      c[i]=r[len]+c[i];
    }
    var res= c.join('');
    return res;
  };
  var versionDeal = function(version){
    let isCarry = true;
    return version.split('.').reverse().map((v) => {
      if (isCarry) {
        if (v < 9) {
          v++;
          isCarry = false;
        } else {
          v = 0;
          isCarry = true;
        }
      }
      return v;
    }).reverse().join('.');
  }
  //预览图片
  var preview = function(e) {
    let imgUrl = e.getAttribute('src'), imagesArray = [];
    imagesArray.push(imgUrl);
    // console.log(imgUrl);
  };
/**
 * 常用的工具类合并一个功能
 * */
/**
 * @desc guid生成器
 * */
let guid =  {

  /**
   * @method getGuid
   * @desc 获取一个guid
   * @return {string}
   * */
  getGuid: function() {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
      s4() + '-' + s4() + s4() + s4();
  }
}

var setCookie = function (cname, cvalue, exdays) {
  var d = new Date()
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000))
  var expires = 'expires=' + d.toUTCString()
  document.cookie = cname + '=' + cvalue + '; ' + expires
}

var getCookie = function (name) {
  var reg = new RegExp('(^| )' + name + '=([^;]*)(;|$)')
  var arr = document.cookie.match(reg)
  if (arr) {
    return unescape(arr[2])
  } else {
    return null
  }
}
/**
 * @desc 常用的校验方法
 * */
// 常用的校验
var validators = {
  /**
   *
   * @method isEmail
   * @desc isEmail 是否为Email
   * @param {String} agr1
   * @return {boolean} flag
   */
  isEmail: function (text) {
    var reg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return reg.test(text)
  },

  /**
   * @method isPassword
   * @desc isPassword 是否为合法密码，6-20位字母数字
   * @param {String} agr1
   * @return {boolean} flag
   */
  isPassword: function (text) {
    var reg = /^[a-zA-Z0-9]{6,20}$/;
    return reg.test(text);
  },

  /**
   * @method isMobile
   * @desc isMobile 是否为合法手机号
   * @param {string}  text
   * @return {boolean}
   */
  isMobile: function (text) {
    var reg = /^(1[3-8][0-9])\d{8}$/;
    return reg.test(text);
  },

  /**
   * @method isMoney
   * @desc isMobile 是否为合法手机号
   * @param {string}  text
   * @return {boolean}
   */
  isMoney:function(text){
    //  /^\d*(?:\.\d{0,2})?$/
    var reg =/^\d*(?:\.\d{0,2})?$/ ;
    return reg.test(text);
  },


  /**
   * @desc isMobile 是否为合法手机号
   * @param {string}  text
   * @return {boolean}
   */
  isChinaCharacter:function(text){
    //  /^[\u4e00-\u9fa5]{0,}$/
    var reg = /^[\u4e00-\u9fa5]{0,}$/;
    return reg.test(text);
  },

  /**
   * @method isChar
   * @desc isMobile 是否为数字
   * @param {string}  text
   * @return {boolean}
   */
  isChar:function(text){
    //  /^[a-zA-Z]*$/
    var reg = /^[a-zA-Z]*$/;
    return reg.test(text);
  },

  /**
   * @method isInt
   * @desc isMobile 是否为整数
   * @param {string}  text
   * @return {boolean}
   */
  isInt:function(text){
    //  /^0$|^[1-9]\d*$/
    var reg = /^0$|^[1-9]\d*$/ ;
    return reg.test(text);
  },
  /**
   * @method isCharNum
   * @desc isCharNum 是否为字母和数字
   * @param {string}  text
   * @return {boolean}
   */
  isCharNum:function(text){
    //  /^[a-zA-Z0-9]*$/
    var reg =  /^[a-zA-Z0-9]*$/ ;
    return reg.test(text);

  },
  /**
   * @method isIDCardVildate
   * @desc 检验18位身份证号码（15位号码可以只检测生日是否正确即可，自行解决）
   * @param  {string} idCardValue
   *   18位身份证号
   * @return {boolean} 匹配返回true 不匹配返回false
   */
  isIDCardVildate: function (cid) {
    var arrExp = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];// 加权因子
    var arrValid = [ 1, 0, "X", 9, 8, 7, 6, 5, 4, 3, 2 ];// 校验码
    var reg = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/;
    if (reg.test(cid)) {
      var sum = 0, idx;
      for (var i = 0; i < cid.length - 1; i++) {
// 对前17位数字与权值乘积求和
        sum += parseInt(cid.substr(i, 1), 10) * arrExp[i];
      }
// 计算模（固定算法）
      idx = sum % 11;
// 检验第18为是否与校验码相等
      return arrValid[idx] == cid.substr(17, 1).toUpperCase();
    } else {
      return false;
    }
  }
};
/**
 * @description 获取url 中的参数
 * @param key
 * @param url
 *
 * */
function getQueryString(key,url){
  if (!url) url = window.location.href;
  key = key.replace(/[\[\]]/g, '\\$&');
  var regex = new RegExp('[?&]' + key + '(=([^&#]*)|&|#|$)'),
    results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, ' '))
}

/**
 *
 * @desc 获取url参数
 * @param  {string} key
 * @return {object} 返回值 对象
 */
function getQueryObject(name){
  var search = location.href.split('?')[1] || ''
  var result = qs.parse(search);
  return result;
}


function isType(type) {
  return function(obj) {
    return {}.toString.call(obj) == "[object " + type + "]"
  }
}
/**
 * @method  isObject
 * @desc 判断Object 类型
 * @return {boolean}
 * */
var isObject = isType("Object")
/**
 * @method  isString
 * @desc 判断String类型
 * @return {boolean}
 * */
var isString = isType("String")
/**
 * @method  isArray
 * @desc 判断 Array 类型
 * @return {boolean}
 * */
var isArray = Array.isArray || isType("Array")
/**
 * @method  isFunction
 * @desc 判断 Function 类型
 * @return {boolean}
 * */
var isFunction = isType("Function")
/**
 * @method  isUndefined
 * @desc 判断 Undefined 类型
 * @return {boolean}
 * */
var isUndefined = isType("Undefined")
var type={
  isObject,
  isString,
  isArray,
  isFunction,
  isUndefined
};
function getTimestamp(){
  return new Date().getTime();
}

/**
 * @exports util
 * @desc 常用工具类合计
 *
 * */
export {
    /**
     * @desc cookie 设置
     * @param {string}  名称
     * @param {string} 值
     * @param {int} 时间
     * */
    setCookie,
    /**
     * @desc cookie 获取
     * @param {string}  名称
     * @return {string} 结果
     * */
    getCookie,
    guid,
    validators,
    /**
     *
     * @desc 获取url参数
     * @param  {string} key
     * @return {string || boolean} 返回值
     */
    getQueryString,
    getQueryObject,
    /**
     * @desc 生成类型判断器
     * @param {string} type
     * @return {function}
     * */
    type,

    /**
     * @desc 获取时间戳
     * @return {int}
     * */
    getTimestamp,
    toNum,
    versionDeal,
    preview
}
