// Generated by CoffeeScript 2.6.1
/*
  pid
*/
module.exports = {
  method: "post",
  path: "/api/posts/top",
  handler: async function(req, h) {
    var auth, db, err, que;
    db = req.server.db;
    que = req.payload;
    auth = req.auth.credentials;
    try {
      if (auth.icat_users_extend.power >= 90) {
        await db.icat_posts.update({
          isTop: ((await db.icat_posts.findByPk(que.pid))).isTop > 0 ? 0 : 1
        }, {
          where: {
            pid: que.pid
          }
        });
        return {
          valid: true,
          msg: "置顶成功"
        };
      } else {
        return {
          valid: false,
          msg: "权限不足"
        };
      }
    } catch (error) {
      err = error;
      console.log(err);
      return {
        valid: false,
        msg: "服务器内部错误"
      };
    }
  }
};
