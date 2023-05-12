m = require "mithril"
module.exports = 
  view:->
    m "style","""
    /*markdown 格式化*/
    .article img{
        border-radius: 0.3rem;
        max-width:80%;
    }
    .article h1{
        font-size:1.8rem;
    }
    .article h1:before{
        content:"";
        display:inline;
        background:#1a83e6;
        margin-right:1rem;

        border:4px solid #bb4344;
        border-radius: 3px;
        border-top:0;
        border-bottom:0; 
    }


    .article h2{
        font-size:1.7rem;
    }
    .article h2:before{
        content:"";
        display:inline;
        background:#1a83e6;
        margin-right:1rem;

        border:0.3rem solid #ffc116;
        border-radius: 0.3rem;
        border-top:0;
        border-bottom:0;
    }


    .article h3{
        font-size:1.6rem;
    }

    .article h3:before{
        content:"";
        display:inline;
        background:#1a83e6;
        margin-right:1rem;

        border:0.2rem solid #1a83e6;
        border-radius: 0.3rem;
        border-top:0;
        border-bottom:0;
    }


    .article h4,.article h5,.article h6{
        font-size:1.5rem;
    }
    .article p{
        padding-left: 1.2em;
        padding-right: 1.2rem;
        margin-block-start: 1rem;
        margin-block-end: 1rem;

    }
    .article ul{
        padding-left:1.8rem;
        padding-right: 1.8rem;
    }
    .article code{
        display:inline-block;
        background:rgb(53, 59, 70);
        color:#eee;
        border-radius:0.3rem;
        font-family: "微软雅黑";
        margin:0.2rem;
        font-size:1.3rem;
        text-indent: 0;
    }
    .article blockquote{
        margin:0
    }
    .article blockquote{
        padding:0.2rem;
        border-left:0.4rem solid #ccc;
        background:#f5f5f5;
        border-radius: 0.3rem;
        font-style:italic
    }
    """