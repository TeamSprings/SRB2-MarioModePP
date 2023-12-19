/* 
		Pipe Kingdom Zone's Collectable Objects - think_collect.lua

Description:
Scripts needed on special collectable objects

Contributors: Skydusk, Krabs(Checkpoints)
@Team Blue Spring 2024

Contains:
	SMS Alfredo - Shelmet; Mushroom Movement Thinker
*/

// Mushroom thinker... obvi.. obviousl.. fuck
// Written by Ace
local PwThinkers = {
	-- invidiual settings
	
	static = function(a)
		a.momx = 0
		a.momy = 0
		//Transparent Shroom		
		if a.behsetting == 4 then
			a.frame = $ | FF_TRANS70
			a.flags = $ | MF_NOGRAVITY		
		end
		//Invisible Shroom		
		if a.behsetting == 5 then
			a.sprite = SPR_NULL
			a.flags = $ | MF_NOGRAVITY		
		end
	end,
	
	bunnyhop = function(a)
		if P_IsObjectOnGround(a) then
			a.z = $ + P_MobjFlip(a)
			P_SetObjectMomZ(a, 4 << FRACBITS, false)
		end
	end,
	
	flying = function(a)
		a.flags = $|MF_NOGRAVITY

		local anglesin = (180 & leveltime)*ANG2	
		a.momz = P_RandomRange(4, 6)*sin(anglesin)
		a.angle = $ + P_RandomRange(-2, 2)*ANG1
		
		if not P_TryMove(a, a.x + P_ReturnThrustX(a, a.angle, a.info.speed << FRACBITS), a.y + P_ReturnThrustY(a, a.angle, a.info.speed << FRACBITS), true) then
			a.angle = $ + ANGLE_180
		end		
	end,

}

local MushroomSettings = {
	-- functions
	[0]	= function(a) return end,
	[1]	= function(a) PwThinkers.static(a) end,
	[2] = function(a) PwThinkers.bunnyhop(a) end,
	[3] = function(a) a.scale = a.spawnpoint.scale*3/2 end,
	[4] = function(a) PwThinkers.static(a) end,
	[5] = function(a) PwThinkers.static(a) end,
	[6] = function(a) PwThinkers.flying(a) end,
	[7] = function(a) PwThinkers.flying(a) end,
}

local MushroomAnimation = {
	-- Lively mushroom animation into itemholder
	[0] = {offscale_x = 0, offscale_y = 0, tics = 4, nexts = 1},
	[1] = {offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offscale_x = -(FRACUNIT >> 3), offscale_y = (FRACUNIT >> 4), tics = 4, nexts = 3},
	[3] = {offscale_x = (FRACUNIT >> 3), offscale_y = -(FRACUNIT >> 4), tics = 3, nexts = 0},	
}

local function MushThinker(a)
	if a.redrewarditem then return end
	
	//Normal behavior
	local speed = FixedHypot(a.momx, a.momy)
	local newspeed = a.scale << 2
	
	if speed then
		TBSlib.scaleAnimator(a, MushroomAnimation)
		a.angle = R_PointToAngle2(0,0, a.momx, a.momy)
	end
	
	P_InstaThrust(a, a.angle, newspeed)
	//Behaviorselect
	if not (a.redrewarditem or a.reserved or a.mushfall) then
		MushroomSettings[a.behsetting and a.behsetting or 0](a)
	end
end

local POISONDIST = 728<<FRACBITS

addHook("MobjThinker", function(a)
	if a.redrewarditem then return end

	//Normal behavior
	local speed = FixedHypot(a.momx, a.momy)
	local newspeed = a.scale << 2
	
	if speed then
		TBSlib.scaleAnimator(a, MushroomAnimation)

		local player = P_LookForPlayers(a, POISONDIST, true, false)
		if player then
			a.angle = TBSlib.reachAngle(a.angle, R_PointToAngle2(a.x, a.y, a.target.x, a.target.y), ANG10) 
		else
			a.angle = R_PointToAngle2(0,0, a.momx, a.momy)		
		end
	end
	
	P_InstaThrust(a, a.angle, newspeed)
end, MT_POISONSHROOM)

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

// Follow Thinker for Wings
// Written by Ace

local capecor = {
	[1] = { 22, 10;},
	[2] = { -10, 11;},
	[3] = { 12, 0;},
	[4] = { 34, 11;},
	[5] = { 22, 0;},
	[6] = { 22, 32;},
	[7] = { 0, -11;},
}

addHook("MobjThinker", function(actor)
	if (actor and actor.valid and actor.target and actor.target.valid and actor.target.health > 0) then
		local target = actor.target
		local set = (actor.capeset and actor.capeset or 5)
	
		states[S_WIDEWINGS].frame = (set == 3 and A|FF_ANIMATE|FF_PAPERSPRITE or A|FF_ANIMATE)
		if capecor[set] then
			actor.angle = target.angle + ANGLE_90
			P_MoveOrigin(actor, target.x-(capecor[set][1] or 0)*cos(target.angle), target.y-(capecor[set][1] or 0)*sin(target.angle), target.z+(capecor[set][2] << FRACBITS or 0))	
		end
	else
		P_RemoveMobj(actor)
	end
end, MT_WIDEWINGS)



// Star thinker
// Star bunnyhops or not...
// Written by Ace
local StarSettings = {
	-- functions
	[1]	= function(a) PwThinkers.static(a) end;
	[2] = function(a) a.scale = a.spawnpoint.scale*3>>1 end;
}

addHook("MobjThinker", function(a)
	//Behavioral setting
	if a.behsetting == nil then
		if a.spawnpoint ~= nil then
			a.behsetting = a.spawnpoint.extrainfo or a.spawnpoint.args[0]
		else
			a.behsetting = a.extrainfo or 0
		end
		a.dispoffset = $+1
	end
	
	//Normal behavior
	if a.isInBlock == true then
		a.momx = 0
		a.momy = 0
		a.momz = $ + FRACUNIT/24
		a.flags = $|MF_NOGRAVITY
	else
		local newspeed = 5*a.scale
		local speed = FixedHypot(a.momx, a.momy)
		if speed
			a.angle = R_PointToAngle2(0,0, a.momx, a.momy)
		end
		P_InstaThrust(a, a.angle, newspeed)
		a.flags = $ &~ MF_NOGRAVITY
	end
	
	if (8 & leveltime) >> 2
		local poweruppar = P_SpawnMobjFromMobj(a, P_RandomRange(-16,16) << FRACBITS, P_RandomRange(-16,16) << FRACBITS, P_RandomRange(0,32) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = a.scale
		poweruppar.color = SKINCOLOR_AETHER
		poweruppar.fuse = TICRATE
	end
	
	A_GhostMe(a)
	if P_IsObjectOnGround(a)
		a.z = $ + P_MobjFlip(a)
		P_SetObjectMomZ(a, 12 << FRACBITS, false)
	end
	
	if not (a.behsetting or a.behsetting == 1 or a.behsetting == 2) then return end
	StarSettings[a.behsetting](a)
	
end, MT_STARMAN)

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
		
	PwThinkers.flying(actor)
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

// Shelmet Power-Up
// Written by SMS Alfredo

addHook("MobjThinker", function(mobj)
	if mobj.reactiontime == 0 then
		mobj.reactiontime = $+1
		mobj.scale = $*5>>2
		mobj.scalespeed = $*2
		mobj.threshold = 1
	end
	mobj.sprite = SPR_SHMT
	if mobj.flags2 & MF2_AMBUSH then
		mobj.frame = 1
	else
		mobj.frame = 0
	end
	if not mobj.health then
		mobj.rollangle = $+ANGLE_11hh
		mobj.momz = $-(P_GetMobjGravity(mobj) >> 1)
		return
	end
	if mobj.tracer and mobj.tracer.valid and mobj.tracer.player then
		local mo = mobj.tracer
		local player = mobj.tracer.player
		
		if not mo.health then
			P_KillMobj(mobj)
			mobj.tracer = nil
			return
		end
		
		if player.speed and P_IsObjectOnGround(mo) then
			mobj.rollangle = $+(max(min(player.speed,32 << FRACBITS),6 << FRACBITS)*mobj.threshold<<5)
			if mobj.rollangle > ANGLE_11hh then
				mobj.threshold = -1
			elseif mobj.rollangle < -1*ANGLE_11hh then
				mobj.threshold = 1
			end
		else
			mobj.rollangle = $*99/100
		end
		mobj.destscale = mo.scale*5>>2
		mobj.angle = player.drawangle
		
		local multiplier = 16
		if ((mo.skin == "tails" and player.panim != PA_ABILITY) or mo.skin == "amy"
		or mo.skin == "fang") and not (player.pflags&PF_SPINNING)
		and not (player.pflags&PF_JUMPED and not (player.pflags&PF_NOJUMPDAMAGE)) then
			multiplier = 24
		end
		
		if (mo.eflags & MFE_VERTICALFLIP) then
			mobj.eflags = $|MFE_VERTICALFLIP
			mobj.flags2 = $|MF2_OBJECTFLIP
			mobj.z = mo.z + (mo.scale*multiplier)
		else
			mobj.eflags = $ & ~MFE_VERTICALFLIP
			mobj.flags2 = $ & ~MF2_OBJECTFLIP
			mobj.z = mo.z + mo.height - (mo.scale*multiplier)
		end
		
		if displayplayer.valid then
			P_MoveOrigin(mobj,mo.x-P_ReturnThrustX(nil,displayplayer.cmd.angleturn<<16,1),
			mo.y-P_ReturnThrustY(nil,displayplayer.cmd.angleturn<<16,1),mobj.z)
		else
			P_MoveOrigin(mobj,mo.x-P_ReturnThrustX(nil,mobj.player.cmd.angleturn<<16,1),
			mo.y-P_ReturnThrustY(nil,mobj.player.cmd.angleturn<<16,1),mobj.z)
		end
	end
end, MT_SHELMET)

addHook("MobjDeath", function(mobj)
	if mobj.tracer and mobj.tracer.valid and mobj.tracer.shelmet
	and mobj.tracer.shelmet == mobj then
		mobj.tracer.shelmet = nil
	end
	mobj.tracer = nil
	mobj.flags = $&~MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT&~MF_SPECIAL
	mobj.fuse = TICRATE*3
	P_SetObjectMomZ(mobj,4 << FRACBITS,false)
	S_StartSound(mobj, sfx_shlmls)
end, MT_SHELMET)

addHook("MobjDamage", function(target,inflictor,source,damage,damagetype)
	if target and target.valid and target.shelmet and target.shelmet.valid
	and target.player and not (target.player.powers[pw_shield] & SH_NOSTACK)
	and not (damagetype&DMG_DEATHMASK) then
		target.player.powers[pw_flashing] = TICRATE << 1
		target.shelmet.tracer = nil
		P_KillMobj(target.shelmet)
		target.shelmet = nil
		return true
	end
end, MT_PLAYER)

addHook("TouchSpecial", function(special, toucher)
	if not (toucher and toucher.valid and toucher.player
	and not toucher.player.bot) return end
	if toucher.shelmet and toucher.shelmet.valid then
		P_KillMobj(toucher.shelmet)
	end
	special.tracer = toucher
	toucher.shelmet = special
	special.flags = $|MF_NOGRAVITY|MF_NOCLIPHEIGHT&~MF_SPECIAL
	P_SetScale(special, special.scale*3>>1)
	if special.flags2&MF2_AMBUSH then
		S_StartSound(special, sfx_spnget)
	else
		S_StartSound(special, sfx_btlget)
	end
	return true
end, MT_SHELMET)

local shelmentbounce = function(toucher, special)
	if toucher and toucher.valid and toucher.player
	and toucher.shelmet and toucher.shelmet.valid
	and special and special.valid
	and special.z - special.scale <= toucher.z + toucher.height + toucher.scale*8
	and special.z + special.height + special.scale >= toucher.z + toucher.scale*-8
	and ((toucher.player.pflags&PF_SPINNING and P_IsObjectOnGround(toucher))
	or (special.z > toucher.z+(toucher.height/2) and not (toucher.eflags & MFE_VERTICALFLIP))
	or (special.z < toucher.z+(toucher.height/2) and toucher.eflags & MFE_VERTICALFLIP)) then
		if not special.health return false end
		
		local spike = false
		
		local i=0 while i<8 and special and special.valid
			local ghost = P_SpawnGhostMobj(special)
			P_SetObjectMomZ(ghost, FRACUNIT<<1, false)
			P_InstaThrust(ghost,ANGLE_45*i,4*ghost.scale)
			ghost.sprite = SPR_NSTR
			ghost.frame = 7
			ghost.scale = $/4
			ghost.fuse = TICRATE>>1
			i=$+1
		end
		
		if special.flags&MF_SHOOTABLE or special.flags & MF_MISSILE then
			P_DoSpring(toucher.shelmet, special)
			local flags = toucher.flags
			local momz = toucher.momz
			toucher.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING&~MF_SPECIAL
			P_SetObjectMomZ(toucher, 12*FRACUNIT, false)
			special.momz = toucher.momz
			toucher.momz = momz
			if toucher.eflags & MFE_VERTICALFLIP then
				special.z = toucher.z-special.height-toucher.scale
			else
				special.z = toucher.z+toucher.height+toucher.scale
			end
			toucher.flags = flags
			
			if special.flags & MF_MISSILE then
				special.target = toucher
				special.flags = $&~MF_NOGRAVITY
			end
			
			if toucher.shelmet.flags2 & MF2_AMBUSH and (special.flags & MF_SHOOTABLE or special.flags & MF_MISSILE) then
				if special.flags & MF_MISSILE then
					P_KillMobj(special)
				else
					P_DamageMobj(special)
				end
				S_StartSound(toucher, sfx_spnhit)
				spike = true
			end
		elseif not P_IsObjectOnGround(toucher) then
			P_DoSpring(toucher.shelmet, toucher)
		end
			
		S_StopSoundByID(toucher, sfx_btlht1)
		S_StopSoundByID(toucher, sfx_btlht2)
		S_StopSoundByID(toucher, sfx_btlht3)
		if not spike then
			if P_RandomChance(FRACUNIT/2) then
				S_StartSound(toucher, sfx_btlht1)
			elseif P_RandomChance(FRACUNIT/2) then
				S_StartSound(toucher, sfx_btlht2)
			else
				S_StartSound(toucher, sfx_btlht3)
			end
		end
		
		P_SetScale(toucher.shelmet, toucher.scale*5/4*3/2)
		return false
	end
end

addHook("ShouldDamage", shelmentbounce, MT_PLAYER)

addHook("PlayerCanDamage", function(player,mobj)
	return shelmentbounce(player.mo,mobj)
end)

local PowerMoonNum = 0

//Amount of things to add shit
addHook("PlayerSpawn", function(player)
	PowerMoonNum = 0
	for thing in mobjs.iterate() do
		if thing.type == MT_MARPOWERMOON then
			PowerMoonNum = $+1
		end
	end	
end)

addHook("MobjThinker", function(actor)
	actor.angle = $ + ANG1*3
	if (8 & leveltime)/6 then
		local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(0,64) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = actor.scale
		poweruppar.color = SKINCOLOR_GOLD
		poweruppar.fuse = TICRATE
	end	
end, MT_MARPOWERMOON)

addHook("MobjRemoved", function(actor)
	PowerMoonNum = $-1
	if PowerMoonNum <= 0 then
		G_ExitLevel()
	end
end, MT_MARPOWERMOON)

// Grouping of Items
// Thanks Amperbee!

for _,shroms in pairs({
	MT_LIFESHROOM,
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
	MT_ELEMENTALSHROOM,
	MT_CLOUDSHROOM,
	MT_FLAMESHROOM,
	MT_BUBBLESHROOM,
	MT_THUNDERSHROOM,
	MT_PITYSHROOM,
	MT_PINKSHROOM,
	MT_GOLDSHROOM,
	MT_MINISHROOM,
	MT_REDSHROOM
	}) do

addHook("MobjThinker", MushThinker, shroms)
addHook("MapThingSpawn", Spawnwings, shroms)
end

addHook("MapThingSpawn", Spawnwings, MT_POISONSHROOM)

// New checkpoint system
// script by Krabs

addHook("TouchSpecial", function(post, toucher)
	local player = toucher.player
	
	if player.bot
	or player.starpostnum >= post.health then
		return true
	end
	
	if CV_FindVar("pkz_debug").value == 1
		print(player.starpostnum.." "..post.health)
		print("\x82".."hit starpost omg cool")
	end
	
	local coopstarposts = CV_FindVar("coopstarposts")
	if (coopstarposts.value >= 1 and gametype == GT_COOP and netgame) or splitscreen then //In splitscreen, we'll just have the checkpoint help both players.
		//print("coop starposts")
		for player2 in players.iterate do
			if player2 == player or player2.bot then continue end
			player2.starposttime = leveltime
			player2.starpostx = toucher.x >> FRACBITS
			player2.starposty = toucher.y >> FRACBITS
			player2.starpostz = post.z >> FRACBITS
			player2.starpostangle = post.angle + ANGLE_270
			player2.starpostscale = toucher.destscale
			
			if (post.flags2 & MF2_OBJECTFLIP) then
				player2.starpostscale = $ * -1
				player2.starpostz = $ + post.height >> FRACBITS
			end
			
			player2.starpostnum = post.health
			
			if coopstarposts == 2
			and (player2.playerstate == PST_DEAD or player2.spectator)
			and player2.lives then
				P_SpectatorJoinGame(player2)
			end
		end
	end
	
	if player.powers[pw_shield] == SH_NONE and PKZ_Table.disabledSkins[toucher.skin] == nil and player.mo and player.mo.valid then
		A_MarioPain(player.mo, SH_NONE, SH_BIGSHFORM, 5)
	end

	for i = 0,4 do
		local offset_x = (i<<4)-32
		local star_x = offset_x*cos(post.angle)
		local star_y = offset_x*sin(post.angle)
		
		local star_list_1 = P_SpawnMobjFromMobj(post, star_x, star_y, 37 << FRACBITS, MT_POPPARTICLEMAR)
		star_list_1.state = S_INVINCSTAR
		star_list_1.color = toucher.color
		star_list_1.fuse = TICRATE
		
		local star_list_2 = P_SpawnMobjFromMobj(post, star_x, star_y, 49 << FRACBITS, MT_POPPARTICLEMAR)
		star_list_2.state = S_INVINCSTAR
		star_list_2.color = toucher.color
		star_list_2.fuse = TICRATE
	end
	
	player.starposttime = leveltime
	player.starpostx = toucher.x >> FRACBITS
	player.starposty = toucher.y >> FRACBITS
	player.starpostz = post.z >> FRACBITS
	player.starpostangle = post.angle + ANGLE_270
	player.starpostscale = toucher.destscale
	
	
	if (post.flags2 & MF2_OBJECTFLIP) then
		player.starpostscale = $ * -1
		player.starpostz = $ + post.height >> FRACBITS
	end
	
	player.starpostnum = post.health
	S_StartSound(toucher, sfx_marioe)
	
	return true
end, MT_CHECKPOINTBAR)

addHook("MapThingSpawn", function(mo, mapthing)
	//Tag checking for UDMF/Binary -- added by Ace
	mo.health = mapthing.args[0] or mapthing.extrainfo 
	if CV_FindVar("pkz_debug").value == 1
		print("\x82".."new post:".."\x80"..mo.health)
	end	
end, MT_CHECKPOINTBAR)

addHook("MobjThinker", function(mo)
	if consoleplayer and consoleplayer.valid and consoleplayer.starpostnum >= mo.health and not (mo.flags2 & MF2_DONTDRAW) then
		if CV_FindVar("pkz_debug").value == 1
			print("\x82".."post gone:".."\x80"..mo.health)
		end
		mo.flags2 = $ | MF2_DONTDRAW
	end
end, MT_CHECKPOINTBAR)

//  Not so great Dragon Coin saving system
// To do: Fix other states' transparency
//  Made by Ace 
local confirmedreset = 0
local dragoncointag = {}
local dgcoincount = {
	[0] = PKZ_Table.dragonCoins, // current amount
	[1]	= PKZ_Table.maxDrgCoins,// fixed total amount, also forces to not overreach wanted number
}



COM_AddCommand("pkz_dragonlist", function(player)
	CONS_Printf(player, "\x82".."New Mario Mode debug list - DRAGON COINS:")
	for i = 1,PKZ_Table.maxDrgCoins do
		CONS_Printf(player, i+" is "+PKZ_Table.dragonCoinTags[i])
	end
end, COM_LOCAL)

COM_AddCommand("pkz_dragonreset", function(player)
	if confirmedreset == 1
		CONS_Printf(player, "\x85".."WARNING:".."\x80".." Reset of dragon coin list was successful - Map restart is required for restart to take effect")
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
		confirmedreset = 0		
	else
		CONS_Printf(player, "\x85".."WARNING:".."\x80".." Are you sure you want to reset your entire progress? Type command again for confirmation.")
		confirmedreset = 1
	end
end, COM_LOCAL)

// Upon Dragon Coin's spawn... change coloring and make variable signaling this coin was collected
addHook("MapThingSpawn", function(actor, mapthing)
	//Tag checking for UDMF/Binary
	local vanilla_coin = 0
	
	if mapthing.args[1] then
		actor.dragtag = mapthing.args[1]
	else
		actor.dragtag = mapthing.angle
	end
		
	if PKZ_Table.levellist[gamemap] then
		vanilla_coin = PKZ_Table.levellist[gamemap].new_coin
		actor.color = SKINCOLOR_GOLD
		if vanilla_coin then
			if vanilla_coin == 1 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = C|FF_PAPERSPRITE
				actor.color = SKINCOLOR_BLUEBELL
			end
			if vanilla_coin == 2 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = D|FF_PAPERSPRITE
			end
			if vanilla_coin == 3 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = E|FF_PAPERSPRITE
			end			
		end
	end	
	
	if consoleplayer and consoleplayer.valid then
		if (PKZ_Table.dragonCoinTags[actor.dragtag] and PKZ_Table.dragonCoinTags[actor.dragtag] > 0) then
			actor.color = SKINCOLOR_SAPPHIRE
			actor.blendmode = AST_ADD
			actor.colorized = true
			actor.dragoncoincolored = true
		else
			actor.colorized = false
			actor.dragoncoincolored = false
		end
	end	
	
	-- spawn sides
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = actor
		sideSpawn.scale = actor.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.frame = actor.frame
		sideSpawn.sprite = SPR_DOIP
	end		
end, MT_DRAGONCOIN)

// Upon Actor's Death, it should search for parameter of their's spawner...
// Also add 1 collected to tracker
addHook("MobjDeath", function(actor, mo)
	if actor.dragtag > 0 then
		PKZ_Table.dragonCoinTags[actor.dragtag] = PKZ_Table.hardMode and 2 or 1
	end
	A_AwardScore(actor)
	actor.flags = $ &~ MF_NOGRAVITY
	actor.momz = 8 << FRACBITS
end, MT_DRAGONCOIN)

//Hacky way to unlock things
//Hey don't blame me
local function DCoinTriggertrigger(actor)
	if actor.health > 0 then
		if not libOpt.ConsoleCameraBool(actor, libOpt.ITEM_CONST) then return end	
		actor.angle = $-ANG1*3
		if actor.dragoncoincolored == false and not (8 & leveltime) then
			local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-2,50) << FRACBITS, MT_POPPARTICLEMAR)
			poweruppar.state = S_INVINCSTAR
			poweruppar.scale = actor.scale
			poweruppar.color = actor.color
			poweruppar.fuse = TICRATE
		end		
	else
		actor.angle = $+ANG1*8	
	end
	if not netplay and not splitscreen then
		if actor.dragoncoincolored == true then
			actor.frame = $|FF_TRANS60
		end
	end
end

addHook("MobjThinker", DCoinTriggertrigger, MT_DRAGONCOIN)

// Oi, have you heard about saving... I know bizzare concept
// Especially upon death or rather entire removal from existance
addHook("MobjRemoved", function(actor)
	PKZ_Table.saveDrgProgress()
	//debug lmao
	if CV_FindVar("pkz_debug").value == 1
	print("\x82"+actor.target.player.name+" got dragoncoin number "+actor.dragtag+" out of "+dgcoincount[1])
	end
end, MT_DRAGONCOIN)

addHook("MobjSpawn", function(a)
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(a, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = a
		sideSpawn.scale = a.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.sprite = SPR_K0MO
		sideSpawn.frame = B|FF_PAPERSPRITE
	end	
	return true	
end, MT_MARBWKEY)


addHook("MobjDeath", function(a)
	A_ForceWin(a)
	PKZ_Table.roomHubKey = 1
end, MT_MARBWKEY)

addHook("MobjThinker", function(actor)
	actor.angle = $ + ANG1*3
	if not (6 & leveltime) then
		local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(0,64) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = actor.scale
		poweruppar.color = SKINCOLOR_GOLD
		poweruppar.fuse = TICRATE
	end	
end, MT_MARBWKEY)

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

addHook("MobjThinker", function(a)
	if a.state ~= S_HAMMERX then
		a.state = S_HAMMERX 
	end
	
	a.rollangle = $ + ANG10	
end, MT_HAMMER)