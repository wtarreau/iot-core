-- to be sure to fix it
uart.setup(0,115200,8,0,1)

-- check if we have an LFS image available ("lfs.img")
if file.exists("lfs.img") then
  file.remove("lfs.tmp")
  file.rename("lfs.img", "lfs.tmp")
  if not node.flashreload then
    print("removing unsupported lfs.img")
  else
    print("flashing new lfs.img and rebooting")
    node.flashreload("lfs.tmp")
    print("failed (probably too low on memory")
    file.rename("lfs.tmp", "lfs.img")
  end
end

-- remove leftover from a previous upgrade
file.remove("lfs.tmp")

-- load all LFS symbols
if node.flashindex and not pcall(function() node.flashindex'_init'() end) then
  print("Caught exception while initializing LFS")
end

-- start, either from LFS or from SPIFFS
if file.exists("start.lc") or (LFS and LFS.start) then
  if not pcall(dofile,"start.lc") then
    print("Caught exception while initializing services")
  end
elseif file.exists("start.lua") then
  if not pcall(dofile,"start.lua") then
    print("Caught exception while initializing services")
  end
end
