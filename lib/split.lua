-- Returns an array containing all parts of string <s> cut around any of the
-- delimiting characters in string <d>. This is useful to cut IP addresses or
-- MAC addresses around '.' and ':' for example.
local function split(s, d)
  local r = {}
  for m in string.gmatch(s,"([^"..d.."]+)") do
    r[#r+1]=m
  end
  return r
end

local G=getfenv()
G.split=split
