/* eslint-disable dot-notation */
/* eslint-disable prefer-destructuring */
/* eslint-disable prettier/prettier */
/* eslint-disable import/no-unresolved */
/* eslint-disable import/no-extraneous-dependencies */

const fs = require('fs');
const Web3 = require('web3');
var mysql = require('mysql');
// const redis = require('redis');

// Ethereum public Blockchain
// const host = 'wss://ropsten.infura.io/ws/v3/4164c4424c7d465daab94864544fa622';
// const web3js = new Web3(Web3.givenProvider || new Web3.providers.WebsocketProvider(host));

// Ethereum private Blockchain
const httphost = 'http://localhost:8545';
const web3http = new Web3(Web3.givenProvider || new Web3.providers.HttpProvider(httphost));
var con = mysql.createConnection({
    host: "47.74.84.137",
    user: "jiang",
    password: "Bjmt@1234",
    database: "smarthome"
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");

});

var currenttime = 0;
var blocknumber = 0;

// // This function listenning to all LightBulbs events
function BlockEvents() {
    // console.log(currenttime);
    // var blocknumber;
    // web3http.eth.getBalance("0x8acd17e6f4fef86fdf75078d179ec2612fb354ae").then(console.log);
    web3http.eth.getBlockNumber(function(err, res) {
        if (blocknumber == res) {

        } else {
            blocknumber = res;
            web3http.eth.getBlock(res, function(err, ress) {
                currenttime = ress.timestamp;
                console.log(blocknumber);
                console.log(ress.difficulty);

                console.log(currenttime);
                var sql = "INSERT INTO block (blockid, blocktime, difficulty) VALUES (?,?,?)";
                con.query(sql, [blocknumber, currenttime, ress.difficulty], function(err, result) {
                    if (err) throw err;
                    console.log("1 record inserted");
                });
            });
        }
    });
}

/*
 * ----- Start of the main server code -----
 */
setInterval(BlockEvents, 1);
// BlockEvents();