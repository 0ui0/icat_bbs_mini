// Generated by CoffeeScript 2.6.1
/*
  @key que.key
  @value que.value
*/
module.exports = {
  method: "post",
  path: "/api/vars/set",
  handler: async function(req, h) {
    var auth, data, db, err, que;
    que = req.payload;
    db = req.server.db;
    auth = req.auth.credentials;
    try {
      if (!que.key || que.key === "") {
        return {
          valid: false,
          msg: "请检查key"
        };
      } else if (que.value == null) {
        return {
          valid: false,
          msg: "请检查value"
        };
      } else if (que.value === "") {
        if ((await db.icat_vars.findOne({
          where: {
            uid: auth.uid + "",
            key: que.key + ""
          }
        }))) {
          await db.icat_vars.destroy({
            where: {
              uid: auth.uid + "",
              key: que.key + ""
            }
          });
        } else {
          return {
            valid: false,
            msg: "变量不存在，无法删除"
          };
        }
        return {
          valid: true,
          msg: "已删除该变量"
        };
      }
      que.key = que.key + "";
      que.value = que.value + "";
      await db.icat_vars.findOrCreate({
        where: {
          uid: auth.uid,
          key: que.key
        },
        defaults: {
          uid: auth.uid,
          user: auth.user,
          key: que.key,
          value: que.value
        }
      });
      await db.icat_vars.update({
        value: que.value
      }, {
        where: {
          key: que.key,
          uid: auth.uid
        }
      });
      data = (await db.icat_vars.findOne({
        where: {
          uid: auth.uid,
          key: que.key
        }
      }));
      return {
        valid: true,
        data: data.value
      };
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
