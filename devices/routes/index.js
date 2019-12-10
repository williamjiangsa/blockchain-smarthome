/* eslint-disable no-loop-func */
/* eslint-disable no-undef */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
const express = require('express');

const router = express.Router();
const redis = require('redis');
const longpoll = require('../node_modules/express-longpoll/index')(router);

longpoll.create('/routerpoll');

const client = redis.createClient();

// Stores objects for use on server
let AllLightbulbs = [];
let AllPlugs = [];

// Gets data for all lightbulbs and stores it
function getAllLightbulbs() {
  client.smembers('LightBulbs', function(err, reply) {
    AllLightbulbs = [];
    let lightbulbHashList = [];
    lightbulbHashList = reply;
    for (i in lightbulbHashList) {
      client.hgetall(lightbulbHashList[i], function(_err, object) {
        AllLightbulbs.push(object);
      });
    }
  });
}

// Gets data for all plugs and stores it
function getAllPlugs() {
  client.smembers('ElectricPlugs', function(err, reply) {
    AllPlugs = [];
    let plugHashList = [];
    plugHashList = reply;
    for (i in plugHashList) {
      client.hgetall(plugHashList[i], function(err, object) {
        AllPlugs.push(object);
      });
    }
  });
}

client.on('error', function(err) {
  console.log(`Error ${err}`);
});

// Connects to Redis server and retrieves data
client.on('connect', function() {
  console.log('Redis connected');
  getAllLightbulbs();
  getAllPlugs();
});

// Gets home page and renders lists of devices
router.get('/', function(req, res, next) {
  getAllLightbulbs();
  getAllPlugs();
  res.render('index', { lightbulbs: AllLightbulbs, plugs: AllPlugs });
});

router.get('/lightbulbs', function(req, res, next) {
  getAllLightbulbs();

  // Publish every 5 seconds
  setInterval(function() {
    getAllLightbulbs();
    longpoll.publish('/routerpoll', {
      lightbulbs: AllLightbulbs,
    });
  }, 5000);

  res.json({ lightbulbs: AllLightbulbs });
});

router.get('/electricplugs', function(req, res, next) {
  getAllPlugs();
  res.render('plugs', { plugs: AllPlugs });
});

// Renders individual lightbulb page
router.get('/lightbulb/:id', function(req, res) {
  client.hgetall(req.params.id, function(err, object) {
    const currentLightbulb = object;

    const IValueCalc = currentLightbulb.intensity / 100;

    let setStatusColour;
    let setStatus;
    if (currentLightbulb.status === 'true') {
      setStatusColour = 'green';
      setStatus = 'ON';
    } else {
      setStatusColour = 'red';
      setStatus = 'OFF';
    }

    res.render('lightbulb', {
      name: currentLightbulb.name,
      Description: currentLightbulb.description,
      status: setStatus,
      statusColour: setStatusColour,
      RValue: currentLightbulb.red,
      GValue: currentLightbulb.green,
      BValue: currentLightbulb.blue,
      IValue: currentLightbulb.intensity,
      IValueCSS: IValueCalc,
    });
  });
});

// Renders individual plug
router.get('/plug/:id', function(req, res) {
  client.hgetall(req.params.id, function(err, object) {
    const currentPlug = object;

    let setStatusColour;
    let setStatus;
    if (currentPlug.status === 'true') {
      setStatusColour = 'green';
      setStatus = 'ON';
    } else {
      setStatusColour = 'red';
      setStatus = 'OFF';
    }

    res.render('plug', {
      name: currentPlug.name,
      Description: currentPlug.description,
      status: setStatus,
      statusColour: setStatusColour,
    });
  });
});

module.exports = router;

/* TESTING FUNCTIONS

router.get('/lightbulbchange', function(req, res) {
  client.hmset('lightbulb1', {'id': 'lightbulb1',
    'name': 'Smart Lightbulb 1',
    'description': 'This is a lightbulb that was changed',
    'status': 1, 
    'red': 0,
    'green': 255,
    'blue': 255,
    'intensity': 100
    }, function(err, reply) {
        console.log("set" + reply);
    }); 

    res.render('index', {lightbulbs: AllLightbulbs, plugs: AllPlugs});
});

router.get('/plugchange', function(req, res) {
  client.hmset('plug2', {'id': 'plug2',
  'name': 'Smart Plug 2',
  'description': 'This is a plug that is off that is on now',
  'status': 1, 
  }, function(err, reply) {
      console.log("set" + reply);
  }); 

  res.render('index', {lightbulbs: AllLightbulbs, plugs: AllPlugs});
});
*/
/*

function testAdd() {
  client.sadd(['LightBulbs', 'lightbulb1', 'lightbulb2', 'lightbulb3'], function(err, reply) {
    console.log(reply);
    client.hmset('lightbulb1', {'id': 'lightbulb1',
    'name': 'Smart Lightbulb 1',
    'description': 'This is a lightbulb',
    'status': 1, 
    'red': 255,
    'green': 255,
    'blue': 0,
    'intensity': 100
    }, function(err, reply) {
        console.log("set" + reply);
    });        
    client.hmset('lightbulb3', {'id': 'lightbulb3',
    'name': 'Smart Lightbulb 3',
    'description': 'This is a lightbulb 3',
    'status': 1, 
    'red': 255,
    'green': 255,
    'blue': 0,
    'intensity': 100
    }, function(err, reply) {
        console.log("set" + reply);
    });     
client.hmset('lightbulb2', {'id': 'lightbulb2',
    'name': 'Smart Lightbulb 2',
    'description': 'This is a lightbulb, the second one',
    'status': 1, 
    'red': 255,
    'green': 50,
    'blue': 255,
    'intensity': 80
    }, function(err, reply) {
        console.log("set" + reply);
    });   
  });
  client.sadd(['plugs', 'plug1', 'plug2'], function(err, reply) {
    console.log(reply);
    client.hmset('plug1', {'id': 'plug1',
    'name': 'Smart Plug 1',
    'description': 'This is a plug that is on',
    'status': 1, 
    }, function(err, reply) {
        console.log("set" + reply);
    });    
    client.hmset('plug2', {'id': 'plug2',
    'name': 'Smart Plug 2',
    'description': 'This is a plug that is off',
    'status': 0, 
    }, function(err, reply) {
        console.log("set" + reply);
    });               
  });  
                                              
}
/*
TO READ FROM ALL LIST INSTEAD
Lightbulb:
getAllLightbulbs();
var currentLightbulb = [];
for(i in AllLightbulbs) {
  if(req.params.id == AllLightbulbs[i].id) {
    currentLightbulb = AllLightbulbs[i];
  }
}

Plug: 
  getAllPlugs();

  var currentPlug = [];
  for(i in AllPlugs) {
    if(req.params.id == AllPlugs[i].id) {
      currentPlug = AllPlugs[i];
    }
  }

*/
