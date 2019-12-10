/* eslint-disable object-shorthand */
/* eslint-disable no-template-curly-in-string */
/* eslint-disable no-plusplus */
/* eslint-disable no-undef */
/* eslint-disable no-multi-str */
/* eslint-disable no-unused-vars */
// Updates slider numbers and light bulb colour as sliders are changed
function changeBulb() {
  const r = document.getElementById('RValue').value;
  const g = document.getElementById('GValue').value;
  const b = document.getElementById('BValue').value;
  let i = document.getElementById('IValue').value;

  document.getElementById('RNumber').innerHTML = r;
  document.getElementById('GNumber').innerHTML = g;
  document.getElementById('BNumber').innerHTML = b;
  document.getElementById('INumber').innerHTML = i;

  i /= 100;

  document.getElementById(
    'overlay'
  ).style.backgroundColor = `rgba(${r}, ${g}, ${b}, ${i})`;
}

// Changes text and colour of ON/OFF text
function changeStatus() {
  if (document.getElementById('deviceStatus').innerHTML === 'OFF') {
    document.getElementById('deviceStatus').innerHTML = 'ON';
    document.getElementById('deviceStatus').style.color = 'green';
    document.getElementById('plug').style.backgroundColor = 'green';
  } else {
    document.getElementById('deviceStatus').innerHTML = 'OFF';
    document.getElementById('deviceStatus').style.color = 'red';
    document.getElementById('plug').style.backgroundColor = 'red';
  }
}

const vueinst = new Vue({
  el: '#lightbulbs',
  data: {
    lights: [],
  },
});

Vue.component('light', {
  props: {
    name: String,
    description: String,
    red: Number,
    green: Number,
    blue: Number,
    intensity: Number,
    status: Boolean,
  },
  methods: {
    lightCssStyle: function() {
      return {
        backgroundColor: `rgba(${this.$props.red},${this.$props.green},${
          this.$props.blue
        }, ${this.$props.intensity})`,
      };
    },
  },
  template:
    '<div class="deviceIf horizontal"> \
      <div class="lightbulbdiv"> \
        <img id="lightbulb" src="../Images/lightbulb.png"> \
        <img id="overlay" src="../Images/overlay.png" :style="lightCssStyle()"> \
      </div> \
      <h1 class="deviceName">{{name}}</h1> \
    </div>',
});

const poll = function() {
  $.ajax({
    url: '/routerpoll',
    success(data) {
      const temp = data.lightbulbs;
      for (let i = 0; i < temp.length; i++) {
        temp[i].red = parseInt(temp[i].red);
        temp[i].green = parseInt(temp[i].green);
        temp[i].blue = parseInt(temp[i].blue);
        temp[i].intensity = parseInt(temp[i].intensity);
      }
      vueinst.lights = temp;
      poll();
    },
    error() {
      poll();
    },
    timeout: 30000, // 30 seconds
  });
};

function firstRequest() {
  $.ajax({
    url: '/lightbulbs',
    success(data) {
      const temp = data.lightbulbs;
      for (let i = 0; i < temp.length; i++) {
        temp[i].red = parseInt(temp[i].red);
        temp[i].green = parseInt(temp[i].green);
        temp[i].blue = parseInt(temp[i].blue);
        temp[i].intensity = parseInt(temp[i].intensity);
      }
      vueinst.lights = temp;
    },
    error(error) {
      console.log(error);
    },
  });
  poll();
}

// call first request
firstRequest();
