function disp_init()
  if not brd_oled_addr then return end
  local fct = u8g.ssd1306_128x64_i2c or u8g.ssd1306_128x32_i2c or u8g.ssd1306_64x64_i2c
  -- release unused memory
  u8g.ssd1306_128x32_hw_spi=nil
  u8g.ssd1306_128x64_hw_spi=nil
  if not fct then return end
  disp = fct(brd_oled_addr)
  if disp ~= nil then
    disp:begin()
    disp_reset_font()
  end
end

function disp_reset_font(f)
  if not disp then return end
  disp:setFont(f or default_font or DISP_FONT or u8g.font_6x10 or u8g.font_5x8 or u8g.font_04b_03 or u8g.font_chikita)
  disp:setFontRefHeightExtendedText()
  disp:setDefaultForegroundColor()
  disp:setFontPosTop()
end

function disp_clear()
  if not disp then return end
  disp:firstPage()
  while disp:nextPage() do end
end

function disp_lines(...)
  local args={...}
  local arg
  if not disp then return end
  disp:firstPage()
  repeat
    for arg=1,#args do
      disp:drawStr(0,(arg-1)*disp:getFontLineSpacing(),args[arg])
    end
  until not disp:nextPage()
end

disp_init()
if wifi ~= nil then
  local ssid=wifi.sta.getconfig(wifi.sta.getapindex())
  local a,b=node.bootreason()
  disp_reset_font(u8g.font_04b_03)
  disp_lines(
    "Booting " .. (wifi.sta.gethostname and wifi.sta.gethostname() or "?"),
    "MAC: " .. (wifi.sta.getmac and wifi.sta.getmac() or "?"),
    "AP: " .. (ssid or "<none>"),
    "Mode: " .. (recovery and recovery() > 0 and "dbg" or "run") .. ", boot " .. a .. "," .. b)
  disp_reset_font()
end
