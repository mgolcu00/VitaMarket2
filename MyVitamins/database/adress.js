const { pool } = require('./connection');

const addAdress = (id, address, city, userId, callback) => {
    pool.query('INSERT INTO "public"."adress" (id,adress,city,user_id) VALUES ($1,$2,$3,$4)', [id, address, city, userId], (err, result) => {
        console.log(err, result);
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    })
}

const getAdressWithUserId = (userId, callback) => {
    pool.query('SELECT * FROM "public"."adress" WHERE user_id = $1', [userId], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    })
}

const getAdressWithId = (id, callback) => {
    pool.query('SELECT * FROM "public"."adress" WHERE id = $1', [id], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    })
}
const deleteAdress = (id, callback) => {
    pool.query('DELETE FROM "public"."adress" WHERE id = $1', [id], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    })
}
const updateAdress = (address, city, userId, callback) => {
    pool.query('UPDATE "public"."adress" SET "adress" = $1, "city" = $2 WHERE "user_id" = $3  ', [address, city, userId], (err, result) => {
        if (err) {
            callback(err, null);
        } 
            callback(null, result);
    })
}

const parseAdress = (result) => {
    let adress = {};
    if (result.rows.length > 0) {
        adress = result.rows[0];
    }
    return adress;
}
module.exports = {
    addAdress,
    getAdressWithUserId,
    getAdressWithId,
    deleteAdress,
    parseAdress,
    updateAdress
}