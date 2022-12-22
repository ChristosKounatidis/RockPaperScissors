const user = process.env['user'];
const host = process.env['host'];
const database = process.env['database'];
const password = process.env['password'];
const port = process.env['port'];

console.log(user);
console.log(host);
console.log(database);
console.log(password);
console.log(port);

//credentials = require('./credentials.js');
const { Client } = require('pg');

const client = new Client({
    user,
    host,  
    database,
    password,
    port
});
const mySecret = process.env['user']

client.connect(function(err) {
    if (err) throw err;
      console.log("Connected!");
    if (err) console.log("Not Connected");
    
});
