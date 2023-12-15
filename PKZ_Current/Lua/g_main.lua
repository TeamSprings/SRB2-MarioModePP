/* 
		Pipe Kingdom Zone's Main - g_main.lua

Description:
Global Setup of PKZ

Contributors: Skydusk
@Team Blue Spring 2024
*/

CV_RegisterVar({
	name = "pkz_selectlvlmenu",
	defaultvalue = "test",
	flags = 0,
	PossibleValue = {test=49, legacyi=31, legacyii=46, pkzi=34, pkzii=35, pkziii=36, klzi=37, klzii=38, klziii=39},
})

local PKZ_Table = {

	-- Core
	active = true, 
	version = "2.0", // current
	versnum = 199, // Change to 200 on release
	betarelease = "0.78.22112023",

	-- Collectibles
	dragonCoins = 0,
	maxDrgCoins = 39, //There are only 30 in levels, other 10 are gain through time/coin required means	
	dragonCoinTags = {},
	ringsCoins = 0,
	roomHubKey = 0,

	dragonCoinRingSelect = {28, 27, 26, 25, 24}, -- for dragoncoins gained through coin collection
	listoflevelIDs = {31, 34, 35, 36, 37, 38, 39, 46, 48, 49, 50, 51, 52},
	levellist = {
		[31] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 40; coins = {}},
		[34] = {reqVisit = false; recordedtime = 0; timeattack = 5250; timeattackDGid = 39; coins = {1, 2, 3, 4, 5, 29}},
		[46] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 41; coins = {}},		
		[35] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 38; coins = {}},
		[36] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 37; coins = {}},
		[37] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 36; coins = {}},
		[38] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 35; coins = {}},
		[39] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 34; coins = {}},
		[48] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 33; coins = {}},
		[49] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 32; coins = {}},
		[50] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 31; coins = {}},
		[51] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 30; coins = {}},
		[52] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 29; coins = {}};
	},
	
	checklist = {
		{name = "Beat Bowser", reward = "Key to Extra LVLs", 
		toggle = function(table)
			if table.roomHubKey then 
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
			if table.dragonCoins == table.maxDrgCoins then 
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
	["mario"] = 1|4,
	["luigi"] = 1|4,	
	["modernsonic"] = 0,
	["default"] = 1|2|4|8,
	},

	PF_BACKUPS 	= 1, 	-- THE ITEM HOLDER SYSTEM, includes HUD and backend
	PF_POWERUPS = 2, 	-- CUSTOM POWER UPS THEMSELVES
	PF_HUD 		= 4,	-- MARIO HUDS (Maker 2, 64, W, Modern)
	PF_HEALTH 	= 8,	-- POWER UPS, FORMS (mini, small, big)
}

PKZ_Table.resetProgress = function()
	for i = 1,PKZ_Table.maxDrgCoins do
		PKZ_Table.dragonCoinTags[i] = 0
	end
	
	local file = io.openlocal("bluespring/mario/pkz_dgsave.dat", "w+")
	if file
		file:seek("set", 0)
		for i = 1,PKZ_Table.maxDrgCoins do
			file:write(PKZ_Table.dragonCoinTags[i].."\n")
		end
		file:close()
	end

	print("\x85".."WARNING:".."\x80".." Reset of dragon coin list was successful - Map restart is required for restart to take effect")
	
	local file = io.openlocal("bluespring/mario/pkz_unlocks.dat", "w+")	
	if file then
		file:seek("set", 0)
		file:write("0".."\n")
		file:write("0")
		file:close()
	end

	print("\x85".."WARNING:".."\x80".." Restart of global coin count was successful - Map restart is required for restart to take effect")
end

PKZ_Table.saveDrgProgress = function()
	if PKZ_Table.cheatrecord then return end
	local file = io.openlocal("bluespring/mario/pkz_dgsave.dat", "w+")
	if file
		//file:write(dragoncointag[15])
		file:seek("set", 0)
		local string = ""
		for i = 1,PKZ_Table.maxDrgCoins do
			string = string..(PKZ_Table.dragonCoinTags[i] or 0 + "").."\n"
		end
		file:write(string)
		file:close()
	end
	PKZ_Table.dragonCoins = 0
	for i = 1,PKZ_Table.maxDrgCoins do
		PKZ_Table.dragonCoins = $ + min(PKZ_Table.dragonCoinTags[i] or 0, 1)
	end
end

rawset(_G, "PKZ_Table", PKZ_Table)

// Upon map load/change load all previous values damn it...
addHook("MapLoad", function(newmap)
		PKZ_Table.dragonCoinTags = {}
		for i = 1,PKZ_Table.maxDrgCoins do
			PKZ_Table.dragonCoinTags[i] = 0 
		end
		local check = io.openlocal("bluespring/mario/pkz_dgsave.dat", "r+")
		if check
			check:seek("set", 0)
			for i = 1,PKZ_Table.maxDrgCoins do
				PKZ_Table.dragonCoinTags[i] = check:read("*n")
			end
			check:close()
		end
		local key = io.openlocal("bluespring/mario/pkz_unlocks.dat", "r+")
		if key then
			key:seek("set", 0)
			PKZ_Table.roomHubKey = key:read("*n")
			PKZ_Table.ringsCoins = key:read("*n")
			for line in key:lines() do
				local tab = {}
 
				for w in string.gmatch(line, "%S+") do
					table.insert(tab, w)
				end
		
				if tab and tab[1] and tab[2] and tab[3] then
					local index, reqvisit, ticsTimeAttack = tonumber(tab[1]), tonumber(tab[2]), tonumber(tab[3])
					
					PKZ_Table.levellist[index].reqVisit = (reqvisit == 0)
					PKZ_Table.levellist[index].recordedtime = ticsTimeAttack
				else
					continue
				end
			end
			key:close()
		end

		if PKZ_Table.levellist[newmap] then
			PKZ_Table.levellist[newmap].reqVisit = false
		end

		if not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[5]] then
		
			if PKZ_Table.ringsCoins > 500 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[1]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[1]] = 1
				print("Dragon Coin for reaching 500 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 1250 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[2]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[2]] = 1
				print("Dragon Coin for reaching 1250 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 2000 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[3]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[3]] = 1
				print("Dragon Coin for reaching 2000 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 3500 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[4]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[4]] = 1
				print("Dragon Coin for reaching 3500 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 5000 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[5]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[5]] = 1
				print("Final Dragon Coin for reaching 5000 coins was earned")			
			end
			
		end
		PKZ_Table.saveDrgProgress()
end)

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
    jmp = {}, spn = {}, cb1 = {}, cb2 = {}, cb3 = {},
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
