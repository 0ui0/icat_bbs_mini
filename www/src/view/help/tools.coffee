
m = require "mithril"
Notice = require "../common/notice"
user = require "../common/user"



isMobile = -> 
  pageWidth = document.documentElement.clientWidth
  if pageWidth <= 768 then true else false
isTablet = ->
  pageWidth = document.documentElement.clientWidth
  if (768 < pageWidth <= 1024) then true else false
isDesktop = ->
  pageWidth = document.documentElement.clientWidth
  if (1024 < pageWidth <= 1215) then true else false
isWideScreen = ->
  pageWidth = document.documentElement.clientWidth
  if(1215 < pageWidth <= 1407) then true else false
isFullHD = ->
  pageWidth = document.documentElement.clientWidth
  if pageWidth > 1407 then  true else false

isLogined = ->
  if  not user.info?.uid
    Notice.launch 
      msg:"请登录哈~"
    return false
  else
    return true

startMove = (obj,target,prop,fnEnd)->

  clearInterval timer

  timer = setInterval ->

    if prop is "opacity"
      current = Math.round getComputedStyle(obj,false)[prop]    
    else 
      current = parseInt getComputedStyle(obj,false)[prop]

    speed = ( target - current ) / 6
    speed = if speed > 0 then Math.ceil(speed) else Math.floor(speed)


    if Math.abs(current-target) <= speed      
      clearInterval timer
      obj.style[prop] = 
        if prop is "opacity"
          target
        else
          target + "px"
      if fnEnd
        fnEnd()
    else
      obj.style[prop] = 
        if prop is "opacity"
          current + speed
        else
          current + speed + "px"
      #console.log "当前位置"+current,"目标"+target
    m.redraw()
  ,30

module.exports = 
  isMobile:isMobile
  isTablet:isTablet
  isDesktop:isDesktop
  isWideScreen:isWideScreen
  isFullHD:isFullHD
  isLogined:isLogined
  startMove:startMove