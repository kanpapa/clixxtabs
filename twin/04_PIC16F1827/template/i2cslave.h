/*---------------------------------------------------------------------------*
* Simple I2C client implementation for 16F1827 chips.
*----------------------------------------------------------------------------*
*---------------------------------------------------------------------------*/
#ifndef __I2CSLAVE_H
#define __I2CSLAVE_H

/** Initialise I2C hardware in slave mode
 */
void i2c_slave_init();

/** Called when a register is being written to
 *
 * This function must be provided by the user application and is called for
 * all register write requests for registers >= 1 (register 0 is reserved for
 * changing the I2C address of the chip).
 *
 * The library supports block writes (a single address followed by multiple
 * data bytes) so the function must return the value of the register to write
 * the next byte of data to.
 *
 * @param reg the address of the register to write
 * @param value the value to write into the register
 *
 * @return the register address to move to for the next byte of data
 */
byte i2c_slave_write(byte reg, byte value);

/** Called when a register is being read
 *
 * This function must be provided by the user application and is called for
 * all register read operations for registers >= 1 (register 0 is reserved for
 * changing the I2C address of the chip). It simply returns the current value
 * of the specified register.
 *
 * @param reg the address of the register to read
 *
 * @return the current value of the register
 */
byte i2c_slave_write(byte reg);

#endif /* __I2CSLAVE_H */

