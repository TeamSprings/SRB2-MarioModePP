/* 
		Team Blue Spring's Series of Libaries. 
		Initiation script - init.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

// Settings
local Game_String = "PKZ"
local Pack_Type = '[Pipe Kingdom Zone]'
local Version = '2.2.14'

// Required level of library
local libTBSReq = 2
local waylibReq = 1
local menuliReq = 1


// Not meating requirements errors
assert((VERSION == 202), Pack_Type.."Mod doesn't support this major version of SRB2. Mod was made for version "..Version)
assert((SUBVERSION > 12), Pack_Type.."Mod requires features from "..Version.."+, please update your base game.")


// Load every script
if VERSION == 202 and SUBVERSION > 12 then
	print(Pack_Type.." -- Loading scripts")

	-- Libaries
	if not TBSlib or ((TBSlib.iteration < libTBSReq) or not TBSlib.iteration) then
		dofile("Libs/lib_general.lua")
	end
	
	if not TBSWaylib or ((TBSWaylib.iteration < waylibReq) or not TBSWaylib.iteration) then
		dofile("Libs/lib_pathing.lua")	
	end
	
		//dofile("Libs/lib_vector.lua")

		--dofile("Libs/lib_polygon.lua")	
		dofile("Libs/lib_polygon_rewrite.lua")
	
		dofile("Libs/lib_nodes.lua")
		dofile("Libs/lib_optimal.lua")
		dofile("Libs/sprkizard_worldtoscreen.lua")

	-- Globals
		dofile("g_setup.lua")
		dofile("g_main.lua")
		dofile("g_save.lua")
		dofile("g_config.lua")

	-- Freeslot
		dofile("Data/state_actions.lua")	
		dofile("Data/slots_general.lua")
		dofile("Data/info_sfx.lua")
		dofile("Data/state_general.lua")		
		dofile("Data/info_general.lua")
		dofile("Data/info_colors.lua")

	-- Gameplay
		dofile("Player/game_gamemodes.lua")
		dofile("Player/game_powerups.lua")
		dofile("Player/game_backuppw.lua")
		dofile("Thinkers/map_exec.lua")
		dofile("Player/game_scenes.lua")
		dofile("Player/game_race.lua")
		dofile("Player/game_yahoo.lua")	

	-- Hud
		dofile("GUI/gui_hud.lua")
		dofile("GUI/gui_title.lua")
		dofile("GUI/gui_inter.lua")	

	-- Objects
		dofile("Thinkers/think_collect.lua")
		dofile("Thinkers/think_foes.lua")
		dofile("Thinkers/const_sprmodels.lua")
		dofile("Thinkers/think_miscs.lua")
		dofile("Thinkers/const_pathing.lua")
		dofile("Thinkers/const_ambience.lua")	

	-- Bowser
		dofile("Bowser/bow_helpers.lua")
		dofile("Bowser/bow_main.lua")
		dofile("Bowser/bow_otherthink.lua")

	-- Config Menu
	if not TBS_Menu or ((TBS_Menu.iteration < menuliReq) or not TBSWaylib.iteration) then
		dofile("Libs/lib_interface.lua")
	end

		dofile("GUI/gui_config.lua")
		dofile("Libs/lib_polygon_editor.lua")	

		print(Pack_Type.." -- Mod loaded")
end

