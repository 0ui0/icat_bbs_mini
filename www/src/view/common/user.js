// Generated by CoffeeScript 2.6.1
var m;

m = require("mithril");

module.exports = {
  info: null,
  fresh: async function() {
    var err, tmp;
    try {
      tmp = (await m.request({
        method: "get",
        url: "api/auth/valid"
      }));
      if (tmp.valid) {
        this.info = tmp.data;
        return localStorage.setItem("user", tmp.data.user);
      }
    } catch (error) {
      err = error;
      console.log("===验证错误===");
      console.log(err);
      console.log(JSON.stringify(err));
      console.log("=============");
      this.info = null;
      return localStorage.removeItem("user");
    }
  }
};
