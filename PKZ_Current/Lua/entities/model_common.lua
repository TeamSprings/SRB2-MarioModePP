/*
		Pipe Kingdom Zone's Sprite Models - const_sprmodels.lua

Description:
Blocks, mutli coins and any sprite model found in PKZ

Note:
Code, is one of the first Skydusk's Lua codes, it is horrible more than usual.

Contributors: Skydusk
@Team Blue Spring 2024
*/

// Configurations of tables

local colors = {
[0] = SKINCOLOR_NONE,
SKINCOLOR_WHITE,
SKINCOLOR_BONE,
SKINCOLOR_CLOUDY,
SKINCOLOR_GREY,
SKINCOLOR_SILVER,
SKINCOLOR_CARBON,
SKINCOLOR_JET,
SKINCOLOR_BLACK,
SKINCOLOR_AETHER,
SKINCOLOR_SLATE,
SKINCOLOR_BLUEBELL,
SKINCOLOR_PINK,
SKINCOLOR_YOGURT,
SKINCOLOR_BROWN,
SKINCOLOR_BRONZE,
SKINCOLOR_TAN,
SKINCOLOR_BEIGE,
SKINCOLOR_MOSS,
SKINCOLOR_AZURE,
SKINCOLOR_LAVENDER,
SKINCOLOR_RUBY,
SKINCOLOR_SALMON,
SKINCOLOR_RED,
SKINCOLOR_CRIMSON,
SKINCOLOR_FLAME,
SKINCOLOR_KETCHUP,
SKINCOLOR_PEACHY,
SKINCOLOR_QUAIL,
SKINCOLOR_SUNSET,
SKINCOLOR_COPPER,
SKINCOLOR_APRICOT,
SKINCOLOR_ORANGE,
SKINCOLOR_RUST,
SKINCOLOR_GOLD,
SKINCOLOR_SANDY,
SKINCOLOR_YELLOW,
SKINCOLOR_OLIVE,
SKINCOLOR_LIME,
SKINCOLOR_PERIDOT,
SKINCOLOR_APPLE,
SKINCOLOR_GREEN,
SKINCOLOR_FOREST,
SKINCOLOR_EMERALD,
SKINCOLOR_MINT,
SKINCOLOR_SEAFOAM,
SKINCOLOR_AQUA,
SKINCOLOR_TEAL,
SKINCOLOR_WAVE,
SKINCOLOR_CYAN,
SKINCOLOR_SKY,
SKINCOLOR_CERULEAN,
SKINCOLOR_ICY,
SKINCOLOR_SAPPHIRE,
SKINCOLOR_CORNFLOWER,
SKINCOLOR_BLUE,
SKINCOLOR_COBALT,
SKINCOLOR_VAPOR,
SKINCOLOR_DUSK,
SKINCOLOR_PASTEL,
SKINCOLOR_PURPLE,
SKINCOLOR_BUBBLEGUM,
SKINCOLOR_MAGENTA,
SKINCOLOR_NEON,
SKINCOLOR_VIOLET,
SKINCOLOR_LILAC,
SKINCOLOR_PLUM,
SKINCOLOR_RASPBERRY,
SKINCOLOR_ROSY
}

local bricoloring = {
	[0] = SKINCOLOR_BROWNBRICK,
	SKINCOLOR_CYANBRICK,
	SKINCOLOR_GREENBRICK,
	SKINCOLOR_BEIGEBRICK,
	SKINCOLOR_GRAYBRICK
}

local similarities = {
	["qblock"]	= "qblock",
	["eblock"] 	= "qblock",
	["6block"] 	= "qblock",
	["lblock"] 	= "qblock",
	["qbrick"] 	= "qblock",
	["rotate"]  = "qblock",
	["pow"]    	= "pow",
	["note"] 	= "note",
	["info"] 	= "info",
	["random"] 	= "random",
}

local blocktype = {
	-- ? Blocks
	[MT_QBLOCK] = 			{bt = "qblock", c = SKINCOLOR_GOLDENBLOCK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	[MT_BLQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_CYANBLOCK, 		pc = SKINCOLOR_CYANEMPTYBLOCK},
	[MT_GRQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_GREENBLOCK, 		pc = SKINCOLOR_GREENEMPTYBLOCK},
	[MT_BRQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_BEIGEBLOCK, 		pc = SKINCOLOR_BEIGEEMPTYBLOCK},
	[MT_SBQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_GRAYBLOCK, 		pc = SKINCOLOR_GRAYEMPTYBLOCK},
	-- Special Variants of ? Block
	[MT_EXBLOCK] = 			{bt = "eblock", c = SKINCOLOR_GOLDENBLOCK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	[MT_SM64BLOCK] = 		{bt = "6block", c = SKINCOLOR_BLUE, 			pc = SKINCOLOR_BROWNEMPTYBLOCK},
	[MT_LONGQBLOCK]	=		{bt = "lblock", c = SKINCOLOR_GOLDENBLOCK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	-- ? Brick Blocks
	[MT_QPRIMBRICK] = 		{bt = "qbrick", c = SKINCOLOR_BROWNBRICK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	[MT_QCYANBRICK] = 		{bt = "qbrick", c = SKINCOLOR_CYANBRICK, 		pc = SKINCOLOR_CYANEMPTYBLOCK},
	[MT_QGREENBRICK] = 		{bt = "qbrick", c = SKINCOLOR_GREENBRICK,		pc = SKINCOLOR_GREENEMPTYBLOCK},
	[MT_QTANBRICK] = 		{bt = "qbrick", c = SKINCOLOR_BEIGEBRICK, 		pc = SKINCOLOR_BEIGEEMPTYBLOCK},
	[MT_QSBLBRICK] = 		{bt = "qbrick", c = SKINCOLOR_GRAYBRICK, 		pc = SKINCOLOR_GRAYEMPTYBLOCK},
	// Bricks
	[MT_SPRIMBRICK] = 		{bt = "brick", 	c = SKINCOLOR_BROWNBRICK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	-- Special Blocks
	[MT_POWBLOCK] = 		{bt = "pow", 	c = SKINCOLOR_BLUE, 			pc = SKINCOLOR_RED},
	[MT_NOTEBLOCK] = 		{bt = "note", 	c = SKINCOLOR_AETHER, 			pc = SKINCOLOR_ORANGE},
	[MT_RANDOMBLOCK] = 		{bt = "random", c = SKINCOLOR_AURORAROLLBLOCK, 	pc = SKINCOLOR_AURORAROLLBLOCK},
	[MT_ICERANDOMBLOCK] = 	{bt = "random", c = SKINCOLOR_CYAN, 			pc = SKINCOLOR_CYAN},
	[MT_INFOBLOCK] = 		{bt = "info", 	c = SKINCOLOR_BLUE, 			pc = SKINCOLOR_BLUE},
	[MT_ROTATINGBLOCK] =	{bt = "rotate", c = SKINCOLOR_GOLDENBLOCK, 		pc = SKINCOLOR_GOLDENBLOCK},
}

// State table
local stble = {
	["qblock"] = 	{s = S_BLOCKQUE, 	sb = SPR_M2BL, a = A, 	sp = SPR_M1BL, b = A, 	sx = SPR_M4BL, c = A, 	5},
	["eblock"] = 	{s = S_BLOCKEXC, 	sb = SPR_M7BL, a = A,	sp = SPR_M1BL, b = A, 	sx = SPR_M4BL, c = A, 	5},
	["lblock"] = 	{s = S_BLOCKVIS, 	sb = SPR_M8BL, a = E,	sp = SPR_M1BL, b = A, 	sx = SPR_M4BL, c = F, 	5},
	["6block"] = 	{s = S_BLOCKVIS, 	sb = SPR_M8BL, a = A,	sp = SPR_M8BL, b = B, 	sx = SPR_M4BL, c = A, 	5},
	["qbrick"] = 	{s = S_BLOCKVIS, 	sb = SPR_M6BL, a = A,	sp = SPR_M5BL, b = A, 	sx = SPR_M4BL, c = A, 	5},
	["rotate"] = 	{s = S_BLOCKVIS, 	sb = SPR_M8BL, a = C,	sp = SPR_M8BL, b = A, 	sx = SPR_M4BL, c = A, 	5},
	["pow"] = 		{s = S_BLOCKVIS, 	sb = SPR_M2BL, a = A,	sp = SPR_C2BL, b = A, 	sx = SPR_C2BL, c = A, 	5},
	["info"] = 		{s = S_BLOCKVIS, 	sb = SPR_M2BL, a = A,	sp = SPR_IN1B, b = A, 	sx = SPR_IN1B, c = A, 	5},
	["random"] = 	{s = S_BLOCKRAND, 	sb = SPR_M2BL, a = A,	sp = SPR_C1BL, b = A, 	sx = SPR_C1BL, c = A, 	4},
	["brick"] = 	{s = S_BLOCKVIS, 	sb = SPR_M6BL, a = A,	sp = SPR_M5BL, b = A, 	sx = SPR_M5BL, c = A, 	5},
	["note"] = 		{s = S_BLOCKNOTE, 	sb = SPR_M2BL, a = A,	sp = SPR_NO1B, b = A, 	sx = SPR_NO1B, c = A, 	5},
}

local conversionmsh = {
	[MT_NEWFIREFLOWER] = MT_REDSHROOM,
	[MT_NUKESHROOM] = MT_REDSHROOM,
	[MT_FORCESHROOM] = MT_REDSHROOM,
	[MT_ELECTRICSHROOM] = MT_REDSHROOM,
	[MT_ELEMENTALSHROOM] = MT_REDSHROOM,
	[MT_CLOUDSHROOM] = MT_REDSHROOM,
	[MT_FLAMESHROOM] = MT_REDSHROOM,
	[MT_BUBBLESHROOM] = MT_REDSHROOM,
	[MT_THUNDERSHROOM] = MT_REDSHROOM,
	[MT_PITYSHROOM] = MT_REDSHROOM,
	[MT_PINKSHROOM] = MT_REDSHROOM,
	[MT_ICYFLOWER] = MT_REDSHROOM,
}

// Parameter Limit is 16(15) -- With extra flag 32(31)
// Item drop if powered up, non-mushroom item drop, amount
local itemselection = {
	[0] = 	{MT_DROPCOIN, 			MT_DROPCOIN, 		1},
	[1] = 	{MT_NEWFIREFLOWER, 		MT_REDSHROOM, 		1},
	[2] = 	{MT_LIFESHROOM, 		MT_LIFESHROOM, 		1},
	[3] = 	{MT_NUKESHROOM, 		MT_REDSHROOM, 		1},
	[4] = 	{MT_FORCESHROOM, 		MT_REDSHROOM, 		1},
	[5] = 	{MT_ELECTRICSHROOM, 	MT_REDSHROOM, 		1},
	[6] = 	{MT_ELEMENTALSHROOM, 	MT_REDSHROOM, 		1},
	[7] = 	{MT_CLOUDSHROOM, 		MT_REDSHROOM, 		1},
	[8] = 	{MT_POISONSHROOM, 		MT_POISONSHROOM, 	1},
	[9] = 	{MT_FLAMESHROOM, 		MT_REDSHROOM, 		1},
	[10] = 	{MT_BUBBLESHROOM, 		MT_REDSHROOM, 		1},
	[11] = 	{MT_THUNDERSHROOM, 		MT_REDSHROOM, 		1},
	[12] = 	{MT_PITYSHROOM, 		MT_REDSHROOM, 		1},
	[13] = 	{MT_PINKSHROOM, 		MT_REDSHROOM, 		1},
	[14] = 	{MT_STARMAN, 			MT_STARMAN, 		1},
	[15] = 	{MT_REDSHROOM, 			MT_REDSHROOM, 		1},
	[16] = 	{MT_MINISHROOM, 		MT_MINISHROOM, 		1},
	[17] = 	{MT_ICYFLOWER, 			MT_REDSHROOM, 		1},
	[18] = 	{MT_DROPCOIN, 			MT_DROPCOIN, 		3},
	[19] = 	{MT_DROPCOIN, 			MT_DROPCOIN, 		10}
}

local randselection = {
	[1] = 	MT_NEWFIREFLOWER,
	[2] = 	MT_LIFESHROOM,
	[3] = 	MT_NUKESHROOM,
	[4] = 	MT_FORCESHROOM,
	[5] =	MT_ELECTRICSHROOM,
	[6] = 	MT_ELEMENTALSHROOM,
	[7] = 	MT_CLOUDSHROOM,
	[8] = 	MT_FLAMESHROOM,
	[9] = 	MT_BUBBLESHROOM,
	[10] = 	MT_THUNDERSHROOM,
	[11] = 	MT_PITYSHROOM,
	[12] = 	MT_PINKSHROOM,
	[13] = 	MT_STARMAN,
	[14] = 	MT_REDSHROOM,
	[15] = 	MT_MINISHROOM,
	[16] = 	MT_ICYFLOWER,
}

local index_five_test = {
	["6block"] = function(blockSpawn, mo, i)
		blockSpawn.state = S_BLOCKVIS
		blockSpawn.sprite = SPR_M8BL
		blockSpawn.frame = B
		mo.state = S_BLOCKVIS
		mo.sprite = SPR_M8BL
		mo.frame = B
	end,
	["lblock"] = function(blockSpawn, mo, i)
		blockSpawn.sprite = SPR_M2BL
		blockSpawn.frame = B
		mo.sprite = SPR_M3BL
		mo.frame = B
	end,
	["brick"] = function(blockSpawn, mo, i)
		blockSpawn.sprite = SPR_M6BL
		mo.sprite = SPR_M6BL
		mo.frame = B
	end,
	["qbrick"] = function(blockSpawn, mo, i)
		blockSpawn.sprite = SPR_M6BL
		mo.sprite = SPR_M6BL
		mo.frame = B
	end,
	["info"] = function(blockSpawn, mo, i)
		blockSpawn.sprite = SPR_M2BL
		mo.sprite = SPR_M3BL
	end,
	["random"] = function(blockSpawn, mo, i)
		blockSpawn.frame = A|FF_PAPERSPRITE|FF_TRANS50
	end,
	["pow"] = function(blockSpawn, mo, i)
		blockSpawn.sprite = SPR_M2BL
		mo.sprite = SPR_M3BL
	end,
	["note"] = function(blockSpawn, mo, i)
		blockSpawn.state = S_BLOCKVIS
		blockSpawn.sprite = SPR_M2BL
	end,
}

local function LODblockModel(mo, mapthing)
	if mo.blocktype then
		local state = states[stble[mo.blocktype].s]
		mo.state = S_INVISIBLE
		mo.sprite = state.sprite
		mo.frame = stble[mo.blocktype].a+state.frame
		if mo.activated and mo.simblocktype == "qblock" then
			mo.sprite = stble[mo.blocktype].sx
			if stble[mo.blocktype].s == S_BLOCKVIS then
				mo.frame = stble[mo.blocktype].c+states[S_BLOCKVIS].frame
			else
				mo.frame = A
			end
		end
	end
	mo.frame = $ &~ FF_PAPERSPRITE
	mo.flags2 = $ &~ MF2_SPLAT
	mo.renderflags = $ &~ (RF_FLOORSPRITE|RF_NOSPLATBILLBOARD)
end

// Cleaner table-based block
local function blockModel(mo, mapthing)
	-- defining values
	local maxval = 5

	-- control object
	if mo.sides == nil then
		mo.sides = {}
	end

	mo.frame = $|FF_PAPERSPRITE
	mo.flags2 = $|MF2_SPLAT
	mo.renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
	mo.scale = FRACUNIT*5/6

	-- drag mo settings from table
	mo.blocktype = blocktype[mo.type].bt
	mo.simblocktype = similarities[mo.blocktype]

	mo.color = blocktype[mo.type].c


	mo.state = S_BLOCKTOPBUT

	if mo.blocktype ~= "random" then
		mo.sprite = SPR_M3BL
	end

	if mapthing then
		if mapthing.args[5] then
			mo.flying = true
		end

		if mapthing.args[1] then
			mo.color = colors[mapthing.args[1]]
		end

		if (mo.simblocktype == "qblock" or mo.simblocktype == "random") and mapthing.stringargs[0]
		and not (mo.activated or mo.itemcontainer) then
			mo.itemcontainer = {}
			local st = TBSlib.splitStr(tostring(mapthing.stringargs[0]), '|')

			for i = 1, #st do
				local entry = st[i]
				if _G[entry] and mobjinfo[_G[entry]] then
					table.insert(mo.itemcontainer, _G[entry])
					print(entry)
				end
			end
		end


	end

	-- spawn sides
	maxval = stble[mo.blocktype][1]
	for i = 1,maxval do
		if mo.sides[i] and mo.sides[i].valid then continue end

		local blockSpawn = P_SpawnMobjFromMobj(mo, 0,0,0, MT_BLOCKVIS)
		mo.sides[i] = blockSpawn
		blockSpawn.kstate = S_BLOCKVIS
		blockSpawn.id = i

		blockSpawn.height = mo.height
		blockSpawn.width = mo.width
		blockSpawn.state = stble[mo.blocktype].s
		blockSpawn.sprite = stble[mo.blocktype].sp
		blockSpawn.sprx = stble[mo.blocktype].sx

		if blockSpawn.state == S_BLOCKVIS then
			blockSpawn.frame = stble[mo.blocktype].a+states[S_BLOCKVIS].frame
		end

		blockSpawn.flags2 = $|MF2_LINKDRAW
		blockSpawn.sprmodel = 1
		blockSpawn.target = mo
		if i ~= 5 then continue end

		blockSpawn.flags2 = $|MF2_SPLAT
		blockSpawn.renderflags = RF_FLOORSPRITE|RF_NOSPLATBILLBOARD

		if not index_five_test[mo.blocktype] then continue end

		index_five_test[mo.blocktype](blockSpawn, mo, i)
	end

	-- brick colorpicking
	if mo.blocktype == "brick" then
		mo.color = bricoloring[mapthing and (mapthing.args[0] or mapthing.extrainfo) or 0]
	end

	-- random block inside
	if mo.blocktype == "random" then
		mo.state = S_INVISIBLE

		local object = P_SpawnMobj(mo.x, mo.y, mo.z, MT_BLOCKVIS)
		object.scale = FRACUNIT
		object.angle = mo.angle
		object.state = S_INVISIBLE
		object.target = mo
		object.sprmodel = 5

		mo.ranmsel = mo.ranmsel == nil and 1 or $
	end

	-- variable from mapthing parameter
	if mo.blocktype ~= "brick" then
		mo.picknum = mapthing and mapthing.args[0] or (mapthing.options & MTF_EXTRA and mapthing.extrainfo+16 or mapthing.extrainfo)
		mo.amountc = (itemselection[mo.picknum][3] ~= nil and itemselection[mo.picknum][3] or 1)
	end

	if mo.blocktype == "lblock" then
		local state = stble["lblock"].s
		mo.sides[1].sprite = SPR_M4BL
		mo.sides[3].sprite = SPR_M4BL
		mo.sides[2].sprite = SPR_M8BL
		mo.sides[4].sprite = SPR_M8BL
		if mo.activated then
			mo.sides[2].frame = F|FF_PAPERSPRITE
			mo.sides[4].frame = F|FF_PAPERSPRITE
			mo.color = blocktype[mo.type].pc
		else
			mo.sides[2].frame = E|FF_PAPERSPRITE
			mo.sides[4].frame = E|FF_PAPERSPRITE
		end
		mo.sides[1].frame = B|FF_PAPERSPRITE
		mo.sides[3].frame = B|FF_PAPERSPRITE

		mo.sides[1].sprmodel = 7
		mo.sides[3].sprmodel = 7
	end

	if mo.blocktype == "rotate" then
		mo.sides[1].sprite = SPR_M4BL
		mo.sides[3].sprite = SPR_M4BL
		mo.sides[1].frame = B|FF_PAPERSPRITE
		mo.sides[3].frame = B|FF_PAPERSPRITE
	end

	if mo.blocktype == "brick" or mo.blocktype == "qbrick" then
		for i = 1,4 do
			if not mo.sides[i] then continue end
			mo.sides[i].frame = (i % 2)|FF_PAPERSPRITE
		end
	end

	-- mo activation states
	if mo.simblocktype == "qblock" and mo.blocktype ~= "6block" and mo.blocktype ~= "lblock" then
		mo.sides[5].state = mo.state
		mo.sides[5].sprite = mo.sprite ~= SPR_M3BL and mo.sprite or SPR_M2BL
		if mo.activated then
			for i = 1,4 do
				if not mo.sides[i] then continue end
				mo.sides[i].state = mo.sides[i].kstate
				mo.sides[i].sprite = mo.sides[i].sprx
			end
			mo.sides[5].sprite = SPR_M2BL
			mo.sprite = SPR_M3BL
			mo.frame = A

			if mapthing and mapthing.args[2] then
				mo.color = colors[mapthing.args[2]]
			else
				mo.color = blocktype[mo.type].pc
			end
		end
	end
end

local framet = {[1] = C|FF_PAPERSPRITE, [3] = D|FF_PAPERSPRITE, [9] = E|FF_PAPERSPRITE, [12] = F|FF_PAPERSPRITE, [15] = G|FF_PAPERSPRITE}

addHook("MapThingSpawn", function(a, mt)
	a.requirement = mt.args[0] or mt.extrainfo
	a.frame = framet[a.requirement] or B|FF_PAPERSPRITE
end, MT_MARIODOOR)

// Cleaner table-based block
addHook("MapThingSpawn", function(a, mt)

	a.sprite = SPR_0MDR
	a.frame = A|FF_PAPERSPRITE

	-- spawn sides
	local blockSpawn = P_SpawnMobjFromMobj(a, -3*FixedMul(FixedMul(cos(mt.angle*FRACUNIT), a.radius), mt.scale*FRACUNIT), -3*FixedMul(FixedMul(sin(mt.angle*FRACUNIT), a.radius), mt.scale*FRACUNIT),0, MT_BLOCKVIS)
	blockSpawn.target = a
	blockSpawn.scale = a.scale
	blockSpawn.angle = mt.angle*ANG1+ANGLE_180
	blockSpawn.state = a.state
	blockSpawn.frame = A|FF_PAPERSPRITE
	blockSpawn.flags = a.flags| MF_NOCLIP &~ MF_SOLID
	blockSpawn.height = a.height
	blockSpawn.radius = a.radius
	blockSpawn.sprmodel = 4

	a.keyhole = {}

	if not (mt.extrainfo > 0 or mt.args[0] > 0) then return end

	for i = 1,2 do
		local ang = i*ANGLE_180+a.angle+ANGLE_90
		local keyhole = P_SpawnMobjFromMobj(a, -3*FixedMul(FixedMul(cos(ang*FRACUNIT), a.radius), mt.scale*FRACUNIT), -3*FixedMul(FixedMul(sin(ang*FRACUNIT), a.radius), mt.scale*FRACUNIT), FixedMul(32*FRACUNIT, a.scale), MT_BLOCKVIS)
		keyhole.target = a
		keyhole.scale = a.scale
		keyhole.angle = ang-ANGLE_90
		keyhole.state = a.state
		keyhole.sprite = SPR_0MDR
		keyhole.frame = H|FF_PAPERSPRITE
		keyhole.flags = a.flags| MF_NOCLIP &~ MF_SOLID
		keyhole.height = a.height
		keyhole.radius = a.radius
		keyhole.keyhole = true
		table.insert(a.keyhole, keyhole)
	end

end, MT_MARIOSTARDOOR)

local switchTypesBinary = {
	[0] = {colors = SKINCOLOR_BLUE, frame = A},
	[1] = {colors = SKINCOLOR_RED, frame = A},
	[2] = {colors = SKINCOLOR_GREEN, frame = A},
	[3] = {colors = SKINCOLOR_ORANGE, frame = A},
	[4] = {colors = SKINCOLOR_YELLOW, frame = A},
	[5] = {colors = SKINCOLOR_SKY, frame = A},
	[6] = {colors = SKINCOLOR_PURPLE, frame = A},
	[7] = {colors = SKINCOLOR_PINK, frame = A},
	[8] = {colors = SKINCOLOR_AETHER, frame = A},
	[9] = {colors = SKINCOLOR_BLUE, frame = B},
	[10] = {colors = SKINCOLOR_RED, frame = B},
	[11] = {colors = SKINCOLOR_GREEN, frame = B},
	[12] = {colors = SKINCOLOR_ORANGE, frame = B},
	[13] = {colors = SKINCOLOR_YELLOW, frame = B},
	[14] = {colors = SKINCOLOR_SKY, frame = B},
	[15] = {colors = SKINCOLOR_AETHER, frame = B}
}

local switchTypesUDMF = {
	colors = {SKINCOLOR_BLUE, SKINCOLOR_RED, SKINCOLOR_GREEN, SKINCOLOR_ORANGE, SKINCOLOR_YELLOW, SKINCOLOR_SKY, SKINCOLOR_PURPLE, SKINCOLOR_PINK, SKINCOLOR_AETHER},
	frames = {A, B}
}

// Cleaner table-based block
local function switchModel(mo, mapthing)
	-- variable from mapthing parameter
	-- used for colors
	-- settings
	if mapthing then
		mo.color = (mapthing.args[0] and switchTypesUDMF.colors[mapthing.args[0]] or switchTypesBinary[mapthing.extrainfo].colors) or SKINCOLOR_BLUE
		mo.frame = (mapthing.args[1] and switchTypesUDMF.frames[mapthing.args[1]] or switchTypesBinary[mapthing.extrainfo].frame) or A
		mo.scale = (mapthing.extrainfo and FRACUNIT*5/7 or $) or FRACUNIT*5/7
	end

	-- sides based
	for i = 1,8 do
		local baseSpawn = P_SpawnMobjFromMobj(mo, 0,0,0, MT_BLOCKVIS)
		baseSpawn.target = mo
		baseSpawn.scale = mo.scale
		baseSpawn.id = i
		baseSpawn.sprmodel = 3
		baseSpawn.state = S_BLOCKVIS
		baseSpawn.sprite = SPR_PSW2
		baseSpawn.frame = A|FF_PAPERSPRITE
	end
end

addHook("MobjCollide", function(a, tm)
	if not a.activated and tm.type == MT_PLAYER and FRACUNIT*4 >= abs(a.z+a.height-tm.z) and P_IsObjectOnGround(tm) then
		if a.spawnpoint.valid and a.spawnpoint.tag ~= 0 then
			A_LinedefExecute(a, a.spawnpoint.tag)
		end
		a.activated = true
		S_StartSound(a, sfx_marwob)
	end

end, MT_PSWITCH)

addHook("MobjThinker", function(a)
	if a.activated and a.scale > FRACUNIT/3 then
		a.scale = $-FRACUNIT/28
		a.spritexscale = $+FRACUNIT/10
		//print(a.height)
	end
end, MT_PSWITCH)

local function P_FixSetMobjTo(t, a, x, y, z, angle)
	P_MoveOrigin(a, t.x+x, t.y+y, t.z+z*P_MobjFlip(t))
	a.angle = t.angle+angle
end


local HEIGHTOFBLOCKS = -3*FRACUNIT+1
local SIXTYFOURFRACUNIT = 64*FRACUNIT
local LMULBLOCKS = 3*FRACUNIT

//framework putting it together
local function P_MarBlockFramework(mo, t, id, mul)
	if not (mo and mo.valid and t and t.valid) or (t.boolLOD and not t.activate) then P_RemoveMobj(mo) return end

	if (t.numfaces and t.numfaces[id]) then
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~ MF2_DONTDRAW
	end

	-- dargging values
	local idang = id*ANGLE_90
	local angt = t.angle + idang
	local val = FixedMul(t.scale << 5, mul)
	mo.color = t.color
	mo.scale = t.scale

	-- planes movement
	if id == 5 and t.blocktype ~= nil then
		P_FixSetMobjTo(t, mo, 0, 0, FixedMul(SIXTYFOURFRACUNIT, mo.scale), idang - ANGLE_90)
	else
		P_FixSetMobjTo(t, mo, FixedMul(cos(angt), val), FixedMul(sin(angt), val), HEIGHTOFBLOCKS, idang - ANGLE_90)
	end
end

//framework putting it together
local function P_SideCoinAttacher(mo, t, id)
	if not (mo and mo.valid and t and t.valid)
	or (t.type ~= MT_MARBWKEY and (t.state == S_DCOINSPARKLE1 and t.type == MT_DRAGONCOIN) or (t.state == S_MULTICOINSPARKLE1))
	then P_RemoveMobj(mo) return
	end

	-- dargging values
	local scale_cal = mo.scale*3
	local val = id*ANGLE_180
	local ang = t.angle + val
	mo.color = t.color
	mo.colorized = t.colorized
	mo.blendmode = t.blendmode

	-- planes movement
	P_FixSetMobjTo(t, mo, FixedMul(cos(ang), scale_cal), FixedMul(sin(ang), scale_cal), 0, val+ANGLE_270)
end

//framework putting it together
local function P_SwitchModelFramework(mo, t, id)
	if not (mo and mo.valid and t and t.valid) then P_RemoveMobj(mo) return end

	-- dargging values
	local ang = id*ANGLE_45
	-- planes movement
	P_FixSetMobjTo(t, mo, FixedMul(cos(ang) << 5, mo.scale), FixedMul(sin(ang) << 5, mo.scale), 0, ang+ANGLE_90-t.angle)
end

local visPlaneType = {
	[1] = function(a) -- Blocks
		P_MarBlockFramework(a, a.target, a.id, FRACUNIT)
	end;
	[2] = function(a) -- 3D Coins
		P_SideCoinAttacher(a, a.target, a.id)
	end;
	[3] = function(a) -- Switches
		P_SwitchModelFramework(a, a.target, a.id)
	end;
	[4] = function(a) -- Doors
		a.momx = -(a.target.momx)
		a.momy = -(a.target.momy)
	end;
	[5] = function(a) -- Item in Random Block
		if (a.target.activated or not (a.target and a.target.valid)) then P_RemoveMobj(a) return end
		local selector = a.target.itemcontainer and a.target.itemcontainer or randselection

		local ramdom = selector[a.target.ranmsel or 0]

		a.sprite = states[mobjinfo[ramdom].spawnstate].sprite
		a.frame = states[mobjinfo[ramdom].spawnstate].frame
		a.scale = FRACUNIT
		P_FixSetMobjTo(a.target, a, 0, 0, 12 << FRACBITS, 0)
	end;
	[6] = function(a) -- Overlay method
		P_FixSetMobjTo(a.target, a, 0, 0, 0, 0)
	end;
	[7] = function(a) -- Longer Blocks
		P_MarBlockFramework(a, a.target, a.id, LMULBLOCKS)
	end;
	//[6] = function(a) -- Thwomps
	//	P_ThwompFramework(a, a.target, a.id)
	//end;
	[99] = function(a) -- Random Usage
		if not (a and a.valid and a.customfunc) then return end
		a.customfunc(a)
	end;
}

addHook("MobjThinker", function(a)
	if a.sprmodel then
		visPlaneType[a.sprmodel](a)
	end
end, MT_BLOCKVIS)

local function blockCollison(mo, toucher)

	-- Defining distances
	local pdistance = abs(mo.z - (toucher.z + toucher.height))
	local mobjdistance = abs(toucher.z - (mo.z + mo.height))
	local mobjxydistance = abs(FixedHypot(mo.x, mo.y) - FixedHypot(toucher.x, toucher.y))

	-- Player collision
	if toucher.type == MT_PLAYER then
		mo.toucher = toucher

		if pdistance < FRACUNIT>>2 and toucher.z < mo.z and not mo.activated then
			if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM) and mo.blocktype == "brick" and PKZ_Table.disabledSkins[toucher.skin] ~= false then
				mo.bump = true
			else
				if mo.blocktype ~= "brick" then
					if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM)
						mo.smallbig = 2
					else
						mo.smallbig = 1
					end
				end
				mo.activate = true
			end
			mo.activationmethod = "down"
			local shock = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_BLOCKVIS)
			shock.fuse = 5
			shock.sprite = SPR_PFUF
			shock.frame = G
		end

		if toucher.z >= mo.z-FRACUNIT<<3 and mo.z + mo.height > toucher.z and toucher.player and toucher.player.pflags & PF_SPINNING and not mo.activated then
			if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM) and mo.blocktype == "brick" and PKZ_Table.disabledSkins[toucher.skin] ~= false then
				mo.bump = true
			else
				if mo.blocktype ~= "brick" then
					if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM)
						mo.smallbig = 2
					else
						mo.smallbig = 1
					end
				end
				mo.activate = true
			end
			mo.activationmethod = "side"
		end
	elseif toucher.type == MT_SHELL and toucher.z <= mo.z + mo.height-FRACUNIT*5 and toucher.z >= mo.z and (abs(toucher.momx) > 0 or abs(toucher.momy) > 0) then
		if toucher.z <= mo.z + mo.height>>1 then
			mo.activate = true
			mo.activationmethod = "side"
		end
		mo.toucher = toucher
	else

		-- Register block to mo if any action is required
		toucher.actblyx = mo
		-- Object collision
		if mobjdistance <= 2<<FRACBITS and mobjdistance >= 1<<FRACBITS then
			toucher.isInBlock = false
			toucher.momz = toucher.type == MT_STARMAN and 12<<FRACBITS or $
			toucher.dowhatever = mobjxydistance >= 32<<FRACBITS and true or false

			if toucher.momz < 0 and toucher.dowhatever ~= true then
				toucher.momz = 0
			else
				return
			end

		end
	end

end

addHook("MobjCollide", function(mo, player)
	-- Nukes everything and rmeove object
	if not (player.type == MT_PLAYER and player.state == S_PLAY_ROLL) then return nil end
	if not mo.powfuse then
		mo.powfuse = TICRATE
		mo.flags = $ &~ MF_SOLID|MF_PUSHABLE
		mo.source = player
		return false
	end
end, MT_POWBLOCK)

addHook("MobjThinker", function(a)
	a.boolLOD = a.spawnpoint and libOpt.LODConsole(a, libOpt.ITEM_CONST, blockModel, LODblockModel, a.boolLOD or false) or false
	a.numfaces = libOpt.BlockCulling(a)

	if (a.numfaces[6] and not a.boolLOD) then
		a.flags2 = $|MF2_DONTDRAW
	else
		a.flags2 = $ &~ MF2_DONTDRAW
	end

	if a.powfuse then
		if a.powfuse == 33 then
			local radius = FixedMul(a.radius, a.scale)<<7
			searchBlockmap("objects", function(ref, found)
				if found.flags & MF_ENEMY then
					P_KillMobj(found, a.source, a.source)
					return nil
				end
				if found.type == MT_COIN then
					local coin = P_SpawnMobjFromMobj(found, 0, 0, 0, MT_FLINGCOIN)
					coin.angle = found.angle+ANG1*15*i
					coin.momz = 10*FRACUNIT
					coin.momx = 3*cos(found.angle)
					coin.momy = 3*sin(found.angle)
					coin.fuse = 10*TICRATE
					P_RemoveMobj(found)
					return nil
				end
			end, a, a.x-radius, a.x+radius, a.y-radius, a.y+radius)
			P_StartQuake(FRACUNIT<<5, a.powfuse, {a.x, a.y, a.z}, radius)
		end

		if not (a.powfuse % 8) then
			local wave = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_BLOCKVIS)
			wave.state = S_INVISIBLE
			wave.sprite = SPR_STAB
			wave.frame = C|FF_FLOORSPRITE
			wave.powfuse = TICRATE/3
			wave.sprmodel = 99
			wave.customfunc = function(obj)
				obj.scale = $+FRACUNIT
				obj.powfuse = $-1
				if obj.powfuse == 1 then
					P_RemoveMobj(obj)
				end
			end
		end

		a.powfuse = $ - 1
		a.scale = $ - FRACUNIT >> 6
		if not a.powfuse then
			P_RemoveMobj(a)
		end
	end
end, MT_POWBLOCK)

addHook("MobjCollide", function(mo, player)
	-- Collision Check
	if not (player and player.valid and player.type == MT_PLAYER) then return end

	local distance = abs(player.z+1 - (mo.z + mo.height))

	if distance < FRACUNIT and player.z > mo.z and not mo.cooldown then
		mo.noted = true
		if mo.shootup == nil then
			mo.shootup = 0
		elseif mo.shootup > 0 then
			player.momz = mo.shootup
			player.state = S_PLAY_SPRING
			mo.shootup = 0
		end
	end
end, MT_NOTEBLOCK)

local function P_BlockBump(a, method)
	a.timerblock = a.timerblock and (a.timerblock > 0 and $ + 1 or $) or 1
	if not a.ogpos then
		a.ogpos = {x = a.x, y = a.y, z = a.z, scale = a.scale}
	end

	if method == "side" then
		local ease = ease.outsine(FRACUNIT*max(abs(a.timerblock-7), 7)/7, 9 << FRACBITS, 0)
		local xcos = cos(a.angle)
		local ysin = sin(a.angle)

		P_TryMove(a, a.ogpos.x+xcos*ease, a.ogpos.y+ysin*ease, false)
	elseif method == "up" then
		a.momx = 0
		a.momy = 0

		if a.timerblock > 4 and 10 > a.timerblock then
			a.momz = -6<<FRACBITS
			a.scale = $ - FRACUNIT/28
		end

		if a.timerblock > 9 and 15 > a.timerblock then
			a.momz = 6<<FRACBITS
			a.scale = $ + FRACUNIT/28
		end
	else
		a.momx = 0
		a.momy = 0

		if a.timerblock > 4 and 10 > a.timerblock then
			local tic = (FRACUNIT/5)*(a.timerblock - 4)
			a.momz = ease.outquad(tic, 29*a.ogpos.scale, 0)
			a.scale = ease.outsine(tic, a.ogpos.scale, a.ogpos.scale+a.ogpos.scale >> 2)
		end

		if a.timerblock > 9 and 15 > a.timerblock then
			local tic = (FRACUNIT/5)*(a.timerblock - 9)
			a.momz = ease.outquad(tic, -29*a.ogpos.scale, 0)
			a.scale = ease.outsine(tic, a.ogpos.scale+a.ogpos.scale >> 2, a.ogpos.scale)
		end
	end

	if a.timerblock == 15 then
		a.ogpos = nil
	end
end

local function blockThinker(mo)
	mo.boolLOD = libOpt.LODConsole(mo, libOpt.ITEM_CONST, blockModel, LODblockModel, mo.boolLOD or false)
	mo.numfaces = libOpt.BlockCulling(mo)

	if (mo.numfaces[6] and not mo.boolLOD) then
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~ MF2_DONTDRAW
	end

	mo.blockflying = (mo.blockflying == nil and true or $)

	if mo.blocktype == "random" and not (7 & leveltime) then
		local range = 16
		if mo.itemcontainer then
			range = #mo.itemcontainer
		end

		mo.ranmsel = P_RandomRange(1, range)
	end

	if (mo.flying or mo.flags2 & MF2_AMBUSH) and mo.blockflying then
		if not mo.wings then
			mo.wings = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_WIDEWINGS)
			mo.wings.state = S_SMALLWINGS
			mo.wings.scale = mo.scale << 1
			mo.wings.target = mo
		end

		local newspeed = mo.scale << 2
		local thrustx = P_ReturnThrustX(mo, mo.angle, newspeed)
		local thrusty = P_ReturnThrustY(mo, mo.angle, newspeed)

		if not P_TryMove(mo,
		mo.x + thrustx,
		mo.y + thrusty, true) then
			mo.angle = $ + ANGLE_180
			thrustx = -thrustx
			thrusty = -thrusty
		end

		mo.flags = $|MF_NOGRAVITY

		local anglesin = (180 & leveltime)*ANG2
		P_MoveOrigin(mo, mo.x + thrustx, mo.y + thrusty, mo.z + P_RandomRange(4, 6)*sin(anglesin))
		mo.angle = $ + P_RandomRange(-2, 2)*ANG1
	end

	if mo and mo.valid then

		if mo.blocktype == "brick" then

			if mo.bump then
				P_BlockBump(mo, mo.activationmethod or "down")
				if mo.timerblock == 15 then
					mo.momz = 0
					mo.timerblock = nil
					mo.bump = false
				end
			elseif mo.activate and not mo.bump then
				local zsp = 0
				A_AddNoMPScore(mo, 10, 1)

				for i = 1,10 do
					local zsp = (i > 4 and (45 << FRACBITS) or 0)+P_RandomRange(0,4) << FRACBITS
					local debries = P_SpawnMobjFromMobj(mo, 0, 0, zsp, (P_RandomRange(0,1) and MT_COLORMMARDEBRIES or MT_COLORMARDEBRIES))
					debries.color = mo.color
					debries.angle = mo.toucher.angle-ANGLE_135-ANGLE_90*i+P_RandomRange(-8,8)*ANG1
					debries.momz = P_RandomRange(4,7) << FRACBITS

					if i % 2 then
						local dust = P_SpawnMobjFromMobj(debries, 20*cos(debries.angle), 20*sin(debries.angle), 20 << FRACBITS, MT_SPINDUST)
						dust.scale = $+mo.scale>>1
					end
					P_Thrust(debries, debries.angle, 2 << FRACBITS)

				end
				local pow_brick = P_SpawnMobjFromMobj(mo, 0, 0, mo.height/2, MT_POPPARTICLEMAR)
				pow_brick.scale = $+FRACUNIT >> 1
				S_StartSound(mo.toucher, sfx_marioc)
				P_RemoveMobj(mo)
			end
		end

		--if mo.valid and mo.type == MT_QBLOCK and not mo.activated and PKZ_Table and PKZ_Table.current_goldblockcolor then
		--	mo.color = PKZ_Table.current_goldblockcolor
		--end


		if mo.valid and mo.activate and not mo.activated then

			P_BlockBump(mo, mo.activationmethod or "down")

			if mo.timerblock == 6 and mo.blocktype == '6block' then
				local itemspawn = P_SpawnMobjFromMobj(mo, 0,0,10 << FRACBITS, itemselection[mo.picknum][mo.smallbig])
				itemspawn.target = mo.toucher
				itemspawn.scale = FRACUNIT
				itemspawn.momz = 9 << FRACBITS

				for i = 1,10 do
					local zsp = (i > 4 and (45 << FRACBITS) or 0)+P_RandomRange(0,4) << FRACBITS
					local debries = P_SpawnMobjFromMobj(mo, 0, 0, zsp, MT_COLORMMARDEBRIES)
					debries.color = mo.color
					debries.angle = mo.toucher.angle-ANGLE_135-ANGLE_90*i+P_RandomRange(-8,8)*ANG1
					debries.momz = P_RandomRange(4,7) << FRACBITS

					if i % 2 then
						local dust = P_SpawnMobjFromMobj(debries, 20*cos(debries.angle), 20*sin(debries.angle), 20 << FRACBITS, MT_SPINDUST)
						dust.scale = $+mo.scale>>1
					end
					P_Thrust(debries, debries.angle, 2 << FRACBITS)

				end

				P_RemoveMobj(mo)
				return
			end

			if mo.timerblock == 15 then

				mo.momz = 0
				mo.momx = 0
				mo.momy = 0

				mo.blockflying = false
				if not mo.itemcontainer then
					mo.amountc = mo.amountc > 1 and $ - 1 or $
				end

				local reward = mo.itemcontainer and (mo.blocktype ~= "random" and (mo.smallbig < 2 and mo.itemcontainer[#mo.itemcontainer] or conversionmsh[mo.itemcontainer[#mo.itemcontainer]]) or mo.itemcontainer[mo.ranmsel])
				or (mo.blocktype ~= "random" and itemselection[mo.picknum][mo.smallbig] or randselection[mo.ranmsel])

				S_StartSound(mo.toucher, sfx_mario9)
				if reward ~= MT_DROPCOIN and reward ~= MT_COIN and reward then
					local itemspawn = P_SpawnMobjFromMobj(mo, 0,0,10 << FRACBITS, reward)
					itemspawn.target = mo.toucher
					itemspawn.scale = FRACUNIT
					itemspawn.momx = 3 << FRACBITS
					itemspawn.isInBlock = true
					if mo.blocktype == "eblock" then
						itemspawn.momx = 0
						itemspawn.isInBlock = false
						P_SetOrigin(itemspawn, mo.toucher.x, mo.toucher.y, mo.toucher.z)
					end
				else
					A_CoinProjectile(mo, 0, 0, mo.toucher)
				end

				if mo.itemcontainer then
					if mo.blocktype ~= "random" then
						table.remove(mo.itemcontainer)
						if #mo.itemcontainer < 1 then
							mo.activated = true
							mo.boolLOD = true

							if mo.blocktype == "qbrick" then
								mo.state = S_BLOCKTOPBUT
								mo.sprite = SPR_M3BL
							end
						end
					elseif (mo.blocktype == "random") then
						mo.activated = true
						mo.boolLOD = true
					end
				elseif not mo.itemcontainer and mo.amountc and mo.amountc <= 1 then
					mo.activated = true
					mo.boolLOD = true

					if mo.blocktype == "qbrick" then
						mo.state = S_BLOCKTOPBUT
						mo.sprite = SPR_M3BL
					end
				end

				mo.timerblock = nil

				if not mo.activated then
					mo.activate = false
					mo.timerblock = 1
				end
			end
		end
	end
end

addHook("MobjThinker", function(mo)
	mo.boolLOD = libOpt.LODConsole(mo, libOpt.ITEM_CONST, blockModel, LODblockModel, mo.boolLOD or false)
	mo.numfaces = libOpt.BlockCulling(mo)

	if (mo.numfaces[6] and not mo.boolLOD) then
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~ MF2_DONTDRAW
	end

	if mo.noted == true then
		mo.cooldown = 9
		if not mo.ogpos then
			mo.ogpos = {x = mo.x, y = mo.y, z = mo.z, scale = mo.scale}
		end

		mo.timernote = (mo.timernote and $+1 or 1)

		if mo.timernote > 4 and 10 > mo.timernote then

			mo.z = TBSlib.lerp(FRACUNIT/5, mo.z, mo.ogpos.z-16*mo.scale)
		end

		if mo.timernote == 8 then
			mo.shootup = 20 << FRACBITS
		end

		if mo.timernote == 9 then
			mo.momz = 0
			mo.timernote = 0
			mo.noted = false
		end
	else
		if mo.ogpos then
			mo.z = TBSlib.lerp(FRACUNIT/5, mo.z, mo.ogpos.z)
		end

		if mo.cooldown then
			mo.cooldown = $-1
		end
	end
end, MT_NOTEBLOCK)

addHook("MobjThinker", function(a)
	a.boolLOD = libOpt.LODConsole(a, libOpt.ITEM_CONST, blockModel, LODblockModel, a.boolLOD or false)
	a.numfaces = libOpt.BlockCulling(a)

	if (a.numfaces[6] and not a.boolLOD) then
		a.flags2 = $|MF2_DONTDRAW
	else
		a.flags2 = $ &~ MF2_DONTDRAW
	end


	if a.activate and a.spawnpoint then
		P_BlockBump(a, "down")

		if a.timerblock == 15 and a.spawnpoint.stringargs[0] then
			S_StartSound(a, sfx_marwof)

			a.momx = 0
			a.momy = 0
			a.momz = 0

			local event = {
				active = true,
				inputblock = true;
				[1] = {
				line = ""..a.spawnpoint.stringargs[0]
				}
			}

			if a.spawnpoint.stringargs[1] then
				event[2] = {
				line = ""..a.spawnpoint.stringargs[1]
				}
			end

			event_CallDialog(event)
			a.activated = false
			a.activate = false
			a.timerblock = nil
		end
	end
end, MT_INFOBLOCK)

// Hooks

/*
for _,thwomps in pairs({
	MT_GREYTHWOMP,
	MT_BLUETHWOMP
	}) do
addHook("MapThingSpawn", thowmpModel, thwomps)
addHook("MobjThinker", thwompThinker, thwomps)
addHook("MobjCollide", thwompCollider, thwomps)
end
*/

-- Generic Blocks
for _,blocks in pairs({
	MT_QBLOCK,
	MT_BLQBLOCK,
	MT_GRQBLOCK,
	MT_BRQBLOCK,
	MT_SBQBLOCK,
	MT_SPRIMBRICK,
	MT_RANDOMBLOCK,
	MT_QPRIMBRICK,
	MT_QCYANBRICK,
	MT_QGREENBRICK,
	MT_QTANBRICK,
	MT_QSBLBRICK,
	MT_EXBLOCK,
	MT_SM64BLOCK,
	MT_LONGQBLOCK,
	MT_ROTATINGBLOCK,
	}) do
addHook("MapThingSpawn", blockModel, blocks)
addHook("MobjCollide", blockCollison, blocks)
addHook("MobjThinker", blockThinker, blocks)
end

-- Special Blocks
for _,speblocks in pairs({
	MT_POWBLOCK,
	MT_INFOBLOCK,
	MT_NOTEBLOCK
	}) do

addHook("MapThingSpawn", blockModel, speblocks)
end
addHook("MapThingSpawn", switchModel, MT_PSWITCH)
addHook("MobjCollide", blockCollison, MT_INFOBLOCK)

local RedCoinItemAnimation = {
	[0] = {offscale_x = (FRACUNIT >> 2), offscale_y = (FRACUNIT >> 2), tics = 10, nexts = 1},
	[1] = {offscale_x = -(FRACUNIT >> 2), offscale_y = -(FRACUNIT >> 2), tics = 10, nexts = 0},
}

-- Power Up Table and Special Behavior
for _,tablepowerups in pairs({
	MT_LIFESHROOM,
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
	MT_ELEMENTALSHROOM,
	MT_CLOUDSHROOM,
	MT_POISONSHROOM,
	MT_FLAMESHROOM,
	MT_BUBBLESHROOM,
	MT_THUNDERSHROOM,
	MT_PITYSHROOM,
	MT_PINKSHROOM,
	MT_GOLDSHROOM,
	MT_MINISHROOM,
	MT_NEWFIREFLOWER,
	MT_REDSHROOM,
	MT_ICYFLOWER
	}) do

addHook("MobjThinker", function(mo)
	//Behavior in block
	if mo.isInBlock then
		mo.momx = 0
		mo.momy = 0
		mo.momz = $ + FRACUNIT/24
		mo.flags = $|MF_NOGRAVITY
	elseif not mo.behsetting or mo.behsetting == 0 then
		mo.flags = $ &~ MF_NOGRAVITY
	end
	if mo.reserved then
		if not P_IsObjectOnGround(mo) then
			mo.mushfall = true
			if (8 & leveltime) >> 2 then
				mo.flags2 = $|MF2_DONTDRAW
			else
				mo.flags2 = $ &~ MF2_DONTDRAW
			end
		else
			mo.flags2 = $ &~ MF2_DONTDRAW
			mo.reserved = false
		end
	end
	if mo.redrewarditem then
	    if mo.redrewarditem > 1 then
			if mo.falldowntimer == nil then
				mo.falldowntimer = 1
			end

			if mo.falldowntimer > 0 then
				mo.falldowntimer = $ + 1
			end

			if mo.tracer ~= nil and mo.tracer.valid and mo.falldowntimer <= 70 then
				P_TryMove(mo, mo.tracer.x, mo.tracer.y, true)
				mo.z = mo.tracer.z + 150 << FRACBITS
			end

			mo.momx = 0
			mo.momy = 0
			mo.momz = 0

			TBSlib.scaleAnimator(mo, RedCoinItemAnimation)

			if mo.falldowntimer == 70 then
				TBSlib.resetAnimator(mo)
				mo.redrewarditem = 1
			end
		else
			mo.momx = 0
			mo.momy = 0
			mo.momz = -(4 << FRACBITS)
			if P_IsObjectOnGround(mo) then
				mo.redrewarditem = nil
			end
		end
	end
end, tablepowerups)

end



/*
// Cleaner table-based block
local function thowmpModel(mo, mapthing)
	-- variable from mapthing parameter
	-- used for colors
	if mapthing.args[0] ~= 0
		mo.colornum = mapthing.args[0]
	else
		mo.colornum = mapthing.extrainfo
	end

	local spritepicker = {
		[MT_GREYTHWOMP] = {x = SPR_TWU2, y = SPR_TWU4, z = SPR_TWU1, a = SPR_NULL},
		[MT_BLUETHWOMP] = {x = SPR_TWU7, y = SPR_TWU6, z = SPR_TWU6, a = SPR_TWU6}
	}

	-- base
	mo.state = S_BLOCKVIS
	mo.sprite = spritepicker[mo.type].a
	mo.frame = A|FF_PAPERSPRITE
	mo.originz = mo.z

	for i = 1,4 do
		local baseSpawn = P_SpawnMobjFromMobj(mo, 0,0,0, MT_BLOCKVIS)
		baseSpawn.target = mo
		baseSpawn.scale = mo.scale
		baseSpawn.id = i
		baseSpawn.thwomp = true
		baseSpawn.state = S_BLOCKVIS
		if i == 1
			baseSpawn.sprite = spritepicker[mo.type].x
		elseif i == 3
			baseSpawn.sprite = spritepicker[mo.type].y
		else
			baseSpawn.sprite = spritepicker[mo.type].z
		end
		baseSpawn.frame = A|FF_PAPERSPRITE
	end
end


//framework putting it together
local function P_ThwompFramework(mo, t, id)
	if mo and mo.valid and t and t.valid

		-- dargging values
		local ang = t.angle-ANGLE_90 + id*ANGLE_90
		mo.angle = ang-ANGLE_90
		mo.color = t.color

		-- mo activation states
		if t.activated == true and mo.id == 1
			mo.frame = B|FF_PAPERSPRITE
		else
			mo.frame = A|FF_PAPERSPRITE
		end

		-- planes movement
		if t.type == MT_GREYTHWOMP
			if id == 1 or id == 3
				P_TeleportMove(mo, t.x+FixedMul(25/2*cos(ang), mo.scale), t.y+FixedMul(25/2*sin(ang), mo.scale), t.z)
			else
				P_TeleportMove(mo, t.x+FixedMul(28*cos(ang), mo.scale), t.y+FixedMul(28*sin(ang), mo.scale), t.z)
			end
		else
			P_TeleportMove(mo, t.x+FixedMul(32*cos(ang), mo.scale), t.y+FixedMul(32*sin(ang), mo.scale), t.z)
		end
	else
		-- Remove planes after removal
		P_RemoveMobj(mo)
	end
end

local function thwompThinker(mo)
	if mo and mo.valid
		if P_LookForPlayers(mo, 200*FRACUNIT, true, false) and mo.active ~= true and not P_IsObjectOnGround(mo)
			mo.activated = true
			mo.active = true
		end
		if mo.activated == true
			mo.momz = $ - FRACUNIT*3/2
			if mo.floorz >= mo.z-FRACUNIT and mo.activated == true
				mo.momz = 0
				for i = 1,8 do
					local par = P_SpawnMobjFromMobj(mo, 0,0,0, MT_POPPARTICLEMAR)
					par.angle = mo.angle+i*ANGLE_45
					par.momx = 10*cos(par.angle)
					par.momy = 10*sin(par.angle)
				end
				mo.activated = false
			end
		end
		if mo.activated == false and mo.active == true
			if mo.z < mo.originz
				mo.momz = FRACUNIT*2
			else
				mo.momz = 0
				mo.active = false
			end
		end
	end
end

local function thwompCollider(a, tm)
	if a and a.valid and tm and tm.valid
	-- celling distance
	local cdis = abs(a.z - (tm.z + tm.height))
	-- floor distance
	local fdis = abs(tm.z - (a.z + a.height))
	-- horizontal distance
	local hdis = abs(FixedHypot(a.x, a.y) - FixedHypot(tm.x, tm.y))
		if tm.type == MT_PLAYER
			if fdis < 4*FRACUNIT
				if P_IsObjectOnGround(tm)
					P_KillMobj(tm)
				end
			end
			if (a.z < tm.z+tm.height) or (a.z + a.height > tm.z)
				a.flags = $|MF_SOLID
				return true
			else
				a.flags = $ &~ MF_SOLID
				return false
			end
		end
	end
end
*/