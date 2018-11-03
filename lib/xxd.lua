function xxd(fn)
  local f,d,b,c,o; local h={}; local p=0
  f=file.open(fn,"rb")
  while f~=nil do
    d=f:read(16); o=""
    for b=1,16 do
      if b<=#d then
        c=d:byte(b); h[b]=string.format('%02x ',c)
        if (c>=32 and c<=127) then o=o..d:sub(b,b) else o=o.."." end
      else
        h[b]="   "; file.close(f); f=nil
      end
    end
    print(string.format('%04x: ',p)..h[1]..h[2]..h[3]..h[4]..h[5]..h[6]..h[7]..h[8]..h[9]..h[10]..h[11]..h[12]..h[13]..h[14]..h[15]..h[16].." "..o)
    p=p+16
  end
end
