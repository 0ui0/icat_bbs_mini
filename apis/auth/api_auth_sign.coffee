config = require "../../config/config"
mkUsrDir = require "../tools/tool_mkUsrDir"

md5 = config.md5


tmpUsers = {}
timer = null


module.exports = 
  method: "post"
  path: "/sign"
  options:
    auth: false
  handler: (req,h)->
    try

      db = req.server.db
      que = req.payload

      user = await db.icat_users.findOne
        include: db.icat_users_extend
        where:
          user: que.user
          password: md5((md5 que.password)+config.key)

      
      
      if user
        # 登录成功，写入cookie
        setSession = ->
          await req.cookieAuth.set
            uid: user.uid
            user: user.user
        await setSession()
        return 
            valid:true
            msg:"登录成功"
            data:user.icat_users_extend

      else
        # 如果临时数组有用户，且密码正确 则写入用户到数据库
        if tmpUsers[que.user] and tmpUsers[que.user] is que.password
          try
            t = await db.mysql.transaction()

            user = await db.icat_users.create
              user: que.user
              password: que.password
            ,transaction:t
            
            userExt = await db.icat_users_extend.create
              uid: user.uid
              user: user.user
              group: "user"
              power: 10
              createdTime: new Date().getTime()
            ,transaction:t
          
            # 创建用户专属目录
            await mkUsrDir user.uid

            await req.cookieAuth.set
              uid: user.uid
              user: user.user
            
            delete tmpUsers[que.user]
            clearTimeout timer
            await t.commit()
            return 
              valid: true
              msg: "账号已激活"
              data: userExt

          catch err
            await t.rollback()
            console.log err

        else # 如果没有，尝试创建临时用户 
          if (await db.icat_users.count where:user:que.user) > 0 || tmpUsers[que.user]
            return
              valid:false
              msg:"用户名已存在或即将被销毁或密码不正确"
          else
            # 校验用户名和密码
            if not (que.user or que.password)
              return
                valid:false
                msg:"用户名或密码为空"
            else if !/^\w{4,16}$/.test que.user
              return
                valid:false
                msg:"用户名不合法（长度：4-16字符；数字、字母、下划线）"
            else if /['|"]/.test que.password
              return  
                valid:false
                msg:"密码不合法（请勿使用引号）"
                        
            tmpUsers[que.user] = que.password
            time = 10
            timer = setTimeout ->
              clearTimeout timer if timer
              delete tmpUsers[que.user]
            ,time*1000
            return
              valid:true
              msg:"注册成功，请在#{(time/60).toFixed(2)}分钟内登录，否则账户将被销毁噢"
          
            








###
      tmpUsers = tmpUserss.find (item)->
        item.user is que.user and item.password is que.password
            
      user = await db.icat_users.findAll {
        where:
          user:que.user
      }
      # 如果数据库中没有 但是临时数组中有，那么写入数据库并登录
      if tmpUsers and !user[0]
        #写入数据库

        await db.icat_users.create 
          user: tmpUsers.user
          password: tmpUsers.password

        writeUser = await db.icat_users.findAll where: user: tmpUsers.user
        
        await db.icat_users_extend.create
          uid: writeUser[0].uid
          user: tmpUsers.user
          group: "user"
          power: 10
          createdTime: new Date().getTime()

        #写入登录缓存,登录成功
        await req.cookieAuth.set uid: writeUser[0].uid

        return 
          valid:true
          msg:"登录成功"
          data: await db.icat_users_extend.findOne
            where:
              uid: writeUser[0].uid
          
      else if user[0]
        # 用户存在准备登录 校验密码
        if user[0].password != md5(md5(que.password+config.key))
          return
            vaid:false
            msg:"密码不正确"
        else
          await req.cookieAuth.set uid: user[0].uid
          console.log(user[0].uid)
          return 
            valid:true
            msg:"登录成功"
            data: await db.icat_users_extend.findOne
              where:
                uid: user[0].uid


        #否则准备注册
      else if not (que.user or que.password)
        return
          valid:false
          msg:"用户名或密码为空"
      else if !/^\w{4,16}$/.test que.user
        return
          valid:false
          msg:"用户名不合法（长度：4-16字符；数字、字母、下划线）"
      else if /['|"]/.test que.password
        return  
          valid:false
          msg:"密码不合法（请勿使用引号）"
      else
        if !(tmpUserss.filter (item)=>item.user == que.user)[0]

          tmpUserss.push {
            user: que.user
            password: que.password
            timer: setTimeout ->
              tmpUserss = tmpUserss.filter (item)-> if item.user then item.user != que.user
              console.log "已清除用户"
            , 10*1000
          } 
        else
          return
            valid:false
            msg:"用户名冲突，请修改用户名"
        console.log tmpUserss
        return
          valid:true
          msg:"注册成功，请在五分钟内登录，否则账户将自动销毁"
###    
    catch e
      console.log(e)
    


  

