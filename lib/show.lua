local function totypedstring(x)
  if type(x) == "string" then x = '"' .. x .. '"' end
  x = tostring(x)
  return x
end

local function show(x)
  print(totypedstring(x))
  if type(x) == "userdata" then x=getmetatable(x) end
  local t=type(x)
  if t == "table" or t == "romtable" then
    local t={}
    for k in pairs(x) do table.insert(t,k) end
    pcall(function() table.sort(t) end)
    for i,k in ipairs(t) do print(string.format("  %-20s %s",k,totypedstring(x[k]))) end
  end
end

local function ls() show(file.list()) end

local G=getfenv()
G.show=show
G.ls=ls
