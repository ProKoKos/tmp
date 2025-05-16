

module("luci.controller.btminer.pool", package.seeall)

function index()
    local uci = require("luci.model.uci").cursor()
    local pools_switch = uci:get("miner_setting", "web", "pools_switch")
    if pools_switch == "0" then
        return
    end

    entry({"admin", "network", "btminer", "pool"}, cbi("btminer/pool"), "Pool")
end

function get_support_coin_types()
    local uci = require("luci.model.uci").cursor()
    local miner_type = uci:get("btminer", "default", "chip_id")
    local data = {}

    if miner_type == "0x5100" then
        data[#data] = "DCR"
        data[#data+1] = "HC"
    else
        data[#data] = "BTC"
    end

    return data
end

function get_suggest_btc_pools()
    local data = {}

    data[#data] = "stratum+tcp://btc.ss.poolin.com:443"
    data[#data+1] = "stratum+tcp://stratum.f2pool.com:3333"
    data[#data+1] = "stratum+tcp://stratum.bixin.com:443"

    return data
end

function get_suggest_dcr_pools()
    local data = {}

    data[#data] = "stratum+tcp://dcr.ss.poolin.com:443"
    data[#data+1] = "stratum+tcp://dcr.f2pool.com:5730"

    return data
end

function get_suggest_hc_pools()
    local data = {}

    data[#data] = "stratum+tcp://hc.f2pool.com:5760"

    return data
end