-- returns time in HH:MM:SS and YYYY-MM-DD formats, week day in [1..7] for
-- [Sun..Sat]. Also can return current time, taking care of time offset in
-- time_offset variable if set. Requires rtctime.

function time_hms(d)
  local t={0,0,0,0,0,0,0,0}
  if rtctime ~= nil then t=rtctime.epoch2cal(d) end
  return string.format("%02d:%02d:%02d",t["hour"],t["min"],t["sec"])
end

function time_ymd(d)
  local t={0,0,0,0,0,0,0,0}
  if rtctime ~= nil then t=rtctime.epoch2cal(d) end
  return string.format("%04d-%02d-%02d",t["year"],t["mon"],t["day"])
end

function time_wd(d)
  local t={0,0,0,0,0,0,0,0}
  if rtctime ~= nil then t=rtctime.epoch2cal(d) end
  return t["wday"]
end

function time_hms_now()
  local t=time_offset or 0
  if rtctime ~= nil then t=t+rtctime.get() end
  return time_hms(t)
end

function time_ymd_now()
  local t=time_offset or 0
  if rtctime ~= nil then t=t+rtctime.get() end
  return time_ymd(t)
end

function time_wd_now()
  local t=time_offset or 0
  if rtctime ~= nil then t=t+rtctime.get() end
  return time_wd(t)
end

-- returns y,m,d,h,m,s,wd
function time_get_now()
  local t={}
  if not rtctime then return 0,0,0,0,0,0,0 end
  t=rtctime.epoch2cal(rtctime.get() + (time_offset or 0))
  return t["year"],t["mon"],t["day"],t["hour"],t["min"],t["sec"],t["wday"]
end
