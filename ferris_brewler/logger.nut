function log_state()
{
  //log the temperature sensor states
  fridge_temp <- ds18b20_fridge.readT();
  write_data(fridge_temp,"fridge");
  freezer_temp <- ds18b20_freezer.readT();
  write_data(freezer_temp,"freezer");
  //log the compressor status
  write_data(::compressor_state,"compressor");
  //log the controller status
  write_data(::controller_state,"controller");
}

function write_data(sample,sensor) {
  datafile <- file("sd:/ferris_brewler/data/temp_data.csv","a+");
  local s = time().tostring() + "," + sensor + "," + sample + ",\n";
  datafile.writestr(s);
  datafile.close();
}
