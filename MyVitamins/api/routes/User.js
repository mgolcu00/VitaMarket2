const express = require('express');
const router = express.Router();
const database = require('../../database')


router.post('/login', (req, res) => {
    database.login(req.body.email, req.body.password, (err, user) => {
        if (err) {
            res.status(500).send(err);
        } else if (user) {
            res.status(200).send(user);
        }
    });
})
router.post('/register', (req, res) => {
    database.register(req.body.name, req.body.email, req.body.password, (err, user) => {
        if (err) {
            res.status(500).send(err);
        } else if (user) {
            res.status(200).send(user);
        }
    });
})

router.post('/adress/add', (req, res) => {
    database.addAdress(req.body.userId, req.body.adress, req.body.city, (err, user) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send('success');
        }

    });
})

router.put('/adress/update', (req, res) => {
    database.updateAdress( req.body.adress, req.body.city,req.body.user_id, (err, user) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(user);

        }
    });
})

router.get('/adress/:user_id', (req, res) => {
    database.getAdress(req.params.user_id, (err, adress) => {
        console.log('adress : ' + adress);
        console.log('err : ' + err);
        if (err) {
            res.status(500).send(err);
        } else if (adress) {
            res.status(200).send(adress);
        } else {
            res.status(404).send('Not found');
        }
    });
})

router.post('/search', (req, res) => {
    database.searchProducts(req.body.query, (err, user) => {
        if (err) {
            res.status(500).send(err);
        } else if (user) {
            res.status(200).send(user);
        } else {
            res.status(404).send('Not found');
        }
    });
})



module.exports = router;