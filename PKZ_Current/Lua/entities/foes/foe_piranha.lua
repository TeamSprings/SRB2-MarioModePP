
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


for _,piranhas in pairs({
	MT_REDPIRANHAPLANT,
	MT_FIREFPIRANHAPLANT
}) do


addHook("MapThingSpawn", function(a, tm)
	local workz, workh, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	a.scale = scale
	a.parts = {}
	-- translated A_ConnectToGround
	if a.z ~= a.floorz then
		workz = a.floorz - a.z
		workh = 21 << FRACBITS
		workb = P_SpawnMobjFromMobj(a, 0, 0, workz, MT_NSMBPALMTREE)
		workb.state = S_BLOCKVIS
		workb.sprite = SPR_MRPS
		workb.frame = C
		workb.flags = $|MF_PAIN|MF_NOCLIPHEIGHT
		workz = $ + workh
		table.insert(a.parts, workb)

		if workh ~= 21 << FRACBITS
			return
		end

		while (workz < 0) do
			work = P_SpawnMobjFromMobj(a, 0,0, workz, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = C
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW
			workz = $ + workh
			table.insert(a.parts, work)
		end
		if (workz ~= 0) then
			P_SetOrigin(a, a.x, a.y, a.z + workz)
		end
	end
end, piranhas)

end

addHook("MapThingSpawn", function(a, tm)
	local spawn, comp, workz, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	a.scale = scale
	a.parts = {}
	-- translated A_ConnectToGround
	spawn = (tm.extrainfo*2 or tm.args[0]*2)+1
	comp = 0

		while (comp < spawn) do
			work = P_SpawnMobjFromMobj(a, -(21*comp+24)*cos(angle), -(21*comp+24)*sin(angle), 4*FRACUNIT, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = D|FF_PAPERSPRITE
			work.rollangle = ANGLE_90
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIP|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW
			comp = $+1
			table.insert(a.parts, work)
		end
end, MT_REDHPIRANHAPLANT)