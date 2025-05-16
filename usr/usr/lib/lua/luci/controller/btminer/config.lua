--[[
LuCI - Lua Configuration Interface

Copyright 2016-2017 Caiqinghua <caiqinghua@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.btminer.config", package.seeall)

function index()
	local page

	page = node("admin", "network", "btminer")
	page.target = firstchild()
	page.title  = _("Miner Configuration")
	page.order  = 90
	page.subindex  = true

end
