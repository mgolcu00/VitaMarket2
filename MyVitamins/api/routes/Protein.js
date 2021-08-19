const express = require('express');
const router = express.Router();
const database = require('../../database')

router.post('/add', (req, res) => {
    database.addProtein(
        req.body.name,
        req.body.brand_id,
        req.body.price,
        req.body.weight,
        req.body.for,
        req.body.rate,
        req.body.type_id,
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
    database.getAllProteins((err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

router.get('/:id', (req, res) => {
    database.getProtein(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
}
);

router.put('/:id', (req, res) => {
    database.updateProtein(
        req.params.id,
        req.body.name,
        req.body.brand_id,
        req.body.price,
        req.body.weight,
        req.body.for,
        req.body.rate,
        req.body.type_id,
        (err, data) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.status(200).send(data);
            }
        }
    );
}
);

router.delete('/:id', (req, res) => {
    database.deleteProtein(req.params.id, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});

router.post('/add/type', (req, res) => {
    database.addProteinType(req.body.name, (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(data);
        }
    });
});


module.exports = router;


