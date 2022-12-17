credentials = require('./credentials.js');
const { Client } = require('pg');

const client = new Client({
    user,
    host,  
    database,
    password,
    port
});

client.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
});
