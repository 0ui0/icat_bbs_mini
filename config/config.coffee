fs = require 'fs'
crypto = require 'crypto'

module.exports =
  port: 8080 #服务器监听端口
  host: "localhost" #主机地址
  key: "dfls$ls*fFwBxm<920dSwcScF7&s/4k@k!)VxFs奇怪的乱七八糟的内容" #key，双重密码md5加密使用，请务必更换
  public: "www" #静态路由目录
  md5:(str)->
    obj = crypto.createHash "md5"
    obj.update str
    obj.digest "hex"
  db:
    connectionLimit: 10 #连接池最大连接数
    host: "localhost" #数据库主机
    port: 3306 #数据库端口
    user: "test" #数据库用户名
    database: "test" #数据库名
    password: "test", #数据库密码



