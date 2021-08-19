const { pool } = require('./connection');

const addProduct = (id, name, brand_id, price, callback) => {
    pool.query('INSERT INTO "public"."products" (id,name,brand_id,price) VALUES ($1,$2,$3,$4)', [id, name, brand_id, price], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    });
};
const getProducts = (callback) => {
    pool.query('SELECT * FROM "public"."products"', (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    });
}
const getProduct = (id, callback) => {
    pool.query('SELECT * FROM "public"."products" WHERE id=$1', [id], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    });
}

const updateProduct = (id, name, brand_id, price, callback) => {
    pool.query('UPDATE "public"."products" SET name=$1,brand_id=$2,price=$3 WHERE id=$4', [name, brand_id, price, id], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    });
}

const deleteProduct = (id, callback) => {
    pool.query('DELETE FROM "public"."products" WHERE id=$1', [id], (err, result) => {
        if (err) {
            callback(err, null);
        }
        callback(null, result);
    });
}

const parseProduct = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}

module.exports = {
    addProduct,
    getProducts,
    getProduct,
    updateProduct,
    deleteProduct,
    parseProduct
}
