import React, { useEffect, useState } from 'react';
import { Card, CardHeader, CardContent } from '@material-ui/core';



function searchProducts(query) {
    return fetch('http://localhost:3000/user/search', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            query: query
        })
    })
        .then(response => response.json())
        .catch(error => error.json());
}

export default function Search() {
    const [products, setProducts] = useState([]);
    const [query, setQuery] = useState('');

    const search = () => {
        searchProducts(query+'%')
            .then(response => {
                if (response)
                    setProducts(response);


            }).catch(error => {
                setProducts([]);
            });
    };
    const AllProducts = () => {
        if (products.length > 0)
            return (
                <div>
                    {products.map(product => {
                        return (
                            <div key={product.id}>
                                <Card>
                                    <CardHeader title={product.name} />
                                    <CardContent>
                                        <p>{product.price}</p>
                                    </CardContent>
                                </Card>
                            </div>
                        )
                    })}
                </div>
            )
        return (<div>Not found products</div>)
    }
    return (
        <div>
            <input
                type="text"
                value={query}
                onChange={e => setQuery(e.target.value)}
            />
            <button onClick={() => search()}>Search</button>
            <AllProducts />
        </div>
    );
}
