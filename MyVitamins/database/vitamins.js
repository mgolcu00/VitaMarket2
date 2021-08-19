const { pool } = require('./connection');
const products = require('./products');

const addVitamin = (id, name, brand_id, price, weight, usage, callback) => {
    products.addProduct(id, name, brand_id, price, (err, result) => {
        if (err) {
            callback(err, null);
        } else {
            pool.query('INSERT INTO "public"."vitamins" (product_id,weight,usage) VALUES ($1,$2,$3)', [id, weight, usage], (err, result) => {
                if (err) {
                    callback(err, null);
                } else {
                    callback(null, result);
                }
            });
        }
    });
};
const getAllVitamins = (callback) => {
    pool.query('SELECT * FROM "public"."vitamins"', (err, result) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, result);
        }
    });
}
const deleteVitamin = (id, callback) => {
    pool.query('DELETE FROM "public"."vitamins" WHERE product_id=$1', [id], (err, result) => {
        if (err)
            callback(err, null);
        else
            callback(null, result);
    });
}
const updateVitamin = (id, name, brand_id, price, weight, usage, callback) => {
    products.updateProduct(id, name, brand_id, price, (err, result) => {
        if (err) {
            callback(err, null);
        } else {
            pool.query('UPDATE "public"."vitamins" SET weight=$2,usage=$3 WHERE product_id=$1', [id, weight, usage], (err, result) => {
                if (err) {
                    callback(err, null);
                } else {
                    callback(null, result);
                }
            });
        }
    });
}

const getVitamin = (id, callback) => {
    pool.query('SELECT * FROM "public"."vitamins" WHERE product_id=$1', [id], (err, result) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, result);
        }
    });
}


const parseVitamin = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
};
module.exports = {
    addVitamin,
    getAllVitamins,
    parseVitamin,
    deleteVitamin,
    updateVitamin,
    getVitamin
};
