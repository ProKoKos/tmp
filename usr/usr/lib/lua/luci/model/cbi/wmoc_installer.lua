local util = require "luci.util"

function Is_Regular_File_Exists(rgfn)
	return luci.util.execi([[
if [ -f ]]..rgfn..[[ ]; then
    echo "1"
else
	echo "0"
fi
]])() ~= "0"
end

function Is_Readable_File_Exists(rdfn)
	return luci.util.execi([[
if [ -r ]]..rdfn..[[ ]; then
    echo "1"
else
	echo "0"
fi
]])() ~= "0"
end

function Is_Executable_File_Exists(rdfn)
	return luci.util.execi([[
if [ -x ]]..rdfn..[[ ]; then
    echo "1"
else
	echo "0"
fi
]])() ~= "0"
end

function Is_Symbolic_Link_Exists(slfn)
	return luci.util.execi([[
if [ -L ]]..slfn..[[ ]; then
    echo "1"
else
	echo "0"
fi
]])() ~= "0"
end

function AddToSysLog(msg)
    luci.util.execi("logger \"[mod_overclock]: "..msg.."\"")()
end

function Read_Symbolic_Link(slfn_to_read)
	local res_fn = ""
	if Is_Symbolic_Link_Exists(slfn_to_read) then
		res_fn = luci.util.execi("readlink "..slfn_to_read)()
	end
	return res_fn
end

---CONST-----------------------
local LIC_SERVER_BASE = "https://wmoc.tech"
local LIC_SERVER_ACTIVATE_PAGE = "https://wmoc.tech/activate.php"
local ACTIVATE_USER = "activateadm"
local ACTIVATE_PASS = "c00lnic3passw0w!"
local WMOC_PRODUCT_NAME = ""
local DOWNLOAD_DIRECTORY = "/tmp"
local OPENSSL_CIPHER = "aes-256-cbc"
local OPENSSL_CIPHER_KEY = "4645e4e5880ff4e1d827a31408cb2653"
local OPENSSL_CIPHER_IV = ""
-------------------------------

--CHECK-CURL-BINARY------------
function Is_Curl_Exists()
	if Is_Executable_File_Exists("/usr/bin/curl") then
		return true
	else
		return false
	end
end
-------------------------------

--CONST-HASHBOARD-0-2-MD5------
function Get_Hashboard_Eeprom_Md5(hb_index)
	local md5_string = "00000000000000000000000000000000"
	
	--eeprom-dump--
	if Is_Readable_File_Exists("/tmp/eeprom") and tonumber(hb_index) >= 0 and tonumber(hb_index) <=2 then
		luci.util.execi("echo eeprom"..hb_index.." > /tmp/eeprom"..hb_index.."_dump")()
		luci.util.execi("chmod 700 /tmp/eeprom"..hb_index.."_dump")()
		luci.util.execi("uci get /tmp/eeprom.eeprom"..hb_index..".pcb_data >> /tmp/eeprom"..hb_index.."_dump")()
		luci.util.execi("uci get /tmp/eeprom.eeprom"..hb_index..".chip_data >> /tmp/eeprom"..hb_index.."_dump")()
		luci.util.execi("uci get /tmp/eeprom.eeprom"..hb_index..".time_stamp >> /tmp/eeprom"..hb_index.."_dump")()
		if Is_Readable_File_Exists("/sys/bitmicro/eeprom/eeprom"..tostring(tonumber(hb_index) + 1).."/eeprom") then
			luci.util.execi("cat /sys/bitmicro/eeprom/eeprom"..tostring(tonumber(hb_index) + 1).."/eeprom | cut -c 6-76 >> /tmp/eeprom"..hb_index.."_dump")()
		end
	end
	--------------
	
	--get-dump-md5--
	if Is_Readable_File_Exists("/tmp/eeprom"..hb_index.."_dump") then
		md5_string = luci.util.execi("md5sum /tmp/eeprom"..hb_index.."_dump | cut -c 1-32")()
		luci.util.execi("rm -rf /tmp/eeprom"..hb_index.."_dump")()
	end
	----------------
	
	return md5_string
end
-------------------------------

--CONST-CB-MD5-----------------
function Get_ControlBoard_Md5()
	local md5_string = "00000000000000000000000000000000"
	
	--cb-data-dump--
	if Is_Readable_File_Exists("/proc/cpuinfo") then
		luci.util.execi("echo eeprom4 > /tmp/cb_dump")()
		luci.util.execi("chmod 700 /tmp/cb_dump")()
		luci.util.execi("cat /proc/cpuinfo | grep -i serial >> /tmp/cb_dump")()
		luci.util.execi("ifconfig eth0 | grep HWaddr | cut -b 39-55 >> /tmp/cb_dump")()
	end
	----------------
	
	--get--dump-md5--
	if Is_Readable_File_Exists("/tmp/cb_dump") then
		md5_string = luci.util.execi("md5sum /tmp/cb_dump | cut -c 1-32")()
		luci.util.execi("rm -rf /tmp/cb_dump")()
	end
	-----------------
	
	return md5_string
end
-------------------------------

--GET-SIGN-PRINT---------------
local SM0_MD5_STRING = Get_Hashboard_Eeprom_Md5("0")
local SM1_MD5_STRING = Get_Hashboard_Eeprom_Md5("1")
local SM2_MD5_STRING = Get_Hashboard_Eeprom_Md5("2")
local CB0_MD5_STRING = Get_ControlBoard_Md5()


function Get_Module_Sign_String()
	local md5_string = "NULL"
	local sm0_md5 = SM0_MD5_STRING
	local sm1_md5 = SM1_MD5_STRING
	local sm2_md5 = SM2_MD5_STRING
	local cb0_md5 = CB0_MD5_STRING
	
	luci.util.execi("echo product_sign > /tmp/sign_dump")()
	luci.util.execi("chmod 700 /tmp/sign_dump")()
	luci.util.execi("echo "..WMOC_PRODUCT_NAME.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..cb0_md5.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..sm0_md5.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..sm1_md5.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..sm2_md5.." >> /tmp/sign_dump")()
	
	--get--dump-md5--
	if Is_Readable_File_Exists("/tmp/sign_dump") then
		md5_string = luci.util.execi("md5sum /tmp/sign_dump | cut -c 1-32")()
		luci.util.execi("rm -rf /tmp/sign_dump")()
	end
	-----------------
	
	return md5_string
end

local LOCAL_SIGN_STRING = ""

-------------------------------

---CHECK-LIC-SERVER------------
function Check_License_Server_Is_Alive()
	local curl_exists = Is_Curl_Exists()
	local httpc = ""
	
	if curl_exists then
		httpc = luci.util.execi("/usr/bin/curl -s -k -o /dev/null -w \"%{http_code}\" \""..LIC_SERVER_BASE.."\"")()
	else 
		httpc = "NULL"
	end
	
	if httpc == "200" then
		return true
	else
		return false
	end
end

local IS_LIC_SERVER_ALIVE = false

-------------------------------

--Get-Server-Answer------------
function Get_Server_Answer(keyvalue)
	local curl_exists = Is_Curl_Exists()
	local answer = ""
	
	local cbmd5  = CB0_MD5_STRING
	local sm0md5 = SM0_MD5_STRING
	local sm1md5 = SM1_MD5_STRING
	local sm2md5 = SM2_MD5_STRING
	
	if curl_exists and keyvalue ~= nil and keyvalue ~= "" then
		answer = luci.util.execi("/usr/bin/curl -u "..ACTIVATE_USER..":"..ACTIVATE_PASS.." -m 5 -s -k -X GET \""..LIC_SERVER_ACTIVATE_PAGE.."?mykey="..keyvalue.."&cb="..cbmd5.."&sm0="..sm0md5.."&sm1="..sm1md5.."&sm2="..sm2md5.."\"")()
	else 
		answer = "CURL_NOT_FOUND"
	end
	
	return answer
end

local LIC_SERVER_ACTIVATION_ANSWER = ""

-------------------------------

--Get-Server-Answer------------

local SERVER_SIDE_SIGN_STRING = ""
local SERVER_MODULE_MD5 = ""

function Check_Server_Answer(srv_answer)
	local marker = ""
	
	if srv_answer ~= nil and srv_answer ~= "" then
		marker = luci.util.execi("echo \""..srv_answer.."\" | cut -f 1 -d \" \"")()
		if marker == "[++]" then
			WMOC_PRODUCT_NAME = luci.util.execi("echo \""..srv_answer.."\" | cut -f 2 -d \" \"")()
			SERVER_SIDE_SIGN_STRING = luci.util.execi("echo \""..srv_answer.."\" | cut -f 3 -d \" \"")()
			SERVER_MODULE_MD5 = luci.util.execi("echo \""..srv_answer.."\" | cut -f 4 -d \" \"")()
			return true
		else
			return false
		end
	else
		return false
	end
end

-------------------------------

--GET-CIPHER-IV----------------
function Get_Cipher_Iv(product_name)
	local dumpfn = "/tmp/productname.dmp"
	local iv_str = "ffffffffffffffffffffffffffffffff"
	
	if product_name ~= nil and product_name ~= "" then
		luci.util.execi("echo product > "..dumpfn)()
		luci.util.execi("echo "..product_name.." >> "..dumpfn)()
		luci.util.execi("chmod 700 "..dumpfn)()
		
		if Is_Readable_File_Exists(dumpfn) then
			iv_str = luci.util.execi("md5sum "..dumpfn.." | cut -c 1-32")()
			luci.util.execi("rm -rf "..dumpfn)()
		end
	end
	
	return iv_str
end
-------------------------------

--Download-module-with-wget----
function Download_Module(sign_string)
	local download_url = ""
	
	if sign_string ~= nil and sign_string ~= "" then
		download_url = LIC_SERVER_BASE .. "/" .. sign_string .. ".tar.gz"
		luci.util.execi("wget -P "..DOWNLOAD_DIRECTORY.." -q --no-check-certificate \""..download_url.."\"")()
		if Is_Readable_File_Exists(DOWNLOAD_DIRECTORY .. "/" .. sign_string .. ".tar.gz") then
			return true
		else
			return false
		end
	else
		return false
	end
end
-------------------------------

--Extract-downloaded-module----
function Extract_Downloaded_Module(sign_string)
	local file_path = ""
	local decr_path = ""
	local local_file_md5 = ""
	local upgradesh = ""
	
	file_path = DOWNLOAD_DIRECTORY .. "/" .. sign_string .. ".tar.gz"
	decr_path = DOWNLOAD_DIRECTORY .. "/module.tar.gz"
	
	if Is_Readable_File_Exists(file_path) then
		local_file_md5 = luci.util.execi("md5sum "..file_path.." | cut -c 1-32")()
		if SERVER_MODULE_MD5 == local_file_md5 then
			
			--decrypt--first--
			luci.util.execi("openssl "..OPENSSL_CIPHER.." -d -k '"..OPENSSL_CIPHER_KEY.."' -iv '"..OPENSSL_CIPHER_IV.."' -salt -in "..file_path.." -out "..decr_path)()
			------------------
			
			if Is_Readable_File_Exists(decr_path) then
				luci.util.execi("rm -rf "..file_path)()
				luci.util.execi("tar -xvzf " .. decr_path .. " -C " .. DOWNLOAD_DIRECTORY)()
				upgradesh = DOWNLOAD_DIRECTORY .. "/upgrade-files/upgrade.sh"
				if Is_Readable_File_Exists(upgradesh) then
					luci.util.execi("chmod 711 "..upgradesh)()
					luci.util.execi("rm -rf "..decr_path)()
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false
		end
	else
		return false
	end
end
-------------------------------

--module-installation----------
function Install_Module()
	local upgradesh = ""
	local upgradefiles = ""
	
	upgradesh = DOWNLOAD_DIRECTORY .. "/upgrade-files/upgrade.sh"
	upgradefiles = DOWNLOAD_DIRECTORY .. "/upgrade-files"
	
	if Is_Executable_File_Exists(upgradesh) then
		luci.util.execi("sh "..upgradesh)()
		luci.util.execi("rm -rf "..upgradefiles)()
		return true
	else
		return false
	end
end

-------------------------------
local NEED_REBOOT = false
-------------------------------

m = SimpleForm("wmoc_installer", translate("WMOC Package Installer"),translate("<a href=\"https://t.me/whatsmineroc\"><img src=\"/luci-static/resources/cbi/wmoc_logo.svg\" height=\"85px\"></a><br/>Please use this page to install licenced WMOC Packages into the device firmware."))

m.submit = translate("Install")
m.reset  = false

s = m:section(SimpleSection)

----->AUTO-REBOOT<-----
reboot_switch = s:option(Flag, "reboot", translate("Automatic device reboot :"), translate("The device will be automatically rebooted if the installation is successful."))
reboot_switch.default = "0"
reboot_switch.rmempty = false

function reboot_switch.cfgvalue(...)
	return "0"
end

function reboot_switch.write(self, mysection, val)
	if val == "1" then
		NEED_REBOOT = true
	else
		NEED_REBOOT = false
	end
    return true
end
--<---------------------

MyKey = s:option(Value, "mykey", translatef("Paste License Key here :"),"")
MyKey.datatype = "string"
MyKey.size = 30

vLabel = s:option(DummyValue,"result", translatef(""), translate("Please enter the purchased license key in the input field and click \"<b>Install</b>\" button.") .. "<br/><br/><br/><br/>" .. translate("<i>* Please wait until the page is fully loaded before performing any actions!</i><br/><br/><i>* Do not press the \"<b>Install</b>\" button several times, it may lead to incorrect installation of the package!</i><br/><br/><i>* Please do not reload this page until you see the result of the script execution!</i><br/><br/><i>* You can get help with any issue in our official telegram support chat: <a href=\"https://t.me/whatsmineroc_chat\"><img src=\"/luci-static/resources/cbi/telegram.svg\" height=\"18px\"></a> <a href=\"https://t.me/whatsmineroc_chat\" target=\"_blank\"><i>WMOC Official Support Chat</i></a></i>") )

function MyKey.write(self, s, val)
	local re = ""
	local str = val:gsub('[%p%c%s]', '')

	
	--1-check-server-is-alive
	IS_LIC_SERVER_ALIVE = Check_License_Server_Is_Alive()
	--<----------------------
		
	if IS_LIC_SERVER_ALIVE then
		
		--2-get-server-activate-answer
		LIC_SERVER_ACTIVATION_ANSWER = Get_Server_Answer(str)
		------------------------------
		
		--3-check-server-answer
		if Check_Server_Answer(LIC_SERVER_ACTIVATION_ANSWER) then
			
			--add-step-CIPHER-IV-
			OPENSSL_CIPHER_IV = Get_Cipher_Iv(WMOC_PRODUCT_NAME)
			---------------------
			
			--4-get-local-sign-string
			LOCAL_SIGN_STRING = Get_Module_Sign_String()
			--<----------------------
			
			--5-compare-local-and-server-side-sign
			if LOCAL_SIGN_STRING == SERVER_SIDE_SIGN_STRING then
				
				--6-download-module-archive
				if Download_Module(LOCAL_SIGN_STRING) then
					
					--7-extract-downloaded-module
					if Extract_Downloaded_Module(LOCAL_SIGN_STRING) then
						
						--8-install-module
						if Install_Module() then
							if NEED_REBOOT then
								m.message = "<pre>[++] Package successfully installed. The device will be rebooted now!</pre>"
								luci.util.execi("reboot")()
							else
								m.message = "<pre>[++] Package successfully installed. Please reboot the device manually!</pre>"
							end
						else
							m.message = "<pre>[-] Package installation error, please contact support!</pre>"
						end
						------------------
					else
						m.message = "<pre>[-] Package extracting error, please contact support!</pre>"
					end
					--<--------------------------
				else
					m.message = "<pre>[-] Package downloading error, please contact support!</pre>"
				end
				--<------------------------
			else
				m.message = "<pre>[-] Package sign verification failed, please contact support!</pre>"
			end
			--<---------------------------------
		else
			m.message = "<pre>"..LIC_SERVER_ACTIVATION_ANSWER.."</pre>"
		end
		--<------------------
	else
		m.message = "<pre>[-] WMOC License Server is unavailable. Please check internet connection!</pre>"
	end	
end

return m
