const express = require('express');
const router = express.Router();
const database = require('../../database')

router.post('/add', (req, res) => {
    database.addVitamin(
        req.body.name,
        req.body.brand_id,
        req.body.price,
        req.body.weight,
        req.body.usage,
        (err, data) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.status(200).send(data);
            }
        }
    );
});

router.get('/', (req, res) => {
    database.getAllVitamins((err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});
router.get('/:id', (req, res) => {
    database.getVitamin(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});
router.put('/:id', (req, res) => {
    database.updateVitamin(
        req.params.id,
        req.body.name,
        req.body.brand_id,
        req.body.price,
        req.body.weight,
        req.body.usage,
        (err, data) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.status(200).send(data);
            }
        }
    );
});
router.delete('/:id', (req, res) => {
    database.deleteVitamin(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

module.exports = router;