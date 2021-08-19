const { pool } = require('./connection');
const products = require('./products');

const addProtein = (id, name, brand_id, price, weight, _for, rate, type_id, callback) => {
    products.addProduct(id, name, brand_id, price, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            pool.query(`INSERT INTO "public"."proteins"  VALUES ($1,$2,$3,$4,$5)`, [id, weight, _for, rate, type_id], (err, res) => {
                if (err) {
                    callback(err, null);
                } else {
                    callback(null, res);
                }
            });
        }
    });
};

const getProteins = (callback) => {
    pool.query('SELECT * FROM "public"."proteins"', (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}
const getProtein = (id, callback) => {
    pool.query('SELECT * FROM "public"."proteins" WHERE id=$1', [id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}
const updateProtein = (id, name, brand_id, price, weight, _for, rate, type_id, callback) => {
    products.updateProduct(id, name, brand_id, price, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            pool.query(`UPDATE "public"."proteins" SET weight=$2,for=$3,rate=$4,type_id=$5 WHERE id=$1`, [id, weight, _for, rate, type_id], (err, res) => {
                if (err) {
                    callback(err, null);
                } else {
                    callback(null, res);
                }
            });
        }
    });
}
const deleteProtein = (id, callback) => {
    pool.query('DELETE FROM "public"."proteins" WHERE id=$1', [id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}

const addProteinType = (id, name, callback) => {
    pool.query('INSERT INTO "public"."types" (id,name) VALUES ($1,$2)', [id, name], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
           getProteinType(id, callback);
        }
    });
}

const getProteinTypes = (callback) => {
    pool.query('SELECT * FROM "public"."types"', (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}

const getProteinType = (id, callback) => {
    pool.query('SELECT * FROM "public"."types" WHERE id=$1', [id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}

const setProteinType = (id, type_id, callback) => {
    pool.query('UPDATE "public"."proteins" SET type_id=$1 WHERE id=$2', [type_id, id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}
const deleteProteinType = (id, callback) => {
    pool.query('DELETE FROM "public"."types" WHERE id=$1', [id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}
const getProteinsByType = (type_id, callback) => {
    pool.query('SELECT * FROM "public"."proteins" WHERE type_id=$1', [type_id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}

// get proteins by brand with inner join
const getProteinsByBrand = (brand_id, callback) => {
    pool.query('SELECT * FROM "public"."proteins" INNER JOIN "public"."products" ON "public"."proteins"."product_id"="public"."products"."id" WHERE "public"."products"."brand_id"=$1', [brand_id], (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
}

const parseProtein = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}
const parseProteinType = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}


module.exports =
{
    addProtein,
    getProteins,
    getProtein,
    updateProtein,
    deleteProtein,
    addProteinType,
    getProteinTypes,
    getProteinType,
    setProteinType,
    deleteProteinType,
    getProteinsByType,
    getProteinsByBrand,
    parseProtein,
    parseProteinType
}
