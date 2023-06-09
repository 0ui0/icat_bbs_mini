// Generated by CoffeeScript 2.6.1
var m;

m = require("mithril");

/*
  v.attrs.style = {}
  v.attrs.color = "red||blue||green||pink..."
*/
module.exports = function() {
  return {
    data: {
      value: ""
    },
    oninit: function(v) {
      var ref;
      return v.state.data.value = (ref = v.attrs.value) != null ? ref : "";
    },
    view: function(v) {
      var _this, ref;
      _this = this;
      return m((ref = v.attrs.tagName) != null ? ref : "", {
        class: v.attrs.class,
        style: {
          display: v.attrs.isBlock ? "block" : "inline-block",
          margin: "0.5rem",
          padding: "1rem",
          background: (function() {
            switch (v.attrs.color) {
              case "red":
                return "#bb4344";
              case "deepRed":
                return "#a5000c";
              case "dark":
                return "#333333";
              case "yellow":
                return "#ffdb66";
              case "sliver":
                return "#c0c0c0";
              case "black":
                return "#000000";
              case "white":
                return "#ffffff";
              case "green":
                return "#00d1b3";
              case "deepYellow":
                return "#ab8829";
              case "deepBlue":
                return "#5171b3";
              default:
                return "#eeeeee";
            }
          })(),
          color: (function() {
            switch (v.attrs.color) {
              case "red":
                return "#ffffff";
              case "deepRed":
                return "#ffffff";
              case "dark":
                return "#ffffff";
              case "yellow":
                return "#5f4905";
              case "sliver":
                return "#333333";
              case "black":
                return "#ffffff";
              case "white":
                return "#333333";
              case "green":
                return "#ffffff";
              case "deepYellow":
                return "#ffffff";
              case "deepBlue":
                return "#ffffff";
              default:
                return "#000000";
            }
          })(),
          border: "none",
          cursor: v.attrs.isBtn ? "pointer" : void 0,
          textAlign: v.attrs.isBtn ? "center" : void 0,
          boxShadow: "0 0 1rem rgba(0,0,0,0.05)",
          borderRadius: "0.5rem",
          wordWrap: "break-word",
          ...v.attrs.style
        },
        onmouseover: function(e, a) {
          var base;
          if (v.attrs.isBtn) {
            this.style.opacity = "0.8";
          }
          return typeof (base = v.attrs).onmouseover === "function" ? base.onmouseover(this, e, v, _this) : void 0;
        },
        onmouseout: function(e) {
          var base;
          if (v.attrs.isBtn) {
            this.style.opacity = "1";
          }
          return typeof (base = v.attrs).onmouseout === "function" ? base.onmouseout(this, e, v, _this) : void 0;
        },
        onclick: function(e) {
          var base;
          return typeof (base = v.attrs).onclick === "function" ? base.onclick(this, e, v, _this) : void 0;
        },
        
        // 表单型属性 必须被new才可使用
        oninput: function(e) {
          var base;
          if (((function() {
            switch (e.target.type) {
              case "text":
                return true;
              case "textarea":
                return true;
              case "password":
                return true;
            }
          })())) {
            _this.data.value = e.target.value;
          }
          return typeof (base = v.attrs).oninput === "function" ? base.oninput(this, e, v, _this) : void 0;
        },
        value: this.data.value,
        contenteditable: v.attrs.contenteditable,
        placeholder: v.attrs.placeholder,
        ...v.attrs.ext
      }, [...v.children]);
    }
  };
};
