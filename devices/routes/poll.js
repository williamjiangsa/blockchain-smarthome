const express = require('express');

const router = express.Router();

// Can use routers as well
const longpoll = require('../node_modules/express-longpoll/index')(router);

longpoll.create('/routerpoll');

router.get('/lightbulbs', (req, res) => {
  // Publish every 5 seconds
  setInterval(function() {
    longpoll.publish('/routerpoll', {
      text: 'Some data',
    });
  }, 5000);
  res.render('lightbulbs');
});

module.exports = router;
