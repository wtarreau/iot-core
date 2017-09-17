function cat(n)
  local f = n and file.open(n,"r")
  while f ~= nil do
    local p = file.read(f)
    if not p then file.close(f) f=nil else print(p) end
  end
end
