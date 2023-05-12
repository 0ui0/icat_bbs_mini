m = require "mithril"
class MyVars
  constructor:->
  set:(key,value)->
    try
      tmp = await m.request
        method: "post"
        url:"/api/vars/set"
        body:
          key:key
          value:value
      console.log tmp.msg if not tmp.valid
      @[key] = tmp.data 
    catch err
      console.log err

  get:(key)->
    try 
      if not @?[key] #如果没定义，从服务器拉取一次
        tmp = await m.request
          method:"post"
          url:"/api/vars/get"
          body:
            key:key
        @[key] = tmp.data
      return @?[key]
    catch err
      console.log err
  pull:(where,limit)->
    try
      tmp = await m.request
        method:"post"
        url:"api/vars/getMany"
        body:
          where:where
          limit:limit
    catch err
      console.log err
module.exports = new MyVars()
