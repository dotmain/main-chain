const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const axios = require('axios')

// const db = require('./db')
// const movieRouter = require('./routes/movie-router')

const app = express()
const apiPort = 5000

app.use(bodyParser.urlencoded({ extended: true }))
app.use(cors())
app.use(bodyParser.json())

// db.on('error', console.error.bind(console, 'MongoDB connection error:'))
const headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer SUPERSECRETCHAINKEY'
  }

app.get('/', (req, res) => {
    axios.get("http://app:8080/blockchain", {
        headers: headers
      })
    .then(data => res.json(data.data))
    .catch(err => res.json(err));
})

// app.use('/api', movieRouter)


app.listen(apiPort, () => console.log(`Server running on port ${apiPort}`))