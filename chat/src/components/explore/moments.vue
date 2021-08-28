<template>
  <section class="child_page">
    <section class="friend_wipe" ref="friend">
      <section class="friend">
        <div class="theme">
          <div class="themeinit" @click="exportInput"></div>
          <div :class="{shoowimg : !imagestatus}" @click="exportInput">
            <img src="https://sinacloud.net/vue-wechat/images/headers/zhenji.jpg" id="imgSrc" ref="imgSrc" class="imgSrc" />
          </div>
          <div class="themetext" :class="{shoowimg : imagestatus}">轻触更换主题照片</div>
          <div class="personImg">
            <div class="personame">{{userInfoData.name}}</div>
            <div class="headimg" @click="personInfor">
              <img :src="userHeader" alt="">
            </div>
          </div>
        </div>
        <div class="coverinput" :class="{shoowinput : afterclcik}">
          <div class="coverinputbg" @click="hideIput"></div>
          <div class="coverfiletext">
            <div class="wipeinput">更换相册封面
              <input type="file" class="coverfile" id="input_file" />
            </div>
          </div>
        </div>
        <div class="condition">
          <ul>
            <li class="condition_li" v-for="(item,index) in circleData" :key="index">
              <div class="condition_left">
                <img src="https://sinacloud.net/vue-wechat/images/headers/zhenji.jpg" alt="">
              </div>
              <div class="condition_right">
                <h1>{{item.remarks ? item.remarks : item.petname}}</h1>
                <div class="publishtext">{{item.statements}}</div>
                <div class="publishimg clear" v-show="item.postimage.length>0">
                  <img alt="" v-for="(value,imgIndex) in item.postimage" :key="imgIndex"
                       src="https://sinacloud.net/vue-wechat/images/headers/zhenji.jpg"
                       :class="{releaseimg : item.postimage.length >= 2 ? true : false}" />
                </div>
                <div class="commentbutton">
                  <div class="button_left clear">
                    <span>1小时前</span>
                    <span v-if=" userInfoData.wxid == item.wxid ? true : false">删除</span>
                  </div>
                  <div class="button_right">
                    <div class="iconfont icon-wechat" @click="showDiscuss(item)">
                    </div>
                    <div class="discuss" v-if="item.criticism" :class="{discusshow : item.reviewshow, discusshide : item.reviewhide}">
                      <div @click="supportThing(item)">
                        <div fill="#fff" class="iconfont icon-wechat" :class="{surportdiv : likediv}"></div>
                        <span ref="suporttext">{{item.suporthtml}}</span>
                      </div>
                      <div @click="criticismThing(item)">
                        <div class="iconfont icon-wechat" fill="#fff"></div>
                        <span>评论</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="retext" v-show="item.like.length >0 || item.comment.length > 0">
                  <div class="retext_like clear" :class="{likeborder : item.comment.length >0 }" v-show="item.like.length > 0">
                    <div class="retext_like_svg" fill="#8792b0"></div>
                    <span v-for="(value,likeIndex) in item.like" :key="likeIndex">{{value}}<i>,</i></span>
                  </div>
                  <div class="retext_revert" v-show="item.comment.length > 0">
                    <ul>
                      <li v-for="(value,commentIndex) in item.comment" :key="commentIndex">
                        <span>{{value.remarks ? value.remarks: value.petname}}</span>：{{value.commentext}}
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>
        <!-- 评论 -->
        <section class="criticism" v-if="criticismstate">
          <div class="criticism_con">
            <textarea name="" id="" cols="30" rows="10" ref="textinput" v-model="textareaVlue" @input="inputCriticism" @keyup.enter="enterThing"></textarea>
            <span :class="{notempty:changeinput}" @click="commentSend">发送</span>
          </div>
        </section>
      </section>
    </section>
  </section>
</template>

<script>
const pic = "https://sinacloud.net/vue-wechat/images/headers/zhenji.jpg"
const circle= [
  {
    "wxid":"chenchangsheng",
    "headurl":pic,
    "petname":"陈长生",
    "sex":0,
    "remarks":"",
    "statements":"逆天改命",
    "time":"20分钟前",
    "postimage":[

    ],
    "like":['楚乔',"嗯",],
    "comment":[],
    "reviewshow":false,
    "reviewhide":false,
    "criticism":false,
    "flag":true,
    "suporthtml":"赞",
  },{
    "wxid":"812571880",
    "headurl":pic,
    "petname":"百里辰",
    "sex":1,
    "remarks":"",
    "statements":"身边总有几个这样的朋友，第一次遇见斯斯文文的，熟识之后会发与不知道是哪个精神病院放出来的。",
    "time":"5分钟前",
    "postimage":[
      pic,pic,pic,pic,pic,pic
    ],
    "like":[
      "嗯",
    ],
    "comment":[
      {
        "wxid":"enen",
        "petname":"嗯",
        "remarks":"嗯",
        "commentext":"看好你呦！"
      },
      {
        "wxid":"achuqiao",
        "petname":"a楚乔",
        "remarks":"楚乔",
        "commentext":"披荆斩棘",
      },
    ],
    "reviewshow":false,
    "reviewhide":false,
    "criticism":false,
    "flag":true,
    "suporthtml":"赞",
  },

  {
    "wxid":"chenyuan",
    "headurl":pic,
    "petname":"程鸢",
    "sex":0,
    "remarks":"",
    "statements":"",
    "time":"20分钟前",
    "postimage":[
      pic
    ],
    "like":[],
    "comment":[
      {
        "wxid":"enen",
        "petname":"嗯",
        "remarks":"嗯",
        "commentext":"看好你呦！"
      },
      {
        "wxid":"achuqiao",
        "petname":"a楚乔",
        "remarks":"楚乔",
        "commentext":"披荆斩棘",
      },
    ],
    "reviewshow":false,
    "reviewhide":false,
    "criticism":false,
    "flag":true,
    "suporthtml":"赞",
  },
  {
    "wxid":"shugeuifei",
    "headurl":pic,
    "petname":"魏贵妃",
    "sex":0,
    "remarks":"",
    "statements":"",
    "time":"1小时前",
    "postimage":[
      pic,pic,
    ],
    "like":[],
    "comment":[
      {
        "wxid":"enen",
        "petname":"嗯",
        "remarks":"嗯",
        "commentext":"看好你呦！"
      },
      {
        "wxid":"achuqiao",
        "petname":"a楚乔",
        "remarks":"楚乔",
        "commentext":"披荆斩棘",
      },
    ],
    "reviewshow":false,
    "reviewhide":false,
    "criticism":false,
    "flag":true,
    "suporthtml":"赞",
  },
]

function uploadPreview(setting) {

  var _self = this;

  _self.IsNull = function(value) {
    if (typeof (value) == "function") { return false; }
    if (value == undefined || value == null || value == "" || value.length == 0) {
      return true;
    }
    return false;
  }

  _self.DefautlSetting = {
    UpBtn: "",
    DivShow: "",
    ImgShow: "",
    Width: 100,
    Height: 100,
    ImgType: ["gif", "jpeg", "jpg", "bmp", "png"],
    ErrMsg: "选择文件错误,图片类型必须是(gif,jpeg,jpg,bmp,png)中的一种",
    callback: function() { }
  };

  _self.Setting = {
    UpBtn: _self.IsNull(setting.UpBtn) ? _self.DefautlSetting.UpBtn : setting.UpBtn,
    DivShow: _self.IsNull(setting.DivShow) ? _self.DefautlSetting.DivShow : setting.DivShow,
    ImgShow: _self.IsNull(setting.ImgShow) ? _self.DefautlSetting.ImgShow : setting.ImgShow,
    Width: _self.IsNull(setting.Width) ? _self.DefautlSetting.Width : setting.Width,
    Height: _self.IsNull(setting.Height) ? _self.DefautlSetting.Height : setting.Height,
    ImgType: _self.IsNull(setting.ImgType) ? _self.DefautlSetting.ImgType : setting.ImgType,
    ErrMsg: _self.IsNull(setting.ErrMsg) ? _self.DefautlSetting.ErrMsg : setting.ErrMsg,
    callback: _self.IsNull(setting.callback) ? _self.DefautlSetting.callback : setting.callback
  };

  _self.getObjectURL = function(file) {
    var url = null;
    if (window.createObjectURL != undefined) {
      url = window.createObjectURL(file);
    } else if (window.URL != undefined) {
      url = window.URL.createObjectURL(file);
    } else if (window.webkitURL != undefined) {
      url = window.webkitURL.createObjectURL(file);
    }
    return url;
  }

  _self.Bind = function() {

    document.getElementById(_self.Setting.UpBtn).onchange = function() {
      if (this.value) {
        if (navigator.userAgent.indexOf("MSIE") > -1) {
          try {
            document.getElementById(_self.Setting.ImgShow).src = _self.getObjectURL(this.files[0]);
          } catch (e) {
            var div = document.getElementById(_self.Setting.DivShow);
            this.select();
            top.parent.document.body.focus();
            var src = document.selection.createRange().text;
            document.selection.empty();
            document.getElementById(_self.Setting.ImgShow).style.display = "none";
            div.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale)";
            div.style.width = _self.Setting.Width + "px";
            div.style.height = _self.Setting.Height + "px";
            div.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = src;
          }
        } else {
          document.getElementById(_self.Setting.ImgShow).src = _self.getObjectURL(this.files[0]);
        }
        _self.Setting.callback();
      }

    }
  }
  _self.Bind();
}

export default {
  data() {
    return {
      filevalue: '',
      imageSrc: false,			//显示的是图片还是文字
      afterclcik: true,		//点击显示上传图片的input
      releaseimgnum: true,		//上传的图片数是否大于1
      timer: null,				//定时器
      timers: null,			//点赞定时器
      bordercss: true,			//点赞的下边框
      likenum: true,			//点赞的人数
      circleData: [],
      likediv: false,			//点击时svg图放大
      textareaVlue: '',		//评论输入的内容
      changeinput: false,		//控制发送按钮状态的改变
      criticismstate: false,	//评论显隐
      itemlist: {},			//点击当前的li
      userInfoData: {},			//用户信息
      userHeader: '',			//用户头像
      imagestatus: false,
      userInfo: {}
    }
  },
  created() {

  },
  beforeDestroy() {
    clearTimeout(this.timer);
    clearTimeout(this.timers);
  },
  mounted() {
    this.userInfoData = {
      avatar: "13.jpg",
      id: 1,
      name: "abc"
    }
    this.userInfo = this.userInfoData
    this.userHeader = 'http://localhost:8003/abc.jpeg'
    //上传图片并展示图片（无剪裁功能）
    new uploadPreview({
      UpBtn: "input_file",
      ImgShow: "imgSrc",
      ImgType: ["gif", "jpeg", "jpg", "bmp", "png"],
      callback: () => {
        this.afterclcik = true;
        this.newImg = this.$refs.imgSrc.src
        // this.SAVE_THEMIMG({ newImg: this.$refs.imgSrc.src, imagestatus: true })
      }
    });
    //获取朋友圈数据
    this.circleData = circle;

  },
  components: {
  },
  computed: {
  },
  methods: {
    enterThing() {
      this.commentSend()
    },
    exportInput() {
      this.afterclcik = false;
    },
    hideIput() {
      this.afterclcik = true;
      // this.SAVE_THEMIMG(this.$refs.imgSrc.src)
    },
    commentShow(item) {
      item.criticism = true;
      item.reviewshow = true;
      item.reviewhide = false;
      item.flag = false;
    },
    commentHide(item) {
      item.reviewshow = false;
      item.reviewhide = true;
      this.timer = setTimeout(() => {
        clearTimeout(this.timer);
        item.criticism = false;
      }, 1000)
      item.flag = true;
    },
    showDiscuss(item) { //点击评论按钮点赞与评论出现
      if (item.flag) {
        this.commentShow(item)
      } else {
        this.commentHide(item);
      }
    },
    freshPage() {//点击头部页面滚动到顶部
    },
    personInfor() {//点击头像进入个人资料页
      this.SAVE_MESSAGE(this.userInfoData);
      this.$router.push('/addressbook/details');
    },
    supportThing(item) {//点赞
      this.likediv = true;
      clearTimeout(this.timers);
      this.timers = setTimeout(() => {
        this.likediv = false;
      }, 200);
      this.commentHide(item);
      if (item.suporthtml == "赞") {
        item.suporthtml = "取消";
        item.like.push(this.userInfoData.name)
      } else {
        item.suporthtml = "赞";
        item.like.pop();
      }
    },
    criticismThing(item) {//评论

      this.itemlist = {};
      this.itemlist = item;
      this.criticismstate = true;
      this.$nextTick(() => {
        this.$refs.textinput.focus();
      })
      this.commentHide(item);
    },
    inputCriticism() {//文本框是否为空
      this.textareaVlue ? this.changeinput = true : this.changeinput = false;
    },
    commentSend() {//评论点击发送
      if (this.changeinput) {
        if (this.textareaVlue) {
          this.itemlist.comment.push({
            wxid: this.userInfoData.id,
            petname: this.userInfoData.name,
            commentext: this.textareaVlue
          })
        }
        this.criticismstate = false;
        this.textareaVlue = '';
        this.changeinput = false;
      }

    }
  }
}
</script>
<style lang="less" scoped>
.child_page {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 203;
  background-color: #f8f8f8;
}
.refresh {
  position: absolute;
  width: 12rem;
  Height: 2rem;
  background: #fff;
  left: 2rem;
}
.friend_wipe {
  width: 100%;
  padding-bottom: 1rem;
  background-color: #f8f8f8;
  overflow: scroll;
  -webkit-overflow-scrolling: touch;
  .friend {
    padding-top: 2.06933rem;
    background-color: #f8f8f8;
    .theme {
      width: 100%;
      margin-top: -1px;
      height: 11.3706666667rem;
      position: relative;
      .themeinit {
        width: 100%;
        height: 11.3706666667rem;
        position: absolute;
        top: 0;
        left: 0;
        background: #000;
        opacity: 0.6;
      }
      .imgSrc {
        display: block;
        position: absolute;
        top: 0;
        z-index: 4;
        width: 100%;
        height: 11.3706666667rem;
      }
      .shoowimg {
        display: none;
      }
      .themetext {
        display: flex;
        justify-content:  center;
       font-size: 0.6rem;color:#000;
        z-index: 2;
      }
      .personImg {
        position: absolute;
        right: 0.512rem;
        z-index: 6;
        bottom: -1.3866666667rem;
        display: flex;
        justify-content: flex-end;
        .personame {
          display: block;
          margin-right: 0.512rem;
         font-size: 0.64rem;color: #fff;
          margin-top: 0.96rem;
        }
        .headimg {
          background: #fff;
          border: 1px solid #e2e2e2;
          img {
            margin: 0.064rem;
            display: block;
             width:3.4133333333rem;
            Height:3.4133333333rem;
          }
        }
      }
    }
    .coverinput {
      position: absolute;
      z-index: 11;
      top: 0;
      width: 100%;
      height: 100%;
      .coverinputbg {
        position: fixed;
        width: 100%;
        height: 100%;
        top: 0;
        background: #000;
        opacity: 0.3;
      }
      .coverfiletext {
        display: flex;
        justify-content:  center;
        z-index: 5;
        width: 11rem;
        height: 2.048rem;
        line-height: 2.048rem;
        background: #fff;
        border-radius: 3px;
        font-size: 0.64rem;color: #333;
        .wipeinput {
          position: relative;
          padding-left: 1rem;
          .coverfile {
            position: absolute;
            display: block;
            top: 0;
            left: 0;
            width: 11rem;
            height: 2.048rem;
            opacity: 0;
          }
        }
      }
    }
    .shoowinput {
      display: none;
    }
    .condition {
      width: 100%;
      padding-top: 1.5786666667rem;
      ul {
        width: 100%;
        .condition_li {
          padding: 0.512rem;
          border-bottom: 1px solid #e2e2e2;
          display: flex;
          justify-content: flex-start;
          .condition_left {
            width: 1.792rem;
            margin-right: 0.2986666667rem;
            img {
              display: block;
              width: 1.792rem;Height:1.792rem;
            }
          }
          .condition_right {
            width: 100%;
            h1 {
              display: block;
              padding-top: 0.1706666667rem;
              font-size: 0.5546666667rem;color: #8792b0;
            }
            .publishtext {
              margin-top: 0.064rem;
              width: 100%;

              font-size: 0.5546666667rem;color: #333;
              line-height: 0.7466666667rem;
              overflow: hidden;
              text-overflow: ellipsis;
              display: -webkit-box;
              -webkit-line-clamp: 6;
              -webkit-box-orient: vertical;
              word-break: break-all;
            }
            .publishimg {
              width: 100%;
              margin-top: 0.3413333333rem;
              img {
                width: 40%;
                float: left;
                height: auto;
              }
              .releaseimg {
                width: 3.6266666667rem;
                margin-right: 0.1066666667rem;
                margin-bottom: 0.1066666667rem;
                height: 3.6266666667rem;
              }
            }
            .commentbutton {
              .button_left {
                margin-top: 0.576rem;
                span {
                  float: left;
                 font-size: 0.4693333333rem;color: #666;
                  margin-right: 0.4266666667rem;
                }
                span + span {
                  color: #8792b0;
                }
              }
              .button_right {
                margin-top: 0.6826666667rem;
                position: relative;
                width:0.9386666667rem;height: 0.64rem;
                .button_svg {
                  display: block;
                  width:100%;
                  Height:100%;
                  background-color: green;
                }
                .discuss {
                          width:8.2346666667rem;
                          height:1.7066666667rem;
                  background: #373b3e;
                  border-radius: 3px;
                  right: 1.408rem;
                  top: -0.5973333333rem;
                  box-sizing: border-box;
                  div {
                    width: 50%;
                    float: left;
                    display: flex;
                  justify-content: center;

                    div {
                      display: block;
                             width: 0.768rem;
                              height:0.768rem;
                      margin-right: 0.2133333333rem;
                    }
                    span {
                      display: block;
                       font-size:        0.5546666667rem;
                            color:  #fff;
                    }
                  }
                  div:first-child {
                    border-right: 2px solid #2f3336;
                  }
                  .surportdiv {
                    animation: pulse 0.5s;
                  }
                }
                .discusshow {
                  animation: flipInX 1s 1 ease-in-out both;
                }
                .discusshide {
                  animation: flipOutX 1s 1 ease-in-out both;
                }
              }
            }
            .retext {
              margin-top: 0.128rem;
              .retext_trigon {
                display: block;
                 width:0.8rem;Height: 0.4rem;
                margin-left: 0.4266666667rem;
              }
              .retext_like {
                background: #efefef;
                padding: 0.3413333333rem;
                .retext_like_svg {
                  float: left;
                  width:1rem;
                  Height:1rem;
                  background-color: red;
                  margin-right: 0.2133333333rem;
                  margin-top: 0.064rem;
                }
                span {
                  float: left;
                  margin-right: 0.2133333333rem;
                  font-size: 0.512rem; color:#8792b0;
                  i {
                    font-size: 0.512rem;color: #8792b0;
                  }
                }
                span:last-child {
                  font-size: 0.512rem;color: #8792b0;
                  i {
                    display: none;
                  }
                }
              }
              .likeborder {
                border-bottom: 1px solid #e2e2e2;
              }
              .retext_revert {
                background: #efefef;
                ul {
                  padding: 0.3413333333rem;
                  li {
                    border: 0;
                    padding-bottom: 0.1rem;
                     font-size:        0.5546666667rem;
                       color:     #333;
                    span {
                      display: inline-block;
                      color: #8792b0;
                    }
                  }
                }
              }
            }
          }
        }
        .condition_li:last-child {
          border: 0;
        }
      }
    }
    .criticism {
      position: fixed;
      left: 0;
      z-index: 10;
      bottom: 0;
      width: 100%;
      background: #ebebeb;
      .criticism_con {
        padding: 0.4266666667rem 0.64rem;
        display: flex;
        justify-content: space-between;
        textarea {
          display: block;
          width: 12rem;
          height: 1.5rem;
          max-height: 3.2rem;
          border: 0;
          border-bottom: 2px solid #18ae17;
          resize: none;
          font-size: 0.64rem;color: #333;
          line-height: 0.768rem;
          background: none;
          padding-top: 0.32rem;
        }
        span {
          display: block;
          width: 1.8rem;
          font-size: 0.5546666667rem;color: #d2d2d2;
          border: 1px solid #d7d7d7;
          text-align: center;
          border-radius: 5px;
          line-height: 1.3653333333rem;
        }
        .notempty {
          background: #18ae17;
          color: #fff;
          border-color: #3e8d3e;
        }
      }
    }
  }
}

@keyframes flipInX {
  from {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);
    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);
    -webkit-animation-timing-function: ease-in;
    animation-timing-function: ease-in;
    opacity: 0;
  }

  40% {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);
    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);
    -webkit-animation-timing-function: ease-in;
    animation-timing-function: ease-in;
  }

  60% {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 10deg);
    transform: perspective(400px) rotate3d(1, 0, 0, 10deg);
    opacity: 1;
  }

  80% {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -5deg);
    transform: perspective(400px) rotate3d(1, 0, 0, -5deg);
  }

  100% {
    -webkit-transform: perspective(400px);
    transform: perspective(400px);
  }
}
@keyframes flipOutX {
  from {
    -webkit-transform: perspective(400px);
    transform: perspective(400px);
  }

  30% {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);
    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);
    opacity: 1;
  }

  100% {
    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);
    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);
    opacity: 0;
  }
}
@keyframes pulse {
  from {
    -webkit-transform: scale3d(1, 1, 1);
    transform: scale3d(1, 1, 1);
  }

  50% {
    -webkit-transform: scale3d(1.1, 1.1, 1.1);
    transform: scale3d(1.1, 1.1, 1.1);
  }

  100% {
    -webkit-transform: scale3d(1, 1, 1);
    transform: scale3d(1, 1, 1);
  }
}
</style>
