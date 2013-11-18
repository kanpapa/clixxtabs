# Bootloader for PIC16F1827

This is a simple serial bootloader implementation that allows you to update the
flash on the PIC over a simple FTDI cable connection. It uses the hardware
UART on the PIC for the serial connection and entry to the bootloader is
controlled by a hardware input pin which must be held low on start up.

The bootloader implementation on the PIC is deliberately very simple, the
majority of the work is done by the transfer software (provided in the file
tgloader.py). The only safety precaution taken in the PIC code is that it will
not override the RESET vector memory or the memory occupied by the bootloader
itself (you cannot use the bootloader to update the bootloader).

## Memory Layout

## Protocol

CMD [ ADDRESS [DATA CRC] ] EOL

Query Command (?)

Write Command (W)

Read Command (R)

Reset Command (!)

## Transfer Utility

The transfer utility will load a HEX file containing the code to be transfered,
make a simple modification to it and then transfer it to the target device over
the specified serial port.
