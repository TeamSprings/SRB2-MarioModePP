/* 
		Pipe Kingdom Zone's Bowser - bow_otherthink.lua

Contributors: Zipper, Skydusk(edits)
@Team Blue Spring 2024
*/


--whaaaat's the deal with these names? are they mines or maces?

local function mineCollide(mine, tmthing)
	if mine.state ~= S_BOMBMACE1 then return false end --disregard if exploding
	if not P_ZCheck(mine,tmthing) then return false end --not colliding
	if (tmthing.type == MT_BOWSER or tmthing.type == MT_PLAYER) then
		if (tmthing.type == MT_BOWSER) then
			if tmthing.flags2 & MF2_FRET then return false end
			if tmthing.state ~= S_BOWSER_LAUNCH then return false end
		end
		P_DamageMobj(tmthing, mine, mine, 1)
		
		mine.state = S_BOMBMACE2 --no, make it more metal
		P_StartQuake(15*FRACUNIT,TICRATE)
		
		local ang = 0
		local SPD = 8*FRACUNIT
		for k = 1,3 do
			local SPD_SCALED = SPD * k * 2 / 3
			ang = 0
			for i = 1,8 do 
				for j = -45,45,45 do
					local boomboom = P_SpawnMobj(mine.x, mine.y, mine.z, MT_TNTDUST)
					local vertang = j * ANG1
					boomboom.momx = FixedMul(cos(ang), FixedMul(cos(vertang), SPD_SCALED))
					boomboom.momy = FixedMul(sin(ang), FixedMul(cos(vertang), SPD_SCALED))
					boomboom.momz = FixedMul(sin(vertang), SPD_SCALED)
				end
				ang = $ + ANGLE_45
			end
		end
		
		S_StartSound(mine, sfx_bexpld)
	end
end

addHook("MobjCollide", mineCollide, MT_BOMBMACE)



local function fireThink(mo)
	mo.momx = 97*$ / 100
	mo.momy = 97*$ / 100
	mo.momz = $ - P_MobjFlip(mo) * FRACUNIT>>3
	if (P_IsObjectOnGround(mo) and mo.health) then P_KillMobj(mo) end
end

addHook("MobjThinker", fireThink, MT_BOWSER_FIRE)


local function goomballThink(mo)
	mo.rollangle = $ + ANG20
	if not mo.health then return end
	if P_IsObjectOnGround(mo) then
		mo.extravalue2 = $ + 1
		S_StartSound(mo, sfx_s3k5f)
		P_StartQuake(10*FRACUNIT, TICRATE/2)
		A_NapalmScatter(mo, MT_SPINDUST+16<<FRACBITS, 128+16*FRACUNIT)
		
		local ang = mo.angle
		
		if mo.tracer then
			ang = R_PointToAngle2(mo.x, mo.y, mo.tracer.x, mo.tracer.y)
		end
		
		mo.momx, mo.momy = (24 - mo.extravalue2)*cos(ang)/2, (24 - mo.extravalue2)*sin(ang)/2
		mo.momz = P_MobjFlip(mo)*(32 - mo.extravalue2*2)*FRACUNIT/2
		
		if (mo.extravalue2 >= 12) then
			P_KillMobj(mo)
			return
		end
	end
end

addHook("MobjThinker", goomballThink, MT_BOWSER_GOOMBALL)


local function goomballDeath(mo,inf,src,dmg,dtype)
	for i = 0, 9 do
		local ang = i * ANGLE_45
		local radius_int = mo.radius/FRACUNIT
		local offx = P_RandomRange(0, radius_int)*3
		local offy = P_RandomRange(0, radius_int)*3
		local shoot = P_RandomRange(16,32)
		local goom = P_SpawnMobjFromMobj(mo, offx*cos(ang), offy*sin(ang), mo.height>>1, 552)
		goom.momx = shoot*cos(ang)
		goom.momy = shoot*sin(ang)
		goom.momz = P_MobjFlip(mo)*shoot*FRACUNIT>>2
		goom.target = mo.target.target
		goom.angle = ang
	end
	local dust = P_SpawnMobjFromMobj(mo,0,0,0, MT_ARIDDUST)
	dust.scale = 2*FRACUNIT
end


addHook("MobjRemoved", goomballDeath, MT_BOWSER_GOOMBALL)

local function goombaBallCollide(a, tmthing)
	if not P_ZCheck(a,tmthing) then return false end --not colliding
	if (tmthing.type == MT_BOWSER or tmthing.type == MT_PLAYER) then
		if (tmthing.type == MT_BOWSER) then
			if tmthing.state <= S_BOWSER_FALL1 and tmthing.state >= S_BOWSER_FALL2 then return false end
		end
		P_DamageMobj(tmthing, a, a, 1)
		P_KillMobj(a, tmthing, tmthing)		
	end
end

addHook("MobjCollide", goombaBallCollide, MT_BOWSER_GOOMBALL)