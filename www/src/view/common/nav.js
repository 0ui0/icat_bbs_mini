// Generated by CoffeeScript 2.6.1
var Box, m;

m = require("mithril");

Box = require("./box");

module.exports = {
  view: function(v) {
    if (!(v.attrs.isTop || v.attrs.isBottom)) {
      throw ReferenceError("缺少参数isTop或isBottom");
    }
    return m(Box, {
      style: {
        position: "fixed",
        top: v.attrs.isTop ? 0 : void 0,
        bottom: v.attrs.isBottom ? 0 : void 0,
        left: 0,
        right: 0,
        display: "flex",
        justiContent: "start",
        margin: 0,
        padding: 0,
        borderRadius: "0",
        zIndex: 100,
        height: "5.1rem",
        ...v.attrs.style
      },
      color: v.attrs.color,
      ext: v.attrs.ext
    }, [...v.children]);
  }
};
