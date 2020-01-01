-- return the ADC's value in volt. It can use a scaling factor in brd_adc_a and
-- a base value in brd_adc_b so that the output is ax+b mV. It returns 65535 if
-- the value couldn't be read.
local function adc_mv()
  if not adc then return 65535 end
  local mv = adc.read(0)
  if mv == 65535 then return 65535 end
  mv = mv / 1.023  -- turn the value to millivolts
  if type(brd_adc_a) == "number" then mv=mv * brd_adc_a end
  if type(brd_adc_b) == "number" then mv=mv + brd_adc_b end
  return mv  
end

local G=getfenv()
G.adc_mv=adc_mv
