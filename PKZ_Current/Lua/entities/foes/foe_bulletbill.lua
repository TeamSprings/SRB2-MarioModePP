
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


// Bullet Bill Death
// Written by Ace
local function BulletDeathCheck(actor, mo)
	if not (actor and actor.valid) then return end

	if mo and mo.valid then
		if mo.state == S_PLAY_JUMP or mo.state == S_PLAY_ROLL then
		local spawndamageparticle = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
		spawndamageparticle.fuse = TICRATE
		spawndamageparticle.scale = (actor.scale << 2)/3
		S_StartSound(actor, sfx_pop)
		P_RemoveMobj(actor)
		else
			if not P_LookForPlayers(actor, 5024 << FRACBITS, true, false) then
				S_StartSound(actor, actor.info.deathsound)
				P_RemoveMobj(actor)
			else
				A_TNTExplode(actor, MT_TNTDUST)
				S_StartSound(actor, actor.info.deathsound)
				P_RemoveMobj(actor)
			end
		end
	else
		if not P_LookForPlayers(actor, 5024 << FRACBITS, true, false) then
			S_StartSound(actor, actor.info.deathsound)
			P_RemoveMobj(actor)
		else
			A_TNTExplode(actor, MT_TNTDUST)
			S_StartSound(actor, actor.info.deathsound)
			P_RemoveMobj(actor)
		end
	end
end

addHook("MobjDeath", BulletDeathCheck, MT_BULLETBILL)
addHook("MobjDeath", BulletDeathCheck, MT_HOMINGBULLETBILL)
