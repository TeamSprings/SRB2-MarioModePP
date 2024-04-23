/* 
		Team Blue Spring's Series of Libaries. 
		Node Framework - lib_nodes.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

rawset(_G, "TBS_LUATAGGING", {
	-- version control
	major_iteration = 1, -- versions with extensive changes. 	
	iteration = 1, -- additions, fixes. No variable changes.
	version = "DEV", -- just a string...
	
	last_map = -1,
	sector_custom_vars = {},
	line_custom_vars = {},
	tag_sectors_vars = {},
	tag_lines_vars = {},
	
	polyobjects_vars = {},
	
	scripts = {},
	mobj_scripts = {},
})

freeslot("MT_LUASCRIPTEXECUTOR", "MT_LUASCRIPTMOBJ")

//////////////////////
-- SCRIPT MAP EXECUTOR NODE
//////////////////////

mobjinfo[MT_LUASCRIPTEXECUTOR] = {
//$Category TBS Library
//$Name Lua Map Executor Node
//$Sprite BOM1A0
	doomednum = 2703,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOSECTOR
}


addHook("MapLoad", function(map_int)
	if map_int ~= TBS_LUATAGGING.lastmap then
		TBS_LUATAGGING.sector_custom_vars = {}
		TBS_LUATAGGING.line_custom_vars = {}

		TBS_LUATAGGING.polyobjects_vars = {}
		TBS_LUATAGGING.tag_sectors_vars = {}
		TBS_LUATAGGING.tag_lines_vars = {}
		TBS_LUATAGGING.lastmap = map_int
	end
end)

addHook("MapThingSpawn", function(a, mt)
	a.args = mt.args
	a.tag = mt.args[0]
	a.mode = mt.stringargs[1]
	if TBS_LUATAGGING.scripts[mt.stringargs[0]] then
		a.script = TBS_LUATAGGING.scripts[mt.stringargs[0]] 
	end
end, MT_LUASCRIPTEXECUTOR)

addHook("MobjThinker", function(a)
	if not (a.tag and a.mode and a.args and a.script) then return end
	if not a.tagged then
		a.tagged = {}
		if a.mode == "sectors" then
			for sector in sectors.tagged(a.tag) do
				table.insert(a.tagged, sector)
			end
		elseif a.mode == "lines" then
			for line in lines.tagged(a.tag) do
				table.insert(a.tagged, line)
			end		
		else
			for mapthing in mapthings.tagged(a.tag) do
				table.insert(a.tagged, mapthing)
			end	
		end
	end
	
	if not a.tagged then return end
	a.script(a.tagged, a.args[1], a.args[2], a.args[3], a.args[4], a.args[5], a.args[6], a.args[7], a.args[8], a.args[9], a)
end, MT_LUASCRIPTEXECUTOR)

//////////////////////
-- SCRIPT MOBJ NODE
//////////////////////

mobjinfo[MT_LUASCRIPTMOBJ] = {
//$Category TBS Library
//$Name Lua Script Node
//$Sprite BOM1A0
	doomednum = 2704,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOSECTOR
}

addHook("MapThingSpawn", function(a, mt)
	if TBS_LUATAGGING.mobj_scripts[mt.stringargs[0]] then
		a.script = TBS_LUATAGGING.mobj_scripts[mt.stringargs[0]]
		a.args = mt.args
		a.textarg = mt.stringargs[1]
	end
end, MT_LUASCRIPTMOBJ)

addHook("MobjThinker", function(a)
	if not (a.script and a.args) then return end
	a.script(a.args[0], a.args[1], a.args[2], a.args[3], a.args[4], a.args[5], a.args[6], a.args[7], a.args[8], a.args[9], a.textarg, a)
end, MT_LUASCRIPTMOBJ)

addHook("NetVars", function(net)
	TBS_LUATAGGING.last_map = net($)
	TBS_LUATAGGING.sector_custom_vars = net($)
	TBS_LUATAGGING.line_custom_vars = net($)
	TBS_LUATAGGING.tag_sectors_vars = net($)
	TBS_LUATAGGING.tag_lines_vars = net($)
	TBS_LUATAGGING.polyobjects_vars = net($)
end)