###
  @key que.key
  @value que.value
###
module.exports = 
  method:"post"
  path:"/api/vars/set"
  handler:(req,h)->
    que = req.payload
    db = req.server.db
    auth = req.auth.credentials
    try
      

      if not que.key or que.key is ""
        return
          valid:false
          msg:"请检查key"
      else if not que.value?
        return
          valid:false
          msg:"请检查value"
      else if que.value is ""
        if (await db.icat_vars.findOne
          where:
            uid:auth.uid+""
            key:que.key+"")

          await db.icat_vars.destroy
            where:
              uid:auth.uid+""
              key:que.key+""
        else
          return 
            valid:false
            msg:"变量不存在，无法删除"

        return
          valid:true
          msg:"已删除该变量"

      que.key = que.key + ""
      que.value = que.value + ""

      
      
      await db.icat_vars.findOrCreate
        where:
          uid:auth.uid
          key:que.key
        defaults:
          uid:auth.uid
          user:auth.user
          key:que.key
          value:que.value

      await db.icat_vars.update
        value:que.value
      ,where:
        key:que.key
        uid:auth.uid

      data = await db.icat_vars.findOne
        where:
          uid:auth.uid
          key:que.key
      return
        valid:true
        data: data.value

    catch err
      console.log err
      return 
        valid:false
        msg:"服务器内部错误"