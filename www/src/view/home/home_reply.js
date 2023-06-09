// Generated by CoffeeScript 2.6.1
var Box, Editor, Img, Reply, Tag, homeData, m, opera, user;

m = require("mithril");

// common
Box = require("../common/box");

Tag = require("../common/tag");

Img = require("../common/img");

user = require("../common/user");

//component
Editor = require("./home_editor");

opera = require("./home_opera");

//data
homeData = require("./home_data");

Reply = function() {
  return {
    oninit: async function(v) {
      return (await homeData.fresh(v.attrs.self.pid));
    },
    data: {
      showMenu: false,
      showReply: false
    },
    view: function(v) {
      var _this, item, ref, self;
      _this = this;
      self = v.attrs.self;
      return m(".animated.slideInDown", {
        style: {
          marginLeft: v.attrs.isThread ? "" : "5rem"
        },
        "data-key": self.pid
      }, [
        m("",
        {
          style: {
            display: "flex",
            alignItems: "center"
          }
        },
        [
          m(Img,
          {
            style: {
              width: "4rem",
              boxShadow: "0.1rem 0.1rem 1rem rgba(0,0,0,0.3)"
            },
            src: self.icat_users_extend.avatar || "./statics/default_avatar.jpg"
          }),
          m(Box,
          {
            style: {
              fontSize: "1.2rem"
            },
            color: self.author === ((ref = user.info) != null ? ref.user : void 0) ? "red" : "black"
          },
          self.author),
          m(Box,
          {
            style: {
              //flexGrow: 1
              fontSize: "1.2rem",
              //overflowWrap:"break-word"
              //overflow:"auto"
              //width:"auto"
              maxWidth: "35rem"
            }
          },
          //whiteSpace:"normal"
          //maxHeight:"10rem"
          self.content),
          homeData.posts[v.attrs.self.pid].length > 0 ? m(Box,
          {
            style: {
              fontSize: "1.2rem"
            },
            isBtn: true,
            onclick: function() {
              return _this.data.showReply = !_this.data.showReply;
            }
          },
          _this.data.showReply ? "收起" : `↓评论${homeData.posts[v.attrs.self.pid].length}`) : void 0,
          m(Box,
          {
            style: {
              fontSize: "1.2rem"
            },
            isBtn: true,
            onclick: function() {
              return _this.data.showMenu = !_this.data.showMenu;
            }
          },
          _this.data.showMenu ? "收起" : "操作")
        ]),
        // 操作菜单
        _this.data.showMenu ? m(Box,
        {
          isBlock: true,
          color: "white"
        },
        [
          m(Tag,
          {
            isBtn: true,
            onclick: async function() {
              return (await opera.reply(self,
          _this));
            }
          },
          "回复"),
          m(Tag,
          {
            isBtn: true,
            onclick: async function() {
              return (await opera.edit(self));
            }
          },
          "编辑"),
          m(Tag,
          {
            isBtn: true,
            onclick: async function() {
              return (await opera.del(self));
            }
          },
          "删除")
        ]) : void 0,
        (function() {
          var i,
        len,
        ref1,
        results;
          // 递归回复
          if (_this.data.showReply) {
            ref1 = homeData.posts[v.attrs.self.pid];
            results = [];
            for (i = 0, len = ref1.length; i < len; i++) {
              item = ref1[i];
              results.push(m(Reply,
        {
                key: item.pid,
                self: item
              }));
            }
            return results;
          }
        })()
      ]);
    }
  };
};

module.exports = Reply;
