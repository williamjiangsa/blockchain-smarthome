// setInterval(function() {
//   const url = window.location.href;
//   $('.deviceListDiv').load(url);
// }, 5000);

const poll = function() {
  $.ajax({
    url: '/routerpoll',
    success(data) {
      console.log(data); // { text: "Some data" } -> will be printed in your browser console every 5 seconds
      poll();
    },
    error() {
      poll();
    },
    timeout: 30000, // 30 seconds
  });
};

// Make sure to call it once first,
poll();

// const subscribe = function(url, cb) {
//   $.ajax({
//     method: 'GET',
//     url,
//     success(data) {
//       cb(data);
//     },
//     complete() {
//       setTimeout(function() {
//         subscribe(url, cb);
//       }, 1000);
//     },
//     timeout: 30000,
//   });
// };

// subscribe('/routerpoll', function(data) {
//   console.log('Data:', data);
// });
