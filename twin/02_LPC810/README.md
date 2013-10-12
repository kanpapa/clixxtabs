**Name:** LPC810 Controller Board

**Type:** I2C/Digital/Serial

**Format:** TwinTab

**Voltage:** 3.3V

This board contains the 8 pin DIP version of the
[LPC810 ARM Cortex M0](http://www.nxp.com/products/microcontrollers/cortex_m0_m0/LPC810M021FN8.html)
from NXP Semiconductor. It provides three connectors to the TwinTab Slot and
four external IO pins (one of which is duplicated on the Clixx interface). This
is a flexible board, changing the firmware on the chip (through the provided
FTDI connector) allows you to change it's behaviour.

# Usage

The usage depends entirely on the firmware loaded on to the CPU. The chip is
very flexible when it comes to pin assignments so the board can be configured
as an I2C device (both slave and master), a serial TwinTab device or a digital
device. You can often replace discrete circuitry with firmware or simulate
an intended target device.

When configured as an I2C master the board can act as the main control board
for a project consisting of other I2C Tabs allowing you to build compact and
efficient projects easily.

## Examples

TODO

# Circuit

The Fritzing project for this project requires the LPC810_DIL.fzpz custom
component. This can be found in the *fritzing* directory of the repository.

The circuit provides a simple interface to the LPC810 chip as well as a set of
pins for an FTDI connector so it can be reprogrammed on board.

Two additional jumpers are provided - the *PRG* jumper which must be shorted
to allow ISP programming and the *PWR* jumper which allows the power supply
to come from the FTDI cable instead of the Clixx interface. Note that this is
a 3.3V device, the power supply must provide a regulated 3.3V supply voltage.

To enable ISP programming you must disconnect all external components, short
the *PRG* and *PWR* jumpers and then connect the FTDI cable. You can then
download new firmware. Once complete and verified you must remove the short
from the *PRG* (and the *PWR* if you are using an external power source) and
reinsert the device into your project.

