const path = require('path');


module.exports = {
  entry: './www/src/main.js',
  output: {
    path: path.resolve("./www/bin"),
    filename: 'main.js',
  },
  /*
  module:{
    rules:[
      {
        test: /\.m?js$/,
          exclude: /(node_modules|bower_components)/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
      },
    ]
  },
  */
};