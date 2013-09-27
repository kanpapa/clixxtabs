**Name:** Sample Board

**Type:** Digital

**Format:** TwinTab

**Voltage:** 3.3V/5V

This is a simple test board for experimenting with [Clixx.IO](http://clixx.io).
It contains a single push button and an LED. The circuit is deliberately kept
simple so it can be constructed on strip board to introduce yourself to the
Clixx system.

# Usage

Reading from the board indicates the current state of the push button (0 is
pressed, 1 is not pressed). Writing a 1 to the board turns the LED on, writing
a 0 turns it off. The LED and button are independent of each other, changing
the state of either will not affect the other.

## Examples

TODO

# Circuit

The LED is driven by the input pin through a 330 Ohm current limiting resistor
which is suitable for both 3.3V an 5V operations. The output pin is held high
by a pull up resistor, pressing the button creates a short to ground pulling
the output pin low.

