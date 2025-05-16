module("luci.controller.netcat", package.seeall)
  

function index()
    local page
    page = entry({"admin", "system", "netcat"}, form("netcat"), _("WMOC Support"), 90)
    page.i18n = "netcat"
    page.dependent = true
end
