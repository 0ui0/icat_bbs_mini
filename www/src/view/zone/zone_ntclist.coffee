m = require "mithril"
弹窗 = require "../common/notice"
盒子 = require "../common/box"
标签 = require "../common/tag"

module.exports = 
  view: ->
    m "",[
      m 盒子,
        color:"red"
      ,"哇哇哇"
    ]