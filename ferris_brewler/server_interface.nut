/*Series of functions to be called by the Javascript RPC to allow REST-y
  data and comms.  For now, only getters, no setters.
*/

function get_fridge_temp() {
  fridge_temp <- ds18b20_fridge.readT();
  return fridge_temp;
}

function get_freezer_temp() {
  freezer_temp <- ds18b20_freezer.readT();
  return freezer_temp;
}

function get_controller_state() {
  return ::compressor_state;
}
