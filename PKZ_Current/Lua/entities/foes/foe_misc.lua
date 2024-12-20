local foes = tbsrequire 'entities/foes_common'

-- C Translation for mines in PKZ2
-- Written by Ace
addHook("TouchSpecial", function(special, toucher)
	for i = 1, 12 do
		local explode = P_SpawnMobjFromMobj(special,
		cos(ANGLE_45*i)<<5,
		sin(ANGLE_45*i)<<5,
		sin(ANGLE_45*i)<<5,
		MT_UWEXPLODE)
	end
	if not toucher.player then return end
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

addHook("MobjCollide", foes.ignoreSelf, MT_BIGMOLE)
addHook("MobjCollide", foes.ignoreSelf, MT_SHYGUY)


local FIXED_VOL_ICE = 32 << FRACBITS
local FIXED_SCL_ICE = FRACBITS/32

local function P_GenericEnemyKill(mo)
	local dummy = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_POPPARTICLEMAR)
	dummy.state = S_MARIOSTARS

	A_Scream(dummy)

	-- Koopa exception
	if mo.ogmobjtype == MT_MGREENKOOPA
	or mo.ogmobjtype == MT_PARAKOOPA
	or mo.ogmobjtype == MT_BPARAKOOPA then
		dummy.sprite = SPR_SHLL
	else
		dummy.sprite = mo.sprite
	end

	dummy.color = mo.color
	dummy.flags = $|MF_NOCLIPHEIGHT &~ (MF_NOGRAVITY)

	dummy.momx = 3*FRACUNIT
	dummy.momy = 3*FRACUNIT
	dummy.momz = 8*FRACUNIT

	dummy.fuse = 60

	dummy.angle = mo.angle
	dummy.fireballp = true
	dummy.translation = mo.translation

	dummy.fading = 20

	A_CoinDrop(dummy, 0, 0)
end

local IceDeathLUT = {
	[MT_MGREENKOOPA] = P_GenericEnemyKill,
	[MT_BPARAKOOPA] = P_GenericEnemyKill,
	[MT_PARAKOOPA] = P_GenericEnemyKill,
}

local IceDebries_LUT = {
	S_MMICEDEBRIES1,
	S_MMICEDEBRIES2,
	S_MMICEDEBRIES3,
	S_MMICEDEBRIES4,
	S_MMICEDEBRIES5,
}

local function statue_thinker(obj)
	if not obj.sides then return end

	if not (obj.fuse % 80) then
		for i = 1,4 do
			local side = obj.sides[i]
			side.frame = min(obj.phase, 3)|FF_TRANS40|FF_PAPERSPRITE
		end
		obj.phase = $+1
		S_StartSound(obj, sfx_iceb)

		obj.shake = 8
	end

	if obj.shake then
		if obj.shake > 5 then
			obj.momx = FRACUNIT/6
			obj.momy = FRACUNIT/6
		else
			obj.momx = -FRACUNIT/6
			obj.momy = -FRACUNIT/6
		end

		obj.shake = $ - 1
	elseif obj.shake ~= nil then
		obj.momx = 0
		obj.momy = 0
		obj.shake = nil
	end

	if obj.fuse == 1 then
		if obj.ogmobjtype then
			if IceDeathLUT[obj.ogmobjtype] then
				IceDeathLUT[obj.ogmobjtype](obj)
			else
				local body = P_SpawnMobjFromMobj(obj, 0, 0, 0, obj.ogmobjtype)
				body.mariofrozenkilled = true
				body.color = obj.ogcolor
				body.colorized = obj.ogcolorized
				body.translation = obj.translation

				if obj.sourcekiller then
					P_DamageMobj(body, obj.sourcekiller, obj.sourcekiller, 1)
				else
					P_KillMobj(body)
				end
			end
		end

		local blast = P_SpawnMobjFromMobj(obj, 0,0,-16*obj.scale, MT_POPPARTICLEMAR)
		blast.state = S_MARIOPUFFPARTFASTER
		blast.frame = $|FF_TRANS60

		blast.blendmode = AST_ADD

		blast.color = SKINCOLOR_SKY
		blast.colorized = true

		blast.spriteyscale = FixedDiv(obj.height, FIXED_VOL_ICE)
		blast.spritexscale = blast.spriteyscale

		S_StartSound(blast, sfx_maice2)

		for i = 1,6 do
			local zsp = (obj.height/6)*i
			local debries = P_SpawnMobjFromMobj(obj, 0, 0, zsp, MT_POPPARTICLEMAR)

			debries.state = IceDebries_LUT[P_RandomRange(1, #IceDebries_LUT)]
			debries.scale = debries.scale/3 + P_RandomRange(-8,8) * FIXED_SCL_ICE
			debries.flags = $ &~ MF_NOGRAVITY
			debries.angle = ANGLE_90*i+P_RandomRange(-8,8)*ANG1
			debries.momz = (P_RandomRange(1,7) << FRACBITS)/2
			debries.fuse = 58
			debries.fading = 20

			P_Thrust(debries, debries.angle, 2 << FRACBITS)
		end
	end
end

-- Special Enemy Death Animations
-- Written by Ace

local Goomba_Special = {
	[MT_FIREBALL] = true,
	[MT_PKZFB] = true,
}

local Special_Cases = {
	[MT_FIREBALL] = true,
	[MT_PKZFB] = true,
	[MT_SHELL] = true,
}

local function MM_DeathScenes(mo, inf, source)
	if not (mo and mo.valid and inf and inf.valid) then return end

	if inf.type == MT_PKZIB then
		local dummy = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_BLOCKVIS)

		-- Frame
		dummy.state = S_MARIOSTARS
		dummy.sprite = mo.sprite
		dummy.frame = mo.frame &~ FF_ANIMATE

		-- Color
		dummy.color = SKINCOLOR_ICY
		dummy.translation = "MarioSonICE"
		dummy.colorized = true

		-- Attributes
		dummy.flags = $|MF_SOLID|MF_PUSHABLE & ~(MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_NOCLIPTHING)
		dummy.fuse = 320
		dummy.phase = 0
		dummy.angle = mo.angle
		dummy.scale = mo.scale
		dummy.radius = FRACUNIT<<5
		dummy.height = max(mo.info.height + FIXED_VOL_ICE - (mo.info.height % FIXED_VOL_ICE), FIXED_VOL_ICE)

		-- Prev.Save
		dummy.ogmobjtype = mo.type
		dummy.ogcolor = mo.color
		dummy.ogcolorized = mo.colorized
		dummy.sourcekiller = source
		dummy.sprmodel = 99
		dummy.sides = {}

		-- Thinker
		dummy.customfunc = statue_thinker

		--
		-- 	Planes
		--

		local heightdif = 0

		if mo.type == MT_MGREENKOOPA
		or mo.type == MT_BPARAKOOPA
		or mo.type == MT_PARAKOOPA then
			heightdif = FRACUNIT/2
		elseif mo.info.height > 64*FRACUNIT then
			heightdif = (mo.info.height-64*FRACUNIT)/64
		end

		for i = 1,4 do
			dummy.sides[i] = P_SpawnMobjFromMobj(mo, 0,0,0, MT_BLOCKVIS)
			local plane = dummy.sides[i]

			plane.id = i
			plane.sprmodel = 8
			plane.target = dummy

			plane.state = S_BLOCKVIS
			plane.sprite = SPR_4MIC
			plane.frame = A|FF_TRANS40|FF_PAPERSPRITE

			plane.scale = mo.scale
			plane.spriteyscale = FRACUNIT + heightdif
		end

		P_RemoveMobj(mo)
		return true
	elseif inf.type == MT_PKZGB then
		A_Scream(mo)

		local dummy = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_POPPARTICLEMAR)
		dummy.state = S_MARIOSTARS
		dummy.sprite = mo.sprite
		dummy.frame = mo.frame
		dummy.color = mo.color
		dummy.flags = $ &~ (MF_NOGRAVITY|MF_NOCLIPHEIGHT)
		dummy.fuse = 60
		dummy.angle = mo.angle
		dummy.fading = 20

		dummy.translation = "MarioSonGOLD"
		A_CoinDrop(mo, 4 + (mo.height)/(64*FRACUNIT), 0)

		P_RemoveMobj(mo)
	elseif Special_Cases[inf.type] then
		if (mo.type == MT_GOOMBA or mo.type == MT_BOO) and Goomba_Special[inf.type] then
			return
		end

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
	
		dummy.momx = 3*FRACUNIT
		dummy.momy = 3*FRACUNIT
		dummy.momz = 8*FRACUNIT
	
		dummy.fuse = 60
	
		dummy.angle = mo.angle
		dummy.fireballp = true
	
		dummy.fading = 20
	
		A_CoinDrop(mo, 0, 0)
		P_RemoveMobj(mo)
	end
end

local enemy_database = {}

local function P_AddEnemy(mobjtype)
	if not enemy_database[mobjtype] then
		addHook("MobjDeath", MM_DeathScenes, mobjtype)
		enemy_database[mobjtype] = 1
	end
end

local function P_AddEnemyMulti(...)
	local array = {...}; if not array then return end

	for i = 1, #array do
		local mobjtype = array[i]

		if not enemy_database[mobjtype] then
			addHook("MobjDeath", MM_DeathScenes, mobjtype)
			enemy_database[mobjtype] = 1
		end
	end
end

local function P_ReserveEnemyMulti(...)
	local array = {...}; if not array then return end

	for i = 1, #array do
		local mobjtype = array[i]

		if not enemy_database[mobjtype] then
			enemy_database[mobjtype] = 1
		end
	end
end

-- This checks every mobjinfo slot, parameter being start of from where it should search in the Mobjinfo list.
local function P_CheckNewEnemy(start)
	for i = start, #mobjinfo - 1 do
		local info = mobjinfo[i]

		if info
		and (info.flags & MF_ENEMY)
		and info.spawnhealth <= 2 then
			P_AddEnemy(i)
		end
	end
end

P_AddEnemyMulti(MT_BOO, MT_SHYGUY, MT_REDPIRANHAPLANT, MT_REDJPIRANHAPLANT, MT_FIREFPIRANHAPLANT, MT_REDHPIRANHAPLANT)

addHook("AddonLoaded", function()
	P_CheckNewEnemy(0)
end)
