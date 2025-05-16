--[[
LuCI - Lua Configuration Interface

Copyright 2016-2017 Caiqinghua <caiqinghua@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.btminer", package.seeall)

function index()
	entry({"admin", "status", "btminerstatus"}, cbi("btminer/btminerstatus"), _("Miner Status"), 1)
	entry({"admin", "status", "btminerapi"}, call("action_btminerapi"), _("Miner API Log"), 2)
	entry({"admin", "status", "btminerstatus", "restart"}, call("action_btminerrestart"), nil).leaf = true
	entry({"admin", "status", "checkupgrade"}, call("action_checkupgrade"), nil).leaf = true
	entry({"admin", "status", "set_miningmode"}, call("action_setminingmode"), nil).leaf = true
	entry({"admin", "status", "btminerdebug"}, call("action_btminerdebug"), nil).leaf = true
end

function btminer_restart()
	luci.util.exec("echo \"`date`|E007|Restart btminer|Web|Remote restart\" >> /tmp/event-restart-btminer")
	luci.util.exec("/etc/init.d/btminer restart")
end

function action_btminerrestart()
	btminer_restart()
	
	luci.http.redirect(
	luci.dispatcher.build_url("admin", "status", "btminerstatus")
	)
end

function action_btminerapi()
	local pp   = io.popen("cat /tmp/code/error/*; /usr/bin/btminer-api stats")
	local data = pp:read("*a")
	pp:close()

	luci.template.render("btminerapi", {api=data})
end

function num_commas(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

function valuetodate(elapsed)
	if elapsed then
		local str
		local days
		local h
		local m
		local s = elapsed % 60;
		elapsed = elapsed - s
		elapsed = elapsed / 60
		if elapsed == 0 then
			str = string.format("%ds", s)
		else
			m = elapsed % 60;
			elapsed = elapsed - m
			elapsed = elapsed / 60
			if elapsed == 0 then
				str = string.format("%dm %ds", m, s);
			else
				h = elapsed % 24;
				elapsed = elapsed - h
				elapsed = elapsed / 24
				if elapsed == 0 then
					str = string.format("%dh %dm %ds", h, m, s)
				else
					str = string.format("%dd %dh %dm %ds", elapsed, h, m, s);
				end
			end
		end
		return str
	end

	return "date invalid"
end

function summary()
	local data = {}
	local summary = luci.util.execi("/usr/bin/btminer-api -o summary | sed \"s/|/\\n/g\" ")
	if not summary then
		return
	end

	for line in summary do
		local elapsed, mhsav, accepted,
		rejected,
		fanspeedin, fanspeedout =
		line:match(".*," ..
			"Elapsed=(-?%d+)," ..
			"MHS av=(-?[%d%.]+)," ..
			".*," ..
			"Accepted=(-?%d+)," ..
			"Rejected=(-?%d+)," ..
			".*," ..
			"Fan Speed In=(-?%d+)," ..
			"Fan Speed Out=(-?%d+)," ..
			".*"
		)
		
		local power = require("luci.controller.btminer.power").get_power_pin()
		local voltage = require("luci.controller.btminer.power").get_power_vout_set()
		local workmode
		local power_mode = require("luci.controller.btminer.power").get_power_mode()
		if power_mode == 0 then
			workmode = "Low"
		elseif power_mode == 1 then
			workmode = "Normal"
		else
			workmode = "High"
		end

		if elapsed then
			data[#data+1] = {
				['elapsed'] = valuetodate(elapsed),
				['mhsav'] = num_commas(mhsav),
				['accepted'] = num_commas(accepted),
				['rejected'] = num_commas(rejected),
				['fanspeedin'] = num_commas(fanspeedin),
				['fanspeedout'] = num_commas(fanspeedout),
				['voltage'] = num_commas(voltage),
				['power'] = num_commas(power),
				['liquid_cool'] = "true",
				['workmode'] = workmode,
			}
		end
	end

	return data
end

function pools()
	local data = {}
	local pools = luci.util.execi("/usr/bin/btminer-api -o pools | sed \"s/|/\\n/g\" ")

	if not pools then
		return
	end

	for line in pools do
		local pi, url, st, pri, quo, gw, a, r, sta, gf,
		rf, user, lst, sa, sd =
		line:match("POOL=(-?%d+)," ..
			"URL=(.*)," ..
			"Status=(%a+)," ..
			"Priority=(-?%d+)," ..
			"Quota=(-?%d+)," ..
			"Getworks=(-?%d+)," ..
			"Accepted=(-?%d+)," ..
			"Rejected=(-?%d+)," ..
			".*," ..
			"Stale=(-?%d+)," ..
			"Get Failures=(-?%d+)," ..
			"Remote Failures=(-?%d+)," ..
			"User=(.*)," ..
			"Last Share Time=(-?%d+)," ..
			"Stratum Active=(%a+)," ..
			"Stratum Difficulty=(-?%d+)[%.%d]+")
		if pi then
			if lst == "0" then
				lst_date = "Never"
			else
				lst_date = os.date("%c", lst)
			end
			data[#data+1] = {
				['pool'] = pi,
				['url'] = url,
				['status'] = st,
				['priority'] = pri,
				['quota'] = quo,
				['getworks'] = gw,
				['accepted'] = a,
				['rejected'] = r,
				['stale'] = sta,
				['getfailures'] = gf,
				['remotefailures'] = rf,
				['user'] = user,
				['lastsharetime'] = lst_date,
				['stratumactive'] = sa,
				['stratumdifficulty'] = sd
			}
		end
	end

	return data
end

function devs(show_total)
	local data = {}
	local devs = luci.util.execi("/usr/bin/btminer-api -o edevs | sed \"s/|/\\n/g\" ")

	if not devs then
		return
	end

	for line in devs do
		local asc, slot, enabled, status, temp, freq, mhsav, mhs5s, mhs1m, mhs5m, 
		mhs15m, upfreq_complete, effective_chips =
		line:match("ASC=(%d+)," ..
			"Slot=(%d+)," ..
			"Enabled=(%a+)," ..
			"Status=(%a+)," ..
			"Temperature=(-?[%.%d]+)," ..
			"Chip Frequency=(%d+)," ..
			"MHS av=(-?[%.%d]+)," ..
			"MHS 5s=(-?[%.%d]+)," ..
			"MHS 1m=(-?[%.%d]+)," ..
			"MHS 5m=(-?[%.%d]+)," ..
			"MHS 15m=(-?[%.%d]+)," ..
			".*," ..
			"Upfreq Complete=(%d+)," ..
			"Effective Chips=(%d+)")

		if asc then
			data[#data+1] = {
				['name'] = "SM" .. slot,
				['enable'] = enabled,
				['status'] = status,
				['temp'] = temp,
				['freqs_avg'] = freq,
				['mhsav'] = mhsav,
				['mhs5s'] = mhs5s,
				['mhs1m'] = mhs1m,
				['mhs5m'] = mhs5m,
				['mhs15m'] = mhs15m,
				['upfreq_complete'] = upfreq_complete,
				['effective_chips'] = effective_chips
			}
		end
	end

	if show_total == 1 then
		local freqs_avg, mhsav_sum, mhs5s_sum, mhs1m_sum, mhs5m_sum , mhs15m_sum = 0, 0, 0, 0, 0, 0
		for i=1, #data do
			freqs_avg = freqs_avg + tonumber(data[i].freqs_avg)
			mhsav_sum = mhsav_sum + tonumber(data[i].mhsav)
			mhs5s_sum = mhs5s_sum + tonumber(data[i].mhs5s)
			mhs1m_sum = mhs1m_sum + tonumber(data[i].mhs1m)
			mhs5m_sum = mhs5m_sum + tonumber(data[i].mhs5m)
			mhs15m_sum = mhs15m_sum + tonumber(data[i].mhs15m)
		end
	
		if #data >= 1 then
			freqs_avg = freqs_avg / #data
		end
	
		data[#data+1] = {
			['name'] = 'Total',
			['enable'] = '',
			['status'] = '',
			['temp'] = '',
			['freqs_avg'] = tostring(freqs_avg),
			['mhsav'] = tostring(mhsav_sum),
			['mhs5s'] = tostring(mhs5s_sum),
			['mhs1m'] = tostring(mhs1m_sum),
			['mhs5m'] = tostring(mhs5m_sum),
			['mhs15m'] = tostring(mhs15m_sum),
			['upfreq_complete'] = '',
			['effective_chips'] = ''
		}
	end

	return data
end

function errors()
	local data = {}
	local error_codes = luci.util.execi("ls -1 /tmp/code/error/ 2> /dev/null");

	for line in error_codes do
		local get_cause = "cat /tmp/code/error/%d | cut -d '|' -f 4" % {line}
		local cause = luci.util.execi(get_cause);
		local get_time = "cat /tmp/code/error/%d | cut -d '|' -f 1" % {line}
		local time = luci.util.execi(get_time);

		data[#data+1] = {
			['code'] = line,
			['cause'] = cause(),
			['time'] = time()
		}
	end

	local get_avcode = "cat /sys/bitmicro/antivirus/error_code | cut -d '|' -f 1" 
	local avcode = luci.util.execi(get_avcode);	
	local get_avcode2 = "cat /sys/bitmicro/antivirus/error_code | cut -d '|' -f 1" 
	local avcode2= luci.util.execi(get_avcode);	
	if avcode2() then
		data[#data+1] = {
			['code'] = avcode(),
			['cause'] = "Illegal access to the system",
			['time'] = "Check log"
	}
	end

	return data
end

function events()
	local data = {}
	local count
	local lastline

	local info= {}

	info[#info+1] = {}
	info[#info].io = io.open("/root/.events/event-reboot-control-board")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io= io.open("/root/.events/event-reset-hash-board")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io= io.open("/tmp/event-restart-btminer")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io = io.open("/root/.events/event-zero-hash-rate")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io = io.open("/tmp/event-auto-adjust-voltage")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io = io.open("/tmp/board-reset-error")
	info[#info].detail = nil

	info[#info+1] = {}
	info[#info].io = io.open("/data/logs/event-pools-change")
	info[#info].detail = luci.dispatcher.build_url('admin/status/minerlog') .. '?tab.btminer.default=poolschange'

	for i=1, #info do
		if info[i].io then
			count = 0
			for line in info[i].io:lines() do
					count = count + 1
						lastline = line
			end
	
			local r1 = {}
	
			for a in string.gmatch(lastline, "([^|]+)") do
					table.insert(r1, a)
			end
	
			data[#data+1] = {
				['lasttime'] = r1[1],
				['id'] = r1[2],
				['action'] = r1[3],
				['source'] = r1[4],
				['cause'] = r1[5],
				['times'] = tostring(count),
				['detail'] = info[i].detail
			}

			io.close(info[i].io)
		end
	end

	return data
end

function action_setminingmode()
	local uci = luci.model.uci.cursor()
	local mmode = luci.http.formvalue("mining_mode")
	local modetab = {
			customs = " ",
			normal = "-c /etc/config/a4.normal",
			eco = "-c /etc/config/a4.eco",
			turbo = "-c /etc/config/a4.turbo"
			}

	if modetab[mmode] then
		uci:set("btminer", "default", "mining_mode", modetab[mmode])
		uci:save("btminer")
		uci:commit("btminer")
		if mmode == "customs" then
			luci.http.redirect(
			luci.dispatcher.build_url("admin", "status", "btminer")
			)
		else
			action_btminerrestart()
		end
	end
end

function action_mmupgrade()
	local mm_tmp   = "/tmp/mm.mcs"
	local finish_flag   = "/tmp/mm_finish"

	local function mm_upgrade_avail()
		if nixio.fs.access("/usr/bin/mm-tools") then
			return true
		end

		return nil
	end

	local function mm_supported()
		local mm_tmp   = "/tmp/mm.mcs"

		if not nixio.fs.access(mm_tmp) then
			return false
		end

		local filesize = nixio.fs.stat(mm_tmp).size

		-- TODO: Check mm.mcs format
		if filesize == 0 then
			return false
		end
		return true
	end

	local function mm_checksum()
		return (luci.sys.exec("md5sum %q" % mm_tmp):match("^([^%s]+)"))
	end

	local function storage_size()
		local size = 0
		if nixio.fs.access("/proc/mtd") then
			for l in io.lines("/proc/mtd") do
				local d, s, e, n = l:match('^([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+"([^%s]+)"')
				if n == "linux" or n == "firmware" then
					size = tonumber(s, 16)
					break
				end
			end
		elseif nixio.fs.access("/proc/partitions") then
			for l in io.lines("/proc/partitions") do
				local x, y, b, n = l:match('^%s*(%d+)%s+(%d+)%s+([^%s]+)%s+([^%s]+)')
				if b and n and not n:match('[0-9]') then
					size = tonumber(b) * 1024
					break
				end
			end
		end
		return size
	end

	local fp
	luci.http.setfilehandler(
		function(meta, chunk, eof)
			if not fp then
				if meta and meta.name == "image" then
					fp = io.open(mm_tmp, "w")
				end
			end
			if chunk then
				fp:write(chunk)
			end
			if eof and fp then
				fp:close()
			end
		end
	)

	if luci.http.formvalue("image") or luci.http.formvalue("step") then
		--
		-- Check firmware
		--
		local step = tonumber(luci.http.formvalue("step") or 1)
		if step == 1 then
			if mm_supported() == true then
				luci.template.render("mmupgrade", {
					checksum = mm_checksum(),
					storage  = storage_size(),
					size     = nixio.fs.stat(mm_tmp).size,
				})
			else
				nixio.fs.unlink(mm_tmp)
				luci.template.render("mmupload", {
					mm_upgrade_avail = mm_upgrade_avail(),
					mm_image_invalid = true
				})
			end
		--
		--  Upgrade firmware
		--
		elseif step == 2 then
			luci.template.render("mmapply")
			fork_exec("mmupgrade;touch %q;" %{ finish_flag })
		elseif step == 3 then
			nixio.fs.unlink(finish_flag)
			luci.template.render("mmapply", {
					finish = 1
				})
		end
	else
		luci.template.render("mmupload", {
			mm_upgrade_avail = mm_upgrade_avail()
		})
	end
end

function action_checkupgrade()
	local status = {}
	local finish_flag   = "/tmp/mm_finish"

	if not nixio.fs.access(finish_flag) then
		status.finish = 0
	else
		status.finish = 1
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end

function fork_exec(command)
	local pid = nixio.fork()
	if pid > 0 then
		return
	elseif pid == 0 then
		-- change to root dir
		nixio.chdir("/")

		-- patch stdin, out, err to /dev/null
		local null = nixio.open("/dev/null", "w+")
		if null then
			nixio.dup(null, nixio.stderr)
			nixio.dup(null, nixio.stdout)
			nixio.dup(null, nixio.stdin)
			if null:fileno() > 2 then
				null:close()
			end
		end

		-- replace with target command
		nixio.exec("/bin/sh", "-c", command)
	end
end

function action_btminerdebug()
	luci.util.exec("btminer-api \"debug|D\"")
	luci.http.redirect(
	luci.dispatcher.build_url("admin", "status", "btminerapi")
	)
end
