import React, { useEffect, useState } from 'react';
import './App.css';
import { BrowserRouter, Route, Switch, Link } from 'react-router-dom';
import Dashboard from './components/Dashboard/Dashboard';
import Market from './components/Market/Market';
import Basket from './components/Basket/Basket';
import Login from './components/Login/Login';
import Address from './components/Basket/Address';
import Search from './components/Search/Search';
import { AppContext } from './context/ContextLib'
import Dealer from './components/Login/Dealer';


function addProductToBasket(product_id, basket_id) {
  return fetch('http://localhost:3000/basket/add',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        basket_id: basket_id,
        product_id: product_id
      })
    })
    .then(response => response.json())
}

function getUserBasket(user_id) {
  return fetch(`http://localhost:3000/basket/products/${user_id}`,
    {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
}

function createBasket(user_id) {
  return fetch('http://localhost:3000/basket/create',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        user_id: user_id
      })
    })
    .then(response => response.json())
}

function getBasket(basket_id) {
  return fetch(`http://localhost:3000/basket/${basket_id}`,
    {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
}

function App() {


  const [token, setToken] = useState(localStorage.getItem('token'));
  const [basketId, setBasketId] = useState(localStorage.getItem('basketId'));
  const [basket, setBasket] = useState([]);
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetchBasket()
  }, []);
  const fetchBasket = () => {
    if (basketId) {
      getBasket(basketId)
        .then(basket => {
          setBasketId(basket.id);
          localStorage.setItem('basketId', basket.id);
          getUserBasket(basket.id)
            .then(products => {
              console.log('test : ' + products);
              setBasket(basket);
              setProducts(products);
            }
            ).catch
            (err => {
              console.log(err);
            }
            );
        }).catch(err => {
          console.log(err);
        }
        );
    }
  }


  const addBasket = (product_id) => {
    if (basketId) {
      addProductToBasket(product_id, basketId)
        .then(response => {
          setProducts(response);
        })
    } else {
      createNewBasket()
    }
  }

  const createNewBasket = () => {
    if (token) {
      createBasket(token)
        .then(basket => {
          setBasketId(basket.id);
          setBasket(basket);
          localStorage.setItem('basketId', basket.id);
        }
        ).catch(error => {
          console.log(error);
        });
    } else {
      alert('no token');
    }
  }



  const DrawProducts = () => {
    if (products) {
      console.log(products);
      return (
        <div className="products">
          <p>Sepet : {products.length}</p>
          <Link to="/basket">Sepet</Link>
        </div>
      );
    }
  }

  // fetchBasket()
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/dealer" >
          {token ? <Dashboard token={token} /> : <Dealer setToken={setToken} />}
        </Route>
        <Route path="/market" >
          {token ?
            <div>
              <DrawProducts />
              <br />
              <Link to="/search"><h4>Ara</h4></Link>
              <br />
              <Link to="/address"><h4>Adresim</h4></Link>
              <br />
              <Market addBasket={addBasket} />
            </div>
            : <Login setToken={setToken} />}
        </Route>
        <Route path="/basket"  >
          <Basket />
        </Route>
        <Route path="/search"  >
          <Search />
        </Route>
        <Route path="/address"  >
          <Address user_id={token}/>
        </Route>
      </Switch>
    </BrowserRouter>
  );

}


export default App;
