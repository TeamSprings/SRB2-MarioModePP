local foes = tbsrequire 'entities/foes_common'

// Color switch for Goomba spawn
// Written by Ace
local function Goombaswitch(actor)
	//Default Goomba
	actor.color = SKINCOLOR_GREEN
	actor.scale = actor.spawnpoint.scale*8/10
end

addHook("MobjSpawn", function(actor)
	actor.extravalue1 = 0
end, MT_GOOMBA)

// Goomba thinker
// Written by Ace
addHook("MobjThinker", function(a)
	if not (a and a.valid and P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false)) then return end
	local dist = R_PointToDist2(a.x, a.y, a.target.x, a.target.y)


	if a.state == S_GOOMBA1 then
		if not (a.extravalue1 or a.extravalue2) then
			if dist < (60 << FRACBITS) and a.target.player and
				not (a.target.player.powers[pw_invulnerability] or a.target.player.powers[pw_flashing]) then
				a.extravalue1 = TICRATE*8

				if a.goombatimer == 50 or a.goombatimer == 100 or a.goombatimer == 150 then
					S_StartSound(a, sfx_mgos64)
				end
			elseif dist < (386 << FRACBITS) then
				states[S_GOOMBA1].tics = 16
				states[S_GOOMBA1].var2 = 4

				if P_IsObjectOnGround(a) then
					if a.alertjumpready then
						a.z = $ + P_MobjFlip(a)
						P_SetObjectMomZ(a, 3 << FRACBITS, false)
						a.alertjumpready = false
						S_StartSound(a, sfx_mgos64)
					end

					A_MarRushChase(a, 6)
				end
			else
				A_MarGoinAround(a)
				if P_IsObjectOnGround(a) and a.goombatimer == 75 or a.goombatimer == 150 then
					a.z = $ + P_MobjFlip(a)
					P_SetObjectMomZ(a, 3 << FRACBITS, false)
				end
				a.alertjumpready = true
				states[S_GOOMBA1].tics = 36
				states[S_GOOMBA1].var2 = 9
			end

			if dist < (4 << FRACBITS) and P_IsObjectOnGround(a.target) and P_IsObjectOnGround(a) then
				a.extravalue2 = 2
				a.momx = -a.momx*2
				a.momy = -a.momy*2
				a.momz = (12 << FRACBITS)*P_MobjFlip(a)

				A_FaceTarget()
			end
		elseif a.extravalue1 and P_IsObjectOnGround(a) then
			a.angle = TBSlib.reachAngle(a.angle, R_PointToAngle2(a.x, a.y, a.target.x, a.target.y), ANG10)
			a.momx = FixedMul(8*a.scale, sin(a.angle))
			a.momy = FixedMul(8*a.scale, cos(a.angle))

			a.extravalue1 = $-1
		end
	end

	if P_IsObjectOnGround(a) then
		if a.state == S_GOOMBA_KNOCK then
			a.state = S_GOOMBA1
		end

		if a.extravalue2 then
			a.extravalue2 = $-1
		end
	end
end, MT_GOOMBA)

/*
TBSlib.scaleAnimator(a, MushroomAnimation)
local MushroomAnimation = {
	-- Lively mushroom animation into itemholder
	[0] = {offscale_x = 0, offscale_y = 0, tics = 4, nexts = 1},
	[1] = {offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offscale_x = -(FRACUNIT >> 3), offscale_y = (FRACUNIT >> 4), tics = 4, nexts = 3},
	[3] = {offscale_x = (FRACUNIT >> 3), offscale_y = -(FRACUNIT >> 4), tics = 3, nexts = 0},
}
*/

addHook("MobjMoveBlocked", function(a, block_a, block_l)
	if block_l and a.extravalue1 then
		a.state = S_GOOMBA_KNOCK
		a.momx = -FixedMul(6*a.scale, sin(a.angle))
		a.momy = -FixedMul(6*a.scale, cos(a.angle))
		a.momz = -6*a.scale

		a.extravalue1 = 0
	end
end, MT_GOOMBA)

addHook("MapThingSpawn", Goombaswitch, MT_GOOMBA)
addHook("MapThingSpawn", Goombaswitch, MT_BLUEGOOMBA)



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

local function RemovedGoomba(actor, mo)
	local spawndamageparticle = P_SpawnMobjFromMobj(actor, 0,0,-4*FRACUNIT, MT_POPPARTICLEMAR)
	spawndamageparticle.state = S_PIRANHAPLANTDEAD
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
end

// Piss
// Written by Ace

local function Piss(actor, collider)
	local skin = skins[collider.player.skin]
	if collider.skin == "hms123311" and actor.type ~= MT_EGGGOOMBA then
		local lmaogoomba = P_SpawnMobj(actor.x, actor.y, actor.z, MT_EGGGOOMBA)
		S_StartSound(lmaogoomba, sfx_mario2)
		P_RemoveMobj(actor)
		return true
	end
end



//addHook("MobjDeath", Piss, MT_GOOMBA)
// Particle colorizer
// Written by Ace
local function ParticleSpawn(actor, collider)
	local ohthatcolor = {
		[MT_LIFESHROOM] = SKINCOLOR_EMERALD,
		[MT_NUKESHROOM]	= SKINCOLOR_RED,
		[MT_FORCESHROOM] = SKINCOLOR_BLUE,
		[MT_ELECTRICSHROOM]	= SKINCOLOR_YELLOW,
		[MT_ELEMENTALSHROOM] = SKINCOLOR_BLUE,
		[MT_CLOUDSHROOM] = SKINCOLOR_AETHER,
		[MT_POISONSHROOM] = SKINCOLOR_PURPLE,
		[MT_FLAMESHROOM] = SKINCOLOR_RED,
		[MT_BUBBLESHROOM] = SKINCOLOR_BLUE,
		[MT_MINISHROOM] = SKINCOLOR_CYAN,
		[MT_REDSHROOM] = SKINCOLOR_GOLD,
		[MT_THUNDERSHROOM] = SKINCOLOR_YELLOW,
		[MT_PITYSHROOM]	= SKINCOLOR_GREEN,
		[MT_PINKSHROOM]	= SKINCOLOR_PINK,
		[MT_GOLDSHROOM] = SKINCOLOR_GOLD,
		[MT_STARMAN] = SKINCOLOR_GOLD,
		[MT_SPEEDWINGS] = SKINCOLOR_AETHER,
		[MT_NEWFIREFLOWER] = SKINCOLOR_RED,
		[MT_ICYFLOWER] = SKINCOLOR_CYAN,
	}
	A_SpawnPickUpParticle(actor, ohthatcolor[actor.type] or SKINCOLOR_GOLD)
	--A_MarioPain(actor, actor.powers[pw_shield], , 5)
end

// Power Up Table
for _,powerups in pairs({
	MT_LIFESHROOM,
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
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
	MT_ICYFLOWER,
	MT_REDSHROOM,
	MT_STARMAN,
	MT_SPEEDWINGS
	}) do

addHook("MobjDeath", ParticleSpawn, powerups)
end

// Goomba Table
for _,goombas in pairs({
	MT_GOOMBA,
	MT_BLUEGOOMBA,
	MT_2DGOOMBA,
	MT_2DBLUEGOOMBA,
	MT_EGGGOOMBA,
	}) do

addHook("MobjDeath", PressureGoomba, goombas)
addHook("MobjRemoved", RemovedGoomba, goombas)
//addHook("MobjDeath", Piss, goombas)
end