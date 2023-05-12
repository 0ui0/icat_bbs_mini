m = require "mithril"


# data
homeData = require "./home_data"

# common
Box = require "../common/box"

# component
Thread = require "./home_thread"

module.exports = 
  oninit: (v)->
    # 如果提供了帖子pid
    if v.attrs.pid
      await homeData.getOne(v.attrs.pid)
    # 如果提供了关键词
    else if v.attrs.word
      try
        tmp = await m.request
          method:"get"
          url:"/api/posts/ser?search=#{v.attrs.word}"
        return Notice({msg:tmp.valid}) if !tmp.valid      
        homeData.posts["0"] = tmp.data
      catch err
        console.log err
    # 否则首页
    else      
      await homeData.fresh(0,true,v.state.data.clickCount,v.state)
      clearInterval timer if timer
      timer = setInterval ->
        await homeData.fresh(0,true,v.state.data.clickCount,v.state) if v.attrs.pid
      ,5*60*1000
      
  data:
    allCount: 0
    clickCount: 5
  view: (v)->
    _this = this
    m "",
      style:
        flex:4
        width:"100%"
        #maxWidth:"73.3rem"
    ,[
      # 左右分栏
      for item in homeData.posts["0"]
        m Thread,
          key:item.pid
          self:item
          pid:v.attrs.pid
          word:v.attrs.word
      # 加载更多
      if not v.attrs.pid
        m Box,
          color:"yellow"
          isBlock:yes
          isBtn:yes
          onclick:->
            if _this.data.allCount > _this.data.clickCount
              await homeData.fresh(0,true,_this.data.clickCount+=5,_this)
            else
              clearInterval timer if timer
              timer = setInterval ->
                if document.querySelector("html").scrollTop > 0
                  document.querySelector("html").scrollTop -= (document.body.clientHeight - document.querySelector("html").scrollTop)/100
                else
                  clearInterval timer
              ,10

        ,if _this.data.allCount > _this.data.clickCount then "加载更多" else "到底啦，点击返回顶部"
    ] 


