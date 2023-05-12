m = require "mithril"
Box = require "./box"

# 准备一个函数，返回两个计时器
countTimer = (v)->
  onmouseover:=>
    if not v.attrs.isClick       
      @data.showMenu = yes
      clearTimeout @data.timer
    else{}

  onmouseout:=>
    if not v.attrs.isClick
      clearTimeout @data.timer 
      @data.timer = window.setTimeout =>
        @data.showMenu = no
        m.redraw()
      ,30
    else{}

module.exports = ->
  data:
    showMenu: no
    timer1: null
    timer2 :null
  view:(v)->
    throw ReferenceError "请提供下拉菜单名" if not v.attrs.name1
    m "",
      style:
        position: "relative"
        display: "inline-block"
    ,[
      # 菜单
      m Box,{
        color:v.attrs.color
        isBtn:yes
        countTimer.call(this,v)...
        onclick:=> @data.showMenu = !@data.showMenu
      }          
      ,if not @data.showMenu then v.attrs.name1 else v.attrs.name2 ? v.attrs.name1

      # 隐藏菜单组
      (m Box,{
        onbeforeremove:(v)->
          v.dom.classList.add("zoomOut")
          new Promise (res,rej)->
            v.dom.addEventListener "animationend",res
        style:{
          display:"block"
          #width:"100%"
          position:"absolute"
          right:0
          background:"white"
          v.attrs.style...
        }
        class:v.attrs.class
        countTimer.call(this,v)...
      }

      ,[
        v.attrs.child(this)
      ]) if @data.showMenu is yes

    ]


