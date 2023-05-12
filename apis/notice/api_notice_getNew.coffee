# 只获取最新消息未读消息数量

module.exports =
  method:"get"
  path:"/api/notice/getNew"
  handler:(req,h)->
    que = req.query
    db = req.server.db
    auth = req.auth.credentials
    try
      newNotice = await db.icat_notices.count
        where:
          receiverId: auth.uid
          readTime: null
      return
        valid: true
        msg:"获取最新消息成功"
        data:newNotice
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"