local nonwinged = {6, 7}

//Spawner for Wings
//Written by Ace
local function Spawnwings(mo, mapthing)
	//Behavioral setting
	mo.behsetting = (mapthing.args[0] or mapthing.extrainfo) or 0
	local wingsa = (mo.type == MT_FLYINGCOIN and mo.behsetting+1 or mo.behsetting-5)

	//Wings
	if not (wingsa > 0 or mo.type == MT_FLYINGCOIN) then return end

	mo.wings = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
	local wings = mo.wings
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

	wings.target = mo
end

local bubblespeed = ANG1*6
local bubblescale = 3 << FRACBITS >> 1

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
addHook("MobjThinker", function(mo)
	if not (mo.spawnpoint and mo.spawnpoint.args[1] > 0) then
		local newspeed = mo.scale << 2
		local speed = FixedHypot(mo.momx, mo.momy)
		if speed then
			mo.angle = R_PointToAngle2(0,0, mo.momx, mo.momy)
		end
		P_InstaThrust(mo, mo.angle, newspeed)
	end

	if mo.wings then
		if mo.health > 0 then
			if mo.wings.sprite == SPR_BUBL then
				local ang = leveltime*bubblespeed
				mo.wings.spritexscale = bubblescale+cos(ang)/8
				mo.wings.spriteyscale = bubblescale+sin(ang)/8
			end
		elseif mo.wings.valid then
			if mo.wings.sprite == SPR_BUBL then
				mo.wings.scale = mo.wings.scale/16
			else
				for i = 1, 2 do
					local wings = P_SpawnMobjFromMobj(mo.wings, 0,0,-(20<<FRACBITS), MT_POPPARTICLEMAR)
					wings.fallingwings = true
					wings.state = S_INVISIBLE
					wings.sprite = states[S_SMALLWINGS].sprite
					wings.frame = F|FF_PAPERSPRITE|(i == 2 and FF_HORIZONTALFLIP or 0)
				end
				P_RemoveMobj(mo.wings)
			end
		end
	elseif mo.health > 0 then
		mo.wings = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
		mo.wings.state = S_SMALLWINGS
		mo.target = mo
	end

	flight(mo)
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

addHook("MobjThinker", function(mo)
	if mo.fuse then
		local phase = false
		if mo.fuse < TIER_2_FASING_COIN then
			if mo.fuse < TIER_1_FASING_COIN then
				phase = (mo.fuse % 2)
			else
				phase = (mo.fuse % 6)/3
			end
		end
		mo.flags2 = phase and $|MF2_DONTDRAW or $ &~ MF2_DONTDRAW
	end
end, MT_BLUECOIN)

addHook("MobjFuse", function()
	callspawncoins = 0
end, MT_BLUECOIN)

addHook("MobjThinker", function(mo)
	if P_LookForPlayers(mo, libOpt.ITEM_CONST, true, false) == false then return end
	if mo.spawnpoint.extrainfo == 1 or mo.spawnpoint.args[0] > 0 then
		if (callspawncoins == mo.spawnpoint.angle) or (mo.spawnpoint.args[0] == callspawncoins) then
			A_BlueCoinSpawner(mo, 1)
			P_RemoveMobj(mo)
		end
	else
		A_BlueCoinSpawner(mo)
		P_RemoveMobj(mo)
	end
end, MT_BLUECOINSPAWNER)

local function spawnBlueCoins(line,mo,sector)
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


addHook("MobjThinker", function(mo)
	if mo.fuse then
		local phase = false
		if mo.fuse < TIER_2_FASING_COIN then
			if mo.fuse < TIER_1_FASING_COIN then
				phase = (mo.fuse % 2)
			else
				phase = (mo.fuse % 6)/3
			end
		end
		mo.flags2 = phase and $|MF2_DONTDRAW or $ &~ MF2_DONTDRAW
	end
end, MT_REDCOIN)

local function A_RedCoinSpawn(mo, var1)
	local redcoinspawn = P_SpawnMobjFromMobj(mo, 0,0,0, MT_REDCOIN)

	if var1 ~= 1 then return end
	redcoinspawn.fuse = 10*TICRATE+timer_redcoins
	redcoinspawn.extrainfo = mo.spawnpoint and (mo.spawnpoint.args[1] or mo.spawnpoint.extrainfo) or 0
end

addHook("MobjThinker", function(mo)
	//Tag checking for UDMF/Binary
	mo.redcoinch = mo.spawnpoint.args[1] or mo.spawnpoint.extrainfo
	if mo.redcoinch > 0 then
		if mo.redcoinch == callsredcoins then
			A_RedCoinSpawn(mo, 1)
			P_RemoveMobj(mo)
		end
	else
		A_RedCoinSpawn(mo, 0)
		P_RemoveMobj(mo)
	end
end, MT_SPAWNERREDCOIN)

local REDCIRCLE_DOWNSCALE = FRACUNIT/(TICRATE/3)
--local REDCIRCLE_ROTATION = 22*ANG1

addHook("MobjThinker", function(mo)
	if P_LookForPlayers(mo, libOpt.ITEM_CONST, true, false) == false then return end
	mo.rollangle = $ + ANG15

	if mo.fuse then
		mo.scale = $-REDCIRCLE_DOWNSCALE
		--mo.angle = $+REDCIRCLE_ROTATION
	end
end, MT_REDCOINCIRCLE)

addHook("TouchSpecial", function(mo, touch)
	//Tag checking for UDMF/Binary
	if not (mo.health and mo.spawnpoint) then return true end
    mo.redcoinca = mo.spawnpoint.args[0] or mo.spawnpoint.extrainfo
	if callsredcoins ~= mo.redcoinca then
		callsredcoins = mo.redcoinca
		S_StartSound(mo, sfx_recwi0)
		mo.fuse = TICRATE/3
		mo.spriteyoffset = $-(64 << FRACBITS)
		P_SetOrigin(mo, mo.x, mo.y, mo.z+mo.scale<<6)
		timer_redcoins = mo.spawnpoint.args[1]
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


addHook("MapThingSpawn", function(mo, mapthing)
	-- spawn sides
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(mo, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = mo
		sideSpawn.scale = mo.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.frame = mo.frame
		if mo.type == MT_FIVECOIN then
			sideSpawn.sprite = SPR_5COI
		elseif mo.type == MT_TENCOIN then
			sideSpawn.sprite = SPR_10CO
		else
			sideSpawn.sprite = SPR_30CO
		end
	end
end, multicoins)

local COINCONSTANGLE = ANG1*(360/48)

addHook("MobjThinker", function(mo)
	A_AttractChase(mo)

	if not libOpt.ConsoleCameraBool(mo, libOpt.ITEM_CONST) and not (4 & leveltime) then return end
	mo.angle = $-COINCONSTANGLE
end, multicoins)


end
