m = require "mithril"

Box = require "./box"
Nav = require "./nav"
Dropdown = require "./dropdown"
Notice = require "./notice"
Css = require "./css"

user = require "./user"

HomeLeft = require "../home/home_left"

leftArr = [
  {
    name: "首页"
    url: "/home"
    focus: yes
  }
  ###
  {
    name: "空间"
    url: "/zone"
    focus: no
  }
  ###
]

User = new Box()
User = {...User}
Password = new Box()
Password = {...Password}


module.exports = 
  data: 
    loggedUser: null
    newNotice:0
  method:
    getNewNotice:null

  oninit:(v)->
    await user.fresh()

    for item in leftArr
      if item.url is m.route.get()        
        item.focus = yes
      else
        item.focus = no
    # 自动拉取新消息提醒
    if user?.info?.uid
      clearInterval timer if timer

      v.state.method.getNewNotice = ->
        newNotice = await m.request
          url:"/api/notice/getNew"
          method:"get"
        return Notice.launch msg:newNotice.msg if !newNotice.valid
        if newNotice.data > 0
          v.state.data.newNotice = newNotice.data
      await v.state.method.getNewNotice()
      timer = setInterval v.state.method.getNewNotice, 5*60*1000
    
  view: ->
    _this = this
    m "header",[
      m Notice
      m Css
      # 返回按钮
      
      # 导航
      m Nav,
        color: "yellow"
        isTop: yes
      ,[
        m Box,
          color:"black"
          isBtn:yes
          onclick:->
            HomeLeft.data.show = ! HomeLeft.data.show
        ,(document.querySelector "title").innerHTML

        m Box,
          color:"deepBlue"
          isBtn:yes
          onclick:->
            window.history.back()
        ,[
          m "strong","<"
        ]

        # 左边
        m "left",[
          leftArr.map (item)->
            m Box,
              color: if item.focus then "deepRed" else "dark"
              isBtn: yes
              onclick: ->
                m.route.set item.url             
            ,item.name         
        ]
        # 右边
        m "right",
          style:
            marginLeft:"auto"
        ,[
          m Dropdown,
            style:
              display:"grid"
              gridTemplateColumns:"repeat(2,120px)"
              gridTemplateRows:"repeat(2,1fr)"
            name1:if _this.data.newNotice > 0 then "*新消息" else "(○’ω’○)"
            name2:"(*≧m≦*)"
            color:"red"
            isClick:yes
            class:"animated pulse"
            child:(parent)->
              if !localStorage.user
                [
                  m User,
                    tagName:"input[type=text][placeholder=用户名]"
                    style:
                      width:"auto"
                      display:"block"
                      border:"0.1rem solid #aaaaaa"

                  m Password,
                    tagName:"input[type=password][placeholder=密码]"
                    style:
                      width:"auto"
                      display:"block"
                      border:"0.1rem solid #aaaaaa"

                  m Box,
                    style:
                      display:"block"
                    color:"red"
                    isBtn:yes
                    onclick:(__this,e,v,self)->
                      #校验用户名和密码

                      #等待发送请求
                      tmp = await m.request
                        method:"post"
                        url:"/sign"
                        body:
                          user: User.data.value
                          password: Password.data.value

                      # 如果验证未通过，返回并提示信息
                      Notice.launch msg: tmp.msg if tmp.msg isnt "登录成功"
                      
                      if not tmp.valid                      
                        return 

                      # 写入缓存，登录成功                   
                      if tmp.data
                        localStorage.user = tmp.data.user
                        _this.data.loggedUser = tmp.data 
                        user.info = tmp.data
                      
                  ,"注册/登录"
                  
                  m Box,
                    style:
                      display:"block"
                    color:"dark"
                    isBtn:yes
                    onclick:(__this,e,v,self)-> parent.data.showMenu = no                    
                  ,"收起"
                  
                ]
              else
                [
                  m Box,
                    color:"dark"
                    isBtn:yes
                  ,"欢迎：#{user.info.user}"
                  m Box,
                    color:"red"
                    isBtn:yes
                    onclick:->
                      try
                        tmp = await m.request
                          method:"get"
                          url:"/logout"
                                                
                        localStorage.removeItem "user"
                        _this.data.loggedUser = null
                        user.info = {}

                      catch err
                        console.log err            

                  ,"登出"
                  m Box,
                    color: "yellow" if _this.data.newNotice > 0
                    isBtn:yes
                  ,if _this.data.newNotice > 0 then "消息(#{_this.data.newNotice})" else "消息"
                  m Box,isBtn:yes,"签到"
                ]
        ]     
      ]
    ]