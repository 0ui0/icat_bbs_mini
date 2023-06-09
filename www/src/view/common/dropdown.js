// Generated by CoffeeScript 2.6.1
var Box, countTimer, m;

m = require("mithril");

Box = require("./box");

// 准备一个函数，返回两个计时器
countTimer = function(v) {
  return {
    onmouseover: () => {
      if (!v.attrs.isClick) {
        this.data.showMenu = true;
        return clearTimeout(this.data.timer);
      } else {
        return {};
      }
    },
    onmouseout: () => {
      if (!v.attrs.isClick) {
        clearTimeout(this.data.timer);
        return this.data.timer = window.setTimeout(() => {
          this.data.showMenu = false;
          return m.redraw();
        }, 30);
      } else {
        return {};
      }
    }
  };
};

module.exports = function() {
  return {
    data: {
      showMenu: false,
      timer1: null,
      timer2: null
    },
    view: function(v) {
      var ref;
      if (!v.attrs.name1) {
        throw ReferenceError("请提供下拉菜单名");
      }
      return m("", {
        style: {
          position: "relative",
          display: "inline-block"
        }
      }, [
        // 菜单
        m(Box,
        {
          color: v.attrs.color,
          isBtn: true,
          ...countTimer.call(this,
        v),
          onclick: () => {
            return this.data.showMenu = !this.data.showMenu;
          }
        },
        !this.data.showMenu ? v.attrs.name1 : (ref = v.attrs.name2) != null ? ref : v.attrs.name1),
        // 隐藏菜单组
        this.data.showMenu === true ? m(Box,
        {
          onbeforeremove: function(v) {
            v.dom.classList.add("zoomOut");
            return new Promise(function(res,
        rej) {
              return v.dom.addEventListener("animationend",
        res);
            });
          },
          style: {
            display: "block",
            //width:"100%"
            position: "absolute",
            right: 0,
            background: "white",
            ...v.attrs.style
          },
          class: v.attrs.class,
          ...countTimer.call(this,
        v)
        },
        [v.attrs.child(this)]) : void 0
      ]);
    }
  };
};
