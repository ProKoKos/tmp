--[[]]
local n=require"luci.fs"
local t=luci.http
ful=SimpleForm("upgrade",translate("Upgrade"),nil)
ful.reset=false
ful.submit=false
sul=ful:section(SimpleSection,"",translate("Firmware file looks like whatsminer-***.bin"))
fu=sul:option(FileUpload,"")
fu.template="cbi/other_upload"
um=sul:option(DummyValue,"",nil)
um.template="cbi/other_dvalue"
um.value=translate("If upgrade success, it will be rebooted automatically.")

local a,e
a="/tmp/upgrade/"
nixio.fs.mkdir(a)
t.setfilehandler(
function(t,o,i)
if not e then
if not t then return end
if t and o then e=nixio.open(a..t.file,"w")end
if not e then
um.value=translate("Create upgrade file error.")
return
end
end
if o and e then
e:write(o)
end
if i and e then
e:close()
e=nil
--[[upgrade firmware]]
um.value=translate("If upgrade success, it will be rebooted automatically.")
luci.sys.call(" mv /tmp/upgrade/* /tmp/upgrade-package-web.bin")
luci.sys.call(" upgrade-web &")
end
end
)
if luci.http.formvalue("upgrade")then
local e=luci.http.formvalue("ulfile")
if#e<=0 then
um.value=translate("No specify upgrade file.")
end
end
return ful
