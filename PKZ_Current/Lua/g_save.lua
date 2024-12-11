--[[
		Pipe Kingdom Zone's Main - g_save.lua

Description:
Save File Manager

Contributors: Skydusk
@Team Blue Spring 2024
]]

xMM_registry.save_system_version = "1"

xMM_registry.savefiles = {
	-- Temponary
	["TEMP_MP"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Used for current multiplayer session
	["DEFAULT"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Default Template

	-- Actual Saves:
	["Pipe_Kindom_Zone"] = {total_coins = 0, unlocked = 0, lvl_data = {}, coins = {}}, -- Save_file for Singleplayer
	-- ... (undefined, but likely more saves)
}

--
--	MAIN
--

xMM_registry.loadData = function()
	local path = "client/"..(xMM_registry.game_path).."/"..k..".dat"
	local version = true
	local check = {}

	local file = io.openlocal("client/"..(xMM_registry.game_path).."/savefiles.dat", "r")
	if file then
		for line in file:lines() do
			table.insert(check, line)
		end
	end
	file:close()

	if check then
		for k, v in ipairs(check) do
			xMM_registry.savefiles[v] = TBSlib.deserializeIO("client/"..(xMM_registry.game_path).."/"..v..".dat")
			print('[Mario Mode++]'.." "..v.." Save Data Loaded!")
		end
	end

	xMM_registry.savefiles["TEMP_MP"] = xMM_registry.savefiles[xMM_registry.game_type] or xMM_registry.savefiles["DEFAULT"]
end

xMM_registry.defaultData = function()
	if not xMM_registry.savefiles[xMM_registry.game_type] then
		xMM_registry.savefiles[xMM_registry.game_type] = xMM_registry.savefiles["DEFAULT"]
	end

	if not xMM_registry.savefiles[xMM_registry.game_type].total_coins then
		xMM_registry.savefiles[xMM_registry.game_type].total_coins = 0
	end
	if not xMM_registry.savefiles[xMM_registry.game_type].unlocked then
		xMM_registry.savefiles[xMM_registry.game_type].unlocked = 0
	end

	if not xMM_registry.savefiles[xMM_registry.game_type].lvl_data then
		for k, v in ipairs(xMM_registry.listoflevelIDs) do
			xMM_registry.savefiles[xMM_registry.game_type].lvl_data[v] = {}
			xMM_registry.savefiles[xMM_registry.game_type].lvl_data[v].visited = false
			xMM_registry.savefiles[xMM_registry.game_type].lvl_data[v].recordedtime = 0
		end
	end
	print('[Mario Mode++]'.." "..xMM_registry.game_type.." Defaulting missing values!")
end

xMM_registry.saveData = function()
	local saves = ""
	for k,v in pairs(xMM_registry.savefiles) do
		if (k == "DEFAULT" or k == "TEMP_MP") then continue end
		TBSlib.serializeIO(v, "client/"..(xMM_registry.game_path).."/"..k..".dat")
		saves = $..k.."\n"
		print('[Mario Mode++]'.." "..k.." Save Data Saved!")
	end

	local file = io.openlocal("client/"..(xMM_registry.game_path).."/savefiles.dat", "w")
	file:write(saves)
	file:close()
end

xMM_registry.getSaveData = function()
	if multiplayer then
		return xMM_registry.savefiles["TEMP_MP"]
	else
		return xMM_registry.savefiles[xMM_registry.game_type]
	end
end

xMM_registry.loadDefs()
xMM_registry.loadData()
xMM_registry.defaultData()

addHook("GameQuit", function(quit)
	if quit then
		xMM_registry.saveData()
	end
end)

--
-- UTILITY
--

xMM_registry.resetProgress = function()
	if xMM_registry.savefiles then
		local save_data = xMM_registry.getSaveData()
		save_data = xMM_registry.savefiles["DEFAULT"]
	end
end

-- Upon map load/change load all previous values damn it...
addHook("MapLoad", function(newmap)

	local save_data = xMM_registry.getSaveData()
	local milestone_coins = xMM_registry.dragonCoinRingSelect

	for k, v in ipairs(milestone_coins) do
		if save_data.total_coins > v and not save_data.coins[k] then
			save_data.coins[k] = 1
			if k == #milestone_coins then
				print("You got the Final Special Coin for reaching "..v.." coin milestone!")
			else
				print("You got the Special Coin for reaching "..v.." coin milestone!")
			end
		end
	end
end)

--
--	MULTIPLAYER
--

-- SERVER_SAVE
addHook("GameQuit", function(quit)
	if not quit then
		if multiplayer then
			if consoleplayer == server then
				xMM_registry.savefiles[xMM_registry.game_type] = xMM_registry.savefiles["TEMP_MP"]
			end
			xMM_registry.savefiles["TEMP_MP"] = xMM_registry.savefiles[xMM_registry.game_type]
		end
	end
end)

-- SYNC_SERVER WITH CLIENT
addHook("NetVars", function(net)
	xMM_registry.savefiles["TEMP_MP"] = net($)
end)