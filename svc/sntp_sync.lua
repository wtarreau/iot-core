-- SNTP server, non critical
if recovery and recovery() ~= 0 then return end

function sntp_sync()
  if sntp and sntp_srv_ip then
    sntp.sync(sntp_srv_ip, function()
      sntp_sync_state=1
      sntp_last_sync=tmr.time()
    end, function()
      sntp_sync_state=0
    end, 1)
  end
end
