m = require "mithril"
module.exports = {
  info:null  
  fresh:->
    try
      tmp = await m.request
        method:"get"
        url:"api/auth/valid"
      if tmp.valid
        @info = tmp.data
        localStorage.setItem "user",tmp.data.user
    catch err
      console.log "===验证错误==="
      console.log err
      console.log JSON.stringify err
      console.log "============="
      @info = null
      localStorage.removeItem("user")
}