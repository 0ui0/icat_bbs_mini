// Generated by CoffeeScript 2.6.1
var Box, Container, Cropper, Notice, m, user;

m = require("mithril");

Cropper = require("cropperjs");

// common
user = require("../common/user");

Notice = require("../common/notice");

Container = require("../common/container");

Box = require("../common/box");

// component
module.exports = {
  data: {
    cropper: null
  },
  view: function(v) {
    var _this, ref, ref1;
    _this = this;
    return m("", [
      m("",
      {
        style: {
          display: "block",
          width: "15rem",
          height: "15rem"
        }
      },
      [
        m("img#img",
        {
          src: (ref = (ref1 = user.info) != null ? ref1.avatar : void 0) != null ? ref : "./statics/default_avatar.jpg",
          style: {
            maxWidth: "100%"
          }
        })
      ]),
      m(Box,
      {
        tagName: "input[type=file]",
        accept: "image/jpg,image/jpeg,image/png,image/PNG,image/gif,image/GIF",
        ext: {
          onchange: function(e) {
            var file,
      fileReader;
            file = e.target.files[0];
            fileReader = new FileReader();
            fileReader.readAsDataURL(file);
            return fileReader.onload = function(e) {
              var img;
              img = document.querySelector("#img");
              img.src = e.target.result;
              return _this.data.cropper = new Cropper(img,
      {
                aspectRatio: 1,
                viewMode: 2,
                preview: "",
                dragMode: "move"
              });
            };
          }
        }
      }),
      m(Box,
      {
        isBtn: true,
        onclick: function() {
          if (!_this.data.cropper) {
            return alert("请上传头像哈~");
          } else {
            return _this.data.cropper.getCroppedCanvas().toBlob(async function(blob) {
              var formData,
      tmp;
              formData = new FormData();
              formData.append("avatar",
      blob);
              tmp = (await m.request({
                url: "api/avatar/set",
                method: "post",
                body: formData
              }));
              if (!tmp.valid) {
                return alert(tmp.msg);
              } else {
                return alert("上传成功，请刷新Ctrl+f5刷新页面");
              }
            });
          }
        }
      },
      "提交")
    ]);
  }
};
