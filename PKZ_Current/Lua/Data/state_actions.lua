--[[
		Pipe Kingdom Zone's State Thinkers - state_actions.lua

Description:
Contains action functions for general Lua use or SOC use.

Skydusk: not gonna lie, not sure what I was going with this.
Good for SOC users.

Contributors: Skydusk, Zipper(Bowser), Ashi
@Team Blue Spring 2024
]]

--
-- ACTIONS
--


local LIFEHEIGHT = 24 << FRACBITS
local LIFEUPFRAME = {
	[0] = 10,
	[1] = 12,
	[2] = 13,
	[3] = 14,
}

---@param mo 	mobj_t
---@param var1 	number
function A_Spawn1upScore(mo, var1)
	local index = max(min(var1 or 0, 0), 3)

	local score = P_SpawnMobjFromMobj(mo, 0, 0, LIFEHEIGHT, MT_POPPARTICLEMAR)

	score.fuse = TICRATE + 8
	score.fading = 8

	score.scale = 0
	score.growing = (mo.scale/3) << 1
	score.rising = FRACUNIT*2

	score.flags = mobjinfo[MT_SCORE].flags
	score.state = S_INVISIBLE
	score.sprite = SPR_SCOR
	score.frame = LIFEUPFRAME[index]
end

local SCOREFRAME = {[0] = { [10] = 20, [50] = 15, [100] = 0, [250] = 18, [500] = 2, [1000] = 3, [1500] = 19, [10000] = 4},
					[2] = { [100] = 0, [200] = 1, [400] = 2, [800] = 3, [1000] = 4, [2000] = 5, [4000] = 6, [8000] = 7 }}

local SCORERADIUS = 16 * FRACUNIT
local SCOREHEIGHT = 10 * FRACUNIT

--Due to ring slinger modes hugely being based around getting as much score as possible...
--* Yeah... it would be probably for the best to disable MP score in this more convenient thinker
--* var1: Score value
--* var2:
--*	0: Normal Score Object
--*	1: No Score Object
--*	2: Pole Score Object
---@param mo 	mobj_t
---@param var1 	number
---@param var2 	number
---@return boolean?
function A_AddPlayerScoreMM(mo, var1, var2)
    if not (mo and mo.valid) or G_RingSlingerGametype() then return end
	if (mo.noscore) then return end

	local grant = abs(var1)
	local life_levels = max(min(grant/10000, 3), 0)
	local type = max(min(var2, 2), 0)

    if SCOREFRAME[type] and SCOREFRAME[type][grant] then		
		local score = P_SpawnMobj(
			mo.x + (type == 2 and SCORERADIUS or 0),
			mo.y,
			mo.z + SCOREHEIGHT,
			MT_POPPARTICLEMAR
		)

		score.flags = mobjinfo[MT_SCORE].flags
		score.state = S_INVISIBLE
		score.scale = mo.scale
		score.fading = 8

		if type == 2 then
			score.sprite = SPR_SCO8
			score.fuse = TICRATE*8
		else
			score.sprite = SPR_SCOR
			score.fuse = 2*TICRATE/3
			score.rising = FRACUNIT*2
		end
		score.frame = SCOREFRAME[type][grant]
	elseif grant > 10000 then
		A_Spawn1upScore(mo, life_levels)
    end

    A_FindTarget(mo, MT_PLAYER, 0)
    
	if mo.target.valid and mo.target.player then
		if grant > 10000 then
			P_GivePlayerLives(mo.target.player, life_levels)
		else	
			P_AddPlayerScore(mo.target.player, grant)
		end

		return true
	end

	return false
end

--Spawns pressure stars
---@param mo 		mobj_t
---@param press 	mobj_t object used for orientation like player
function A_SpawnMarioStars(mo, press)
	if (mo.z+mo.height-4*FRACUNIT) < press.z then
		local starcolor = {SKINCOLOR_RED, SKINCOLOR_YELLOW}
		for i = 1,4 do
			local stars = P_SpawnMobjFromMobj(mo, 0,0,0, MT_POPPARTICLEMAR)
			stars.fireballp = true
			stars.state = S_MARIOSTARS
			stars.scale = mo.scale/2
			stars.color = P_RandomRange(1,0) and SKINCOLOR_RED or SKINCOLOR_YELLOW
			stars.angle = press.angle - ANGLE_45 + ANGLE_90*i
			stars.momz = 5*FRACUNIT
			stars.flags = $ &~ MF_NOGRAVITY
			stars.fuse = 38
			stars.fading = 8
			P_InstaThrust(stars, stars.angle, 3*FRACUNIT)
		end
	end
end

--Spawns pick up particle, used exclusively to powerups's death states
---@param mo 	mobj_t
---@param var1 	number
---@param var2 	number
function A_SpawnPickUpParticle(mo, var1, var2)
	for i = 1,2 do
		local pickup = P_SpawnMobjFromMobj(mo, 0,0,0+mo.height/2, MT_POPPARTICLEMAR)
		pickup.state = (i == 1 and S_MMPICKUPLAYER1 or S_MMPICKUPLAYER2)
		pickup.scale = (i == 1 and mo.scale or mo.scale/4)/2
		pickup.source = mo
		pickup.color = (i == 1 and var1 or var2) or mo.color or SKINCOLOR_GOLD
	end
end

--Spawns pick up particle, used exclusively to powerups's death states
---@param mo 	mobj_t
---@param var1 	number
---@param var2 	number
function A_SpawnBigPickUpParticle(mo, var1, var2)
	for i = 1,2 do
		local pickup = P_SpawnMobjFromMobj(mo, 0,0,0+mo.height/2, MT_POPPARTICLEMAR)
		pickup.state = (i == 1 and S_MMPICKUPLAYER1 or S_MMPICKUPLAYER2)
		pickup.scale = (i == 1 and mo.scale or mo.scale/4)
		pickup.source = mo
		pickup.color = (i == 1 and var1 or var2) or mo.color or SKINCOLOR_GOLD
	end
end

--C Translated version of A_ChaseCape with reduced instructions for whatever optimalization I can get with my current skill
---@param mo 	mobj_t
---@param var1 	number
---@param var2 	number
function A_CustomRChaser(mo, var1, var2)
	local target = mo.target
	local angle = target.angle

	if (target.health <= 0) then
		local repl = P_SpawnMobjFromMobj(mo, 0,0,0, MT_MARIOOCTOPUS)
		repl.scale = mo.scale
		repl.angle = mo.angle
		P_RemoveMobj(mo)
	end

	mo.foffsetx = P_ReturnThrustX(target, angle, (var2 >> 16) * mo.scale)
	mo.foffsety = P_ReturnThrustY(target, angle, (var2 >> 16) * mo.scale)
	mo.boffsetx = P_ReturnThrustX(target, angle-ANGLE_90, (var2 & 65535) * mo.scale)
	mo.boffsety = P_ReturnThrustY(target, angle-ANGLE_90, (var2 & 65535) * mo.scale)
	mo.tx = target.x + mo.foffsetx + mo.boffsetx
	mo.ty = target.y + mo.foffsety + mo.boffsety
	mo.tz = target.z + (var1 >> 16) * mo.scale
	mo.angle = angle

	P_SetOrigin(mo, mo.tx, mo.ty, mo.tz+(var1 & 65535))
end

-- Drops coin affected by gravity
--* Used in enemy drops
---@param mo 	mobj_t
---@param var1 	number Default amount
---@param var2 	number Extra coins from power-ups
function A_CoinDrop(mo, var1, var2)
	local amount = 1+var1+var2
	for i = 1,amount do
		local coin = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_FLINGCOIN)
		coin.angle = mo.angle+ANG1*15*i
		coin.momz = 10*FRACUNIT
		coin.momx = 3*cos(coin.angle)
		coin.momy = 3*sin(coin.angle)
		coin.fuse = 180
	end
end

freeslot("MT_DROPCOIN")

-- Coin that shoots up in the sky and collect itself.
--* Used in blocks
---@param mo 		mobj_t
---@param var1 		number 	Default amount
---@param var2 		number 	Extra coins from power-ups
---@param target 	mobj_t 	Target
---@param jaw_coin 	boolean Switches state of the coin to vertical rotation
function A_CoinProjectile(mo, var1, var2, target, jaw_coin)
	if not ((mo.target and mo.target.valid and mo.target.player)
	or (target and target.valid and target ~= nil and target.player)) then return end

	local amount = 1+var1+var2

	for i = 1,amount do
		local coin = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_DROPCOIN)
		if jaw_coin then
			coin.state = S_COIN_JAWROT
		end
		coin.angle = mo.angle
		coin.momz = 5*FRACUNIT
		coin.fuse = 180
		coin.target = mo.target or target
	end
end

---@param mo 		mobj_t
---@param var1 		number
---@param var2 		number
function A_CoinDeathGain(mo, var1, var2)
	A_RingBox(mo, var1, var2)
	if mo.target then
		S_StartSound(mo, mo.info.deathsound)
	end
end

--	Function to activate Mario changing animation
--* Used both for powering down/up
---@param pmo 		mobj_t player mo
---@param var1 		number from power up
---@param var2 		number to 	power up
function A_MarioPain(pmo, var1, var2, cycle)
	pmo.reservedcamerax = camera.x
	pmo.reservedcameray = camera.y
	pmo.reservedcameraz = camera.z
	pmo.reservedcameraaiming = camera.aiming
	pmo.reservedmomx = pmo.momx
	pmo.reservedmomy = pmo.momy
	pmo.reservedmomz = pmo.momz
	pmo.rescamerascale = pmo.player.camerascale
	pmo.shield1 = var1
	pmo.shield2 = var2
	pmo.marinvtimer = (cycle*3)+5
	pmo.player.powers[pw_nocontrol] = pmo.marinvtimer+1
	pmo.player.powers[pw_flashing] = pmo.marinvtimer+40
	if pmo.marinvtimer > 0 then
		return true
	end
end

--	Resets the A_MarioPain animation 
---@param pmo 		mobj_t player mo
function A_MarioPainReset(pmo)
	pmo.reservedcamerax = nil
	pmo.reservedcameray = nil
	pmo.reservedcameraz = nil
	pmo.reservedcameraaiming = nil
	pmo.reservedmomx = nil
	pmo.reservedmomy = nil
	pmo.reservedmomz = nil
	pmo.rescamerascale = nil
	pmo.shield1 = nil
	pmo.shield2 = nil
	pmo.marinvtimer = nil
end

-- Edited & C->Lua Translated A_SkullAttack
--
--* var1:
--*		0 - Fly at the player
--*		1 - Fly away from the player
---@param mo 		mobj_t
---@param var1 		number attack mode 
function A_BloopAttack(mo, var1, var2)
	local dest, an, dist, speed

	if not (mo.target.valid or mo.valid) then
		return
	end

	speed = FixedMul(mo.info.speed, mo.scale)

	dest = mo.target
	mo.flags2 = $ | MF2_SKULLFLY
	if mo.info.activesound ~= nil or mo.info.activesound ~= sfx_none then
		S_StartSound(mo, mo.info.activesound)
	end
	A_FaceTarget(mo)

	dist = P_AproxDistance(dest.x - mo.x, dest.y - mo.y)

	if var1 == 1 then
		mo.angle = $ + ANGLE_180
	end
	an = mo.angle -->> ANGLETOFINESHIFT

	mo.momx = FixedMul(speed, cos(an))
	mo.momy = FixedMul(speed, sin(an))
	dist = $ / speed

	if (dist < 1) then
		dist = 1
	end

	mo.momz = (dest.z + (dest.height>>1) - mo.z) / dist
end

---@param mo 		mobj_t
function A_MarioMoleChase(a)
	if not (a.target and (a.target.flags & MF_SHOOTABLE)) then
		a.state = a.info.spawnstate
	end

	-- Base attributes
	local tg = a.target
	local tangr = (max(tg.angle - ANGLE_180, a.angle) - min(a.angle, tg.angle) - ANGLE_180) / ANG1
	local speed = abs(FixedInt(FixedHypot(a.momx, a.momy)))

	-- Movement
	if abs(tangr) > 35 then
		if speed > 3 then
			speed = $ - 1
		else
			a.angle = $ - FixedAngle(tangr * FRACUNIT / 8)
		end
	else
		a.angle = $ - FixedAngle(tangr * FRACUNIT / 8)
		speed = min(speed + 1, 35)
	end

	P_InstaThrust(a, a.angle, speed * FRACUNIT)
end

-- Zipper Section
--

--all of these are fucking stupid and pointless
--"haha I'll just decouple them a bit"


--what the FUCK
---@param mo 		mobj_t
---@param var1 		INT32 
---@param var2 		INT32 
function A_FlameCharge(mo, var1, var2)
	local frontoff = (var1 & 65535) << FRACBITS
	local heightoff = (var2 & 65535) << FRACBITS
	local randalpha = FixedAngle(P_RandomRange(-90,90) << FRACBITS)
	local randbeta = FixedAngle(P_RandomRange(-90,90) << FRACBITS)
	local rad = FixedMul(mo.scale, 20 << FRACBITS)

	local bull = P_SpawnMobj(mo.x + FixedMul(cos(mo.angle), frontoff) + FixedMul(FixedMul(cos(mo.angle + randalpha),cos(mo.angle + randbeta)), rad),
							 mo.y + FixedMul(sin(mo.angle), frontoff) + FixedMul(FixedMul(cos(mo.angle + randalpha),sin(mo.angle + randbeta)), rad),
							 mo.z + 2*mo.height/3 + heightoff + FixedMul(sin(randbeta),rad),
							 MT_JETTBULLET)
	bull.flags = MF_NOGRAVITY
	bull.destscale = FRACUNIT/3
	bull.fuse = 10

	local hor = R_PointToAngle2(bull.x, bull.y, mo.x, mo.y)
	local ver = R_PointToAngle2(0, 0, bull.z, mo.z + FixedMul(mo.scale, 2*mo.height/3))
	bull.momx = 3*cos(hor)
	bull.momy = 3*sin(hor)
	bull.momz = -6*sin(ver)
	A_FaceTarget(mo,nil,nil)
end

--bruh
---@param mo 		mobj_t
---@param var1 		INT32 
---@param var2 		INT32
function A_ResetBowser(mo, var1, var2)
	mo.flametic = 0
	mo.dashcount = 0
	mo.extravalue1 = 0
	mo.extravalue2 = 0
end

---@param mo 		mobj_t
---@param var1 		INT32 
---@param var2 		INT32
function A_UltraFireShot(mo, var1, var2)
	local frontoff = (var1 & 65535) << FRACBITS
	local obj = var1 >> FRACBITS
	local heightoff = (var2 & 65535) << FRACBITS

	A_FaceTarget(mo,nil,nil)
	local flame = P_SpawnMissile(mo, mo.target, obj)
	flame.scale = FRACUNIT
	flame.destscale = 5*FRACUNIT/2
	S_StartSound(flame, flame.info.seesound)
	flame.momz = 0
	flame.fuse = 25

	for i = -1,1,2 do
		local goast = P_SpawnGhostMobj(flame)
		local randangle = mo.angle + i * P_RandomRange(0,20) * ANG1
		goast.momx = 8*cos(randangle)
		goast.momy = 8*sin(randangle)
		goast.momz = P_RandomRange(-4,4) << FRACBITS

		goast.destscale = 3*FRACUNIT/2
		goast.fuse = TICRATE/2
	end

end

---@param mo 		mobj_t
---@param var1 		state_t state to go to
---@param var2 		INT32 	is stompy?
function A_CheckGround(mo, var1, var2)
	if P_IsObjectOnGround(mo) then
		mo.state = var1
		if var2 then
			S_StartSound(mo, sfx_s3k5f)
			P_StartQuake(10*FRACUNIT, TICRATE/2)
			A_NapalmScatter(mo, MT_SPINDUST+16<<FRACBITS, 128+16*FRACUNIT)
		end
	end
end

---@param mo 		mobj_t
---@param var1 		INT32 shot count
---@param var2 		state_t custom state
function A_Boss3Shot(mo, var1, var2, var3)
	local numtospawn = var1
	local ang = 0
	local interval = (360 / numtospawn) * ANG1
	local shock, sfirst, sprev

	for i = 1, numtospawn do
		shock = P_SpawnMobj(mo.x, mo.y, mo.z, MT_SHOCKWAVE)
		shock.target = mo
		shock.scale = $+(var3 or 0)
		shock.state = var2 and var2 or mobjinfo[MT_SHOCKWAVE].spawnstate
		shock.fuse = shock.info.painchance / 3

		if not (i%2) then
			shock.state = states[shock.state].nextstate and states[shock.state].nextstate or $
		end

		if not (sprev) then
			sfirst = shock
		else
			if (i == numtospawn) then
				shock.hnext = sfirst
			end
			sprev.hnext = shock
		end

		P_Thrust(shock, ang, 3 * shock.info.speed / 2)
		shock.angle = ang + ANGLE_90
		ang = $ + interval
		sprev = shock

	end
	S_StartSound(mo, shock.info.seesound)
end