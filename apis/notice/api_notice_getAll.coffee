###
  @offset 从哪里开始拉取
  @limit 拉取多少条消息
  @asc 顺序，默认倒序
###
module.exports =
  method:"get"
  path:"/api/notice/getAll"
  handler:(req,h)->
    que = req.query
    db = req.server.db
    auth = req.auth.credentials
    try
      newNotice = await db.icat_notices.findAll
        where:
          receiverId: auth.uid
        order:[
          ["ntceid",if que.asc then "ASC" else "DESC"]
        ]
        limit:que.limit||999999
        offset:que.offset||0
      return
        valid: true
        msg:"拉取消息列表成功"
        data:newNotice
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"