module.exports =

  method:"get"
  path:"/api/auth/valid"
  handler:(req,h)->
    auth = req.auth.credentials
    return
      valid:true
      msg:"验证成功"
      data:auth.icat_users_extend