###
  pid
###

module.exports =
  method:"post"
  path:"/api/posts/top"
  handler:(req,h)->
    db = req.server.db
    que = req.payload
    auth = req.auth.credentials
    try
      if auth.icat_users_extend.power >= 90
        await db.icat_posts.update
          isTop:if  (await db.icat_posts.findByPk que.pid).isTop > 0 then 0 else 1
        ,
          where:
            pid:que.pid

        return
            valid:true
            msg:"置顶成功"
      else
        return
          valid:false
          msg:"权限不足"
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"

