m = require "mithril"

posts = {}
for item in [0..99999]
  posts[item] = []

module.exports = 
  posts:posts
  fresh:(linkid,desc,limit,obj)->
    try
      tmp = await m.request
        method:"get"
        url:"/api/posts/get?#{if limit then "limit=#{limit}" else ""}#{if desc then "&&desc=true" else ""}&&linkid=#{linkid}"
      posts[linkid] = tmp.data
      if obj?.data?.allCount >= 0
        obj.data.allCount = tmp.allCount 

      (console.log tmp.msg) if not tmp.valid
    catch err
      console.log err
  getOne:(pid)->
    try
      tmp = await m.request
        method:"get"
        url:"/api/posts/get?pid=#{pid}"
      posts["0"] = [tmp.data]
      (console.log tmp.msg) if not tmp.valid
    catch err
      console.log err

