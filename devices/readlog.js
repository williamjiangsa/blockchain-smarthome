/* eslint-disable dot-notation */
/* eslint-disable prefer-destructuring */
/* eslint-disable prettier/prettier */
/* eslint-disable import/no-unresolved */
/* eslint-disable import/no-extraneous-dependencies */

const fs = require('fs');
const Web3 = require('web3');
var mysql = require('mysql');
const readLastLines = require('read-last-lines');
// const redis = require('redis');

// Ethereum public Blockchain
// const host = 'wss://ropsten.infura.io/ws/v3/4164c4424c7d465daab94864544fa622';
// const web3js = new Web3(Web3.givenProvider || new Web3.providers.WebsocketProvider(host));

// Ethereum private Blockchain
// const httphost = 'http://localhost:8545';
// const web3http = new Web3(Web3.givenProvider || new Web3.providers.HttpProvider(httphost));
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

var currenttime = "0";
var transactiontime = "0";
var currentline;

// // This function listenning to all LightBulbs events
function BlockEvents() {
    readLastLines.read('public/json/log.txt', 15)
        .then((firstlines) => {
            if (currentline == firstlines) {
                console.log("no update");

            } else {
                currentline = firstlines;
                // console.log(currentline);
                readLastLines.read('public/json/log.txt', 15)
                    .then((lines) => {
                        console.log(lines);
                        let newblock = lines.indexOf("Successfully sealed new block");
                        console.log("---------------")
                        let fetchedblocktime = lines.substring(newblock - 20, newblock - 2);
                        console.log(fetchedblocktime);
                        var restlines = lines.substring(newblock + 30);
                        let newblock2 = restlines.indexOf("Successfully sealed new block");
                        let fetchedblocktime2 = restlines.substring(newblock2 - 20, newblock2 - 2);
                        console.log(fetchedblocktime2);
                        // var restlines2 = lines.substring(newblock2 + 30);
                        // let newblock3 = restlines2.indexOf("Successfully sealed new block");
                        // let fetchedblocktime3 = restlines2.substring(newblock2 - 20, newblock2 - 2);
                        // console.log(fetchedblocktime3);
                        console.log(currenttime);
                        let newtransaction = lines.indexOf("Submitted transaction");
                        // console.log(newtransaction);
                        let fetchedtransactiontime = lines.substring(newtransaction - 20, newtransaction - 2);
                        // console.log(fetchedtransactiontime);
                        if (fetchedtransactiontime != transactiontime && newtransaction != -1) {
                            transactiontime = fetchedtransactiontime;
                            // console.log(transactiontime);
                            fetchedtransactiontime = fetchedtransactiontime.replace("-", ":");
                            fetchedtransactiontime = fetchedtransactiontime.replace("|", ":");
                            fetchedtransactiontime = fetchedtransactiontime.replace(".", ":");
                            // console.log(fetchedtransactiontime);
                            var sql = "INSERT INTO transactionfromlog (transactiontime) VALUES (?)";
                            con.query(sql, fetchedtransactiontime, function(err, result) {
                                if (err) throw err;
                                console.log("1 transaction record inserted");
                            });
                        }

                        if (currenttime == fetchedblocktime2) {
                            console.log("same time");
                            // currenttime = fetchedblocktime2;
                            // fetchedblocktime2 = fetchedblocktime2.replace("-", ":");
                            // fetchedblocktime2 = fetchedblocktime2.replace("|", ":");
                            // fetchedblocktime2 = fetchedblocktime2.replace(".", ":");
                            // console.log(fetchedblocktime2);
                            // var sql = "INSERT INTO blockfromlog (blocktime) VALUES (?)";
                            // con.query(sql, fetchedblocktime2, function(err, result) {
                            //     if (err) throw err;
                            //     console.log("1 block record inserted");
                            // });

                        } else if (currenttime == fetchedblocktime) {
                            currenttime = fetchedblocktime2;
                            fetchedblocktime2 = fetchedblocktime2.replace("-", ":");
                            fetchedblocktime2 = fetchedblocktime2.replace("|", ":");
                            fetchedblocktime2 = fetchedblocktime2.replace(".", ":");
                            console.log(fetchedblocktime2);
                            var sql = "INSERT INTO blockfromlog (blocktime) VALUES (?)";
                            con.query(sql, fetchedblocktime2, function(err, result) {
                                if (err) throw err;
                                console.log("1 block record inserted");
                            });
                        } else {
                            currenttime = fetchedblocktime2;
                            console.log("Too many blocks lack");
                            fetchedblocktime = fetchedblocktime.replace("-", ":");
                            fetchedblocktime = fetchedblocktime.replace("|", ":");
                            fetchedblocktime = fetchedblocktime.replace(".", ":");
                            var sql = "INSERT INTO blockfromlog (blocktime) VALUES (?)";
                            con.query(sql, fetchedblocktime, function(err, result) {
                                if (err) throw err;
                                console.log("1 block record inserted");
                            });
                            fetchedblocktime2 = fetchedblocktime2.replace("-", ":");
                            fetchedblocktime2 = fetchedblocktime2.replace("|", ":");
                            fetchedblocktime2 = fetchedblocktime2.replace(".", ":");
                            var sql = "INSERT INTO blockfromlog (blocktime) VALUES (?)";
                            con.query(sql, fetchedblocktime2, function(err, result) {
                                if (err) throw err;
                                console.log("2 block record inserted");
                            });
                        }

                    });
            }

        });
    // console.log(currenttime);
    // var blocknumber;
    // web3http.eth.getBalance("0x8acd17e6f4fef86fdf75078d179ec2612fb354ae").then(console.log);
    // web3http.eth.getBlockNumber(function(err, res) {
    //     if (blocknumber == res) {

    //     } else {
    //         blocknumber = res;
    //         web3http.eth.getBlock(res, function(err, ress) {
    //             currenttime = ress.timestamp;
    //             console.log(blocknumber);
    //             console.log(currenttime);
    //             var sql = "INSERT INTO block (blockid, blocktime) VALUES (?,?)";
    //             con.query(sql, [blocknumber, currenttime], function(err, result) {
    //                 if (err) throw err;
    //                 console.log("1 record inserted");
    //             });
    //         });
    //     }
    // });
}

/*
 * ----- Start of the main server code -----
 */
setInterval(BlockEvents, 80);
// BlockEvents();