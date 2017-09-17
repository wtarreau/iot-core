-- setup an I2C channel if pins are defined
if brd_sda and brd_scl then
  i2c.setup(0, brd_sda, brd_scl, I2C_SPEED or i2c.SLOW)
end
