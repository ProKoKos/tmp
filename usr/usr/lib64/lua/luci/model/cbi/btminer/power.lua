
local m, s, o

m = Map("btminer", translate("Power"))
m.anonymous   = true
m.submit = true

s = m:section(TypedSection, "btminer", translate(""))
s.anonymous = true
s.addremove = false

mode = s:option(ListValue, "miner_type", translate("Power Mode"))
mode.widget = "radio"
-- mode.orientation = "horizontal"
mode.rmempty = true
mode:value(0, translate("Low"))
mode:value(1, translate("Normal"))
mode:value(2, translate("High"))

function mode.write(self, section, value)
    luci.util.execi("set-power-mode " .. value)
end

function mode.cfgvalue(...)
    local power_mode = luci.util.execi("get-power-mode")
    return power_mode()
end

return m
