local foes = tbsrequire 'entities/foes_common'

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

addHook("MobjDamage", foes.KoopaPop, MT_MARIOFISH)
addHook("MobjDamage", foes.KoopaPop, MT_DEEPCHEEP)

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


addHook("MapThingSpawn", function(a, mt)
	local angle = FixedAngle(mt.angle << FRACBITS)
	local scale = a.info.radius
	local base = P_SpawnMobjFromMobj(a, -P_ReturnThrustX(a, angle, scale), -P_ReturnThrustY(a, angle, scale), 0, MT_BLOCKVIS)
	base.angle = angle + ANGLE_90
	base.target = a
	base.state = S_HORIZONTALCASTSPIKEBASE
end, MT_HORIZONTALCASTSPIKE)

addHook("MobjCollide", function(a, t)
	if t and t.player and t.z < a.z+a.height-4*FRACUNIT and t.z+t.height > a.z-4*FRACUNIT and
	not (t.player.powers[pw_invulnerability] or t.player.powers[pw_flashing] or t.player.powers[pw_super]) then
		P_DamageMobj(t)
	end
end, MT_HORIZONTALCASTSPIKE)

addHook("MobjCollide", function(a, t)
	if t and t.player and t.z > a.z+a.height and t.z <= a.z+a.height+4*FRACUNIT and a.momz == 0 and
	not (t.player.powers[pw_invulnerability] or t.player.powers[pw_flashing] or t.player.powers[pw_super]) then
		P_DamageMobj(t)
	end
end, MT_CASTLESPIKES)

addHook("MobjCollide", foes.InvinciMobjKiller, MT_BIGMOLE)
addHook("MobjCollide", foes.InvinciMobjKiller, MT_SHYGUY)



local FIXED_VOL_ICE = 32 << FRACBITS

// Ice Statues and GOLD!
// Written by Ace
addHook("MobjDeath", function(actor, mo, source)
	if not (actor and actor.valid and actor.flags & MF_ENEMY and actor.info.spawnhealth <= 2 and mo and mo.valid) then return end
		if mo.type == MT_PKZIB then
			local heightdif = 0
			local dummyobject = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_BLOCKVIS)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.frame = actor.frame &~ FF_ANIMATE
			dummyobject.color = SKINCOLOR_ICY
			dummyobject.translation = "MarioSonICE"
			dummyobject.colorized = true
			dummyobject.flags = $|MF_SOLID|MF_PUSHABLE & ~(MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_NOCLIPTHING)
			dummyobject.fuse = 320
			dummyobject.phase = 0
			dummyobject.angle = actor.angle
			dummyobject.scale = actor.scale
			dummyobject.radius = FRACUNIT<<5
			dummyobject.height = actor.height + FIXED_VOL_ICE - (actor.height % FIXED_VOL_ICE)
			dummyobject.ogmobjtype = actor.type
			dummyobject.ogcolor = actor.color
			dummyobject.ogcolorized = actor.colorized
			dummyobject.sourcekiller = source
			dummyobject.sprmodel = 99
			dummyobject.sides = {}
			dummyobject.customfunc = function(obj)
				if not obj.sides then return end

				if not (obj.fuse % 80) then
					for i = 1,4 do
						local side = obj.sides[i]
						side.frame = min(obj.phase, 3)|FF_TRANS40|FF_PAPERSPRITE
					end
					obj.phase = $+1
					S_StartSound(obj, sfx_iceb)
				end

				if obj.fuse == 1 then
					local body = P_SpawnMobjFromMobj(obj, 0, 0, 0, obj.ogmobjtype)
					body.mariofrozenkilled = true
					body.color = obj.ogcolor
					body.colorized = obj.ogcolorized
					if obj.sourcekiller then
						P_DamageMobj(body, obj.sourcekiller, obj.sourcekiller, 1)
					else
						P_KillMobj(body)
					end


					for i = 1,10 do
						local zsp = (obj.height/10)*i
						local debries = P_SpawnMobjFromMobj(obj, 0, 0, zsp, MT_POPPARTICLEMAR)
						debries.fireballp = true
						debries.state = S_INVISIBLE
						debries.flags = $ &~ MF_NOGRAVITY
						debries.sprite = SPR_PFUF
						debries.frame = H|FF_TRANS40
						debries.angle = ANGLE_90*i+P_RandomRange(-8,8)*ANG1
						debries.momz = P_RandomRange(4,7) << FRACBITS
						debries.fuse = 38

						if i % 2 then
							local dust = P_SpawnMobjFromMobj(debries, 20*cos(debries.angle), 20*sin(debries.angle), 20 << FRACBITS, MT_SPINDUST)
							dust.scale = $+obj.scale>>1
						end
						P_Thrust(debries, debries.angle, 2 << FRACBITS)
					end
				end
			end

			if actor.height > 64*FRACUNIT then
				heightdif = (actor.height-64*FRACUNIT)/64
			elseif actor.type == MT_MGREENKOOPA or actor.type == MT_BPARAKOOPA or actor.type == MT_PARAKOOPA then
				heightdif = FRACUNIT/2
			end

			for i = 1,4 do
				local blockSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
				blockSpawn.target = dummyobject
				blockSpawn.scale = actor.scale
				blockSpawn.spriteyscale = FRACUNIT + heightdif
				blockSpawn.id = i
				blockSpawn.state = S_BLOCKVIS
				blockSpawn.sprite = SPR_4MIC
				blockSpawn.frame = A|FF_TRANS40|FF_PAPERSPRITE
				blockSpawn.sprmodel = 1
				table.insert(dummyobject.sides, blockSpawn)
			end
			P_RemoveMobj(actor)
			return true
		elseif mo.type == MT_PKZGB then
			A_CoinDrop(actor, 4, 0)
			actor.translation = "MarioSonGOLD"
		end
end)