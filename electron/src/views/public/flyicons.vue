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
      point: {
        x: 0,
        y: 0
      },
      is_touched: false
    }
  },
  onLoad(options) {},
  methods: {
    starMove(obj, target, fnEnd, iDate) {
      if (obj.timer) {
        clearInterval(obj.timer);
      }
        var sAttr = "";
        obj.iSpeed = {};
        for (sAttr in target) {
          obj.iSpeed[sAttr] = 0;
        }

      if (target["transform"]) {
        if (obj["transform"]) {
          target["transform"] += obj["transform"];
        } else {
          this.css(obj, sAttr, 0);
        }
      }

      const that = this;

          obj.timer = setInterval( ()=> {
            that.domoveFlexible(obj, target, fnEnd);
          }, 24);

    },

    domoveFlexible(obj, target, fnEnd) {
      var sAttr = "";
      var iEnd = 1;
      for (sAttr in target) {
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
      if (arguments.length === 2) {
        if (attr == "transform") {
          return obj.transform;
        }
        var i = parseFloat(obj.currentStyle ? obj.currentStyle[attr] : document.defaultView.getComputedStyle(obj, false)[attr]);
        var val = i ? i : 0;
        if (attr === "opacity") {
          val *= 100;
        }
        return val;
      } else if (arguments.length === 3) {
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
    toAppend() {
      var oImg=new Image();
      var sSrc="";
      var iAngle=parseInt(Math.random()*1000)%360;
      var iNubLeft=parseInt(Math.random()*100)%2?-parseInt(Math.random()*40):parseInt(Math.random()*40);
      var iNubTop=parseInt(Math.random()*100)%2?-parseInt(Math.random()*40):parseInt(Math.random()*40);
      var INub=parseInt(Math.random()*20);
      var iNubW=INub+20;
      var iNubH=INub+20;
      iNubLeft+=this.point.x-25;
      iNubTop+=this.point.y-25;
      oImg.src="/static/face.png";
      oImg.onmousemove = ()=>{return false}
      oImg.style['width'] = iNubW+"px";
      oImg.style['height'] = iNubH+"px";
      oImg.style['position'] = "absolute";
      oImg.style['left'] = this.point.x-(iNubW/2)+"px";
      oImg.style['top'] = this.point.y-(iNubH/2)+"px";
      this.css(oImg,"transform",iAngle);
      document.body.appendChild(oImg);
      this.starMove(oImg,{left:iNubLeft,top:iNubTop},1);
    },
    onmousedown(e) {
      this.is_touched = true
      this.point.x = e.clientX;
      this.point.y = e.clientY;
      if (this.oTimer) {
        clearInterval(this.oTimer);
      }
      this.oTimer = setInterval( () => {
          this.toAppend();
      }, 50);
    },
    onmousemove (e) {
      this.point.x = e.clientX;
      this.point.y = e.clientY;
    },
    onmouseup () {
      this.is_touched = false
      clearInterval(this.oTimer);
    }
  }
}
</script>

<style lang="scss">
.container{
  height:100vh;
  display: flex;
  margin:0;
  background:#7a4b94;
}
</style>
