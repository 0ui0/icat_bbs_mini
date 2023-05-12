
m = require "mithril"

class Chest
  
  constructor: (size,site,color,group)->

    @size = {size...}
    @site = {site...}
    @color = color || "gray"
    @group = group if group
    @main = {}  
    @defaultSite = {}

  create: (div)->
      isShadow = false
      isTopest = false
      _this = this
      @main = 
        view: => 
          m "",
            style:
              position:"absolute"
              width:"#{_this.size.w}px"
              height:"#{_this.size.h}px"
              left:"#{_this.site.x}px"
              top:"#{_this.site.y}px"
              backgroundColor:@color
              borderRadius:"0.5rem"
              boxShadow: if isShadow
                "1px 1px 10px rgba(0,0,0,0.5)"
              else
                "none"
              zIndex: if isTopest
                999
              else
                "auto"
            
            onmousedown:(e)->
              e = event || e
              isShadow = true
              isTopest = true

              getMouse = (e)->
                e = event || e
                x:e.clientX
                y:e.clientY

              mouse = getMouse e
              defaultSite = 
                x:_this.site.x 
                y:_this.site.y
              

              document.addEventListener "mousemove",mouseMove=(e)->

                

                newMouse = getMouse e
                dis = 
                  x: mouse.x - newMouse.x 
                  y: mouse.y - newMouse.y 
                
                
                _this.site.x -= dis.x 
                _this.site.y -= dis.y

                m.redraw()    
                
                mouse = getMouse e
              mouseUp = null
              document.addEventListener "mouseup",mouseUp=(e)->

                if _this.group 
                  disArr = _this.group.map (item)-> 
                    tmp = [_this.site.x,_this.site.y]["<->"]([item.x,item.y])
                    return tmp.to_i()

                  _this.newSite _this.group[disArr.indexOf disArr.min()],->
                    isShadow = false
                    isTopest = false

                else
                  _this.newSite defaultSite,->
                    isShadow = false
                    isTopest = false

                document.removeEventListener "mousemove",mouseMove
                document.removeEventListener "mouseup",mouseUp

                
                  
          ,["abc"]

  newSite: (json,fnEnd)->
    _this = this

    run = (target,site,prop)->
      clearInterval timer
      
      timer = setInterval ->

          speed = (target-site[prop])/8    
          speed = if speed > 0 then Math.ceil(speed) else Math.floor(speed)

          if Math.abs(site[prop]-target) <= Math.abs(speed)
            site[prop] = target
            fnEnd() if fnEnd
            clearInterval timer            
          else
            site[prop] += speed

          m.redraw()
      ,30

    run(json.x,@site,"x") if json.x?    
    run(json.y,@site,"y") if json.y?

  newSize: (json)->
    @size.w = json.w if json.w
    @size.h = json.h if json.h


module.exports = Chest