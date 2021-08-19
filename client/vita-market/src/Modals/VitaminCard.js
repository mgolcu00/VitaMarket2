import React, { useEffect, useState } from 'react';
import { Card, CardHeader, CardContent, CardActions, Button } from '@material-ui/core';
import './Modals.css'

function fetchBrand(brand_id) {
    return fetch(`http://localhost:3000/brand/${brand_id}`, {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
    })
        .then(response => response.json())
}

function VitaminCard({ vitamin, addToCart }) {
    const [brand, setBrand] = useState();
    fetchBrand(vitamin.product.brand_id)
        .then(response => setBrand(response.name));

    return (
        <Card className="card-root">
            <CardHeader title={vitamin.product.name} />
            <CardContent>
                <h6>{brand} ®</h6>
                <p>{vitamin.weight} mg</p>
                <p>₺{vitamin.product.price}</p>
            </CardContent>
            <CardActions>
                <Button color="primary" onClick={addToCart}>Sepete Ekle</Button>
            </CardActions>
        </Card>
    );
}

export default VitaminCard;
