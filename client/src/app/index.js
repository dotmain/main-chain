// import React from 'react'
// import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'

// import { NavBar } from '../components'
// import { MoviesList, MoviesInsert, MoviesUpdate } from '../pages'

// import 'bootstrap/dist/css/bootstrap.min.css'

// function App() {
//     return (
//         <Router>
//             <NavBar />
//             <Switch>
//                 <Route path="/movies/list" exact component={MoviesList} />
//                 <Route path="/movies/create" exact component={MoviesInsert} />
//                 <Route
//                     path="/movies/update/:id"
//                     exact
//                     component={MoviesUpdate}
//                 />
//             </Switch>
//         </Router>
//     )
// }

// export default App

import React from "react";
import axios from "axios";
import "./styles.css";
const data = require('./data.json')
console.log("HI")


export default class App extends React.Component {
  state = {
    chain: [],
    error: false
  };

  componentDidMount() {
    axios.get('https://notherweb.com:5005').then((response) => {
      this.setState({ 
        chain: response.data,
        error: false
        });
    }).catch(() => { 
        this.setState({ 
            chain: [],
            error: true
        });
    });
  }


  render() {
    const { chain, error } = this.state;
    return (
      <div>
            Property of mainvolume.com - mv 2021
            <br/>
          {chain.length < 1 ? <strong>{error ? "Invalid or Empty Chain" : "Loading..."}</strong> : 
          <div>
          <strong>Development test unit:</strong> notherweb.com
          <br/>
         <strong>Entries: </strong>{chain[0].blocks.length}
          <br/>
         <strong>ID: </strong>{chain[0].id}
          <br/>
          <strong>Identifier: </strong>{chain[0].identifier}
          <br/>
          <strong>Spawned: </strong>{chain[0].createdAt}
          <br/>
          <br/>
          <strong>Value: </strong>
          <br/>
          <strong>€: </strong>{chain[0].blocks.reduce(function (res, item) { 
              item.dataModels.forEach(dm => { res += dm.total })
              return res;
            }, 0.0)}
        <ul className="users">
          {chain[0].blocks.map((block) => (
            <li className="user">
              <p>
                <strong>created at:</strong> {block.createdAt}
              </p>
              <p>
                <strong>identifier:</strong> {block.identifier}
              </p>
              <p>
              {block.dataModels.map((model) => (
            <li className="user">
              <p>
                <strong>log:</strong> {model.log}
              </p>
              <p>
                <strong>value:</strong> € {model.total} 
              </p>
              <p>
                <strong>synthesized:</strong> {model.createdAt}
                <br/>property of mainvolume.com #mv
              </p>
            </li>
          ))}
              </p>
            </li>
          ))}
        </ul>
        </div>
        }
      </div>
    );
  }
}