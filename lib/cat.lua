local function cat(n)
  local f = n and file.open(n,"r")
  while f do
    local p = file.read(f)
    if p then print(p) else file.close(f) f=nil end
  end
end

local G=getfenv()
G.cat=cat
