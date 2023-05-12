pathLib = require "path"
fs = require "fs-extra"

module.exports = (uid)->
  try
    userDir = pathLib.resolve "./www/data/"+
      (tmp = 10**10 + uid*1 + "").slice(1,tmp.length).match(/../g).join("/")    
    await fs.mkdirs userDir

  catch err
    console.log err