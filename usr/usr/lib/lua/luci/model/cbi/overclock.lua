---------------REQUIRE------------------
local util = require "luci.util"
local math = require "math"
local ver = require "luci.version"
local jsc = require "luci.jsonc"
----------------------------------------
--====================================--
--====================================--
--====================================--
------GLOBAL_MODULE_CONST_VARIABLES-----

local WGET_BINARY_PATH = ""             -->WILL_SET_IN_Function-->Is_Wget_Binary_Exists
local IS_WGET_BINARY_EXISTS = false     -->WILL_SET_IN_Function-->Is_Wget_Binary_Exists
local CURL_BINARY_PATH = ""             -->WILL_SET_IN_Function-->Is_Curl_Binary_Exists
local IS_CURL_BINARY_EXISTS = false		-->WILL_SET_IN_Function-->Is_Curl_Binary_Exists
---
local OPENSSL_CIPHER     = "aes-256-cbc"
local OPENSSL_CIPHER_KEY = "4645e4e5880ff4e1d827a31408cb2653"
---
local LIC_SERVER_VERIFY_PAGE         = "https://wmoc.tech/verify.php"
local LIC_SERVER_ADV_CONFIGS_DIR     = "https://wmoc.tech/your_adv_configs/"
local LIC_SERVER_DEF_CONFIGS_DIR     = "https://wmoc.tech/your_def_configs/"
local LIC_SERVER_PSU_CONFIGS_DIR     = "https://wmoc.tech/your_psu_configs/"
local OLD_UPDATE_SH_URL              = "https://wmoc.tech/my_UPDATESHOLD.tar.gz"
local OLD_UPDATE_MODULE_NAME         = "my_UPDATESHOLD.tar.gz"
local OLD_UPDATE_SH_MD5              = "6754bb3a56bf867f3b4e686d880f4b45"
local OLD_UPDATE_SH_NAME             = "myupdateold"
---
local VERIFY_USER = "verifyadm"
local VERIFY_PASS = "w0wnic3passc00l!"
local WMOC_PRODUCT_NAME = "LITEOVERCLOCK01"
---
local MIN_POWER_CONST = "1800"
local MAX_POWER_CONST = "4700"
local KEEP_CONFIG_FILE = "/data/keep_power_config"
local JSON_SH_LIBRARY_PATH = "/usr/share/libubox/jshn.sh"
local PROFILES_FILE_PATH   = "/etc/config/lite_profiles.json"
local IS_PROFILES_FILE_EXISTS = false
local PROFILES_FILE_CONTENT = ""
local PROFILES_NUM = 0
local PROFILE_NAMES_ARRAY = nil
---
local CURRENT_MINER_SUMMARY_JSON = ""
local CURRENT_MINER_DEVS_JSON    = ""
---
local SM0_MD5_STRING     = "00000000000000000000000000000000"    -->Will_Set_In_Function-->Get_Module_Sign_String
local SM1_MD5_STRING     = "00000000000000000000000000000000"    -->Will_Set_In_Function-->Get_Module_Sign_String
local SM2_MD5_STRING     = "00000000000000000000000000000000"    -->Will_Set_In_Function-->Get_Module_Sign_String
local CB0_MD5_STRING     = "00000000000000000000000000000000"    -->Will_Set_In_Function-->Get_Module_Sign_String
local MODULE_SIGN_STRING = "00000000000000000000000000000000"    -->Will_Set_After_Functions
---
local MINER_BINARY_FILENAME = ""          -->Will_Set_In_DETECT-MINER
local IS_BTMINER = false                  -->Will_Set_In_DETECT-MINER
---
local INSTALLED_PSU_NAME    = "UNKNOWN"   -->Will_Set_In_PSU-GET-SET-DATA
local POWERS_PSU_NAME       = "UNKNOWN"   -->Will_Set_In_Function-->Set_Powers_PSU_Name_Family
local POWERS_PSU_FAMILY     = "UNKNOWN"   -->Will_Set_In_Function-->Set_Powers_PSU_Name_Family
local POWERS_PSU_FAMILY_ADV = "UNKNOWN"   -->Will_Set_In_Function-->Set_Powers_PSU_Name_Family
local INSTALLED_PSU_VENDER  = "UNKNOWN"   -->Will_Set_In_PSU-GET-SET-DATA
local INSTALLED_PSU_MODEL   = "UNKNOWN"   -->Will_Set_In_PSU-GET-SET-DATA
local POWER_MODE            = ""          -->Will_Set_In_PSU-GET-SET-DATA
---
local PSU_CONFIG_FILENAME         = ""    -->Will_Set_In_PSU-GET-SET-DATA  
local PSU_CONFIG_FILENAME_SUFFIX  = ""    -->Will_Set_In_PSU-GET-SET-DATA
local PSU_CONFIG_FILENAME_PREFIX  = ""    -->Will_Set_In_PSU-GET-SET-DATA
local PSU_CONFIG_ALREADY_FIXED    = false -->Will_Set_In_PSU-GET-SET-DATA
local IS_PSU_CONFIG_FIXED         = false -->Will_Set_In_PSU-GET-SET-DATA
local IS_PSU_CONFIG_COPYED        = false -->Will_Set_In_PSU-GET-SET-DATA
local FIXED_PSU_IIN_LIMIT         = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_IIN_MAX           = ""	  -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_POWER_LIMIT       = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_POWER_MAX         = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_IOUT_LIMIT        = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_IOUT_MAX          = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_VOLTAGE_LIMIT     = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
local FIXED_PSU_VOLTAGE_MAX       = ""    -->Will_Set_In_Function-->Fix_PSU_Config_File
---
local DEFAULT_VENDER0_MIN_VOLTAGE = ""
local DEFAULT_VENDER0_MAX_VOLTAGE = ""
local DEFAULT_VENDER0_POWER_LIMIT = ""
local DEFAULT_VENDER0_POWER_MAX   = ""
---
local PSU_CONFIG_ARRAY = {
		exists = false,
		name = "",
		v_min = "",
		v_limit = "",
		v_max = "",
		p_limit = "",
		p_max = "",
		iout_limit = "",
		iout_max = "",
		iin_limit = "",
		iin_max = "",
		barried_err = ""
	}
---
local POWERS_DEFAULT_PATH              = "/etc/config/"
local POWERS_DEFAULT_PATH_NO_SLASH     = "/etc/config"
local PSU_DEFAULT_CONFIG_PATH          = "/etc/config/psu/"
local PSU_DEFAULT_CONFIG_PATH_NO_SLASH = "/etc/config/psu"
local TMP_SHM_DEFAULT_PATH             = "/tmp/shm/" 
local TMP_SHM_DEFAULT_PATH_NO_SLASH    = "/tmp/shm"
local POWERS_SYMLINK                   = POWERS_DEFAULT_PATH.."powers"
local COMMON_POWERS_CFG                = POWERS_DEFAULT_PATH.."powers.common"
local COMMON_DEFAULT_POWERS_CFG        = POWERS_DEFAULT_PATH.."powers.default.common"
---
local POWERS_CONFIG_FILENAME = ""                -->Will_Set_In_GET_SET_POWERS_CONFIG
local POWERS_CONFIG_FULLPATH = ""                -->Will_Set_In_GET_SET_POWERS_CONFIG
local POWERS_CONFIG_VERSION  = "1"
---
local MINER_TYPE_LOWERCASE = ""
local MINER_VERSION_LOWERCASE = ""
local DEFAULT_POWERS_CONFIG_FILENAME = ""
local DEFAULT_POWERS_CONFIG_FULLPATH = ""
local MINER_FULL_MODEL_LOWERCASE = ""
local OVERVIEW_PARSED_MODEL_LOWERCASE = ""
local OVERVIEW_MINER_TYPE_LOWERCASE = ""
local OVERVIEW_MINER_VERSION_LOWERCASE = ""
local OVERVIEW_FULL_MODEL_LOWERCASE = ""
---
local POWERS_CONFIGURATION_NAME = ""
---
local POWERS_PSU_CONFIG = {
		is_set_voltage_min = false,
		voltage_min = "",
		is_set_voltage_limit = false,
		voltage_limit = "",
		is_set_power_limit = false,
		power_limit = "",
		is_set_power_max   = false,
		power_max   = "",
		is_set_power_min   = false,
		power_min   = "",
		is_set_iin_limit   = false,
		iin_limit   = "",
		is_set_iin_max     = false,
		iin_max     = "",
		is_set_iout_limit  = false,
		iout_limit  = "",
		is_set_iout_max    = false,
		iout_max    = ""
	}
---
local ACTUAL_PSU_VOLTAGE_MIN   = ""
local ACTUAL_PSU_VOLTAGE_LIMIT = ""
local ACTUAL_PSU_POWER_LIMIT   = ""
local ACTUAL_PSU_POWER_MAX     = ""
local ACTUAL_PSU_IIN_LIMIT     = ""
local ACTUAL_PSU_IIN_MAX       = ""
local ACTUAL_PSU_IOUT_LIMIT    = ""
local ACTUAL_PSU_IOUT_MAX      = ""
---
local BIN_TYPE    = ""
local BIN_VERSION = ""
local BIN_LEAK    = ""
---
local POWER_MODE_PREFIX                 = ""
local BIN_STRING_NO_PREFIX              = ""
local BIN_STRING_WITH_PREFIX            = ""
local BIN_STRING_RES1_NO_PREFIX         = ""
local BIN_STRING_RES2_NO_PREFIX         = ""
local BIN_STRING_RES1_WITH_PREFIX       = ""
local BIN_STRING_RES2_WITH_PREFIX       = ""
local SHORT_BIN_STRING_NO_PREFIX        = ""
local SHORT_BIN_STRING_WITH_PREFIX      = ""
local CURRENT_POWERS_BIN_STRING         = ""
local POWERS_CONFIGURATION_STRING       = ""
---
local NEED_DEFAULT_POWERS_CONFIG    = false
local IS_DEFAULT_CONFIG_DOWNLOADED  = false
---
local DEFAULT_CONFIGURATION_STRING = ""
---
local MAX_OC_TARGET_FREQ = ""
local MIN_DV_TARGET_FREQ = ""
---
local IS_LIQUID           = false
local IS_POWERFAN_ENABLED = false
---
local POWERS_CONFIGURATION_ARRAY = {
		version = "",
		freq_target = "",
		hash_target = "",
		voltage_target = "",
		voltage_limit = "",
		chip_temp_target = "",
		board_temp_target = "",
		ok_cores_pct = "",
		power_min = "",
		power_rate = ""
	}
-----
local DEFAULT_POWERS_CONFIGURATION_ARRAY = {
		version = "",
		freq_target = "",
		hash_target = "",
		voltage_target = "",
		voltage_limit = "",
		chip_temp_target = "",
		board_temp_target = "",
		ok_cores_pct = "",
		power_min = "",
		power_rate = ""
	}
-----
local POWERS_INCREASE = ""
-----
local FORM_PARSED_CONFIG = {
		is_set_liquid_switch = false,
		liquid_switch = "",
		is_set_powerfanclose_switch = false,
		powerfanclose_switch = "",
		is_set_hash_target = false,
		hash_target = "",
		is_set_freq_target = false,
		freq_target = "",
		is_set_voltage_target = false,
		voltage_target = "",
		is_valid_voltage_min = true,
		is_set_voltage_min = false,
		voltage_min = "",
		is_valid_voltage_limit = true,
		is_set_voltage_limit = false,
		voltage_limit = "",
		is_set_chip_temp_target = false,
		chip_temp_target = "",
		is_set_board_temp_target = false,
		board_temp_target = "",
		is_set_ok_cores_pct = false,
		ok_cores_pct = "",
		is_valid_power_min = false,
		is_set_power_min = false,
		power_min = "",
		is_set_power_rate = false,
		power_rate = "",
		is_set_power_limit = false,
		power_limit = "",
		is_set_power_max = false,
		power_max = ""
	}
----<

--====================================--
--====================================--
--====================================--

----------STRING_FUNCTIONS--------------

function Is_String_Empty(strstr)
	return strstr == nil or strstr == ""
end

function Is_String_Unknown(strstr)
  return strstr == "UNKNOWN" or strstr == "unknown"
end

function Is_String_Common(strstr)
  return strstr == "COMMON" or strstr == "common" 
end

function Is_String_Ini_Usage_Error(strstr)
	---
	if not Is_String_Empty(strstr) then
		local substr = string.sub(strstr, 5)
		return substr == "Usage" or substr == "usage"
	else
		return true
	end
end

function Is_String_Starts(src_str,sub_str)
   return string.sub(src_str,1,string.len(sub_str)) == sub_str
end

function Round_Number(num)
    if num >= 0 then 
        return math.floor(num+.5) 
    else 
        return math.ceil(num-.5) 
    end
end

----------FILE_FUNCTIONS----------------

function AddToSysLog(msg)
    luci.util.execi("logger \"[mod_overclock]: "..msg.."\"")()
end

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

function Read_Symbolic_Link(read_slfn)
	return luci.util.execi("readlink ".. read_slfn .."  2> /dev/null || echo UNKNOWN")()
end

function Set_File_Permissions(file_path,perm_str)
	return luci.util.execi("chmod " ..perm_str.. " " ..file_path.."  2> /dev/null && echo 1 || echo 0")() ~= "0"
end

function Create_File(file_path)
	return luci.util.execi("touch "..file_path.."  2> /dev/null && echo 1 || echo 0")() ~= "0"
end

function Create_File_With_Permissions(file_path_to_create,perm_str)
	if Create_File(file_path_to_create) then
		return Set_File_Permissions(file_path_to_create,perm_str)
	else
		return false
	end
end

function Copy_File_Overwrite(src_file,dest_file)
	return luci.util.execi("cp -dvf " ..src_file.. " " ..dest_file.."  2> /dev/null && echo 1 || echo 0")() ~= "0"
end

function Copy_File_Overwrite_And_Set_Perm(src_file,dest_file,perm_str)
	---
	if Copy_File_Overwrite(src_file,dest_file) then
		if Set_File_Permissions(dest_file,perm_str) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Read_Whole_File(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Failed to open file: " .. filename
    end

    local contents = file:read("*all")
    if not contents then
        file:close()
        return nil, "Failed to read contents of file: " .. filename
    end

    file:close()
    return contents
end

function Check_Json_Library(json_lib_path)
--->
	if Is_Readable_File_Exists(json_lib_path) then
		return true
	else
		return false
	end
end

function Create_Profiles_File(json_lib,profiles_file_path)
--->
	if not Is_Readable_File_Exists(profiles_file_path) then
	--->
		if Create_File_With_Permissions(profiles_file_path,"644") and Check_Json_Library(json_lib) then
			luci.util.execi([[
			profiles_path="]]..profiles_file_path..[["
			. ]]..json_lib..[[
			
			json_init
			json_add_int "count" 0
			json_dump > "$profiles_path"
			]])()
			return true
		else
			return false
		end
	else
		return true
	end
end

function Create_Profiles_File_New(profiles_file_path)
--->
	if not Is_Readable_File_Exists(profiles_file_path) then
	--->
		if Create_File_With_Permissions(profiles_file_path,"644") then
			return luci.util.execi("echo '{\"count\":0,\"auto_generated\":0}' > ".. profiles_file_path .."  2> /dev/null && echo 1 || echo 0")() ~= "0"
		else
			return false
		end
	else
		return true
	end
end

function Enumerate_Json_Profiles(json_lib,profiles_file_path)
--->
	local profiles_num_str = luci.util.execi([[
		profiles_path="]] .. profiles_file_path .. [["
        . ]] .. json_lib .. [[
		
		json_body=`cat "$profiles_path"`
        json_init
		json_load "$json_body"
        json_get_var count count
        echo "$count"
		]])()
	
	if tonumber(profiles_num_str) == nil then
		return 0
	else
		return tonumber(profiles_num_str)
	end
end

function Enumerate_Json_Profiles_New(jsonstr)
    local jsonbody = jsc.parse(jsonstr)
    if type(jsonbody) == "table" and type(jsonbody.count) == "number" then
		return jsonbody.count
    else
        return nil, "JSON string does not contain a \"count\" field."
    end
end

function Get_Profile_Names(json_lib, profiles_file_path)
    local profile_names = {}
    local profiles_num = Enumerate_Json_Profiles(json_lib, profiles_file_path)

    if profiles_num > 0 then
        local script_str = [[
            profiles_path="]] .. profiles_file_path .. [["
            . ]] .. json_lib .. [[
            
            json_body=`cat "$profiles_path"`
            json_init
            json_load "$json_body"

            for i in $(seq 1 ]] .. profiles_num .. [[); do
                json_select profile_$i
                json_get_var name name
                echo "$name"
                json_select ..
            done
        ]]

        local output = luci.util.exec(script_str)
        if output ~= nil then
            for name in output:gmatch("[^\n]+") do
                table.insert(profile_names, name)
            end
        end

        return profile_names
    else
        return nil
    end
end

function Get_Profile_Names_New(jsonstr)
	local pname = ""
	local profile_names = {}
    
	local profiles_num, err = Enumerate_Json_Profiles_New(jsonstr)
    if not profiles_num then
        return nil, err
    end
	
	local jsonbody = jsc.parse(jsonstr)
    if type(jsonbody) == "table" and profiles_num >= 1 then
		for i=1,profiles_num do
			pname = jsonbody["profile_"..i].name
			table.insert(profile_names, pname)
		end
    end
	
	return profile_names
end

function Write_Json_Profile(json_lib,profiles_file_path,profile_name,cfg_ver,is_liquid,is_close_pfan,hash_target,freq_target,vol_target,vol_min,vol_limit,board_targ_temp,power_min,power_limit)
--->
	local profile_index  = -1
	local update_profile = false
	local profiles_num   = Enumerate_Json_Profiles(json_lib,profiles_file_path)
	local profile_names  = Get_Profile_Names(json_lib, profiles_file_path)
	---
    if profile_names ~= nil then
		for i, name in ipairs(profile_names) do
			if name == profile_name then
				profile_index = i
				update_profile = true
				break
			end
		end
	end
	---
	if profile_index == -1 then profile_index = profiles_num + 1 end
--->
    if not update_profile then
	--->
		local script_str = [[
        profiles_path="]] .. profiles_file_path .. [["
		. ]] .. json_lib .. [[
		
		json_body=`cat "$profiles_path"`
        json_init
        json_load "$json_body"
		json_add_int "count" ]]..                tostring(profile_index) ..[[
        json_add_object
		json_add_object "profile_]]..            tostring(profile_index) ..[["
        json_add_string "name" "]] ..            profile_name .. [["
        json_add_string "config_ver" "]] ..      cfg_ver..[["
        json_add_string "liquid_cooling" "]] ..  is_liquid .. [["
        json_add_string "close_powerfan" "]] ..  is_close_pfan .. [["
		json_add_string "target_hash" "]] ..     hash_target .. [["
        json_add_string "target_freq" "]] ..     freq_target .. [["
        json_add_string "target_vol" "]] ..      vol_target .. [["
        json_add_string "min_vol" "]] ..         vol_min .. [["
        json_add_string "limit_vol" "]] ..       vol_limit .. [["
        json_add_string "board_temp" "]] ..      board_targ_temp .. [["
        json_add_string "min_power" "]] ..       power_min .. [["
        json_add_string "power_lim" "]] ..       power_limit .. [["
        json_close_object
		json_close_object
		json_dump > "$profiles_path"
		]]
		
		luci.util.execi(script_str)()
		return "ADD_PROFILE"
	else
		local script_str = [[
        profiles_path="]] .. profiles_file_path .. [["
		. ]] .. json_lib .. [[
		
		json_body=`cat "$profiles_path"`
        json_init
        json_load "$json_body"
		
		json_select "profile_]]..                tostring(profile_index) ..[["
        json_add_string "config_ver" "]] ..      cfg_ver..[["
        json_add_string "liquid_cooling" "]] ..  is_liquid .. [["
        json_add_string "close_powerfan" "]] ..  is_close_pfan .. [["
		json_add_string "target_hash" "]] ..     hash_target .. [["
        json_add_string "target_freq" "]] ..     freq_target .. [["
        json_add_string "target_vol" "]] ..      vol_target .. [["
        json_add_string "min_vol" "]] ..         vol_min .. [["
        json_add_string "limit_vol" "]] ..       vol_limit .. [["
        json_add_string "board_temp" "]] ..      board_targ_temp .. [["
        json_add_string "min_power" "]] ..       power_min .. [["
        json_add_string "power_lim" "]] ..       power_limit .. [["
        
		json_dump > "$profiles_path"
		]]
		
		luci.util.execi(script_str)()
		return "REWRITE_PROFILE"
	end
end

function Write_Json_Profile_New(jsonstr, profiles_file_path, profile_name, cfg_ver, is_liquid, is_close_pfan, hash_target, freq_target, vol_target, vol_min, vol_limit, board_targ_temp, power_min, power_limit)
    local profile_index = -1
    local update_profile = false
    
	local profiles_num, err = Enumerate_Json_Profiles_New(jsonstr)
    if not profiles_num then
        return nil, err
    end

    local profile_names, err = Get_Profile_Names_New(jsonstr)
    if not profile_names then
        return nil, err
    end

	if profile_names ~= nil then
        for i, name in ipairs(profile_names) do
            if name == profile_name then
                profile_index = i
                update_profile = true
                break
            end
        end
    end
	
	if profile_index == -1 then
        profile_index = profiles_num + 1
    end
	
    local jsonbody = jsc.parse(jsonstr)
    if not type(jsonbody) == "table" then
        return nil, "Failed to parse JSON data from file."
    end
	
	if not update_profile then
        jsonbody.count = profile_index
        jsonbody["profile_"..profile_index] = {
            name = profile_name,
            config_ver = cfg_ver,
            liquid_cooling = is_liquid,
            close_powerfan = is_close_pfan,
            target_hash = hash_target,
            target_freq = freq_target,
            target_vol = vol_target,
            min_vol = vol_min,
            limit_vol = vol_limit,
            board_temp = board_targ_temp,
            min_power = power_min,
            power_lim = power_limit
        }
    else
		if not type(jsonbody["profile_"..profile_index]) == "table" then
            return nil, "Failed to find profile data in JSON file."
        end
		
		jsonbody.count = profiles_num
        jsonbody["profile_"..profile_index] = {
            name = profile_name,
            config_ver = cfg_ver,
            liquid_cooling = is_liquid,
            close_powerfan = is_close_pfan,
            target_hash = hash_target,
            target_freq = freq_target,
            target_vol = vol_target,
            min_vol = vol_min,
            limit_vol = vol_limit,
            board_temp = board_targ_temp,
            min_power = power_min,
            power_lim = power_limit
        }
	end
	
	local jsonres = jsc.stringify(jsonbody)
	local file = io.open(profiles_file_path, "w")
	if not file then
		return nil, "Failed to open file: " .. profiles_file_path
	end
	file:write(jsonres)
	file:close()
	
	if update_profile then
		return 1
	else
		return 2
	end
end

function Delete_Json_Profile_New(jsonstr, profiles_file_path, profile_name)
    local profiles_num, err = Enumerate_Json_Profiles_New(jsonstr)
    if not profiles_num then
        return nil, err
    end

    local profile_names, err = Get_Profile_Names_New(jsonstr)
    if not profile_names then
        return nil, err
    end

    local profile_index = -1
    for i, name in ipairs(profile_names) do
        if name == profile_name then
            profile_index = i
            break
        end
    end

    if profile_index == -1 then
        return nil, "Profile not found: " .. profile_name
    end

    local jsonbody = jsc.parse(jsonstr)
    if not type(jsonbody) == "table" then
        return nil, "Failed to parse JSON data from file."
    end

    jsonbody.count = profiles_num - 1
    for i = profile_index, profiles_num do
        jsonbody["profile_"..i] = jsonbody["profile_"..(i+1)]
    end
    jsonbody["profile_"..profiles_num] = nil

    local jsonres = jsc.stringify(jsonbody)
    local file = io.open(profiles_file_path, "w")
    if not file then
        return nil, "Failed to open file: " .. profiles_file_path
    end
    file:write(jsonres)
    file:close()

    return true
end

function Send_Miner_Api_Json_Command(miner_binary_name,cmd_string)
--->
	return luci.util.execi("/usr/bin/"..miner_binary_name.."-api -o  '{\"command\":\""..cmd_string.."\"}'  2> /dev/null || echo '{ }'")()
end			

function Get_New_Power_Rate(cur_power_rate, cur_power, new_power, power_rate_diff_per_step, power_step)
    local power_diff = 0
    local power_rate_diff = 0
	local new_power_rate = 0
	
	if new_power >= cur_power then
		power_diff = new_power - cur_power
		power_rate_diff = power_diff / power_step * power_rate_diff_per_step
		new_power_rate = cur_power_rate + power_rate_diff
	else
		power_diff = cur_power - new_power
		power_rate_diff = power_diff / power_step * power_rate_diff_per_step
		new_power_rate = cur_power_rate - power_rate_diff
	end
	
	return new_power_rate
end

function Get_Hashboard_Hashrate(cur_power, cur_power_rate, board_num)
	local hb_hr = (cur_power / cur_power_rate) / board_num
	return tonumber(string.format("%.2f", hb_hr))
end

function Get_100W_Power_Rate_Step(miner_model)
	if miner_model     == "m21s" then
		return 0.450
	elseif miner_model == "m20s" or miner_model == "m21s+" then
		return 0.400	
	elseif miner_model == "m30s" then
		return 0.300
	elseif miner_model == "m30s+" then
		return 0.250
	elseif miner_model == "m30s++" then
		return 0.200
	elseif miner_model == "m50" then
		return 0.150
	elseif miner_model == "m50s" then
		return 0.100
	elseif miner_model == "m50s+" then
		return 0.090
	elseif miner_model == "m50s++" then
		return 0.080
	elseif miner_model == "m60" then
		return 0.070
	elseif miner_model == "m60" then
		return 0.065	
	else
		return 0.300
	end
end

function Get_Max_Power_Limit(psu_power_max_str)
	if not Is_String_Empty(psu_power_max_str) and not Is_String_Unknown(psu_power_max_str) and tonumber(psu_power_max_str) ~= nil then
		return tonumber(psu_power_max_str) - 50
	else
		return 0
	end
end

function Get_Min_Power_Limit(calculated_max_power_limit,psu_min_power_str)
	local min_power_num = 0
	---
	if not Is_String_Empty(psu_min_power_str) and not Is_String_Unknown(psu_min_power_str) and tonumber(psu_min_power_str) ~= nil then
		min_power_num = tonumber(psu_min_power_str) + 50
		if min_power_num % 100 == calculated_max_power_limit % 100 then
			return tonumber(min_power_num)
		else
			return tonumber(min_power_num) + 50
		end
	else
		return 0
	end
end

function Get_100W_Step_Profiles_Num(min_power_limit,max_power_limit)
	local steps = 0
	if min_power_limit > 0 and max_power_limit > 0 then
		if max_power_limit >= min_power_limit then
			steps = (max_power_limit - min_power_limit) / 100
			return tonumber(string.format("%.0f", steps))
		else
			return 0
		end
	else
		return 0
	end
end

function Get_Profile_Hashrate_Str(one_hb_hr,board_num)
	local total_hr = one_hb_hr * board_num
	return string.format("%.1f", total_hr)
end

function Get_Auto_Profile_Name(profile_index,total_hr_str,profile_power_str)
	if profile_index > 0 and not Is_String_Empty(total_hr_str) and not Is_String_Empty(profile_power_str) then
		return "AGP_".. string.format("%02d",profile_index) .."_".. total_hr_str .."TH_".. profile_power_str .."W"
	else
		return "AGP_Unknown"
	end
end

function Auto_Generate_Profiles(profiles_json_str, profiles_file_path, summary_json_str, devs_json_str, miner_model, cfg_ver, is_liquid, is_close_pfan, vol_target, vol_min, vol_limit, board_targ_temp, psu_power_max)
--->
	local summ_json_body, devs_json_body
	local mhs_av, mhs_rt, power_rt, power_rate_rt
	local elapsed  = 0
	local ths_rt   = 0
	local ths_av   = 0
	local freq_avg = 0
	local power_av = 0
	local power_rate_av  = 0
	local power_rate_res = 0
	local ths_per_freq   = 0
	
	local profiles_max_power       = 0
	local profiles_min_power       = 0
	local add_profiles_num         = 0
	local power_rate_diff_per_step = 0
	local current_profile_power    = 0
	local profiles_power_step      = 100
	local profile_index            = 0
	local cur_board_num = 0
	
--->Get_profiles_number
	local profiles_num, err = Enumerate_Json_Profiles_New(profiles_json_str)
    if not profiles_num then
        return false, err
	end

--->Get_profiles_names_to_array
	local profile_names, err = Get_Profile_Names_New(profiles_json_str)
    if not profile_names then
        return false, err
    end

--->Parse_profiles_From_Json_Str_To_Json_Body
	local profiles_json_body = jsc.parse(profiles_json_str)
    if not type(profiles_json_body) == "table" then
        return false, "Failed to parse JSON data from file."
    end

--->Parse_Devs_Json_String
	if not Is_String_Empty(devs_json_str) and devs_json_str ~= "{ }" then
		devs_json_body = jsc.parse(devs_json_str)
		if not devs_json_body or type(devs_json_body) ~= "table" then
			return false, "Failed to parse devs JSON data."
		end
	else
		return false, "Devs JSON string is empty or json parsing failed."
	end
	
--->Check_Upfreq_Completed_for_all_HashBoards
	for i, dev in ipairs(devs_json_body.DEVS) do
		if dev.ASC ~= nil and (dev["Upfreq Complete"] or 0) == 1 then
			cur_board_num = cur_board_num + 1
		else
			return false, "Error: device upfreq autotuning must be finished to generate presets!"
		end
	end

--->Parse_Summary_Json_String
	if not Is_String_Empty(summary_json_str) and summary_json_str ~= "{ }" then
		summ_json_body = jsc.parse(summary_json_str)
		if not summ_json_body or type(summ_json_body) ~= "table" then
			return false, "Failed to parse summary JSON data."
		end
	else
		return false, "Summary JSON string is empty or json parsing failed."
	end

--->Get_Current_State_Data_from_summary
	if type(summ_json_body.SUMMARY[1]["Elapsed"]) == "number" and summ_json_body.SUMMARY[1]["Elapsed"] > 600 then
		mhs_av   = summ_json_body.SUMMARY[1]["MHS av"] or 0
		mhs_rt   = summ_json_body.SUMMARY[1]["HS RT"] or 0
		ths_av   = tonumber(string.format("%.2f", mhs_av / 1000000))
		ths_rt   = tonumber(string.format("%.2f", mhs_rt / 1000000))
		freq_avg = summ_json_body.SUMMARY[1]["freq_avg"] or 0
		power_rt = summ_json_body.SUMMARY[1]["Power"] or 0
		power_av = power_rt + 15
		ths_per_freq   = ths_av / (freq_avg * cur_board_num)
		power_rate_av  = tonumber(string.format("%.2f", power_av / ths_av))
		power_rate_rt  = summ_json_body.SUMMARY[1]["Power Rate"] or 0
		if power_rate_rt > 0 then
			power_rate_res = tonumber(string.format("%.2f", (power_rate_av + power_rate_rt) / 2))
		else
			power_rate_res = power_rate_av
		end
	else
		return false, "Error: stable device hashrate needed, please wait at least 10 minutes after upfreq is finished"
	end

--->Set_Profiles_Settings
	if not Is_String_Empty(miner_model) and not Is_String_Unknown(miner_model) then
		profiles_max_power       = Get_Max_Power_Limit(psu_power_max)
		profiles_min_power       = Get_Min_Power_Limit(profiles_max_power,MIN_POWER_CONST)
		add_profiles_num         = Get_100W_Step_Profiles_Num(profiles_min_power,profiles_max_power)
		power_rate_diff_per_step = Get_100W_Power_Rate_Step(miner_model)
	else
		return false, "Error: miner model string is empty or unknown"
	end
	
--->Delete_old_auto_generated_profiles
	local profiles_deleted   = 0
	local saved_profiles     = {}
	local saved_profiles_num = 0
	
	if profiles_json_body.auto_generated == 1 and profiles_num > 0 and profile_names ~= nil then
		for i = profiles_num, 1, -1 do
			if Is_String_Starts(profile_names[i], "AGP_") then
				table.remove(profiles_json_body, i)
			else
				saved_profiles_num = saved_profiles_num + 1
				saved_profiles[saved_profiles_num] = profiles_json_body["profile_"..i]
				table.remove(profiles_json_body, i)
			end
		end
		
		if saved_profiles_num > 0 then
			for i = 1, saved_profiles_num do
				profiles_json_body["profile_"..i] = saved_profiles[saved_profiles_num-(i-1)]
			end
		end
		
		profiles_num = saved_profiles_num
		profiles_json_body.count = profiles_num
	end
	
--->Add_Profiles
	local new_profile_power_rate    = 0
	local target_board_hash         = 0
	local target_board_freq         = 0
	local profile_total_hash_str    = ""
	
	if add_profiles_num > 0 then
	--->
		profiles_json_body.count = profiles_num + add_profiles_num
		current_profile_power    = profiles_max_power
		
		for i = 1, add_profiles_num do
			profile_index          = profiles_num + i
			new_profile_power_rate = Get_New_Power_Rate(power_rate_res,power_av,current_profile_power,power_rate_diff_per_step,profiles_power_step)
			target_board_hash      = Get_Hashboard_Hashrate(current_profile_power,new_profile_power_rate,cur_board_num)
			target_board_freq      = target_board_hash / ths_per_freq
			profile_total_hash_str = Get_Profile_Hashrate_Str(target_board_hash,cur_board_num)
			---
			profiles_json_body["profile_"..profile_index] = {
            name           = Get_Auto_Profile_Name(i,profile_total_hash_str,tostring(current_profile_power)),
            config_ver     = cfg_ver,
            liquid_cooling = is_liquid,
            close_powerfan = is_close_pfan,
            target_hash    = tostring(target_board_hash),
            target_freq    = string.format("%.0f", target_board_freq),
            target_vol     = vol_target,
            min_vol        = vol_min,
            limit_vol      = vol_limit,
            board_temp     = board_targ_temp,
            min_power      = "0000",
            power_lim      = tostring(current_profile_power)
        }
		
		current_profile_power = current_profile_power - profiles_power_step
		end
		
		profiles_json_body.auto_generated = 1
	else
		return false, "Error: no profiles to add."
	end

--->Save_profiles_to_file
	local jsonres = jsc.stringify(profiles_json_body)
	local file = io.open(profiles_file_path, "w")
	if not file then
		return false, "Failed to open file: " .. profiles_file_path
	end
	file:write(jsonres)
	file:close()

	return true
end


-------------WGET-CURL-CONST-------------------

function Check_Wget_Binary_Exists()
	---
	WGET_BINARY_PATH = "/bin/wget"
	if Is_Symbolic_Link_Exists(WGET_BINARY_PATH) or Is_Executable_File_Exists(WGET_BINARY_PATH) then
		return true
	else
		WGET_BINARY_PATH = "/bin/uclient-fetch"
		return Is_Executable_File_Exists(WGET_BINARY_PATH)
	end
end

function Check_Curl_Binary_Exists()
	---
	CURL_BINARY_PATH = "/usr/bin/curl"
	if Is_Executable_File_Exists(CURL_BINARY_PATH) then
		return true
	else
		CURL_BINARY_PATH = "/bin/curl"
		return Is_Executable_File_Exists(CURL_BINARY_PATH)
	end
end

--==CONST==--->
IS_WGET_BINARY_EXISTS = Check_Wget_Binary_Exists()
IS_CURL_BINARY_EXISTS = Check_Curl_Binary_Exists()
--------------<

-------------DOWNLOAD-FUNCTIONS----------------

function Download_File(file_url,out_dir_no_last_slash,out_filename,set_perm)
	--->
	if IS_WGET_BINARY_EXISTS then		
		--->
		if luci.util.execi(WGET_BINARY_PATH.." -P "..out_dir_no_last_slash.." -q --no-check-certificate \""..file_url.."\"  2> /dev/null && echo 1 || echo 0")() ~= "0" then
			--->
			if Set_File_Permissions(out_dir_no_last_slash.."/"..out_filename,set_perm) then
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
end

function Download_File_Overwrite(file_url,out_dir_no_last_slash,out_filename,set_perm)
	--->
	if IS_WGET_BINARY_EXISTS then		
		--->
		luci.util.execi("rm -rf "..out_dir_no_last_slash.."/"..out_filename)()
		if luci.util.execi(WGET_BINARY_PATH.." -P "..out_dir_no_last_slash.." -q --no-check-certificate \""..file_url.."\"  2> /dev/null && echo 1 || echo 0")() ~= "0" then
			--->
			if Set_File_Permissions(out_dir_no_last_slash.."/"..out_filename,set_perm) then
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
end

function Extract_Downloaded_Script(download_dir,module_name,scriptname,module_cipher_iv)
	local file_path = ""
	local decr_path = ""
	local local_file_md5 = ""
	local script_path = ""
	
	file_path = download_dir .. "/" .. module_name
	decr_path = download_dir .. "/module.tar.gz"
	
	if Is_Readable_File_Exists(file_path) then
	
			--decrypt--first--
			luci.util.execi("openssl "..OPENSSL_CIPHER.." -d -k '"..OPENSSL_CIPHER_KEY.."' -iv '"..module_cipher_iv.."' -salt -in "..file_path.." -out "..decr_path)()
			------------------
			
			if Is_Readable_File_Exists(decr_path) then
				luci.util.execi("rm -rf "..file_path)()
				luci.util.execi("tar -xvzf " .. decr_path .. " -C " .. download_dir)()
				script_path = download_dir .. "/".. scriptname ..".sh"
				if Is_Readable_File_Exists(script_path) then
					luci.util.execi("chmod 711 "..script_path)()
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
end

-------------DETECT-MINER-BINARY---------------

function Is_Miner_Btminer()
    return luci.util.execi("grep BTMINER /etc/microbt_release | wc -l")() ~= "0"
end

function Get_Miner_Binary_Name()
	if IS_BTMINER then
		return "btminer"
	else
		return "cgminer"
	end
end

--==CONST==--->
IS_BTMINER = Is_Miner_Btminer()
MINER_BINARY_FILENAME = Get_Miner_Binary_Name()
--------------<

-------------DETECT-POWERS-VERSION-------------

function Get_Powers_Config_Version()
	return luci.util.execi("ini get "..POWERS_SYMLINK.." common version  2> /dev/null || echo 1")()
end

--==CONST==--->
POWERS_CONFIG_VERSION = Get_Powers_Config_Version()
--------------<

---------MINER_RESTART-KILL-REDETECT-----------

function Miner_Restart()
	if not Is_String_Empty(MINER_BINARY_FILENAME) then
		luci.util.execi("echo \"`date`|E007|Restart "..MINER_BINARY_FILENAME.."|Web|Remote restart\" >> /tmp/event-restart-"..MINER_BINARY_FILENAME)()
		luci.util.execi("/etc/init.d/"..MINER_BINARY_FILENAME.." restart")()
	end
end

function Miner_Kill()
	if not Is_String_Empty(MINER_BINARY_FILENAME) then
		luci.util.execi("/etc/init.d/"..MINER_BINARY_FILENAME.." stop; killall -9 "..MINER_BINARY_FILENAME.." > /dev/null")()
	end
end

function Redetect_Miner_Info()
	luci.util.execi("rm -rf /tmp/miner-info")()
	luci.util.execi("detect-miner-info")()
end

-------------MINER_MODULE-VERIFY---------------

function Set_Keep_Config_File(config_ver,increase_str,psu_v_limit)
	---
	luci.util.execi("echo \"[config]\" > "..KEEP_CONFIG_FILE)()
	luci.util.execi("ini set "..KEEP_CONFIG_FILE.." config version "..config_ver)()
	luci.util.execi("ini set "..KEEP_CONFIG_FILE.." config increase "..increase_str)()
	luci.util.execi("ini set "..KEEP_CONFIG_FILE.." config orig_psu_vol_limit "..psu_v_limit)()
	--->
	return Set_File_Permissions(KEEP_CONFIG_FILE,"644")
end

function GetHashboardSerial(hb_index_str)
	local hbsn = "UNKNOWN"
	--->
	if tonumber(hb_index_str) >= 0 and tonumber(hb_index_str) <=2 then
		if Is_Readable_File_Exists("/tmp/eeprom/eeprom"..hb_index_str.."/pcb_data") then
			hbsn = luci.util.execi("cat /tmp/eeprom/eeprom"..hb_index_str.."/pcb_data  2> /dev/null")()
		else
			if Is_String_Empty(hbsn) or Is_String_Unknown(hbsn) then
				if Is_Readable_File_Exists("/tmp/eeprom_cfg") then
					hbsn = luci.util.execi("uci get /tmp/eeprom_cfg.eeprom"..hb_index_str..".pcb_data  2> /dev/null")()
				end
			else
				hbsn = "UNKNOWN"
			end
		end
		--->
	end
	--->
	return hbsn
end

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

--==CONST==--->
SM0_MD5_STRING = Get_Hashboard_Eeprom_Md5("0")
SM1_MD5_STRING = Get_Hashboard_Eeprom_Md5("1")
SM2_MD5_STRING = Get_Hashboard_Eeprom_Md5("2")
CB0_MD5_STRING = Get_ControlBoard_Md5()
--------------<

function Get_Module_Sign_String()
	local md5_string = "00000000000000000000000000000000"
	
	luci.util.execi("echo product_sign > /tmp/sign_dump")()
	luci.util.execi("chmod 700 /tmp/sign_dump")()
	luci.util.execi("echo "..WMOC_PRODUCT_NAME.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..CB0_MD5_STRING.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..SM0_MD5_STRING.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..SM1_MD5_STRING.." >> /tmp/sign_dump")()
	luci.util.execi("echo "..SM2_MD5_STRING.." >> /tmp/sign_dump")()
	
	--get--dump-md5--
	if Is_Readable_File_Exists("/tmp/sign_dump") then
		md5_string = luci.util.execi("md5sum /tmp/sign_dump | cut -c 1-32  2> /dev/null")()
		luci.util.execi("rm -rf /tmp/sign_dump")()
	end
	---------------->
	return md5_string
end

--==CONST==--->
MODULE_SIGN_STRING = Get_Module_Sign_String()
--------------<

function Get_Server_Sign_String()
	---
	if IS_CURL_BINARY_EXISTS then
		return luci.util.execi(CURL_BINARY_PATH.." -u "..VERIFY_USER..":"..VERIFY_PASS.." -m 5 -s -k -X GET \""..LIC_SERVER_VERIFY_PAGE.."?product="..WMOC_PRODUCT_NAME.."&cb="..CB0_MD5_STRING.."&sm0="..SM0_MD5_STRING.."&sm1="..SM1_MD5_STRING.."&sm2="..SM2_MD5_STRING.."\"")()
	else 
		return "CURL_NOT_FOUND"
	end
end

----------------PSU_SET_GET--------------------

function Get_PSU_Name()
--->
	INSTALLED_PSU_NAME = luci.util.execi("cat /tmp/power/name  2> /dev/null")()
	if Is_String_Empty(INSTALLED_PSU_NAME) then
	--->
		INSTALLED_PSU_NAME = luci.util.execi("cat /sys/bitmicro/power/name  2> /dev/null")()
		if Is_String_Empty(INSTALLED_PSU_NAME) then
		--->
			INSTALLED_PSU_NAME  = "UNKNOWN"
			return false
		else
			return true
		end
	else
		return true
	end
	---<
end

--==CONST==--->
local OK_INSTALLED_PSU_NAME = Get_PSU_Name()
--------------<

function Set_Powers_PSU_Name_Family()
--->
	if OK_INSTALLED_PSU_NAME then
		---Set-powers-PSU-name--->
		POWERS_PSU_NAME = "power_"..INSTALLED_PSU_NAME
		
		---P221X-12V--->
		if INSTALLED_PSU_NAME == "P221B" or INSTALLED_PSU_NAME == "P221C" or INSTALLED_PSU_NAME == "P231A" or INSTALLED_PSU_NAME == "P231B" then
			POWERS_PSU_FAMILY        = "power_P221X"
			POWERS_PSU_FAMILY_ADV    = "power_PXX1X"
			OK_POWERS_PSU_FAMILY     = true
			OK_POWERS_PSU_FAMILY_ADV = true
		end
		---P222-14V--->
		if INSTALLED_PSU_NAME == "P222B" or INSTALLED_PSU_NAME == "P222C" or INSTALLED_PSU_NAME == "P232A" or INSTALLED_PSU_NAME == "P232B" then
			POWERS_PSU_FAMILY        = "power_P222X"
			POWERS_PSU_FAMILY_ADV    = "power_PXX2X"
			OK_POWERS_PSU_FAMILY     = true
			OK_POWERS_PSU_FAMILY_ADV = true
		end
		---21-12V
		if INSTALLED_PSU_NAME == "P21" or INSTALLED_PSU_NAME == "P21D" or INSTALLED_PSU_NAME == "P21E" or INSTALLED_PSU_NAME == "P21G" then
			POWERS_PSU_FAMILY        = "UNKNOWN"
			POWERS_PSU_FAMILY_ADV    = "UNKNOWN"
			OK_POWERS_PSU_FAMILY     = false
			OK_POWERS_PSU_FAMILY_ADV = false
		end
		--->
		return true
	else
		POWERS_PSU_NAME          = "UNKNOWN"
		POWERS_PSU_FAMILY        = "UNKNOWN"
		POWERS_PSU_FAMILY_ADV    = "UNKNOWN"
		OK_POWERS_PSU_FAMILY     = false
		OK_POWERS_PSU_FAMILY_ADV = false
		return false
	end
	---<
end

--==CONST==--->
local OK_POWERS_PSU_NAME = Set_Powers_PSU_Name_Family()
--------------<

function Get_Power_Model()
--->
	INSTALLED_PSU_MODEL = luci.util.execi("cat /tmp/power/model  2> /dev/null")()
	if Is_String_Empty(INSTALLED_PSU_MODEL) then
	--->
		INSTALLED_PSU_MODEL = luci.util.execi("cat /sys/bitmicro/power/model  2> /dev/null")()
		if Is_String_Empty(INSTALLED_PSU_MODEL) then
		--->	
			INSTALLED_PSU_MODEL = "UNKNOWN"
			return false
		else
			return true
		end
	else
		return true
	end
end

--==CONST==--->
local OK_INSTALLED_PSU_MODEL  = Get_Power_Model()
--------------<

function Get_Power_Vender()
--->
	INSTALLED_PSU_VENDER = luci.util.execi("cat /tmp/power/vender  2> /dev/null")()
	if Is_String_Empty(INSTALLED_PSU_VENDER) then
	--->
		INSTALLED_PSU_VENDER = luci.util.execi("cat /sys/bitmicro/power/vender  2> /dev/null")()
		if Is_String_Empty(INSTALLED_PSU_VENDER) then
		--->
			INSTALLED_PSU_VENDER = "UNKNOWN"
			return false
		else
			return true
		end
	else
		return true
	end
	
end

--==CONST==--->
local OK_INSTALLED_PSU_VENDER = Get_Power_Vender()
--------------<

function Get_Power_Mode()
--->
	POWER_MODE = luci.util.execi("get-power-mode")()
	if Is_String_Empty(POWER_MODE) then
	--->
		POWER_MODE = "UNKNOWN"
		return false
	else
		return true
	end
end

--==CONST==--->
local OK_POWER_MODE = Get_Power_Mode()
--------------<

--==ADDLOG==-->
if OK_INSTALLED_PSU_NAME and OK_INSTALLED_PSU_VENDER and OK_INSTALLED_PSU_MODEL then  
	AddToSysLog("detected PSU name= "..INSTALLED_PSU_NAME..", vender= "..INSTALLED_PSU_VENDER..", model= "..INSTALLED_PSU_MODEL..", powers_psu_string= "..POWERS_PSU_NAME)
end
--------------<

function Get_Regular_PSU_Config_File()
	local power_cfg = ""
	--->
	power_cfg = Read_Symbolic_Link("/tmp/psu_cfg")
	---
	if Is_Regular_File_Exists(power_cfg) or Is_Symbolic_Link_Exists(power_cfg) then
		PSU_CONFIG_FILENAME = power_cfg
		return true
	else
	--->
		power_cfg = PSU_DEFAULT_CONFIG_PATH..power_cfg 
		---
		if Is_Regular_File_Exists(power_cfg) or Is_Symbolic_Link_Exists(power_cfg) then
			PSU_CONFIG_FILENAME = power_cfg
			return true
		else
			PSU_CONFIG_FILENAME = "UNKNOWN"
			return false
		end
	end	
end

function Get_Reserve_PSU_Config_File()
	local psu_n  = INSTALLED_PSU_NAME
	local psu_m  = INSTALLED_PSU_MODEL
	local psu_v  = INSTALLED_PSU_VENDER
	local try_fn = ""
	---->

	--1--
	if OK_INSTALLED_PSU_NAME and OK_INSTALLED_PSU_VENDER then
		try_fn = PSU_DEFAULT_CONFIG_PATH..psu_n.."_"..psu_v
		if Is_Regular_File_Exists(try_fn) or Is_Symbolic_Link_Exists(try_fn) then 
			PSU_CONFIG_FILENAME = try_fn 
			return true
		end
	end
	
	--2--
	if OK_INSTALLED_PSU_NAME then
		try_fn = PSU_DEFAULT_CONFIG_PATH..psu_n.."_0"
		if Is_Regular_File_Exists(try_fn) or Is_Symbolic_Link_Exists(try_fn) then 
			PSU_CONFIG_FILENAME = try_fn 
			return true
		end
	end
	
	--3--
	if OK_INSTALLED_PSU_MODEL and OK_INSTALLED_PSU_VENDER then
		try_fn = PSU_DEFAULT_CONFIG_PATH..psu_m.."_"..psu_v
		if Is_Regular_File_Exists(try_fn) or Is_Symbolic_Link_Exists(try_fn) then 
			PSU_CONFIG_FILENAME = try_fn 
			return true
		end
	end
	
	--4--
	if OK_INSTALLED_PSU_MODEL then
		try_fn = PSU_DEFAULT_CONFIG_PATH..psu_m.."_0"
		if Is_Regular_File_Exists(try_fn) or Is_Symbolic_Link_Exists(try_fn) then 
			PSU_CONFIG_FILENAME = try_fn 
			return true
		end
	end
	
	--5--
	return false
end

function Download_Default_PSU_Config()
	local psufn_url1 = ""
	local psufn_url2 = ""
	local down1 = false
	local down2 = false
	---
	if OK_INSTALLED_PSU_NAME and OK_INSTALLED_PSU_MODEL then
		--make-urls->
		psufn_url1 = LIC_SERVER_PSU_CONFIGS_DIR .. INSTALLED_PSU_NAME  .. "_0"
		psufn_url2 = LIC_SERVER_PSU_CONFIGS_DIR .. INSTALLED_PSU_MODEL .. "_0"
		------------<
		
		--download->
		if psufn_url1 ~= psufn_url2 then
			down1 = Download_File(psufn_url1,PSU_DEFAULT_CONFIG_PATH_NO_SLASH,INSTALLED_PSU_NAME .. "_0","664")
			down2 = Download_File(psufn_url2,PSU_DEFAULT_CONFIG_PATH_NO_SLASH,INSTALLED_PSU_MODEL .. "_0","664")
		else
			down1 = Download_File(psufn_url1,PSU_DEFAULT_CONFIG_PATH_NO_SLASH,INSTALLED_PSU_NAME .. "_0","664")
		end
		-----------<
		
		--->
		if down1 and not down2 then
			PSU_CONFIG_FILENAME = PSU_DEFAULT_CONFIG_PATH .. INSTALLED_PSU_NAME .. "_0"
			AddToSysLog("detected PSU config file downloaded and stored: ".. INSTALLED_PSU_NAME .. "_0")
			return true
		end
		--->
		if not down1 and down2 then
			PSU_CONFIG_FILENAME = PSU_DEFAULT_CONFIG_PATH .. INSTALLED_PSU_MODEL .."_0"
			AddToSysLog("detected PSU config file downloaded and stored: ".. INSTALLED_PSU_MODEL .. "_0")
			return true
		end
		--->
		if not down1 and not down2 then
			PSU_CONFIG_FILENAME = "UNKNOWN"
			AddToSysLog("detected PSU config file download failed!")
			return false
		end
		---<
	else
		PSU_CONFIG_FILENAME = "UNKNOWN"
		AddToSysLog("detected PSU config file download failed!")
		return false
	end
end

--==CONST==--->
local OK_PSU_CONFIG_FILENAME        = false
local IS_PSU_CONFIG_FILENAME_EXISTS = false
local IS_PSU_CONFIG_RESERVE         = false
---
OK_PSU_CONFIG_FILENAME = Get_Reserve_PSU_Config_File()
--->
	if not OK_PSU_CONFIG_FILENAME then
		IS_PSU_CONFIG_RESERVE  = true
		OK_PSU_CONFIG_FILENAME = Get_Regular_PSU_Config_File()
	end
	--->
		if not OK_PSU_CONFIG_FILENAME then
			IS_PSU_CONFIG_RESERVE  = true
			OK_PSU_CONFIG_FILENAME = Download_Default_PSU_Config()
		end
---------->
if OK_PSU_CONFIG_FILENAME then
	IS_PSU_CONFIG_FILENAME_EXISTS = true
else
	IS_PSU_CONFIG_FILENAME_EXISTS = false
end
--------------<

function Get_PSU_Config_Filename_Suffix()
	--->
	if OK_PSU_CONFIG_FILENAME then
		PSU_CONFIG_FILENAME_SUFFIX = luci.util.execi("echo " ..PSU_CONFIG_FILENAME.. " | cut -f 2 -d \"_\"  2> /dev/null")()
		if Is_String_Empty(PSU_CONFIG_FILENAME_SUFFIX) or tonumber(PSU_CONFIG_FILENAME_SUFFIX) == nil then
			PSU_CONFIG_FILENAME_SUFFIX = "UNKNOWN"
			return false
		else
			return true
		end
	else
		PSU_CONFIG_FILENAME_SUFFIX = "UNKNOWN"
		return false
	end
end

function Get_PSU_Config_Filename_Prefix()
	--->
	if OK_PSU_CONFIG_FILENAME then
		PSU_CONFIG_FILENAME_PREFIX = luci.util.execi("echo " ..PSU_CONFIG_FILENAME.. " | cut -f 1 -d \"_\" | cut -f 5 -d \"/\"  2> /dev/null")()
		if Is_String_Empty(PSU_CONFIG_FILENAME_PREFIX) then
			PSU_CONFIG_FILENAME_PREFIX = "UNKNOWN"
			return false
		else
			return true
		end
	else
		PSU_CONFIG_FILENAME_PREFIX = "UNKNOWN"
		return false
	end
end

--==CONST==--->
local OK_PSU_CONFIG_FILENAME_SUFFIX = Get_PSU_Config_Filename_Suffix()
local OK_PSU_CONFIG_FILENAME_PREFIX = Get_PSU_Config_Filename_Prefix()
--------------<

--==ADDLOG==-->
if OK_PSU_CONFIG_FILENAME and OK_PSU_CONFIG_FILENAME_PREFIX and OK_PSU_CONFIG_FILENAME_SUFFIX then
	AddToSysLog("detected loaded PSU config: "..PSU_CONFIG_FILENAME..", isreserve= "..tostring(IS_PSU_CONFIG_RESERVE)..", prefix= "..PSU_CONFIG_FILENAME_PREFIX..", suffix= "..PSU_CONFIG_FILENAME_SUFFIX)
end
--------------<

function Fix_PSU_Config_File(psu_cfg_fn)
--->	
	if Is_Regular_File_Exists(psu_cfg_fn) or Is_Symbolic_Link_Exists(psu_cfg_fn) then
	--->
		if luci.util.execi("ini get "..psu_cfg_fn.." common iout_max  2> /dev/null || echo 0")() == "334.0" then
		--->
			PSU_CONFIG_ALREADY_FIXED = true
			
			--Load-fixed-parameters-->
			FIXED_PSU_IIN_LIMIT     = luci.util.execi("ini get " ..psu_cfg_fn.. " common iin_limit  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_IIN_MAX       = luci.util.execi("ini get " ..psu_cfg_fn.. " common iin_max  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_POWER_LIMIT   = luci.util.execi("ini get " ..psu_cfg_fn.. " common power_limit  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_POWER_MAX     = luci.util.execi("ini get " ..psu_cfg_fn.. " common power_max  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_IOUT_LIMIT    = luci.util.execi("ini get " ..psu_cfg_fn.. " common iout_limit  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_IOUT_MAX      = luci.util.execi("ini get " ..psu_cfg_fn.. " common iout_max  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_VOLTAGE_LIMIT = luci.util.execi("ini get " ..psu_cfg_fn.. " common voltage_limit  2> /dev/null || echo UNKNOWN")()
			FIXED_PSU_VOLTAGE_MAX   = luci.util.execi("ini get " ..psu_cfg_fn.. " common voltage_max  2> /dev/null || echo UNKNOWN")()
			--->
			return true
		---<
		else
			--->
			PSU_CONFIG_ALREADY_FIXED = false

			--PXX1X--12V--->
			if INSTALLED_PSU_NAME == "P221B" or INSTALLED_PSU_NAME == "P221C" or INSTALLED_PSU_NAME == "P231A" or INSTALLED_PSU_NAME == "P231B" then
				---------->
				FIXED_PSU_IIN_LIMIT     = "18.6"
				FIXED_PSU_IIN_MAX       = "18.8"
				FIXED_PSU_POWER_LIMIT   = "3800"
				FIXED_PSU_POWER_MAX     = "3850"
				FIXED_PSU_IOUT_LIMIT    = "327.0"
				FIXED_PSU_IOUT_MAX      = "334.0"
				FIXED_PSU_VOLTAGE_LIMIT = "1450"
				FIXED_PSU_VOLTAGE_MAX   = "1500"
								-------------------------->
				luci.util.execi("ini set " ..psu_cfg_fn..  " common power_limit " ..FIXED_PSU_POWER_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common power_max " ..FIXED_PSU_POWER_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..   " common iout_limit " ..FIXED_PSU_IOUT_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..     " common iout_max " ..FIXED_PSU_IOUT_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common iin_limit " ..FIXED_PSU_IIN_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..      " common iin_max " ..FIXED_PSU_IIN_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn.." common voltage_limit " ..FIXED_PSU_VOLTAGE_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..  " common voltage_max " ..FIXED_PSU_VOLTAGE_MAX)()
				--->
				return true
			end
			---<
		
			--PXX2X--14V--->
			if INSTALLED_PSU_NAME == "P222B" or INSTALLED_PSU_NAME == "P222C" or INSTALLED_PSU_NAME == "P232A" or INSTALLED_PSU_NAME == "P232B" or INSTALLED_PSU_NAME == "P21E" then
				---------->
				FIXED_PSU_IIN_LIMIT   = "18.6"
				FIXED_PSU_IIN_MAX     = "18.8"
				FIXED_PSU_POWER_LIMIT = "3800"
				FIXED_PSU_POWER_MAX   = "3850"
				FIXED_PSU_IOUT_LIMIT  = "327.0"
				FIXED_PSU_IOUT_MAX    = "334.0"
				FIXED_PSU_VOLTAGE_LIMIT = "1550"
				FIXED_PSU_VOLTAGE_MAX   = "1600"
				-------------------------->
				luci.util.execi("ini set " ..psu_cfg_fn..  " common power_limit " ..FIXED_PSU_POWER_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common power_max " ..FIXED_PSU_POWER_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..   " common iout_limit " ..FIXED_PSU_IOUT_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..     " common iout_max " ..FIXED_PSU_IOUT_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common iin_limit " ..FIXED_PSU_IIN_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..      " common iin_max " ..FIXED_PSU_IIN_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn.." common voltage_limit " ..FIXED_PSU_VOLTAGE_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..  " common voltage_max " ..FIXED_PSU_VOLTAGE_MAX)()
				--->
				return true
			end
			---<
		
			--P21--12V--->
			if INSTALLED_PSU_NAME == "P21" then
				---------->
				FIXED_PSU_IIN_LIMIT     = "18.3"
				FIXED_PSU_IIN_MAX       = "18.5"
				FIXED_PSU_POWER_LIMIT   = "3750"
				FIXED_PSU_POWER_MAX     = "3800"
				FIXED_PSU_IOUT_LIMIT    = "327.0"
				FIXED_PSU_IOUT_MAX      = "334.0"
				FIXED_PSU_VOLTAGE_LIMIT = "1450"
				FIXED_PSU_VOLTAGE_MAX   = "1500"
				-------------------------->
				luci.util.execi("ini set " ..psu_cfg_fn..  " common power_limit " ..FIXED_PSU_POWER_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common power_max " ..FIXED_PSU_POWER_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..   " common iout_limit " ..FIXED_PSU_IOUT_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..     " common iout_max " ..FIXED_PSU_IOUT_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common iin_limit " ..FIXED_PSU_IIN_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..      " common iin_max " ..FIXED_PSU_IIN_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn.." common voltage_limit " ..FIXED_PSU_VOLTAGE_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..  " common voltage_max " ..FIXED_PSU_VOLTAGE_MAX)()
				--->
				return true
			end
			---<
		
			---P21D--P21G--12V--->
			if INSTALLED_PSU_NAME == "P21D" or INSTALLED_PSU_NAME == "P21G" then
				---------->
				FIXED_PSU_IIN_LIMIT     = "18.6"
				FIXED_PSU_IIN_MAX       = "18.8"
				FIXED_PSU_POWER_LIMIT   = "3800"
				FIXED_PSU_POWER_MAX     = "3850"
				FIXED_PSU_IOUT_LIMIT    = "327.0"
				FIXED_PSU_IOUT_MAX      = "334.0"
				FIXED_PSU_VOLTAGE_LIMIT = "1450"
				FIXED_PSU_VOLTAGE_MAX   = "1500"
				-------------------------->
				luci.util.execi("ini set " ..psu_cfg_fn..  " common power_limit " ..FIXED_PSU_POWER_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common power_max " ..FIXED_PSU_POWER_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..   " common iout_limit " ..FIXED_PSU_IOUT_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..     " common iout_max " ..FIXED_PSU_IOUT_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn..    " common iin_limit " ..FIXED_PSU_IIN_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..      " common iin_max " ..FIXED_PSU_IIN_MAX)()
				luci.util.execi("ini set " ..psu_cfg_fn.." common voltage_limit " ..FIXED_PSU_VOLTAGE_LIMIT)()
				luci.util.execi("ini set " ..psu_cfg_fn..  " common voltage_max " ..FIXED_PSU_VOLTAGE_MAX)()
				--->
				return true
			end
			---<
		
			---PSU-name-not-found--->
			FIXED_PSU_IIN_LIMIT     = "UNKNOWN"
			FIXED_PSU_IIN_MAX       = "UNKNOWN"
			FIXED_PSU_POWER_LIMIT   = "UNKNOWN"
			FIXED_PSU_POWER_MAX     = "UNKNOWN"
			FIXED_PSU_IOUT_LIMIT    = "UNKNOWN"
			FIXED_PSU_IOUT_MAX      = "UNKNOWN"
			FIXED_PSU_VOLTAGE_LIMIT = "UNKNOWN"
			FIXED_PSU_VOLTAGE_MAX   = "UNKNOWN"
			--->
			return false
			---<
		end	
	else
		---PSU-file-not-found--->
		FIXED_PSU_IIN_LIMIT     = "UNKNOWN"
		FIXED_PSU_IIN_MAX       = "UNKNOWN"
		FIXED_PSU_POWER_LIMIT   = "UNKNOWN"
		FIXED_PSU_POWER_MAX     = "UNKNOWN"
		FIXED_PSU_IOUT_LIMIT    = "UNKNOWN"
		FIXED_PSU_IOUT_MAX      = "UNKNOWN"
		FIXED_PSU_VOLTAGE_LIMIT = "UNKNOWN"
		FIXED_PSU_VOLTAGE_MAX   = "UNKNOWN"
		--->
		return false
		---<
	end
end

function Copy_Default_PSU_To_Vender_PSU()
	local psu_suff = PSU_CONFIG_FILENAME_SUFFIX
	---
	if OK_PSU_CONFIG_FILENAME_PREFIX and OK_PSU_CONFIG_FILENAME_SUFFIX and OK_INSTALLED_PSU_VENDER and IS_PSU_CONFIG_FILENAME_EXISTS then
	--->
		if tonumber(INSTALLED_PSU_VENDER) ~= tonumber(PSU_CONFIG_FILENAME_SUFFIX) and INSTALLED_PSU_VENDER ~= "0" then
		--->
			if Copy_File_Overwrite_And_Set_Perm(PSU_CONFIG_FILENAME,PSU_DEFAULT_CONFIG_PATH..PSU_CONFIG_FILENAME_PREFIX.."_"..INSTALLED_PSU_VENDER,"664") then
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
end

--==CONST==--->
if OK_PSU_CONFIG_FILENAME_PREFIX and OK_PSU_CONFIG_FILENAME_SUFFIX and IS_PSU_CONFIG_FILENAME_EXISTS then
--->
	if PSU_CONFIG_FILENAME_SUFFIX ~= "0" then
	--->	
		IS_PSU_CONFIG_FIXED = Fix_PSU_Config_File(PSU_CONFIG_FILENAME)
	else
	--->
		IS_PSU_CONFIG_COPYED = Copy_Default_PSU_To_Vender_PSU()
		if IS_PSU_CONFIG_COPYED then IS_PSU_CONFIG_FIXED = Fix_PSU_Config_File(PSU_DEFAULT_CONFIG_PATH..PSU_CONFIG_FILENAME_PREFIX.."_"..INSTALLED_PSU_VENDER) end
	end
end
--------------<

--==ADDLOG==-->
if OK_PSU_CONFIG_FILENAME then
	AddToSysLog("detected fixed PSU config: "..PSU_CONFIG_FILENAME..", fixed_loaded= "..tostring(PSU_CONFIG_ALREADY_FIXED)..", fixed= "..tostring(IS_PSU_CONFIG_FIXED))
end
--------------<

function Get_PSU_Config_Array()
	
	local cfg = {
		exists = false,
		name = "",
		v_min = "",
		v_limit = "",
		v_max = "",
		p_limit = "",
		p_max = "",
		iout_limit = "",
		iout_max = "",
		iin_limit = "",
		iin_max = "",
		barried_err = ""
	}
	
	if IS_PSU_CONFIG_FILENAME_EXISTS then
		cfg.exists      = true
		cfg.name        = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common name  2> /dev/null")()
		cfg.v_min       = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common voltage_min  2> /dev/null")()
		cfg.v_limit     = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common voltage_limit  2> /dev/null")()
		cfg.v_max       = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common voltage_max  2> /dev/null")()
		cfg.p_limit     = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common power_limit  2> /dev/null")()
		cfg.p_max       = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common power_max  2> /dev/null")()
		cfg.iout_limit  = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common iout_limit  2> /dev/null")()
		cfg.iout_max    = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common iout_max  2> /dev/null")()
		cfg.iin_limit   = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common iin_limit  2> /dev/null")()
		cfg.iin_max     = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common iin_max  2> /dev/null")()
		cfg.barried_err = luci.util.execi("ini get " ..PSU_CONFIG_FILENAME.. " common barried_error  2> /dev/null")()
	else
		cfg.exists      = false
		cfg.name        = "UNKNOWN"
		cfg.v_min       = "UNKNOWN"
		cfg.v_limit     = "UNKNOWN"
		cfg.v_max       = "UNKNOWN"
		cfg.p_limit     = "UNKNOWN"
		cfg.p_max       = "UNKNOWN"
		cfg.iout_limit  = "UNKNOWN"
		cfg.iout_max    = "UNKNOWN"
		cfg.iin_limit   = "UNKNOWN"
		cfg.iin_max     = "UNKNOWN"
		cfg.barried_err = "UNKNOWN"
	end
	
	return cfg
end

function Get_PSU_Config_Value(psu_config_filepath,value_name)
	return luci.util.execi("ini get "..psu_config_filepath.." common "..value_name.."  2> /dev/null || echo UNKNOWN")()
end

function Set_PSU_Config_Value(psu_config_filepath,value_name,value)
	return luci.util.execi("ini set "..psu_config_filepath.." common "..value_name.." "..value.."  2> /dev/null && echo 1 || echo 0")() ~= "0"
end

--==CONST==--->
PSU_CONFIG_ARRAY = Get_PSU_Config_Array()
local OK_PSU_CONFIG_ARRAY = PSU_CONFIG_ARRAY.exists

if OK_PSU_CONFIG_ARRAY then
	DEFAULT_VENDER0_MIN_VOLTAGE = PSU_CONFIG_ARRAY.v_min
	DEFAULT_VENDER0_MAX_VOLTAGE = PSU_CONFIG_ARRAY.v_limit
	DEFAULT_VENDER0_POWER_LIMIT = PSU_CONFIG_ARRAY.p_limit
	DEFAULT_VENDER0_POWER_MAX   = PSU_CONFIG_ARRAY.p_max
	---
	if PSU_CONFIG_ALREADY_FIXED and OK_INSTALLED_PSU_VENDER and INSTALLED_PSU_VENDER ~= "0" then
		if OK_PSU_CONFIG_FILENAME_PREFIX and Is_Regular_File_Exists(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0") or Is_Symbolic_Link_Exists(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0") then
			DEFAULT_VENDER0_MIN_VOLTAGE = Get_PSU_Config_Value(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0","voltage_min")
			DEFAULT_VENDER0_MAX_VOLTAGE = Get_PSU_Config_Value(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0","voltage_limit")
			DEFAULT_VENDER0_POWER_LIMIT = Get_PSU_Config_Value(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0","power_limit")
			DEFAULT_VENDER0_POWER_MAX   = Get_PSU_Config_Value(PSU_DEFAULT_CONFIG_PATH .. PSU_CONFIG_FILENAME_PREFIX .. "_0","power_max")
		end
	end
else
	DEFAULT_VENDER0_MIN_VOLTAGE = "UNKNOWN"
	DEFAULT_VENDER0_MAX_VOLTAGE = "UNKNOWN"
	DEFAULT_VENDER0_POWER_LIMIT = "UNKNOWN"
	DEFAULT_VENDER0_POWER_MAX   = "UNKNOWN"
end	
--------------<

----------------------------------------
--====================================--
--====================================--
--====================================--
---------GET_SET_POWERS_CONFIG----------

function Get_Powers_Config_Filename()
	--->
	POWERS_CONFIG_FILENAME = Read_Symbolic_Link(POWERS_SYMLINK)
	if Is_String_Empty(POWERS_CONFIG_FILENAME) or Is_String_Unknown(POWERS_CONFIG_FILENAME) then
		POWERS_CONFIG_FILENAME = "UNKNOWN"
		POWERS_CONFIG_FULLPATH = "UNKNOWN"
		return false
	else
		POWERS_CONFIG_FULLPATH = POWERS_DEFAULT_PATH..POWERS_CONFIG_FILENAME
		return true
	end
end

--==CONST==--->
local OK_POWERS_CONFIG_FILENAME = Get_Powers_Config_Filename()
--------------<

--==ADDLOG==-->
if OK_POWERS_CONFIG_FILENAME then
	AddToSysLog("detected powers config: "..POWERS_CONFIG_FULLPATH..", config version= "..POWERS_CONFIG_VERSION)
end
--------------<

---------GET_MINER-TYPE-VERSION---------

function Get_Miner_Type()
	--->
	if OK_POWERS_CONFIG_FILENAME then
		---get-miner-type->
		MINER_TYPE_LOWERCASE = luci.util.execi("echo "..POWERS_CONFIG_FILENAME.." | cut -f 2 -d \".\"  2> /dev/null")()
		------------------<
		if Is_String_Empty(MINER_TYPE_LOWERCASE) then
			MINER_TYPE_LOWERCASE = "unknown"
			return false
		else
			return true
		end
	else
		MINER_TYPE_LOWERCASE = "unknown"
		return false
	end
end

function Get_Miner_Version()
	--->
	if OK_POWERS_CONFIG_FILENAME then
		---get-miner-type->
		MINER_VERSION_LOWERCASE = luci.util.execi("echo "..POWERS_CONFIG_FILENAME.." | cut -f 3 -d \".\"  2> /dev/null")()
		------------------<
		if Is_String_Empty(MINER_VERSION_LOWERCASE) then
			MINER_VERSION_LOWERCASE = "unknown"
			return false
		else
			return true
		end
	else
		MINER_VERSION_LOWERCASE = "unknown"
		return false
	end

end

--==CONST==--->
local OK_MINER_TYPE_LOWERCASE       = Get_Miner_Type()
local OK_MINER_VERSION_LOWERCASE    = Get_Miner_Version()
local OK_MINER_FULL_MODEL_LOWERCASE = false
--->
	if OK_MINER_TYPE_LOWERCASE and Is_String_Common(MINER_TYPE_LOWERCASE) then
		DEFAULT_POWERS_CONFIG_FILENAME = "powers.default.common"
		DEFAULT_POWERS_CONFIG_FULLPATH = POWERS_DEFAULT_PATH.."powers.default.common"
		MINER_FULL_MODEL_LOWERCASE     = "common"
		OK_MINER_FULL_MODEL_LOWERCASE  = true
	end
	
	
	if OK_MINER_TYPE_LOWERCASE and not Is_String_Common(MINER_TYPE_LOWERCASE) and OK_MINER_VERSION_LOWERCASE then
		DEFAULT_POWERS_CONFIG_FILENAME = "powers.default."..MINER_TYPE_LOWERCASE.."."..MINER_VERSION_LOWERCASE
		DEFAULT_POWERS_CONFIG_FULLPATH = POWERS_DEFAULT_PATH.."powers.default."..MINER_TYPE_LOWERCASE.."."..MINER_VERSION_LOWERCASE
		MINER_FULL_MODEL_LOWERCASE     = MINER_TYPE_LOWERCASE.."."..MINER_VERSION_LOWERCASE
		OK_MINER_FULL_MODEL_LOWERCASE  = true
	end
--------------<

--==ADDLOG==-->
if OK_MINER_FULL_MODEL_LOWERCASE then
	AddToSysLog("detected miner model by powers config: "..MINER_FULL_MODEL_LOWERCASE)
end
--------------<


function Get_Overview_Miner_Full_Model()
	local hostname = ""
	
	--Get-hostname-from-overview->
	hostname = string.pcdata(ver.hardwareversion)
	---<
	if Is_String_Empty(hostname) then
		OVERVIEW_PARSED_MODEL_LOWERCASE = "unknown"
		return false
	else
		OVERVIEW_PARSED_MODEL_LOWERCASE = luci.util.execi("echo "..hostname.." | cut -f 1 -d \".\"  2> /dev/null")()
		if Is_String_Empty(OVERVIEW_PARSED_MODEL_LOWERCASE) or Is_String_Unknown(OVERVIEW_PARSED_MODEL_LOWERCASE) then
			OVERVIEW_PARSED_MODEL_LOWERCASE = "unknown"
			return false
		else
			hostname = string.lower(OVERVIEW_PARSED_MODEL_LOWERCASE)
			OVERVIEW_PARSED_MODEL_LOWERCASE = hostname
			return true
		end
	end
end

function Get_Overview_Miner_Type(overview_full_model)
	--->
	if Is_String_Empty(overview_full_model) or Is_String_Unknown(overview_full_model) then
		OVERVIEW_MINER_TYPE_LOWERCASE = "unknown"
		return false
	else
		OVERVIEW_MINER_TYPE_LOWERCASE = luci.util.execi("echo "..overview_full_model.." | cut -f 1 -d \"_\"  2> /dev/null")()
		if Is_String_Empty(OVERVIEW_MINER_TYPE_LOWERCASE) then
			OVERVIEW_MINER_TYPE_LOWERCASE = "unknown"
			return false
		else
			return true
		end
	end
end

function Get_Overview_Miner_Version(overview_full_model)
	local strstr = ""
	---
	if Is_String_Empty(overview_full_model) or Is_String_Unknown(overview_full_model) then
		OVERVIEW_MINER_VERSION_LOWERCASE = "unknown"
		return false
	else
		OVERVIEW_MINER_VERSION_LOWERCASE = luci.util.execi("echo "..overview_full_model.." | cut -f 2 -d \"_\"  2> /dev/null")()
		if Is_String_Empty(OVERVIEW_MINER_VERSION_LOWERCASE) then
			OVERVIEW_MINER_VERSION_LOWERCASE = "unknown"
			return false
		else
			strstr = OVERVIEW_MINER_VERSION_LOWERCASE:sub(1, -2)
			OVERVIEW_MINER_VERSION_LOWERCASE = strstr .. "0"
			return true
		end
	end
end

--==CONST==--->
local OK_OVERVIEW_PARSED_MODEL_LOWERCASE  = Get_Overview_Miner_Full_Model()
local OK_OVERVIEW_MINER_TYPE_LOWERCASE    = Get_Overview_Miner_Type(OVERVIEW_PARSED_MODEL_LOWERCASE)
local OK_OVERVIEW_MINER_VERSION_LOWERCASE = Get_Overview_Miner_Version(OVERVIEW_PARSED_MODEL_LOWERCASE)
local OK_OVERVIEW_FULL_MODEL_LOWERCASE    = false
--->
	if OK_OVERVIEW_MINER_TYPE_LOWERCASE and OK_OVERVIEW_MINER_VERSION_LOWERCASE then
		OVERVIEW_FULL_MODEL_LOWERCASE    = OVERVIEW_MINER_TYPE_LOWERCASE .."."..OVERVIEW_MINER_VERSION_LOWERCASE
		OK_OVERVIEW_FULL_MODEL_LOWERCASE = true
	else
		OVERVIEW_FULL_MODEL_LOWERCASE = "unknown"
		OK_OVERVIEW_FULL_MODEL_LOWERCASE = false
	end
--------------<

--==ADDLOG==-->
if not Is_String_Empty(OVERVIEW_FULL_MODEL_LOWERCASE) then
	AddToSysLog("detected miner model by current overview hw: "..OVERVIEW_FULL_MODEL_LOWERCASE)
end
--------------<

---------MINER-CONFIGURATION-NAME----------

function Get_Powers_Configuration_Name()
	local strstr = ""
	local powers_cfg_name = "config"
	
	local psu0 = false
	local fam1 = false
	local fam2 = false
	local new3 = false
	
	if OK_POWERS_PSU_NAME and OK_POWERS_CONFIG_FILENAME then
	--->
		psu0 = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME      .." config  2> /dev/null || echo 0")() ~= "0"
		fam1 = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY    .." config  2> /dev/null || echo 0")() ~= "0"
		fam2 = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY_ADV.." config  2> /dev/null || echo 0")() ~= "0"
	--->
		if fam1 and fam2 then
			powers_cfg_name = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY    .." config  2> /dev/null || echo 0")()
			strstr = "\\\""..powers_cfg_name.."\\\""
			---
			OK_POWERS_PSU_FAMILY     = true
			OK_POWERS_PSU_FAMILY_ADV = true
			---
			if not psu0 then
				luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME.." config "..strstr)()
			end
		end
	--->
		if fam1 and not fam2 then
			powers_cfg_name = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY    .." config  2> /dev/null || echo 0")()
			strstr = "\\\""..powers_cfg_name.."\\\""
			---
			OK_POWERS_PSU_FAMILY     = true
			OK_POWERS_PSU_FAMILY_ADV = false
			---
			if not psu0 then
				luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME.." config "..strstr)()
			end
		end
	--->
		if fam2 and not fam1 then
			powers_cfg_name = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY_ADV.." config  2> /dev/null || echo 0")()
			strstr = "\\\""..powers_cfg_name.."\\\""
			---
			OK_POWERS_PSU_FAMILY     = false
			OK_POWERS_PSU_FAMILY_ADV = true
			---
			if not psu0 then
				luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME.." config "..strstr)()
			end
		end
	--->
		if not fam1 and not fam2 then
			---
			if psu0 then
				powers_cfg_name = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME .." config  2> /dev/null || echo 0")()
			else
				powers_cfg_name = "config"
				strstr = "\\\""..powers_cfg_name.."\\\""
				--->
				luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME.." config "..strstr)()
			end
			---
			OK_POWERS_PSU_FAMILY     = false
			OK_POWERS_PSU_FAMILY_ADV = false	
		end
	---<
	end
	
------->
		POWERS_CONFIGURATION_NAME = powers_cfg_name
		return true
-------<

end

--==CONST==--->
local OK_POWERS_CONFIGURATION_NAME = Get_Powers_Configuration_Name()
--------------<

--==ADDLOG==-->
if OK_POWERS_CONFIG_FILENAME then
	if OK_POWERS_PSU_NAME and not OK_POWERS_PSU_FAMILY and not OK_POWERS_PSU_FAMILY_ADV then
		AddToSysLog("powers config used psu strings: "..POWERS_PSU_NAME)
	end
	if OK_POWERS_PSU_NAME and not OK_POWERS_PSU_FAMILY and OK_POWERS_PSU_FAMILY_ADV then
		AddToSysLog("powers config used psu strings: "..POWERS_PSU_NAME..", "..POWERS_PSU_FAMILY_ADV)
	end
	if OK_POWERS_PSU_NAME and OK_POWERS_PSU_FAMILY and not OK_POWERS_PSU_FAMILY_ADV then
		AddToSysLog("powers config used psu strings: "..POWERS_PSU_NAME..", "..POWERS_PSU_FAMILY)
	end
end
--------------<

------------POWERS-PSU-CONFIG--------------

function Get_Current_Powers_PSU_Config_Value(value_name)
	return luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME.." "..value_name.."  2> /dev/null || echo UNKNOWN")()
end

function Set_Current_Powers_PSU_Config_Value(value_name,value,fixed_psu_config_loaded)
	---
	if OK_POWERS_CONFIG_FILENAME then
		--set-for-psu-name--
		if OK_POWERS_PSU_NAME then
			luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_NAME      .." "..value_name.." "..value)()
		end
		--set-for-psu-fam1--
		if OK_POWERS_PSU_FAMILY then
			luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY    .." "..value_name.." "..value)()
		end
		--set-for-psu-fam2--
		if OK_POWERS_PSU_FAMILY_ADV then
			luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_PSU_FAMILY_ADV.." "..value_name.." "..value)()
		end
	end
	---
	if OK_PSU_CONFIG_FILENAME and not Is_String_Empty(value_name) and not Is_String_Empty(value) and fixed_psu_config_loaded then
		--set-in-psu-config--
		luci.util.execi("ini set "..PSU_CONFIG_FILENAME.." common "..value_name.." "..value.."  2> /dev/null")()
	end
end

function Get_Current_Powers_Common_Config_Value(value_name)
	return luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." common "..value_name.."  2> /dev/null || echo UNKNOWN")()
end

function Set_Current_Powers_Common_Config_Value(value_name,value)
	--->
	if OK_POWERS_CONFIG_FILENAME and not Is_String_Empty(value_name) and not Is_String_Empty(value) then
		luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." common "..value_name.." "..value.."  2> /dev/null")()
	end
end

function Get_Current_Powers_PSU_Config()
	local lvoltage_min   = ""
	local lvoltage_limit = ""
	local lpower_limit   = ""
	local lpower_max     = ""
	local lpower_min     = ""
	local liin_limit     = ""
	local liin_max       = ""
	local liout_limit    = ""
	local liout_max      = ""
	
	---	
	local pws_cfg = {
		is_set_voltage_min = false,
		voltage_min = "",
		is_set_voltage_limit = false,
		voltage_limit = "",
		is_set_power_limit = false,
		power_limit = "",
		is_set_power_max   = false,
		power_max   = "",
		is_set_power_min   = false,
		power_min   = "",
		is_set_iin_limit   = false,
		iin_limit   = "",
		is_set_iin_max     = false,
		iin_max     = "",
		is_set_iout_limit  = false,
		iout_limit  = "",
		is_set_iout_max    = false,
		iout_max    = ""
	}
	
	if OK_POWERS_CONFIG_FILENAME then
		--voltage-min--
		lvoltage_min = Get_Current_Powers_PSU_Config_Value("voltage_min")
		if not Is_String_Unknown(lvoltage_min) then
			pws_cfg.is_set_voltage_min = true
			pws_cfg.voltage_min = lvoltage_min
		end
		
		--voltage-limit--
		lvoltage_limit = Get_Current_Powers_PSU_Config_Value("voltage_limit")
		if not Is_String_Unknown(lvoltage_limit) then
			pws_cfg.is_set_voltage_limit = true
			pws_cfg.voltage_limit = lvoltage_limit
		end
		
		--power-limit--
		lpower_limit = Get_Current_Powers_PSU_Config_Value("power_limit")
		if not Is_String_Unknown(lpower_limit) then
			pws_cfg.is_set_power_limit = true
			pws_cfg.power_limit = lpower_limit
		end
		
		--power-max--
		lpower_max = Get_Current_Powers_PSU_Config_Value("power_max")
		if not Is_String_Unknown(lpower_max) then
			pws_cfg.is_set_power_max = true
			pws_cfg.power_max = lpower_max
		end
		
		--power-min--
		lpower_min = Get_Current_Powers_PSU_Config_Value("power_min")
		if not Is_String_Unknown(lpower_min) then
			pws_cfg.is_set_power_min = true
			pws_cfg.power_min = lpower_min
		end
		
		--iin-limit--
		liin_limit = Get_Current_Powers_PSU_Config_Value("iin_limit")
		if not Is_String_Unknown(liin_limit) then
			pws_cfg.is_set_iin_limit = true
			pws_cfg.iin_limit = liin_limit
		end
		
		--iin-max----
		liin_max = Get_Current_Powers_PSU_Config_Value("iin_max")
		if not Is_String_Unknown(liin_max) then
			pws_cfg.is_set_iin_max = true
			pws_cfg.iin_max = liin_max
		end
		
		--iout-limit--
		liout_limit = Get_Current_Powers_PSU_Config_Value("iout_limit")
		if not Is_String_Unknown(liout_limit) then
			pws_cfg.is_set_iout_limit = true
			pws_cfg.iout_limit = liout_limit
		end
		
		--iout-max--
		liout_max = Get_Current_Powers_PSU_Config_Value("iout_max")
		if not Is_String_Unknown(liout_max) then
			pws_cfg.is_set_iout_max = true
			pws_cfg.iout_max = liout_max
		end
		------------>
	end
	
	return pws_cfg
end

--==CONST==--->
POWERS_PSU_CONFIG = Get_Current_Powers_PSU_Config()
--------------<

function Get_Current_Actual_PSU_VoltageMin()			-->Need-Compare-With-Voltage_Min-From_Powers-Bin-Config!!!
	if POWERS_PSU_CONFIG.is_set_voltage_min then
		return POWERS_PSU_CONFIG.voltage_min
	else
		return PSU_CONFIG_ARRAY.v_min
	end
end

function Get_Current_Actual_PSU_VoltageLimit()			-->Need-Compare-With-Voltage_Limit-From_Powers-Bin-Config!!!
	if POWERS_PSU_CONFIG.is_set_voltage_limit then
		return POWERS_PSU_CONFIG.voltage_limit
	else
		return PSU_CONFIG_ARRAY.v_limit
	end
end

function Get_Current_Actual_PSU_PowerLimit()
	if POWERS_PSU_CONFIG.is_set_power_limit then
		return POWERS_PSU_CONFIG.power_limit
	else
		return PSU_CONFIG_ARRAY.p_limit
	end
end

function Get_Current_Actual_PSU_PowerMax()
	if POWERS_PSU_CONFIG.is_set_power_max then
		return POWERS_PSU_CONFIG.power_max
	else
		return PSU_CONFIG_ARRAY.p_max
	end

end

function Get_Current_Actual_PSU_IinLimit()
	if POWERS_PSU_CONFIG.is_set_iin_limit then
		return POWERS_PSU_CONFIG.iin_limit
	else
		return PSU_CONFIG_ARRAY.iin_limit
	end
end

function Get_Current_Actual_PSU_IinMax()
	if POWERS_PSU_CONFIG.is_set_iin_max then
		return POWERS_PSU_CONFIG.iin_max
	else
		return PSU_CONFIG_ARRAY.iin_max
	end
end

function Get_Current_Actual_PSU_IoutLimit()
	if POWERS_PSU_CONFIG.is_set_iout_limit then
		return POWERS_PSU_CONFIG.iout_limit
	else
		return PSU_CONFIG_ARRAY.iout_limit
	end
end

function Get_Current_Actual_PSU_IoutMax()
	if POWERS_PSU_CONFIG.is_set_iout_max then
		return POWERS_PSU_CONFIG.iout_max
	else
		return PSU_CONFIG_ARRAY.iout_max
	end
end

--==CONST==--->
ACTUAL_PSU_VOLTAGE_MIN   = Get_Current_Actual_PSU_VoltageMin()
ACTUAL_PSU_VOLTAGE_LIMIT = Get_Current_Actual_PSU_VoltageLimit()
ACTUAL_PSU_POWER_LIMIT   = Get_Current_Actual_PSU_PowerLimit()
ACTUAL_PSU_POWER_MAX     = Get_Current_Actual_PSU_PowerMax()
ACTUAL_PSU_IIN_LIMIT     = Get_Current_Actual_PSU_IinLimit()
ACTUAL_PSU_IIN_MAX       = Get_Current_Actual_PSU_IinMax()
ACTUAL_PSU_IOUT_LIMIT    = Get_Current_Actual_PSU_IoutLimit()
ACTUAL_PSU_IOUT_MAX      = Get_Current_Actual_PSU_IoutMax()
--------------<

------------POWER_MODE--------------

--==CONST==--->
if OK_POWER_MODE then
	if POWER_MODE == "0" then POWER_MODE_PREFIX = "lp_" end
	if POWER_MODE == "1" then POWER_MODE_PREFIX = ""    end
	if POWER_MODE == "2" then POWER_MODE_PREFIX = "hp_" end
end
--------------<

--==ADDLOG==-->
if OK_POWER_MODE then
	if Is_String_Empty(POWER_MODE_PREFIX) then
		AddToSysLog("detected power mode: "..POWER_MODE..", no bin prefix will be used.")
	else
		AddToSysLog("detected power mode: "..POWER_MODE..", bin prefix= "..POWER_MODE_PREFIX)
	end
end
--------------<

------------BIN_VER_TYPE_LEAK--------------

function Get_Bin_Type()
	--->
	if IS_BTMINER then
		BIN_TYPE = luci.util.execi("cat /tmp/eeprom/bin_type  2> /dev/null")()
		if Is_String_Empty(BIN_TYPE) then
			--->
			BIN_TYPE = luci.util.execi("uci get /tmp/eeprom.common.bin_type  2> /dev/null")()
				if Is_String_Empty(BIN_TYPE) then
					BIN_TYPE = ""
					return false
				else
					return true
				end
		else
			return true
		end
	else
		--->
		BIN_TYPE = luci.util.execi("uci get /tmp/eeprom.common.bin_type  2> /dev/null")()
		if Is_String_Empty(BIN_TYPE) then
			--->
			BIN_TYPE = luci.util.execi("cat /tmp/eeprom/bin_type  2> /dev/null")()
				if Is_String_Empty(BIN_TYPE) then
					BIN_TYPE = ""
					return false
				else
					return true
				end
		else
			return true
		end	
	end
end

function Get_Bin_Version()
	---
	if IS_BTMINER then
		--->
		BIN_VERSION = luci.util.execi("cat /tmp/eeprom/bin_version  2> /dev/null")()
		if Is_String_Empty(BIN_VERSION) then
			--->
			BIN_VERSION = luci.util.execi("uci get /tmp/eeprom.common.bin_version  2> /dev/null")()
				if Is_String_Empty(BIN_VERSION) then
					BIN_VERSION = ""
					return false
				else
					return true
				end
		else
			return true
		end
	else
		--->
		BIN_VERSION = luci.util.execi("uci get /tmp/eeprom.common.bin_version  2> /dev/null")()
		if Is_String_Empty(BIN_VERSION) then
			--->
			BIN_VERSION = luci.util.execi("cat /tmp/eeprom/bin_version  2> /dev/null")()
				if Is_String_Empty(BIN_VERSION) then
					BIN_VERSION = ""
					return false
				else
					return true
				end
		else
			return true
		end
	end
end

function Get_Bin_Leak_Current()
	---
	if IS_BTMINER then
		--->
		BIN_LEAK = luci.util.execi("cat /tmp/eeprom/leak_current  2> /dev/null")()
		if Is_String_Empty(BIN_LEAK) then
			--->
			BIN_LEAK = luci.util.execi("uci get /tmp/eeprom.common.leak_current  2> /dev/null")()
				if Is_String_Empty(BIN_LEAK) then
					BIN_LEAK = ""
					return false
				else
					return true
				end
		else
			return true
		end
	else
		--->
		BIN_LEAK = luci.util.execi("uci get /tmp/eeprom.common.leak_current  2> /dev/null")()
		if Is_String_Empty(BIN_LEAK) then
			--->
			BIN_LEAK = luci.util.execi("uci get /tmp/eeprom.common.leak_current  2> /dev/null")()
				if Is_String_Empty(BIN_LEAK) then
					BIN_LEAK = ""
					return false
				else
					return true
				end
		else
			return true
		end
	end
end

--==CONST==--->
local OK_BIN_TYPE    = Get_Bin_Type()
local OK_BIN_VERSION = Get_Bin_Version()
local OK_BIN_LEAK    = Get_Bin_Leak_Current()
--------------<

--==ADDLOG==-->
if OK_BIN_TYPE and OK_BIN_VERSION and OK_BIN_LEAK then
	AddToSysLog("detected miner BIN string: bin"..BIN_TYPE.."v"..BIN_VERSION.."_"..BIN_LEAK)
else
	AddToSysLog("detected miner BIN string: UNKNOWN")
end
--------------<

function Set_All_Bin_Strings()
--->
	if OK_BIN_TYPE and OK_BIN_VERSION and OK_BIN_LEAK then
		--main----------------------------------------------------------------->
		BIN_STRING_NO_PREFIX                  = "bin"..BIN_TYPE.."v"..BIN_VERSION.."_"..BIN_LEAK
		--reserve-------------------------------------------------------------->
		BIN_STRING_RES1_NO_PREFIX             = "bin"..BIN_TYPE.."v1_"..BIN_LEAK
		BIN_STRING_RES2_NO_PREFIX             = "bin"..BIN_TYPE.."v1_A"
		--short---------------------------------------------------------------->
		SHORT_BIN_STRING_NO_PREFIX            = "bin"..BIN_TYPE
		
		---
		if Is_String_Empty(POWER_MODE_PREFIX) then
			--main------------------------------------------------------>
			BIN_STRING_WITH_PREFIX            = BIN_STRING_NO_PREFIX
			--reserve--------------------------------------------------->
			BIN_STRING_RES1_WITH_PREFIX       = BIN_STRING_RES1_NO_PREFIX
			BIN_STRING_RES2_WITH_PREFIX       = BIN_STRING_RES2_NO_PREFIX
			--short----------------------------------------------------->
			SHORT_BIN_STRING_WITH_PREFIX      = SHORT_BIN_STRING_NO_PREFIX
		else
			--main------------------------------------------------------>
			BIN_STRING_WITH_PREFIX            = POWER_MODE_PREFIX .. BIN_STRING_NO_PREFIX
			--reserve--------------------------------------------------->
			BIN_STRING_RES1_WITH_PREFIX       = POWER_MODE_PREFIX .. BIN_STRING_RES1_NO_PREFIX
			BIN_STRING_RES2_WITH_PREFIX       = POWER_MODE_PREFIX .. BIN_STRING_RES2_NO_PREFIX
			--short----------------------------------------------------->
			SHORT_BIN_STRING_WITH_PREFIX      = POWER_MODE_PREFIX .. SHORT_BIN_STRING_NO_PREFIX
		end
	--->
		return true
	else
		return false
	end
end

--==CONST==--->
local OK_ALL_BIN_STRINGS = Set_All_Bin_Strings()
--------------<

function Get_Current_Powers_Config_Str(cfg_ver)
	---
	if OK_POWERS_CONFIG_FILENAME and OK_POWERS_CONFIGURATION_NAME and OK_ALL_BIN_STRINGS then
		if POWER_MODE == "1" then
		--->
			POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
			if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
			--->
				POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES1_NO_PREFIX.."  2> /dev/null")() 
				if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
					--->
					POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES2_NO_PREFIX.."  2> /dev/null")() 
					if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
					--->
						POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..SHORT_BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
						if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
							--->
							if cfg_ver == "2" then
								POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0"
							else
								POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0 0 0"
							end
							
							CURRENT_POWERS_BIN_STRING   = "UNKNOWN"
							NEED_DEFAULT_POWERS_CONFIG  = true
							return false
						else
							CURRENT_POWERS_BIN_STRING = SHORT_BIN_STRING_NO_PREFIX
							return true
						end
					else
						--->
						if luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES1_NO_PREFIX.." \""..POWERS_CONFIGURATION_STRING.."\"  2> /dev/null && echo 1 || echo 0")() ~= "0" then
							CURRENT_POWERS_BIN_STRING = BIN_STRING_RES1_NO_PREFIX
							return true
						else
							CURRENT_POWERS_BIN_STRING = BIN_STRING_RES2_NO_PREFIX
							return true
						end
						---<
					end
				else
					CURRENT_POWERS_BIN_STRING = BIN_STRING_RES1_NO_PREFIX
					return true
				end
			else
				CURRENT_POWERS_BIN_STRING = BIN_STRING_NO_PREFIX
				return true
			end
		end
		
		--============================================================================================================================================--
		if POWER_MODE ~= "1" then
		--->
			POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_WITH_PREFIX.."  2> /dev/null")() 
			if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
			--->
				POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES1_WITH_PREFIX.."  2> /dev/null")() 
				if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
					--->
					POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES2_WITH_PREFIX.."  2> /dev/null")() 
					if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
					--->
						POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..SHORT_BIN_STRING_WITH_PREFIX.."  2> /dev/null")() 
						if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
						--->	
							POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
							if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
							--->
								POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES1_NO_PREFIX.."  2> /dev/null")() 
								if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
								--->
									POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES2_NO_PREFIX.."  2> /dev/null")() 
									if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
									--->
										POWERS_CONFIGURATION_STRING = luci.util.execi("ini get "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..SHORT_BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
										if Is_String_Ini_Usage_Error(POWERS_CONFIGURATION_STRING) then
										--->
											if cfg_ver == "1" then
												POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0 0 0"
											else
												POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0"
											end
											
											CURRENT_POWERS_BIN_STRING   = "UNKNOWN"
											NEED_DEFAULT_POWERS_CONFIG  = true
											return false
										else
											CURRENT_POWERS_BIN_STRING = SHORT_BIN_STRING_NO_PREFIX
											return true
										end
									else
										CURRENT_POWERS_BIN_STRING = BIN_STRING_RES2_NO_PREFIX
										return true
									end
								else
									CURRENT_POWERS_BIN_STRING = BIN_STRING_RES1_NO_PREFIX
									return true
								end
							else
								CURRENT_POWERS_BIN_STRING = BIN_STRING_NO_PREFIX
								return true
							end
						else
							CURRENT_POWERS_BIN_STRING = SHORT_BIN_STRING_WITH_PREFIX
							return true
						end
					else
						CURRENT_POWERS_BIN_STRING = BIN_STRING_RES2_WITH_PREFIX
						return true
					end
				else
					CURRENT_POWERS_BIN_STRING = BIN_STRING_RES1_WITH_PREFIX
					return true
				end
			else
				CURRENT_POWERS_BIN_STRING = BIN_STRING_WITH_PREFIX
				return true
			end
		end
	else
		if cfg_ver == "2" then
			POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0"
		else
			POWERS_CONFIGURATION_STRING = "0 0 0 0 0 0 0 0"
		end
		
		CURRENT_POWERS_BIN_STRING   = "UNKNOWN"
		NEED_DEFAULT_POWERS_CONFIG  = true
		return false
	end
end

--==CONST==--->
local OK_POWERS_CONFIGURATION_STRING = Get_Current_Powers_Config_Str(POWERS_CONFIG_VERSION)
--------------<

--==ADDLOG==-->
if OK_POWERS_CONFIGURATION_NAME and not Is_String_Empty(POWERS_CONFIGURATION_STRING) and not Is_String_Empty(CURRENT_POWERS_BIN_STRING) then
	AddToSysLog("dected config \""..POWERS_CONFIGURATION_NAME.."\" = \""..POWERS_CONFIGURATION_STRING.."\" for "..CURRENT_POWERS_BIN_STRING)
end
--------------<

-----------LIQUID-MODE-POWER-FAN--------------

function Check_Miner_Cooling_Mode()
	local is_file_mrk = false
	local is_uci_mrk  = false
	local liquid_cfg  = ""
	----------------->
	if Is_Regular_File_Exists("/etc/config/liquid_cooling") then
		is_file_mrk = true
	else
		is_file_mrk = false
	end
	----------------->
	if IS_BTMINER then
		liquid_cfg = luci.util.execi("uci get btminer.default.liquid_cooling  2> /dev/null")()
		--->
			if Is_String_Empty(liquid_cfg) then
				is_uci_mrk = false
			else
				--->	
				if liquid_cfg == "1" then
					is_uci_mrk = true
				else
					is_uci_mrk = false
				end
			end
	else 
		liquid_cfg = luci.util.execi("uci get cgminer.default.liquid_cooling  2> /dev/null")()
		--->	
			if Is_String_Empty(liquid_cfg) then
				is_uci_mrk = false
			else
				--->
				if liquid_cfg == "1" then
					is_uci_mrk = true
				else
					is_uci_mrk = false
				end
			end
	end
	----------------->
	if is_file_mrk and is_uci_mrk then
		AddToSysLog("detected liquid cooling now is switched ON.")
		return true
	else
		AddToSysLog("detected liquid cooling now is switched OFF.")
		return false
	end
end

function Check_Power_Fan_Enabled()
	local int_powerfan_on = true
	local int_is_set      = false
	local cfg_powerfan_on = true
	local cfg_is_set      = false
	local powerfan_str   = ""
	
	--check-power-fan-interface-->
	if Is_Readable_File_Exists("/sys/bitmicro/power/fan_enable") then
		powerfan_str = luci.util.execi("cat /sys/bitmicro/power/fan_enable  2> /dev/null")()
		if not Is_String_Empty(powerfan_str) then
			if powerfan_str == "0" then
				int_powerfan_on = false
			else
				int_powerfan_on = true
			end
			int_is_set = true
		end
	end
		
	--check-power-fan-in-power_cfg-->
	if Is_Readable_File_Exists("/data/power_cfg") then
		powerfan_str = luci.util.execi("ini get /data/power_cfg common power_fan_enable  2> /dev/null")()
		if not Is_String_Empty(powerfan_str) then
			if powerfan_str == "0" then
				cfg_powerfan_on = false
			else
				cfg_powerfan_on = true
			end
		end
		cfg_is_set = true
	end
		
	--write-to-log-->
	if int_is_set then
		AddToSysLog("detected /sys/bitmicro/power/fan_enable power interface and power fan now is enabled= "..tostring(int_powerfan_on))
		return int_powerfan_on
	else
		if cfg_is_set then
			AddToSysLog("detected /sys/bitmicro/power/fan_enable interface NOT found. Parsed config file /data/power_cfg and power fan now is enabled= "..tostring(cfg_powerfan_on))
			return cfg_powerfan_on
		else
			AddToSysLog("detected /sys/bitmicro/power/fan_enable interface NOT found. Config file /data/power_cfg NOT found. PSU fan seems to be ON!")
			return true
		end
	end
	
end

function Set_Liquid_Cooling_On()
	local liquid_cfg  = ""
	local is_file_mrk = false
	local is_uci_mrk  = false
	local fan_enabled = true
	---
	local hbsn0       = ""
	local hbsn1       = ""
	local hbsn2       = ""
	------------------------>
	luci.util.execi("touch /etc/config/liquid_cooling")()
	if Is_Regular_File_Exists("/etc/config/liquid_cooling") then
		is_file_mrk = true
	else
		is_file_mrk = false
	end
	------------------------>
	if IS_BTMINER then
		luci.util.execi("uci set btminer.default.liquid_cooling=1")()
		luci.util.execi("uci commit btminer.default")()
		liquid_cfg = luci.util.execi("uci get btminer.default.liquid_cooling  2> /dev/null")()
		if liquid_cfg == "1" then
			is_uci_mrk = true
		else
			is_uci_mrk = false
		end
	else
		luci.util.execi("uci set cgminer.default.liquid_cooling=1")()
		luci.util.execi("uci commit cgminer.default")()
		liquid_cfg = luci.util.execi("uci get cgminer.default.liquid_cooling  2> /dev/null")()
		--->
		if liquid_cfg == "1" then
			is_uci_mrk = true
		else
			is_uci_mrk = false
		end
	end
	------------------------>
	if Is_Regular_File_Exists("/data/user_cfg") then
		--->
		hbsn0 = GetHashboardSerial("0")
		if (not Is_String_Empty(hbsn0)) and (not Is_String_Unknown(hbsn0)) then
			luci.util.execi("ini set /data/user_cfg pcb sn0 "..hbsn0.."  2> /dev/null")()
		end
		--->
		hbsn1 = GetHashboardSerial("1")
		if (not Is_String_Empty(hbsn1)) and (not Is_String_Unknown(hbsn1)) then
			luci.util.execi("ini set /data/user_cfg pcb sn1 "..hbsn1.."  2> /dev/null")()
		end
		--->
		hbsn2 = GetHashboardSerial("2")
		if (not Is_String_Empty(hbsn2)) and (not Is_String_Unknown(hbsn2)) then
			luci.util.execi("ini set /data/user_cfg pcb sn2 "..hbsn2.."  2> /dev/null")()
		end
	end
	
	if is_file_mrk and is_uci_mrk then
		return true
	else
		return false
	end
end

function Set_Liquid_Cooling_Off()
	local liquid_cfg  = ""
	local is_file_mrk = false
	local is_uci_mrk  = false
	
	------------------------>
	luci.util.execi("rm -rf /etc/config/liquid_cooling")()
	if Is_Regular_File_Exists("/etc/config/liquid_cooling") then
		is_file_mrk = true
	else
		is_file_mrk = false
	end
	
	------------------------>
	if IS_BTMINER then
		luci.util.execi("uci del btminer.default.liquid_cooling")()
		luci.util.execi("uci commit btminer.default")()
		liquid_cfg = luci.util.execi("uci get btminer.default.liquid_cooling  2> /dev/null")()
		if liquid_cfg == "1" then
			is_uci_mrk = true
		else
			is_uci_mrk = false
		end
	else
		luci.util.execi("uci del cgminer.default.liquid_cooling")()
		luci.util.execi("uci commit cgminer.default")()
		liquid_cfg = luci.util.execi("uci get cgminer.default.liquid_cooling  2> /dev/null")()
		--->
		if liquid_cfg == "1" then
			is_uci_mrk = true
		else
			is_uci_mrk = false
		end
	end
	
	if not is_file_mrk and not is_uci_mrk then
		return true
	else
		return false
	end
end

function Set_Power_Fan_Enabled()
	--->
	if Is_Readable_File_Exists("/sys/bitmicro/power/fan_enable") then
		luci.util.execi("echo 1 > /sys/bitmicro/power/fan_enable")()
	end
	--->
	if Is_Readable_File_Exists("/data/power_cfg") then
		luci.util.execi("ini set /data/power_cfg common power_fan_enable 1")()
	end
	--->
	if Is_Readable_File_Exists("/data/user_cfg") then
		luci.util.execi("ini set /data/user_cfg power power_fan_enable 1")()
	end
end

function Set_Power_Fan_Disabled()
	local psu_serial = ""
	--->
		if Is_Readable_File_Exists("/sys/bitmicro/power/fan_enable") then
			luci.util.execi("echo 0 > /sys/bitmicro/power/fan_enable")()
		end
		--->
		if Is_Readable_File_Exists("/data/power_cfg") then
			luci.util.execi("ini set /data/power_cfg common power_fan_enable 0")()
		else
			psu_serial = luci.util.execi("cat /sys/bitmicro/power/serial_no  2> /dev/null")()
			--->
			luci.util.execi("echo \"[common]\" > /data/power_cfg")()
			if not Is_String_Empty(psu_serial) then
				luci.util.execi("ini set /data/power_cfg common power_serial_no "..psu_serial)()
			end
			luci.util.execi("ini set /data/power_cfg common power_fan_enable 0")()
			luci.util.execi("chmod 664 /data/power_cfg")()
		end
		--->
		if Is_Readable_File_Exists("/data/user_cfg") then
			luci.util.execi("ini set /data/user_cfg power power_fan_enable 0")()
			psu_serial = luci.util.execi("cat /sys/bitmicro/power/serial_no  2> /dev/null")()
			if not Is_String_Empty(psu_serial) then
				luci.util.execi("ini set /data/user_cfg power power_serial_no "..psu_serial)()
			end
		end
	---<	
end

--==CONST==--->
IS_LIQUID           = Check_Miner_Cooling_Mode()
IS_POWERFAN_ENABLED = Check_Power_Fan_Enabled()
--------------<

function Download_Default_Powers_Config(download_needed)
	local miner_cfg_url    = ""
	local powers_cfg_url   = ""
	---
	local is_exists_miner_cfg  = false
	local miner_def_cfg_fn     = ""
	local miner_def_cfg_path   = ""
	---
	local is_exists_powers_cfg = false
	local powers_def_cfg_fn    = ""
	local powers_def_cfg_path  = ""
	--->
	
	if download_needed and Is_String_Common(MINER_FULL_MODEL_LOWERCASE) and not Is_String_Unknown(OVERVIEW_FULL_MODEL_LOWERCASE) then
	--->
		powers_def_cfg_fn   = "powers.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
		powers_def_cfg_path = POWERS_DEFAULT_PATH .."powers.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
		powers_cfg_url      = LIC_SERVER_DEF_CONFIGS_DIR..powers_def_cfg_fn
		--->
		if IS_BTMINER then
			miner_def_cfg_fn   = "btminer.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
			miner_def_cfg_path = POWERS_DEFAULT_PATH .."btminer.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
			miner_cfg_url      = LIC_SERVER_DEF_CONFIGS_DIR .. miner_def_cfg_fn
		else
			miner_def_cfg_fn   = "cgminer.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
			miner_def_cfg_path = POWERS_DEFAULT_PATH .."cgminer.default.".. OVERVIEW_FULL_MODEL_LOWERCASE
			miner_cfg_url      = LIC_SERVER_DEF_CONFIGS_DIR .. miner_def_cfg_fn
		end
		
		---
		if not Is_Regular_File_Exists(powers_def_cfg_path) and not Is_Symbolic_Link_Exists(powers_def_cfg_path) then
			AddToSysLog("will try to download powers default config: ".. powers_def_cfg_fn)
			is_exists_powers_cfg = Download_File(powers_cfg_url,POWERS_DEFAULT_PATH_NO_SLASH,powers_def_cfg_fn,"664")
			--->
			if is_exists_powers_cfg then
				AddToSysLog("powers default config file successfully downloaded and stored: ".. powers_def_cfg_path)
			else 
				AddToSysLog("powers default config file download failed!")
			end
		else
			is_exists_powers_cfg = true
		end
		
		---
		if not Is_Regular_File_Exists(miner_def_cfg_path) and not Is_Symbolic_Link_Exists(miner_def_cfg_path) then
			AddToSysLog("will try to download miner default config: ".. miner_def_cfg_fn)
			is_exists_miner_cfg = Download_File(miner_cfg_url,POWERS_DEFAULT_PATH_NO_SLASH,miner_def_cfg_fn,"664")
			--->
			if is_exists_miner_cfg then
				AddToSysLog("miner default config file successfully downloaded and stored: ".. miner_def_cfg_path)
			else
				AddToSysLog("miner default config file download failed!")
			end
		else
			is_exists_miner_cfg = true
		end
		
		------>
		if is_exists_miner_cfg and is_exists_powers_cfg then
			return true
		else
			return false
		end
		-------<
	else
		return false
	end
end

--==CONST==--->
IS_DEFAULT_CONFIG_DOWNLOADED = Download_Default_Powers_Config(NEED_DEFAULT_POWERS_CONFIG)
--------------<


function Set_Current_Powers_Config_Str(powers_cfg_string)
--->
	if not Is_String_Empty(CURRENT_POWERS_BIN_STRING) and not Is_String_Unknown(CURRENT_POWERS_BIN_STRING) and OK_POWERS_CONFIG_FILENAME and OK_POWERS_CONFIGURATION_NAME then
		return luci.util.execi("ini set "..POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..CURRENT_POWERS_BIN_STRING.." \""..powers_cfg_string.."\"  2> /dev/null && echo 1 || echo 0")() ~= "0"
	else
		return false
	end
end

function Get_Powers_Config_Array(pwcfg_str,cfg_ver)
	---
	local cfg_array = {
		version = "",
		freq_target = "",
		hash_target = "",
		voltage_target = "",
		voltage_limit = "",
		chip_temp_target = "",
		board_temp_target = "",
		ok_cores_pct = "",
		power_min = "",
		power_rate = ""
	}
	
	if not Is_String_Empty(pwcfg_str) then
	--->	
		cfg_array.version = cfg_ver
	--->
		if cfg_ver == "2" then
			cfg_array.hash_target       = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 1 -d \" \"  2> /dev/null")()
			cfg_array.voltage_target    = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 2 -d \" \"  2> /dev/null")()
			cfg_array.board_temp_target = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 3 -d \" \"  2> /dev/null")()
			cfg_array.ok_cores_pct      = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 4 -d \" \"  2> /dev/null")()
			cfg_array.power_min         = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 5 -d \" \"  2> /dev/null")()
			cfg_array.power_rate        = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 6 -d \" \"  2> /dev/null")()
		else
			cfg_array.freq_target       = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 1 -d \" \"  2> /dev/null")()
			cfg_array.voltage_target    = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 2 -d \" \"  2> /dev/null")()
			cfg_array.voltage_limit     = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 3 -d \" \"  2> /dev/null")()
			cfg_array.chip_temp_target  = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 4 -d \" \"  2> /dev/null")()
			cfg_array.board_temp_target = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 5 -d \" \"  2> /dev/null")()
			cfg_array.ok_cores_pct      = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 6 -d \" \"  2> /dev/null")()
			cfg_array.power_min         = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 7 -d \" \"  2> /dev/null")()
			cfg_array.power_rate        = luci.util.execi("echo \""..pwcfg_str.."\" | cut -f 8 -d \" \"  2> /dev/null")()
		end
	--->
		return cfg_array
	end
end

--==CONST==--->
POWERS_CONFIGURATION_ARRAY = Get_Powers_Config_Array(POWERS_CONFIGURATION_STRING,POWERS_CONFIG_VERSION)
--------------<

function Get_Default_Config_String(cfg_ver)
	local def_powers_str = ""
	---
	if OK_ALL_BIN_STRINGS and OK_POWERS_CONFIGURATION_NAME then
	--->
		def_powers_str = luci.util.execi("ini get "..DEFAULT_POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
			if Is_String_Ini_Usage_Error(def_powers_str) then
			--->
				def_powers_str = luci.util.execi("ini get "..DEFAULT_POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES1_NO_PREFIX.."  2> /dev/null")() 
				if Is_String_Ini_Usage_Error(def_powers_str) then
					--->
					def_powers_str = luci.util.execi("ini get "..DEFAULT_POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..BIN_STRING_RES2_NO_PREFIX.."  2> /dev/null")() 
					if Is_String_Ini_Usage_Error(def_powers_str) then
					--->
						def_powers_str = luci.util.execi("ini get "..DEFAULT_POWERS_CONFIG_FULLPATH.." "..POWERS_CONFIGURATION_NAME.." "..SHORT_BIN_STRING_NO_PREFIX.."  2> /dev/null")() 
						if Is_String_Ini_Usage_Error(def_powers_str) then
							--->
							if cfg_ver == "2" then
								def_powers_str = "0 0 0 0 0 0"
								return def_powers_str
							else
								def_powers_str = "0 0 0 0 0 0 0 0"
								return def_powers_str
							end
						else
							return def_powers_str
						end
					else
						return def_powers_str
					end
				else
					return def_powers_str
				end
			else
				return def_powers_str
			end
	else
		if cfg_ver == "2" then
			def_powers_str = "0 0 0 0 0 0"
			return def_powers_str
		else
			def_powers_str = "0 0 0 0 0 0 0 0"
			return def_powers_str
		end
	end
end

--==CONST==--->
DEFAULT_CONFIGURATION_STRING       = Get_Default_Config_String(POWERS_CONFIG_VERSION)
DEFAULT_POWERS_CONFIGURATION_ARRAY = Get_Powers_Config_Array(DEFAULT_CONFIGURATION_STRING,POWERS_CONFIG_VERSION)
--------------<

function Get_Powers_String_From_Configuration_Array(config_array)
	local cfg_str = ""
--->	
	if config_array.version == "2" then
		cfg_str = config_array.hash_target.." "..config_array.voltage_target.." "..config_array.board_temp_target.." "..config_array.ok_cores_pct.." "..config_array.power_min.." "..config_array.power_rate
		return cfg_str
	else
		cfg_str = config_array.freq_target.." "..config_array.voltage_target.." "..config_array.voltage_limit.." "..config_array.chip_temp_target.." "..config_array.board_temp_target.." "..config_array.ok_cores_pct.." "..config_array.power_min.." "..config_array.power_rate
		return cfg_str
	end

end

function Get_Max_OC_Powers_TargetFreq(max_oc_percent,cfg_ver)
	local max_freq = 0
	local up_delta = 0
	local target_freq = ""
	local target_freq_num = 0
	---
	if cfg_ver == "2" then
		target_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.hash_target
	else
		target_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.freq_target
	end
	---
	if target_freq ~= nil and target_freq ~= "" then
		if target_freq ~= "0" then
			target_freq_num = tonumber(target_freq)
			if target_freq_num ~= nil then
				up_delta = target_freq_num * max_oc_percent
				up_delta = up_delta / 100
				up_delta = math.floor(up_delta)
				max_freq = target_freq_num + up_delta
			else
				max_freq = 0
			end
		else
			max_freq = 0
		end	
	end
	
	return tostring(max_freq)
end

function Get_Min_DV_Powers_TargetFreq(max_dv_percent,cfg_ver)
	local down_delta = 0
	local min_freq = 0
	local target_freq = ""
	local target_freq_num = 0
	---
	if cfg_ver == "2" then
		target_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.hash_target
	else
		target_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.freq_target
	end
	---
	if target_freq ~= nil and target_freq ~= "" then
		if target_freq ~= "0" then
			target_freq_num = tonumber(target_freq)
			if target_freq_num ~= nil then
				down_delta = target_freq_num * max_dv_percent
				down_delta = down_delta / 100
				down_delta = math.floor(down_delta)
				min_freq = target_freq_num - down_delta
			else 
				min_freq = 0
			end
		else
			min_freq = 0
		end	
	end
	
	return tostring(min_freq)
end

--==CONST==--->
MAX_OC_TARGET_FREQ = Get_Max_OC_Powers_TargetFreq(30,POWERS_CONFIG_VERSION)
MIN_DV_TARGET_FREQ = Get_Min_DV_Powers_TargetFreq(40,POWERS_CONFIG_VERSION)
--------------<

--==GET_CURRENT_STATE==-->
CURRENT_MINER_SUMMARY_JSON = Send_Miner_Api_Json_Command(MINER_BINARY_FILENAME,"summary")
CURRENT_MINER_DEVS_JSON    = Send_Miner_Api_Json_Command(MINER_BINARY_FILENAME,"devs")
-------------------------<

--==PROFILES==-->
IS_PROFILES_FILE_EXISTS = Create_Profiles_File_New(PROFILES_FILE_PATH)
----------------<


function Get_Powers_Increase_Margin(cfg_ver)
--->		
	local def_freq = ""
	local def_freq_num = 0
	local trg_freq = ""
	local trg_freq_num = 0
	---
	if cfg_ver == "2" then
		def_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.hash_target
		def_freq_num = tonumber(def_freq)
		trg_freq = POWERS_CONFIGURATION_ARRAY.hash_target
		trg_freq_num = tonumber(trg_freq)
	else
		def_freq = DEFAULT_POWERS_CONFIGURATION_ARRAY.freq_target
		def_freq_num = tonumber(def_freq)
		trg_freq = POWERS_CONFIGURATION_ARRAY.freq_target
		trg_freq_num = tonumber(trg_freq)
	end
	---
	if def_freq_num ~= nil and trg_freq_num ~= nil then
		if trg_freq_num >= def_freq_num then
			FREQ_DIFF_DELTA = trg_freq_num - def_freq_num
			FREQ_DIFF_DELTA = FREQ_DIFF_DELTA * 100
			FREQ_DIFF_DELTA = math.floor(FREQ_DIFF_DELTA / def_freq_num)
			FREQ_DIFF_DELTA = FREQ_DIFF_DELTA + 1
			POWERS_INCREASE = tostring(FREQ_DIFF_DELTA)
			return true
		else
			FREQ_DIFF_DELTA = def_freq_num - trg_freq_num
			FREQ_DIFF_DELTA = FREQ_DIFF_DELTA * 100
			FREQ_DIFF_DELTA = math.floor(FREQ_DIFF_DELTA / def_freq_num)
			FREQ_DIFF_DELTA = FREQ_DIFF_DELTA + 1
			POWERS_INCREASE = "-"..tostring(FREQ_DIFF_DELTA)
			return true
		end
	else
		return false
	end	
end

--====================================--
--==============FORM=================--
--====================================--

----------------------------------------------------------------------------Start-form-description-----------------------------------------------------------------------------------

m = SimpleForm("overclock", translate("WMOC Overclock Lite v_1.4"),translate("<a href=\"https://t.me/whatsmineroc\"><img src=\"/luci-static/resources/cbi/wmoc_logo.svg\" height=\"85px\"></a><br/><div class=\"cbi-value-description\">Please stay updated with our latest news and get support for any issues in our Telegram Community: <a href=\"https://t.me/WMOC_Official\" target=\"_blank\"><img src=\"/luci-static/resources/cbi/telegram.svg\" height=\"18px\"></a> <a href=\"https://t.me/WMOC_Official\" target=\"_blank\">WMOC Official</a></div><br>"))
m.submit = false
m.reset  = false

mysection = m:section(SimpleSection)

--======================--
--->AUTO-UPDATE-BOTTON<---
--======================--

update_button = mysection:option(Button, "_update_button", translate("Module Update Action :"), translate("Use this button to check for updates of the module and install a new version of the module if it is found<div style=\"margin-top: 10px;\"> </div>"))
update_button.inputtitle = translate("Check for updates")
update_button.inputstyle = "find"
update_button.write = function(self, section)
	local down1 = false
	local extr1 = false
	local update_res = ""
	
	luci.util.execi("rm -rf ".. TMP_SHM_DEFAULT_PATH .."".. OLD_UPDATE_MODULE_NAME .."  2> /dev/null")()
	down1 = Download_File(OLD_UPDATE_SH_URL,TMP_SHM_DEFAULT_PATH_NO_SLASH,OLD_UPDATE_MODULE_NAME,"664")
	
	if down1 then
		extr1 = Extract_Downloaded_Script(TMP_SHM_DEFAULT_PATH_NO_SLASH,OLD_UPDATE_MODULE_NAME,OLD_UPDATE_SH_NAME,OLD_UPDATE_SH_MD5)
		
		if extr1 then
			update_res = luci.util.execi("sh ".. TMP_SHM_DEFAULT_PATH .."".. OLD_UPDATE_SH_NAME ..".sh ".. WMOC_PRODUCT_NAME)()
			luci.util.execi("rm -rf ".. TMP_SHM_DEFAULT_PATH .."".. OLD_UPDATE_SH_NAME ..".sh   2> /dev/null")()
						
			if Is_String_Starts(update_res,"[+]") then
				if OK_PSU_CONFIG_FILENAME and OK_PSU_CONFIG_FILENAME_PREFIX and OK_PSU_CONFIG_FILENAME_SUFFIX then
					if Is_Regular_File_Exists(PSU_DEFAULT_CONFIG_PATH..PSU_CONFIG_FILENAME_PREFIX.."_"..INSTALLED_PSU_VENDER) then
						luci.util.execi("rm -rf "..PSU_DEFAULT_CONFIG_PATH..PSU_CONFIG_FILENAME_PREFIX.."_"..INSTALLED_PSU_VENDER.."   2> /dev/null")()
					end
				end
				m.message = "<pre>"..update_res.." The \"Overclock\" page will be refreshed now.</pre>"
				
				luci.http.redirect(luci.dispatcher.build_url("admin/network/overclock"))
			else
				m.message = "<pre>"..update_res.." Please contact support.</pre>"
			end
		else
			m.message = "<pre>[-] Error: script extraction failed!</pre>"
		end
	else
		m.message = "<pre>[-] Error: update script download failed!</pre>"
	end
end


--======================--
--->GEN-AUTO-PROFILES<----
--======================--

generate_button = mysection:option(Button, "_generate_button", translate("AGP Presets Action :"))
generate_button.inputtitle = translate("Generate / Update AGP")
generate_button.inputstyle = "reload"
generate_button.write = function(self, section)

	local p1 = POWERS_CONFIG_VERSION
	local p2 = liquid_m:formvalue(section) or "0"
	local p3 = powerfanclose_m:formvalue(section) or "0"
	local p6 = targ_vol:formvalue(section)
	local p7 = lowlimit_vol:formvalue(section)
	local p8 = uplimit_vol:formvalue(section)
	local p9 = temp_board:formvalue(section)
	
	local generate_res, generate_err = Auto_Generate_Profiles(PROFILES_FILE_CONTENT, PROFILES_FILE_PATH, CURRENT_MINER_SUMMARY_JSON, CURRENT_MINER_DEVS_JSON, MINER_TYPE_LOWERCASE, p1, p2, p3, p6, p7, p8, p9, PSU_CONFIG_ARRAY.p_max)
	if generate_res then
		luci.http.redirect(luci.dispatcher.build_url("admin/network/overclock"))
	else
		m.message = "<pre>[-] Error: "..generate_err.."</pre>"
	end
end
--<---------------------




--======================--
---->LIST-OF-PROFILES<----
--======================--

PROFILES_FILE_CONTENT = Read_Whole_File(PROFILES_FILE_PATH)
if PROFILES_FILE_CONTENT ~= nil and not Is_String_Empty(PROFILES_FILE_CONTENT) then
	PROFILES_NUM = Enumerate_Json_Profiles_New(PROFILES_FILE_CONTENT)
	PROFILE_NAMES_ARRAY = Get_Profile_Names_New(PROFILES_FILE_CONTENT)
end
---
profiles_m = mysection:option(ListValue, "profiles_list", translate("Load Saved / AGP Preset : "), translate("Use this drop-down list to load form values from available saved presets"))

if PROFILE_NAMES_ARRAY ~= nil and PROFILES_NUM > 0 then
	profiles_m:value("0", "Please select the preset")
	for i, name in ipairs(PROFILE_NAMES_ARRAY) do
		profiles_m:value(tostring(i), name)
	end
else
	profiles_m:value("0", "No saved profiles found")
end
profiles_m.rmempty = false


--<---------------------




--======================--
--+-->LIQUID_COOLING<--+--
--======================--

liquid_m = mysection:option(Flag, "liquid_cooling", translate("Liquid Cooling Switch :"), translate("Use this option for immersion cooling or water block cooling (need device reboot to accept)"))
liquid_m.default = "0"
liquid_m.rmempty = false
---
function liquid_m.cfgvalue(...)
	if IS_LIQUID then
		return "1"
	else
		return "0"
	end
end
---
function liquid_m.write(self, section, val)
	---
	if val == "1" then
		FORM_PARSED_CONFIG.is_set_liquid_switch = true
		FORM_PARSED_CONFIG.liquid_switch = "1"
	end
	---
	if val == "0" then
		FORM_PARSED_CONFIG.is_set_liquid_switch = true
		FORM_PARSED_CONFIG.liquid_switch = "0"
	end
	---
    return true
end
--<---------------------




--======================--
---->POWER-FAN-CLOSE<--+--
--======================--

powerfanclose_m = mysection:option(Flag, "close_powerfan", translate("Close Power Fan Switch :"), translate("Use this option with immersion cooling switch to disable PSU built-in fan check (need device reboot to accept)"))
powerfanclose_m.default = "0"
powerfanclose_m.rmempty = false
---
function powerfanclose_m.cfgvalue(...)
	if IS_POWERFAN_ENABLED then
		return "0"
	else
		return "1"
	end
end
---
function powerfanclose_m.write(self, section, val)
	if val == "1" then
		FORM_PARSED_CONFIG.is_set_powerfanclose_switch = true
		FORM_PARSED_CONFIG.powerfanclose_switch = "1"
	end
	---
	if val == "0" then
		FORM_PARSED_CONFIG.is_set_powerfanclose_switch = true
		FORM_PARSED_CONFIG.powerfanclose_switch = "0"
	end
	---
    return true
end
--<---------------------




--======================--
------>TARGET-FREQ<-------
--======================--

if POWERS_CONFIGURATION_ARRAY.version == "2" then
	----HASH-TARGET--->
	targ_hash = mysection:option(Value, "target_hash", translate("Target Board Hashrate :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.hash_target..", Min = "..MIN_DV_TARGET_FREQ..", Max = "..MAX_OC_TARGET_FREQ..", BIN_str = "..CURRENT_POWERS_BIN_STRING..", CFG_str = \""..POWERS_CONFIGURATION_STRING.."\")"))
	targ_hash.datatype = "and(min("..MIN_DV_TARGET_FREQ.."),max("..MAX_OC_TARGET_FREQ.."))"
	targ_hash.placeholder = POWERS_CONFIGURATION_ARRAY.hash_target
	targ_hash._min_value = "0"
	targ_hash._max_value = MAX_OC_TARGET_FREQ
	targ_hash.rmempty = false
	---
	function targ_hash.cfgvalue(...)
		if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.hash_target) then
			return "0"
		else
			return POWERS_CONFIGURATION_ARRAY.hash_target
		end
	end
	---
	function targ_hash.write(self, section, value)
		if not Is_String_Empty(value) then
			FORM_PARSED_CONFIG.is_set_hash_target = true
			FORM_PARSED_CONFIG.hash_target = value
			POWERS_CONFIGURATION_ARRAY.hash_target = value
			return true
		end
	end
	------------------<
else
	----FREQ-TARGET--->
	targ_freq = mysection:option(Value, "target_freq", translate("Target Frequency :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.freq_target..", Min = "..MIN_DV_TARGET_FREQ..", Max = "..MAX_OC_TARGET_FREQ..", BIN_str = "..CURRENT_POWERS_BIN_STRING..", CFG_str = \""..POWERS_CONFIGURATION_STRING.."\")"))
	targ_freq.datatype = "and(min("..MIN_DV_TARGET_FREQ.."),max("..MAX_OC_TARGET_FREQ.."),uinteger)"
	targ_freq.placeholder = POWERS_CONFIGURATION_ARRAY.freq_target
	targ_freq._min_value = "0"
	targ_freq._max_value = MAX_OC_TARGET_FREQ
	targ_freq.rmempty = false
	---
	function targ_freq.cfgvalue(...)
		if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.freq_target) then
			return "0"
		else
			return POWERS_CONFIGURATION_ARRAY.freq_target
		end	
	end
	---
	function targ_freq.write(self, section, value)
		if not Is_String_Empty(value) then
			FORM_PARSED_CONFIG.is_set_freq_target = true
			FORM_PARSED_CONFIG.freq_target = value
			POWERS_CONFIGURATION_ARRAY.freq_target = value
			return true
		end
	end
	------------------<
end





--======================--
----->TARGET-VOLTAGE<-----
--======================--

if not Is_String_Empty(FIXED_PSU_VOLTAGE_LIMIT) and not Is_String_Unknown(FIXED_PSU_VOLTAGE_LIMIT) then
	targ_vol = mysection:option(Value, "target_vol", translate("Voltage Target :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.voltage_target..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..FIXED_PSU_VOLTAGE_LIMIT..")"))
	targ_vol.datatype = "and(min("..DEFAULT_VENDER0_MIN_VOLTAGE.."),max("..FIXED_PSU_VOLTAGE_LIMIT.."),uinteger)"
	targ_vol.placeholder = POWERS_CONFIGURATION_ARRAY.voltage_target
	targ_vol._min_value = DEFAULT_VENDER0_MIN_VOLTAGE
	targ_vol._max_value = FIXED_PSU_VOLTAGE_LIMIT
else
	targ_vol = mysection:option(Value, "target_vol", translate("Voltage Target :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.voltage_target..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..DEFAULT_VENDER0_MAX_VOLTAGE..")"))
	targ_vol.datatype = "and(min("..DEFAULT_VENDER0_MIN_VOLTAGE.."),max("..DEFAULT_VENDER0_MAX_VOLTAGE.."),uinteger)"
	targ_vol.placeholder = POWERS_CONFIGURATION_ARRAY.voltage_target
	targ_vol._min_value = DEFAULT_VENDER0_MIN_VOLTAGE
	targ_vol._max_value = DEFAULT_VENDER0_MAX_VOLTAGE
end
targ_vol.rmempty = false

---
function targ_vol.cfgvalue(...)
	if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.voltage_target) then
		return "0"
	else
		return POWERS_CONFIGURATION_ARRAY.voltage_target
	end
end
---
function targ_vol.write(self, section, value)
	if not Is_String_Empty(value) then
		FORM_PARSED_CONFIG.is_set_voltage_target = true
		FORM_PARSED_CONFIG.voltage_target = value
		POWERS_CONFIGURATION_ARRAY.voltage_target = value
		return true
	end
end
--<-----------------------




--======================--
------>MIN-VOLTAGE------->
--======================--

lowlimit_vol = mysection:option(Value, "min_vol", translate("Lower Voltage Limit :"), translate("(Default = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..DEFAULT_VENDER0_MAX_VOLTAGE..")"))
lowlimit_vol.datatype = "and(min("..DEFAULT_VENDER0_MIN_VOLTAGE.."),max("..DEFAULT_VENDER0_MAX_VOLTAGE.."),uinteger)"
lowlimit_vol.placeholder = ACTUAL_PSU_VOLTAGE_MIN
lowlimit_vol._min_value = "0"
lowlimit_vol._max_value = DEFAULT_VENDER0_MAX_VOLTAGE
lowlimit_vol.rmempty = false
---
function lowlimit_vol.cfgvalue(...)
	if Is_String_Empty(ACTUAL_PSU_VOLTAGE_MIN) or Is_String_Unknown(ACTUAL_PSU_VOLTAGE_MIN) then
		return "0"
	else
		return ACTUAL_PSU_VOLTAGE_MIN
	end
end
---
function lowlimit_vol.validate(self, value, section)
	local tvol = targ_vol:formvalue(section)
	---
	if tonumber(value) <= tonumber(tvol) then
		FORM_PARSED_CONFIG.is_valid_voltage_min = true
		return value
	else
		FORM_PARSED_CONFIG.is_valid_voltage_min = false
		return nil, "\"Lower Voltage Limit\" value is invalid. It should be <= \"Target Voltage\" value!"
	end	
end
---
function lowlimit_vol.write(self, section, value)
	if not Is_String_Empty(value) then
		FORM_PARSED_CONFIG.is_set_voltage_min = true
		FORM_PARSED_CONFIG.voltage_min = value
		ACTUAL_PSU_VOLTAGE_MIN = value
		return true
	end
end
--<-----------------------




--======================--
----->LIMIT_VOLTAGE------>
--======================--

if POWERS_CONFIGURATION_ARRAY.version == "2" then
	--->LIMIT_VOLTAGE_VER2--->
	if not Is_String_Empty(FIXED_PSU_VOLTAGE_LIMIT) and not Is_String_Unknown(FIXED_PSU_VOLTAGE_LIMIT) then
		uplimit_vol = mysection:option(Value, "limit_vol", translate("Upper Voltage Limit :"), translate("(Default = "..DEFAULT_VENDER0_MAX_VOLTAGE..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..FIXED_PSU_VOLTAGE_LIMIT..")"))
	else
		uplimit_vol = mysection:option(Value, "limit_vol", translate("Upper Voltage Limit :"), translate("(Default = "..DEFAULT_VENDER0_MAX_VOLTAGE..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..DEFAULT_VENDER0_MAX_VOLTAGE..")"))
	end
	uplimit_vol.datatype = "and(min("..DEFAULT_VENDER0_MIN_VOLTAGE.."),max(9999),uinteger)"
	uplimit_vol.placeholder = ACTUAL_PSU_VOLTAGE_LIMIT
	uplimit_vol._min_value  = DEFAULT_VENDER0_MIN_VOLTAGE
	uplimit_vol._max_value  = "9999"
	uplimit_vol.rmempty = false
	---
	function uplimit_vol.cfgvalue(...)
		if Is_String_Empty(ACTUAL_PSU_VOLTAGE_LIMIT) or Is_String_Unknown(ACTUAL_PSU_VOLTAGE_LIMIT) then
			return "0"
		else
			return ACTUAL_PSU_VOLTAGE_LIMIT
		end	
	end
	---
	function uplimit_vol.validate(self, value, section)
		local tvol = targ_vol:formvalue(section)
		---
		if tonumber(value) >= tonumber(tvol) then
			FORM_PARSED_CONFIG.is_valid_voltage_limit = true
			return value
		else
			FORM_PARSED_CONFIG.is_valid_voltage_limit = false
			return nil, "\"Lower Voltage Limit\" value is invalid. It should be <= \"Target Voltage\" value!"
		end
	end
	---
	function uplimit_vol.write(self, section, value)
		if not Is_String_Empty(value) then
			FORM_PARSED_CONFIG.is_set_voltage_limit = true
			FORM_PARSED_CONFIG.voltage_limit = value
			ACTUAL_PSU_VOLTAGE_LIMIT = value
			return true
		end
	end
	-------------------------<
else
	--->LIMIT_VOLTAGE_VER1--->
	if not Is_String_Empty(FIXED_PSU_VOLTAGE_LIMIT) and not Is_String_Unknown(FIXED_PSU_VOLTAGE_LIMIT) then
		uplimit_vol = mysection:option(Value, "limit_vol", translate("Upper Voltage Limit :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.voltage_limit..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..FIXED_PSU_VOLTAGE_LIMIT..")"))
	else
		uplimit_vol = mysection:option(Value, "limit_vol", translate("Upper Voltage Limit :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.voltage_limit..", Min = "..DEFAULT_VENDER0_MIN_VOLTAGE..", Max = "..DEFAULT_VENDER0_MAX_VOLTAGE..")"))
	end
	uplimit_vol.datatype = "and(min("..DEFAULT_VENDER0_MIN_VOLTAGE.."),max(9999),uinteger)"
	uplimit_vol.placeholder = POWERS_CONFIGURATION_ARRAY.voltage_limit
	uplimit_vol._min_value  = DEFAULT_VENDER0_MIN_VOLTAGE
	uplimit_vol._max_value  = "9999"
	uplimit_vol.rmempty = false
	---
	function uplimit_vol.cfgvalue(...)
		if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.voltage_limit) then
			return "0"
		else
			return POWERS_CONFIGURATION_ARRAY.voltage_limit
		end	
	end
	---
	function uplimit_vol.validate(self, value, section)
		local tvol = targ_vol:formvalue(section)
		---
		if tonumber(value) >= tonumber(tvol) then
			FORM_PARSED_CONFIG.is_valid_voltage_limit = true
			return value
		else
			FORM_PARSED_CONFIG.is_valid_voltage_limit = false
			return nil, "\"Lower Voltage Limit\" value is invalid. It should be <= \"Target Voltage\" value!"
		end
	end
	---
	function uplimit_vol.write(self, section, value)
		if not Is_String_Empty(value) then
			FORM_PARSED_CONFIG.is_set_voltage_limit = true
			FORM_PARSED_CONFIG.voltage_limit = value
			POWERS_CONFIGURATION_ARRAY.voltage_limit = value
			return true
		end
	end
	-------------------------<
end





--======================--
------->BOARD-TEMP------->
--======================--

temp_board = mysection:option(Value, "board_temp", translate("Target Board Temperature :"), translate("(Default = "..DEFAULT_POWERS_CONFIGURATION_ARRAY.board_temp_target..", Min = 45, Max = 80)"))
temp_board.datatype = "and(min(45),max(80),uinteger)"
temp_board.placeholder = POWERS_CONFIGURATION_ARRAY.board_temp_target
temp_board._min_value  = "0"
temp_board._max_value  = "80"
temp_board.rmempty = false
---
function temp_board.cfgvalue(...)
	if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.board_temp_target) then
		return "0"
	else
		return POWERS_CONFIGURATION_ARRAY.board_temp_target
	end
end
---
function temp_board.write(self, section, value)
	if not Is_String_Empty(value) then
		FORM_PARSED_CONFIG.is_set_board_temp_target = true
		FORM_PARSED_CONFIG.board_temp_target = value
		POWERS_CONFIGURATION_ARRAY.board_temp_target = value
		return true
	end
end
--<-----------------------





--======================--
------->MIN-POWER-------->
--======================--

power_minimum = mysection:option(Value, "min_power", translate("PSU Power Minimum :"), translate("(Default = ".. DEFAULT_POWERS_CONFIGURATION_ARRAY.power_min ..", Min = 0, Max = "..tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-100)..")"))
power_minimum.datatype = "and(min(0),max("..tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-100).."),uinteger)"
power_minimum.placeholder = POWERS_CONFIGURATION_ARRAY.power_min
power_minimum._min_value = "0"
power_minimum._max_value = tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-100)
power_minimum.rmempty = false
---
function power_minimum.cfgvalue(...)
	if Is_String_Empty(POWERS_CONFIGURATION_ARRAY.power_min) then
		return "0"
	else
		return POWERS_CONFIGURATION_ARRAY.power_min
	end
end
---
function power_minimum.write(self, section, value)
	if not Is_String_Empty(value) then
		FORM_PARSED_CONFIG.is_set_power_min = true
		FORM_PARSED_CONFIG.power_min = value
		POWERS_CONFIGURATION_ARRAY.power_min = value
		return true
	end
end
--<-----------------------




--======================--
----->POWER_LIMIT<--------
--======================--

power_uplimit = mysection:option(Value, "power_lim", translate("PSU Power Limit :"), translate("(Default = "..DEFAULT_VENDER0_POWER_LIMIT..", Min = "..MIN_POWER_CONST..", Max = "..tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-50)..", PSU = "..INSTALLED_PSU_NAME..", VENDER = "..INSTALLED_PSU_VENDER..", Iin_limit = ".. FIXED_PSU_IIN_LIMIT ..")"))
power_uplimit.datatype = "and(min("..MIN_POWER_CONST.."),max("..tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-50).."),uinteger)"
power_uplimit.placeholder = ACTUAL_PSU_POWER_LIMIT
power_uplimit._min_value  = MIN_POWER_CONST
power_uplimit._max_value  = tostring(tonumber(PSU_CONFIG_ARRAY.p_max)-50)
power_uplimit.rmempty = false
---
function power_uplimit.cfgvalue(...)
	if Is_String_Empty(ACTUAL_PSU_POWER_LIMIT) or Is_String_Unknown(ACTUAL_PSU_POWER_LIMIT) then
		return "0"
	else
		return ACTUAL_PSU_POWER_LIMIT
	end
	
end
---
function power_uplimit.write(self, section, value)
	if not Is_String_Empty(value) then
		FORM_PARSED_CONFIG.is_set_power_limit = true
		FORM_PARSED_CONFIG.power_limit = value
		ACTUAL_PSU_POWER_LIMIT = value
		return true
	end
end
--<-----------------------




--======================---
------->APPLY_BUTTON<------
--======================---
bstart = mysection:option(Button, "_start", translate("Module Action :"))
bstart.inputtitle = translate("Save & Apply")
bstart.inputstyle = "apply"

bstart.write = function(self, section)
	local LIC_SRV_RESPONSE = ""
	local powers_string_to_set = ""
	
	if FORM_PARSED_CONFIG.is_valid_voltage_min and FORM_PARSED_CONFIG.is_valid_voltage_limit then
		
		--get-server-response--
		LIC_SRV_RESPONSE = Get_Server_Sign_String()
		-----------------------
		
		if LIC_SRV_RESPONSE == MODULE_SIGN_STRING then
		
			--set-parameters-that-can-be-set--
			if FORM_PARSED_CONFIG.is_set_liquid_switch then
				if FORM_PARSED_CONFIG.liquid_switch == "1" then
					Set_Liquid_Cooling_On()
					IS_LIQUID = true
				else
					Set_Liquid_Cooling_Off()
					IS_LIQUID = false
				end
			end
			---
			if FORM_PARSED_CONFIG.is_set_powerfanclose_switch then
				if FORM_PARSED_CONFIG.powerfanclose_switch == "1" then
					Set_Power_Fan_Disabled()
					IS_POWERFAN_ENABLED = false
				else
					Set_Power_Fan_Enabled()
					IS_POWERFAN_ENABLED = true
				end
			end
			--
			if FORM_PARSED_CONFIG.is_set_voltage_min then
				Set_Current_Powers_PSU_Config_Value("voltage_min",ACTUAL_PSU_VOLTAGE_MIN,PSU_CONFIG_ALREADY_FIXED)
			end
			--
			if FORM_PARSED_CONFIG.is_set_voltage_limit and POWERS_CONFIGURATION_ARRAY.version == "2" then
				Set_Current_Powers_PSU_Config_Value("voltage_limit",ACTUAL_PSU_VOLTAGE_LIMIT,PSU_CONFIG_ALREADY_FIXED)
			end
			---
			if FORM_PARSED_CONFIG.is_set_power_limit then
				Set_Current_Powers_PSU_Config_Value("power_limit",ACTUAL_PSU_POWER_LIMIT,PSU_CONFIG_ALREADY_FIXED)
			end
			----------------------------------
		
			--set-power-rate->0--
			if not Is_String_Empty(POWERS_CONFIGURATION_ARRAY.power_rate) then
				POWERS_CONFIGURATION_ARRAY.power_rate = "0"
			end
			---------------------
						
			--get-freq-margin----
			Get_Powers_Increase_Margin(POWERS_CONFIGURATION_ARRAY.version)
			---------------------
		
			--set-current-powers-cfg-string--
			powers_string_to_set = Get_Powers_String_From_Configuration_Array(POWERS_CONFIGURATION_ARRAY)
			Set_Current_Powers_Config_Str(powers_string_to_set)
			AddToSysLog("set new config for "..CURRENT_POWERS_BIN_STRING.." = "..powers_string_to_set..", increase = "..POWERS_INCREASE)
			---------------------------------
		
			--set--keep_power_config-file----
			Set_Keep_Config_File("1",POWERS_INCREASE,PSU_CONFIG_ARRAY.v_limit)
			---------------------------------
			
			--delete-local-cfg-----
			luci.util.execi("rm -rf /data/local_cfg  2> /dev/null")()
			-----------------------
			
			--Restart-and-Redect---
			Miner_Restart()
			Redetect_Miner_Info()
			-----------------------
	
			m.message = "<pre>New config for "..CURRENT_POWERS_BIN_STRING.." = \""..powers_string_to_set.."\" was successfully writed, "..MINER_BINARY_FILENAME.." was restarted!</pre>"
		else
			if LIC_SRV_RESPONSE == "CURL_NOT_FOUND" then
				m.message = "<pre>[--] Curl binary file was not found, please contact support!</pre>"
			else
				m.message = "<pre>[--] Device hardware verification failed, please contact support!</pre>"
			end
		end
	end
end
--<-----------------------

--======================---
--->SAVE-DEL-PRESET<-------
--======================---

save_text = mysection:option(DummyValue, "_save_text", translate('<div style="width: 500px; text-align: left;">After successfully testing the current configuration, you can save it as a preset.</div>'), translate(""))

preset_name = mysection:option(Value, "name", translate("Preset Name: "), translate("Enter the preset name you want to add / rewrite / delete, or select an existing preset at the top of the page"))
preset_name.placeholder = "Enter your preset name here"
preset_name.rmempty = true


save_button = mysection:option(Button, "_save_button", translate("Presets Action :"))
save_button.inputtitle = translate("Add / Rewrite Preset")
save_button.inputstyle = "add"
save_button.write = function(self, section)
--->
	local p4 = ""
	local p5 = ""
	local new_preset_name = preset_name:formvalue(section)
	if not Is_String_Empty(new_preset_name) then
	--->
		local p1 = POWERS_CONFIG_VERSION
		local p2 = liquid_m:formvalue(section) or "0"
		local p3 = powerfanclose_m:formvalue(section) or "0"
		---
		if p1 == "2" then
			p4 = targ_hash:formvalue(section)
			p5 = "0"
		else
			p4 = "0"
			p5 = targ_freq:formvalue(section)
		end
		---
		local p6 = targ_vol:formvalue(section)
		local p7 = lowlimit_vol:formvalue(section)
		local p8 = uplimit_vol:formvalue(section)
		---
		local p9  = temp_board:formvalue(section)
		local p10 = power_minimum:formvalue(section)
		local p11 = power_uplimit:formvalue(section)
		---
		
		local write_res = Write_Json_Profile_New(PROFILES_FILE_CONTENT,PROFILES_FILE_PATH,new_preset_name,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
		if write_res ~= nil then
			luci.http.redirect(luci.dispatcher.build_url("admin/network/overclock"))
		else
			m.message = "<pre>[-] Error: Failed to write preset!</pre>"
		end
	else
		m.message = "<pre>[-] Error: Invalid preset name!</pre>"
	end
end

del_button = mysection:option(Button, "_delete_button", translate("Presets Action :"))
del_button.inputtitle = translate("Delete Preset")
del_button.inputstyle = "remove"
del_button.write = function(self, section)
--->
	local del_preset_name = preset_name:formvalue(section)
	if not Is_String_Empty(del_preset_name) then
	--->
		if Delete_Json_Profile_New(PROFILES_FILE_CONTENT,PROFILES_FILE_PATH,del_preset_name) then
			luci.http.redirect(luci.dispatcher.build_url("admin/network/overclock"))
		else
			m.message = "<pre>[-] Error: Failed to delete preset!</pre>"
		end
	else
		m.message = "<pre>[-] Error: Invalid preset name!</pre>"
	end
end
--<-----------------------



--======================---
------->JAVA-SCRIPT<-------
--======================---

script_m = mysection:option(TextValue, "_script", "")
script_m.template = "admin_network/overclock"
script_m._profiles = luci.util.execi("cat "..PROFILES_FILE_PATH.."  2> /dev/null || echo '{\"count\":0,\"auto_generated\":0}'")()

--<-----------------------

return m