/* 
		Pipe Kingdom Zone's Sprite Models - const_sprmodels.lua

Description:
Blocks, mutli coins and any sprite model found in PKZ

Contributors: Skydusk
@Team Blue Spring 2024
*/

// Configurations of tables


local bricoloring = { 
	[0] = SKINCOLOR_BROWNBRICK, 
	SKINCOLOR_CYANBRICK, 
	SKINCOLOR_GREENBRICK, 
	SKINCOLOR_BEIGEBRICK, 
	SKINCOLOR_GRAYBRICK
}

local blocktype = {
	-- ? Blocks
	[MT_QBLOCK] = 			{bt = "qblock", c = SKINCOLOR_GOLDENBLOCK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK}, 
	[MT_BLQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_CYANBLOCK, 		pc = SKINCOLOR_CYANEMPTYBLOCK},
	[MT_GRQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_GREENBLOCK, 		pc = SKINCOLOR_GREENEMPTYBLOCK},
	[MT_BRQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_BEIGEBLOCK, 		pc = SKINCOLOR_BEIGEEMPTYBLOCK},
	[MT_SBQBLOCK] = 		{bt = "qblock", c = SKINCOLOR_GRAYBLOCK, 		pc = SKINCOLOR_GRAYEMPTYBLOCK},
	// Bricks
	[MT_SPRIMBRICK] = 		{bt = "brick", 	c = SKINCOLOR_BROWNBRICK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK},
	-- ? Brick Blocks
	[MT_QPRIMBRICK] = 		{bt = "qbrick", c = SKINCOLOR_BROWNBRICK, 		pc = SKINCOLOR_BROWNEMPTYBLOCK}, 
	[MT_QCYANBRICK] = 		{bt = "qbrick", c = SKINCOLOR_CYANBRICK, 		pc = SKINCOLOR_CYANEMPTYBLOCK},
	[MT_QGREENBRICK] = 		{bt = "qbrick", c = SKINCOLOR_GREENBRICK,		pc = SKINCOLOR_GREENEMPTYBLOCK},
	[MT_QTANBRICK] = 		{bt = "qbrick", c = SKINCOLOR_BEIGEBRICK, 		pc = SKINCOLOR_BEIGEEMPTYBLOCK},
	[MT_QSBLBRICK] = 		{bt = "qbrick", c = SKINCOLOR_GRAYBRICK, 		pc = SKINCOLOR_GRAYEMPTYBLOCK},
	-- Special Blocks
	[MT_POWBLOCK] = 		{bt = "pow", 	c = SKINCOLOR_BLUE, 			pc = SKINCOLOR_RED},	
	[MT_NOTEBLOCK] = 		{bt = "note", 	c = SKINCOLOR_AETHER, 			pc = SKINCOLOR_ORANGE},
	[MT_RANDOMBLOCK] = 		{bt = "random", c = SKINCOLOR_AURORAROLLBLOCK, 	pc = SKINCOLOR_AURORAROLLBLOCK},
	[MT_ICERANDOMBLOCK] = 	{bt = "random", c = SKINCOLOR_CYAN, 			pc = SKINCOLOR_CYAN},
	[MT_INFOBLOCK] = 		{bt = "info", 	c = SKINCOLOR_BLUE, 			pc = SKINCOLOR_BLUE}
}

// State table
local stble = {
	["qblock"] = 	{s = S_BLOCKQUE, sb = SPR_M2BL, sp = SPR_M1BL, sx = SPR_M4BL, 5},
	["qbrick"] = 	{s = S_BLOCKVIS, sb = SPR_M6BL, sp = SPR_M5BL, sx = SPR_M4BL, 5},
	["pow"] = 		{s = S_BLOCKVIS, sb = SPR_M2BL, sp = SPR_C2BL, sx = SPR_C2BL, 5},
	["info"] = 		{s = S_BLOCKVIS, sb = SPR_M2BL, sp = SPR_IN1B, sx = SPR_IN1B, 5},
	["random"] = 	{s = S_BLOCKRAND, sb = SPR_M2BL, sp = SPR_C1BL, sx = SPR_C1BL, 4},
	["brick"] = 	{s = S_BLOCKVIS, sb = SPR_M6BL, sp = SPR_M5BL, sx = SPR_M5BL, 5},
	["note"] = 		{s = S_BLOCKNOTE, sb = SPR_M2BL, sp = SPR_NO1B, sx = SPR_NO1B, 5},
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
	["brick"] = function(blockSpawn, actor, i)
		blockSpawn.sprite = SPR_M6BL		
		actor.sprite = SPR_M6BL
		actor.frame = B
	end,
	["qbrick"] = function(blockSpawn, actor, i)
		blockSpawn.sprite = SPR_M6BL		
		actor.sprite = SPR_M6BL
		actor.frame = B		
	end,
	["info"] = function(blockSpawn, actor, i)
		blockSpawn.sprite = SPR_M2BL
		actor.sprite = SPR_M3BL
	end,	
	["random"] = function(blockSpawn, actor, i)
		blockSpawn.frame = A|FF_PAPERSPRITE|FF_TRANS50
	end,
	["pow"] = function(blockSpawn, actor, i)
		blockSpawn.sprite = SPR_M2BL
		actor.sprite = SPR_M3BL		
	end,
	["note"] = function(blockSpawn, actor, i)
		blockSpawn.state = S_BLOCKVIS
		blockSpawn.sprite = SPR_M2BL
	end,
}

local function LODblockModel(actor, mapthing)
	if actor.blocktype then
		local state = states[stble[actor.blocktype].s]
		actor.state = S_INVISIBLE
		actor.sprite = state.sprite
		actor.frame = state.frame
		if actor.activated and (actor.blocktype == "qbrick" or actor.blocktype == "qblock") then
			actor.sprite = stble[actor.blocktype].sx
			actor.frame = A	
		end
	end
	actor.frame = $ &~ FF_PAPERSPRITE	
	actor.flags2 = $ &~ MF2_SPLAT
	actor.renderflags = $ &~ (RF_FLOORSPRITE|RF_NOSPLATBILLBOARD)
end

// Cleaner table-based block 
local function blockModel(actor, mapthing)
	-- defining values
	local maxval = 5
	
	-- control object
	actor.sides = {}
	actor.frame = $|FF_PAPERSPRITE	
	actor.flags2 = $|MF2_SPLAT
	actor.renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
	actor.scale = FRACUNIT*5/6
	
	-- drag actor settings from table
	actor.blocktype = blocktype[actor.type].bt
	actor.color = blocktype[actor.type].c
	
	actor.state = S_BLOCKTOPBUT
	
	if actor.blocktype ~= "random" then
		actor.sprite = SPR_M3BL
	end
	
	-- spawn sides
	maxval = stble[actor.blocktype][1]
	for i = 1,maxval do
		local blockSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		table.insert(actor.sides, blockSpawn)
		blockSpawn.kstate = S_BLOCKVIS
		blockSpawn.id = i		
		
		blockSpawn.height = actor.height
		blockSpawn.width = actor.width		
		blockSpawn.state = stble[actor.blocktype].s
		blockSpawn.sprite = stble[actor.blocktype].sp		
		blockSpawn.sprx = stble[actor.blocktype].sx

		blockSpawn.flags2 = $|MF2_LINKDRAW
		blockSpawn.sprmodel = 1
		blockSpawn.target = actor
		if i ~= 5 then continue end
		
		blockSpawn.flags2 = $|MF2_SPLAT		
		blockSpawn.renderflags = RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
		
		if not index_five_test[actor.blocktype] then continue end
		
		index_five_test[actor.blocktype](blockSpawn, actor, i)
	end
	
	-- brick colorpicking
	if actor.blocktype == "brick" then
		actor.color = bricoloring[mapthing and (mapthing.args[0] or mapthing.extrainfo) or 0]
	end
	
	-- random block inside
	if actor.blocktype == "random" then
		actor.state = S_INVISIBLE
		
		local object = P_SpawnMobj(actor.x, actor.y, actor.z, MT_BLOCKVIS)
		object.scale = FRACUNIT
		object.angle = actor.angle
		object.state = S_INVISIBLE
		object.target = actor
		object.sprmodel = 5
		
		actor.ranmsel = actor.ranmsel == nil and 1 or $
	end
	
	-- variable from mapthing parameter
	if actor.blocktype ~= "brick" then
		actor.picknum = mapthing and mapthing.args[0] or (mapthing.options & MTF_EXTRA and mapthing.extrainfo+16 or mapthing.extrainfo)
		actor.amountc = (itemselection[actor.picknum][3] ~= nil and itemselection[actor.picknum][3] or 1)
	end
	
	if actor.blocktype == "brick" or actor.blocktype == "qbrick" then
		for i = 1,4 do
			actor.sides[i].frame = (i % 2)|FF_PAPERSPRITE
		end
	end


	-- actor activation states
	if actor.blocktype == "qbrick" or actor.blocktype == "qblock" then
		actor.sides[5].state = actor.state
		actor.sides[5].sprite = actor.sprite ~= SPR_M3BL and actor.sprite or SPR_M2BL
		if actor.activated then
			for i = 1,4 do
				actor.sides[i].state = actor.sides[i].kstate
				actor.sides[i].sprite = actor.sides[i].sprx
			end
			actor.sides[5].sprite = SPR_M2BL
			actor.sprite = SPR_M3BL
			actor.frame = A
			actor.color = blocktype[actor.type].pc			
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
local function switchModel(actor, mapthing)
	-- variable from mapthing parameter 
	-- used for colors
	-- settings
	if mapthing then
		actor.color = (mapthing.args[0] and switchTypesUDMF.colors[mapthing.args[0]] or switchTypesBinary[mapthing.extrainfo].colors) or SKINCOLOR_BLUE
		actor.frame = (mapthing.args[1] and switchTypesUDMF.frames[mapthing.args[1]] or switchTypesBinary[mapthing.extrainfo].frame) or A 
		actor.scale = (mapthing.extrainfo and FRACUNIT*5/7 or $) or FRACUNIT*5/7
	end
	
	-- sides based	
	for i = 1,8 do
		local baseSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		baseSpawn.target = actor
		baseSpawn.scale = actor.scale
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

//framework putting it together
local function P_MarBlockFramework(actor, t, id)
	if not (actor and actor.valid and t and t.valid) or (t.boolLOD and not t.activate) then P_RemoveMobj(actor) return end	
	
	if (t.numfaces and t.numfaces[id]) then
		actor.flags2 = $|MF2_DONTDRAW
	else
		actor.flags2 = $ &~ MF2_DONTDRAW
	end
	
	-- dargging values
	local idang = id*ANGLE_90
	local angt = t.angle + idang
	local val = t.scale << 5
	actor.color = t.color
	actor.scale = t.scale
		
	-- planes movement
	if id == 5 and t.blocktype ~= nil then
		P_FixSetMobjTo(t, actor, 0, 0, FixedMul(SIXTYFOURFRACUNIT, actor.scale), idang - ANGLE_90)
	else
		P_FixSetMobjTo(t, actor, FixedMul(cos(angt), val), FixedMul(sin(angt), val), HEIGHTOFBLOCKS, idang - ANGLE_90)	
	end
end

//framework putting it together
local function P_SideCoinAttacher(actor, t, id)
	if not (actor and actor.valid and t and t.valid) 
	or (t.type ~= MT_MARBWKEY and (t.state == S_DCOINSPARKLE1 and t.type == MT_DRAGONCOIN) or (t.state == S_MULTICOINSPARKLE1)) 
	then P_RemoveMobj(actor) return 
	end
	
	-- dargging values
	local scale_cal = actor.scale*3
	local val = id*ANGLE_180
	local ang = t.angle + val
	actor.color = t.color
	actor.colorized = t.colorized
	actor.blendmode = t.blendmode

	-- planes movement
	P_FixSetMobjTo(t, actor, FixedMul(cos(ang), scale_cal), FixedMul(sin(ang), scale_cal), 0, val+ANGLE_270)
end

//framework putting it together
local function P_SwitchModelFramework(actor, t, id)
	if not (actor and actor.valid and t and t.valid) then P_RemoveMobj(actor) return end
	
	-- dargging values
	local ang = id*ANGLE_45
	-- planes movement
	P_FixSetMobjTo(t, actor, FixedMul(cos(ang) << 5, actor.scale), FixedMul(sin(ang) << 5, actor.scale), 0, ang+ANGLE_90-t.angle)	
end

local visPlaneType = {
	[1] = function(a) -- Blocks
		P_MarBlockFramework(a, a.target, a.id)
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
		local ramdom = randselection[a.target.ranmsel or 0]
		
		a.sprite = states[mobjinfo[ramdom].spawnstate].sprite
		a.frame = states[mobjinfo[ramdom].spawnstate].frame
		a.scale = FRACUNIT
		P_FixSetMobjTo(a.target, a, 0, 0, 12 << FRACBITS, 0)
	end;
	[6] = function(a) -- Overlay method
		P_FixSetMobjTo(a.target, a, 0, 0, 0, 0)
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

local function blockCollison(actor, toucher)
	
	-- Defining distances
	local pdistance = abs(actor.z - (toucher.z + toucher.height))
	local mobjdistance = abs(toucher.z - (actor.z + actor.height))
	local mobjxydistance = abs(FixedHypot(actor.x, actor.y) - FixedHypot(toucher.x, toucher.y))
	
	-- Player collision
	if toucher.type == MT_PLAYER then
		actor.toucher = toucher

		if pdistance < FRACUNIT>>2 and toucher.z < actor.z and not actor.activated then
			if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM) and actor.blocktype == "brick" and PKZ_Table.disabledSkins[toucher.skin] ~= false then
				actor.bump = true
			else
				if actor.blocktype ~= "brick" then
					if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM)
						actor.smallbig = 2
					else
						actor.smallbig = 1
					end
				end
				actor.activate = true
			end
			actor.activationmethod = "down"		
			local shock = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_BLOCKVIS)
			shock.fuse = 5
			shock.sprite = SPR_PFUF
			shock.frame = G
		end
		
		if toucher.z >= actor.z-FRACUNIT<<3 and actor.z + actor.height > toucher.z and toucher.player and toucher.player.pflags & PF_SPINNING and not actor.activated then
			if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM) and actor.blocktype == "brick" and PKZ_Table.disabledSkins[toucher.skin] ~= false then
				actor.bump = true
			else
				if actor.blocktype ~= "brick" then
					if (toucher.player.powers[pw_shield] == SH_NONE or toucher.player.powers[pw_shield] == SH_MINISHFORM)
						actor.smallbig = 2
					else
						actor.smallbig = 1
					end
				end
				actor.activate = true
			end
			actor.activationmethod = "side"
		end
	elseif toucher.type == MT_SHELL and toucher.z <= actor.z + actor.height-FRACUNIT*5 and toucher.z >= actor.z and (abs(toucher.momx) > 0 or abs(toucher.momy) > 0) then
		if toucher.z <= actor.z + actor.height>>1 then
			actor.activate = true
			actor.activationmethod = "side"			
		end
		actor.toucher = toucher
	else

		-- Register block to actor if any action is required 
		toucher.actblyx = actor
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

addHook("MobjCollide", function(actor, player)
	-- Nukes everything and rmeove object
	if not (player.type == MT_PLAYER and player.state == S_PLAY_ROLL) then return nil end
	if not actor.powfuse then 
		actor.powfuse = TICRATE
		actor.flags = $ &~ MF_SOLID|MF_PUSHABLE
		actor.source = player
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

addHook("MobjCollide", function(actor, player)
	-- Collision Check
	if not (player and player.valid and player.type == MT_PLAYER) then return end
	
	local distance = abs(player.z+1 - (actor.z + actor.height))
	
	if distance < FRACUNIT and player.z > actor.z and not actor.cooldown then
		actor.noted = true
		if actor.shootup == nil then
			actor.shootup = 0
		elseif actor.shootup > 0 then
			player.momz = actor.shootup
			player.state = S_PLAY_SPRING
			actor.shootup = 0
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

local function blockThinker(actor)
	actor.boolLOD = libOpt.LODConsole(actor, libOpt.ITEM_CONST, blockModel, LODblockModel, actor.boolLOD or false)
	actor.numfaces = libOpt.BlockCulling(actor)	

	if (actor.numfaces[6] and not actor.boolLOD) then
		actor.flags2 = $|MF2_DONTDRAW
	else
		actor.flags2 = $ &~ MF2_DONTDRAW
	end

	actor.blockflying = (actor.blockflying == nil and true or $)

	if actor.blocktype == "random" and not (7 & leveltime) then
		actor.ranmsel = P_RandomRange(1, 16)
	end
	
	if actor.flags2 & MF2_AMBUSH and actor.blockflying then
		local newspeed = actor.scale/32
		local speed = FixedHypot(actor.momx, actor.momy)
		if speed then
			actor.angle = R_PointToAngle2(0,0, actor.momx, actor.momy)
		end
		P_InstaThrust(actor, actor.angle, newspeed)
		actor.ztimer = (actor.ztimer ~= nil and (actor.ztimer ~= 105 and $ + 1 or 1) or 1)		
		
		if actor.ztimer > 1 and actor.ztimer < 25 then
			actor.momz = $ + FRACUNIT >> 3
		end
		
		if actor.ztimer > 46 and actor.ztimer < 75 then
			actor.momz = $ - FRACUNIT >> 3
		end

		if not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, actor.info.speed << FRACBITS), actor.y + P_ReturnThrustY(actor, actor.angle, actor.info.speed << FRACBITS), true) then
			actor.angle = $ + ANGLE_180
		end
	end	
	
	if actor and actor.valid then
	
		if actor.blocktype == "brick" then
		
			if actor.bump then
				P_BlockBump(actor, actor.activationmethod or "down")
				if actor.timerblock == 15 then
					actor.momz = 0
					actor.timerblock = nil	
					actor.bump = false
				end
			elseif actor.activate and not actor.bump then
				local zsp = 0
				A_AddNoMPScore(actor, 10, 1)
				
				for i = 1,10 do
					local zsp = (i > 4 and (45 << FRACBITS) or 0)+P_RandomRange(0,4) << FRACBITS
					local debries = P_SpawnMobjFromMobj(actor, 0, 0, zsp, (P_RandomRange(0,1) and MT_COLORMMARDEBRIES or MT_COLORMARDEBRIES))
					debries.color = actor.color
					debries.angle = actor.toucher.angle-ANGLE_135-ANGLE_90*i+P_RandomRange(-8,8)*ANG1
					debries.momz = P_RandomRange(4,7) << FRACBITS
					
					if i % 2 then
						local dust = P_SpawnMobjFromMobj(debries, 20*cos(debries.angle), 20*sin(debries.angle), 20 << FRACBITS, MT_SPINDUST)
						dust.scale = $+actor.scale>>1
					end
					P_Thrust(debries, debries.angle, 2 << FRACBITS)
				
				end
				local pow_brick = P_SpawnMobjFromMobj(actor, 0, 0, actor.height/2, MT_POPPARTICLEMAR)
				pow_brick.scale = $+FRACUNIT >> 1
				S_StartSound(actor.toucher, sfx_marioc)
				P_RemoveMobj(actor)
			end
		end
	
		--if actor.valid and actor.type == MT_QBLOCK and not actor.activated and PKZ_Table and PKZ_Table.current_goldblockcolor then
		--	actor.color = PKZ_Table.current_goldblockcolor
		--end

	
		if actor.valid and actor.activate and not actor.activated then
	
			P_BlockBump(actor, actor.activationmethod or "down")
		
		
			if actor.timerblock == 15 then
		
				actor.momz = 0
				actor.momx = 0
				actor.momy = 0

				actor.blockflying = false
				actor.amountc = actor.amountc > 1 and $ - 1 or $
				
				S_StartSound(actor.toucher, sfx_mario9)
				if (itemselection[actor.picknum][actor.smallbig] ~= MT_DROPCOIN or (actor.ranmsel and randselection[actor.ranmsel])) then
					local itemspawn = P_SpawnMobjFromMobj(actor, 0,0,10 << FRACBITS, (actor.blocktype ~= "random" and itemselection[actor.picknum][actor.smallbig] or randselection[actor.ranmsel]))
					itemspawn.target = actor.toucher
					itemspawn.scale = FRACUNIT
					itemspawn.momx = 3 << FRACBITS
					itemspawn.isInBlock = true
				else
					A_CoinProjectile(actor, 0, 0, actor.toucher)
				end
			
				if actor.amountc and actor.amountc <= 1 then
					actor.activated = true
					actor.boolLOD = true
					
					if actor.blocktype == "qbrick" then
						actor.state = S_BLOCKTOPBUT
						actor.sprite = SPR_M3BL
					end
				end	

				actor.timerblock = nil
			
				if not actor.activated then
					actor.activate = false
					actor.timerblock = 1
				end
			end
		end
	end
end

addHook("MobjThinker", function(actor)
	actor.boolLOD = libOpt.LODConsole(actor, libOpt.ITEM_CONST, blockModel, LODblockModel, actor.boolLOD or false)
	actor.numfaces = libOpt.BlockCulling(actor)	

	if (actor.numfaces[6] and not actor.boolLOD) then
		actor.flags2 = $|MF2_DONTDRAW
	else
		actor.flags2 = $ &~ MF2_DONTDRAW
	end

	if actor.noted == true then
		actor.cooldown = 9
		if not actor.ogpos then
			actor.ogpos = {x = actor.x, y = actor.y, z = actor.z, scale = actor.scale}
		end
		
		actor.timernote = (actor.timernote and $+1 or 1)

		if actor.timernote > 4 and 10 > actor.timernote then

			actor.z = TBSlib.lerp(FRACUNIT/5, actor.z, actor.ogpos.z-16*actor.scale)
		end
		
		if actor.timernote == 8 then
			actor.shootup = 20 << FRACBITS
		end
		
		if actor.timernote == 9 then
			actor.momz = 0
			actor.timernote = 0
			actor.noted = false
		end
	else
		if actor.ogpos then
			actor.z = TBSlib.lerp(FRACUNIT/5, actor.z, actor.ogpos.z)
		end
		
		if actor.cooldown then
			actor.cooldown = $-1
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
	MT_QSBLBRICK
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

addHook("MobjThinker", function(actor)
	//Behavior in block
	if actor.isInBlock then
		actor.momx = 0
		actor.momy = 0
		actor.momz = $ + FRACUNIT/24
		actor.flags = $|MF_NOGRAVITY
	elseif not actor.behsetting or actor.behsetting == 0 then
		actor.flags = $ &~ MF_NOGRAVITY	
	end
	if actor.reserved then
		if not P_IsObjectOnGround(actor) then
			actor.mushfall = true
			if (8 & leveltime) >> 2 then
				actor.flags2 = $|MF2_DONTDRAW
			else
				actor.flags2 = $ &~ MF2_DONTDRAW
			end	
		else
			actor.flags2 = $ &~ MF2_DONTDRAW
			actor.reserved = false
		end
	end
	if actor.redrewarditem then
	    if actor.redrewarditem > 1 then
			if actor.falldowntimer == nil then
				actor.falldowntimer = 1			
			end
		
			if actor.falldowntimer > 0 then
				actor.falldowntimer = $ + 1
			end		
		
			if actor.tracer ~= nil and actor.tracer.valid and actor.falldowntimer <= 70 then
				P_TryMove(actor, actor.tracer.x, actor.tracer.y, true)
				actor.z = actor.tracer.z + 150 << FRACBITS			
			end
		
			actor.momx = 0
			actor.momy = 0
			actor.momz = 0
		
			TBSlib.scaleAnimator(actor, RedCoinItemAnimation)
		
			if actor.falldowntimer == 70 then
				TBSlib.resetAnimator(actor)
				actor.redrewarditem = 1
			end
		else
			actor.momx = 0
			actor.momy = 0		
			actor.momz = -(5 << FRACBITS)
			if P_IsObjectOnGround(actor) then
				actor.redrewarditem = nil
			end
		end
	end
end, tablepowerups)

end



/*
// Cleaner table-based block 
local function thowmpModel(actor, mapthing)
	-- variable from mapthing parameter 
	-- used for colors
	if mapthing.args[0] ~= 0
		actor.colornum = mapthing.args[0]
	else
		actor.colornum = mapthing.extrainfo
	end
	
	local spritepicker = {
		[MT_GREYTHWOMP] = {x = SPR_TWU2, y = SPR_TWU4, z = SPR_TWU1, a = SPR_NULL},
		[MT_BLUETHWOMP] = {x = SPR_TWU7, y = SPR_TWU6, z = SPR_TWU6, a = SPR_TWU6}		
	}
	
	-- base
	actor.state = S_BLOCKVIS
	actor.sprite = spritepicker[actor.type].a
	actor.frame = A|FF_PAPERSPRITE		
	actor.originz = actor.z

	for i = 1,4 do
		local baseSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		baseSpawn.target = actor
		baseSpawn.scale = actor.scale
		baseSpawn.id = i
		baseSpawn.thwomp = true
		baseSpawn.state = S_BLOCKVIS
		if i == 1
			baseSpawn.sprite = spritepicker[actor.type].x
		elseif i == 3
			baseSpawn.sprite = spritepicker[actor.type].y
		else
			baseSpawn.sprite = spritepicker[actor.type].z
		end
		baseSpawn.frame = A|FF_PAPERSPRITE
	end
end


//framework putting it together
local function P_ThwompFramework(actor, t, id)
	if actor and actor.valid and t and t.valid
	
		-- dargging values
		local ang = t.angle-ANGLE_90 + id*ANGLE_90
		actor.angle = ang-ANGLE_90
		actor.color = t.color
	
		-- actor activation states
		if t.activated == true and actor.id == 1
			actor.frame = B|FF_PAPERSPRITE
		else
			actor.frame = A|FF_PAPERSPRITE
		end
	
		-- planes movement
		if t.type == MT_GREYTHWOMP
			if id == 1 or id == 3
				P_TeleportMove(actor, t.x+FixedMul(25/2*cos(ang), actor.scale), t.y+FixedMul(25/2*sin(ang), actor.scale), t.z)
			else
				P_TeleportMove(actor, t.x+FixedMul(28*cos(ang), actor.scale), t.y+FixedMul(28*sin(ang), actor.scale), t.z)			
			end
		else
			P_TeleportMove(actor, t.x+FixedMul(32*cos(ang), actor.scale), t.y+FixedMul(32*sin(ang), actor.scale), t.z)		
		end
	else
		-- Remove planes after removal
		P_RemoveMobj(actor)
	end
end

local function thwompThinker(actor)
	if actor and actor.valid
		if P_LookForPlayers(actor, 200*FRACUNIT, true, false) and actor.active ~= true and not P_IsObjectOnGround(actor)
			actor.activated = true
			actor.active = true
		end
		if actor.activated == true
			actor.momz = $ - FRACUNIT*3/2
			if actor.floorz >= actor.z-FRACUNIT and actor.activated == true
				actor.momz = 0
				for i = 1,8 do
					local par = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
					par.angle = actor.angle+i*ANGLE_45
					par.momx = 10*cos(par.angle)
					par.momy = 10*sin(par.angle)
				end
				actor.activated = false				
			end
		end		
		if actor.activated == false and actor.active == true
			if actor.z < actor.originz
				actor.momz = FRACUNIT*2
			else
				actor.momz = 0
				actor.active = false
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