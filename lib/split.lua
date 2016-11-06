function split(s, d) local i=1; local r={}; for m in string.gmatch(s,"([^"..d.."]+)") do r[i]=m i=i+1 end return r end
