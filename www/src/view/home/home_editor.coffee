m = require "mithril"
Box = require "../common/box"
Tag = require "../common/tag"
Nav = require "../common/nav"
tools = require "../help/tools"
format = require "../help/format"
isLogined = require "../help/isLogined"
Container = require "../common/container"
Notice = require "../common/notice"

Vditor = require "vditor"

homeData = require "./home_data"


isMobile = tools.isMobile()


滑块调整开始监听 = (类型,对象,事件,外部变量)->

  switch 类型
    when "鼠标"
      监听移动 = "mousemove"
      监听终止 = "mouseup"
    when "触摸"
      监听移动 = "touchmove"
      监听终止 = "touchend"

  距离 = (事件.clientY ? 事件.touches[0].clientY) - 外部变量.data.height

  document.addEventListener 监听移动,监听移动函数=(e)->

    mouseY = e.clientY ? e.touches[0].clientY


    e.preventDefault() #阻止鼠标默认行为

    三分之一高度 = document.documentElement.clientHeight / 3
    三分之二高度 = Math.round document.documentElement.clientHeight * 2 / 3

    if (mouseY <= 0)
        外部变量.data.height = 0
        return
    if (mouseY >= 三分之二高度)
        外部变量.data.height = 三分之二高度
        return

    外部变量.data.height = mouseY - 距离

    m.redraw() #立即刷新，防止页面卡顿


  document.addEventListener 监听终止,监听终止函数=->

    document.removeEventListener 监听移动,监听移动函数
    document.removeEventListener 监听终止,监听终止函数


module.exports =
  oninit:->
    window.addEventListener "resize",->
      isMobile = tools.isMobile()
      m.redraw()
  Text:Box()
  data:
    show:false
    linkid:0
    replyTo:""
    pid:null
    self:null

    height: Math.round document.documentElement.clientHeight*2/3
  method:
    showReply:->
  view:->
    _this = this
    m "",[
      #m Notice
      m Nav,
        style:
          height:"auto"
          background:"rgba(0,0,0,0.5)"
          display:if _this.data.show then "block" else "none"
          top: _this.data.height+"px"
          overflow:"auto"
        isBottom:yes
        ext:
          class:"animated pulse" #弹出动画
          ### onbeforeremove:(v)->
            v.dom.classList.add("zoomOut")
            new Promise (res,rej)->
              v.dom.addEventListener "animationend",res ###
      ,[
        # 拖动条
        m "",
          style:
            marginBottom:"0.5rem"
            background:"#000"
            height:"2rem"
            width:"100%"
            touchAction: "none"
            position:"relative"
            cursor:"row-resize"
          onmousedown:(e)-> 滑块调整开始监听("鼠标",this,e,_this)
          ontouchstart:(e)-> 滑块调整开始监听("触摸",this,e,_this)

          onmouseover:->
            @style.opacity = "0.8"
          onmouseout:->
            @style.opacity = "1"
        ,[
          for item in ["calc(50% - 2px)","calc(50% + 1px)"]
            m "span",
              style:
                background:"#eee"
                borderRadius:"0.3rem"
                height:"0.1rem"
                left:"calc(50% - 8px)"
                position:"absolute"
                width:"1.3rem"
                top:item

        ]
        # 底部容器
        m Container,[
          m "",
            style:
              display:"block"
          ,[
            # 工具栏
            if _this.data.linkid #如果有传入linkid，那么是回复，显示回复
              # 回复对象
              m Box,
                isBtn:yes
                color:"dark"
                onclick:->
                  _this.data.linkid = 0
                  _this.Text.data.value = ""
                  _this.data.show = no
              ,"回复给：#{_this.data.replyTo}（#{this.data.linkid}）【点击取消】"
            if _this.data.pid #如果有传入pid数据，那么是编辑而不是回复
              # 编辑对象
              m Box,
                isBtn:yes
                color:"dark"
                onclick:->
                  _this.data.pid = null
                  _this.Text.data.value = ""
                  _this.data.show = no
              ,"编辑："+_this.data.pid+"【点击取消】"

            # 提交按钮
            m Box,
              isBtn:yes
              color:"red"
              style:
                marginBottom:0
              onclick:->
                return if not isLogined()
                if m.route.get() isnt "/home" and _this.data.linkid is 0
                  m.route.set("/home")
                try
                  tmp = await m.request
                    method:"post"
                    url:"/api/posts/set"
                    body:
                      type:if _this.data.pid then "edit" else "post"
                      title:_this.Text.data.value.split("\n")[0].slice(0,50)
                      content:_this.Text.data.value
                      linkid:_this.data.linkid
                      pid:_this.data.pid #编辑帖子用
                  if !tmp.valid
                    return Notice.launch msg:tmp.msg
                  #刷新数据

                  if _this.data.linkid is 0
                    await homeData.fresh(
                      _this.data.linkid,
                      true,
                      _this.data.self?.data?.clickCount,
                      _this.data.self
                    )
                  else
                    await homeData.fresh(
                      _this.data.linkid,
                      false,
                      _this.data.self?.data?.clickCount,
                      _this.data.self
                    )
                    _this.method.showReply()

                  _this.data.pid = null
                  _this.data.show = no

                  _this.Text.data.value = ""
                catch err
                  console.log err
            ,"提交"

            # 高级模式
            ###
            m Box,
              isBtn:yes
              color:"dark"
              ext:
                onclick:->

                  Notice.launch
                    content:
                      oncreate:->
                        window.vditor = new Vditor "vditor",{}
                        console.log vditor
                      view:->
                        m "#vditor",[]
                    confirm:->
                        console.log window.vditor.getValue()

            ,"高级模式"
            ###
          ]

          # 编辑器
          m "",
            style:
              display:"grid"
              gridTemplateColumns:if not isMobile then "1fr 1fr" else "1fr"
              gridTemplateRows:"1fr 1fr" if isMobile
          ,[
            m _this.Text,
              style:
                bottom:0
                top:"50px"
                display:"block"
                resize:"none"
                minHeight:"10rem"
                height: "#{document.documentElement.clientHeight - _this.data.height - 110}px"
                marginBottom:"1rem"
              tagName: "textarea"
              placeholder:"""
              这里是输入框哦，隔壁是预览框
              您输入的第一行将会成为标题
              """
            m Box,
              color:"white"
              class:"article"
              style:
                overflow:"auto"
                display:"inline-block"
                height: "#{document.documentElement.clientHeight - _this.data.height - 110}px"
                marginBottom:"1rem"
              ext:
                onupdate:(e)->
                  e.dom.scrollTop = e.dom.scrollHeight
            ,m.trust format _this.Text.data.value
          ]

        ]
      ]
      m Box,
        color:if _this.data.show then "yellow" else "red"
        style:
          position:"fixed"
          right:"1rem"
          bottom:"1rem"
          borderRadius:"50%"
          width:"1.5rem"
          height:"1.5rem"
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
          cursor:"pointer"
          zIndex:"100"
          userSelect:"none"
        onclick:()->
          #isLogined() #判断是否登录
          _this.data.show = not _this.data.show
      ,[
        m "strong",if _this.data.show then "-" else "+"
      ]
    ]
