/* 
		Pipe Kingdom Zone's Main - g_main.lua

Description:
Global Setup of PKZ

Contributors: Skydusk
@Team Blue Spring 2024
*/

local PKZ_Table = {

	-- Core
	active = true, 
	version = "2.0", // current
	versnum = 199, // Change to 200 on release
	betarelease = "0.78.22112023",
	
	// Mario Mode Plus
	game_type = "Pipe_Kindom_Zone",

	-- Collectibles
	dragonCoins = 0,
	maxDrgCoins = 39, //There are only 30 in levels, other 10 are gain through time/coin required means	
	dragonCoinTags = {},
	ringsCoins = 0,
	roomHubKey = 0,
	
	unlocks_flags = {
		["KEY"] = 1,
	},

	-- Currently these are just placeholder, that get replaced by g_setup.lua definitions, but it will likely left in place as backup, similarly how SRB2 2.1 used to have 2.0 GFZ in SRB2.srb
	dragonCoinRingSelect = {28, 27, 26, 25, 24}, -- for dragoncoins gained through coin collection
	listoflevelIDs = {31, 34, 35, 36, 37, 38, 39, 46, 48, 49, 50, 51, 52},
	levellist = {
		[31] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 40; coins = {}, new_coin = 2},
		[34] = {reqVisit = false; recordedtime = 0; timeattack = 5250; timeattackDGid = 39; coins = {1, 2, 3, 4, 5, 29}, new_coin = 1},
		[46] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 41; coins = {}, new_coin = 2},		
		[35] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 38; coins = {}, new_coin = 1},
		[36] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 37; coins = {}, new_coin = 1},
		[37] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 36; coins = {}, new_coin = 0},
		[38] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 35; coins = {}, new_coin = 0},
		[39] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 34; coins = {}, new_coin = 0},
		[48] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 33; coins = {}, new_coin = 2},
		[49] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 32; coins = {}, new_coin = 3},
		[50] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 31; coins = {}, new_coin = 2},
		[51] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 30; coins = {}, new_coin = 2},
		[52] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 29; coins = {}, new_coin = 2};
	},

	-- Hub Return
	hub_warp = 1,
	
	-- Mainly for all radars and misc. purposes
	curlvl = {
		mobj_scoins = {},
		mobj_smoons = {},
	},
	
	-- Achivement shall get refactored into savefile saving, this is performance wasting
	checklist = {
		{name = "Beat Bowser", reward = "Key to Extra LVLs", 
		toggle = function(table)
			local save_data = table.getSaveData()	
			if save_data.unlocked & table.unlocks_flags["KEY"] then 
				return true 
			else 
				return false 
			end
		end;};
		
		{name = "Beat All Goomba Races", reward = "L Statue.", 
		toggle = function(table) 
			return false 
		end;};
		
		{name = "Get All Pipe Coins", reward = "Level Select", 
		toggle = function(table) 
			return false 
		end;};		
		
		{name = "Get All Dragon Coins", reward = "Cheats", 
		toggle = function(table)
			local coins_data = table.getSaveData().coins
			if #coins_data == table.maxDrgCoins then 
				return true 
			else 
				return false
			end
		end;};		
		
		{name = "Get All Achivements", reward = "Congratulation!", 
		toggle = function(table) 
			return false
		end;};		
	};
	
	EV_BOWSER 	= 1,
	EV_ALLRACES = 2,
	EV_ALLCOINS = 4,
	
	-- ALL ACHIVEMENTS
	EV_ALLACHIVEMENTS = 1|2|4,
	
	-- REWARDS
	RE_KEY = 1,
	RE_STATUEL = 2,
	RE_LEVELSELECT = 4,
	RE_CHEATS = 8,
	
	achivement_definitions = {},
	
	-- MARIO MODE ++ GAME FLAGS
	-- TO DO:
	gameFlags = 0,
	
	GF_NOSONICHURT 	= 1, -- DISABLES THE CLASSIC SONIC RING DROP MECHANIC 
	GF_HARDMODE 	= 2, -- CHEAT!
	GF_EVIL 		= 4, -- CHEAT!	
	GF_LISREAL 		= 8, -- CHEAT!
	
	-- code states
	nosonicrings = false,	
	hardMode = false,
	evil = false,
	lisreal = false,
	
		-- Just for compatibility purposes
	hideHud = false,
	replaceHud = true,
	
	/* 
	*	Either, they have different custom functionality
	*	or... they are simply disabled, due to lack of compability
	*	They are still playable tho!
	*/ 
	disabledSkins = {
	["mario"] = false,
	["luigi"] = false,	
	["modernsonic"] = false,
	},
		
	-- MARIO MODE ++ SPECIFIC PLAYER FLAGS 
	-- TO DO:
	skinSpecifications = {
	["mario"] = 1|8,
	["luigi"] = 1|8,	
	["modernsonic"] = 0,
	["default"] = 1|2|4|8,
	},

	PF_BACKUPS 	= 1, 	-- THE ITEM HOLDER SYSTEM, includes HUD and backend
	PF_POWERUPS = 2, 	-- CUSTOM POWER UPS THEMSELVES
	PF_HUD 		= 4,	-- MARIO HUDS (Maker 2, 64, W, Modern)
	PF_HEALTH 	= 8,	-- POWER UPS, FORMS (mini, small, big)
}

PKZ_Table.game_path = "bluespring/mario"

local coin_types = {
	["DRAGON_COINS"] = 0,
	["PIPE_COINS"] = 1,
	["A_COINS"] = 2,
	["STAR_COINS"] = 3, 
}

local instruction_set = {
	["SAVE_FILE"] = function(cmap, lvl_data, data, line)
		PKZ_Table.game_type = line[2]
		return cmap, lvl_data, data
	end,
	["COIN_MILESTONES"] = function(cmap, lvl_data, data, line) 	
		for i = 2, #line do
			data.max_specialcoins = $+1
			local current_num = string.gsub(string.gsub(line[i], ", ", ""), ",","")
			table.insert(data.milestones, tonumber(current_num))
		end
		return cmap, lvl_data, data
	end,
	["MAP"] = function(cmap, lvl_data, data, line)
		local dummy
		cmap, dummy = G_FindMapByNameOrCode(line[2]) or 1
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
		print('[Mario Mode++]'.." Added Map into Slot! "..cmap)
		return cmap, lvl_data, data
	end,
	["HUB"] = function(cmap, lvl_data, data, line)
		if cmap then
			PKZ_Table.hub_warp = cmap
		end
		return cmap, lvl_data, data		
	end,	
	["REQUIRED_VISIT"] = function(cmap, lvl_data, data, line) 
		if lvl_data[cmap] then
			local bool = string.upper(line[2] or "false")

			lvl_data[cmap].reqVisit = (bool == "TRUE")
			--print("Map "..cmap.." requirement of visit is set: "..line[2])		
		end
		return cmap, lvl_data, data
	end,
	-- Event <event_id> [<event_rew>] [description]
	--["EVENT"] = function(cmap, lvl_data, data, line) 
	--	if lvl_data[cmap] then
	--		local bool = string.upper(line[2] or "false")
	--
	--		lvl_data[cmap].reqVisit = (bool == "TRUE")
	--		--print("Map "..cmap.." requirement of visit is set: "..line[2])		
	--	end
	--	return cmap, lvl_data, data
	--end,	
	["TIME_ATTACK"] = function(cmap, lvl_data, data, line) 
		if lvl_data[cmap] then
	
			lvl_data[cmap].timeattack = tonumber(line[2] or 0)
			if line[3] and string.upper(line[3]) == "TRUE" then
				data.max_specialcoins =	$+1
				lvl_data[cmap].timeattackDGid = data.max_specialcoins
				table.insert(lvl_data[cmap].coins, data.max_specialcoins)
			end
			--print("Map "..cmap.." timeattack requirement: "..lvl_data[cmap].timeattack)
		end
		return cmap, lvl_data, data		
	end,
	["SPECIAL_COIN"] = function(cmap, lvl_data, data, line) 
		if lvl_data[cmap] then
		
			if line[3] then
				for i = 1, tonumber(line[3]) do
					table.insert(lvl_data[cmap].coins, data.max_specialcoins+i)
				end	
			
				data.max_specialcoins =	$+tonumber(line[3])
				lvl_data[cmap].new_coin = coin_types[string.upper(line[2])] or coin_types["A_COINS"]
				lvl_data[cmap].num_coin = tonumber(line[3])
				--print("Map "..cmap.." amount of special coins: "..tonumber(line[3]))				
			end
		end
		return cmap, lvl_data, data
	end,
}

PKZ_Table.loadDefs = function()
	print('[Mario Mode++]'.." Parsing Data")
	
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
			cmap, lvl_data, data = instruction_set[string.upper(line[1])](cmap, lvl_data, data, line)
		end
	end
	
	PKZ_Table.achivement_definitions = data.events
	PKZ_Table.maxDrgCoins = data.max_specialcoins
	PKZ_Table.dragonCoinRingSelect = data.milestones
	PKZ_Table.listoflevelIDs = data.level_ids
	PKZ_Table.levellist = lvl_data
	
	print('[Mario Mode++]'.." Definitions loaded")
end

rawset(_G, "PKZ_Table", PKZ_Table)

// Debug Mode variable
// Enables currently all print() functions to every object having them
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

-- input variables that we use very often
local ctrl_inputs = {
    -- movement
    up = {}, down = {}, left = {}, right = {}, turr = {}, turl = {},
    -- main
    jmp = {}, spn = {}, cb1 = {}, cb2 = {}, cb3 = {}, tfg = {},
    -- sys
    sys = {}, pause = {}, con = {}
}
-- fill out these on map load
addHook("MapLoad", do
    ctrl_inputs.up[1], ctrl_inputs.up[2] = input.gameControlToKeyNum(GC_FORWARD)
	ctrl_inputs.down[1], ctrl_inputs.down[2] = input.gameControlToKeyNum(GC_BACKWARD)
	ctrl_inputs.left[1], ctrl_inputs.left[2] = input.gameControlToKeyNum(GC_STRAFELEFT)
	ctrl_inputs.right[1], ctrl_inputs.right[2] = input.gameControlToKeyNum(GC_STRAFERIGHT)
	ctrl_inputs.turl[1], ctrl_inputs.turl[2] = input.gameControlToKeyNum(GC_TURNLEFT)
	ctrl_inputs.turr[1], ctrl_inputs.turr[2] = input.gameControlToKeyNum(GC_TURNRIGHT)	

	ctrl_inputs.jmp[1], ctrl_inputs.jmp[2] = input.gameControlToKeyNum(GC_JUMP)
	ctrl_inputs.spn[1], ctrl_inputs.spn[2] = input.gameControlToKeyNum(GC_SPIN)
	ctrl_inputs.cb1[1], ctrl_inputs.cb1[2] = input.gameControlToKeyNum(GC_CUSTOM1)
    ctrl_inputs.cb2[1], ctrl_inputs.cb2[2] = input.gameControlToKeyNum(GC_CUSTOM2)
    ctrl_inputs.cb3[1], ctrl_inputs.cb3[2] = input.gameControlToKeyNum(GC_CUSTOM3)
	ctrl_inputs.tfg[1], ctrl_inputs.tfg[2] = input.gameControlToKeyNum(GC_TOSSFLAG)		

    ctrl_inputs.con[1], ctrl_inputs.con[2] = input.gameControlToKeyNum(GC_CONSOLE)
end)

-- actually make these global
rawset(_G, "ctrl_inputs", ctrl_inputs)

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
