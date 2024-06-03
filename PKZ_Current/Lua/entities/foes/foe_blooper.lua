
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
	if actor.isbaby == true and tracer then
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
				actor.cmomh = -(FixedHypot(offset*(tracer.momy - actor.tmomy)*2, offset*(tracer.momx - actor.tmomx)*2))/FRACUNIT
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
						actor.momz = $ - (FRACUNIT >> 3)
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
						actor.momz = -(FRACUNIT >> 3)
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