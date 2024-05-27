local foes = tbsrequire 'entities/foes_common'

//	A_GuardChase without function to move into PainState, due to lack of shield
//	Contributed by Lat' per request (Thank you Lat'!)
function A_FakeGuardChase(actor)
	if not (actor and actor.valid and P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) == true) then
		actor.tics = states[actor.state].tics
		return
	end

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
		if not (actor and actor.valid and P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) == true) then
			actor.frame = states[actor.state].frame
			return
		end

		if actor.extravalue1 then
			if actor.cusval == -1 then
				actor.cusval = 1<<actor.extravalue1
			end

			actor.angle = $+(actor.extravalue2 >> actor.extravalue1)
			actor.cusval = $-1
			if actor.cusval == 0 then
				actor.extravalue2 = 0
				actor.extravalue1 = 0
			end
		else
			actor.reactiontime = $ and $-1 or 0
			actor.cusval = -1

			local speed = 3*((actor.info.speed*actor.scale)*(actor.extravalue1 or 1)) >> 3

			if speed and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, speed), actor.y + P_ReturnThrustY(actor, actor.angle, speed), (actor.flags2 & MF2_AMBUSH and true or false)) and actor.valid and speed > 0
				if actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == MTF_OBJECTSPECIAL) then
					actor.extravalue1 = 2
					actor.extravalue2 = ANGLE_90
				elseif actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == 1) then
					actor.extravalue1 = 2
					actor.extravalue2 = -ANGLE_90
				else
					actor.extravalue1 = 3
					actor.extravalue2 = ANGLE_180
				end
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

// Shellpop... quite same as before KoopaPop
// Written by Ace

local function ShellPop(actor, toucher)
	if not (not actor.mariofrozenkilled and toucher.type == MT_PLAYER and (toucher.z > actor.z + actor.info.height) or
	(P_IsObjectOnGround(toucher) and not (actor.momx or actor.momy))) then return end

	local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
	spawndamageparticle.fuse = TICRATE
	spawndamageparticle.scale = actor.scale
	A_SpawnMarioStars(actor, toucher)
end

local function ShellvsShell(actor, toucher)
	if toucher.type == MT_SHELL and toucher.z >= actor.z and toucher.z <= actor.z+actor.height then
		local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
		spawndamageparticle.momx = 0
		spawndamageparticle.momy = 0
		spawndamageparticle.momz = 0
		spawndamageparticle.fuse = TICRATE
		spawndamageparticle.scale = actor.scale
		if not actor.threshold then
			actor.movedir = (actor.movedir == 1 and -1 or 1)
			P_InstaThrust(actor, toucher.angle, actor.info.speed*actor.scale)
			actor.target = toucher.target or toucher
			actor.threshold = (3*TICRATE)/2
		end
		return true
	end
end

// Fire Ball Death Thinker for specific Enemies
// Written by Ace

local function FireballDeath(actor, toucher)
	if not (toucher and (toucher.type == MT_FIREBALL or actor.mariofrozenkilled or toucher.type == MT_PKZFB or toucher.type == MT_PKZGB or
	toucher.type == MT_SHELL and toucher.type ~= MT_PKZGB)) then return end

	A_Scream(actor)
	A_CoinDrop(actor, (toucher.type == MT_PKZGB and 4 or 0), 0)

	local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
	dummyobject.state = S_MARIOSTARS
	if actor.type == MT_MGREENKOOPA or actor.type == MT_PARAKOOPA or actor.type == MT_BPARAKOOPA
		dummyobject.sprite = SPR_SHLL
	else
		dummyobject.sprite = actor.sprite
	end
	dummyobject.color = actor.color
	dummyobject.flags = $|MF_NOCLIPHEIGHT
	dummyobject.flags = $ &~ MF_NOGRAVITY
	dummyobject.momz = 8*FRACUNIT
	dummyobject.momx = 3*FRACUNIT
	dummyobject.momy = 3*FRACUNIT
	dummyobject.fuse = 60
	dummyobject.angle = actor.angle
	dummyobject.fireballp = true
	if toucher.type == MT_PKZGB then
		dummyobject.translation = "MarioSonGOLD"
	end
	P_RemoveMobj(actor)
end

addHook("MobjDamage", foes.KoopaPop, MT_BPARAKOOPA)
addHook("MobjDamage", foes.KoopaPop, MT_PARAKOOPA)
addHook("MobjDamage", foes.KoopaPop, MT_MGREENKOOPA)
addHook("TouchSpecial", ShellPop, MT_SHELL)
addHook("MobjCollide", ShellvsShell, MT_SHELL)
addHook("MobjDamage", FireballDeath, MT_BPARAKOOPA)
addHook("MobjDamage", FireballDeath, MT_PARAKOOPA)
addHook("MobjDamage", FireballDeath, MT_MGREENKOOPA)
addHook("MobjDamage", FireballDeath, MT_SHELL)

addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDJPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_FIREFPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDHPIRANHAPLANT)

addHook("MapThingSpawn", foes.Spawnenemywings, MT_BPARAKOOPA)
addHook("MapThingSpawn", foes.Spawnenemywings, MT_PARAKOOPA)