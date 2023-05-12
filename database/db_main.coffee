{ Sequelize, DataTypes } = require 'sequelize'
config = require "../config/config"
pathLib = require "path"
fsp = (require "fs").promises


###
  @用户表       icat_users
  @用户扩展表   icat_users_extend
  @帖子表      icat_posts
  @设置表      icat_options
  @消息表      icat_notices
  @标签表      icat_tags
###

mysql = new Sequelize {
  database:config.db.database
  username:config.db.user
  password:config.db.password
  port:config.db.port
  dialect:"mysql"
  logging:(msg)->
    try
      #await fsp.appendFile pathLib.resolve("./database/db_log.sql"),msg
    catch err
      console.log err
}

icat_users={}
icat_users_extend={}
icat_posts={}
icat_options={}
icat_notices={}
icat_tags={}
icat_tasks={}
icat_vars={}

init = async = -> 

  icat_users = mysql.define 'icat_user',{

    uid:{
      type: DataTypes.INTEGER.UNSIGNED
      allowNull: no
      primaryKey: yes
      autoIncrement:yes
    }

    user:{
      type: DataTypes.STRING
      allowNull: no
      #unique:yes
    }
    password:{
      type: DataTypes.STRING
      allowNull: no
      set:(value)->        
        # 二次
        this.setDataValue 'password',config.md5((config.md5 value)+config.key)
    }

  }

  icat_users_extend = mysql.define 'icat_users_extend',{
    uextid:{
      type: DataTypes.INTEGER.UNSIGNED
      allowNull: no
      primaryKey: yes
      autoIncrement: yes
    }
    uid:{
      type: DataTypes.INTEGER.UNSIGNED
      allowNull: no
      unique:yes
    }
    user:{
      type: DataTypes.STRING
      allowNull: no
      #unique:yes
    }
    credit:{
      type: DataTypes.FLOAT
      defaultValue:0  
    }
    group:{
      type: DataTypes.STRING
      allowNull: no

    }
    power:{
      type: DataTypes.INTEGER
      allowNull: no
    }
    createdTime: {
      type: DataTypes.DATE
      allowNull:no
      defaultValue: DataTypes.NOW
    }
    name: DataTypes.STRING
    avatar: DataTypes.TEXT
    mail: DataTypes.STRING
    sex: {
      type: DataTypes.BOOLEAN
      defaultValue: 0,
    }
    age: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue: 0,
    }
    brithday: {
      type: DataTypes.DATE
      defaultValue: DataTypes.NOW
    }
    introduction:DataTypes.TEXT
    qq: DataTypes.STRING
    wechat: DataTypes.STRING
    ip: DataTypes.STRING
    postCount: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue:0
    }
    replyCount: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue:0
    }
    likeCount: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue:0
    }
    favoriteCount: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue:0
    }
    friendCount: {
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue:0
    }    

  },{freezeTableName: yes}

  icat_users.hasOne icat_users_extend,
    foreignKey: "uid"
    onDelete: "CASCADE"
    allowNull: "false"
  
  icat_users_extend.belongsTo icat_users,
    foreignKey: "uid"

  

  icat_posts = mysql.define "icat_post",{
    pid:{
      type: DataTypes.INTEGER.UNSIGNED
      autoIncrement: yes
      allowNull: no
      primaryKey: yes
    }
    uid:{
      type: DataTypes.INTEGER.UNSIGNED
      allowNull: no
    }
    author:{
      type: DataTypes.STRING
      allowNull: no
    }
    title:{
      type: DataTypes.STRING
      allowNull: no
    }
    content:{
      type: DataTypes.TEXT
      allowNull: no
    }
    likes:{
      type: DataTypes.TEXT
      defaultValue :"{}"
    }
    createTime:{
      type:DataTypes.DATE
      allowNull: no
      defaultValue: DataTypes.NOW
    }
    finallyTime:{
      type:DataTypes.DATE
      allowNull: no
      defaultValue: DataTypes.NOW
    }
    linkid:{
      type:DataTypes.INTEGER.UNSIGNED
      allowNull: no
    }
    isTop:{
      type:DataTypes.INTEGER
      defaultValue: 0
    }
    block:{
      type:DataTypes.INTEGER
    }
    tags:{
      type:DataTypes.TEXT  #json
    }


  }

  icat_users_extend.hasMany icat_posts,
    foreignKey: "uid"
    sourceKey: "uid"
    onDelete: "CASCADE"

  icat_posts.belongsTo icat_users_extend,
    foreignKey: "uid"

  icat_options = mysql.define "icat_option",{
    optid:{
      type: DataTypes.INTEGER.UNSIGNED
      primaryKey:yes
      autoIncrement:yes
      allowNull:no
    }
    key:{
      type: DataTypes.STRING
      allowNull:no
    }
    name:{
      type: DataTypes.STRING
      allowNull:no
    }
    value:{
      type: DataTypes.TEXT
    }
  }

  icat_notices = mysql.define "icat_notice",{
    ntceid:{
      type: DataTypes.INTEGER.UNSIGNED
      primaryKey:yes
      autoIncrement:yes
      allowNull:no
    }
    ### senderId:{
      type: DataTypes.INTEGER
      allowNull:no
    } ###
    sender:{
      type: DataTypes.STRING
      allowNull:no
    }
    ### receiverId:{
      type: DataTypes.INTEGER
      allowNull:no
    }  ###
    receiver:{
      type: DataTypes.STRING
      allowNull:no
    }
    msgType:{
      type: DataTypes.STRING
      allowNull:no
    }
    msgAction:{
      type: DataTypes.STRING
      allowNull:no
    }
    msgContent:{
      type: DataTypes.TEXT
      allowNull:no
    }
    sendTime:{
      type: DataTypes.STRING
      allowNull:no
      defaultValue:new Date().getTime()
    }
    readTime:{
      type: DataTypes.STRING
    }
  }

  icat_users_extend.hasMany icat_notices,
    sourceKey:"uid"
    foreignKey:
      name:"receiverId"
      allowNull:no  
    

    
  icat_notices.belongsTo icat_users_extend,
    sourceKey:"uid"
    foreignKey:
      name:"receiverId"
      allowNull:no  
  
  # 由于sequelize框架问题，实际上只使用下面两条
  icat_users_extend.hasMany icat_notices,
    sourceKey:"uid"
    foreignKey:
      name:"senderId"
      allowNull:no   

    
  icat_notices.belongsTo icat_users_extend,
    sourceKey:"uid"
    foreignKey:
      name:"senderId"
      allowNull:no


  icat_tags = mysql.define "icat_tag",{
    tagid:{
      type: DataTypes.INTEGER.UNSIGNED
      primaryKey:yes
      autoIncrement:yes
      allowNull:no
    }
    name:{
      type: DataTypes.STRING
      allowNull:no
    }
    type:{
      type: DataTypes.STRING
      allowNull:no
      defaultValue:"tag"
    }
    description:{
      type: DataTypes.STRING
    }
    count:{
      type: DataTypes.INTEGER
      allowNull:no
      defaultValue:0
    }
    order:{
      type: DataTypes.INTEGER
      defaultValue:0
    }
    parent:{
      type: DataTypes.INTEGER.UNSIGNED
      allowNull:no
      defaultValue:0
    }
  }

  icat_tags.belongsToMany(icat_posts,{through:"icat_conPostsAndTags"})
  icat_posts.belongsToMany(icat_tags,{through:"icat_conPostsAndTags"})

  icat_tasks = mysql.define "icat_task",
    taskid:
      type: DataTypes.INTEGER.UNSIGNED
      primaryKey:yes
      autoIncrement:yes
      allowNull:no    
    type:
      type: DataTypes.STRING
      allowNull:no
    # 发新贴thread、回复reply、点赞like、签到
    name:
      type: DataTypes.STRING
      allowNull:no    
    description:
      type: DataTypes.TEXT
    startTime:
      type: DataTypes.STRING
      allowNull: no
    stopTime:
      type: DataTypes.STRING
      allowNull: no
    actionCount:
      type: DataTypes.INTEGER.UNSIGNED
      defaultValue: 0
    

  icat_vars = mysql.define "icat_var",
    varid:
      type: DataTypes.INTEGER.UNSIGNED
      primaryKey:yes
      autoIncrement:yes
      allowNull:no    
    uid:
      type: DataTypes.INTEGER
      allowNull:no
    user:
      type: DataTypes.STRING
      allowNull:no
    key:
      type: DataTypes.STRING
      allowNull:no
    value:
      type: DataTypes.TEXT
      allowNull:no 

  
  await mysql.sync {alter:yes}
  #await mysql.sync {force:yes}
  #console.log (await icat_users.findAll({include:icat_users_extend}))





(->
  await init()
  # 更新统计
  dbUpdate = require "./db_update"
  await dbUpdate()
)()

module.exports = {
  mysql
  icat_users
  icat_users_extend
  icat_posts
  icat_notices
  icat_options
  icat_tags
  icat_tasks
  icat_vars
}

