m = require "mithril"

Box = require "../common/box"
Img = require "../common/img"
Tag = require "../common/tag"

user = require "../common/user"
Notice = require "../common/notice"
Avatar = require "../zone/zone_avatar"



tools = require "../help/tools"

myVars = require "../help/myVars"

homeData = require "./home_data"


isMobile = tools.isMobile()

Search = new Box()

module.exports =
  oninit:(v)->
    showOrClose = ->
      if isMobile
        v.state.data.show = false
      else
        v.state.data.show = true
    window.addEventListener "resize",->
      isMobile = tools.isMobile()
      showOrClose()
      m.redraw()
    showOrClose()  
  data:
    show:true
    press:0
  view:->
    _this = this
    m Box,
        onbeforeremove:(v)->
          if isMobile
            v.dom.classList.add("slideOutLeft")
            new Promise (res,rej)->
              v.dom.addEventListener "animationend",res
        class:"animated #{if isMobile then "slideInLeft" else ""}" 
        style:{
          textAlign:"center"
          flex:1
          minWidth:"20.6rem"
          (if isMobile
            position:"fixed"
            top:0
            left:0
            bottom:0
            zIndex:"200"
            margin:0
            borderRadius:0
            background:"rgba(255,255,255,0.9)"
            width:"20.6rem")...            
        }

        color:"white"
    ,[
      m Box,
        color:"dark"
        style:
          position:"fixed"
          top:0
          left:0
          borderRadius:"5rem"
          width:"1rem"
          height:"1rem"
        onclick:-> _this.data.show = false
      ,"x" if isMobile
      m Img,
        src:user.info?.avatar ? "./statics/default_avatar.jpg"
        ext:
          onclick:->
            if !tools.isLogined()  then return
            Notice.launch
              content: Avatar
      m "", #标签容器
        style:
          display:"flex"
          justifyContent:"center"
          margin:"0.5rem auto"
      ,[
        m "",flex:1,[
          m Tag,
            isBlock:yes
            isWide:yes
            color:"red"
          , item.name
          m "span",
            style:
              color:"#cccccc"
              fontWeight:"blod"
              fontSize:"1.6rem"                
          ,if item.num then item.num else "-" 
        ] for item in [
          {name:"帖子",num: user.info?.postCount}
          {name:"回复",num: user.info?.replyCount}
          {name:"点赞",num: user.info?.likeCount}
        ]
      ] 
      

      
      # 搜索框
      m Box,
        style:
          padding:"0.5rem"
          borderRadius:"10rem"
      ,[
        m "",
          style:
            display:"flex"
            justifyContent:"center"
            alignItems:"center"
        ,[
          m Search,
            tagName:"input[type=text]"
            color:"white"
            placeholder:"搜索其实很简单"
            style:
              borderRadius:"10rem 0 0 10rem"
              width:"10rem"              
              margin:0
              height:"2rem"
          m Box,
            color:"deepBlue"
            isBtn:yes
            style:
              borderRadius:"10rem"
              borderRadius:"0 10rem 10rem 0"
              margin:0
              height:"2rem"
            onclick:->
              if Search.data.value is ""
                return
              else
                m.route.set "/search/#{Search.data.value}"              
          ,"搜索"
        ]
        
      ]

      # 释放压力
      m "",
        style:
          display:"grid"
          gridTemplateColumns:"1fr 1fr"
      ,[
        m Box,
          isBtn:yes
          style:
            marginTop:"1rem"
          oninit:-> _this.data.press = await myVars.get("press") if localStorage.user
          onclick:->
          
            return if not tools.isLogined()
            _this.data.press = "..."
            if not (await myVars.get("press")) or (await myVars.get("press"))*1 > 999
              await myVars.set("press",0)
            hello = await myVars.get("press")
            await myVars.set("press",hello*1+1)
            _this.data.press = await myVars.get("press")

        ,"戳我(#{_this.data.press ? 0})"

        # 压力排行榜
        m Box,
          isBtn:yes
          color:"dark"
          style:
            marginTop:"1rem"
          onclick:->
            unless tools.isLogined() then return
            rank = 
              list:[]
              oninit:(v)->
                try
                  tmp = await myVars.pull()
                  v.state.list = tmp.data.filter (item)->item.key is "press"
                catch err
                  console.log err
              view: ->
                _this = this
                m "",[
                  for item in (_this.list.sort (a,b)->b.value*1-a.value*1)
                    do ()->
                      m "",[
                        m Box,
                          color:if item.uid is user.info?.uid then "red" else "dark"
                        ,item.user
                        m Box,item.value
                      ]
                ]
            Notice.launch
              type: "peace"
              content: rank            
        ,"排行榜"
      ]

      # 帖子分类
      

    ] if _this.data.show 
      

