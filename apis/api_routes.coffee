fs = require "fs-extra"
pathLib = require "path"

module.exports = (server)->

  await server.route require "./api_statics"

  await server.route require "./auth/api_auth_login"
  await server.route require "./auth/api_auth_sign"
  await server.route require "./auth/api_auth_valid"
  await server.route require "./auth/api_auth_logout"

  await server.route require "./posts/api_posts_set"
  await server.route require "./posts/api_posts_get"
  await server.route require "./posts/api_posts_del"
  await server.route require "./posts/api_posts_ser"
  await server.route require "./posts/api_posts_top"
  await server.route require "./posts/api_posts_like"

  await server.route require "./notice/api_notice_getNew"
  await server.route require "./notice/api_notice_getAll"

  await server.route require "./avatar/api_avatar_set"

  await server.route require "./vars/api_vars_set"
  await server.route require "./vars/api_vars_get"
  await server.route require "./vars/api_vars_getMany"
  



  

  

  