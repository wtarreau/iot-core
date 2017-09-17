function load_dir(dir)
  local toload={}
  for n,s in pairs(file.list()) do
    b,e = string.find(n, dir .. "/")
    if b == 1 then table.insert(toload,n) end
  end
  table.sort(toload)

  for n,f in pairs(toload) do
    print("Loading " .. f)
    dofile(f)
  end
end

if file.exists("nodemcu.lua") then dofile("nodemcu.lua") end
if file.exists("firmware.lua") then dofile("firmware.lua") end
if file.exists("board.lua") then dofile("board.lua") end

if file.exists("netconf.lua") then dofile("netconf.lua") end
if file.exists("sysconf.lua") then dofile("sysconf.lua") end

load_dir("lib")

if file.exists("netsetup.lua") then dofile("netsetup.lua") end
if file.exists("socket.lua") then dofile("socket.lua") end
if file.exists("pre-svc.lua") then dofile("pre-svc.lua") end

load_dir("svc")

if file.exists("post-svc.lua") then dofile("post-svc.lua") end

if not recovery or recovery() == 0 then
  if file.exists("appli.lc") then dofile("appli.lc")
  elseif file.exists("appli.lua") then dofile("appli.lua")
  end
else
  print("Skipping appli.lua due to recovery button")
end
