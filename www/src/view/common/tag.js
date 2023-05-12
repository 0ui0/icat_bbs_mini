// Generated by CoffeeScript 2.6.1
var Box, m;

m = require("mithril");

Box = require("./box");

module.exports = function() {
  return {
    view: function(v) {
      if (v.attrs.style) {
        throw Error("请使用styleExt");
      }
      return m(Box, {
        style: {
          display: v.attrs.isBlock ? "block" : "inline-block",
          padding: v.attrs.isWide ? "0.2rem 1rem" : "0.2rem 0.5rem",
          fontSize: "1.3rem",
          margin: "0.2rem 0.5rem",
          borderRadius: "1rem",
          ...v.attrs.styleExt
        },
        ...v.attrs
      }, v.children);
    }
  };
};