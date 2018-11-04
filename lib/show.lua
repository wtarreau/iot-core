function show(x) for k,v in pairs(x) do print(k,v) end end
function sshow(x)
  local t = {}
  for k in pairs(x) do table.insert(t, k) end
  table.sort(t)
  for i,k in ipairs(t) do print(k,x[k]) end
end
