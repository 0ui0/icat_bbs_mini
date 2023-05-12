pathLib = require "path"
fs = require "fs-extra"
module.exports =
  method:"post"
  path:"/api/avatar/set"
  options:
    payload:
      output:"stream"
      #uploads:pathLib.resolve "./www/data/avatars"
      parse: true,
      allow: 'multipart/form-data'
      multipart: true
      maxBytes: 5*1024*1024

  handler:(req,h)->
    que = req.payload
    db = req.server.db
    auth = req.auth.credentials
    userImgDir = pathLib.resolve "www/data/"+auth.userDir+"/avatar"

    try

      await fs.mkdirs userImgDir

      # ===== 创建写入流
      writeStream = new fs.createWriteStream userImgDir+"/"+ tmp = new Date().getTime()  
      # 所有的头像流接入写入流    
      que.avatar.pipe writeStream
      # =====

      await db.icat_users_extend.update
        avatar: "/data/" + auth.userDir + "/avatar/" + tmp
      ,where:
        uid: auth.uid

      return
        valid:true
        msg:"上传成功"
    catch err
      console.log err
      return
        valid:false
        msg:"服务器内部错误"