--[[ 
		Pipe Kingdom Zone's Bowser - bow_helpers.lua

Contributors: Zipper, Skydusk(edits)
@Team Blue Spring 2024
--]]


--double negative wtffffff
rawset(_G, "P_ZCheck", function(m1,m2)
	return not (m1.z > m2.z + m2.height or m2.z > m1.z + m1.height)
end)

rawset(_G, "P_AimLaunch", function (m1, m1target, airtime)
	local hordist = R_PointToDist2(m1.x,m1.y, m1target.x, m1target.y)
	local ang = R_PointToAngle2(m1.x,m1.y, m1target.x, m1target.y)
	local verdist = m1.target.z - m1.z
	local fulldist = hordist + FixedDiv(FixedMul(verdist,verdist),hordist) * (verdist > 0 and -1 or 1)
	
	local horspeed = fulldist / airtime
	local verspeed = FixedMul((gravity*airtime) >> 1, m1.scale)
	
	m1.momx = FixedMul(horspeed, cos(ang))
	m1.momy = FixedMul(horspeed, sin(ang))
	m1.momz = verspeed
end)

rawset(_G, "P_ParticleSpawn", function (mo, type, range, count, time) --what does P even stand for
	count = $ or 20
	range = $ or (mo.radius >> FRACBITS)
	local xoff = P_RandomRange(-range,range) << FRACBITS
	local yoff = P_RandomRange(-range,range) << FRACBITS
	local zoff = P_RandomRange(0,range) << FRACBITS

	for i = 1, count do
		local part = P_SpawnMobjFromMobj(mo, xoff, yoff, zoff, type)
		part.momz = P_RandomRange(1,5) << FRACBITS * P_MobjFlip(mo)
		part.scale = $ * P_RandomRange(2,4) / 3
		part.destscale = part.scale >> 1
		part.fuse = time or 8
		part.color = SKINCOLOR_WHITE
	end
end)


rawset(_G, "S_PlayRandomSound", function (mo, tab)
	S_StartSound(mo, tab[P_RandomRange(1, #tab)])
end)

rawset(_G, "P_SpawnTrail", function(mo, type, fuse)
	for i = -1, 1, 2 do
		local offang = mo.angle + ANGLE_90*i
		local offx = 50*cos(mo.angle) + 20*cos(offang)
		local offy = 50*sin(mo.angle) + 20*sin(offang)
		local dust = P_SpawnMobjFromMobj(mo,offx,offy,0, type) --takes scale into account again UUUUUUGH
		dust.fuse = fuse
	end
end)