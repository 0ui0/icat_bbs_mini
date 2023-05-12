module.exports =
  method: "post"
  path: "/api/posts/del"
  handler: (req,h)->
    que = req.payload
    auth = req.auth.credentials
    db= req.server.db

    t = await db.mysql.transaction()

    try    
      
      fn = (pid)->
        tmp = await db.icat_posts.findAll
          where:
            linkid:que.pid
        ,transaction:t
        for item in tmp
          if not tmp[0]
            await fn(tmp.pid)
        await db.icat_posts.destroy
          where:
            pid:pid
        ,transaction:t
        await t.commit()

      isMine = await db.icat_posts.findOne
        where:
          pid: que.pid
          author: auth.user
        ,transaction:t
      if isMine || auth.icat_users_extend.power > 90
        await fn(que.pid)        
        return
          valid:true
          msg:"删除成功"
      else
        return
          valid:false
          msg:"权限不足"

    catch e
      await t.rollback()
      console.log(e)


      

