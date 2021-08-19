const express = require('express');
// Create Express App
const app = express();
app.use(express.json())

// Server side
const PORT = 3000;

app.listen(PORT, () => {
    console.log("Listening on port " + PORT);
});

app.use(function (req, res, next) {

    // Website you wish to allow to connect
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:3001');

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});

// Routes 
app.get('/', (req, res) => {
    res.send("This is root! Hello.")
});

// User routes
const userRoutes = require('./api/routes/User')
app.use('/user', userRoutes);

// Brand routes
const brandRoutes = require('./api/routes/Brand')
app.use('/brand', brandRoutes);

// Vitamins routes
const vitaminsRoutes = require('./api/routes/Vitamin')
app.use('/vitamin', vitaminsRoutes);

// protein routes
const proteinRoutes = require('./api/routes/Protein')
app.use('/protein', proteinRoutes);

//Basket routes
const basketRoutes = require('./api/routes/Basket')
app.use('/basket', basketRoutes);

//Dealer routes
const dealerRoutes = require('./api/routes/Dealer')
app.use('/dealer', dealerRoutes);


