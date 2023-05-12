m = require "mithril"

# common
Box = require "../common/box"
Img = require "../common/img"
Tag = require "../common/tag"
user = require "../common/user"
Notice = require "../common/notice"

#help
Tools = require "../help/tools"
format = require "../help/format"



# component
Reply = require "./home_reply"
Editor = require "./home_editor"
opera = require "./home_opera"



# data
homeData = require "./home_data"

module.exports = ->
  oninit:(v)->
    await homeData.fresh(v.attrs.self.pid)
    if v.attrs.pid  
      v.state.data.showMore = true
  data:
    showMore:false #显示全文
    showReply:false
  method:
    showReply:(v)->
      v.state.data.showReply = !v.state.data.showReply
  view:(v)->
    _this = this
    self = v.attrs.self
    
    m "",
      class: if v.attrs.pid then "" else "animated slideInDown"
      "data-key": self.pid
    ,[
        m "",
        style:        
          display:"grid"
          gridTemplateColumns:"22% 1fr"
        ,[
          m "left",
            style:
              textAlign:"center"
          ,[
            # 用户名
            m Box,
              color: if self.author is user.info?.user then "red" else "black"
              isBlock:yes
            ,self.author
            # 头像
            m Img,
              style:
                width:"calc(100% - 4rem)"
                borderRadius:"0.5rem"
              src: self.icat_users_extend.avatar ? "./statics/default_avatar.jpg"
              ext:
                onclick:->console.log self
            # 勋章
            m Tag,
              styleExt:
                display:"flex"
                justifyContent:"center"
                flexWrap:"wrap"
                padding:0
              color:"white"
            ,[
              m Tag,color:"yellow","喵"
              m Tag,color:"red","会"
              m Tag,color:"deepBlue","管" if self.icat_users_extend.power > 90
            ]
          ]
          m "right",[
            # 帖子标题
            m Box,
              color:"dark"
              isBlock:yes
            ,m "a[href=#!/home/#{self.pid}]",style:color:"white",self.title
            # 帖子内容
            m Box,
              isBlock:yes
            ,[
              m "",
                style:
                  fontSize:"1rem"
              ,"最后编辑："+new Date(self.finallyTime).toLocaleString("chinese",{hour12:false})
              if self.content.length < 150
                m "",
                  class:"article"
                  style:
                    wordWrap:"break-word"
                    overflow:"auto"
                ,m.trust format self.content
              else
                [
                  m "",
                    class:"article"
                    style:
                      wordWrap:"break-word"
                      overflow:"auto"
                      maxHeight:"18rem" if not _this.data.showMore
                  ,m.trust format self.content
                  m "a",
                    onclick:->
                      _this.data.showMore = not _this.data.showMore
                  ,if _this.data.showMore then "[收起Biu]" else "[展开Wiu]"
                ]
            ]
            # 编辑菜单
            m Box,
              isBlock:yes
            ,[
              m Tag,
                color:"white"
                isBtn:yes
                onclick:-> await opera.like(self)
              ,"赞"

              m Tag,
                color:"white"
                isBtn:yes
                onclick:-> await opera.edit(self)
              ,"编辑"

              m Tag,
                color:"white"
                isBtn:yes
                onclick:-> await opera.reply(self,_this)
              ,"回复"

              m Tag,
                color:"white"
                isBtn:yes
                onclick:-> await opera.del(self)
              ,"删除"

              m Tag,
                color:if self.isTop>0 then "yellow" else "white"
                isBtn:yes
                onclick:-> await opera.top(self)
              ,if self.isTop>0 then "取消置顶" else "置顶"

              
              if homeData.posts[v.attrs.self.pid][0]
                m Tag,
                  color:"white"
                  isBtn:yes
                  onclick:-> _this.method.showReply(v)
                ,"#{if _this.data.showReply then "( ๑ŏ ﹏ ŏ๑ )" else "|･ω･｀)"}"  

            ]      
          ]
        ]
        # 点赞显示区域
        m Box,
          isBlock:yes
          color:"white"
        ,[
          m Tag,
            color:"red"
            styleExt:
              marginRight:0
              borderRadius:"1rem 0 0 1rem"
          ,"赞"

          if self.likes
            Object.values(JSON.parse self.likes)?.map (item)->
              m Tag,
                color: "dark"
                styleExt:
                  marginLeft:0
                  marginRight:0
                  borderRadius:"0"
              ,item

          m Tag,
            color:"yellow"
            styleExt:
              marginLeft:0
              borderRadius:"0 1rem 1rem 0"
            ,"@"
        ]

        # 回复显示区域
        m "",
          style:
            display:"block"
            whiteSpace:"nowrap"
            overflow:"auto"
        ,[
          for item in homeData.posts[v.attrs.self.pid]
            m Reply,
              key:item.pid
              self:item
              isThread:yes
        ] if _this.data.showReply
        
        # 显示回复
        if homeData.posts[v.attrs.self.pid][0] and _this.data.showReply
          m Box,
            isBlock:yes
            isBtn:yes
            onclick:-> _this.method.showReply(v)
          ,"#{if _this.data.showReply then "( ๑ŏ ﹏ ŏ๑ )" else "|･ω･｀)"}" 

      ]