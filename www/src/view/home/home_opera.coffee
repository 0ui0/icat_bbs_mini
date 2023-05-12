m = require "mithril"

Editor = require "./home_editor"
homeData = require "./home_data"

Notice = require "../common/notice"

isLogined = (require "../help/tools").isLogined


module.exports = 
  del:(self)->
    return if not isLogined()
    Notice.launch 
      msg:"确定要删除吗？（注意这将同时清空所有回复）"
      confirm:->
        try
          tmp = await m.request
            method:"post"
            url:"/api/posts/del"
            body:
              pid:self.pid
          await homeData.fresh(self.linkid,(if self.linkid is 0 then true else false),0,self)    
          if not tmp.valid
            Notice.launch msg:tmp.msg              
        catch err
          console.log err
  edit:(self)->
    return if not isLogined()
    fn = ->
      Editor.data.show = yes
      Editor.Text.data.value = self.content
      Editor.data.pid = self.pid                                  
      Editor.data.linkid = self.linkid #更新用
      Editor.data.self = self

    if Editor.Text.data.value.length>0
      Notice.launch 
        msg:"即将清空已编辑内容，要继续吗？"
        confirm:->fn()
        calcel:->
    else
      fn()

  reply:(self,_this)->
    return if not isLogined()
    fn = ->
      Editor.data.show = yes
      Editor.data.linkid = self.pid
      Editor.data.replyTo = self.author
      Editor.data.pid = null
      Editor.data.self = self
      Editor.Text.data.value = ""
      Editor.method.showReply = ->
        _this.data.showReply = yes
        _this.data.showMenu = no

    if Editor.Text.data.value.length>0
      Notice.launch 
        msg:"即将清空已编辑内容，要继续吗？"
        confirm:->fn()
        calcel:->
    else
      fn()
  top:(self)->
    return if not isLogined()
    try
      tmp = await m.request
        method:"post"
        url:"/api/posts/top"
        body:
          pid:self.pid
      return Notice.launch msg:tmp.msg if !tmp.valid
      await homeData.fresh(self.linkid,if self.linkid is 0 then true else false)
    catch err
      console.log err

  like:(self)->
    return if not isLogined()
    try
      tmp = await m.request
        method:"post"
        url:"/api/posts/like"
        body:
          pid:self.pid
      return Notice.launch msg:tmp.msg if !tmp.valid
      await homeData.fresh(self.linkid,if self.linkid is 0 then true else false)
    catch err
      console.log err
      
    



    

  

    

  