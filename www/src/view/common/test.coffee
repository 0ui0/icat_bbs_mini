m = require "mithril"

盒子 = require "./box"
头部 = require "./head"
容器 = require "./container"
消息窗 = require "../zone/zone_ntclist"

module.exports = ->
  view: (v)->
    m "",[
      m 头部
      m 容器,[
        m 盒子,"我是测试页面"
        m 消息窗
      ]
    ]