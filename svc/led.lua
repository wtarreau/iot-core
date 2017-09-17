-- export led functions and turn off the board's led if defined (brd_led)
-- supports brd_led_inv (nil/0 = not inverted, >0=inverted)
brd_led_inv = brd_led_inv or 0

function led_off()
  if brd_led then gpio.write(brd_led, brd_led_inv==0 and 0 or 1) end
end

function led_on()
  if brd_led then gpio.write(brd_led, brd_led_inv==0 and 1 or 0) end
end

function led(col)
  if col and col > 0 then led_on() else led_off() end
end

led_off()
