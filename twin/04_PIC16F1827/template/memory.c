/*---------------------------------------------------------------------------*
* Sample program - a simple 16 byte I2C addressable memory store.
*----------------------------------------------------------------------------*
* 19-Nov-2013 ShaneG
*
* This simple example simply provided 16 locations that can be used to store
* byte values. These appear as registers 1 to 16.
*---------------------------------------------------------------------------*/
#include "i2cslave.h"

/* Number of I2C registers available */
#define REGISTER_COUNT 16

/** Register values
 */
static byte g_registers[REGISTER_COUNT];

/** Called when a register is being written to
 *
 * @param reg the address of the register to write
 * @param value the value to write into the register
 *
 * @return the register address to move to for the next byte of data
 */
byte i2c_slave_write(byte reg, byte value) {
  if(reg<=REGISTER_COUNT)
    g_registers[reg - 1] = value;
  return reg + 1;
  }

/** Called when a register is being read
 *
 * @param reg the address of the register to read
 *
 * @return the current value of the register
 */
byte i2c_slave_write(byte reg) {
  if(reg<=REGISTER_COUNT)
    return g_registers[reg - 1];
  /* Not a valid register, use a default value */
  return 0x00;
  }

/** Program entry point
 */
void main() {
  /* Initialise register values */
  byte i;
  for(i=0; i<REGISTER_COUNT; i++)
    g_registers[i] = i;
  /* Start I2C operations */
  i2c_slave_init();
  /* Everything is interrupt driven, go into busy waiting loop */
  while(1);
  }
