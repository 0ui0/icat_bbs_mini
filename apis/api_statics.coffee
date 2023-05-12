module.exports =
  method:'get'
  path:"/{param*}"
  handler:
      directory:
          path:'.'
  options:
    auth:false
  
