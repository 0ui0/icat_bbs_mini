db = require "./db_main"
{ Op } = require "sequelize"

# 更新统计


fn = ->
  t = await db.mysql.transaction() 

  try
    users = await db.icat_users.findAll
      attributes:["uid"]

    for item in users
      await db.icat_users_extend.update
        postCount: await db.icat_posts.count
          where:
            uid: item.uid
            linkid: 0
          , transaction:t
        replyCount: await db.icat_posts.count
          where:
            uid: item.uid
            linkid:
              [Op.ne]: 0
          , transaction: t
        likeCount: (Object.keys JSON.parse (await db.icat_posts.findOne
          attributes:["likes"]
          where:
            uid: item.uid)?.likes ? "{}").length
          , transaction:t
        friendCount: 0
      ,
        where:
          uid:item.uid
      , transaction:t
    await t.commit()
    console.log "已同步数据"
  catch err
    t.rollback()
    console.log err

setInterval fn,5*60*1000    

module.exports = fn

    

