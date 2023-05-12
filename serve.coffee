Hapi = require("@hapi/hapi")
pathLib = require("path")
config = require("./config/config")
db = require("./database/db_main")
tools = require("./config/tools")
routes = require("./apis/api_routes")

init = ->
  server = new Hapi.server
    port: config.port
    host: config.host
    routes:
      files:
        relativeTo: pathLib.resolve config.public    
  server.db = db

  # plugins
  await server.register require "@hapi/inert"
  await server.register require "@hapi/cookie"

  # auth strategy
  server.auth.strategy "session","cookie",
    cookie:
      name: "session-id"
      password: "!ufWx&3*xkW2x@#vslwon*9XlauPxWvZ<>0>>9s"
      isSecure: no
    validateFunc: (req,sess) ->
      try
        user = await db.icat_users.findOne
          where:
            uid: sess.uid
          include:db.icat_users_extend
        if not user
          return valid: false
        else
          return
            valid: true
            credentials: {
              userDir:(tmp = 10**10 + user.uid*1 + "").slice(1,tmp.length).match(/../g).join("/")
              user.dataValues...
            }
      catch e
        console.log e

  # default session
  server.auth.default "session"
  # all routes
  await routes(server) 

  # start server
  await server.start()
  console.log "server start at #{server.info.uri}"

init()



