module("luci.controller.exportlogs", package.seeall)

function index()
    entry({"admin", "status", "exportlogs"}, call("getlogs"), _("Export Logs"), 9)
end

local logspath     = "/tmp/logs.tgz"
local ipaddr       = luci.util.execi("ifconfig eth0|grep inet|awk '{print $2}'|tr -d \"addr:\"")()
local savelogspath = "/www/luci-static/logs_".. ipaddr ..".tgz"
local logslink     = "../../../../../luci-static/logs_".. ipaddr ..".tgz"

function Copy_File_Overwrite(src_file,dest_file)
	return luci.util.execi("cp -dvf " ..src_file.. " " ..dest_file.."  2> /dev/null && echo 1 || echo 0")() ~= "0"
end

function getlogs()
    luci.util.exec("mount -o remount,rw /dev/mapper/rootfs /")
	luci.util.exec("rm -rf " .. logspath)
	luci.util.exec("rm -rf /www/luci-static/logs_*")
	luci.util.exec("/usr/bin/pack-miner-logs")
	
	if Copy_File_Overwrite(logspath,savelogspath) then
		luci.util.exec("mount /dev/mapper/rootfs -o remount,ro >/dev/null 2>&1")
		luci.http.redirect(logslink, "_blank")
	else
		luci.util.exec("mount /dev/mapper/rootfs -o remount,ro >/dev/null 2>&1")
	end
end