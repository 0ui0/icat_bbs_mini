m = require "mithril"

# common
Head = require "../common/head"
Foot = require "../common/foot"
Container = require "../common/container"
Tools = require "../help/tools"

# component
HomeLeft = require "./home_left"
HomeRight = require "./home_right"
HomeEditor = require "./home_editor"

Body =    
  view:(v)->
    m Container,
      style:
        display:"flex"
    ,[
      m HomeLeft
      m HomeRight,{
        v.attrs...
      }
      m HomeEditor
    ]
module.exports = 
  view:(v)->
    m "",[
      m Head
      m Body,{
        v.attrs...
      }
      m Foot
    ]