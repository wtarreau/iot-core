if file.exists("nodemcu.lua") then dofile("nodemcu.lua") end
if file.exists("firmware.lua") then dofile("firmware.lua") end
if file.exists("board.lua") then dofile("board.lua") end

if file.exists("netconf.lua") then dofile("netconf.lua") end
if file.exists("sysconf.lua") then dofile("sysconf.lua") end
for n,s in pairs(file.list()) do
  b,e = string.find(n, "lib/")
  if b == 1 then print("Loading " .. n) dofile(n) end
end
if file.exists("netsetup.lua") then dofile("netsetup.lua") end
if file.exists("socket.lua") then dofile("socket.lua") end
if file.exists("pre-svc.lua") then dofile("pre-svc.lua") end
for n,s in pairs(file.list()) do
  b,e = string.find(n, "svc/")
  if b == 1 then print("Loading " .. n) dofile(n) end
end
if file.exists("post-svc.lua") then dofile("post-svc.lua") end
if file.exists("appli.lc") then dofile("appli.lc") end
if file.exists("appli.lua") then dofile("appli.lua") end
