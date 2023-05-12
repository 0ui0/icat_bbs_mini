module.exports =
  method:"get"
  path:"/api/notice/getNew"
  handler:(req,h)->
    que = req.query
    db = req.server.db
    auth = req.auth.credentials
    try
      
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"