local foes = tbsrequire 'entities/foes_common'

-- Color switch for Goomba spawn
--* Written by Ace
---@param mo mobj_t 
local function P_GoombaInit(mo)
	--Default Goomba
	mo.color = SKINCOLOR_GREEN
	mo.scale = mo.spawnpoint.scale*8/10
	mo.extravalue1 = 0

	if mo.type == MT_BLUEGOOMBA then
		local replace = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_GOOMBA)
		replace.translation = 'MarioUndergroundGoombas'
	
		P_RemoveMobj(mo)
	end
end

-- Goomba thinker
-- Written by Ace
addHook("MobjThinker", function(mo)
	if not (mo and mo.valid and P_LookForPlayers(mo, libOpt.ENEMY_CONST, true, false)) then return end
	local dist = R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y)
	local dist3D = R_PointToDist2(0, mo.z, dist, mo.target.z)

	if mo.state == S_GOOMBA1 then
		if not (mo.extravalue1 or mo.extravalue2) then
			if dist < (60 << FRACBITS) and mo.target.player and
				not (mo.target.player.powers[pw_invulnerability] or mo.target.player.powers[pw_flashing]) then
				mo.extravalue1 = TICRATE*5

				if mo.goombatimer == 50 or mo.goombatimer == 100 or mo.goombatimer == 150 then
					S_StartSound(mo, sfx_mgos64)
				end
			elseif dist < (386 << FRACBITS) then
				states[S_GOOMBA1].tics = 16
				states[S_GOOMBA1].var2 = 4

				if P_IsObjectOnGround(mo) then
					if mo.alertjumpready then
						mo.z = $ + P_MobjFlip(mo)
						P_SetObjectMomZ(mo, 3 << FRACBITS, false)
						mo.alertjumpready = false
						S_StartSound(mo, sfx_mgos64)
					end

					A_MarRushChase(mo, 6)
				end
			else
				A_MarGoinAround(mo)
				if P_IsObjectOnGround(mo) and mo.goombatimer == 75 or mo.goombatimer == 150 then
					mo.z = $ + P_MobjFlip(mo)
					P_SetObjectMomZ(mo, 3 << FRACBITS, false)
				end
				mo.alertjumpready = true
				states[S_GOOMBA1].tics = 36
				states[S_GOOMBA1].var2 = 9
			end

		elseif mo.extravalue1 and P_IsObjectOnGround(mo) and not mo.extravalue2 then
			mo.angle = TBSlib.reachAngle(mo.angle, R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y), ANG2)
			mo.momx = FixedMul(8*mo.scale, cos(mo.angle))
			mo.momy = FixedMul(8*mo.scale, sin(mo.angle))

			mo.extravalue1 = $-1
		end
	end

	if P_IsObjectOnGround(mo) then
		if mo.state == S_GOOMBA_KNOCK then
			mo.state = S_GOOMBA1
		end

		if mo.extravalue2 then
			mo.extravalue2 = $-1
		end
	end
end, MT_GOOMBA)

addHook("ShouldDamage", function(mobj, inflict)
	if type(inflict) == 'userdata' and userdataType(inflict) == 'mobj_t'
	and inflict.type == MT_GOOMBA and not inflict.extravalue2 then
		inflict.extravalue2 = 2
		inflict.momx = -inflict.momx
		inflict.momy = -inflict.momy
		inflict.z = $ + P_MobjFlip(inflict)
		P_SetObjectMomZ(inflict, 3 << FRACBITS, false)
		inflict.extravalue1 = 0
		return nil
	end
end, MT_PLAYER)

--[[
TBSlib.scaleAnimator(a, MushroomAnimation)
local MushroomAnimation = {
	-- Lively mushroom animation into itemholder
	[0] = {offscale_x = 0, offscale_y = 0, tics = 4, nexts = 1},
	[1] = {offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offscale_x = -(FRACUNIT >> 3), offscale_y = (FRACUNIT >> 4), tics = 4, nexts = 3},
	[3] = {offscale_x = (FRACUNIT >> 3), offscale_y = -(FRACUNIT >> 4), tics = 3, nexts = 0},
}
--]]

addHook("MobjMoveBlocked", function(a, block_a, block_l)
	if block_l and a.extravalue1 and not a.extravalue2 then
		a.extravalue2 = 2
		a.momx = -a.momx
		a.momy = -a.momy
		a.z = $ + P_MobjFlip(a)
		P_SetObjectMomZ(a, 3 << FRACBITS, false)
		a.extravalue1 = 0
	end
end, MT_GOOMBA)

addHook("MapThingSpawn", P_GoombaInit, MT_GOOMBA)
addHook("MapThingSpawn", P_GoombaInit, MT_BLUEGOOMBA)

-- I wouldn't do this shit, if game actually took vanilla mapthing indeficiations seriously.
addHook("MapThingSpawn", function(a, mt)
	a.gbknock = 2
end, MT_BLUEGOOMBA)

addHook("MapThingSpawn", function(a, mt)
	a.gbknock = 2
end, MT_2DBLUEGOOMBA)

local scaled_goomba_sound = { [FRACUNIT*2] = sfx_mariog, [FRACUNIT/2] = sfx_marioh, [FRACUNIT*8/10] = sfx_mario5}

local function PressureGoomba(actor, mo)
	if not (actor and actor.valid and mo and mo.valid) then return end

	if mo.state == S_PLAY_JUMP or mo.state == S_PLAY_FALL then
		for i = -45,45,90 do
			local pressgom = P_SpawnMobjFromMobj(actor, 0,0,0, MT_PRESSUREPARTICLEMAR)
			pressgom.fuse = 45
			pressgom.scale = actor.scale
			pressgom.angle = mo.angle + ANG1*i
		end
		A_SpawnMarioStars(actor, mo)
		S_StartSound(mo, scaled_goomba_sound[actor.scale] or sfx_mario5)
	end

	if not (mo.state == S_PLAY_ROLL or mo.type == MT_FIREBALL or mo.type == MT_SHELL or mo.type == MT_PKZFB or mo.type == MT_PKZGB and mo.type ~= MT_PKZIB) then return end

	if mo.type ~= MT_PKZGB then
		if mo.type == MT_FIREBALL then
			A_CoinDrop(actor, 0, 0)
		else
			A_CoinProjectile(actor, 0, 0)
		end
	else
		actor.translation = "MarioSonGOLD"
	end
	actor.gbknock = $ or 1

	local goombaknock = P_SpawnMobjFromMobj(actor, 0,0,0, MT_GOOMBAKNOCKOUT)
	goombaknock.state = (actor.gbknock == 2 and S_BLUEGOOMBA_KNOCK or S_GOOMBA_KNOCK)
	S_StartSound(goombaknock, sfx_mario2)
	goombaknock.momx = $+mo.momx << 1
	goombaknock.momy = $+mo.momy << 1
	goombaknock.momz = 5 << FRACBITS + mo.momz
	goombaknock.angle = mo.angle+ANGLE_180
	goombaknock.scale = actor.scale
	goombaknock.translation = actor.translation
	if mo.type == MT_FIREBALL or mo.type == MT_PKZFB then
		goombaknock.color = SKINCOLOR_CARBON
		goombaknock.colorized = true
		local smoke = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_POPPARTICLEMAR)
		smoke.scale = $+FRACUNIT >> 1
		smoke.color = SKINCOLOR_CARBON
		smoke.colorized = true
	end
	P_RemoveMobj(actor)
end

addHook("MobjMoveBlocked", function(mo, block_a, block_l)
	if mo.turn_on_rotation == nil then
		mo.turn_on_rotation = true
	else
		mo.turn_on_rotation = not (mo.turn_on_rotation)
	end

	mo.rollangle = $+ANGLE_45
	mo.momx = -mo.momx
	mo.momy = -mo.momy

	local smoke = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_POPPARTICLEMAR)
end, MT_GOOMBAKNOCKOUT)

addHook("MobjThinker", function(mo)
	if mo.turn_on_rotation ~= nil then
		mo.rollangle = $+FixedAngle(FixedHypot(FixedHypot(mo.momx, mo.momy), mo.momz))
	end

	if mo.state ~= S_BLUEGOOMBA_KNOCK and mo.state ~= S_GOOMBA_KNOCK then
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
	end

	mo.scale = $-FRACUNIT/128
end, MT_GOOMBAKNOCKOUT)


local function RemovedGoomba(mo)
	local dust = P_SpawnMobjFromMobj(mo, 0,0,-4*FRACUNIT, MT_POPPARTICLEMAR)
	dust.state = S_PIRANHAPLANTDEAD
	dust.momx = 0
	dust.momy = 0
	dust.momz = 0
end

-- Piss
-- Written by Ace

local function Piss(actor, collider)
	local skin = skins[collider.player.skin]
	if collider.skin == "hms123311" and actor.type ~= MT_EGGGOOMBA then
		local lmaogoomba = P_SpawnMobj(actor.x, actor.y, actor.z, MT_EGGGOOMBA)
		S_StartSound(lmaogoomba, sfx_mario2)
		P_RemoveMobj(actor)
		return true
	end
end

-- Goomba Table
for _,goombas in pairs({
	MT_GOOMBA,
	MT_BLUEGOOMBA,
	MT_2DGOOMBA,
	MT_2DBLUEGOOMBA,
	MT_EGGGOOMBA,
	}) do

addHook("MobjDeath", PressureGoomba, goombas)
addHook("MobjRemoved", RemovedGoomba, goombas)
--addHook("MobjDeath", Piss, goombas)
end