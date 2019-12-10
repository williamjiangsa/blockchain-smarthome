/* eslint-disable dot-notation */
/* eslint-disable prefer-destructuring */
/* eslint-disable prettier/prettier */
/* eslint-disable import/no-unresolved */
/* eslint-disable import/no-extraneous-dependencies */

const fs = require('fs');
const Web3 = require('web3');
const redis = require('redis');

// Ethereum public Blockchain
const host = 'wss://ropsten.infura.io/ws/v3/4164c4424c7d465daab94864544fa622';
const web3js = new Web3(Web3.givenProvider || new Web3.providers.WebsocketProvider(host));

// Ethereum private Blockchain
const httphost = 'http://10.0.0.50:7545';
const web3http = new Web3(Web3.givenProvider || new Web3.providers.HttpProvider(httphost));

// create new Redis client
const client = redis.createClient(); // using default connection (127.0.0.1 : 6379)
client.on('connect', function() {
    console.log('Redis client connected');
});
client.on('error', function(err) {
    console.log(`Something went wrong ${err}`);
});

// ElectricPlugs contract
// let parsedJson = JSON.parse(fs.readFileSync('./.deployed_contracts/ElectricPlugs.json'));
// const contractEP = {
//   abi: parsedJson.abi,
//   contractAddress: parsedJson.contractAddress
// };

// LightBulbs public contract
const parsedJson = JSON.parse(fs.readFileSync('./public/CSS/publiclightbulbs.json'));
const contractLB = {
    abi: parsedJson.abi,
    contractAddress: parsedJson.contractAddress
};

// LightBulbs private contract
const parsedJsonpri = JSON.parse(fs.readFileSync('./public/CSS/LightBulbs.json'));
const contractLBpri = {
    abipri: parsedJsonpri.abi,
    contractAddresspri: parsedJsonpri.contractAddress
};

let LightBulbs;
// let ElectricPlugs;

// This function listenning to all ElectricPlugs events
// function ElectricPlugsEvents() {
//   // Assign contract for event listenning of ElectricPlugs
//   ElectricPlugs = new web3js.eth.Contract(contractEP.abi, contractEP.contractAddress);

//   // Listenning to all events of ElectricPlugs
//   ElectricPlugs.events
//     .NewElectricPlug()
//     .on('data', function(event) {
//       const data = event.returnValues;
//       client.hmset(data.hash_id, {
//         'id': data.hash_id,
//         'name': data.name,
//         'description': data.description,
//         'status': data.status,
//       });
//       // call sadd(KEY_NAME VALUE1..VALUEN) to store the set of hash_id
//       console.log(`${data.hash_id  } ${  data.name  } ${  data.description  } ${  data.status}`);
//       client.sadd('ElectricPlugs', data.hash_id);
//     })
//     .on('error', console.error);

//   ElectricPlugs.events
//     .NameChange()
//     .on('data', function(event) {
//       const data = event.returnValues;
//       client.hmset(data.hash_id, {'name': data.name});
//     })
//     .on('error', console.error);

//   ElectricPlugs.events
//     .DescriptionChange()
//     .on('data', function(event) {
//       const data = event.returnValues;
//       client.hmset(data.hash_id, {'description': data.description});
//     })
//     .on('error', console.error);

//   ElectricPlugs.events
//     .StatusChange()
//     .on('data', function(event) {
//       const data = event.returnValues;
//       client.hmset(data.hash_id, {'status': data.status});
//     })
//     .on('error', console.error);
// }

// // This function listenning to all LightBulbs events
function LightBulbsEvents() {
    // Assign contract for event listenning of LightBulbs
    LightBulbs = new web3js.eth.Contract(contractLB.abi, contractLB.contractAddress);
    LightBulbspri = new web3http.eth.Contract(contractLBpri.abipri, contractLBpri.contractAddresspri);

    // Listenning to all events of LightBulbs
    LightBulbs.events
        .NewLightBulb()
        .on('data', function(event) {
            const data = event.returnValues;
            client.hmset(
                data.hash_id, {
                    'id': data.hash_id,
                    'name': data.name,
                    'description': data.description,
                    'status': data.status,
                    'red': data.red,
                    'green': data.green,
                    'blue': data.blue,
                    'intensity': data.intensity
                }

            );
            // call sadd(KEY_NAME VALUE1..VALUEN) to store the set of hash_id
            client.sadd('LightBulbs', data.hash_id);
        })
        .on('error', console.error);

    LightBulbs.events
        .NameChange()
        .on('data', function(event) {
            const data = event.returnValues;
            client.hmset(data.hash_id, { 'name': data.name });
        })
        .on('error', console.error);

    LightBulbs.events
        .DescriptionChange()
        .on('data', function(event) {
            const data = event.returnValues;
            client.hmset(data.hash_id, { 'description': data.description });
        })
        .on('error', console.error);

    LightBulbs.events
        .StatusChange()
        .on('data', function(event) {
            const data = event.returnValues;
            client.hmset(data.hash_id, { 'status': data.status });
            console.log(data);
        })
        .on('error', console.error);

    LightBulbs.events
        .ColorChange()
        .on('data', function(event) {
            const data = event.returnValues;
            var hashid = data.hash_id;
            var numid = hashid.substring(4);
            var id = parseInt(numid, 10);
            console.log(id);
            client.hmset(
                data.hash_id, {
                    'red': data.red,
                    'green': data.green,
                    'blue': data.blue
                }
            );
            console.log(data);
            LightBulbspri.methods.getNumberOfdevices().call()
                .then(console.log);
            LightBulbspri.methods._changeColor(id, data.red, data.green, data.blue).send({ from: '0xbD54Aa1B52e2d550E8caA789eeaABF144d2Af02F' }).then(console.log);

        })
        .on('error', console.error);
    LightBulbs.events
        .IntensityChange()
        .on('data', function(event) {
            const data = event.returnValues;
            client.hmset(data.hash_id, { 'intensity': data.intensity });
        })
        .on('error', console.error);
}

/*
 * ----- Start of the main server code -----
 */

// ElectricPlugsEvents();
LightBulbsEvents();