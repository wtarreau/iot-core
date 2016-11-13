local telnet_conns=0
local telnet_auth=false

if telnet_passwd==nil then
  telnet_passwd="" .. node.chipid() .. node.flashid() ..node.flashsize()
end
print("Starting telnet on port " .. 2323 .. " with password [" .. telnet_passwd .."]")
tcpsrv:listen(2323,function(c)
  local sending=false
  local buffer={}
  local function s_output(str)
    if c==nil or str==nil or str=="" then return end
    if sending then
      table.insert(buffer,str)
    else
      c:send(str)
      sending=true
    end
  end
  c:on("sent",function(c)
    sending=false
    if #buffer > 0 then
      c:send(table.remove(buffer,1))
      sending=true
    end
  end)
  c:on("disconnection",function(c)
    telnet_conns=telnet_conns-1
    if telnet_auth then
      node.output(nil)
    end
    if telnet_conns == 0 then
      telnet_auth=false
    end
  end)

  c:on("receive",function(c,l)
    if telnet_auth then
      c:hold()
      node.input(l)
      c:unhold()
    else
      local pass=l:gsub("\r",""):gsub("\n","")
      if pass:byte(1) == 255 then return end
      if pass == telnet_passwd then
        telnet_auth=true
        s_output("> ");
        node.output(s_output, 0)
      else
        s_output("Wrong password, try again.\nPassword: ");
      end
    end
  end)

  telnet_conns=telnet_conns+1
  s_output("[" ..
    string.format("%x",node.chipid()) .. "/" ..
    ((wifi.sta.getip()~=nil) and wifi.sta.getip() or wifi.ap.getip()) .. " - " ..
    telnet_conns .. ":" ..
    (telnet_auth and "AUTH" or "ANON") .. "]\n" ..
    ((telnet_auth and "> ") or ((telnet_conns == 1) and "Password: ") or "Authenticate first!\n"))

  if (telnet_auth) then
    node.output(s_output, 0)
  elseif telnet_conns > 1 then
    c:close()
  end
end)
