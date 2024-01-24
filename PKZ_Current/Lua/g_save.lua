/* 
		Pipe Kingdom Zone's Main - g_save.lua

Description:
Save File Manager

Contributors: Skydusk
@Team Blue Spring 2024
*/

PKZ_Table.save_system_version = "1"

-- [1]> Singleplayer, [2]> Host Multiplayer
PKZ_Table.savefiles = {
	-- Temponary
	["TEMP_MP"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Used for current multiplayer session
	["DEFAULT"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Default Template
	
	-- Actual Saves:
	["Pipe_Kindom_Zone"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Save_file for Singleplayer
	-- ... (undefined, but likely more saves)
}

local DEFAULT_LVLDATA = {
	visited = false,
	recordedTime = 0,
}

-- FILE STRUCT
-- VERSION SAVE_FILE_VER
-- SAVE <PACK> <TOTAL_COINS> <RECORDEDTIME: map_id:record_map1-map_id:record_map2-...> <VISITED_BITARRAY> <SPECIALCOIN_BITARRAY> <UNLOCKS_BITARRAY>
-- ...
-- ...

//
//	INSTRUCTIONS
//
data_set = $.."SAVE "..(data.total_coins).." "..recorded_time.." "..visits.." "..coins.." "..unlocks.."\n"
local load_set = {
	["VERSION"] = function(line, version) 
		if line[2] and line[2] == PKZ_Table.save_system_version then
			version = true
		else
			version = false
		end
		return version
	end,
	["SAVE"] = function(line) 
		local total_coins = 	tonumber(line[2])
		local recorded_time = 	line[3]
		local visits = 			line[4]
		local sp_coins = 		line[5]
		local unlocks =			TBSlib.toBitsString(line[6], PKZ_Table.unlocks_flags)
		
		if not PKZ_Table.savefiles[PKZ_Table.game_type] then
			PKZ_Table.savefiles[PKZ_Table.game_type] = PKZ_Table.savefiles["DEFAULT"]
		end
		
		if type(total_coins) == "number" then
			PKZ_Table.savefiles[PKZ_Table.game_type].total_coins = total_coins
		end
		
		if type(unlocks) == "number" then
			PKZ_Table.savefiles[PKZ_Table.game_type].total_coins = unlocks
		end
		
		if sp_coins then
			local coin_table = TBSlib.getBoolLineNum(sp_coins)
			PKZ_Table.savefiles[PKZ_Table.game_type].coins = coin_table
		end
		
		if visits then
			local split_dot = TBSlib.splitStr(visits, ",")
		end
		
		if recorded_time then
			local split_dot = TBSlib.splitStr(recorded_time, ",")
		end
	end,
}

//
//	GENERAL
//

PKZ_Table.loadData = function()
	local path = (PKZ_Table.game_path).."/"..(PKZ_Table.game_type)..".dat"
	local save_file = io.openlocal(path, "r")
	local version = true
	
	if save_file then
		for line in save_file:lines do
			local split = TBSlib.parseLine(line)
			
			if split[1] and load_set[string.upper(split[1])] 
			and (version or not (version and string.upper(split[1]) == "VERSION")) then
				version = load_set[string.upper(split[1])](split, version)
			end
			
			if not version and version ~= nil then
				print("\x85".."WARNING:".."\x80".." Save is outdated or invalid! Save won't load.")
				version = nil
			end
		end
	end
	save_file:close()
end

-- SAVE SP <PACK> <TOTAL_COINS> <RECORDEDTIME: map_id:record_map1-map_id:record_map2-...> <VISITED_BITARRAY> <SPECIALCOIN_BITARRAY> <UNLOCKS_BITARRAY>
PKZ_Table.saveData = function()
	local path = (PKZ_Table.game_path).."/"..(PKZ_Table.game_type)..".dat"
	local data_set = "VERSION "..PKZ_Table.save_system_version.."\n"
	
	for s,v in pairs(PKZ_Table.savefiles) do
		if s == "DEFAULT" or s == "TEMP_MP" then
			continue
		end

		local rec_i = 1
		
		for i = 1, 2 do
			local data = v[i]
			
			local coins = ""
			local visits = ""
			local unlocks = ""
			local recorded_time = ""
			
			for y = 1, PKZ_Table.maxDrgCoins do
				coins = $..(data.coins[y] or 0)
			end
			
			local unlocks_array = data.unlocked	
			
			for y = 1, #unlocks_array do
				unlocks = $..(unlocks_array[y] or 0)
			end

			for k, l in ipairs(data.lvl_data) do
				visits = $..k.."-"..(l.reqVisit == true and 0 or 1)..","
				if == 1 then
					recorded_time = $..k.."-"..l.recordedtime..","
				end
			end
		

			data_set = $.."SAVE "..(data.total_coins).." "..recorded_time.." "..visits.." "..coins.." "..unlocks.."\n"
		end
	end
end

PKZ_Table.loadData()
addHook("GameQuit", PKZ_Table.saveData)

//
//	MULTIPLAYER
//

-- SERVER_SAVE
addHook("PlayerQuit", function()
	if consoleplayer == server then
		PKZ_Table.savefiles[PKZ_Table.game_type] = PKZ_Table.savefiles["TEMP_MP"]
	end
	PKZ_Table.savefiles["TEMP_MP"] = PKZ_Table.savefiles[PKZ_Table.game_type]
end)

-- SYNC_SERVER WITH CLIENT
addHook("NetVars", function(net)
	PKZ_Table.savefiles[PKZ_Table.game_type] = net($)
end)