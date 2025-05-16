
module("luci.controller.btminer.power", package.seeall)

function index()
    local power_mode = require("luci.controller.btminer.power").get_power_mode()
    if power_mode == -1 then
        return
    end
    
    entry({"admin", "network", "btminer", "power"}, cbi("btminer/power"), "Power")
    
end

function get_power_mode()
    local mode = luci.util.execi("get-power-mode")
    return tonumber(mode())
end

function get_power_pin()
        local file = io.open("/sys/bitmicro/power/pin", "r")
        if file then
                file:close()
        else
                return 0
        end

	local get_val = luci.util.execi("cat /sys/bitmicro/power/pin 2> /dev/null")
	return tonumber(get_val())
end

function get_power_vout_set()
	local get_val = luci.util.execi("cat /sys/bitmicro/power/vout_set 2> /dev/null")
	return tonumber(get_val())
end
