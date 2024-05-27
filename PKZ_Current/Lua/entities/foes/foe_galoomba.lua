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
