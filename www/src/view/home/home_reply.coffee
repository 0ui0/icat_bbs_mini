m = require "mithril"

# common
Box = require "../common/box"
Tag = require "../common/tag"
Img = require "../common/img"
user = require "../common/user"


#component
Editor = require "./home_editor"
opera = require "./home_opera"

#data
homeData = require "./home_data"

Reply = ->
  oninit:(v)->
    await homeData.fresh(v.attrs.self.pid)
  data:
    showMenu:false
    showReply:false
  view:(v)->
    _this = this
    self = v.attrs.self

    m ".animated.slideInDown",
      style:        
        marginLeft:if v.attrs.isThread then "" else "5rem"
      "data-key":self.pid
    ,[
      m "",
        style:
          display:"flex"
          alignItems:"center"
      ,[
        m Img,
          style:
            width:"4rem"
            boxShadow:"0.1rem 0.1rem 1rem rgba(0,0,0,0.3)"
          src:self.icat_users_extend.avatar||"./statics/default_avatar.jpg"
        m Box,
          style:fontSize:"1.2rem"
          color:if self.author is user.info?.user then "red" else "black"
        ,self.author

        

        m Box,
          style:
            #flexGrow: 1
            fontSize:"1.2rem"
            #overflowWrap:"break-word"
            #overflow:"auto"
            #width:"auto"
            maxWidth:"35rem"
            #whiteSpace:"normal"
            #maxHeight:"10rem"
        ,self.content

        if homeData.posts[v.attrs.self.pid].length > 0
          m Box,
            style:fontSize:"1.2rem"
            isBtn:yes
            onclick:-> _this.data.showReply = !_this.data.showReply
          ,if _this.data.showReply then "收起" else "↓评论#{homeData.posts[v.attrs.self.pid].length}" 

        m Box,
          style:fontSize:"1.2rem"
          isBtn:yes
          onclick:-> _this.data.showMenu = !_this.data.showMenu
        ,if _this.data.showMenu then "收起" else "操作"
      ]

      # 操作菜单
      m Box,
        isBlock:yes
        color:"white"
      ,[
        m Tag,
          isBtn:yes
          onclick:-> await opera.reply(self,_this)            
        ,"回复"
        m Tag,
          isBtn:yes
          onclick:-> await opera.edit(self)
        ,"编辑"
        m Tag,
          isBtn:yes
          onclick:-> await opera.del(self)
        ,"删除"
      ] if _this.data.showMenu

      # 递归回复
      if _this.data.showReply
        for item in homeData.posts[v.attrs.self.pid]
          m Reply,
            key:item.pid
            self:item     
    ] 


module.exports = Reply

