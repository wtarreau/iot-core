function debounce(pin)
  local val=gpio.read(pin)
  local cnt=0

  while cnt < 5 do
    if gpio.read(pin) ~= val then
      val=gpio.read(pin)
      cnt=0
    else
      tmr.delay(10000)
      cnt=cnt+1
    end
  end
  return val
end
