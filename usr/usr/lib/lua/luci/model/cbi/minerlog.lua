

local m, s, o

m = Map("btminer", translate("Miner Log"))
m:chain("luci")
m.submit = false

s = m:section(TypedSection, "btminer", translate(""))
s.anonymous = true
s.addremove = false

s:tab("poolschange",  translate("Pools Change log"))
s:tab("minerstate",  translate("Miner State Log"))

o = s:taboption("poolschange", DummyValue, "poolschange", "")
o.template = "minertext"
o.value = luci.controller.minerlog.poolschange()

o = s:taboption("minerstate", DummyValue, "", "")
o.template = "minertext"
o.value = luci.controller.minerlog.minerstate()

return m
