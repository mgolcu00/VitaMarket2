const { pool } = require('./connection')
const products = require('./products')
const brands = require('./brands')
const vitamins = require('./vitamins')

// add active_material
const addActiveMaterial = (id, name, weight, callback) => {
    pool.query('INSERT INTO "public"."active_materials" (id,name,weight) VALUES ($1,$2,$3)', [id, name, weight], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, rows)
        }
    }
    )
}
const getActiveMaterial = (id, callback) => {
    pool.query('SELECT * FROM "public"."active_materials" WHERE id=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, rows)
        }
    }
    )
}

const addActiveMaterialToProduct = (id, name, weight, productId, callback) => {
    addActiveMaterial(id, name, weight, (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            pool.query('INSERT INTO "public"."active_materials_products" (active_material_id,product_id) VALUES ($1,$2)', [id, productId, rows.insertId], (err, rows) => {
                if (err) {
                    callback(err, null)
                } else {
                    callback(null, rows)
                }
            }
            )
        }
    })
}

const getActiveMaterialWithProductId = (id, callback) => {
    pool.query('SELECT * FROM "public"."active_materials_products" WHERE product_id = $1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            rows.rows.forEach(row => {
                getActiveMaterial(row.active_material_id, (err, activeMaterial) => {
                    if (err) {
                        callback(err, null)
                    } else {
                        callback(null, activeMaterial)
                    }
                })
            }
            )
        }
    })
}
const parseActiveMaterial = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}

const createBasket = (id, user_id, payment_method_id, callback) => {
    pool.query('INSERT INTO "public"."basket" (id,user_id,payment_method_id) VALUES ($1,$2,$3)', [id, user_id, payment_method_id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            getBasket(id, (err, data) => {
                if (err) {
                    callback(err, null)
                } else {
                    callback(null, parseBasket(data))
                }
            }
            )
        }
    }
    )
}
const parseBasket = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}

const getBasket = (id, callback) => {
    pool.query('SELECT * FROM "public"."basket" WHERE id=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, rows)
        }
    }
    )
}
const getBasketWithUserId = (user_id, callback) => {
    pool.query('SELECT * FROM "public"."basket" WHERE user_id=$1', [user_id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, rows)
        }
    }
    )
}
// get Basket Products
const getBasketProducts = (id, callback) => {
    pool.query('SELECT * FROM "public"."basket_products" WHERE basket_id=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            let productList = []
            rows.rows.forEach(row => {
                products.getProduct(row.product_id, (err, product) => {
                    if (err) {
                        callback(err, null)
                    } else {
                        productList.push(product)
                    }
                }
                )
            }
            )
        }
    }
    )
}
// get products from basket  with join basket_products
const getBasketProductsWithJoin = (id, callback) => {
    pool.query('SELECT * FROM "public"."products" INNER JOIN "basket_products" ON  "basket_products"."product_id" = "products"."id" WHERE "basket_id"=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, products.parseProduct(rows))
        }
    }
    )
}

const getVitaminsInBasket = (id, callback) => {
    pool.query('SELECT * FROM "public"."basket_products" WHERE basket_id=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            let vitaminList = []
            rows.rows.forEach(row => {
                console.log(row.product_id);
                vitamins.getVitamin(row.product_id, (err, vitamin) => {
                    if (err) {
                        callback(err, null)
                    } else {
                        console.log(vitamin);
                        vitaminList.push(vitamins.parseVitamin(vitamin))
                        if (vitaminList.length == rows.rows.length) {
                            callback(null, vitaminList)
                        }
                    }
                }
                )
            }
            )

        }
    }
    )
}




// add product to basket
const addProductToBasket = (id, product_id, callback) => {
    pool.query('INSERT INTO "public"."basket_products" (basket_id,product_id) VALUES ($1,$2)', [id, product_id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            getBasketProductsWithJoin(id, (err, data) => {
                if (err) {
                    callback(err, null)
                } else {
                    callback(null, data)
                }
            }
            )
        }
    }
    )
}

const addDealer = (id, name, email, password, callback) => {
    pool.query('INSERT INTO "public"."dealers" (id,name,email,password) VALUES ($1,$2,$3,$4)', [id, name, email, password], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            getDealer(id, (err, data) => {
                if (err) {
                    callback(err, null)
                } else {
                    callback(null, data)
                }
            }
            )
        }
    }
    )
}
const getDealer = (id, callback) => {
    pool.query('SELECT * FROM "public"."dealers" WHERE id=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)

        } else {
            callback(null, rows)
        }
    }
    )
}
const getDealerWithEmailAndPassword = (email, password, callback) => {
    pool.query('SELECT * FROM "public"."dealers" WHERE email=$1 AND password=$2', [email, password], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, parseDealer(rows))
        }
    }
    )
}
const parseDealer = (result) => {
    if (result.rows.length == 1) {
        return result.rows[0]
    } else if (result.rows.length > 1) {
        return result.rows
    } else {
        return null
    }
}

const getBrandsDealerWithJoin = (id, callback) => {
    pool.query('SELECT * FROM "public"."brands" INNER JOIN "dealers" ON "dealers"."id" = "brands"."dealer_id" WHERE "dealer_id"=$1', [id], (err, rows) => {
        if (err) {
            callback(err, null)
        } else {
            callback(null, brands.parseBrand(rows))
        }
    }
    )
}

const searchProducts = (query, callback) => {
    pool.query('SELECT * FROM "public"."search_products"($1)', [query], (err, rows) => {
        console.log('rows : '+JSON.stringify(rows)+'\nerr : '+err);
        if (err) {
            callback(err, null)
        } else {
           
            callback(null, products.parseProduct(rows))
        }
    }
    )
}

const removeProductFromBasket = (id, product_id, callback) => {
    pool.query('DELETE FROM "public"."basket_products" WHERE basket_id=$1 AND product_id=$2', [id, product_id], (err, rows) => {
        console.log(err + '\n' + rows);
        if (err) {
            callback(err, null)
        } else {
            getBasketProductsWithJoin(id, (err, data) => {
                if (err) {
                    callback(err, null)
                } else {
                    callback(null, data)
                }
            }
            )
        }
    }
    )
}



module.exports = {
    addActiveMaterial,
    getActiveMaterial,
    addActiveMaterialToProduct,
    getActiveMaterialWithProductId,
    parseActiveMaterial,
    createBasket,
    getBasket,
    getBasketWithUserId,
    getBasketProducts,
    addProductToBasket,
    getBasketProductsWithJoin,
    addDealer,
    getDealer,
    getBrandsDealerWithJoin,
    getDealerWithEmailAndPassword,
    parseBasket,
    getVitaminsInBasket,
    searchProducts,
    removeProductFromBasket
}