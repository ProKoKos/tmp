module("luci.controller.overclock", package.seeall)

function index()

    entry({"admin", "network", "overclock"}, cbi("overclock"), "Overclock", 91)

end