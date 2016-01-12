///////////////////////////////////////////////////////////////////////////////
// Welcome to the Esquilo boot nut!
//
// The Esquilo boot nut is a squirrel nut that your Esquilo can execute every
// time it boots.  It is stored in a special area of flash inside of the ARM
// processor so it is available even if there is no micro SD card.  You can
// change the boot nut setting either from the Esquilo IDE under the system
// menu or with the "sq boot <true|false> command from an EOS shell.
//
// What you do with the boot nut is up to you.  You can write your entire
// application in the boot.nut or you can use it as a springboard to a nut
// stored elsewhere.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Run a nut on the micro SD card
///////////////////////////////////////////////////////////////////////////////
// dofile("sd:/blinky.nut");

///////////////////////////////////////////////////////////////////////////////
// Run your own application
///////////////////////////////////////////////////////////////////////////////

print("Loading libraries");
dofile("sd:/lib/sensors/ds18b20/ds18b20.nut");
dofile("sd:/lib/buses/onewire/onewire.nut");
print("Libraries loaded, initializing sensor");

//initialize the sensors
/* Create a _onewire instance on UART1 */
onewire <- Onewire(1);
/* Search for the DS18B20 on the bus */
rom <- onewire.searchRomFamily(0x28);
if (!rom)
   throw("Fridge DS18B20 not found");
/* Create the DS18B20 instance */
ds18b20_fridge <- DS18B20(onewire, rom);
/* Repeat the above process on UART 2 for the freezer sensor*/
/* Create a _onewire instance on UART2 */
onewire2 <- Onewire(2);
/* Search for the DS18B20 on the bus */
rom2 <- onewire2.searchRomFamily(0x28);
if (!rom2)
   throw("Freezer DS18B20 not found");
/* Create the DS18B20 instance */
ds18b20_freezer <- DS18B20(onewire2, rom2);

//run the controller nut
dofile("sd:/ferris_brewler/temp_record.nut");

// Configure the GPIO as a digital output

// Function to toggle the LED state
function blinky()
{
    //serial2.write('b');
    if (led.ishigh()) {
    	led.low();
    }
    else {
    	led.high();
    }
}
led.high();

while (true)
{
}

///////////////////////////////////////////////////////////////////////////////
// Run an Arduino-style application
///////////////////////////////////////////////////////////////////////////////

/*
// Set the LED pin number
ledPin <- LED_BUILTIN;

// Configure the LED as an output
function setup()
{
    pinMode(ledPin, OUTPUT);
}

// Loop blinking the LED every half second
function loop()
{
    digitalWrite(ledPin, HIGH);
    delay(400);
    digitalWrite(ledPin, LOW);
    delay(400);
}

// Run the Arduino loop
run();
*/
