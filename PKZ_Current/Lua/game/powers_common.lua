/* 
		Pipe Kingdom Zone's Power-Up Base - game_powerups.lua

Description:
Work-around for power-ups in Mario Mode

Contributors: Skydusk
@Team Blue Spring 2024
*/

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
			return PKZ_Table.getFlameColor(4)
		end	
		
		if flowerpu == SH_NICEFLOWER then
			return PKZ_Table.getIcyColor(5)
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

local function P_SpawnParticlesforPowers(a, tic, state, col, momz, fuse)
	if (leveltime % 8)/tic then
		local poweruppar = P_SpawnMobjFromMobj(a, P_RandomRange(-24,24) << FRACBITS, P_RandomRange(-24,24) << FRACBITS, P_RandomRange(0,48) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = state
		poweruppar.angle = a.angle
		poweruppar.scale = a.scale
		poweruppar.color = a.color
		poweruppar.colorized = col
		poweruppar.momz = momz
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
	
	if (player.powers[pw_shield] == SH_NEWFIREFLOWER or player.powers[pw_shield] == SH_NICEFLOWER) then
		P_SpawnParticlesforPowers(player.mo, 7, S_FLAMEPARTICLE, true, FRACUNIT, TICRATE)
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

//Mario Mode Character Changes
addHook("PostThinkFrame", do for player in players.iterate do
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
	local skin = skins[player.skin]
	player.mariomode.backup_pentup = 0
	
	if player.mo and player.mo.valid and PKZ_Table.disabledSkins[player.mo.skin] == false or not mariomode then 
		if player.pkzmariochanges then
			player.mo.scale = skin.scale
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
	
	// Dust behind player
	--if (leveltime & 0xA)/6 and (player.speed) > (skin.normalspeed - 15 << FRACBITS) and 
	--P_IsObjectOnGround(player.mo) and (player.mo.state == S_PLAY_RUN or player.mo.state == S_PLAY_WALK) then
	--	local rundust = P_SpawnMobjFromMobj(player.mo, P_RandomRange(-11,11) << FRACBITS, P_RandomRange(-11,11) << FRACBITS, 0, MT_SPINDUST)
	--	rundust.angle = player.mo.angle+P_RandomRange(-11,11)*ANG1
	--	rundust.momx = player.mo.momx
	--	rundust.momy = player.mo.momy
	--end
	
	if player.mariomode.backup_pentup > 0 and not input.gameControlDown(GC_TOSSFLAG) then
		player.mariomode.backup_pentup = $-1
	end
	
	// Invulnerability State
	if player.powers[pw_invulnerability] > 0 then
		player.runspeed = skin.runspeed
		player.normalspeed = skin.normalspeed*3 >> 1
			
		if player.curinvtimer == nil then player.curinvtimer = 1 end
		local ghost = P_SpawnInvincibilityGhost(player.mo)
		local fade = (8-(player.curinvtimer % 8)-1) << FF_TRANSSHIFT
		ghost.frame = $ | fade
		ghost.color = T_InvColors[((player.curinvtimer-1 >> 3) % #T_InvColors)+1]
		
		if player.followmobj then
			local tail_ghost = P_SpawnInvincibilityGhost(player.followmobj)
			tail_ghost.frame = ghost.frame
			tail_ghost.color = ghost.color
		end		
		
		player.curinvtimer = ($+1) % INDEXINVMUL

		player.mo.color = T_InvColors[(player.curinvtimer >> 3)+1]
		P_SpawnParticlesforPowers(player.mo, 4, S_INVINCSTAR, false, 0, TICRATE)
		if player.powers[pw_invulnerability] > 1 then
			player.mo.colorized = true
			player.mo.frame = $|FF_FULLBRIGHT
		else
			player.mo.colorized = false
			player.mo.frame = $ &~ FF_FULLBRIGHT
		end
		// Golden Form State
	elseif player.powers[pw_shield] == SH_GOLDENSHFORM then
		player.mo.color = SKINCOLOR_GOLD
		player.shieldscale = 0
		player.mo.colorized = true
		P_SpawnParticlesforPowers(player.mo, 4, S_INVINCSTAR, false, 0, TICRATE)
		
		player.mo.translation = P_GetPowerUpTranslationColors(SH_GOLDENSHFORM, player.mo.skin)
	else
		// Size Forms
			
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
		else
			player.mo.color = player.skincolor
			
		end
	
		player.mo.translation = P_GetPowerUpTranslationColors(flowerpu, player.mo.skin)
		player.mo.colorized = false
	end	
end)

// Invidiual Action Functions for power-up gains 
// Redirection of Mario Pick Ups. -- It is possible it may going to be reversed

function A_GiveMarioPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= var1 then
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false then
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], var1, 5)
		else
			actor.target.player.powers[pw_shield] = var1
		end
	end
end

function A_SpawnGoldenFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_GOLDENSHFORM then
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_GOLDENSHFORM, 5)
		else
			actor.target.player.powers[pw_shield] = SH_THUNDERCOIN	
		end
	end
end

function A_SpawnFireFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_NEWFIREFLOWER then
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_NEWFIREFLOWER, 5)			
		else
			actor.target.player.powers[pw_shield] = SH_FIREFLOWER			
		end
	end
end

function A_SpawnIcyFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player and actor.target.player.powers[pw_shield] ~= SH_NICEFLOWER then
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_NICEFLOWER, 5)
		else
			actor.target.player.powers[pw_shield] = SH_BUBBLEWRAP			
		end		
	end
end

function A_SpawnRedFormPowerUp(actor, var1, var2)
	if actor.target and actor.target.player then
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false and (actor.target.player.powers[pw_shield] == SH_MINISHFORM or actor.target.player.powers[pw_shield] == SH_NONE)
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
		if PKZ_Table.disabledSkins[actor.target.skin] ~= false
			A_MarioPain(actor.target, actor.target.player.powers[pw_shield], SH_MINISHFORM, 5)
		else
			actor.target.player.powers[pw_shield] = SH_MINI
		end
	end
end

// Assign item into item holder

local spowerups = {
	[SH_NEWFIREFLOWER] = {pl = MT_PKZFB},
	[SH_NICEFLOWER] = {pl = MT_PKZIB},
	[SH_GOLDENSHFORM] = {pl = MT_PKZGB} 
}
	

addHook("PlayerThink", function(player)
	local playerpower = player.powers[pw_shield]
	if player.countdownpw == nil
		player.countdownpw = 0		
	end

	if player.countdownpw == 0 and (player.cmd.buttons & BT_ATTACK) and
	((playerpower == SH_NEWFIREFLOWER) or (playerpower == SH_NICEFLOWER) or (playerpower == SH_GOLDENSHFORM)) then
		S_StartSound(player.mo, sfx_mario7)	
		P_SpawnPlayerMissile(player.mo, spowerups[playerpower].pl)
		player.countdownpw = 16
	end

	if player.countdownpw > 0
		player.countdownpw = $-1
	end	

end)

for _,powerballs in pairs({
	MT_PKZFB,
	MT_PKZIB,
	MT_PKZGB
	}) do
	
addHook("MobjThinker", function(actor)
	actor.blendmode = AST_ADD

	actor.rollangle = $ + ANG15
	if P_IsObjectOnGround(actor) and not actor.plzno then
		actor.momz = 10 << FRACBITS
	end
	actor.momx = 25*cos(actor.angle)
	actor.momy = 25*sin(actor.angle)
	
	if not (leveltime % 2) then
		local gh = P_SpawnModifiableGhost(actor, function(a)
			local timer = (7-a.fuse) 
			a.frame = $|(timer << FF_TRANSSHIFT)
			a.scale = $-FRACUNIT/10
		end)
		gh.scale = actor.scale - (FRACUNIT >> 2)
		--gh.momx = actor.momx >> 3
		--gh.momy = actor.momy >> 3
		--gh.momz = actor.momz >> 3
		gh.frame = $|FF_TRANS10|FF_ADD
		gh.fuse = 7
	end
end, powerballs)

local coloringfb = {
		[MT_PKZFB] = SKINCOLOR_NONE,
		[MT_PKZIB] = SKINCOLOR_SKY,	
		[MT_PKZGB] = SKINCOLOR_GOLD	
}

addHook("MobjRemoved", function(actor)
	if actor.type ~= MT_PKZGB
		local fireballparticle = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
		fireballparticle.scale = FRACUNIT*5/3
		fireballparticle.state = S_FIREBALLDEAD
		fireballparticle.blendmode = AST_ADD
		fireballparticle.color = coloringfb[actor.type]
		fireballparticle.colorized = true
	else
		local spparticle = P_SpawnMobjFromMobj(actor, 0,0,0+actor.height >> 1, MT_POPPARTICLEMAR)
		spparticle.state = S_NEWPICARTICLE
		spparticle.sprite = SPR_PUP2
		spparticle.scale = actor.scale >> 1
		spparticle.fuse = 18
		spparticle.color = SKINCOLOR_GOLD
		spparticle.blendmode = AST_TRANSLUCENT
		spparticle.spparticle = 1
	end
	
	if actor.actblyx ~= nil and actor.type == MT_PKZGB then
		local t = actor.actblyx 
		-- Golden Balls 
		if t.type == MT_SPRIMBRICK
			P_SpawnMobjFromMobj(t, 0,0,12 << FRACBITS, MT_COIN)
			P_RemoveMobj(t)
		elseif t.blocktype ~= nil
			t.activate = true
		end
	end
end, powerballs)

end
