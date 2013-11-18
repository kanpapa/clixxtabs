# PIC16F1827 SmartTab

This TwinTab is an I2C client device containing an PIC16F1827 CPU. It can be
used as a general purpose module to simplify more complex operations. The board
has been designed with an FTDI connector on it to allow for serial transfer of
the firmware (the source for the bootloader is provided in the 'bootloader'
directory).

10 of the GPIO pins and the two power pins are exposed through a 12 pin header
on the board that can be used to interface to external circuitry.

Two sample projects have been provided:

1. An I2C client template project - this contains the code and Makefiles
   required to implement a basic register based I2C protocol. The project is
   designed to use the open source [SDCC]() compiler and [gputils]().
2. A generic LCD driver - this firmware can drive multiple types of LCD devices
   while exposing a single memory mapped API to the host system.
