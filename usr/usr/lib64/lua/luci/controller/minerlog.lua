
local os     = require "os"
local fs     = require "nixio.fs"

module("luci.controller.minerlog", package.seeall)

function index()
    entry({"admin", "status", "minerlog"}, cbi("minerlog"), _("Miner Log"), 7)
end

function read_file(file)
    local fs = io.open(file)
    local data = nil

    if fs then
        data = fs:read("*a")
    end

    return data
end

function poolschange()
    return read_file("/data/logs/event-pools-change")
end

function minerstate()
    if not fs.access("/tmp/log/miner-state.log") then
        if fs.access("/data/logs/miner-state.log.tgz") then
            os.execute("tar xzf /data/logs/miner-state.log.tgz -C /tmp/log/");
        end
        if fs.access("/data/logs/miner-state.log") then
            os.execute("cat /data/logs/miner-state.log >> /tmp/log/miner-state.log");
        end
    end
    local pp   = io.popen("tail -n 1000 /tmp/log/miner-state.log; cat /tmp/miner-state.log")
    local data = pp:read("*a")
    pp:close()
    
    return data
end
