const Client = require('./connection.js')
//test();
var table = "users"
var infoTag = document.getElementById("info").innerText;

Client.connect();

const query = 
{
    text:"SELECT * FROM $1;",
    values:[table],    
}

Client.query(query,(err,res)=>
    {
        if(err){console.error(err); return;}

        infoTag = res;
        Client.end();
    }
);