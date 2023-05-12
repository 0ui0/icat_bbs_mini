m = require "mithril"

###
  v.attrs.style = {}
  v.attrs.color = "red||blue||green||pink..."
###
module.exports = ->
  data:
    value:""
  oninit:(v)->
    v.state.data.value = v.attrs.value ? ""
  view: (v) ->
    _this = this
    m v.attrs.tagName ? "",{
      class:v.attrs.class
      style: {
        display:if v.attrs.isBlock then "block" else "inline-block"
        margin:"0.5rem"
        padding:"1rem"        
        background: switch v.attrs.color
          when "red" then "#bb4344" 
          when "deepRed" then "#a5000c"
          when "dark" then "#333333" 
          when "yellow" then "#ffdb66" 
          when "sliver" then "#c0c0c0" 
          when "black" then "#000000" 
          when "white" then "#ffffff" 
          when "green" then "#00d1b3"
          when "deepYellow" then "#ab8829"
          when "deepBlue" then "#5171b3"
          else "#eeeeee"      
        color: switch v.attrs.color
          when "red" then "#ffffff"
          when "deepRed" then "#ffffff"
          when "dark" then "#ffffff" 
          when "yellow" then "#5f4905" 
          when "sliver" then "#333333" 
          when "black" then "#ffffff" 
          when "white" then "#333333" 
          when "green" then "#ffffff"
          when "deepYellow" then "#ffffff"
          when "deepBlue" then "#ffffff"
          else "#000000"
        border:"none"
        cursor:"pointer" if v.attrs.isBtn
        textAlign:"center" if v.attrs.isBtn
        boxShadow: "0 0 1rem rgba(0,0,0,0.05)"
        borderRadius: "0.5rem"
        wordWrap:"break-word"  
        v.attrs.style...
      }
      onmouseover:(e,a)->
        @style.opacity = "0.8" if v.attrs.isBtn
        v.attrs.onmouseover? @,e,v,_this
      onmouseout:(e)->
        @style.opacity = "1" if v.attrs.isBtn
        v.attrs.onmouseout? @,e,v,_this
      onclick: (e)->
        v.attrs.onclick? @,e,v,_this
      
      # 表单型属性 必须被new才可使用
      oninput: (e)->
        if (switch e.target.type
          when "text" then true
          when "textarea" then true
          when "password" then true
          )
          _this.data.value = e.target.value 
        v.attrs.oninput? @,e,v,_this

      value: @data.value
      contenteditable: v.attrs.contenteditable
      placeholder:v.attrs.placeholder

      v.attrs.ext...
    }
    ,[
      v.children...
    ]