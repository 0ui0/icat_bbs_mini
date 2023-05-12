m = require "mithril"
Cropper = require "cropperjs"

# common
user = require "../common/user"
Notice = require "../common/notice"
Container = require "../common/container"
Box = require "../common/box"

# component

module.exports = 
  data:
    cropper:null
  view: (v)->
    _this = this
    m "",[
      m "",
        style:
          display:"block"
          width:"15rem"
          height:"15rem"
      ,[
        m "img#img",
          src: user.info?.avatar ? "./statics/default_avatar.jpg"
          style:
            maxWidth:"100%"          
      ]
      m Box,
        tagName:"input[type=file]"
        accept:"image/jpg,image/jpeg,image/png,image/PNG,image/gif,image/GIF"
        ext:
          onchange:(e)->
            file = e.target.files[0]
            fileReader = new FileReader()
            fileReader.readAsDataURL file

            fileReader.onload = (e)->

              img = document.querySelector("#img")
              img.src = e.target.result

              _this.data.cropper = new Cropper img,
                aspectRatio:1
                viewMode:2
                preview:""
                dragMode:"move"
      m Box,
        isBtn:yes
        onclick:->
          if not _this.data.cropper
            alert "请上传头像哈~"
          else
            _this.data.cropper.getCroppedCanvas().toBlob (blob)->
              formData = new FormData()
              formData.append "avatar",blob

              tmp = await m.request
                url:"api/avatar/set"
                method:"post"
                body:formData
              if not tmp.valid
                alert(tmp.msg) 
              else
                alert("上传成功，请刷新Ctrl+f5刷新页面")
      ,"提交"
    ]
    


