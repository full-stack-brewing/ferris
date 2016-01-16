function log_state() {
  //log the temperature sensor states
  fridge_temp <- ds18b20_fridge.readT();
  write_data(fridge_temp,"fridge");
  freezer_temp <- ds18b20_freezer.readT();
  write_data(freezer_temp,"freezer");
  write_data(::compressor_state,"controller");
}

function write_data(sample,sensor) {
  datafile <- file("sd:/ferris_brewler/data/temp_data.csv","a+");
  local s = time().tostring() + "," + sensor + "," + sample + ",\n";
  datafile.writestr(s);
  datafile.close();
}

//attach a timer to begin logging data
local log_period = 30*1000;
local log_timer = Timer(log_state);
log_timer.interval(log_period);
