m = require "mithril"


Home = require "./view/home/home_main"
Zone = require "./view/zone/zone_main"

Avatar = require "./view/zone/zone_avatar"
Test = require "./view/common/test"



m.route document.body,"/home"
  ,
    "/home":Home
    "/home/:pid":
      render:(v)->
        m Home,
          pid:v.attrs.pid
    "/zone":Zone
    "/search/:word": 
      render:(v)->
        m Home, 
          word:v.attrs.word
    "/avatar":Avatar
    "/test":Test
      
  











  


