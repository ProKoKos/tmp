-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local sys   = require "luci.sys"
local zones = require "luci.sys.zoneinfo"
local fs    = require "nixio.fs"
local conf  = require "luci.config"

local m, s, o
local has_ntpd = fs.access("/usr/sbin/ntpd")

m = Map("system", translate("System"), translate("Here you can configure the basic aspects of your device like the timezone."))
m:chain("luci")

function commit_handler(...)
	fs.chmod("/etc/config/system", 666)
end
m.commit_handler = commit_handler

s = m:section(TypedSection, "system", translate("System Properties"))
s.anonymous = true
s.addremove = false


--
-- System Properties
--

o = s:option(DummyValue, "_systime", translate("Local Time"))
o.template = "admin_system/clock_status"

o = s:option(ListValue, "zonename", translate("Timezone"))
o:value("UTC")

for i, zone in ipairs(zones.TZ) do
	o:value(zone[1])
end

function o.write(self, section, value)
	local function lookup_zone(title)
		for _, zone in ipairs(zones.TZ) do
			if zone[1] == title then return zone[2] end
		end
	end

	AbstractValue.write(self, section, value)
	local timezone = lookup_zone(value) or "GMT0"
	self.map.uci:set("system", section, "timezone", timezone)
	fs.writefile("/etc/TZ", timezone .. "\n")
end


--
-- NTP
--

if has_ntpd then

	-- timeserver setup was requested, create section and reload page
	if m:formvalue("cbid.system._timeserver._enable") then
		m.uci:section("system", "timeserver", "ntp",
			{
                	server = { "0.openwrt.pool.ntp.org", "1.openwrt.pool.ntp.org", "2.openwrt.pool.ntp.org", "3.openwrt.pool.ntp.org" }
			}
		)

		m.uci:save("system")
		luci.http.redirect(luci.dispatcher.build_url("admin/system", arg[1]))
		return
	end

	local has_section = false
	m.uci:foreach("system", "timeserver", 
		function(s) 
			has_section = true 
			return false
	end)

	if not has_section then

		s = m:section(TypedSection, "timeserver", translate("Time Synchronization"))
		s.anonymous   = true
		s.cfgsections = function() return { "_timeserver" } end

		x = s:option(Button, "_enable")
		x.title      = translate("Time Synchronization is not configured yet.")
		x.inputtitle = translate("Set up Time Synchronization")
		x.inputstyle = "apply"

	else
		
		s = m:section(TypedSection, "timeserver", translate("Time Synchronization"))
		s.anonymous = true
		s.addremove = false

		o = s:option(Flag, "enabled", translate("Enable NTP client"))
		o.rmempty = false

		function o.write(self, section, value)
			if (value == "1") then
				sys.init.enable("sysntpd")
				sys.call("env -i /etc/init.d/sysntpd start >/dev/null")
			else
				sys.call("env -i /etc/init.d/sysntpd stop >/dev/null")
				sys.init.disable("sysntpd")
			end
			self.map.uci:set("system", section, "enabled", value)
		end


		-- o = s:option(Flag, "enable_server", translate("Provide NTP server"))
		-- o:depends("enable", "1")


		o = s:option(DynamicList, "server", translate("NTP server candidates"))
		o.datatype = "host(0)"
		o:depends("enabled", "1")

		-- retain server list even if disabled
		function o.remove() end

	end
end

return m
