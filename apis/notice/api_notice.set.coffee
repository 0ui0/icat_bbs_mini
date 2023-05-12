###

###

module.exports =
  method:"post"
  path:"/api/notice/set"
  handler:(req,h)->
    que = req.payload
    db = req.server.db
    auth = req.auth.credentials
    try
      tmp = await db.icat_notices.create
        sender: auth.icat_users_extend.user 
        senderId: auth.uid
        receiver: que.receiver
        receiverId: (await db.icat_users.findOne where:user:que.receiver).uid
        msgType: que.msgType
        msgAction: que.msgAction
        msgContent: que.msgContent
      return
        valid: true
        msg:"消息发送成功"

    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"