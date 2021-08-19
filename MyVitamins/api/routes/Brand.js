const express = require('express');
const router = express.Router();
const database = require('../../database')

/**
 * @swagger
 * /add:
 * parameters: name:String
 * description:Add a new brand
 * responses:
 * 200: Brand
 * 500: Error
*/
router.post('/add', (req, res) => {
    database.addBrand(req.body.name, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

/**
 * @swagger
 * /get:
 * description:Get all brands
 * responses:
 * 200: Array[Brand]
 * 500: Error
*/
router.get('/getAll', (req, res) => {
    database.getAllBrands((err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

router.get('/:id', (req, res) => {
    database.getBrand(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else if (data === null) {
            res.status(404).send('Brand not found');
        } else {
            res.status(200).send(data);
        }
    });
});

router.delete('/:id', (req, res) => {
    database.deleteBrand(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});
router.put('/:id', (req, res) => {
    database.updateBrand(req.params.id, req.body.name, req.body.rate, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});
router.put('/:id/rate', (req, res) => {
    database.updateBrandRate(req.params.id, req.body.rate, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

module.exports = router;