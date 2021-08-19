const { pool } = require('./connection');


const addUser = (id, name, email, password, callback) => {

    pool.query(`INSERT INTO "public"."user"(id,name,email,password) VALUES($1,$2,$3,$4)`, [id, name, email, password], (err, result) => {
        if (err) throw err;
        if (result) {
            getUser(id, callback);
        }
    });
}
const getUser = (id, callback) => {
    pool.query(`SELECT * FROM "public"."user" WHERE id=$1`, [id], (err, result) => {
        if (err) throw err;
        callback(result);
    });
}
const getUserWithEmailAndPassword = (email, password, callback) => {

    pool.query(`SELECT * FROM "public"."user" WHERE email=$1 AND password=$2`, [email, password], (err, result) => {
        if (err) throw err;

        callback(result);
    });
}

const getUsers = (callback) => {

    pool.query(`SELECT * FROM "public"."user"`, (err, result) => {
        if (err) throw err;
        callback(result)
    });
}

const deleteUser = (id) => {

    pool.query(`DELETE FROM "public"."user" WHERE id = $1`, [id], (err, result) => {
        if (err) throw err;

    });
}

const updateUser = (id, name, email, password) => {

    pool.query(`UPDATE "public"."user" SET name=$2, email=$3, password=$4 WHERE id=$1`, [id, name, email, password], (err, result) => {
        if (err) throw err;

    });
}

const parseUser = (user) => {
    if (user.rows[0]) {
        return {
            id: user.rows[0].id,
            name: user.rows[0].name,
            email: user.rows[0].email,
            password: user.rows[0].password
        }
    }
}


module.exports = {
    addUser,
    getUsers,
    deleteUser,
    updateUser,
    getUser,
    getUserWithEmailAndPassword,
    parseUser
}