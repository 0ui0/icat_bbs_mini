m = require "mithril"
Box = require "./box"

module.exports =
  launch:(json)->

    {
      type: @data.type = "peace" 
      tip: @data.tip = "提示",
      msg: @data.msg = "忘记赋值了噢",
      content: @data.content = undefined,      
      confirm: @method.confirm = ->,
      cancel: @method.cancel = ->

    } = {...json}

    @data.show = yes

  data:
    show: no
    type:"peace"
    tip: "提示："
    msg: "忘记赋值了噢"
    content: undefined

  method:
    confirm: ->
    cancel: ->

      
  view: ->
    _this = this
    if _this.data.show
      m "",
        style:
          zIndex: 10000
          position: "fixed"
          top: 0
          bottom: 0
          left: 0
          right: 0
          background: "rgba(0,0,0,0.5)"
          display: "flex"
          flexDirection: "column"
          justifyContent: "center"
          alignItems: "center"
          boxShadow:"0.1rem 0.1rem 1rem rgba(0,0,0,0.5)"        
      ,[
        m Box,
          class: switch _this.data.type
            when "basic" then "animated shake"
            when "peace" then "animated pulse"
          style:
            display: "grid"
            gridTemplateAreas: """
            "a a"
            "b c"
            """
          color: "white",        
        ,
        [
          # 如果有组件传入，直接展示组件

          if _this.data.content
            m "",
              style:
                gridArea:"a"
            ,[
              m _this.data.content
            ]
              
          else
            m Box,
              style:
                gridArea:"a"
            ,[
              m "strong",_this.data.tip
              m "",_this.data.msg
            ] 

          m Box,
            color:"red"
            style:
              gridArea:"b"
            isBtn: yes
            onclick: ->
              _this.method.confirm()
              _this.data.show = no
          ,"确定"
          m Box,
            style:
              gridArea:"c"
            isBtn: yes
            onclick: ->
              _this.method.cancel()
              _this.data.show = no
          ,"取消"
        ]
      ]
    else
      null