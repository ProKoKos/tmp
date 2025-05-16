--[[
LuCI - Lua Configuration Interface

Copyright 2016-2017 CaiQinghua <caiqinghua@gmail.com>
Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--
btnref = luci.dispatcher.build_url("admin", "status", "btminerstatus", "restart")
f = SimpleForm("btminerstatus", translate("Miner Status") ..
		    "  <input type=\"button\" class=\"btn btn-danger\"value=\" " .. translate("Restart Miner") .. " \" onclick=\"location.href='" .. btnref .. "'\" href=\"#\"/>",
		    translate("Please visit <a href='https://www.whatsminer.com'> https://www.whatsminer.com</a> for support."))

f.reset = false
f.submit = false

local error_data = luci.controller.btminer.errors()
if #error_data == 0 then
	f1 = SimpleForm("", "", translate(""))
else
	f1 = SimpleForm("", "<p class=\"alert-message warning\">Warning: There are "..#error_data.." errors that affect the machine running!</p>", translate(""))
end
f1.reset = false
f1.submit = false
f1.embedded = true

btminer_summary = luci.controller.btminer.summary()
t0 = f:section(Table, btminer_summary, translate("Summary"))

local function get_cool_mode()
	local cool_mode = luci.util.execi("uci get btminer.default.cool_mode 2> /dev/null")
	local val = cool_mode()
	if val == nil then 
		return 0
	end
	return val
end

t0:option(DummyValue, "elapsed", translate("Elapsed"))
ghsav = t0:option(DummyValue, "mhsav", translate("GHSav"))
function ghsav.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section):gsub(",","")
	return string.format("%.2f", tonumber(v)/1000)
end

t0:option(DummyValue, "accepted", translate("Accepted"))
t0:option(DummyValue, "rejected", translate("Rejected"))
local cool_mode = get_cool_mode()
if cool_mode ~= 0 then
t0:option(DummyValue, "liquid_cool", translate("Liquid Cooling"))
else
t0:option(DummyValue, "fanspeedin", translate("FanSpeedIn"))
t0:option(DummyValue, "fanspeedout", translate("FanSpeedOut"))
end
t0:option(DummyValue, "voltage", translate("Voltage"))
if btminer_summary[1] ~= nil and btminer_summary[1]['power'] ~= '-1' then
t0:option(DummyValue, "power", translate("Power"))
end
t0:option(DummyValue, "workmode", translate("Power Mode"))

t1 = f:section(Table, luci.controller.btminer.devs(1), translate("Devices"))
t1:option(DummyValue, "name", translate("Device"))

freq = t1:option(DummyValue, "freqs_avg", translate("Frequency"))
function freq.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.0f", v)
end

ghsav = t1:option(DummyValue, "mhsav", translate("GHSav"))
function ghsav.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v/1000)
end

ghs5s = t1:option(DummyValue, "mhs5s", translate("GHS5s"))
function ghs5s.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v/1000)
end

ghs1m = t1:option(DummyValue, "mhs1m", translate("GHS1m"))
function ghs1m.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v/1000)
end

ghs5m = t1:option(DummyValue, "mhs5m", translate("GHS5m"))
function ghs5m.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v/1000)
end

ghs15m = t1:option(DummyValue, "mhs15m", translate("GHS15m"))
function ghs15m.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v/1000)
end


t2 = f:section(Table, luci.controller.btminer.devs(0), translate(""))
t2:option(DummyValue, "name", translate("Device"))
t2:option(DummyValue, "status", translate("Status"))
t2:option(DummyValue, "upfreq_complete", translate("UpfreqCompleted"))
t2:option(DummyValue, "effective_chips", translate("EffectiveChips"))

temp=t2:option(DummyValue, "temp", translate("Temperature"))
function temp.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	return string.format("%.2f", v)
end

t3 = f:section(Table, luci.controller.btminer.pools(), translate("Pools"))
t3:option(DummyValue, "pool", translate("Pool"))
t3:option(DummyValue, "url", translate("URL"))
t3:option(DummyValue, "stratumactive", translate("Active"))
t3:option(DummyValue, "user", translate("User"))
t3:option(DummyValue, "status", translate("Status"))
t3:option(DummyValue, "stratumdifficulty", translate("Difficulty"))
t3:option(DummyValue, "getworks", translate("GetWorks"))
t3:option(DummyValue, "accepted", translate("Accepted"))
t3:option(DummyValue, "rejected", translate("Rejected"))
t3:option(DummyValue, "stale", translate("Stale"))
t3:option(DummyValue, "lastsharetime", translate("LST"))


t4 = f:section(Table, error_data, translate("Errors"))
t4:option(DummyValue, "code", translate("ErrorCode"))
t4:option(DummyValue, "cause", translate("Cause"))
t4:option(DummyValue, "time", translate("Time"))

local data = luci.controller.btminer.events()
t4 = f:section(Table, data, translate("Events"))
t4:option(DummyValue, "id", translate("EventCode"))
t4:option(DummyValue, "cause", translate("EventCause"))
t4:option(DummyValue, "action", translate("EventAction"))
t4:option(DummyValue, "times", translate("EventCount"))
t4:option(DummyValue, "lasttime", translate("LastTime"))
t4:option(DummyValue, "source", translate("EventSource"))
x = t4:option(Button, "detail", translate("Detail"))
x.render = function(self, section, scope)
    if data[section]['detail'] then
        Button.render(self, section, scope)
    end
end
x.write = function(self, section, value)
    if data[section]['detail'] then
        luci.http.redirect(data[section]['detail'])
    end
end

return f1, f
