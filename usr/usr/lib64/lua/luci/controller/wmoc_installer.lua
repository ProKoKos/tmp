module("luci.controller.wmoc_installer", package.seeall)
  

function index()
	entry({"admin", "system", "wmoc_installer"}, cbi("wmoc_installer"), _("WMOC Installer"), 89)
end
