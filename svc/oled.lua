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

-- Draw the segments represented by the bit field <code> with top left corner
-- at (x0,y0). <code> has one bit set per segment to illuminate. Segments are
-- 12 pixels wide or high, thus digits are 20 pixels high and 12 pixels
-- wide. Segments are numbered this way and are represented by a bit each :
--    0       | Line positions for each of the 7 segments are defined by
-- 5     1    | <from>,<to>, each encoded as half a byte made of: bit[2] for
--    6       | x (0=left, 1=right), bits[1,0] for y (0=top,1=middle,2=down,
-- 4     2    | 3=underline). <from> is in the high nibble, <to> in the low.
--    3       | Lines are stripped by one pixel on each end.
--    7       | 7 is an underline.
function draw_7seg(x0,y0,code)
  local coord=string.char(0x04, 0x45, 0x56, 0x26, 0x12, 0x01, 0x15, 0x37)
  local x1,y1,x2,y2,seg,pos
  if not disp then return end
  for seg=1,8 do
    if code % 2 == 1 then
      pos=string.byte(coord,seg)
      x1=math.floor((pos/16)/4)%2*9   y1=math.floor(pos/16)%4*9
      x2=math.floor(pos/4)%2*9        y2=pos%4*9
      if y1 > 18 then y1=22 end
      if y2 > 18 then y2=22 end
      if x1==x2 then
        disp:drawLine(x1+x0+0, y1+y0+2, x2+x0+0, y2+y0+0)
        disp:drawLine(x1+x0+1, y1+y0+1, x2+x0+1, y2+y0+1)
        disp:drawLine(x1+x0+2, y1+y0+2, x2+x0+2, y2+y0+0)
      elseif y1==y2 then
        disp:drawLine(x1+x0+2, y1+y0+0, x2+x0+0, y2+y0+0)
        disp:drawLine(x1+x0+1, y1+y0+1, x2+x0+1, y2+y0+1)
        disp:drawLine(x1+x0+2, y1+y0+2, x2+x0+0, y2+y0+2)
      else
        disp:drawLine(x1+x0+1,y1+y0+1,x2+x0+1,y2+y0+1)
      end
      code=code-1
    end
    code=code/2
  end
end

-- Display character <c> with top left corner at (x0,y0). For now values of <d>
-- may be within '0' and '9'. An optional non-zero value may be passed as a 4th
-- argument to underline the character. Characters are 12 pixels wide by 20
-- pixels high (24 with the underline).
function disp_7seg(x0,y0,c,u)
  local code=string.byte(c)
  if not disp then return end
  if code >= 0x30 and code <= 0x39 then
    local dig=string.char(0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6d, 0x7d, 0x07, 0x7F, 0x6F)
    draw_7seg(x0,y0,string.byte(dig,code-0x30+1)+(u and u>0 and 128 or 0))
  elseif code == 0x3a then
    disp:drawDisc(x0+5, y0+5, 2, DRAW_ALL)
    disp:drawDisc(x0+5, y0+13, 2, DRAW_ALL)
  end
end

disp_init()
-- release unused memory
disp_init = nil

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
