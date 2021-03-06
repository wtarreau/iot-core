local function print_load(f)
    print("Loading " .. f)
    dofile(f)
end

local function load_dir(dir)
  local toload={}
  for n,s in pairs(file.list()) do
    local b,e = string.find(n, dir .. "/")
    if b == 1 then table.insert(toload,n) end
  end

  if LFS and LFS._list then
    for i,n in pairs(LFS._list()) do
      local b,e = string.find(n, dir .. "_")
      if b == 1 then table.insert(toload,n .. ".lc") end
    end
  end

  table.sort(toload)

  for n,f in pairs(toload) do
    print_load(f)
  end
end

local function load_file(f)
  if file.exists(f .. ".lc") or (LFS and type(LFS[f]) == "function") then
    print_load(f .. ".lc")
  elseif file.exists(f .. ".lua") then
    print_load(f .. ".lua")
  end
end

load_file("nodemcu")
load_file("firmware")
load_file("board")
load_file("netconf")
load_file("sysconf")

load_dir("lib")

load_file("netsetup")
load_file("socket")
load_file("pre-svc")

load_dir("svc")

load_file("post-svc")

-- release memory
load_dir=nil

if not recovery or recovery() == 0 then
  load_file("appli")
else
  print("Skipping appli.lua due to recovery button")
end

load_file=nil
