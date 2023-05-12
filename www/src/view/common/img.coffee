m = require "mithril"

module.exports = 
  view: (v)->
    m "img",{
        style:{
          margin:"10px"
          width:"calc(100% - 5rem)"
          boxShadow:"0.1rem 0.1rem 1rem rgba(0,0,0,0.5)"
          verticalAlign:"middle"
          borderRadius:"50%"
          v.attrs.style...
        }
        src:v.attrs.src
        v.attrs.ext...
    }