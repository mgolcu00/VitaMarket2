
const express = require('express');
const router = express.Router();
const database = require('../../database')

router.post('/register', (req, res) => {
    database.registerDealer(req.body.name, req.body.email, req.body.password, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});
router.post('/login', (req, res) => {
    database.loginDealer(req.body.email, req.body.password, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

router.get('/:id/brands', (req, res) => {
    database.getDealerBrands(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    })
});

module.exports = router;