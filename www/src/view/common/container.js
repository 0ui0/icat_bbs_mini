// Generated by CoffeeScript 2.6.1
var Tools, isMobile, m;

m = require("mithril");

Tools = require("../help/tools");

isMobile = Tools.isMobile();

module.exports = {
  oninit: function() {
    return window.addEventListener("resize", function() {
      isMobile = Tools.isMobile();
      return m.redraw();
    });
  },
  view: function(v) {
    return m("", {
      style: {
        width: isMobile ? "auto" : "960px",
        margin: "0 auto",
        ...v.attrs.style
      },
      ...v.attrs.ext
    }, [v.children]);
  }
};