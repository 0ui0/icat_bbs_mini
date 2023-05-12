m = require "mithril"
Box = require "./box"

module.exports = 
  view: (v)->
    throw ReferenceError "缺少参数isTop或isBottom" if not(v.attrs.isTop||v.attrs.isBottom)
    m Box,{
      style:{
        position: "fixed"
        top: 0 if v.attrs.isTop
        bottom: 0 if v.attrs.isBottom
        left:0
        right:0
        display: "flex"
        justiContent: "start"
        margin: 0
        padding: 0
        borderRadius: "0"
        zIndex: 100
        height: "5.1rem"
        v.attrs.style...
      } 
      color: v.attrs.color 
      ext:v.attrs.ext
    }
    ,[
      v.children...
    ]
