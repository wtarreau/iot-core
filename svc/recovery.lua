-- this is used to abort sensitive processing (network etc) when a button is
-- pressed during boot. It checks button 1 which the board may defined in
-- brd_btn1 and returns 1 if pressed (button is supposed to use a pull-up).

function recovery()
  if not brd_btn1 then return 0 end
  return gpio.read(brd_btn1) == 0 and 1 or 0
end
