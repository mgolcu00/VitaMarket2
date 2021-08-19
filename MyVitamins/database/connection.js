const { Pool, Client } = require('pg')


const client = new Client({
    user: 'postgres',
    password: 'mert7591',
    database: 'VitaMarketDB',
    host: 'localhost',
    port: 5432
});

const pool = new Pool({
    user: 'postgres',
    password: 'mert7591',
    database: 'VitaMarketDB',
    host: 'localhost',
    port: 5432
});





module.exports = {
    client,
    pool
}

