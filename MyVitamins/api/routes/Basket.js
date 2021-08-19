const express = require('express');
const router = express.Router();
const database = require('../../database')

router.post('/create', (req, res) => {
    database.createBasket(req.body.user_id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});

router.post('/add', (req, res) => {
    database.addProductToBasket(req.body.basket_id, req.body.product_id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});
router.get('/products/:id', (req, res) => {
    database.getBasketProducts(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});

router.get('/:id', (req, res) => {
    database.getBasket(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});
router.get('/vitamins/:id', (req, res) => {
    database.getVitaminsInBasket(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});

router.delete('/remove', (req, res) => {
    database.removeProductFromBasket(req.body.basket_id, req.body.product_id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    }
    )
});




module.exports = router;