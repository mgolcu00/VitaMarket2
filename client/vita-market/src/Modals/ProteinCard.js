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
export default function ProteinCard({ protein,addToCart }) {
    const [brand, setBrand] = useState();
    fetchBrand(protein.product.brand_id)
        .then(response => setBrand(response.name));

    return (
        <Card className="card-root">
            <CardHeader title={protein.product.name} />
            <CardContent>
                <h6>{brand} ®</h6>
                <p>{protein.weight} mg</p>
                <p>₺ {protein.product.price}</p>
            </CardContent>
            <CardActions>
                <Button color="primary" onClick={() => addToCart()}>
                    Sepete Ekle
                </Button>
            </CardActions>
        </Card>
    );
}
