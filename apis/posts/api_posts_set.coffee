###
  type:edit/post
  title:
  content:
  linkid:
###

module.exports =
  method:"post"
  path:"/api/posts/set"
  handler:(req,h)->
    try
      db = req.server.db
      que = req.payload
      auth = req.auth.credentials


      if que.content.length is 0
        return
          valid:false
          msg:"你还没写东西呀"

      if que.type is "post"
        post = await db.icat_posts.create
          uid: auth.uid
          author: auth.user
          title: que.title
          content: que.content
          create_time: new Date().getTime()
          finally_time: new Date().getTime()
          linkid: que.linkid

        # 发送消息列表
        if que.linkid isnt 0

          postUp = await db.icat_posts.findOne
            where:
              pid:que.linkid

          await db.icat_notices.create
            sender: auth.user
            senderId: auth.uid
            receiver:  postUp.author
            receiverId: postUp.uid
            msgType: "系统"
            msgAction:"回复了"
            msgContent: JSON.stringify
              thread : que.linkid
              reply : post.pid
          
        
      else if que.type is "edit"

        if auth.icat_users_extend.power < 90
          await db.icat_posts.update
            uid: auth.uid
            title: que.title
            content:que.content
            finally_time: new Date().getTime()
          ,
            where:
              pid:que.pid
              uid:auth.uid 
        else
          await db.icat_posts.update
            uid: auth.uid
            title: que.title
            content:que.content
            finally_time: new Date().getTime()
          ,
            where:
              pid:que.pid



      return
          valid:true
          msg:"操作成功"
      
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"

