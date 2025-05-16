m = Map("pools", translate("Configuration"), translate(""))

conf = m:section(TypedSection, "pools", "")
conf.anonymous = true
conf.addremove = false

o = conf:option(ListValue, "coin_type", translate("Coin Type"))
o.datatype = "string"

pool1url = conf:option(Value, "pool1url", translate("Pool 1"))
pool1url.datatype = "string"
pool1user = conf:option(Value, "pool1user", translate("Pool1 worker"))
pool1pw = conf:option(Value, "pool1pw", translate("Pool1 password"))
pool2url = conf:option(Value, "pool2url", translate("Pool 2"))
pool2url.datatype = "string"
pool2user = conf:option(Value, "pool2user", translate("Pool2 worker"))
pool2pw = conf:option(Value, "pool2pw", translate("Pool2 password"))
pool3url = conf:option(Value, "pool3url", translate("Pool 3"))
pool3url.datatype = "string"
pool3user = conf:option(Value, "pool3user", translate("Pool3 worker"))
pool3pw = conf:option(Value, "pool3pw", translate("Pool3 password"))

coin_types = luci.controller.btminer.pool.get_support_coin_types()
o.default = coin_types[0]
local i
for i=0, #coin_types do
        o:value(coin_types[i])

        local pools = {}
        if coin_types[i] == "BTC" then
                pools = luci.controller.btminer.pool.get_suggest_btc_pools();
        elseif coin_types[i] == "DCR" then
                pools = luci.controller.btminer.pool.get_suggest_dcr_pools();
        elseif coin_types[i] == "HC" then
                pools = luci.controller.btminer.pool.get_suggest_hc_pools();
        end

        local j
        for j=0, #pools do
                pool1url:value(pools[j])
                pool2url:value(pools[j])
                pool3url:value(pools[j])
        end
end

return m
