local foes = tbsrequire 'entities/foes_common'

--[[

	Probably due to rewrite

--]]


-- #region Functions for shared Hooks

---@param mo mobj_t
local function P_PiranhaDeath(mo)
	if not (mo and mo.valid) then return end

	local dummy = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_POPPARTICLEMAR)
	dummy.state = S_MARIOSTARS

	A_Scream(dummy)

	-- Koopa exception
	if mo.type == MT_MGREENKOOPA
	or mo.type == MT_PARAKOOPA
	or mo.type == MT_BPARAKOOPA then
		dummy.sprite = SPR_SHLL
	else
		dummy.sprite = mo.sprite
	end

	dummy.color = mo.color
	dummy.flags = $|MF_NOCLIPHEIGHT &~ (MF_NOGRAVITY)

	dummy.momx = 5*FRACUNIT
	dummy.momy = 5*FRACUNIT
	dummy.momz = 15*FRACUNIT

	dummy.fuse = 60

	dummy.angle = mo.angle
	dummy.fireballp = true

	dummy.fading = 20

	A_CoinDrop(mo, 0, 0)
	P_RemoveMobj(mo)
end

---@param mo mobj_t
local function P_PartsDeleter(mo)
	if mo.parts then
		for _,part in ipairs(mo.parts) do
			if part and part.valid then
				P_RemoveMobj(part)
			end
		end

		mo.parts = nil
	end
end

---@param mo mobj_t
---@param tm mapthing_t
local function P_VerticalStonk(mo, tm)
	local workz, workh, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	mo.scale = scale
	mo.parts = {}
	-- translated A_ConnectToGround
	if mo.z ~= mo.floorz then
		workz = mo.floorz - mo.z
		workh = 21 << FRACBITS
		workb = P_SpawnMobjFromMobj(mo, 0, 0, workz, MT_NSMBPALMTREE)
		workb.state = S_BLOCKVIS
		workb.sprite = SPR_MRPS
		workb.frame = C
		workb.flags = $|MF_PAIN|MF_NOCLIPHEIGHT
		workz = $ + workh
		table.insert(mo.parts, workb)

		if workh ~= 21 << FRACBITS then
			return
		end

		while (workz < 0) do
			work = P_SpawnMobjFromMobj(mo, 0,0, workz, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = C
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW
			workz = $ + workh
			table.insert(mo.parts, work)
		end
		if (workz ~= 0) then
			P_SetOrigin(mo, mo.x, mo.y, mo.z + workz)
		end
	end
end

-- #endregion
-- #region Hooks for specific behaviors
addHook("MobjThinker", function(mo)
	if mo.spawnpoint and (mo.spawnpoint.options & MTF_EXTRA or mo.spawnpoint.args[0] > 0) then
		if mo.timerbop == nil or mo.timerbop <= 0 then
			mo.timerbop = 200
		end
		if mo.timerbop > 0 and not (mo.timer == 101 and P_LookForPlayers(actor, 386 << FRACBITS, true, false)) then
			mo.timerbop = $-1
		end

		if mo.timerbop == 199 then
			mo.momz = -FRACUNIT << 2
			mo.fireballready = false
			mo.timer = 75
		end

		if mo.timerbop == 149 then
			mo.momz = 0
		end

		if mo.timerbop == 100 then
			mo.momz = FRACUNIT << 2
		end

		if mo.timerbop == 50 then
			mo.momz = 0
		end
			
		if mo and mo.valid then
			for _,parts in ipairs(mo.parts) do
				if parts and parts.valid then
					parts.momz = mo.momz
				end
			end
		end
	end
end, MT_REDPIRANHAPLANT)

addHook("MobjThinker", function(mo)
	if mo.spawnpoint and (mo.spawnpoint.options & MTF_EXTRA or mo.spawnpoint.args[0] > 0) then
		if mo.timerbop == nil or mo.timerbop <= 0 then
			mo.timerbop = 200
		end
		if mo.timerbop > 0 and not (mo.timer == 101 and P_LookForPlayers(actor, 386 << FRACBITS, true, false)) then
			mo.timerbop = $-1
		end

		if mo.timerbop == 199 then
			mo.momz = -FRACUNIT << 2
			mo.fireballready = false
			mo.timer = 75
		end

		if mo.timerbop == 149 then
			mo.momz = 0
		end

		if mo.timerbop == 100 then
			mo.momz = FRACUNIT << 2
		end

		if mo.timerbop < 100 and mo.timerbop > 0 then
			mo.fireballready = true
		end

		if mo.timerbop == 50 then
			mo.momz = 0
		end
			
		if mo and mo.valid then
			for _,parts in ipairs(mo.parts) do
				if parts and parts.valid then
					parts.momz = mo.momz
				end
			end
		end
	else
		mo.fireballready = true
	end

	if mo.fireballready then

		if mo.timer == nil then
			mo.targeting = nil			
			mo.timer = 75
		end
		mo.timer = $-1 or 75

		if P_LookForPlayers(mo, 5120 << FRACBITS, true, false) and P_CheckSight(mo, mo.target) then
			local z, dest = mo.z+2*mo.height/3, mo.target
			mo.angle = mo.angle + FixedMul(R_PointToAngle2(mo.x, mo.y, dest.x, dest.y) - mo.angle, FRACUNIT >> 3)
			if dest and not mo.targeting then
				mo.state = S_FIREPIRANHAPLANT1
				mo.targeting = {x = dest.x, y = dest.y, z = dest.z}
			end

			if mo.timer == 1 and mo.targeting then
				S_StartSound(mo, sfx_mario7)

				local missile = P_SpawnPointMissile(mo, mo.targeting.x, mo.targeting.y, mo.targeting.z, MT_PKZFB, mo.x, mo.y, z)
				missile.fuse = 200
				missile.flags = MF_MISSILE|MF_PAIN|MF_NOGRAVITY
				missile.non_player = true

				mo.targeting = nil
				mo.timer = nil
				mo.fireballready = nil
			end
		end
	end
end, MT_FIREFPIRANHAPLANT)

addHook("MapThingSpawn", function(mo, tm)
	local spawn, comp, workz, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	mo.scale = scale
	mo.parts = {}
	-- translated A_ConnectToGround
	spawn = (tm.extrainfo*2 or tm.args[0]*2)+1
	comp = 0

		while (comp < spawn) do
			work = P_SpawnMobjFromMobj(mo, -(21*comp+24)*cos(angle), -(21*comp+24)*sin(angle), 4*FRACUNIT, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = D|FF_PAPERSPRITE
			work.rollangle = ANGLE_90
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIP|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW
			comp = $+1
			table.insert(mo.parts, work)
		end
end, MT_REDHPIRANHAPLANT)

addHook("MobjThinker", function(mo)
	if not (mo.spawnpoint and (mo.spawnpoint.options & MTF_EXTRA or mo.spawnpoint.args[0] > 0)) then return end

	if mo.timerbop == nil or mo.timerbop <= 0 then
		mo.timerbop = 250
	end

	if mo.timerbop > 0 and not (mo.timer == 101 and P_LookForPlayers(mo, 386 << FRACBITS, true, false)) then
		mo.timerbop = $-1
	end

	if mo.timerbop == 249 then
		mo.momz = -FRACUNIT << 1
	end

	if mo.timerbop == 174 then
		mo.momz = 0
	end

	if mo.timerbop == 100 then
		mo.momz = 6 << FRACBITS
	end

	if mo.timerbop == 75 then
		mo.momz = 0
	end

end, MT_REDJPIRANHAPLANT)

addHook("MobjThinker", function(mo)
	if not (mo and mo.valid and mo.spawnpoint and (mo.spawnpoint.options & MTF_EXTRA or mo.spawnpoint.args[1] > 0)) then return end

	if mo.timerbop == nil or mo.timerbop <= 0 then
		mo.timerbop = 200
	end
	if mo.timerbop > 0 and not (mo.timer == 101 and P_LookForPlayers(mo, 386 << FRACBITS, true, false)) then
		mo.timerbop = $-1
	end

	if mo.timerbop == 199 then
		mo.momx = -cos(mo.angle) << 2
		mo.momy = -sin(mo.angle) << 2
	end

	if mo.timerbop == 149 then
		mo.momx = 0
		mo.momy = 0
	end

	if mo.timerbop == 100 then
		mo.momx = cos(mo.angle) << 2
		mo.momy = sin(mo.angle) << 2
	end

	if mo.timerbop == 50 then
		mo.momx = 0
		mo.momy = 0
	end

	for _,parts in ipairs(mo.parts) do
		parts.momx = mo.momx
		parts.momy = mo.momy
	end

end, MT_REDHPIRANHAPLANT)
-- #endregion
-- #region Shared Hooks
addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDJPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_FIREFPIRANHAPLANT)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_REDHPIRANHAPLANT)

addHook("MobjMoveCollide", foes.InvinciMobjKiller, MT_REDPIRANHAPLANT)
addHook("MobjMoveCollide", foes.InvinciMobjKiller, MT_REDJPIRANHAPLANT)
addHook("MobjMoveCollide", foes.InvinciMobjKiller, MT_FIREFPIRANHAPLANT)
addHook("MobjMoveCollide", foes.InvinciMobjKiller, MT_REDHPIRANHAPLANT)

addHook("MobjDeath", P_PiranhaDeath, MT_REDPIRANHAPLANT)
addHook("MobjDeath", P_PiranhaDeath, MT_REDJPIRANHAPLANT)
addHook("MobjDeath", P_PiranhaDeath, MT_FIREFPIRANHAPLANT)
addHook("MobjDeath", P_PiranhaDeath, MT_REDHPIRANHAPLANT)

addHook("MobjRemoved", P_PartsDeleter, MT_REDPIRANHAPLANT)
addHook("MobjRemoved", P_PartsDeleter, MT_FIREFPIRANHAPLANT)
addHook("MobjRemoved", P_PartsDeleter, MT_REDHPIRANHAPLANT)

addHook("MapThingSpawn", P_VerticalStonk, MT_REDPIRANHAPLANT)
addHook("MapThingSpawn", P_VerticalStonk, MT_FIREFPIRANHAPLANT)
-- #endregion