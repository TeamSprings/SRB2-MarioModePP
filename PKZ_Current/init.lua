--[[
		Team Blue Spring's Series of Libaries.
		Initiation script - init.lua

Contributors: Skydusk
@Team Blue Spring 2024
]]

-- Settings
local Game_String = "PKZ"
local Pack_Type = '[Pipe Kingdom Zone]'
local Version = '2.2.14'

-- Required level of library
local libTBSReq = 2
local waylibReq = 1
local menuliReq = 1

-- Not meating requirements errors
assert((VERSION == 202), Pack_Type.."Mod doesn't support this major version of SRB2. Mod was made for version "..Version)
assert((SUBVERSION > 12), Pack_Type.."Mod requires features from "..Version.."+, please update your base game.")

-- Pointless really, merely attempt to create iterator, possibly useful for other type of iterations
local function iterator_n(array, n) if n < #array then n = $+1 return n, array[n] end end
local function iterator(array) return iterator_n, array, 0 end

local function macro_dofile(prefix, ...)
	local array = {...}
	for _,use in iterator(array) do
		dofile(prefix..'_'..use)
	end
end

local cache_lib = {}

if not tbsrequire then
	local cache_lib = {}

	-- Simulated require function
	---@param path string
	---@return table?
	rawset(_G, "tbsrequire", function(path)
		local path = path .. ".lua"
		if cache_lib[path] then
			return cache_lib[path]
		else
			local func, err = loadfile(path)
			if not func then
				error("error loading module '"..path.."': "..err)
			else
				cache_lib[path] = func()
				return cache_lib[path]
			end
		end
	end)

	-- Library function
	---@param path string
	---@return table?
	rawset(_G, "tbslibrary", function(path)
		return tbsrequire("libs/"..path)
	end)
end
-- Simulated require function
---@param path string
---@param prefix string
rawset(_G, "tbsmacroinit", function(path, prefix, ...)
	local array = {...}
	for _,use in iterator(array) do
		dofile(path..'/'..prefix..'_'..use..'.lua')
	end
end)

-- Load every script
if VERSION == 202 and SUBVERSION > 12 then
	print(Pack_Type.." -- Loading scripts")

	-- Libaries
	if not TBSlib or ((TBSlib.iteration < libTBSReq) or not TBSlib.iteration) then
		dofile("libs/lib_general.lua")
	end

	if not TBSWaylib or ((TBSWaylib.iteration < waylibReq) or not TBSWaylib.iteration) then
		dofile("libs/lib_pathing.lua")
	end
		--dofile("Libs/lib_vector.lua")

		--dofile("Libs/lib_polygon.lua")
		dofile("libs/lib_debug.lua")

		dofile("libs/lib_nodes.lua")
		dofile("libs/lib_optimal.lua")
		dofile("libs/sprkizard_worldtoscreen.lua")
		dofile("libs/sal_lib-customhud-v2-1.lua")

		dofile("libs/lib_spriteeffects.lua")

		dofile("libs/zlib_ashi_dialogue.lua")

	-- Globals
		dofile("g_setup.lua")
		dofile("g_main.lua")
		dofile("g_save.lua")
		dofile("g_config.lua")

	-- Freeslot
		dofile("data/state_actions.lua")
		dofile("data/slots_general.lua")
		dofile("data/info_sfx.lua")
		dofile("data/state_general.lua")
		dofile("data/info_general.lua")
		dofile("data/info_colors.lua")


	-- Objects
		dofile("init/entities_init.lua")

	-- Gameplay
		dofile("init/game_init.lua")

	-- Hud
		dofile("gui/gui_setup.lua")
		dofile("gui/gui_hud.lua")
		dofile("gui/gui_title.lua")
		dofile("gui/gui_inter.lua")

	-- Config Menu
	if not TBS_Menu or ((TBS_Menu.iteration < menuliReq) or not TBSWaylib.iteration) then
		dofile("libs/lib_interface.lua")
	end

		dofile("gui/gui_config.lua")
		print(Pack_Type.." -- Mod loaded")
end

