--[[
		Pipe Kingdom Zone's Power-Up Base - game_powerups.lua

Description:
Work-around for power-ups in Mario Mode

Contributors: Skydusk
@Team Blue Spring 2024
--]]

local DSF_POWERUPS = 2

local JUMP_CONSTANT_TWODEE = 7*FRACUNIT/9

local T_PowerUpStats = {
	[0] = function(player) -- normal state
		local skin = skins[player.mo.skin]
		player.jumpfactor =  FixedMul(FixedMul(skin.jumpfactor, (7 << FRACBITS) >> 2), twodlevel and JUMP_CONSTANT_TWODEE or FRACUNIT)
		player.camerascale = FixedMul(skin.camerascale, (4 << FRACBITS)/3)
		--player.runspeed = skin.runspeed << 1
		player.normalspeed = skin.normalspeed
		player.mo.scale = (3 << FRACBITS) >> 2
		player.mo.destscale = player.mo.scale
	end;
	[2503] = function(player) -- mini state
		local skin = skins[player.mo.skin]
		player.jumpfactor = FixedMul(FixedMul(skin.jumpfactor, 6 << FRACBITS), twodlevel and JUMP_CONSTANT_TWODEE or FRACUNIT)
		player.camerascale = FixedMul(skin.camerascale, 4 << FRACBITS)
		--player.runspeed = skin.runspeed
		player.normalspeed = skin.normalspeed << 1
		player.mo.scale = FRACUNIT >> 2
		player.mo.destscale = player.mo.scale
	end;
	[2500] = function(player) -- large state
		local skin = skins[player.mo.skin]
		player.jumpfactor = FixedMul(FixedMul(skin.jumpfactor, (3 << FRACBITS) >> 1), twodlevel and JUMP_CONSTANT_TWODEE or FRACUNIT)
		player.camerascale = skin.camerascale
		--player.runspeed = skin.runspeed << 1
		player.normalspeed = skin.normalspeed
		player.mo.scale = FRACUNIT
		player.mo.destscale = player.mo.scale
	end;
}

local T_PowerUpColors = {
	[2504] = {
		["sonic"] = SKINCOLOR_RED,
		["tails"] = SKINCOLOR_SUNSET,
		["knuckles"] = SKINCOLOR_ORANGE,
		["metalsonic"] = SKINCOLOR_RUBY,
		["amy"] = SKINCOLOR_SUNSET,
		["fang"] = SKINCOLOR_ORANGE,
		["toad"] = SKINCOLOR_RED,
	},
	[2505] = {
		["sonic"] = SKINCOLOR_SKY,
		["tails"] = SKINCOLOR_AETHER,
		["knuckles"] = SKINCOLOR_BLUE,
		["metalsonic"] = SKINCOLOR_SAPPHIRE,
		["amy"] = SKINCOLOR_CYAN,
		["fang"] = SKINCOLOR_AETHER,
		["toad"] = SKINCOLOR_BLUE,
	},
}

local T_InvColors = {
	--SKINCOLOR_CYAN;
	--SKINCOLOR_COBALT;
	--SKINCOLOR_PURPLE;
	--SKINCOLOR_RED;
	--SKINCOLOR_ORANGE;
	--SKINCOLOR_GREEN;
	--SKINCOLOR_MINT;
	--SKINCOLOR_AETHER;
	SKINCOLOR_MARIOINVULN1,
	SKINCOLOR_MARIOINVULN2,
	SKINCOLOR_MARIOINVULN3,
	SKINCOLOR_MARIOINVULN4,
	SKINCOLOR_MARIOINVULN5,
	SKINCOLOR_MARIOINVULN6,
	SKINCOLOR_MARIOINVULN7,
	SKINCOLOR_MARIOINVULN8,
}

local INDEXINVMUL = #T_InvColors*8

local function P_GetPowerUpColors(flowerpu, skin)
	if skin == "sonic" then
		if flowerpu == SH_NEWFIREFLOWER then
			return xMM_registry.getFlameColor(4)
		end

		if flowerpu == SH_NICEFLOWER then
			return xMM_registry.getIcyColor(5)
		end
	else
		return (T_PowerUpColors[flowerpu][skin] or (flowerpu == SH_NEWFIREFLOWER and SKINCOLOR_ORANGE or SKINCOLOR_CYAN))
	end
end

local function P_GetPowerUpTranslationColors(flowerpu, skin)
	if skin == "sonic" then
		if flowerpu == SH_NEWFIREFLOWER then
			return "MarioSonFFLW"
		end

		if flowerpu == SH_NICEFLOWER then
			return "MarioSonIFLW"
		end
	end

	if flowerpu == SH_GOLDENSHFORM then
		return "MarioSonGOLD"
	end

	return
end

local function P_SpawnSpecialBGStar(a, tic, col, momz, fuse, momx, momy, scale, color)
	if (leveltime % 8)/tic then
		local randomness_jitter = P_RandomRange(-4, 4) << FRACBITS
		local x = P_RandomRange(-24,24) << FRACBITS + randomness_jitter
		local y = P_RandomRange(-24,24) << FRACBITS + randomness_jitter
		local z = P_RandomRange(0,48) << FRACBITS + randomness_jitter
		local poweruppar

		if P_RandomKey(16) == 2 then
			poweruppar = P_SpawnMobjFromMobj(a, x, y, z, MT_POPPARTICLEMAR)
			poweruppar.state = S_SM64BGSTAR
			poweruppar.dispoffset = -3
			poweruppar.angle = a.angle
			poweruppar.scale = scale or a.scale
			poweruppar.color = color or a.color
			poweruppar.colorized = col
			poweruppar.momz = momz
			poweruppar.momx = (momx or 1)/2
			poweruppar.momy = (momy or 1)/2
			poweruppar.fuse = fuse
		end

		poweruppar = P_SpawnMobjFromMobj(a, x, y, z, MT_POPPARTICLEMAR)
		poweruppar.state = S_SM64SPARKLESSINGLE
		poweruppar.angle = a.angle
		poweruppar.scale = scale or a.scale
		poweruppar.color = color or a.color
		poweruppar.colorized = col
		poweruppar.momz = momz
		poweruppar.momx = (momx or 1)/2
		poweruppar.momy = (momy or 1)/2
		poweruppar.fuse = fuse
	end
end

local function P_SpawnParticlesforPowers(a, tic, state, col, momz, fuse, momx, momy, scale, color)
	if (leveltime % 8)/tic then
		local randomness_jitter = P_RandomRange(-4, 4) << FRACBITS
		local poweruppar = P_SpawnMobjFromMobj(a, P_RandomRange(-24,24) << FRACBITS + randomness_jitter, P_RandomRange(-24,24) << FRACBITS + randomness_jitter, P_RandomRange(0,48) << FRACBITS + randomness_jitter, MT_POPPARTICLEMAR)
		poweruppar.state = state
		poweruppar.angle = a.angle
		poweruppar.scale = scale or a.scale
		poweruppar.color = color or a.color
		poweruppar.colorized = col
		poweruppar.momz = momz
		poweruppar.momx = (momx or 1)/2
		poweruppar.momy = (momy or 1)/2
		poweruppar.fuse = fuse
	end
end

local function P_SetPlayerStatsforPowers(p, cs)
	T_PowerUpStats[cs](p)
	p.pkzmariochanges = true
end


local function P_CheckShieldSize(player, shieldcheck)
	if not (player.powers[pw_shield] == SH_NONE or player.powers[pw_shield] == SH_BIGSHFORM or player.powers[pw_shield] == SH_MINISHFORM or
	player.powers[pw_shield] == SH_NEWFIREFLOWER or player.powers[pw_shield] == SH_NICEFLOWER or player.powers[pw_shield] == SH_GOLDENSHFORM) then
		if shieldcheck then P_SpawnShieldOrb(player) end
		return skins[player.mo.skin].shieldscale
	else
		return 0
	end
end

local function P_PlayerCheckActualForm(player)
	local currentshield

	if (player.powers[pw_shield] == SH_NONE or player.powers[pw_shield] == SH_BIGSHFORM or player.powers[pw_shield] == SH_MINISHFORM) then
		currentshield = player.powers[pw_shield]
	else
		currentshield = SH_BIGSHFORM
	end

	return currentshield
end

local function P_SpawnInvincibilityGhost(mo)
	local ghost = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_GHOST)
	ghost.angle = mo.angle

	ghost.target = mo
	ghost.tracer = mo
	ghost.dontdrawforviewmobj = mo

	ghost.color = mo.color
	ghost.colorized = mo.colorized

	ghost.roll = mo.roll
	ghost.pitch = mo.pitch
	ghost.spriteroll = mo.spriteroll

	ghost.renderflags = mo.renderflags
	ghost.blendmode = mo.blendmode

	ghost.skin = mo.skin
	ghost.sprite = mo.sprite
	ghost.sprite2 = mo.sprite2
	ghost.frame = mo.frame
	ghost.frame = $ & ~(FF_TRANSMASK)
	ghost.tics = mo.tics
	ghost.flags2 = ($ & MF2_SPLAT) | MF2_LINKDRAW

	ghost.spritexscale = mo.spritexscale
	ghost.spriteyscale = mo.spriteyscale
	ghost.spritexoffset = mo.spritexoffset
	ghost.spriteyoffset = mo.spriteyoffset
	ghost.dispoffset = 2

	ghost.fuse = 2

	if mo.flags2 & MF2_OBJECTFLIP then
		ghost.flags2 = $|MF2_OBJECTFLIP
	end

	P_MoveOrigin(ghost, mo.x, mo.y, mo.z)
	ghost.momx = mo.momx
	ghost.momy = mo.momy
	ghost.momz = mo.momz

	return ghost
end

--Mario Mode Character Changes
addHook("PostThinkFrame", function() 
	for player in players.iterate do
		if not mariomode then return nil end
		-- damage scenario
		if player.playerstate == PST_DEAD then return end

		if player.mo.marinvtimer ~= nil then
			if player.mo.marinvtimer > 0 then
				local ghost = P_SpawnInvincibilityGhost(player.mo)
				ghost.frame = $|FF_TRANS60
				ghost.color = player.mo.color
				ghost.fuse = 4
				player.powers[pw_shield] = ((player.mo.marinvtimer % 6)>>1 and player.mo.shield1 or player.mo.shield2)
				A_ForceStop(player.mo, 0, 0)
				--P_SwitchShield(player, ((player.mo.marinvtimer % 9)/5 and player.mo.shield1 or player.mo.shield2))
				player.mo.flags2 = $ &~ MF2_DONTDRAW
				player.shieldscale = P_CheckShieldSize(player, true)
				player.camerascale = player.mo.rescamerascale
				P_TeleportCameraMove(camera, player.mo.reservedcamerax, player.mo.reservedcameray, player.mo.reservedcameraz)
				camera.momx = 0
				camera.momy = 0
				camera.momz = 0
				camera.aiming = player.mo.reservedcameraaiming
				player.mo.marinvtimer = $-1
			else
				player.powers[pw_shield] = player.mo.shield2
				if not (player.powers[pw_super] and player.powers[pw_invulnerability]) then
					if (player.powers[pw_shield] == SH_NEWFIREFLOWER or player.powers[pw_shield] == SH_NICEFLOWER or (player.powers[pw_shield] & SH_FIREFLOWER)) then
						player.mo.eflags = $ | MFE_FORCESUPER
					else
						player.mo.eflags = $ &~ MFE_FORCESUPER
					end
				end
				player.shieldscale = P_CheckShieldSize(player, true)
				if P_IsObjectOnGround(player.mo) then
					local cmd = player.cmd
					if cmd.forwardmove or cmd.sidemove then
						player.mo.momx = player.mo.reservedmomx/2
						player.mo.momy = player.mo.reservedmomy/2
					end
				else
					player.mo.momx = player.mo.reservedmomx
					player.mo.momy = player.mo.reservedmomy
					player.mo.momz = player.mo.reservedmomz
				end
				A_MarioPainReset(player.mo)
			end
		end

		player.shieldscale = P_CheckShieldSize(player, false)
	end
end)

addHook("PlayerSpawn", function(player)
	player.mariomode.backup_pentup = 0

	if player.mo and player.mo.valid and not (not (xMM_registry.skinCheck(player.mo.skin) & DSF_POWERUPS) or mariomode) then
		if player.pkzmariochanges then
			player.mo.scale = FRACUNIT
			player.mo.color = player.color
			player.camerascale = skin.camerascale
			player.jumpfactor = skin.jumpfactor
			--player.runspeed = skin.runspeed
			player.normalspeed = skin.normalspeed
			player.pkzmariochanges = false
		end
	end
end)

local function P_SpawnModifiableGhost(mo, func)
	local ghost = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_BLOCKVIS)
	ghost.angle = mo.angle

	ghost.target = mo
	ghost.tracer = mo
	ghost.dontdrawforviewmobj = mo

	ghost.color = mo.color
	ghost.colorized = mo.colorized

	ghost.roll = mo.roll
	ghost.pitch = mo.pitch
	ghost.spriteroll = mo.spriteroll

	ghost.renderflags = mo.renderflags
	ghost.blendmode = mo.blendmode

	ghost.sprite = mo.sprite
	ghost.frame = mo.frame
	ghost.frame = $ & ~(FF_TRANSMASK)
	ghost.tics = mo.tics
	ghost.flags2 = ($ & MF2_SPLAT) | MF2_LINKDRAW

	ghost.spritexscale = mo.spritexscale
	ghost.spriteyscale = mo.spriteyscale
	ghost.spritexoffset = mo.spritexoffset
	ghost.spriteyoffset = mo.spriteyoffset
	ghost.dispoffset = 2

	ghost.fuse = 2
	ghost.sprmodel = 99
	ghost.customfunc = func

	if mo.flags2 & MF2_OBJECTFLIP then
		ghost.flags2 = $|MF2_OBJECTFLIP
	end

	return ghost
end

addHook("PlayerThink", function(player)
	if not (player.valid and player.mo and player.mo.valid) then return end
	local skin = skins[player.skin]

	if player.mo.skin == "sonic" then
		if not (player.powers[pw_super] and player.powers[pw_invulnerability]) and
		(player.powers[pw_shield] == SH_NEWFIREFLOWER or player.powers[pw_shield] == SH_NICEFLOWER or (player.powers[pw_shield] & SH_FIREFLOWER)) then
			player.mo.eflags = $ | MFE_FORCESUPER
		else
			player.mo.eflags = $ &~ MFE_FORCESUPER
		end
	end

	if not mariomode then return end

	-- Dust behind player
	--if (leveltime & 0xA)/6 and (player.speed) > (skin.normalspeed - 15 << FRACBITS) and
	--P_IsObjectOnGround(player.mo) and (player.mo.state == S_PLAY_RUN or player.mo.state == S_PLAY_WALK) then
	--	local rundust = P_SpawnMobjFromMobj(player.mo, P_RandomRange(-11,11) << FRACBITS, P_RandomRange(-11,11) << FRACBITS, 0, MT_SPINDUST)
	--	rundust.angle = player.mo.angle+P_RandomRange(-11,11)*ANG1
	--	rundust.momx = player.mo.momx
	--	rundust.momy = player.mo.momy
	--end

	if player.mariomode.backup_pentup > 0
	and player.cmd and not (player.cmd.buttons & BT_TOSSFLAG) then
		player.mariomode.backup_pentup = $-1
	end

	-- Invulnerability State
	if player.powers[pw_invulnerability] > 0 then
		player.runspeed = skin.runspeed
		player.normalspeed = skin.normalspeed*3 >> 1

		if player.curinvtimer == nil then player.curinvtimer = 1 end
		local ghost = P_SpawnInvincibilityGhost(player.mo)
		local fade = (8-(player.curinvtimer % 8)-1) << FF_TRANSSHIFT
		ghost.frame = $ | fade
		ghost.color = T_InvColors[((player.curinvtimer-1 >> 3) % #T_InvColors)+1]

		local fog_height = player.mo.height/32
		local fog_width = player.mo.radius/16

		-- follow invfog
		local fog = P_SpawnInvincibilityGhost(player.mo)
		fog.state = S_WIILIKEINVFOG
		fog.color = ghost.color
		fog.frame = $| ((leveltime % 2) == 1 and FF_HORIZONTALFLIP or 0)
		fog.fuse = 3
		fog.spritexscale = fog_width
		fog.spriteyscale = fog_height

		-- trail invfog
		if player.speed > FRACUNIT*12 then
			fog = P_SpawnInvincibilityGhost(player.mo)
			fog.state = S_WIILIKEINVFOG
			fog.color = ghost.color
			fog.fuse = 4
			fog.momx = player.mo.momx/32
			fog.momy = player.mo.momy/32
			fog.momz = player.mo.momz/32
			fog.spritexscale = fog_width
			fog.spriteyscale = fog_height
		end

		if player.followmobj then
			local tail_ghost = P_SpawnInvincibilityGhost(player.followmobj)
			tail_ghost.frame = ghost.frame
			tail_ghost.color = ghost.color
		end

		player.curinvtimer = ($+1) % INDEXINVMUL

		player.mo.color = T_InvColors[(player.curinvtimer >> 3)+1]
		P_SpawnSpecialBGStar(player.mo, 4, false, 0, TICRATE, player.mo.momx, player.mo.momy, 3*player.mo.scale/4, T_InvColors[P_RandomKey(#T_InvColors)])
		if player.powers[pw_invulnerability] > 1 then
			player.mo.colorized = true
			player.mo.frame = $|FF_FULLBRIGHT
		else
			player.mo.colorized = false
			player.mo.frame = $ &~ FF_FULLBRIGHT
		end
		-- Golden Form State
	elseif player.powers[pw_shield] == SH_GOLDENSHFORM then
		player.mo.color = SKINCOLOR_GOLD
		player.shieldscale = 0
		player.mo.colorized = true
		P_SpawnParticlesforPowers(player.mo, 4, S_SM64SPARKLESSINGLE, false, 0, TICRATE)

		player.mo.translation = P_GetPowerUpTranslationColors(SH_GOLDENSHFORM, player.mo.skin)
	else
		-- Size Forms

		-- Size check
		local currentshield = P_PlayerCheckActualForm(player)
		local flowerpu = player.powers[pw_shield]

		P_SetPlayerStatsforPowers(player, currentshield)
		player.mo.frame = $ &~ FF_FULLBRIGHT

		-- Color check
		if (flowerpu == SH_NEWFIREFLOWER or flowerpu == SH_NICEFLOWER or (flowerpu & SH_FIREFLOWER)) and not player.powers[pw_super] and not player.powers[pw_invulnerability] then
			if (flowerpu &~ SH_FIREFLOWER) then
				player.mo.color = P_GetPowerUpColors(flowerpu, player.mo.skin)
			else
				player.mo.color = SKINCOLOR_WHITE
			end

			if (player.powers[pw_shield] == SH_NEWFIREFLOWER or player.powers[pw_shield] == SH_NICEFLOWER) then
				P_SpawnParticlesforPowers(player.mo, 7, player.powers[pw_shield] == SH_NEWFIREFLOWER and S_FLAMEPARTICLE or S_SM64SPARKLESSINGLE, true, FRACUNIT, TICRATE)
			end
		else
			player.mo.color = player.skincolor
		end

		player.mo.translation = P_GetPowerUpTranslationColors(flowerpu, player.mo.skin)
		player.mo.colorized = false
	end
end)

-- Invidiual Action Functions for power-up gains
-- Redirection of Mario Pick Ups. -- It is possible it may going to be reversed

function A_GiveMarioPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= var1 then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], var1, 5)
		else
			actor.target.player.powers[pw_shield] = var1
		end
	end
end

function A_SpawnGoldenFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_GOLDENSHFORM then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_GOLDENSHFORM, 5)
		else
			actor.target.player.powers[pw_shield] = SH_THUNDERCOIN
		end
	end
end

function A_SpawnFireFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_NEWFIREFLOWER then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_NEWFIREFLOWER, 5)
		else
			actor.target.player.powers[pw_shield] = SH_FIREFLOWER
		end
	end
end

function A_SpawnIcyFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_NICEFLOWER then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_NICEFLOWER, 5)
		else
			actor.target.player.powers[pw_shield] = SH_BUBBLEWRAP
		end
	end
end

function A_SpawnRedFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) and (actor.target.player.powers[pw_shield] == SH_MINISHFORM or actor.target.player.powers[pw_shield] == SH_NONE) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_BIGSHFORM, 5)
		elseif actor.target.skin == "mario" and actor.target.player.mariohealth ~= nil then
			actor.target.player.mariohealth = 3
			actor.target.player.mariocoins = 0
		else
			actor.target.player.rings = $+10
		end
	end
end

function A_SpawnMiniFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and not actor.target.player.powers[pw_shield] ~= SH_MINISHFORM then
		if not (xMM_registry.skinCheck(actor.target.skin) & DSF_POWERUPS) then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_MINISHFORM, 5)
		else
			actor.target.player.powers[pw_shield] = SH_MINI
		end
	end
end

-- Assign item into item holder


local POWER_UP_COOLDOWN = 3 * (21*TICRATE/60) / 2
local POWER_UP_ANIMHOLDUP = 4*POWER_UP_COOLDOWN/5

addHook("PlayerThink", function(player)
	if not (player.mo and player.mo.valid) then return end

	local playerpower = player.powers[pw_shield]

	if (player.cmd.buttons & BT_ATTACK) and not player.countdownpw then
		if playerpower == SH_NEWFIREFLOWER then
			P_SpawnPlayerMissile(player.mo, MT_PKZFB)
			S_StartSound(player.mo, sfx_mario7)

			player.countdownpw = POWER_UP_COOLDOWN
		elseif playerpower == SH_NICEFLOWER then
			P_SpawnPlayerMissile(player.mo, MT_PKZIB)
			S_StartSound(player.mo, sfx_maice1)

			player.countdownpw = POWER_UP_COOLDOWN
		elseif playerpower == SH_GOLDENSHFORM then
			P_SpawnPlayerMissile(player.mo, MT_PKZGB)
			S_StartSound(player.mo, sfx_mario7)

			player.countdownpw = POWER_UP_COOLDOWN
		end
	end


	if player.countdownpw then
		if player.countdownpw > POWER_UP_ANIMHOLDUP
		and player.mo.state ~= S_PLAY_GASP
		and player.panim < 6 then
			player.mo.state = S_PLAY_GASP
		end

		player.countdownpw = $-1
	end
end)

local function ghostThinker(a)
	local timer = (7-a.fuse)
	a.frame = $|(timer << FF_TRANSSHIFT)
	a.scale = $-FRACUNIT/10
end

for _,powerballs in pairs({
	MT_PKZFB,
	MT_PKZIB,
	MT_PKZGB
	}) do

	addHook("MobjThinker", function(a)
		a.blendmode = AST_ADD
		a.rollangle = $ + ANG15
		a.momx = 25*cos(a.angle)
		a.momy = 25*sin(a.angle)

		if not a.non_player then
			if P_IsObjectOnGround(a) then
				a.spriteyscale = FRACUNIT-FRACUNIT/4
				a.spritexscale = FRACUNIT+FRACUNIT/4
				a.momz = 10 << FRACBITS
			else
				if a.spriteyscale < FRACUNIT then
					a.spriteyscale = $+FRACUNIT/24
				end

				if a.spritexscale > FRACUNIT then
					a.spritexscale = $-FRACUNIT/24
				end
			end
		end

		if not (leveltime % 2) then
			local gh = P_SpawnModifiableGhost(a, ghostThinker)
			gh.scale = a.scale - (FRACUNIT >> 2)
			gh.frame = $|FF_TRANS10|FF_ADD
			gh.fuse = 7
		end
	end, powerballs)
end

addHook("MobjRemoved", function(actor)
	local blast = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
	blast.scale = blast.scale*5/3
	blast.state = S_MMFIREBALLBLAST
	blast.blendmode = AST_ADD

	S_StartSound(blast, sfx_nmara3)
end, MT_PKZFB)


addHook("MobjRemoved", function(actor)
	local blast = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
	blast.state = S_MARIOPUFFPARTFASTER
	blast.scale = 2*blast.scale/3
	blast.frame = $|FF_TRANS40
	blast.blendmode = AST_ADD
	blast.color = SKINCOLOR_SKY
	blast.colorized = true

	S_StartSound(blast, sfx_maice2)

	for i = 1, 8 do
		local stars = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
		stars.state = S_SM64SPARKLESSINGLE
		stars.angle = ANGLE_45*i+P_RandomRange(-8,8)*ANG1
		stars.momz = (P_RandomRange(-3,3) << FRACBITS)
		stars.color = SKINCOLOR_SKY

		P_Thrust(stars, stars.angle, actor.radius/12)
	end
end, MT_PKZIB)

addHook("MobjRemoved", function(actor)
	local blast = P_SpawnMobjFromMobj(actor, 0,0,0+actor.height >> 1, MT_POPPARTICLEMAR)
	blast.state = S_NEWPICARTICLE
	blast.sprite = SPR_PUP2
	blast.scale = blast.scale >> 1
	blast.fuse = 18
	blast.color = SKINCOLOR_GOLD
	blast.blendmode = AST_TRANSLUCENT
	blast.spparticle = 1

	if actor.actblyx ~= nil then
		local t = actor.actblyx
		-- Golden Balls
		if t.type == MT_SPRIMBRICK then
			P_SpawnMobjFromMobj(t, 0,0,12 << FRACBITS, MT_COIN)
			P_RemoveMobj(t)
		elseif t.blocktype ~= nil then
			t.activate = true
		end
	end
end, MT_PKZGB)