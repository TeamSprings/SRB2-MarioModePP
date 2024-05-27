local nonwinged = {6, 7}

//Spawner for Wings
//Written by Ace
local function Spawnwings(actor, mapthing)
	//Behavioral setting
	actor.behsetting = (mapthing.args[0] or mapthing.extrainfo) or 0
	local wingsa = (actor.type == MT_FLYINGCOIN and actor.behsetting+1 or actor.behsetting-5)

	//Wings
	if not (wingsa > 0 or actor.type == MT_FLYINGCOIN) then return end

	local wings = P_SpawnMobj(actor.x, actor.y, actor.z, MT_OVERLAY)
	if wingsa == 1 then
		wings.state = S_SMALLWINGS
	else
		wings.state = S_MARIOSTARS
		wings.sprite = SPR_BUBL
		wings.frame = FF_TRANS50|FF_FULLBRIGHT|4
		wings.spriteyoffset = -12 << FRACBITS
		wings.spritexscale = 3 << FRACBITS >> 1
		wings.spriteyscale = wings.spritexscale
	end

	wings.target = actor
end

addHook("MapThingSpawn", Spawnwings, MT_FLYINGCOIN)

local function flight(mo)
	mo.flags = $|MF_NOGRAVITY

	local anglesin = (180 & leveltime)*ANG2
	mo.momz = P_RandomRange(4, 6)*sin(anglesin)
	mo.angle = $ + P_RandomRange(-2, 2)*ANG1

	if not P_TryMove(mo,
	mo.x + P_ReturnThrustX(mo, mo.angle, mo.info.speed << FRACBITS),
	mo.y + P_ReturnThrustY(mo, mo.angle, mo.info.speed << FRACBITS), true) then
		mo.angle = $ + ANGLE_180
	end
end

// Flying Coin Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not (actor.spawnpoint and actor.spawnpoint.args[1] > 0) then
		local newspeed = actor.scale << 2
		local speed = FixedHypot(actor.momx, actor.momy)
		if speed then
			actor.angle = R_PointToAngle2(0,0, actor.momx, actor.momy)
		end
		P_InstaThrust(actor, actor.angle, newspeed)
	end

	flight(actor)
end, MT_FLYINGCOIN)


// Blue coin
// Written by Ace

local callspawncoins = 0

local TIER_1_FASING_COIN = 2*TICRATE
local TIER_2_FASING_COIN = 5*TICRATE

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, libOpt.ITEM_CONST, true, false) == false then return end
	if not (a.activated == true) then return end
	callspawncoins = a.spawnpoint.args[3] or a.spawnpoint.angle
end, MT_PSWITCH)

local function A_BlueCoinSpawner(a, var1)
	local bluecoinspawn = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_BLUECOIN)
	if var1 == 1 then
		bluecoinspawn.fuse = 10*TICRATE
	end
end

addHook("MobjThinker", function(actor)
	if actor.fuse then
		local phase = false
		if actor.fuse < TIER_2_FASING_COIN then
			if actor.fuse < TIER_1_FASING_COIN then
				phase = (actor.fuse % 2)
			else
				phase = (actor.fuse % 6)/3
			end
		end
		actor.flags2 = phase and $|MF2_DONTDRAW or $ &~ MF2_DONTDRAW
	end
end, MT_BLUECOIN)

addHook("MobjFuse", function()
	callspawncoins = 0
end, MT_BLUECOIN)

addHook("MobjThinker", function(actor)
	if P_LookForPlayers(actor, libOpt.ITEM_CONST, true, false) == false then return end
	if actor.spawnpoint.extrainfo == 1 or actor.spawnpoint.args[0] > 0 then
		if (callspawncoins == actor.spawnpoint.angle) or (actor.spawnpoint.args[0] == callspawncoins) then
			A_BlueCoinSpawner(actor, 1)
			P_RemoveMobj(actor)
		end
	else
		A_BlueCoinSpawner(actor)
		P_RemoveMobj(actor)
	end
end, MT_BLUECOINSPAWNER)

local function spawnBlueCoins(line,actor,sector)
	if callspawncoins == nil or callspawncoins ~= line.tag
		callspawncoins = line.tag
	end
end

addHook("LinedefExecute", spawnBlueCoins, "CALCOIN")

// Red coin
// Written by Ace

local timer_redcoins = 0
local callsredcoins = 0
local redcoincount = 0


addHook("MobjThinker", function(actor)
	if actor.fuse then
		local phase = false
		if actor.fuse < TIER_2_FASING_COIN then
			if actor.fuse < TIER_1_FASING_COIN then
				phase = (actor.fuse % 2)
			else
				phase = (actor.fuse % 6)/3
			end
		end
		actor.flags2 = phase and $|MF2_DONTDRAW or $ &~ MF2_DONTDRAW
	end
end, MT_REDCOIN)

local function A_RedCoinSpawn(actor, var1)
	local redcoinspawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_REDCOIN)

	if var1 ~= 1 then return end
	redcoinspawn.fuse = 10*TICRATE+timer_redcoins
	redcoinspawn.extrainfo = actor.spawnpoint and (actor.spawnpoint.args[1] or actor.spawnpoint.extrainfo) or 0
end

addHook("MobjThinker", function(actor)
	//Tag checking for UDMF/Binary
	actor.redcoinch = actor.spawnpoint.args[1] or actor.spawnpoint.extrainfo
	if actor.redcoinch > 0 then
		if actor.redcoinch == callsredcoins then
			A_RedCoinSpawn(actor, 1)
			P_RemoveMobj(actor)
		end
	else
		A_RedCoinSpawn(actor, 0)
		P_RemoveMobj(actor)
	end
end, MT_SPAWNERREDCOIN)

local REDCIRCLE_DOWNSCALE = FRACUNIT/(TICRATE/3)
--local REDCIRCLE_ROTATION = 22*ANG1

addHook("MobjThinker", function(actor)
	if P_LookForPlayers(actor, libOpt.ITEM_CONST, true, false) == false then return end
	actor.rollangle = $ + ANG15

	if actor.fuse then
		actor.scale = $-REDCIRCLE_DOWNSCALE
		--actor.angle = $+REDCIRCLE_ROTATION
	end
end, MT_REDCOINCIRCLE)

addHook("TouchSpecial", function(actor, mo)
	//Tag checking for UDMF/Binary
	if not (actor.health and actor.spawnpoint) then return true end
    actor.redcoinca = actor.spawnpoint.args[0] or actor.spawnpoint.extrainfo
	if callsredcoins ~= actor.redcoinca then
		callsredcoins = actor.redcoinca
		S_StartSound(mo, sfx_recwi0)
		actor.fuse = TICRATE/3
		actor.spriteyoffset = $-(64 << FRACBITS)
		P_SetOrigin(actor, actor.x, actor.y, actor.z+actor.scale<<6)
		timer_redcoins = actor.spawnpoint.args[1]
	end
	return true
end, MT_REDCOINCIRCLE)

local redrewards = {
	MT_NEWFIREFLOWER;
	MT_ICYFLOWER;
	MT_LIFESHROOM;
	MT_NUKESHROOM;
}

addHook("MobjDeath", function(a, mo, so)
	redcoincount = (redcoincount < 8 and $ + 1 or 0)
	callsredcoins = 0

	local spawnred = P_SpawnMobjFromMobj(a, 0,0,10 << FRACBITS, MT_BLOCKVIS)
	spawnred.state = S_INVISIBLE
	spawnred.sprite = SPR_RELT
	spawnred.ogframe = redcoincount-1
	spawnred.ticsf = 0
	spawnred.ticstr = 0
	spawnred.frame = redcoincount-1
	spawnred.fuse = 2*TICRATE
	spawnred.sprmodel = 99
	spawnred.customfunc = function(obj)
		if obj.fuse <= TICRATE+TICRATE >> 1 then
			obj.momz = 0
			if (obj.fuse % 16) >> 3 then
				obj.scale = TBSlib.lerp(FRACUNIT >> 1, obj.scale, FRACUNIT+FRACUNIT >> 2)
			else
				obj.scale = TBSlib.lerp(FRACUNIT >> 1, obj.scale, FRACUNIT)
			end
			if not (obj.fuse % 3) then
				obj.ticsf = (obj.ticsf+1) % 4
			end
			if (obj.fuse <= 9) then
				obj.ticstr = min(obj.ticstr+1, 9)
			end
			obj.frame = obj.ogframe+(obj.ticsf << 3)+obj.ticstr << FF_TRANSSHIFT
		else
			obj.momz = TBSlib.lerp(((obj.fuse-TICRATE+TICRATE >> 1) << FRACBITS)/TICRATE, 0, (2 << FRACBITS)+(FRACUNIT >> 2) << 1)
		end
	end
	S_StartSound(mo, sfx_recwi1+(redcoincount-1))

	if not (redcoincount >= 8) then return end

	local rewardspawn = P_SpawnMobjFromMobj(a, 0,0,150 << FRACBITS, redrewards[P_RandomRange(1, #redrewards)])
	rewardspawn.extrainfo = 0
	rewardspawn.tracer = so
	rewardspawn.redrewarditem = 2
	redcoincount = 0
end, MT_REDCOIN)

addHook("MapChange", function()
	redcoincount = 0
end)


for _,multicoins in pairs({
	MT_FIVECOIN,
	MT_TENCOIN,
	MT_THIRTYCOIN
	}) do


addHook("MapThingSpawn", function(actor, mapthing)
	-- spawn sides
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = actor
		sideSpawn.scale = actor.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.frame = actor.frame
		if actor.type == MT_FIVECOIN then
			sideSpawn.sprite = SPR_5COI
		elseif actor.type == MT_TENCOIN then
			sideSpawn.sprite = SPR_10CO
		else
			sideSpawn.sprite = SPR_30CO
		end
	end
end, multicoins)

local COINCONSTANGLE = ANG1*(360/48)

addHook("MobjThinker", function(actor)
	A_AttractChase(actor)

	if not libOpt.ConsoleCameraBool(actor, libOpt.ITEM_CONST) and not (4 & leveltime) then return end
	actor.angle = $-COINCONSTANGLE
end, multicoins)


end
