m = require "mithril"

# common
Head = require "../common/head"
Foot = require "../common/foot"
Notice = require "../common/notice"
Container = require "../common/container"
Box = require "../common/box"
tools = require "../help/tools"
Chest = require "./zone_chest"








# component
numOfX = 0
remainSpace = 0
spaceWidth = 0

rectSize = 
  width:100
  height:100

getPos = (order,rectSize,contentWidth,reduceRate)->
  {width,height} = rectSize
  reduceRate = 1 || reduceRate #调整比例
  # x轴的磁贴数量
  numOfX = Math.floor(contentWidth / width)-reduceRate
  # 剩余空间长度
  remainSpace = (contentWidth % width) + width*reduceRate
  # 间距
  spaceWidth = Math.round remainSpace / (numOfX-1)

  return 
    x: (order % numOfX)*(width+spaceWidth)
    y: Math.floor(order / numOfX)*(height+spaceWidth)

chestGroupPos = [0..39].map (item)-> getPos(item,rectSize,960)

chestGroupPos_bak = chestGroupPos.map (item)->
  x:item.x 
  y:item.y

chestGroup = chestGroupPos.map (item,index)->
  tmp = new Chest({w:100,h:100},item,"red",chestGroupPos_bak)
  tmp.create()
  return tmp


Coordinate =
  blocks: []
  xW:100
  yW:100
  xNum:0
  yNum:0
  space:0

  map:(site)->
    x: site.x * (@xW+ @space)
    y: site.y * (@yW + @space)
  remap:(site)->
    x: site.x / (@xW+ @space)
    y: site.y / (@yW+ @space)

  add: (div,sizeNum,site)->
    position = {position...}
    size = switch sizeNum
      when 1 then {w:100,h:100}
      when 2 then {w:200+@space,h:100}
      when 3 then {w:200+@space,h:200+@space}

    if site
      site = @map site,size
    else 
      if @blocks.length is 0
        site = 
          x:0
          y:0
      else
        leftItem = @blocks[@blocks.length-1]

        transBlocks = @blocks.slice().sort (a,b)=>
          a = @remap a.site
          b = @remap b.site
          a.y - b.y
        console.log @blocks

        #pp transBlocks

        

        

        upItem = transBlocks[transBlocks.length-1]
        
        



        # 如果是最后一个元素，那么下移一行，横坐标归零，纵坐标+1
        if @remap(leftItem.site).x+(leftItem.size.w/@xW).to_i()+1*(size.w/@xW).to_i() > @xNum
          site = {}
          site.x = 0
          site.y = @map 
            x: 0
            y: (@remap(leftItem.site).y+1)
          .y
        else
          site = 
            x: leftItem.site.x + leftItem.size.w + @space
            y: upItem.site.y + upItem.size.h + @space
          

  

    chest = new Chest size,site
    chest.create(div)
    @blocks.push chest

  


  oninit:(v)->
    # 转化坐标系
    _this = @__proto__
    _this.xNum = (v.attrs.width / @xW).to_i() - 1
    _this.yNum = (v.attrs.height / @yW).to_i() - 1

    # this的指向的是实例框架内部生成的实例，所以要访问修改原型
    _this.space = ((v.attrs.width - _this.xNum*@xW)/(_this.xNum-1)).to_i()

    
  view: (v)->
    _this = this
    m "",
      style:
        position:"relative"
        width: v.attrs.width + 'px'
        height: v.attrs.height + 'px'
    ,[
      (@blocks.map (item)=>
        m item.main
      )if @blocks.length >= 0
      
    ]




  

tiles = 
  avatar:
    key:1
    pos:
      x:0
      y:0
    view:(v)->
      return m "span",
        style:
          position:"relative"
      ,"头像"
  message:
    key:2
    pos:
      x:50
      y:50
    view:(v)->
      return m "span",
        style:
          position:"relative"
      ,"头像"

Body =
  view:(v)->
    _this = this
    m "",[
      
      m Container,[
        m "","个人中心"
        ### m "",
          style:
            display:"block"
            position:"relative"
            height:"600px"   
        ,[
          chestGroup.map (item)->m item.main    
        ] ###
        m Coordinate,
          width:960
          height:500
        m "button",
          onclick:->
            item1 = 
              view:(v)-> m "",
                style:
                  color:"white"
                  fontSize:"16px"
              ,v.children
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),2
            Coordinate.add m(item1.to_s()),2
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),3
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),3
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),2
            Coordinate.add m(item1.to_s()),1
            Coordinate.add m(item1.to_s()),3
            Coordinate.add m(item1.to_s()),1



        ,"按钮"

      ]
    ]

module.exports = 
  view: (v)->
    _this = this
    m "",[
      m Head
      m Body
      m Foot
    ]
    


