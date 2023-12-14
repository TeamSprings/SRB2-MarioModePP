/* 
		Pipe Kingdom Zone's State Thinkers - state_actions.lua

Description:
Contains action functions for general Lua use or SOC use.

Skydusk: not gonna lie, not sure what I was going with this.
Good for SOC users.

Contributors: Skydusk, Zipper(Bowser), Ashi
@Team Blue Spring 2024
*/

//
// ACTIONS
//

// Force Stop for Particles
// Note: lazy :V
// Written by Ace
function A_ForceStopParticle(a)
	a.flags = $|MF_NOGRAVITY
	a.momx = 0
	a.momy = 0
	a.momz = 0
end

// Score Action Thinkers
// Written by Ace
-- var1: Score value
function A_AddScore(actor, var1)
	if actor.noscore == true then return end
	A_FindTarget(actor, MT_PLAYER, 0)
	
	if not actor.target.valid then return end
	P_AddPlayerScore(actor.target.player, var1)
end

//Due to ringslinger modes hugely being based around getting as much score as possible...
//Yeah... it would be probably for the best to disable MP score in this more conveneint thinker 
-- var1: Score value
-- var2 
--	0: Normal Score Object 
--	1: No Score Object
--	2: Pole Score Object

local scoreFrame = {[0] = { [10] = U, [50] = P, [100] = A, [250] = S, [500] = C, [1000] = D, [1500] = T, [10000] = E },
					[2] = { [100] = A, [200] = B, [400] = C, [800] = D, [1000] = E, [2000] = F, [4000] = G, [8000] = H }}

function A_AddNoMPScore(a, var1, var2)
    if not (a and a.valid) or a.noscore == true or G_RingSlingerGametype()
    or (MarioScoreGametype and MarioScoreGametype()) then return end 
    
    if var2 ~= 1
        local scoreItem = P_SpawnMobj((var2 and (a.x + 16*FRACUNIT) or a.x), a.y, a.z+10*FRACUNIT, MT_SCORE)
        scoreItem.source = a
        scoreItem.sprite = (var2 == 2 and SPR_SCO8 or SPR_SCOR)
        scoreItem.momz = (var2 ~= 2 and FRACUNIT*2 or 0)
        scoreItem.fuse = (var2 ~= 2 and TICRATE/2 or TICRATE*8)
        scoreItem.frame = (scoreFrame[var2][var1] or R)
    end

    A_FindTarget(a, MT_PLAYER, 0)
    if a.target.valid then P_AddPlayerScore(a.target.player, var1) end

end

function A_SpawnMarioStars(actor, mo)
	if (actor.z+actor.height-4*FRACUNIT) < mo.z then
		local starcolor = {SKINCOLOR_RED, SKINCOLOR_YELLOW}
		for i = 1,4 do
			local marstars = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
			marstars.fireballp = true
			marstars.state = S_MARIOSTARS
			marstars.scale = actor.scale/2
			marstars.color = starcolor[P_RandomRange(1,2)]
			marstars.angle = mo.angle - ANGLE_45 + ANGLE_90*i
			marstars.momz = 5*FRACUNIT
			marstars.flags = $ &~ MF_NOGRAVITY
			marstars.fuse = 38
			P_InstaThrust(marstars, marstars.angle, 3*FRACUNIT)
		end
	end
end

function A_FuseFade(actor, frame, slash, multi)
	local transp = FF_TRANS90-(actor.fuse*FRACUNIT/slash*multi)
	actor.frame = frame|transp
end


//Spawns pick up particle, used exclusively to powerups's death states 
function A_SpawnPickUpParticle(a, var1)
	for i = 1,2 do
		local spparticle = P_SpawnMobjFromMobj(a, 0,0,0+a.height/2, MT_POPPARTICLEMAR)
		spparticle.state = S_NEWPICARTICLE
		spparticle.sprite = (i == 1 and SPR_PUP2 or SPR_PUP3)
		spparticle.scale = a.scale/12
		spparticle.source = a
		spparticle.fuse = 10+(i-1)*5
		spparticle.color = var1
		spparticle.blendmode = (i == 1 and AST_TRANSLUCENT or AST_ADD)
		spparticle.spparticle = i
	end
end


//Translated A_SpawnXYZMissile
function A_SpawnMarioMissile(source, dest, mbtype, x, y, z, objtype, fuse)
	local th, an, dist, hypot, speed
	objtype = objtype or "none"

	if (source.eflags & MFE_VERTICALFLIP)
		z = source.z - source.height - FixedMul(32*FRACUNIT, source.scale)
	else
		z = source.z + FixedMul(32*FRACUNIT, source.scale)
	end

	th = P_SpawnMobj(x, y, z, mbtype)

	if (source.eflags & MFE_VERTICALFLIP)
		th.flags2 = $|MF2_OBJECTFLIP
	end

	if objtype == "piranha"
		th.scale = FixedMul(FRACUNIT/3, source.scale)	
		th.flags = MF_MISSILE|MF_PAIN|MF_NOGRAVITY
		th.plzno = true
	else
		th.scale = source.scale
	end

	if fuse then
		th.fuse = fuse
	end

	speed = newspeed and newspeed or FixedMul(th.info.speed, th.scale)

	th.target = source // where it came from
	an = R_PointToAngle2(x, y, dest.x, dest.y)

	th.angle = an
	th.momx = FixedMul(speed, cos(an))
	th.momy = FixedMul(speed, sin(an))

	dist = R_PointToDist2(x, y, dest.x, dest.y)
	hypot = FixedDiv(dest.z - z, dist)
	
	th.momz = FixedMul(speed, sin(FixedAngle(asin(hypot))))
	
	return th
end

//C Translated version of A_ChaseCape with reduced instructions for whatever optimalization I can get with my current skill
function A_CustomCChaser(actor, var1, var2, typetr, shox)
	local target = typetr
	local angle = target.angle
	if shox == 1 then
		if (target.health <= 0)
			P_RemoveMobj(actor)
		end
		actor.scale = target.scale
	elseif shox == 0 then
		if (target.health <= 0) then
			local repl = P_SpawnMobjFromMobj(actor, 0,0,0, MT_MARIOOCTOPUS)
			repl.scale = actor.scale
			repl.angle = actor.angle
			P_RemoveMobj(actor)			
		end	
	end
	actor.foffsetx = P_ReturnThrustX(target, angle, FixedMul((var2 >> 16)*FRACUNIT, actor.scale))
	actor.foffsety = P_ReturnThrustY(target, angle, FixedMul((var2 >> 16)*FRACUNIT, actor.scale))
	actor.boffsetx = P_ReturnThrustX(target, angle-ANGLE_90, FixedMul((var2 & 65535)*FRACUNIT, actor.scale))
	actor.boffsety = P_ReturnThrustY(target, angle-ANGLE_90, FixedMul((var2 & 65535)*FRACUNIT, actor.scale))
	actor.tx = target.x + actor.foffsetx + actor.boffsetx
	actor.ty = target.y + actor.foffsety + actor.boffsety
	actor.tz = target.z + FixedMul((var1 >> 16)*FRACUNIT, actor.scale)
	actor.angle = angle
	P_SetOrigin(actor, actor.tx, actor.ty, actor.tz+(var1 & 65535))
end

function A_CustomTChaser(actor, var1, var2)
	A_CustomCChaser(actor, var1, var2, actor.target, 1)
end

function A_CustomRChaser(actor, var1, var2)
	A_CustomCChaser(actor, var1, var2, actor.tracer, 0)
end

function A_CoinDrop(actor, var1, var2)
	-- var 1: Default amount
	-- var 2: Extra coins from power-ups
	local amount = 1+var1+var2
	for i = 1,amount do
		local coin = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_FLINGCOIN)
		coin.angle = actor.angle+ANG1*15*i
		coin.momz = 10*FRACUNIT
		coin.momx = 3*cos(coin.angle)
		coin.momy = 3*sin(coin.angle)
		coin.fuse = 180
	end
end


freeslot("MT_DROPCOIN")
function A_CoinProjectile(a, var1, var2, target, jaw_coin)

	-- var 1: Default amount
	-- var 2: Extra coins from power-ups
	if not ((a.target and a.target.valid and a.target.player) 
	or (target and target.valid and target ~= nil and target.player)) then return end
	
	local amount = 1+var1+var2
	
	for i = 1,amount do
		local coin = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_DROPCOIN)
		if jaw_coin then
			coin.state = S_COIN_JAWROT
		end
		coin.angle = a.angle
		coin.momz = 5*FRACUNIT
		coin.fuse = 180
		coin.target = a.target or target
	end
end

function A_CoinDeathGain(a, var1, var2)
	A_RingBox(a, var1, var2)
	if a.target then
		S_StartSound(a, a.info.deathsound)
	end
end

//Function for Mario Pain//
// var1:
function A_MarioPain(p, var1, var2, cycle)
	p.reservedcamerax = camera.x
	p.reservedcameray = camera.y
	p.reservedcameraz = camera.z
	p.reservedcameraaiming = camera.aiming
	p.reservedmomx = p.momx
	p.reservedmomy = p.momy
	p.reservedmomz = p.momz
	p.rescamerascale = p.player.camerascale	
	p.shield1 = var1
	p.shield2 = var2
	p.marinvtimer = (cycle*3)+5
	p.player.powers[pw_nocontrol] = p.marinvtimer+1
	p.player.powers[pw_flashing] = p.marinvtimer+40
	if p.marinvtimer > 0 then
		return true
	end
end

function A_MarioPainReset(p)
	p.reservedcamerax = nil
	p.reservedcameray = nil
	p.reservedcameraz = nil
	p.reservedcameraaiming = nil
	p.reservedmomx = nil
	p.reservedmomy = nil
	p.reservedmomz = nil
	p.rescamerascale = nil	
	p.shield1 = nil
	p.shield2 = nil
	p.marinvtimer = nil
end

// C Translation of Function: A_SkullAttack
//
// var1:
//		0 - Fly at the player
//		1 - Fly away from the player
function A_BloopAttack(actor, var1, var2)
	local dest, an, dist, speed

	if not (actor.target.valid or actor.valid)
		return
	end

	speed = FixedMul(actor.info.speed, actor.scale)

	dest = actor.target
	actor.flags2 = $ | MF2_SKULLFLY
	if actor.info.activesound ~= nil or actor.info.activesound ~= sfx_none
		S_StartSound(actor, actor.info.activesound)
	end
	A_FaceTarget(actor)

	dist = P_AproxDistance(dest.x - actor.x, dest.y - actor.y)

	if var1 == 1
		actor.angle = $ + ANGLE_180
	end
	an = actor.angle -->> ANGLETOFINESHIFT

	actor.momx = FixedMul(speed, cos(an))
	actor.momy = FixedMul(speed, sin(an))
	dist = $ / speed

	if (dist < 1)
		dist = 1
	end

	actor.momz = (dest.z + (dest.height>>1) - actor.z) / dist
end

-- Translated P_HomingAttack
function A_HomingETarget(source, target, speed) // Home in on your target
	local zdist, dist
	local ns = 0

	// change slope
	dist = P_AproxDistance(P_AproxDistance(target.x - source.x, target.y - source.y), (target.z - source.z))

	if (dist < 1)
		dist = 1
	end

	ns = FixedMul(speed, source.scale)
	source.momx = FixedMul(FixedDiv(target.x - source.x, dist), ns)
	source.momy = FixedMul(FixedDiv(target.y - source.y, dist), ns)
	source.momz = FixedMul(FixedDiv(target.z - source.z, dist), ns)
end

local SwitchEasing = {
	[0] = function(t, s, e) return ease.linear(t, s, e) end;
	[1] = function(t, s, e) return ease.outsine(t, s, e) end;
	[2] = function(t, s, e) return ease.outexpo(t, s, e) end;
	[3] = function(t, s, e) return ease.outquad(t, s, e) end;
	[4] = function(t, s, e) return ease.outback(t, s, e) end;
}

// Eased Object to Target Thinker
//
// if someone for whatever reason would use this, then I would check out this before lamenting which function to use : https://easings.net/
//
// var1: target
// var2: easefunction enum : {}
// speed: Lua-only variable for custom speed
// Note: speed is constant used from object's speed
function A_EasedObjectTarget(a, var1, var2, speed)
	local zdist, dist
	local ns = 0

	// change slope
	dist = P_AproxDistance(P_AproxDistance(target.x - source.x, target.y - source.y), (target.z - source.z))

	if (dist < 1)
		dist = 1
	end

	ns = FixedMul(speed, source.scale)
	source.momx = FixedMul(FixedDiv(target.x - source.x, dist), ns)
	source.momy = FixedMul(FixedDiv(target.y - source.y, dist), ns)
	source.momz = FixedMul(FixedDiv(target.z - source.z, dist), ns)
end

// Zipper Section
//

//all of these are fucking stupid and pointless
//"haha I'll just decouple them a bit"


//what the FUCK
function A_FlameCharge(actor, var1, var2)
	local frontoff = (var1 & 65535) << FRACBITS
	local heightoff = (var2 & 65535) << FRACBITS
	local randalpha = FixedAngle(P_RandomRange(-90,90) << FRACBITS)
	local randbeta = FixedAngle(P_RandomRange(-90,90) << FRACBITS)
	local rad = FixedMul(actor.scale, 20 << FRACBITS)
	
	local bull = P_SpawnMobj(actor.x + FixedMul(cos(actor.angle), frontoff) + FixedMul(FixedMul(cos(actor.angle + randalpha),cos(actor.angle + randbeta)), rad),
							 actor.y + FixedMul(sin(actor.angle), frontoff) + FixedMul(FixedMul(cos(actor.angle + randalpha),sin(actor.angle + randbeta)), rad),
							 actor.z + 2*actor.height/3 + heightoff + FixedMul(sin(randbeta),rad),
							 MT_JETTBULLET)
	bull.flags = MF_NOGRAVITY
	bull.destscale = FRACUNIT/3
	bull.fuse = 10
	
	local hor = R_PointToAngle2(bull.x, bull.y, actor.x, actor.y)
	local ver = R_PointToAngle2(0, 0, bull.z, actor.z + FixedMul(actor.scale, 2*actor.height/3))
	bull.momx = 3*cos(hor)
	bull.momy = 3*sin(hor)
	bull.momz = -6*sin(ver)
	A_FaceTarget(actor,nil,nil)
end

//bruh
function A_ResetBowser(actor, var1, var2)
	actor.flametic = 0
	actor.dashcount = 0
	actor.extravalue1 = 0
	actor.extravalue2 = 0
end

function A_UltraFireShot(actor, var1, var2)
	local frontoff = (var1 & 65535) << FRACBITS
	local obj = var1 >> FRACBITS
	local heightoff = (var2 & 65535) << FRACBITS
	
	A_FaceTarget(actor,nil,nil)
	local flame = P_SpawnMissile(actor, actor.target, obj)
	flame.scale = FRACUNIT
	flame.destscale = 5*FRACUNIT/2
	S_StartSound(flame, flame.info.seesound)
	flame.momz = 0
	flame.fuse = 25
	
	for i = -1,1,2 do
		local goast = P_SpawnGhostMobj(flame)
		local randangle = actor.angle + i * P_RandomRange(0,20) * ANG1
		goast.momx = 8*cos(randangle)
		goast.momy = 8*sin(randangle)
		goast.momz = P_RandomRange(-4,4) << FRACBITS
		
		goast.destscale = 3*FRACUNIT/2
		goast.fuse = TICRATE/2
	end
	
end

//var1 : state to go to
//var2 : is stompy?
function A_CheckGround(actor, var1, var2)
	if P_IsObjectOnGround(actor) then
		actor.state = var1
		if var2 then
			S_StartSound(actor, sfx_s3k5f)
			P_StartQuake(10*FRACUNIT, TICRATE/2)
			A_NapalmScatter(actor, MT_SPINDUST+16<<FRACBITS, 128+16*FRACUNIT)
		end
	end
end

//var1 : shot count
//var2 : custom state
function A_Boss3Shot(actor, var1, var2, var3)
	local numtospawn = var1
	local ang = 0
	local interval = (360 / numtospawn) * ANG1
	local shock, sfirst, sprev
	
	for i = 1, numtospawn do
		shock = P_SpawnMobj(actor.x, actor.y, actor.z, MT_SHOCKWAVE)
		shock.target = actor
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
	S_StartSound(actor, shock.info.seesound)
end