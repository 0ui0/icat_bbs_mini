m = require "mithril"
Tools = require "../help/tools"

isMobile = Tools.isMobile()

module.exports = 
  oninit: ->     
    window.addEventListener "resize",->
      isMobile = Tools.isMobile()
      m.redraw()
  view: (v)->
    m "",{
      style:{
        width:if isMobile then "auto" else "960px"
        margin:"0 auto"
        v.attrs.style...
      }
      v.attrs.ext...
    },[
      v.children
    ]