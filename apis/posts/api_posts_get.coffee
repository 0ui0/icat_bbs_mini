###
  desc
  linkid
  limit
###

module.exports =
  method:"get"
  path:"/api/posts/get"
  options:
    auth:false
  handler:(req,h)->
    try
      db = req.server.db
      que = req.query
      auth = req.auth.credentials
      
      if que.pid #如果提供pid，说明需要返回单个帖子
        tmp = await db.icat_posts.findByPk que.pid,
          include: db.icat_users_extend

      else # 否则使用linkid查询帖子列表
        tmp = await db.icat_posts.findAll
          include: db.icat_users_extend
          where:
            linkid:if que.linkid then que.linkid*1 else 0
          order:[
            ["isTop","DESC"]
            ["pid",if que.desc then "desc" else "ASC"]
          ]
          limit: if que.limit then que.limit*1 else 999999

      return
          valid:true
          msg:"操作成功"
          data:tmp
          allCount:await db.icat_posts.count
            where:
              linkid: if que.linkid then que.linkid*1 else 0
      
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"

