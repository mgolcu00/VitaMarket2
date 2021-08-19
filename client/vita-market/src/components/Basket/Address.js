import React, { useEffect, useState } from 'react';
import { Card, CardHeader, CardContent, CardActions, Button, duration } from '@material-ui/core';

function getAddress(user_id) {
    return fetch(`http://localhost:3000/user/adress/${user_id}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => response.json())
}
function upadateAdress(user_id, address) {
    return fetch(`http://localhost:3000/user/adress/update`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            adress: address.adress,
            city: address.city,
            user_id: user_id,
        }),
    }).then(response => response.json())
}
export default function Address({ user_id }) {
    const [address, setAddress] = useState();
    useEffect(() => {
        fetchAdress()
    }, []);


    const fetchAdress = () => {
        getAddress(user_id).then(response => {
            setAddress(response);
        });
    };

    const updateAddress = () => {
        upadateAdress(user_id, address)
            .then(response => {
                fetchAdress();
            });
    };



    const DrawAddress = () => {
        console.log(address);
        if (address) {
            return (
                <Card>
                    <CardHeader title="Address" />
                    <CardContent>
                        <input
                            type="text"
                            placeholder="adress"
                            value={address.adress}
                            onChange={e => setAddress(address => ({ ...address, adress: e.target.value }))}
                            style={{ width: '100%' }}

                        />
                        <br></br>
                        <br></br>
                        <input
                            type="text"
                            placeholder="postal code"
                            value={address.city}
                            onChange={e => setAddress(address => ({ ...address, city: e.target.value }))}
                        />
                    </CardContent>
                    <CardActions>
                        <Button color="primary" onClick={updateAddress}>
                            Update
                        </Button>
                    </CardActions>
                </Card>
            );
        } else {
            return (
                <p>Loading ...</p>
            );
        }
    };



    return (

        <div>

            <DrawAddress />
        </div>

    );
}
