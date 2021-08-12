<template>
  <div class="container" @mousedown="onmousedown" @mouseup="onmouseup" @mousemove="onmousemove">
    <h1>满屏飘舞的小图标</h1>
  </div>
</template>

<script>
export default {
  name: "flyicons",
  data() {
    return {
      oTimer: null,
      iLeft: 0,
      iTop: 0,
      iWidth: 20,
      iHeight: 20,
      is_touched: false
    }
  },
  onLoad(options) {},
  methods: {
    toBrowser() {
      var browser = navigator.appName;
      var b_version = navigator.appVersion;
      if (browser == "Netscape") {
        return true;
      }
      var version = b_version.split(";");
      var trim_Version = version[1].replace(/[ ]/g, "");
      if (browser == "Microsoft Internet Explorer" && (trim_Version == "MSIE7.0" || trim_Version == "MSIE6.0" || trim_Version == "MSIE8.0")) {
        return false;
      } else {
        return true;
      }
    },
    starMove(obj, target, iType, fnEnd, iDate) {
      if (obj.timer) {
        clearInterval(obj.timer);
      }
      if (iType == 1) {
        var sAttr = "";
        obj.iSpeed = {};
        for (sAttr in target) {
          obj.iSpeed[sAttr] = 0;
        }
      }
      if (target["transform"]) {
        if (obj["transform"]) {
          target["transform"] += obj["transform"];
        } else {
          this.css(obj, sAttr, 0);
        }
      }

      const that = this;
      switch (iType) {
        case 0:
          obj.timer = setInterval( ()=> {
            that.doMoveBuffer(obj, target, fnEnd);
          }, 24);
          break;
        case 1:
          obj.timer = setInterval( ()=> {
            that.domoveFlexible(obj, target, fnEnd);
          }, 24);
          break;
      }
    },
    doMoveBuffer(obj, target, fnEnd) {
      var sAttr = "";
      var iEnd = 1;
      for (sAttr in target) {
        if (this.toBrowser() == false && target["transform"]) {
          continue;
        }
        var iNow = parseFloat(this.css(obj, sAttr));
        if (iNow == target[sAttr]) {
          continue;
        } else {
          var iSpeed = (target[sAttr] - iNow) / 5;
          iSpeed *= 0.75;
          if (iSpeed > 0) {
            iSpeed = Math.ceil(iSpeed);
          } else {
            iSpeed = Math.floor(iSpeed);
          }
          this.css(obj, sAttr, iNow += iSpeed);
          iEnd = 0;
        }
      }
      if (iEnd) {
        clearInterval(obj.timer);
        if (fnEnd) {
          fnEnd.call(obj);
        }
      }
    },

    domoveFlexible(obj, target, fnEnd) {
      var sAttr = "";
      var iEnd = 1;
      for (sAttr in target) {
        if (this.toBrowser() === false && target["transform"]) {
          continue;
        }
        var iNow = parseFloat(this.css(obj, sAttr));
        obj.iSpeed[sAttr] += (target[sAttr] - iNow) / 5;
        obj.iSpeed[sAttr] *= 0.83;
        if (Math.round(iNow) == target[sAttr] && Math.abs(obj.iSpeed[sAttr]) < 1) {
          continue;
        } else {
          iNow = Math.round(iNow + obj.iSpeed[sAttr]);
          this.css(obj, sAttr, iNow);
          iEnd = 0;
        }
      }
      if (iEnd) {
        clearInterval(obj.timer);
        if (fnEnd) {
          fnEnd.call(obj);
        }
      }
    },
    css(obj, attr, value) {
      if (arguments.length == 2) {
        if (attr == "transform") {
          return obj.transform;
        }
        var i = parseFloat(obj.currentStyle ? obj.currentStyle[attr] : document.defaultView.getComputedStyle(obj, false)[attr]);
        var val = i ? i : 0;
        if (attr == "opacity") {
          val *= 100;
        }
        return val;
      } else if (arguments.length == 3) {
        switch (attr) {
          case 'width':
          case 'height':
          case 'paddingLeft':
          case 'paddingTop':
          case 'paddingRight':
          case 'paddingBottom':
            value = Math.max(value, 0);
          case 'left':
          case 'top':
          case 'marginLeft':
          case 'marginTop':
          case 'marginRight':
          case 'marginBottom':
            obj.style[attr] = value + 'px';
            break;
          case 'opacity':
            if (value < 0) {
              value = 0;
            }
            obj.style.filter = "alpha(opacity:" + value + ")";
            obj.style.opacity = value / 100;
            break;
          case 'transform':
            obj.transform = value;
            obj.style["transform"] = "rotate(" + value + "deg)";
            obj.style["MsTransform"] = "rotate(" + value + "deg)";
            obj.style["MozTransform"] = "rotate(" + value + "deg)";
            obj.style["WebkitTransform"] = "rotate(" + value + "deg)";
            obj.style["OTransform"] = "rotate(" + value + "deg)";
            break;
          default:
            obj.style[attr] = value;
        }

        return function (attr_in, value_in) {
          this.css(obj, attr_in, value_in)
        };
      }
    },
    getClass(sClass, obj) {
      var aRr = [];
      if (obj) {
        var aTag = obj.getElementsByTagName('*');
      } else {
        var aTag = document.getElementsByTagName('*');
      }
      for (var i = 0; i < aTag.length; i++) {
        var aClass = aTag[i].className.split(" ");
        for (var j = 0; j < aClass.length; j++) {
          if (aClass[j] == sClass) {
            aRr.push(aTag[i]);
          }
        }
      }
      return aRr;
    },
    byClient(obj, attr) {
      if (attr == "width") {
        return this.css(obj, "borderLeft") + this.css(obj, "borderRight") + this.css(obj, "paddingLeft") + this.css(obj, "paddingWidth") + this.css(obj, "paddingWidth");
      } else if (attr == "height") {
        return this.css(obj, "borderTop") + this.css(obj, "borderBottom") + this.css(obj, "paddingTop") + this.css(obj, "paddingBottom") + this.css(obj, "paddingHeight");
      }
    },
    toAppend() {
      var oImg=new Image();
      var sSrc="";
      var iAngle=parseInt(Math.random()*1000)%360;
      var iNubLeft=parseInt(Math.random()*100)%2?-parseInt(Math.random()*40):parseInt(Math.random()*40);
      var iNubTop=parseInt(Math.random()*100)%2?-parseInt(Math.random()*40):parseInt(Math.random()*40);
      var INub=parseInt(Math.random()*20);
      var iNubW=INub+this.iWidth;
      var iNubH=INub+this.iHeight;
      iNubLeft+=this.iLeft-25;
      iNubTop+=this.iTop-25;
      sSrc="/static/face.png";
      oImg.src=sSrc;
      oImg.onmousemove=()=>{
        return false;
      };
      oImg.style['width'] = iNubW+"px";
      oImg.style['height'] = iNubH+"px";
      oImg.style['position'] = "absolute";
      oImg.style['left'] = this.iLeft-(iNubW/2)+"px";
      oImg.style['top'] = this.iTop-(iNubH/2)+"px";


      this.css(oImg,"transform",iAngle);
      document.body.appendChild(oImg);
      this.starMove(oImg,{left:iNubLeft,top:iNubTop},1);
    },
    onmousedown(e) {
      this.is_touched = true
      console.log('start')
      var ev = e || event;
      this.iLeft = ev.clientX;
      this.iTop = ev.clientY;
      if (this.oTimer) {
        clearInterval(this.oTimer);
      }
      this.oTimer = setInterval( () => {
        if (this.is_touched) {
          this.toAppend();
        }
      }, 50);
      return false;
    },
    onmousemove (e) {
      console.log('move')
      var ev = e || event;
      this.iLeft = ev.clientX;
      this.iTop = ev.clientY;
      return false;
    },
    onmouseup () {
      this.is_touched = false
      console.log('end')
      clearInterval(this.oTimer);
      this.oTimer = null;
    }
  }
}
</script>

<style lang="scss">
.container{
  weight:100%;
  height:100vh;
  display: flex;
  margin:0;
  background:#7a4b94;
}
img {

}
</style>
