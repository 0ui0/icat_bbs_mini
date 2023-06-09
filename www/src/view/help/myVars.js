// Generated by CoffeeScript 2.6.1
var MyVars, m;

m = require("mithril");

MyVars = class MyVars {
  constructor() {}

  async set(key, value) {
    var err, tmp;
    try {
      tmp = (await m.request({
        method: "post",
        url: "/api/vars/set",
        body: {
          key: key,
          value: value
        }
      }));
      if (!tmp.valid) {
        console.log(tmp.msg);
      }
      return this[key] = tmp.data;
    } catch (error) {
      err = error;
      return console.log(err);
    }
  }

  async get(key) {
    var err, tmp;
    try {
      if (!(this != null ? this[key] : void 0)) {
        tmp = (await m.request({
          method: "post",
          url: "/api/vars/get",
          body: {
            key: key
          }
        }));
        this[key] = tmp.data;
      }
      return this != null ? this[key] : void 0;
    } catch (error) {
      err = error;
      return console.log(err);
    }
  }

  async pull(where, limit) {
    var err, tmp;
    try {
      return tmp = (await m.request({
        method: "post",
        url: "api/vars/getMany",
        body: {
          where: where,
          limit: limit
        }
      }));
    } catch (error) {
      err = error;
      return console.log(err);
    }
  }

};

module.exports = new MyVars();
