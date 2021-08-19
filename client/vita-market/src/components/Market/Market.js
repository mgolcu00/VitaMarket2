import React, { useEffect, useState } from 'react';
import VitaminCard from '../../Modals/VitaminCard';
import ProteinCard from '../../Modals/ProteinCard';
import { Grid, GridList } from '@material-ui/core'
import PropTypes from 'prop-types';

async function fetchVitamins() {
    return fetch('http://localhost:3000/vitamin/', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(data => data.json());
}
async function fetchProteins() {
    return fetch('http://localhost:3000/protein/', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(data => data.json())
}
export default function Market({addBasket}) {
    const [vitamins, setVitamins] = useState([]);
    const [proteins, setProteins] = useState([]);
    const [category, setCategory] = useState('vitamins');
    useEffect(() => {
        fetchVitamins().then(data => {
            console.log(data);
            setVitamins(data);
        })
        fetchProteins().then(data => {
            console.log(data);
            setProteins(data);
        })
    }, [])
    const VitaminList = () => {
        return (
            <GridList spacing={2} >
                {vitamins.map(v => <VitaminCard key={v.product.name} vitamin={v} addToCart={() => {
                    addBasket(v.product.id)
                }} />)}
            </GridList>
        );
    }
    const ProteinList = () => {
        return (
            <GridList spacing={2} >
                {proteins.map(p => <ProteinCard key={p.id} protein={p} addToCart={() => {
                    addBasket(p.product.id)
                }}/>)}
            </GridList>
        );
    }
    const ListWithCategory = () => {
        if (category === 'vitamins') {
            return <VitaminList />;
        } else if (category === 'proteins') {
            return <ProteinList />;
        }
    }
    const changeCategory = (e) => {
        console.log(e);
        setCategory(e)

    }
    return (
        <div>
            <h2>Market</h2>
            <button onClick={(e) => changeCategory('vitamins')}>Vitaminler</button>
            <button onClick={(e) => changeCategory('proteins')}>Proteinler</button>
            <ListWithCategory />
        </div>

    );
}
