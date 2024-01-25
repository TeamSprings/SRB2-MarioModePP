/* 
		Pipe Kingdom Zone's Main - g_save.lua

Description:
Save File Manager

Contributors: Skydusk
@Team Blue Spring 2024
*/

PKZ_Table.save_system_version = "1"

PKZ_Table.savefiles = {
	-- Temponary
	["TEMP_MP"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Used for current multiplayer session
	["DEFAULT"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Default Template
	
	-- Actual Saves:
	["Pipe_Kindom_Zone"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Save_file for Singleplayer
	-- ... (undefined, but likely more saves)
}

//
//	MAIN
//

PKZ_Table.loadData = function()
	local path = "client/"..(PKZ_Table.game_path).."/"..k..".dat"
	local version = true
	local check = {}
	
	local file = io.openlocal("client/"..(PKZ_Table.game_path).."/savefiles.dat", "r")
	if file then
		for line in file:lines() do
			table.insert(check, line)
		end
	end
	file:close()

	if check then
		for k, v in ipairs(check) do
			PKZ_Table.savefiles[v] = TBSlib.deserializeIO("client/"..(PKZ_Table.game_path).."/"..v..".dat")
			print('[Mario Mode++]'.." "..v.." Save Data Loaded!")
		end
	end
end

PKZ_Table.defaultData = function()
	PKZ_Table.savefiles[PKZ_Table.game_type] = PKZ_Table.savefiles["DEFAULT"]
	for k, v in ipairs(PKZ_Table.levellist) do
		PKZ_Table.savefiles[PKZ_Table.game_type].lvl_data[k] = {}
		PKZ_Table.savefiles[PKZ_Table.game_type].lvl_data[k].visited = false
		PKZ_Table.savefiles[PKZ_Table.game_type].lvl_data[k].recordedtime = 0	
	end
	print('[Mario Mode++]'.." "..PKZ_Table.game_type.." Defaulting values!")	
end

PKZ_Table.saveData = function()
	local saves = ""
	for k,v in pairs(PKZ_Table.savefiles) do
		if (k == "DEFAULT" or k == "TEMP_MP") then continue end
		TBSlib.serializeIO(v, "client/"..(PKZ_Table.game_path).."/"..k..".dat")
		saves = $..k.."\n"
		print('[Mario Mode++]'.." "..k.." Save Data Saved!")
	end
	
	local file = io.openlocal("client/"..(PKZ_Table.game_path).."/savefiles.dat", "w")
	file:write(saves)
	file:close()
end

PKZ_Table.getSaveData = function()
	if multiplayer then
		return PKZ_Table.savefiles["TEMP_MP"]
	else
		return PKZ_Table.savefiles[PKZ_Table.game_type]	
	end
end

PKZ_Table.loadDefs()
PKZ_Table.defaultData()
PKZ_Table.loadData()

addHook("GameQuit", function(quit)
	if not quit then return end
	PKZ_Table.saveData()
end)

//
// GENERAL
//

PKZ_Table.resetProgress = function()
	if PKZ_Table.savefiles then
		local save_data = PKZ_Table.getSaveData()
		save_data = PKZ_Table.savefiles["DEFAULT"]
	end
end

// Upon map load/change load all previous values damn it...
addHook("MapLoad", function(newmap)

	local save_data = PKZ_Table.getSaveData()
	local milestone_coins = PKZ_Table.dragonCoinRingSelect
	
	for k, v in ipairs(milestone_coins) do
		if save_data.total_coins > v and not save_data[k] then
			save_data.coins[k] = 1
			if k == #milestone_coins then
				print("You got the Final Special Coin for reaching "..v.." coin milestone!")			
			else
				print("You got the Special Coin for reaching "..v.." coin milestone!")
			end
		end
	end
end)

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