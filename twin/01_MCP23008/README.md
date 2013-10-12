**Name:** MCP23008

**Type:** I2C

**Format:** TwinTab

**Voltage:** 3.3V/5V

This board is a simple breakout board for the [MCP23008](http://www.microchip.com/wwwproducts/Devices.aspx?dDocName=en021393)
I2C I/O expander. It is intended to help design projects around this device.

# Usage

The board is controlled through the I2C interface and provides a programmable
interrupt output on the *extra* pin to the Clixx interface. The 8 GPIO pins
on the expander are provided as pin headers on the board. Power and ground are
also provided for use in the connected circuit.

Three jumpers are provided to allow the I2C address of the chip to be adjusted,
allowing up to 8 such devices to be used with a single I2C master.

## Examples

TODO

# Circuit

TODO

