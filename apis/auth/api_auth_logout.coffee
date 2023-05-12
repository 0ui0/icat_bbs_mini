
module.exports =
  method:"get"
  path:"/logout"
  handler:(req,h)->
    
    req.cookieAuth.clear()

    return 
      valid:true
      msg:"登出成功"
    
