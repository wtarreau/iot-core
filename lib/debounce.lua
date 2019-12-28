-- reads GPIO pin <pin> waiting for it to remain stable for at least 50ms and
-- returns its final value.
local function debounce(pin)
  local  val, cnt = nil, 0
  if pin == nil then return 0 end
  while cnt < 5 do
    cnt = cnt + 1
    if gpio.read(pin) ~= val then
      val, cnt = gpio.read(pin), 0
    end
    tmr.delay(10000)
  end
  return val
end

local G=getfenv()
G.debounce=debounce
