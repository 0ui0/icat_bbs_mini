// Generated by CoffeeScript 2.6.1
var katex, marked;

marked = require("marked");

katex = require("katex");

marked.setOptions({
  breaks: true
});

module.exports = function(content) {
  return marked(content.replace(/\$\$[^\$\$]+\$\$/g, function(i) {
    return katex.renderToString(i.replace(/\$\$/g, ""), {
      throwOnError: false
    });
  }));
};
