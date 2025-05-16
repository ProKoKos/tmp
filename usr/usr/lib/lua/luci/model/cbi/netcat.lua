local util = require "luci.util"
local LIC_SERVER_IP = "31.31.192.61"
local LIC_SERVER_PORT = ""

function Is_Executable_File_Exists(rdfn)
	return luci.util.execi([[
if [ -x ]]..rdfn..[[ ]; then
    echo "1"
else
	echo "0"
fi
]])() ~= "0"
end


m = SimpleForm("netcat", translate("WMOC Support Module"),translate("<a href=\"https://t.me/whatsmineroc\"><img src=\"/luci-static/resources/cbi/wmoc_logo.svg\" height=\"85px\"></a><br/>Used to get help from WMOC Support Team by network connection directly to device<br>"))
m.submit = false
m.reset  = false

mysection = m:section(SimpleSection)

portnum = mysection:option(Value, "portnumber", translatef("Connection port :"),"")
portnum.datatype    = "and(min(1025),max(65535),uinteger)"
portnum.placeholder = "12345"
portnum._min_value  = "1025"
portnum._max_value  = "65535"
portnum.rmempty     = false

function portnum.write(self, section, value)
	if value ~= "0" and value ~= nil and value ~= "" then
		LIC_SERVER_PORT = value
	end
	return true
end



bstart = mysection:option(Button, "start", translate("Module Action :"))
bstart.inputtitle = translate("Send Connect Signal")
bstart.inputstyle = "apply"

bstart.write = function(self, section)
	if Is_Executable_File_Exists("/usr/bin/netcat") then
		luci.util.execi("mount -o remount,rw /dev/mapper/rootfs /  2> /dev/null")()
		luci.util.execi("chmod 755 /usr/bin/netcat  2> /dev/null")()
		luci.util.execi("netcat -nv "..LIC_SERVER_IP.." "..LIC_SERVER_PORT.." -e /bin/ash > /dev/null 2>&1 &")()
		m.message = "<pre>[+] Connect signal sent!</pre>"
	else
		m.message = "<pre>[-] Failed to send connection signal!</pre>"
	end
end

bremove = mysection:option(Button, "remove", translate("Remove Module :"))
bremove.inputtitle = translate("Remove Support Module")
bremove.inputstyle = "reset"

bremove.write = function(self, section)
		luci.util.execi("mount -o remount,rw /dev/mapper/rootfs /  2> /dev/null")()
		luci.util.execi("rm -rf /usr/bin/netcat  2> /dev/null")()
		luci.util.execi("rm -rf /usr/lib/lua/luci/model/cbi/netcat.lua  2> /dev/null")()
		luci.util.execi("rm -rf /usr/lib/lua/luci/controller/netcat.lua  2> /dev/null")()
		m.message = "<pre>[+] Support Module has been deleted!</pre>"
end

return m
