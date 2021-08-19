import React, { useState } from 'react';
import './Login.css';
import PropTypes from 'prop-types';
import {
    Link
} from "react-router-dom";

async function loginDealer(credentials) {
    console.log(credentials);
    return fetch('http://127.0.0.1:3000/dealer/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            email: credentials.email,
            password: credentials.password
        })
    })
        .then(data => data.json())
}

export default function Delaer({ setToken }) {

    const [email, setEmail] = useState();
    const [password, setPassword] = useState();

    const handleSubmit = async e => {
        e.preventDefault();
        const token = await loginDealer({
            email,
            password
        });
        console.log(token);
        setToken(token.id);
        localStorage.setItem('token', token.id);
    }
    return (
        <div className="login-wrapper">
            <h1>Satıcı Girişi yapın</h1>
            <form onSubmit={handleSubmit}  >
                <label>
                    <p>email</p>
                    <input type="text" onChange={e => setEmail(e.target.value)} />
                </label>
                <label>
                    <p>Password</p>
                    <input type="password" onChange={e => setPassword(e.target.value)} />
                </label>
                <div>
                    <button type="submit">Submit</button>
                </div>
            </form>
            <Link to="/login">musteri</Link>
        </div>
    )
}
Delaer.propTypes = {
    setToken: PropTypes.func.isRequired,
    setUserType: PropTypes.func.isRequired
}