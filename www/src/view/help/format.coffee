marked = require "marked"
katex =  require "katex"

marked.setOptions breaks:true

module.exports = (content)->
  return marked content.replace /\$\$[^\$\$]+\$\$/g,(i)->
    katex.renderToString (i.replace /\$\$/g,""),throwOnError: false