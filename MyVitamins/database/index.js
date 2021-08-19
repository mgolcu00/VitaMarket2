const users = require('./users');
const adress = require('./adress');
const brands = require('./brands');
const vitamins = require('./vitamins');
const products = require('./products');
const proteins = require('./proteins');
const rest = require('./rest');
const UUID = require('uuid-int');
const seed = 511;
const generator = UUID(seed);

const generateId = () => {
    return generator.uuid() % 1000000;
};


const login = (username, password, callback) => {
    users.getUserWithEmailAndPassword(username, password, (user) => {
        if (user) {
            if (user.rowCount > 0) {
                callback(null, users.parseUser(user));
            } else {
                callback("Kullanıcı bulunamadı", null);
            }
        } else {

            callback("Kullanıcı Bulunamadı", null);
        }
    });
};

const register = (name, password, email, callback) => {
    users.addUser(generateId(), name, password, email, (user) => {
        if (user) {
            callback(null, users.parseUser(user));
        } else {
            callback("Kullanıcı Kaydedilemedi", null);
        }
    });
};

const addAdress = (userId, address, city, callback) => {
    adress.addAdress(generateId(), address, city, userId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, adress.parseAdress(res));
        }
    });
};

const getAdress = (userId, callback) => {
    adress.getAdressWithUserId(userId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, adress.parseAdress(res));
        }
    });
};
const updateAdress = ( _adress, city,userId, callback) => {
    console.log(_adress, city, userId);
    adress.updateAdress(_adress, city, userId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const addBrand = (brandName, callback) => {
    brands.addBrand(generateId(), brandName, 0, (err, res) => {

        if (err) {
            callback(err, null);
        } else {
            callback(null, brands.parseBrand(res));
        }
    });
};
const getAllBrands = (callback) => {
    brands.getAllBrands((err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, brands.parseBrand(res));
        }
    });
};
const getBrand = (brandId, callback) => {
    brands.getBrand(brandId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, brands.parseBrand(res));
        }
    });
};

const deleteBrand = (brandId, callback) => {
    brands.deleteBrand(brandId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const updateBrand = (brandId, brandName, rate, callback) => {
    brands.updateBrand(brandId, brandName, rate, (err, res) => {
        console.log(err, res);
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const updateBrandRate = (brandId, rate, callback) => {
    var brand = ''
    brands.getBrand(brandId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            brand = brands.parseBrand(res);
            brand.rate = rate;
            brands.updateBrand(brandId, brand.name, brand.rate, (err, res) => {
                if (err) {
                    callback(err, null);
                } else {
                    brands.getBrand(brandId, (err, res) => {
                        if (err) {
                            callback(err, null);
                        } else {
                            callback(null, brands.parseBrand(res));
                        }
                    }
                    );
                }
            });
        }
    });
};

const addVitamin = (name, brand_id, price, weight, usage, callback) => {
    vitamins.addVitamin(generateId(), name, brand_id, price, weight, usage, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, vitamins.parseVitamin(res));

        }
    });
};
const deleteVitamin = (vitaminId, callback) => {
    vitamins.deleteVitamin(vitaminId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};
const updateVitamin = (vitaminId, name, brand_id, price, weight, usage, callback) => {
    vitamins.updateVitamin(vitaminId, name, brand_id, price, weight, usage, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            getVitamin(vitaminId, (err, res) => {
                if (err) {
                    callback(err, null);
                }
                callback(null, res);
            }
            );
        }
    });
};
const getVitamin = (vitaminId, callback) => {
    vitamins.getVitamin(vitaminId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            console.log("vit : " + vit);
            var vit = vitamins.parseVitamin(res);
            products.getProduct(vit.product_id, (err, res) => {
                if (err) {
                    callback(err, null);
                } else {
                    vit.product = products.parseProduct(res);
                    callback(null, vit);
                }
            });
        }

    });
};

const getAllVitamins = (callback) => {
    vitamins.getAllVitamins((err, res) => {
        if (err) {
            callback(err, null);
        } else {
            var vits = vitamins.parseVitamin(res);
            if (vits instanceof Array) {
            } else {
                vits = [vits]
            }
            var newVitamins = [];
            vits.forEach((vitamin) => {
                products.getProduct(vitamin.product_id, (err, res) => {
                    if (err) {
                        callback(err, null);
                    } else {
                        vitamin.product = products.parseProduct(res);
                        newVitamins.push(vitamin);
                        if (newVitamins.length == vits.length) {
                            callback(null, newVitamins);
                        }
                    }
                });

            }
            );
        }
    });
};

const addProtein = (name, brand_id, price, weight, _for, rate, type_id, callback) => {
    proteins.addProtein(generateId(), name, brand_id, price, weight, _for, rate, type_id, (err, res) => {
        console.log(err, res);
        if (err) {
            callback(err, null);
        } else {
            callback(null, proteins.parseProtein(res));
        }
    });
};
const deleteProtein = (proteinId, callback) => {
    proteins.deleteProtein(proteinId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};
const updateProtein = (proteinId, name, brand_id, price, weight, _for, rate, type_id, callback) => {
    proteins.updateProtein(proteinId, name, brand_id, price, weight, _for, rate, type_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            getProtein(proteinId, (err, res) => {
                if (err) {
                    callback(err, null);
                }
                callback(null, res);
            });
        }
    });
};

const getProtein = (proteinId, callback) => {
    proteins.getProtein(proteinId, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            var protein = proteins.parseProtein(res);
            products.getProduct(protein.product_id, (err, res) => {
                if (err) {
                    callback(err, null);
                }
                protein.product = products.parseProduct(res);
                callback(null, protein);
            });
        }
    });
};

const getAllProteins = (callback) => {
    proteins.getProteins((err, res) => {
        if (err) {
            callback(err, null);
        } else {
            var prots = proteins.parseProtein(res);
            if (prots instanceof Array) {
            } else {
                prots = [prots]
            }
            var newProteins = [];
            prots.forEach((protein) => {
                products.getProduct(protein.product_id, (err, res) => {
                    if (err) {
                        callback(err, null);
                    } else {
                        protein.product = products.parseProduct(res);
                        newProteins.push(protein);
                        if (newProteins.length == prots.length) {
                            callback(null, newProteins);
                        }
                    }
                });
            }
            );
        }
    });
};

const addProteinType = (name, callback) => {
    proteins.addProteinType(generateId(), name, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, proteins.parseProteinType(res));
        }
    });
};


//---------------------

const createBasket = (user_id, callback) => {
    rest.createBasket(generateId(), user_id, 10, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};
const getBasket = (basket_id, callback) => {
    rest.getBasket(basket_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, rest.parseBasket(res));
        }
    });
};


const addProductToBasket = (basket_id, product_id, callback) => {
    rest.addProductToBasket(basket_id, product_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};
const getVitaminsInBasket = (basket_id, callback) => {
    rest.getVitaminsInBasket(basket_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const getBasketProducts = (basket_id, callback) => {
    rest.getBasketProductsWithJoin(basket_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const loginDealer = (email, password, callback) => {
    rest.getDealerWithEmailAndPassword(email, password, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};
const registerDealer = (name, email, password, callback) => {
    rest.addDealer(generateId(), name, email, password, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const getDealerBrands = (dealer_id, callback) => {
    rest.getBrandsDealerWithJoin(dealer_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const searchProducts = (query, callback) => {
    rest.searchProducts(query, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};

const removeProductFromBasket = (basket_id, product_id, callback) => {
    rest.removeProductFromBasket(basket_id, product_id, (err, res) => {
        if (err) {
            callback(err, null);
        } else {
            callback(null, res);
        }
    });
};



module.exports = {
    login,
    register,
    addAdress,
    getAdress,
    addBrand,
    getAllBrands,
    getBrand,
    deleteBrand,
    updateBrand,
    updateBrandRate,
    addVitamin,
    getAllVitamins,
    getVitamin,
    deleteVitamin,
    updateVitamin,
    addProtein,
    getAllProteins,
    getProtein,
    deleteProtein,
    updateProtein,
    addProteinType,
    createBasket,
    addProductToBasket,
    getBasketProducts,
    loginDealer,
    registerDealer,
    getDealerBrands,
    getBasket,
    getVitaminsInBasket,
    searchProducts,
    removeProductFromBasket,
    updateAdress
};