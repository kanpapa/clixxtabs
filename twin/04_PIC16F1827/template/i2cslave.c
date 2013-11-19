/*---------------------------------------------------------------------------*
* Simple I2C client implementation for 16F1827 chips.
*----------------------------------------------------------------------------*
* 4.4 User ID
* Four memory locations (8000h-8003h) are designated
* as ID locations where the user can store checksum or
* other code identification numbers. These locations are
* readable and writable during normal execution. See
* Section 11.5 “User ID, Device ID and Configuration
* Word Access” for more information on accessing these
* memory locations.
*---------------------------------------------------------------------------*/
#include "i2cslave.h"

/** Initialise I2C hardware in slave mode
 */
void i2c_slave_init() {
  }


