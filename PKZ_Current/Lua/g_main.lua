--[[
		Pipe Kingdom Zone's Main - g_main.lua

Description:
Global Setup of PKZ

Contributors: Skydusk
@Team Blue Spring 2024
]]

local xMM_registry = {

	---@type boolean
	active = true,

	-- Core	
	version = "2.0", 	---@type string current
	versnum = 199, 		---@type number Change to 200 on release

	-- Beta
	betarelease = "0.60.07062024", ---@type string

	-- Mario Mode Plus
	game_type = "Pipe_Kindom_Zone", ---@type string

	-- Levels

	---@type number
	hub_warp = 1, 

	---@type table
	curlvl = {mobj_scoins = {}, mobj_smoons = {}}, 

	-- Heads-up Display
	
	---@type boolean
	hideHud = false,

	---@type boolean
	replaceHud = true,
}

--[[
	*
	*	Game Modes
	*
]]

-- Flags for the game modes
--* 1 = GF_NOSONICHURT
--* 2 = GF_HARDMODE
--* 4 = GF_EVIL
---@type number
xMM_registry.gameFlags = 0

--[[
	*
	*	Skins
	*
]]


-- Flags to disable
local DSF_BACKUPS 	= 1 	-- THE ITEM HOLDER SYSTEM, includes HUD and backend
local DSF_POWERUPS 	= 2 	-- CUSTOM POWER UPS THEMSELVES
local DSF_HUD 		= 4 	-- MARIO HUDS (Maker 2, 64, W, Modern)
local DSF_HEALTH 	= 8 	-- POWER UPS, FORMS (mini, small, big)

-- Sets
local DSF_MARIO 	= DSF_BACKUPS|DSF_HEALTH

-- Disables everything
local DSF_DISABLE 	= DSF_BACKUPS|DSF_POWERUPS|DSF_HUD|DSF_HEALTH

xMM_registry.skinDisable = {
	["mario"] = 		DSF_MARIO,
	["luigi"] = 		DSF_MARIO,
	["modernsonic"] = 	DSF_DISABLE,
}

-- Checks MM++ Compatibility status
---* HE ITEM HOLDER SYSTEM 	= 1
---* CUSTOM POWER UPS THEMSELVES = 2
---* MARIO HUDS (Maker 2, 64, W, Modern) = 4 
---* POWER UPS, FORMS 	= 8
---@param skin string
---@return number
function xMM_registry.skinCheck(skin)
	if xMM_registry.skinDisable[skin] then
		return xMM_registry.skinDisable[skin]
	else
		return 0
	end
end

--[[
	*
	*	Paths
	*
]]


xMM_registry.game_path = "bluespring/mario" ---@type string



-------------------------------------------------------------------------
-------------------------------------------------------------------------
----						SETUP FUNCTIONS
-------------------------------------------------------------------------
-------------------------------------------------------------------------


local coin_types = {
	["DRAGON_COINS"] = 0,
	["PIPE_COINS"] = 1,
	["A_COINS"] = 2,
	["STAR_COINS"] = 3,
}

local function MM_SetupError(line, error_msg)
	print('[Mario Mode++ Header] Line '..line..": "..error_msg)
end

local instruction_set = {

	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position
	["SAVE_FILE"] = function(cmap, lvl_data, data, line, row)
		xMM_registry.game_type = line[2]
		return cmap, lvl_data, data
	end,

	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position
	["COIN_MILESTONES"] = function(cmap, lvl_data, data, line, row)
		if line[2] == nil then
			MM_SetupError(row, "Invalid coin milestone setup!")
			return cmap, lvl_data, data
		end

		for i = 2, #line do
			data.max_specialcoins = $+1
			local current_num = string.gsub(string.gsub(line[i], ", ", ""), ",","")
			table.insert(data.milestones, tonumber(current_num))
		end
		return cmap, lvl_data, data
	end,
	
	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["MAP"] = function(cmap, lvl_data, data, line, row)
		if line[2] == nil then
			MM_SetupError(row, "No MapID specified!")
			return cmap, lvl_data, data
		end

		local dummy
		local orgcmap
		cmap, dummy = G_FindMapByNameOrCode(line[2]) or 1
		if cmap then
			lvl_data[cmap] = {
				coins = {},
				timeattack = 0,
				recordedtime = 0,
				timeattackDGid = nil,
				reqVisit = false,
			}
			table.insert(data.level_ids, cmap)
			if not data.level_ids.default then
				data.level_ids.default = 1
				data.level_ids.value = 1
			end

			return cmap, lvl_data, data
		end

		MM_SetupError(row, "Invalid MapID!")
		return orgcmap, lvl_data, data
	end,
	
	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["HUB"] = function(cmap, lvl_data, data, line, row)
		if cmap then
			xMM_registry.hub_warp = cmap
		else
			MM_SetupError(row, "HUB is a map field. The map has not been created!")
		end
		return cmap, lvl_data, data
	end,

	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["REQUIRED_VISIT"] = function(cmap, lvl_data, data, line, row)
		if lvl_data[cmap] then

			local bool = string.upper(line[2] or "false")

			lvl_data[cmap].reqVisit = (bool == "TRUE")
			--print("Map "..cmap.." requirement of visit is set: "..line[2])
		else
			MM_SetupError(row, "REQUIRED_VISIT is a map field. The map object is invalid!")
		end
		return cmap, lvl_data, data
	end,

	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["TIME_ATTACK"] = function(cmap, lvl_data, data, line, row)
		if lvl_data[cmap] then
			if not line[2] then
				MM_SetupError(row, "TIME_ATTACK field is empty!")

				lvl_data[cmap].timeattack = 0
				return cmap, lvl_data, data
			end

			lvl_data[cmap].timeattack = tonumber(line[2] or 0)
			if line[3] and string.upper(line[3]) == "TRUE" then
				data.max_specialcoins =	$+1
				lvl_data[cmap].timeattackDGid = data.max_specialcoins
				table.insert(lvl_data[cmap].coins, data.max_specialcoins)
			end
			--print("Map "..cmap.." timeattack requirement: "..lvl_data[cmap].timeattack)
		else
			MM_SetupError(row, "TIME_ATTACK is a map field. The map object is invalid!")
		end
		return cmap, lvl_data, data
	end,
	
	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["SPECIAL_COIN"] = function(cmap, lvl_data, data, line, row)
		if lvl_data[cmap] then
			if not line[2] then
				MM_SetupError(row, "SPECIAL_COIN field is empty!")
				return cmap, lvl_data, data
			end

			if line[3] then
				for i = 1, tonumber(line[3]) do
					table.insert(lvl_data[cmap].coins, data.max_specialcoins+i)
				end

				data.max_specialcoins =	$+tonumber(line[3])
				lvl_data[cmap].new_coin = coin_types[string.upper(line[2])] or coin_types["A_COINS"]
				lvl_data[cmap].num_coin = tonumber(line[3])
				--print("Map "..cmap.." amount of special coins: "..tonumber(line[3]))
			else
				MM_SetupError(row, "SPECIAL_COIN amount not specified!")
			end
		else
			MM_SetupError(row, "SPECIAL_COIN is a map field. The map object is invalid!")
		end
		return cmap, lvl_data, data
	end,
	
	---@param cmap 		number	current map
	---@param lvl_data 	table	level specific data
	---@param data 		table	global data
	---@param line 		string	full line
	---@param row 		number	parse position	
	["SHOP"] = function(cmap, lvl_data, data, line, row)
		if lvl_data[cmap] then
			if not lvl_data[cmap].shop then
				lvl_data[cmap].shop = {}
			end

			if line[2] and line[3] then
				local li2 = string.upper(line[2])
				local li3 = string.upper(line[3])

				local obj = _G[li2]
				local cost = tonumber(li3 or 1) or 1
				local forced_unlock = xMM_registry.hub_warp == cmap and true or false


				if li2 == "COIN" then
					table.insert(lvl_data[cmap].shop, {
						type = "COIN",
						cost = cost,
						forced = forced_unlock,
					})
				elseif obj and mobjinfo[obj] then
					local quantity = tonumber(line[4] or 1) or 1

					table.insert(lvl_data[cmap].shop, {
						type = "OBJECT",
						object = obj,
						quantity = quantity,
						cost = cost,
						forced = forced_unlock,
					})
				end
			else
				MM_SetupError(row, "Invalid SHOP function format. 'SHOP <MT_COIN> <COST> <QUANTITY>' for objects or 'SHOP COIN <COST>' for special coins")
			end
		else
			MM_SetupError(row, "SHOP is a map functoin. The map object is invalid!")
		end
		return cmap, lvl_data, data
	end,
}

--Loads definitions in the g_setup.lua file
--* Write MM_Setup global for this to work
xMM_registry.loadDefs = function()
	print('[Mario Mode++] Parsing Data')

	local start = getTimeMicros()

	local cmap = 0
	local def = TBSlib.parse(MM_setup)
	local lvl_data = {}
	local data = {
		level_ids = {},
		milestones = {},
		events = {},
		max_specialcoins = 0,
	}

	for i = 1, #def do
		local line = def[i]
		if not (line and line[1]) then continue end
		if instruction_set[string.upper(line[1])] then
			cmap, lvl_data, data = instruction_set[string.upper(line[1])](cmap, lvl_data, data, line, i)
		end
	end

	xMM_registry.achivement_definitions = data.events
	xMM_registry.maxDrgCoins = data.max_specialcoins
	xMM_registry.dragonCoinRingSelect = data.milestones
	xMM_registry.listoflevelIDs = data.level_ids
	xMM_registry.levellist = lvl_data

	local delta = abs(start - getTimeMicros())

	print('[Mario Mode++] Definitions loaded! '..tostring(#def)..' lines read and took '..tostring(delta)..' ms')
end

rawset(_G, "xMM_registry", xMM_registry)

-- Switch debug Mode command
-- Currently unused for most part
-- Enables currently all print() functions to every object having them
rawset(_G, "debugmariomode", CV_RegisterVar({
	name = "pkz_debug",
	defaultvalue = "off",
	flags = CV_CALL|CV_NOTINNET,
	PossibleValue = CV_OnOff,
	func = function(var)
		if not var then return end
		print((var.value and "\x82".."New Mario Mode - Debug Mode - Activated" or "\x82".."New Mario Mode - Debug Mode - Deactivated"))
	end
}))

addHook("MapLoad", function()
	xMM_registry.hideHud = false	
end)

-- create mario mode player userdata
addHook("PlayerSpawn", function(p)
	p.tempmariomode = {}
	if not p.mariomode then
		p.mariomode = {}
	end
	if p.mo and p.mo.valid and not p.mo.mariomode then
		p.mo.mariomode = {}
	end
end)

-- create mario mode hud userdata
if not hud.mariomode then
	hud.mariomode = {}
	hud.mariomode.title_ticker = {}
end
