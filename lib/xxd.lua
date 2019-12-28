local function xxd(fn)
  local p,f = 0, file.open(fn, "rb")
  while f do
    local o,h,d = "", "", f:read(16)
    for b = 1,16 do
      if b <= #d then
        local k = d:sub(b,b)
        local c = k:byte()
	h = h .. string.format('%02x ', c)
        if (c < 32 or c > 127) then k = "." end
        o = o .. k
      else
        h = h .. "   "
	file.close(f)
	f = nil
      end
    end
    print(string.format('%04x: ', p) .. h .. " " .. o)
    p = p + 16
  end
end

local G=getfenv()
G.xxd=xxd
