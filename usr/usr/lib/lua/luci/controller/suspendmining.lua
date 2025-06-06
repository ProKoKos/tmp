module("luci.controller.suspendmining", package.seeall)

function index()
    entry({"admin", "system", "suspendmining"}, call("suspend"), _("Suspend Mining"), 89)
end

function Is_Miner_Btminer()
    return luci.util.execi("grep BTMINER /etc/microbt_release | wc -l")() ~= "0"
end

local miner_status_link = ""

if Is_Miner_Btminer() then
		miner_status_link =	luci.dispatcher.build_url("admin", "status", "btminerstatus")
	else
		miner_status_link = luci.dispatcher.build_url("admin", "status", "cgminerstatus")
	end

function suspend()
    luci.util.exec("/usr/bin/poweroff.sh \'by user\'")
	luci.http.redirect(miner_status_link)
end