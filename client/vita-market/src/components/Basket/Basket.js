import React, { useEffect, useState } from 'react';
import { Card, CardHeader, CardContent, CardActions, Button } from '@material-ui/core';

import PropTypes from 'prop-types';

function getProducts(basket_id) {
    return fetch(`http://localhost:3000/basket/products/${basket_id}`,
        {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        })
        .then(response => response.json())
}
function removeProduct(basket_id, product_id) {
    return fetch(`http://localhost:3000/basket/remove`,
        {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                basket_id: basket_id,
                product_id: product_id,
            }),
        })
        .then(response => response.json())
}

export default function Basket() {
    const [basketId, setBasketId] = useState(localStorage.getItem('basketId'));
    const [products, setProducts] = useState([]);
    const [basket_total, setBasket_total] = useState(0);


    const initProducts = () => {
        getProducts(basketId)
            .then(products => {
                if (products instanceof Array) {

                    setProducts(products);
                    let bt = 0
                    products.forEach(product => {
                        bt += product.price;
                    });
                    setBasket_total(bt);
                }
                else {
                    if(products.name== 'error'){
                        setProducts([]);
                        setBasket_total(0);
                        return;}
                    products = [products];
                    setProducts(products);
                    let bt = 0
                    products.forEach(product => {
                        bt += product.price;
                    });
                    setBasket_total(bt);
                }
            });
    };

    useEffect(() => {
        console.log('basketID: ' + basketId);
        initProducts();
    }, []);

    const deleteProduct = (product_id) => {
        console.log('pid: ' + product_id);
        console.log('bid: ' + basketId);
        removeProduct(basketId, product_id)
            .then((res) => {
                console.log(res);
                initProducts();
            });
    };



    const AllProducts = () => {
        console.log("PRODUCTS :" + JSON.stringify(products));
        if (products.length > 0 && products.name != "error")
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
                                    <CardActions>
                                        <Button onClick={() => deleteProduct(product.id)}>Delete</Button>
                                    </CardActions>
                                </Card>
                            </div>
                        )
                    })}
                </div>
            )
        return (<div>No products in the basket</div>)
    }
    return (
        <div className="basket">
            <h1>Basket</h1>
            <AllProducts />
            <p>Toplam Tutar : {basket_total}</p>
        </div>
    );
}
// Basket.propTypes = {
//     basket_id: PropTypes.func.isRequired
// }