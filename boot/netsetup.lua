wifi_retry=0
wifi.setmode(wifi.STATION)
if (wifi_sta_ip~=nil) then wifi.sta.setip({ip=wifi_sta_ip,netmask=wifi_sta_nm,gateway=wifi_sta_gw}) end
wifi_sta_ip=nil wifi_sta_nm=nil wifi_sta_gw=nil
if (wifi_sta_passwd==nil) then wifi_sta_passwd="" end
if (wifi_sta_ssid~=nil) then
  local cfg={ssid=wifi_sta_ssid,pwd=(wifi_sta_passwd~="") and wifi_sta_passwd or nil,bssid=wifi_sta_bssid}
  print("WiFi : trying " .. wifi_sta_ssid .. (wifi_sta_passwd == "" and " without password" or ""))
  wifi.sta.config(cfg)
  wifi_retry=20
end
wifi_sta_ssid=nil wifi_sta_passwd=nil wifi_sta_bssid=nil

tmr.alarm(0,500,tmr.ALARM_SEMI,function()
  local status=wifi.sta.status()
  local stnames={"idle","connecting","wrongpwd","apnotfound","fail","done"}
  if status~=5 then
    if wifi_retry > 0 then
      print("WiFi : st=<" .. stnames[status+1] .. "> retrying #" .. wifi_retry)
      wifi_retry=wifi_retry-1
      tmr.start(0)
    else
      wifi.sta.disconnect() wifi.setmode(wifi.SOFTAP)
      local cfg={ssid="iot4h-"..node.chipid(), pwd="password"..node.flashid()}
      print("WiFi : switching to AP. SSID="..cfg.ssid.." PWD="..cfg.pwd)
      wifi.ap.config(cfg) cfg=nil wifi_retry=nil
    end
  else
    print("WiFi connected: IP="..wifi.sta.getip().." MAC="..wifi.ap.getmac())
    wifi_retry=nil
    if sntp_sync ~= nil and (not recovery or recovery() == 0) then sntp_sync() end
  end
end)
