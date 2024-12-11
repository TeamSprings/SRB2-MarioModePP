local foes = tbsrequire 'entities/foes_common'

local lerp = TBSlib.lerp

-- #region Unused

--	A_GuardChase without function to move into PainState, due to lack of shield
--* Contributed by Lat' per request (Thank you Lat'!)
---@deprecated
---@param actor mobj_t
function A_FakeGuardChase(actor)
	if not (actor and actor.valid and P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) == true) then
		actor.tics = states[actor.state].tics
		return
	end

	actor.reactiontime = $ and $-1 or 0

	local speed = actor.info.speed*actor.scale*(actor.extravalue1 or 1)

	if speed and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, speed), actor.y + P_ReturnThrustY(actor, actor.angle, speed), (actor.flags2 & MF2_AMBUSH and true or false)) and actor.valid and speed > 0 then
		if actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == MTF_OBJECTSPECIAL) then
			actor.angle = $+ ANGLE_90
		elseif actor.spawnpoint and ((actor.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == 1) then
			actor.angle = $- ANGLE_90
		else
			actor.angle = $+ ANGLE_180
		end
	end
end

-- #endregion
-- #region Hook functions

---@param mo mobj_t
local function P_KoopaThinker(mo)
	if mo.state == S_KOOPAPATROLING1 then
		if not (mo and mo.valid and P_LookForPlayers(mo, libOpt.ENEMY_CONST, true, false) == true) then
			mo.frame = states[mo.state].frame
			return
		end

		if mo.extravalue1 then
			if mo.cusval == -1 then
				mo.cusval = 1<<mo.extravalue1
			end

			mo.angle = $+(mo.extravalue2 >> mo.extravalue1)
			mo.cusval = $-1
			if mo.cusval == 0 then
				mo.extravalue2 = 0
				mo.extravalue1 = 0
			end
		else
			mo.reactiontime = $ and $-1 or 0
			mo.cusval = -1

			local speed = 3*((mo.info.speed*mo.scale)*(mo.extravalue1 or 1)) >> 3

			if speed and not P_TryMove(mo, mo.x + P_ReturnThrustX(mo, mo.angle, speed), mo.y + P_ReturnThrustY(mo, mo.angle, speed), (mo.flags2 & MF2_AMBUSH and true or false)) and mo.valid and speed > 0 then
				if mo.spawnpoint and ((mo.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == MTF_OBJECTSPECIAL) then
					mo.extravalue1 = 2
					mo.extravalue2 = ANGLE_90
				elseif mo.spawnpoint and ((mo.spawnpoint.options & (1|MTF_OBJECTSPECIAL)) == 1) then
					mo.extravalue1 = 2
					mo.extravalue2 = -ANGLE_90
				else
					mo.extravalue1 = 3
					mo.extravalue2 = ANGLE_180
				end
			end
		end
	end
end

---@param mo mobj_t
local function P_ShellLayerThinker(mo)
	if mo.valid and (mo.momx ~= 0 or mo.momy ~= 0) then
		if not mo.spineffect then
			mo.spineffect = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)
			mo.spineffect.state = S_MMSHELLPARTICLE
			mo.spineffect.target = mo
			mo.spineffect.dispoffset = 4
			mo.spineffect.spritexscale = 3*FRACUNIT/5
			mo.spineffect.spriteyscale = 3*FRACUNIT/5
		end
	else
		if mo.spineffect then
			if mo.spineffect.valid then
				P_RemoveMobj(mo.spineffect)
			end
			mo.spineffect = nil
		end
	end
end

--* Written by Skydusk
---@param mo mobj_t
---@param mt mapthing_t
local function P_KoopaColoring(mo, mt)
	--Behavioral setting
	if not (mo and mo.valid) then return end

	mo.behsetting = mt.args[0] or mt.extrainfo
	local color = { [1] = SKINCOLOR_EMERALD, [2] = SKINCOLOR_RUBY, [3] = SKINCOLOR_GOLDENROD, [4] = SKINCOLOR_SAPPHIRE }
	mo.color = color[mo.behsetting] or 0
end

--* Braindead spawners by Skydusk
---@param mo mobj_t
function A_KoopaSpawn(mo)
	local koopa = P_SpawnMobjFromMobj(mo, 0,0,0, MT_MGREENKOOPA)
	koopa.extrainfo = mo.extrainfo and (mo.extrainfo or (mo.spawnpoint and mo.spawnpoint.args[0] or mo.spawnpoint.extrainfo)) or 0
	koopa.angle = mo.angle or (mo.spawnpoint and mo.spawnpoint.angle*ANG1 or 0)
	koopa.scale = mo.scale
	koopa.color = mo.color
end

---@param mo mobj_t
function A_ShellSpawn(mo)
	local shell = P_SpawnMobjFromMobj(mo, 0,0,0, MT_SHELL)
	shell.extrainfo = mo.extrainfo and (mo.extrainfo or (mo.spawnpoint and mo.spawnpoint.args[0] or mo.spawnpoint.extrainfo)) or 0
	shell.angle = mo.angle or (mo.spawnpoint and mo.spawnpoint.angle*ANG1 or 0)
	shell.scale = mo.scale
	shell.color = mo.color

	if mo.type ~= MT_BUZZYBEETLE then return end
	shell.sprite = SPR_0BET
	shell.frame = E
end

--* Written by Skydusk
---@param mo mobj_t
---@param th mobj_t
local function P_ShellPop(mo, th)
	if not (th.type == MT_PLAYER and (th.z > mo.z + mo.info.height) or
	(P_IsObjectOnGround(th) and mo.momx == 0 or mo.momy == 0)) then return end

	local pop = P_SpawnMobjFromMobj(mo, lerp(FRACUNIT >> 1, mo.x, th.x)-mo.x, lerp(FRACUNIT >> 1, mo.y, th.y)-mo.y, lerp(FRACUNIT >> 1, mo.z, th.z)-mo.z, MT_POPPARTICLEMAR)
	pop.momx = 0
	pop.momy = 0
	pop.momz = 0
	pop.fuse = TICRATE
	pop.scale = mo.scale
	A_SpawnMarioStars(mo, th)
end

---@param mo mobj_t
---@param th mobj_t
local function P_ShellShellCollider(mo, th)
	if th.type == MT_SHELL and th.z >= mo.z and th.z <= mo.z+mo.height then
		local pop = P_SpawnMobjFromMobj(mo, lerp(FRACUNIT >> 1, mo.x, th.x)-mo.x, lerp(FRACUNIT >> 1, mo.y, th.y)-mo.y, lerp(FRACUNIT >> 1, mo.z, th.z)-mo.z, MT_POPPARTICLEMAR)
		pop.momx = 0
		pop.momy = 0
		pop.momz = 0
		pop.fuse = TICRATE
		pop.scale = mo.scale
		if not mo.threshold then
			mo.movedir = (mo.movedir == 1 and -1 or 1)
			P_InstaThrust(mo, th.angle, mo.info.speed*mo.scale)
			mo.target = th.target or th
			mo.threshold = (3*TICRATE)/2
		end

		return true
	end
end

-- #endregion
-- #region Hooks
addHook("MobjThinker", P_KoopaThinker, MT_MGREENKOOPA)
addHook("MobjThinker", P_ShellLayerThinker, MT_MGREENKOOPA)

addHook("MapThingSpawn", P_KoopaColoring, MT_MGREENKOOPA)
addHook("MapThingSpawn", P_KoopaColoring, MT_BPARAKOOPA)
addHook("MapThingSpawn", P_KoopaColoring, MT_PARAKOOPA)

addHook("TouchSpecial", P_ShellPop, MT_SHELL)
addHook("MobjCollide", 	P_ShellShellCollider, MT_SHELL)

addHook("MobjDamage", foes.KoopaPop, MT_BPARAKOOPA)
addHook("MobjDamage", foes.KoopaPop, MT_PARAKOOPA)
addHook("MobjDamage", foes.KoopaPop, MT_MGREENKOOPA)

addHook("MapThingSpawn", foes.Spawnenemywings, MT_BPARAKOOPA)
addHook("MapThingSpawn", foes.Spawnenemywings, MT_PARAKOOPA)
-- #endregion