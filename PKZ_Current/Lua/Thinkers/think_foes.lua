/* 
		Pipe Kingdom Zone's Enemies - think_foes.lua

Description:
All thinkers, behaviors and other things related to enemies of PKZ

Contributors: Skydusk
@Team Blue Spring 2024
*/

//	A_GuardChase without function to move into PainState, due to lack of shield
//	Contributed by Lat' per request (Thank you Lat'!)
function A_FakeGuardChase(actor)
	if not (actor and actor.valid and P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) == true) then return end
	
	actor.reactiontime = $ and $-1 or 0

	local speed = actor.info.speed*actor.scale*(actor.extravalue1 or 1)
	
	if speed and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, speed), actor.y + P_ReturnThrustY(actor, actor.angle, speed), (actor.flags2 & MF2_AMBUSH and true or false)) and actor.valid and speed > 0
		if actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == MTF_OBJECTSPECIAL) then
			actor.angle = $+ ANGLE_90
		elseif actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == 1) then
			actor.angle = $- ANGLE_90
		else
			actor.angle = $+ ANGLE_180
		end
	end
end

addHook("MobjThinker", function(actor)
	if actor.state == S_KOOPAPATROLING1 then
		if not (actor and actor.valid and P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) == true) then return end
	
		actor.reactiontime = $ and $-1 or 0

		local speed = 3*((actor.info.speed*actor.scale)*(actor.extravalue1 or 1)) >> 3
	
		if speed and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, speed), actor.y + P_ReturnThrustY(actor, actor.angle, speed), (actor.flags2 & MF2_AMBUSH and true or false)) and actor.valid and speed > 0
			if actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == MTF_OBJECTSPECIAL) then
				actor.angle = $+ ANGLE_90
			elseif actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == 1) then
				actor.angle = $- ANGLE_90
			else
				actor.angle = $+ ANGLE_180
			end
		end
	end
end, MT_MGREENKOOPA)

// Color switch for Koopa spawn
// Written by local idiot... I mean Ace
local function Koopaswitch(actor, mt)
	//Behavioral setting
	if not (actor and actor.valid) then return end 
	
	actor.behsetting = mt.args[0] or mt.extrainfo
	local color = { [1] = SKINCOLOR_EMERALD, [2] = SKINCOLOR_RUBY, [3] = SKINCOLOR_GOLDENROD, [4] = SKINCOLOR_SAPPHIRE }
	actor.color = color[actor.behsetting] or 0
end

// Custom Koopa/Shell spawners
// Braindead spawners by Ace
function A_KoopaSpawn(actor)
	local koopaspawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_MGREENKOOPA)
	koopaspawn.extrainfo = actor.extrainfo and (actor.extrainfo or (actor.spawnpoint and actor.spawnpoint.args[0] or actor.spawnpoint.extrainfo)) or 0
	koopaspawn.angle = actor.angle or actor.spawnpoint.angle*ANG1
	koopaspawn.scale = actor.scale
	koopaspawn.color = actor.color
end

function A_ShellSpawn(actor)
	local shellspawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_SHELL)
	shellspawn.extrainfo = actor.extrainfo and (actor.extrainfo or (actor.spawnpoint and actor.spawnpoint.args[0] or actor.spawnpoint.extrainfo)) or 0
	shellspawn.angle = actor.angle or (actor.spawnpoint and actor.spawnpoint.angle*ANG1 or 0)
	shellspawn.scale = actor.scale
	shellspawn.color = actor.color
	
	if actor.type ~= MT_BUZZYBEETLE then return end
	shellspawn.sprite = SPR_0BET
	shellspawn.frame = E
end

addHook("MapThingSpawn", Koopaswitch, MT_MGREENKOOPA)
addHook("MapThingSpawn", Koopaswitch, MT_BPARAKOOPA)
addHook("MapThingSpawn", Koopaswitch, MT_PARAKOOPA)

// Color switch for Goomba spawn
// Written by Ace
local function Goombaswitch(actor)
	//Default Goomba
	actor.color = SKINCOLOR_GREEN
	actor.scale = actor.spawnpoint.scale*8/10
end

addHook("MapThingSpawn", Goombaswitch, MT_GOOMBA)
addHook("MapThingSpawn", Goombaswitch, MT_BLUEGOOMBA)

// Goomba Action Thinkers
// Written by Ace
function A_MarRushChase(actor, th)
	A_FaceTarget(actor)
	A_Thrust(actor, th, 1)
end

// Bomb-Omh Mobj Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) then return end
	
	if actor.state == S_BOMBOHM1 then
		actor.color = SKINCOLOR_SILVER
		if P_LookForPlayers(actor, 46 << FRACBITS, true, false) then
			P_KillMobj(actor)
		elseif P_LookForPlayers(actor, 386 << FRACBITS, true, false) then
			states[S_BOMBOHM1].tics = 12
			states[S_BOMBOHM1].var2 = 3
			if P_IsObjectOnGround(actor) then
				A_MarRushChase(actor, 6)
			end
		else 
			A_MarGoinAround(actor)
			states[S_BOMBOHM1].tics = 32
			states[S_BOMBOHM1].var2 = 8
		end
	end
	
	if actor.state == S_BOMBOHMEXP then
		A_MarBombohmexp(actor)
	end
end, MT_BOMBOHM)

local Bombohmcolor = {
	SKINCOLOR_YELLOW;
	SKINCOLOR_GOLD;
	SKINCOLOR_RED;
	SKINCOLOR_WHITE;
	SKINCOLOR_YELLOW;
	SKINCOLOR_RUBY;
}


// Bomb-Omh Action Thinker
// Written by Ace
function A_MarBombohmexp(actor)
	if not (actor and actor.valid) then return end
		
	actor.bombohmtimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)
		
	if actor.bombohmtimer == 2 then
		local tirefire = P_SpawnMobjFromMobj(actor, 0,0,39 << FRACBITS, MT_FLAME)
		tirefire.fuse = 32
		tirefire.scale = actor.scale >> 2
		tirefire.flags = MF_NOGRAVITY
	end

	actor.scale = (((actor.bombohmtimer % 10)+1 /5) and $ + FRACUNIT/25 or $ - FRACUNIT/25)
	actor.color = Bombohmcolor[((actor.bombohmtimer % 36) % #Bombohmcolor) + 1]
		
	if actor.bombohmtimer > 0 and actor.bombohmtimer < 6 then S_StartSound(actor, sfx_fubo64) end

	if actor.bombohmtimer > 29 then
		S_StartSound(actor, sfx_mar64c)
		A_TNTExplode(actor, MT_TNTDUST)
		P_RemoveMobj(actor)
	end
end

// Goomba/Bomb-Ohm running around
// Written by Ace
function A_MarGoinAround(actor)
	local speed = FixedHypot(actor.momx, actor.momy)
	local snspeed = actor.scale<<2/5
	
	actor.goombatimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)
	
	if actor.goombatimer == 150 then
		actor.angle = $ + ANGLE_45
		actor.goombatimer = 1
	end

	if speed > 0 and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, snspeed), actor.y + P_ReturnThrustY(actor, actor.angle, snspeed), true)
		actor.angle = $+ ANGLE_180
    end

	P_InstaThrust(actor, actor.angle, snspeed)
end

// Goomba thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) then return end
	
	if actor.state == S_GOOMBA1 and actor.valid then
		if P_LookForPlayers(actor, 36 << FRACBITS, true, false)
			if actor.goombatimer == 50 or actor.goombatimer == 100 or actor.goombatimer == 150
				S_StartSound(actor, sfx_mgos64)
			end
			actor.momx = 0
			actor.momy = 0
			if P_IsObjectOnGround(actor)
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 6 << FRACBITS, false)
			end
			A_FaceTarget(actor)
		elseif P_LookForPlayers(actor, 386 << FRACBITS, true, false) then //or not target.player.powers[pw_flashing] or not target.player.powers[pw_invulnerability]
			if P_IsObjectOnGround(actor) and actor.alertjumpready == true
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 3 << FRACBITS, false)
				actor.alertjumpready = false
				S_StartSound(actor, sfx_mgos64)
			end
			states[S_GOOMBA1].tics = 16
			states[S_GOOMBA1].var2 = 4
			if P_IsObjectOnGround(actor)
				A_MarRushChase(actor, 6)
			end
			//elseif target.player.powers[pw_invulnerability]
			//A_MarbackChase(actor)
			//states[S_GOOMBA1].tics = 16
			//states[S_GOOMBA1].var2 = 4
		else 
			A_MarGoinAround(actor)
			if P_IsObjectOnGround(actor) and actor.goombatimer == 75 or actor.goombatimer == 150
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 3 << FRACBITS, false)
			end
			actor.alertjumpready = true
			states[S_GOOMBA1].tics = 36
			states[S_GOOMBA1].var2 = 9
		end
	end
end, MT_GOOMBA)

// Blue Goomba thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) then return end

	if actor.state == S_BLUEGOOMBA1 and actor.valid then
		if P_LookForPlayers(actor, 40 << FRACBITS, true, false)
			if actor.goombatimer == 50 or actor.goombatimer == 100 or actor.goombatimer == 150 then
				S_StartSound(actor, sfx_mgos64)
			end
			actor.momx = 0
			actor.momy = 0
			if P_IsObjectOnGround(actor) then
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 6 << FRACBITS, false)
			end
			A_FaceTarget(actor)
		elseif P_LookForPlayers(actor, 386 << FRACBITS, true, false) then //or not target.player.powers[pw_flashing] or not target.player.powers[pw_invulnerability]
			if P_IsObjectOnGround(actor) and actor.alertjumpready == true then
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 3 << FRACBITS, false)
				actor.alertjumpready = false
				S_StartSound(actor, sfx_mgos64)
			end
			states[S_BLUEGOOMBA1].tics = 16
			states[S_BLUEGOOMBA1].var2 = 4
			if P_IsObjectOnGround(actor) then
				A_MarRushChase(actor, 6)
			end
		else 
			A_MarGoinAround(actor)
			if P_IsObjectOnGround(actor) and actor.goombatimer == 75 or actor.goombatimer == 150 then
				actor.z = $ + P_MobjFlip(actor)
				P_SetObjectMomZ(actor, 3 << FRACBITS, false)
			end
			actor.alertjumpready = true
			states[S_BLUEGOOMBA1].tics = 36
			states[S_BLUEGOOMBA1].var2 = 9
		end
	end
end, MT_BLUEGOOMBA)

// Bulletbill Mobj Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not (actor and actor.valid) and actor.state ~= S_BULLETBILL then return end
	
	if not (leveltime % 8) then
		local smokeparticle = P_SpawnMobj(actor.x, actor.y, actor.z, MT_MARSMOKEPARTICLE)
		smokeparticle.scale = actor.scale
		smokeparticle.angle = actor.angle + ANGLE_90
	end
	P_InstaThrust(actor, actor.angle, actor.info.speed << FRACBITS)
	if not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, actor.info.speed << FRACBITS), actor.y + P_ReturnThrustY(actor, actor.angle, actor.info.speed << FRACBITS), true) or P_LookForPlayers(actor, 2 << FRACBITS, true, false) then
		P_KillMobj(actor)
	end
	
end, MT_BULLETBILL)

// Homing Bulletbill Mobj Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not (actor and actor.valid) and actor.state ~= S_HOMINGBULLETBILL then return end
	
	if actor.state == S_HOMINGBULLETBILL then
		actor.color = SKINCOLOR_RED
		actor.colorized = true
		if not (leveltime % 8) then
			local smokeparticle = P_SpawnMobj(actor.x, actor.y, actor.z, MT_MARSMOKEPARTICLE)
			smokeparticle.scale = actor.scale*3>>1
			smokeparticle.angle = actor.angle + ANGLE_90
		end
		A_SmokeTrailer(actor, MT_TNTDUST)
		if P_LookForPlayers(actor, 1024 << FRACBITS, true, false) then
			A_HomingChase(actor, actor.info.speed << FRACBITS, 0)
		elseif not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, actor.info.speed << FRACBITS), actor.y + P_ReturnThrustY(actor, actor.angle, actor.info.speed << FRACBITS), true) or P_LookForPlayers(actor, 2 << FRACBITS, true, false) then
			P_KillMobj(actor)
		else
			P_InstaThrust(actor, actor.angle, actor.info.speed << FRACBITS)
		end
	end
	
end, MT_HOMINGBULLETBILL)

// Bullet Bill Spawner
// Written by Ace
addHook("MobjThinker", function(actor)
	if actor.bullettimer == nil then
		actor.bullettimer = 1
	end
	if actor.bullettimer > 0 then
		actor.bullettimer = $+1
	end
	if actor.bullettimer == 75 then
		actor.bullettimer = 1
		if actor.state == S_INVISIBLE then
			S_StartSound(actor, sfx_mar64c)
			local udmf = (actor.spawnpoint and (actor.spawnpoint.args[0] or actor.spawnpoint.extrainfo) or 0)
			A_SpawnObjectRelative(actor, 0, 0+(udmf == 1 and MT_HOMINGBULLETBILL or MT_BULLETBILL))
		end
	end
end, MT_BULLETBILLSPAWNER)

// C Translation for mines in PKZ2
// Written by Ace
addHook("TouchSpecial", function(special, toucher)
	for i = 1, 12 do
		local explode = P_SpawnMobjFromMobj(special, 
		cos(ANGLE_45*i)<<5,
		sin(ANGLE_45*i)<<5,
		sin(ANGLE_45*i)<<5, 
		MT_UWEXPLODE)
	end
	if not toucher.player return end		
	P_DamageMobj(toucher)
end, MT_MARIOUNDERWATER)


// Killer of invincible enemies
// Written by Ace
local function InvinciMobjKiller(actor, collider)
	if collider and collider.valid and collider.type == MT_PLAYER and (collider.z) >= (actor.z) and (collider.z) < (actor.z+actor.height+1*FRACUNIT) and (actor.state ~= actor.info.deathstate) then
		if collider.player.powers[pw_invulnerability] or (actor.type == MT_SHYGUY and collider.state == S_PLAY_ROLL) then
			local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.frame = actor.frame|FF_VERTICALFLIP
			dummyobject.color = actor.color
			dummyobject.flags = $|MF_NOCLIPHEIGHT &~ MF_NOGRAVITY	
			dummyobject.momz = 8*FRACUNIT
			dummyobject.momx = 3*FRACUNIT
			dummyobject.momy = 3*FRACUNIT
			dummyobject.fuse = 60
			dummyobject.angle = actor.angle
			S_StartSound(collider, (actor.type ~= MT_BIGMOLE and sfx_mario5 or sfx_marwoc))
			if actor.parts then
				for _,parts in pairs(actor.parts) do
					P_RemoveMobj(parts)
				end
			end			
			P_RemoveMobj(actor)
		end
	end
end

//local function Piranhaplantthinker(actor)
//end

addHook("MobjCollide", InvinciMobjKiller, MT_REDPIRANHAPLANT)
addHook("MobjCollide", InvinciMobjKiller, MT_REDJPIRANHAPLANT)
addHook("MobjCollide", InvinciMobjKiller, MT_FIREFPIRANHAPLANT)
addHook("MobjCollide", InvinciMobjKiller, MT_REDHPIRANHAPLANT)
addHook("MobjCollide", InvinciMobjKiller, MT_BIGMOLE)
addHook("MobjCollide", InvinciMobjKiller, MT_SHYGUY)

// Action Thinker Spawner for Babies 
// (Currently used for Bloopers)
// Written by Ace
function A_SpawnFollowingBaby(actor, var1, var2)
	local baby = P_SpawnMobjFromMobj(actor, 0, 0, 0, actor.type)
	if not (baby and baby.valid) then return end
	
	baby.tracer = actor
	baby.isbaby = true
	baby.scale = actor.scale/4
	baby.tmomx = FRACUNIT/(var1 or 1)
	baby.tmomy = FRACUNIT/(var1 or 1)
	baby.tmomz = FRACUNIT/(var2 or 1)
	baby.interid = (var1 or 1)/2
end

// Blooper Mobj Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) then return end

	local offset = -8
	local tracer = actor.tracer
	local target = actor.target
	local snspeed = actor.scale*10
	if actor.isbaby == true then
			// Baby Mode
			if (tracer.health <= 0) then
				actor.state = actor.info.spawnstate
				actor.isbaby = false
			end
			if tracer and tracer.valid then
				if offset == -8 then
					offset = $ * actor.interid
				end
				actor.state = S_INVISIBLE
				actor.angle = tracer.angle
				actor.sprite = tracer.sprite
				actor.frame = tracer.frame
				actor.cmomh = -(FixedHypot(offset*(tracer.momy - actor.tmomy)>>FRACBITS<<1, offset*(tracer.momx - actor.tmomx)>>FRACBITS<<1))
				actor.cmomz = offset*(tracer.momz - actor.tmomz)>>FRACBITS
				A_CustomRChaser(actor, (actor.cmomz<<16)+1, (actor.cmomh<<16)+0)
				actor.spritexscale = tracer.spritexscale
				actor.spriteyscale = tracer.spriteyscale
			end
	else
		if target == nil then
			actor.state = S_MARIOOCTODADSPAWN
		end
		// Actual Thinker
		if actor.state == S_MARIOOCTODADSPAWN then
			A_FindTarget(actor, MT_PLAYER, 0)
			A_FaceTarget(actor, MT_PLAYER, 0)
			actor.flags = $|MF_NOGRAVITY
		elseif actor.state == S_WELLEXCUSEMEPRINCESS then
			A_Scream(actor)
			actor.flags = $ & ~MF_NOGRAVITY
			actor.spritexscale = 0
			actor.spriteyscale = 0
			if actor.rollangle ~= ANGLE_180
				actor.rollangle = $ + ANG15
			end
		elseif actor.state == S_MARIOOCTODAD then
			if actor.actionbloop == nil
				actor.actionbloop = 1
			end
			if actor.actionbloop > 0
				actor.actionbloop = $+1
			end
			if actor.actionbloop == 125
				actor.actionbloop = 1
			end
			if P_LookForPlayers(actor, 200 << FRACBITS, true, false) then
				actor.falldown = true
			else
				actor.falldown = false
			end
			if actor.falldown == false
				if actor.target.z+175 << FRACBITS >= actor.z and actor.actionbloop < 101 and actor.actionbloop > 0 then
					if actor.actionbloop == 1 then
						S_StartSound(actor, sfx_mawii1)
					end
					actor.shootnow = false
					actor.frame = D
					actor.flags = $|MF_NOGRAVITY
					if actor.momz < 5 << FRACBITS then
						actor.momz = $ + FRACUNIT/3
					end
					if actor.momz < FRACUNIT >> 1 then
						if actor.spritexscale <= FRACUNIT*3 >> 1 then
							actor.spritexscale = $ + FRACUNIT/7
						end
						if actor.spriteyscale >= FRACUNIT*2/3 then
							actor.spriteyscale = $ - FRACUNIT/7
						end
					elseif actor.momz < 4 << FRACBITS then
						if actor.spriteyscale <= FRACUNIT*3/2 then
							actor.spriteyscale = $ + FRACUNIT/7
						end
						if actor.spritexscale >= FRACUNIT*2/3 then
							actor.spritexscale = $ - FRACUNIT/7
						end
					end
					actor.angle = R_PointToAngle2(actor.x, actor.y, target.x, target.y)
					P_InstaThrust(actor, actor.angle, snspeed)
				elseif actor.actionbloop < 125 and actor.actionbloop > 100 then
					if actor.spritexscale <= FRACUNIT then
						actor.spritexscale = $ + FRACUNIT/3
					end
					if actor.spriteyscale >= FRACUNIT then
						actor.spriteyscale = $ - FRACUNIT/3
					end
					if actor.momz > 0 then
						actor.momz = $ - FRACUNIT >> 3
					end
					if actor.momz > 0 then
						actor.momx = $ - FRACUNIT/6
					end
					if actor.momy > 0 then
						actor.momy = $ - FRACUNIT/6
					end
					actor.angle = R_PointToAngle2(actor.x, actor.y, target.x, target.y)
				elseif target.z+175 << FRACBITS < actor.z and actor.actionbloop < 101 and actor.actionbloop > 0 then
					if (actor.z >= actor.floorz + FRACUNIT << 2) then 
						actor.flags = $ &~ MF_NOGRAVITY
						actor.momz = -FRACUNIT >> 3
						actor.frame = D
						R_PointToAngle2(actor.x, actor.y, target.x, target.y)
					end
				end
			else
				if actor.target.z < actor.z then
					if actor.target.player.powers[pw_flashing] == 0 then
						A_BloopAttack(actor, 0, 0)
					else
						A_BloopAttack(actor, 1, 0)
					end
				else
					actor.flags = $|MF_NOGRAVITY
					return
				end
			end
		end
	end
end, MT_MARIOOCTOPUS)

// Blooper Baby Spawn
// Written by Ace
addHook("MapThingSpawn", function(actor)
	//Behavioral setting
	if actor.spawnpoint then
		actor.behsetting = actor.spawnpoint.args[0] and actor.spawnpoint.args[0] or actor.spawnpoint.extrainfo
		actor.amnsetting = actor.spawnpoint.args[1] and (actor.spawnpoint.args[1]*2+2) or 8
	end
	
	if not actor.behsetting then return end
	
	for i = 2,actor.amnsetting,2 do
		A_SpawnFollowingBaby(actor, (i+2), i)
	end
end, MT_MARIOOCTOPUS)

// Blooper Death Hook
// Written by Ace
addHook("MobjDeath", function(actor)
	local posiongas = P_SpawnMobjFromMobj(actor, 0,0,0, MT_CANARIVORE_GAS)
	posiongas.fuse = 45
	posiongas.scale = actor.scale
	posiongas.source = actor
	
	if not actor.isbaby then return end
	S_StartSound(actor.target, sfx_marioh)
end, MT_MARIOOCTOPUS)

// Wings Spawner for Enemies
// Written by Ace
local function Spawnenemywings(actor)		
	if not (actor.type == MT_PARAKOOPA or actor.type == MT_BPARAKOOPA) then return end
	
	local wingsespawn = P_SpawnMobj(actor.x, actor.y, actor.z, MT_WIDEWINGS)
	wingsespawn.angle = actor.angle
	wingsespawn.scale = actor.scale
	wingsespawn.target = actor
	wingsespawn.flags2 = $|MF2_LINKDRAW	
	wingsespawn.capeset = 3
	
end

addHook("MapThingSpawn", Spawnenemywings, MT_BPARAKOOPA)
addHook("MapThingSpawn", Spawnenemywings, MT_PARAKOOPA)

// Bowser JR Edits
// Written by Ace
local function BowserJRSpawn(actor)
	actor.health = 8
end

addHook("MobjThinker", function(a)
	if not P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) then return end

	if P_IsObjectOnGround(a) then
		if a.momx or a.momy then
			a.frame = ((leveltime % 8) >> 2 and D or E)
		else
			a.frame = A
		end
	else
		a.frame = C
	end
	
	--if a.z <= a.watertop and a.health > 0 then
	--	P_KillMobj(a)
	--end
end, MT_KOOPA)

local function BowserJRDamage(actor, collider)
	if collider and collider.valid and collider.type == MT_FIREBALL and (collider.z) >= (actor.z) and (collider.z) < (actor.z+actor.height+FRACUNIT) then
		actor.health = $-1
		-- Remove Fire Ball
		P_RemoveMobj(collider)
		if actor.health <= 0 then
			local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.color = actor.color		
			dummyobject.flags = $|MF_NOCLIPHEIGHT
			dummyobject.flags = $ &~ MF_NOGRAVITY	
			dummyobject.momz = FRACUNIT<<3
			dummyobject.momx = 3<<FRACBITS
			dummyobject.momy = 3<<FRACBITS
			dummyobject.fuse = 60
			dummyobject.angle = actor.angle
			dummyobject.fireballp = true
			P_RemoveMobj(actor)
		end
	end
end

addHook("MapThingSpawn", BowserJRSpawn, MT_KOOPA)
addHook("MobjCollide", BowserJRDamage, MT_KOOPA)
addHook("MobjRemoved", function(a)
	P_LinedefExecute(650)
	return true
end, MT_KOOPA)


for _,piranhas in pairs({
	MT_REDPIRANHAPLANT,
	MT_FIREFPIRANHAPLANT
}) do

addHook("MobjThinker", function(a)
	if a.spawnpoint and (a.spawnpoint.options & MTF_EXTRA or a.spawnpoint.args[0] > 0) then
		if a.timerbop == nil or a.timerbop <= 0
			a.timerbop = 200
		end
		if a.timerbop > 0 and not (a.timer == 101 and P_LookForPlayers(actor, 386 << FRACBITS, true, false)) then
			a.timerbop = $-1
		end

		if a.timerbop == 199 then
			a.momz = -FRACUNIT << 2
			a.fireballready = false
			a.timer = 75		
		end
	
		if a.timerbop == 149 then
			a.momz = 0
		end
	
		if a.timerbop == 100 then
			a.momz = FRACUNIT << 2
		end
	
		if a.timerbop < 100 and a.timerbop > 0 then
			a.fireballready = true
		end

		if a.timerbop == 50 then
			a.momz = 0
		end
		if a and a.valid then
			for _,parts in pairs(a.parts) do
				if parts and parts.valid then
					parts.momz = a.momz
				end
			end
		end
	else
		a.fireballready = true
	end
	
	if a.type == MT_FIREFPIRANHAPLANT and a.fireballready then
		
		if a.timer == nil then
			a.timer = 75
		end
		a.timer = $-1 or 75
		
		if P_LookForPlayers(a, 5120 << FRACBITS, true, false) and P_CheckSight(a, a.target) then
			local z, dest = a.z+a.height, a.target
			a.angle = a.angle + FixedMul(R_PointToAngle2(a.x, a.y, dest.x, dest.y) - a.angle, FRACUNIT >> 3)			
			if a.timer == 8
				a.state = S_FIREPIRANHAPLANT1
				a.dest = {x = dest.x, y = dest.y, z = dest.z}
			end		
			
			if a.timer and a.timer <= 4 and a.dest then
				local missile = P_SpawnPointMissile(a, a.dest.x or dest.x, a.dest.y or dest.y, a.dest.z or dest.z, MT_PKZFB, a.x, a.y, z)
				missile.fuse = 200
				missile.scale = 2*a.scale/5	
				missile.flags = MF_MISSILE|MF_PAIN|MF_NOGRAVITY
				missile.plzno = true
			end
		end	
	end
end, piranhas)

addHook("MobjDeath", function(a)
	if not (a and a.valid) then return end
	
	for _,parts in pairs(a.parts) do
		P_RemoveMobj(parts)
	end
	
end, piranhas)


end

addHook("MobjThinker", function(a)
	if not (a.spawnpoint and (a.spawnpoint.options & MTF_EXTRA or a.spawnpoint.args[0] > 0)) then return end
	
	if a.timerbop == nil or a.timerbop <= 0
		a.timerbop = 250
	end
	
	if a.timerbop > 0 and not (a.timer == 101 and P_LookForPlayers(a, 386 << FRACBITS, true, false))
		a.timerbop = $-1
	end

	if a.timerbop == 249 then
		a.momz = -FRACUNIT << 1
	end
	
	if a.timerbop == 174 then
		a.momz = 0
	end
	
	if a.timerbop == 100 then
		a.momz = 6 << FRACBITS
	end

	if a.timerbop == 75 then
		a.momz = 0
	end

end, MT_REDJPIRANHAPLANT)

addHook("MobjThinker", function(a)
	if not (a and a.valid and a.spawnpoint and (a.spawnpoint.options & MTF_EXTRA or a.spawnpoint.args[1] > 0)) then return end
	
	if a.timerbop == nil or a.timerbop <= 0
		a.timerbop = 200
	end
	if a.timerbop > 0 and not (a.timer == 101 and P_LookForPlayers(a, 386 << FRACBITS, true, false))
		a.timerbop = $-1
	end

	if a.timerbop == 199 then
		a.momx = -cos(a.angle) << 2
		a.momy = -sin(a.angle) << 2
	end
	
	if a.timerbop == 149 then
		a.momx = 0
		a.momy = 0		
	end
	
	if a.timerbop == 100 then
		a.momx = cos(a.angle) << 2
		a.momy = sin(a.angle) << 2	
	end

	if a.timerbop == 50 then
		a.momx = 0
		a.momy = 0
	end

	for _,parts in pairs(a.parts) do
		parts.momx = a.momx
		parts.momy = a.momy
	end

end, MT_REDHPIRANHAPLANT)

addHook("MobjDeath", function(a)
	if not (a and a.valid) then return end

	for _,parts in pairs(a.parts) do
		P_RemoveMobj(parts)
	end
end, MT_REDHPIRANHAPLANT)

addHook("MapThingSpawn", function(a, mt)
	if (mt.extrainfo == 1 or mt.args[0] == 1) then
		a.parachute = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_WIDEWINGS)
		a.parachute.target = a
		a.parachute.state = S_INVISIBLE
		a.parachute.sprite = SPR_MAP3
		a.parachute.capeset = 6
		a.parachute.flags2 = $|MF2_LINKDRAW
		a.state = S_PARAGALOOMBAPARA
	end
	if (mt.extrainfo == 2 or mt.args[0] == 2) then
		a.parachute = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_WIDEWINGS)
		a.parachute.target = a
		a.parachute.state = S_INVISIBLE
		a.parachute.sprite = SPR_MAP2	
		a.parachute.capeset = 5
		a.parachute.flags2 = $|MF2_LINKDRAW		
		a.state = S_PARAGALOOMBAWINGS
	end
end, MT_GALOOMBA)

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) == false then return end

	if a.state == S_GALOOMBAWALK or a.state == S_PARAGALOOMBAWINGS then
		local t = a.target
		if not t then a.state = S_GALOOMBASTILL return end
		
		P_InstaThrust(a, a.angle, 5*a.scale)
		
		if (a.tics < 20 or a.state == S_PARAGALOOMBAWINGS) and P_IsObjectOnGround(a) then
			a.lightjump = true
			a.momz = 5*a.scale
		elseif not P_IsObjectOnGround(a) and (a.tics >= 20 or a.state ~= S_PARAGALOOMBAWINGS) then
			a.lightjump = false
		end
		
		if t and t.player and not t.player.powers[pw_flashing] then
			A_FaceTarget(a)
		end
		
		if a.parachute and a.parachute.valid and a.parachute.sprite == SPR_MAP3 then 
			a.flags = $ &~ MF_NOGRAVITY	
			P_RemoveMobj(a.parachute) 
		end		
		if not P_IsObjectOnGround(a) and a.momz < 0 and a.lightjump then a.state = S_GALOOMBAFALLING end
	end
	
	if a.state == S_PARAGALOOMBAPARA then
		a.flags = $|MF_NOGRAVITY
		if P_LookForPlayers(a, 4096 << FRACBITS, true) then
			a.momz = -FRACUNIT
			A_FaceTarget(a)
			P_InstaThrust(a, a.angle, a.scale << 1)
		else
			a.momz = (leveltime % 128) >> 6 and $ - FRACUNIT >> 7 or $ + FRACUNIT >> 7
		end
		if a.floorz+15 << FRACBITS > a.z then
			a.momz = 0
			a.state = S_GALOOMBAWALK
		end
	end
	
	if a.state == S_GALOOMBATURNUPSIDEDOWN then
		if a.tics == 1 then
			a.momz = 5*a.scale
			if a.target then
				A_FaceTarget(a)
			end
			a.state = S_GALOOMBASTILL
			
			if a.parachute and a.parachute.valid and a.parachute.sprite == SPR_MAP3 then 
				a.flags = $ &~ MF_NOGRAVITY			
				P_RemoveMobj(a.parachute) 
			end				
		end
		a.flags = $|MF_SPECIAL &~ MF_ENEMY
	else
		a.flags = $|MF_ENEMY
	end
end, MT_GALOOMBA)

addHook("TouchSpecial", function(a, sp)
	if a.state == S_GALOOMBATURNUPSIDEDOWN then
		a.momx = sp.momx
		a.momy = sp.momy
		a.tics = (a.tics < 256 and $+35 or $)
		a.momz = 10 << FRACBITS
		return true
	end
end, MT_GALOOMBA)

addHook("MobjDamage", function(a, mt)
	if mt.player then
		a.health = 1
		if a.state ~= S_GALOOMBATURNUPSIDEDOWN then
			a.momx = cos(mt.angle) << 2
			a.momy = sin(mt.angle) << 2
			a.momz = 4 << FRACBITS	
			a.state = S_GALOOMBATURNUPSIDEDOWN
		end
		
		return true		
	end
end, MT_GALOOMBA)

addHook("MobjThinker", function(a)
	if mariomode then
		if a.state == S_PUMA_START1 then a.state = S_NEWPUMAMAR end
		if (P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) == false and not twodlevel) then return end
	
		if P_LookForPlayers(a, a.info.speed, true) then
			local rad = a.radius>>FRACBITS
			local trail = P_SpawnMobjFromMobj(a, P_RandomRange(rad, -rad)<<FRACBITS, P_RandomRange(rad, -rad)<<FRACBITS, 0, MT_PUMATRAIL)
			trail.scale = a.scale>>2*3
		end
		
		a.frame = (a.momz < 0 and $|FF_VERTICALFLIP or $ &~ FF_VERTICALFLIP)
		if P_IsObjectOnGround(a) then
			a.momz = $+(a.spawnpoint and a.spawnpoint.angle*a.scale or a.scale*15)
		end
	end
end, MT_PUMA)


addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) == false then return end

	if a.state == S_DEEPCHEEPATTACK then
		local t = a.target
		if t and t.valid and (P_AproxDistance(P_AproxDistance(a.x - t.x, a.y - t.y), a.z - t.z) < 512 << FRACBITS) then 
			P_HomingAttack(a, t)
		else
			a.state = S_DEEPCHEEPROAM
		end
	end
	
	if a.state == S_DEEPCHEEPROAM then
		A_Look(a)
		a.momx = 10*sin(a.angle)
		a.momy = 10*cos(a.angle)
		a.angle = $+ANG1*5
	end
end, MT_DEEPCHEEP)

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) == false then return end

	if a.health < 1 and not a.target then return end
	local t = a.target
	
	if a.state ~= S_LAKITUSSTILL then
		local distxyz = P_AproxDistance(P_AproxDistance(a.x - t.x, a.y - t.y), a.z - t.z)
		local distxy = P_AproxDistance(a.x - t.x, a.y - t.y)		
		if t and t.valid and (distxyz < 8192 << FRACBITS) then 
			a.momx = FixedMul(FixedDiv(t.x - a.x, distxyz), 20 << FRACBITS)
			a.momy = FixedMul(FixedDiv(t.y - a.y, distxyz), 20 << FRACBITS)
			A_FaceTarget(a)
		else
			A_ForceStop(a)
			a.state = S_LAKITUSSTILL
		end
		
		if (distxy < 100 << FRACBITS) and a.state ~= S_LAKITUSAIM and a.state ~= S_LAKITUSSHOOT then
			a.state = S_LAKITUSAIM
		end
		
		if not a.shootnum then
			a.shootnum = {}
		end
		
		if a.state == S_LAKITUSSHOOT and a.tics == 14 then
			S_StartSound(a, sfx_mawii6)
			local shoot = P_SpawnMobjFromMobj(a, 0, 0, 40 << FRACBITS, MT_SPIKY)
			shoot.state = S_SPINYEGG
			shoot.momx = 10*cos(a.angle)
			shoot.momy = 10*sin(a.angle)
			shoot.momz = 3 << FRACBITS
			local table_len = a.shootnum
			if #table_len > 8 then
				local kill_first = false
				local temp_table = {}
				for k,v in ipairs(a.shootnum) do
					if not kill_first then
						P_KillMobj(v)
						a.shootnum[k] = nil
						kill_first = true											
						continue
					end
					table.insert(temp_table, v)
				end
				a.shootnum = temp_table
			end
			table.insert(a.shootnum, shoot)
		end
	end
end, MT_LAKITUS)

local function P_AngleBoolean(ang, angc1, angc2)
	if ang < angc1 and ang > angc2 then
		return true
	else
		return false		
	end
end

addHook("MapThingSpawn", function(a, mt)
	a.extravalue1 = min(max(mt.args[0], 0), 3) or 0
end, MT_BOO)

addHook("MobjSpawn", function(a, mt)
	if a.extravalue1 == 0 then
		a.extravalue1 = P_RandomRange(1,3)
	end
end, MT_BOO)

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, a.scale << 10, true, false) or P_LookForPlayers(a, a.scale << 12, false, false) then
		local t = a.target
	
		if a.health > 0 then
			local tangr = abs(max((t and t.angle or 0)-ANGLE_180, a.angle) - min(a.angle, (t and t.angle or 0)-ANGLE_180))/ANG1
			local state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
			if a.tracer then
				if a.state ~= state then
					a.state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
				end
				if t then
					A_FaceTarget(a)
				end
			else
				if t then
					if tangr < 30 then
						a.state = S_BOOBLOCK
						A_ForceStop(a)
					elseif tangr < 45 then -- side eye watching
						a.state = S_BOOBLOCKLOOKING
						A_ForceStop(a)
					else
						if a.state ~= state then
							a.state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
						end
						P_HomingAttack(a, t)
						if (leveltime % 5) >> 2 then
							A_GhostMe(a)
						end
				
						if not (leveltime % 56) then
							S_StartSound(a, sfx_mar64f)
						end
					end
				else
					a.state = S_BOOSTILL
					A_ForceStop(a)
				end
			end
		end
	else
		a.target = nil
	end
end, MT_BOO)


addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) == false then return end
	
	local t = a.target
	
	if not P_IsObjectOnGround(a) then
		a.state = S_SPINYEGG
	elseif P_IsObjectOnGround(a) and a.state == S_SPINYEGG then
		a.state = S_SPIKYSPAWN
	end
	
	if t and t.valid then
		local distxy = abs(P_AproxDistance(a.x - t.x, a.y - t.y))
		if (t.flags2 &~ MF2_OBJECTFLIP) and (a.flags2 & MF2_OBJECTFLIP) and (distxy < FixedMul(a.info.radius, a.scale)) then
			a.flags2 = $ &~ MF2_OBJECTFLIP
		end
	end
end, MT_SPIKY)