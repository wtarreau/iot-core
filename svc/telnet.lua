local telnet_conns=0
tcpsrv:listen(2323,function(c)
  local sending=false
  local buffer={}
  local function s_output(str)
    if c==nil then return end
    if sending then
      table.insert(buffer,str)
    else
      c:send(str)
      sending=true
    end
  end
  node.output(s_output, 0)
  c:on("receive",function(c,l)
    c:hold()
    node.input(l)
    c:unhold()
  end)
  c:on("sent",function(c)
    sending=false
    if #buffer > 0 then
      c:send(table.remove(buffer,1))
      sending=true
    end
  end)
  c:on("disconnection",function(c)
    telnet_conns=telnet_conns-1
    node.output(nil)
  end)
  telnet_conns=telnet_conns+1
  print("[" .. ((wifi.sta.getip()~=nil) and wifi.sta.getip() or wifi.ap.getip()) .. " - " .. telnet_conns .. "]\n> ")
end)
