###
pid
###

module.exports =
  method:"post"
  path:"/api/posts/like"
  handler:(req,h)->
    try
      db = req.server.db
      que = req.payload
      auth = req.auth.credentials

      await db.icat_posts.update
        likes: 
          if tmp = (await db.icat_posts.findOne {where:pid:que.pid}).likes
            if (tmp = JSON.parse tmp)[auth.uid]
              delete tmp[auth.uid]
              JSON.stringify tmp
            else
              tmp[auth.uid] = auth.user
              JSON.stringify tmp
          else
            tmp = {}
            tmp[auth.uid] = auth.user
            JSON.stringify tmp
      ,
        where:
          pid: que.pid

      return
        valid:true
        msg:"赞操作成功"
      
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"

