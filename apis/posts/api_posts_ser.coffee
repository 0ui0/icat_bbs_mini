
{ Op } = require "sequelize"
module.exports =
  method:"get"
  path:"/api/posts/ser"
  options:
    auth:false
  handler:(req,h)->
    try
      db = req.server.db
      que = req.query
      auth = req.auth.credentials
      
      tmp = await db.icat_posts.findAll
        include: db.icat_users_extend
        where:
          content:
            [Op.regexp]: que.search||"''"
        order:[
          ["isTop","DESC"]
          ["pid","DESC"]
        ]
      return
          valid:true
          msg:"搜索成功"
          data:tmp
      
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"

