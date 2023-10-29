-- returns time in HH:MM:SS and YYYY-MM-DD formats, week day in [1..7] for
-- [Sun..Sat]. Also can return current time, taking care of time offset in
-- time_offset variable if set (should be set in timezone.lua, set in seconds
-- from UTC). Requires rtctime, which is automatically checked for.

-- returns time <d> as {year,mon,day,hour,min,sec,wday,yday} a-la localtime()
local function time_local(d)
  return rtctime and rtctime.epoch2cal(d) or {
    year=0, mon=0, day=0,
    hour=0, min=0, sec=0,
    wday=0, yday=0}
end

-- returns current time as {year,mon,day,hour,min,sec,wday,yday} a-la localtime()
local function time_now()
  return time_local(rtctime and (rtctime.get() + (time_offset or 0)) or 0)
end

-- returns "HH:MM:SS" from a time_local()/time_now() output
local function time_hms(t)
  return string.format("%02d:%02d:%02d",t["hour"],t["min"],t["sec"])
end

-- returns "YYYY-MM-DD" from a time_local()/time_now() output
local function time_ymd(t)
  return string.format("%04d-%02d-%02d",t["year"],t["mon"],t["day"])
end

-- returns the day of week (int) from a time_local()/time_now() output
local function time_wd(t)
  return t["wday"]
end

-- returns y,m,d,h,m,s,wd from current time
local function time_get_now()
  local t=time_now()
  return t["year"],t["mon"],t["day"],t["hour"],t["min"],t["sec"],t["wday"]
end

local G=getfenv()
G.time_local=time_local
G.time_now=time_now
G.time_hms=time_hms
G.time_ymd=time_ymd
G.time_wd=time_wd
G.time_get_now=time_get_now
