const crypto = require('crypto');
const config = require('./config.js')

const md5 = (str)=> {
    let obj = crypto.createHash('md5');
    obj.update(str);
    return obj.digest('hex');
}
const encrypt = (str)=> md5(md5(str)+config.key);

const iTry = async (fn)=>{
    try{
        return await fn()
    }catch(e){
        console.log(e)
        return {
            valid:false,
            msg:e
        }
    }
}

const fillZero = async(db)=>{
    try{
        await db.query(`update icat_users_extend set post_count=0 where post_count is null`)
        await db.query(`update icat_users_extend set reply_count=0 where reply_count is null`)
        await db.query(`update icat_users_extend set like_count=0 where like_count is null`)
        await db.query(`update icat_users_extend set favo_count=0 where favo_count is null`)
        await db.query(`update icat_users_extend set friend_count=0 where friend_count is null`)

    }catch(e){
        console.log(e)
    }finally{
        return true
    }
}

const updateCount = async(db,table,column,opera,id)=>{
    try{
        await db.query(`update ${table} set ${column} = ${column}${opera} where id=${id}`)
    }catch(e){
        console.log(e)
    }

}

const updateAllCount = async(db,id)=>{
    try{
        let posts = await db.query(`select * from icat_posts where id=${id}`)

        await updateCount(
            db,
            "icat_users_extend",
            "post_count",
            `-post_count+${posts.filter(item=>item.linkid === 0).length}`,
            id
        )

        await updateCount(
            db,
            "icat_users_extend",
            "reply_count",
            `-reply_count+${posts.filter(item=>item.linkid !== 0).length}`,
            id
        )

        let likeCount = await db.query(`select * from icat_posts`);
        likeCount = likeCount.map(item=>item.likes||"{}").filter(item=>{return new RegExp(`"${id}"`,"g").test(item)})

        await updateCount(
            db,
            "icat_users_extend",
            "like_count",
            `-like_count+${likeCount.length}`
            ,id
        )

        

    }
    catch(e){
        console(e)
    }
}

module.exports = {
    md5,
    encrypt,
    iTry,
    fillZero,
    updateCount,
    updateAllCount,
}