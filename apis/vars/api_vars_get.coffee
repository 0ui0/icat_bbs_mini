###
  @key que.key
  @value que.value
###
module.exports = 
  method:"post"
  path:"/api/vars/get"
  handler:(req,h)->
    que = req.payload
    db = req.server.db
    auth = req.auth.credentials
    try
      data = await db.icat_vars.findOne
        where:
          uid: auth.uid
          key: que.key      
      return
        valid:true
        data: data?.value ? undefined

    catch err
      console.log err
      return 
        valid:false
        msg:"服务器内部错误"