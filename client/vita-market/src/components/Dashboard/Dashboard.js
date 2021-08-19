import React from 'react';

export default function Dashboard({ token }) {
    return (
        <div>
            <h2>Dashboard</h2>
            <p>{token}</p>
        </div>

    );
}