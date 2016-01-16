/*
File for the Ferris Brewler temperature controller

The controller is a simple state machine.  The core is a bang-bang controller
based on logger temperature data and the current (hardcoded) bands.  The
controller also avoids making any changes to the current compressor state if a
change has been made too recently, where "recently" is in the wait_time
variable, and the last change is stored in the compressor_change_time variable.
It also sets the global variables ::controller_state and ::compressor_state for
use in data logging.

TODO a better way of adjusting the bands
*/

//intialize the fride to cooling
local compressor_pin <- GPIO(30);
local timer_interval = 60*1000;
local compressor_timeout = 5*60*1000;
::compressor_state = 'cooling';
::low_temp = 22.0;
::high_temp = 24.0;
::transition_time = 0;

function transition() {
  if (::compressor_state == 'cooling') {
    if (!compressor_pin.ishigh()) {
      compressor_pin.high();
    }
    local fridge_temp <- ds18b20_fridge.readT();
    if (fridge_temp<::low_temp) {
      ::compressor_state = 'waiting_to_warm';
    }
  }

  if (::compressor_state == 'warming') {
    if (compressor_pin.ishigh()) {
      compressor_pin.low();
    }
    local fridge_temp <- ds18b20_fridge.readT();
    if (fridge_temp>::high_temp) {
      ::compressor_state = 'waiting_to_cool';
    }
  }

  if (::compressor_state == 'waiting_to_warm') {
    //check if the timeout has expired
    if (time()-transition_time>compressor_timeout) {
      if (compressor_pin.ishigh()) {
        compressor_pin.low();
      }
      ::compressor_state = 'warming';
      transition_time = time();
    }
  }

  if (::compressor_state == 'waiting_to_cool') {
    //check if the timeout has expired
    if (time()-transition_time>compressor_timeout) {
      if (!compressor_pin.ishigh()) {
        compressor_pin.high();
      }
      ::compressor_state = 'cooling';
      transition_time = time();
    }
  }
}

//attach a timer to fire the state machine
local control_timer = Timer(transition);
controller_timer.interval(timer_interval);
