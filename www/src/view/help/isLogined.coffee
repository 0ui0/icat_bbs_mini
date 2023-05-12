user = require "../common/user"
Notice = require "../common/notice"

module.exports = ->
  if not user.info?.uid
    Notice.launch 
      msg:"请登录哈~"
    return false
  else
    return true