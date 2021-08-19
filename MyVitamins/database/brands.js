const { pool } = require('./connection')

const addBrand = (id, brandName, rate, callback) => {
    pool.query(`INSERT INTO "public"."brands" (id,name,rate) VALUES ($1,$2,$3)`, [id, brandName, rate], (err, result) => {
        if (err) {
            callback(err,null)
        } else {
            callback(null, result)
        }
    })
}
const getBrand = (id, callback) => {
    pool.query(`SELECT * FROM "public"."brands" WHERE id = $1`, [id], (err, result) => {
        if (err) {
            callback(err,null)
        } else {
            callback(null, result)
        }
    })
}
const getAllBrands = (callback) => {
    pool.query(`SELECT * FROM "public"."brands"`, (err, result) => {
        if (err) {
            callback(err,null)
        } else {
            callback(null, result)
        }
    })
}
const updateBrand = (id, brandName, rate, callback) => {
    pool.query(`UPDATE "public"."brands" SET name = $1, rate = $2 WHERE id = $3`, [brandName, rate, id], (err, result) => {
        if (err) {
            callback(err,null)
        } else {
            callback(null, result)
        }
    })
}
const deleteBrand = (id, callback) => {
    pool.query(`DELETE FROM "public"."brands" WHERE id = $1`, [id], (err, result) => {
        if (err) {
            callback(err,null)
        } else {
            callback(null, result)
        }
    })
}
const parseBrand = (result) => {
    if(result.rows.length == 1){
        return result.rows[0]
    }else if(result.rows.length  >1){
        return result.rows
    }else{
        return null
    }
}
module.exports = {
    addBrand,
    getBrand,
    getAllBrands,
    updateBrand,
    deleteBrand,
    parseBrand
}

