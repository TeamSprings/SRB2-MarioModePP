
local Base_Table = {
	-- main_definitions
	game_type = "Pipe_Kindom_Zone",

	version = "2.0",
	versnum = 199, // Change to 200 on release
	specific = "0.60.07062024",
}

local Definitions = {
	-- @def level definitions
	hub_warp = 1,

	-- $level sets
	list_levels = {
		[31] = {
			accessible = false,
			requireVisit = false,

			-- collectible coins
			coin_type = 1 -- 0, 1, 2, 3,
			coin_ids = {},
		},
	},
}

local PF_HEALTH = 1
local PF_BACKUPS = 2
local PF_POWERUPS = 4

local PF_MAX = PF_BACKUPS|PF_POWERUPS|PF_HEALTH

local Compability = {
	["default"] = PF_MAX,

	-- Mario Bros. Pack
	["mario"] = PF_BACKUPS|PF_BACKUPS,
	["luigi"] = PF_BACKUPS|PF_BACKUPS,

	-- Sonic Hell
	["sonic"] = 0,
}

return {MM_Table = Base_Table, Calls = Calls, Definitions = Definitions, Compability = Compability}