/* 
		Pipe Kingdom Zone's Backup System - game_backuppw.lua

Description:
Mario Mode Backup System

Contributors: Skydusk
@Team Blue Spring 2024
*/

// Assign item into item holder
local pwBackupSystem = {}

pwBackupSystem.drawer_data = {
	current_state = 0,
	current_default = 0,
	tics = 0,
	offset_x = 0,
	offset_y = 0,
	offscale = 0,
	offscale_x = 0,
	offscale_y = 0,
	
	-- change animation into itemholder
	[-2] = {offset_x = 0, offset_y = -16, offscale = 0, offscale_x = FRACUNIT >> 2, offscale_y = FRACUNIT >> 2, tics = 4, nexts = -1},
	[-1] = {offset_x = 0, offset_y = 2, offscale = 0, offscale_x = FRACUNIT >> 4, offscale_y = FRACUNIT >> 4, tics = 2, nexts = nil},
	
	-- Lively mushroom animation into itemholder
	[0] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = 0, offscale_y = 0, tics = 20, nexts = 1},
	[1] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offset_x = 0, offset_y = -2, offscale = 0, offscale_x = -(FRACUNIT >> 5), offscale_y = (FRACUNIT >> 5), tics = 3, nexts = 3},
	[3] = {offset_x = 0, offset_y = 1, offscale = 0, offscale_x = (FRACUNIT >> 5), offscale_y = -(FRACUNIT >> 5), tics = 3, nexts = 0},	
	
	-- Lively flower animation into itemholder
	[10] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = 0, offscale_y = 0, tics = 10, nexts = 11},
	[11] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = 0, offscale_y = 0, tics = 3, nexts = 12},
	[12] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = -(FRACUNIT >> 5), offscale_y = 0, tics = 3, nexts = 13},
	[13] = {offset_x = 0, offset_y = 0, offscale = 0, offscale_x = 0, offscale_y = -(FRACUNIT >> 5), tics = 3, nexts = 10},
}

pwBackupSystem.assign = function(a, mo, kill_mobj)
	local shpl = mo.player.powers[pw_shield]
	
	if not (mariomode and mo.type == MT_PLAYER and mo.player and mo.player) then return false end
	
	local get_pw = pwBackupSystem.pw_list[shpl]
	if get_pw ~= mo.player.mariomode.sidepowerup then
		pwBackupSystem.drawer_data.current_default = pwBackupSystem.pw_anim_list[shpl] or 0
		pwBackupSystem.drawer_data.current_state = -2
		pwBackupSystem.drawer_data.tics = 0	
	end
	mo.player.mariomode.sidepowerup = (get_pw or $)
	
	if a and a.valid and not kill_mobj then
		P_KillMobj(a, mo, mo)
	end
	
	return
end

pwBackupSystem.drawerAnim = function()
	local data = pwBackupSystem.drawer_data
	local cur_state = data[data.current_state]
	local next_state = data[cur_state.nexts or data.current_default]
	local progress = (FRACUNIT/cur_state.tics)*data.tics
	
	pwBackupSystem.drawer_data.offset_x = ease.outsine(progress, cur_state.offset_x, next_state.offset_x)
	pwBackupSystem.drawer_data.offset_y = ease.outsine(progress, cur_state.offset_y, next_state.offset_y)
	pwBackupSystem.drawer_data.offscale = ease.outsine(progress, cur_state.offscale, next_state.offscale)
	pwBackupSystem.drawer_data.offscale_x = ease.outsine(progress, cur_state.offscale_x, next_state.offscale_x)+pwBackupSystem.drawer_data.offscale
	pwBackupSystem.drawer_data.offscale_y = ease.outsine(progress, cur_state.offscale_y, next_state.offscale_y)+pwBackupSystem.drawer_data.offscale

	if data.current_state < 0 or 
	consoleplayer.powers[pw_shield] == 0 or 
	consoleplayer.powers[pw_shield] == 2500 or
	consoleplayer.powers[pw_shield] == 2503 then
		pwBackupSystem.drawer_data.tics = $+1
		if pwBackupSystem.drawer_data.tics == cur_state.tics then
			pwBackupSystem.drawer_data.current_state = cur_state.nexts or data.current_default
			pwBackupSystem.drawer_data.tics = 0
		end
	else
		pwBackupSystem.drawer_data.tics = 0
		pwBackupSystem.drawer_data.current_state = data.current_default
	end
end

pwBackupSystem.reset = function(p)	
	p.mariomode.sidepowerup = 0
end

pwBackupSystem.takeItem = function(p)
	if not (p.mo and p.mo.valid and p.mariomode.sidepowerup) then return end
		
	local height_offset = p.mo.height+28*p.mo.scale

	--MT_ITEMHOLDERBALLOON
	if pwBackupSystem.balloon_list[p.mariomode.sidepowerup] then
		local item_balloon = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z+height_offset, MT_ITEMHOLDERBALLOON)
		item_balloon.item = p.mariomode.sidepowerup
		item_balloon.frame = pwBackupSystem.balloon_list[p.mariomode.sidepowerup].frame
	else
		local backuppowerup = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z+height_offset, p.mariomode.sidepowerup)
		backuppowerup.noscore = true
		backuppowerup.reserved = true	
	end
	
	for i = 1, 8 do
		local angle = P_RandomRange(0,8)*ANGLE_45
		local sparkles = P_SpawnMobj(p.mo.x+12*sin(angle), p.mo.y+12*cos(angle), p.mo.z+height_offset+P_RandomRange(0,53) << FRACBITS, MT_POPPARTICLEMAR)
		sparkles.state = S_INVINCSTAR
		sparkles.scale = FRACUNIT+FRACUNIT >> 1
		if pwBackupSystem.balloon_list[p.sidepowerup] then
			sparkles.color = pwBackupSystem.balloon_list[p.mariomode.sidepowerup].color
		else	
			sparkles.color = SKINCOLOR_GOLD
		end
		sparkles.fuse = TICRATE
	end

	p.mariomode.sidepowerup = 0	
	S_StartSound(p.mo, sfx_marwod)	
end

local BALLOON_XSTART = FixedDiv(3 << FRACBITS, 43 << FRACBITS)
local BALLOON_YSTART = FixedDiv(25 << FRACBITS, 54 << FRACBITS)

local function P_SpawnBalloonInProgress(p, powerup, winduptimer)
	local progress, color, mo
	if not (p.mo and p.mo.valid) then return end
	mo = p.mo
	
	if not pwBackupSystem.balloon_list[powerup] then
		color = SKINCOLOR_GREEN
	else
		color = pwBackupSystem.balloon_list[powerup].color		
	end
	
	local height_offset = mo.height+28*mo.scale
	progress = ((winduptimer or 0) << FRACBITS)/25
	
	local inprogress = P_SpawnMobj(mo.x, mo.y, mo.z+height_offset, MT_POPPARTICLEMAR)
	inprogress.state = S_ITEMHOLDERBALLOON
	inprogress.spritexscale = ease.incubic(progress, BALLOON_XSTART, FRACUNIT)
	inprogress.spriteyscale = ease.insine(progress, BALLOON_YSTART, FRACUNIT)	
	inprogress.color = color
	inprogress.frame = $|FF_TRANS50
	inprogress.fuse = 3
end

// Player 1 Set Up
addHook("KeyDown", function(keyevent)
	if not (mariomode and keyevent.num == input.gameControlToKeyNum(GC_TOSSFLAG)) then return end
	// Press "tossflag" button to release powerup from item holder	
	if consoleplayer.mariomode.sidepowerup and consoleplayer.mariomode.backup_pentup > 24 then
		PKZ_pwBackupSystem.takeItem(consoleplayer)
		return false
	end
	
	if consoleplayer.mariomode.sidepowerup and consoleplayer.mariomode.backup_pentup <= 24 then
		P_SpawnBalloonInProgress(consoleplayer, consoleplayer.mariomode.sidepowerup, consoleplayer.mariomode.backup_pentup)
		consoleplayer.mariomode.backup_pentup = $+1
	end
end)

// Player 2 Set Up
addHook("KeyDown", function(keyevent)
	if not (mariomode and keyevent.num == input.gameControl2ToKeyNum(GC_TOSSFLAG)) then return end
	// Press "tossflag" button to release powerup from item holder
	if secondarydisplayplayer.mariomode.sidepowerup and secondarydisplayplayer.mariomode.backup_pentup > 24 then
		PKZ_pwBackupSystem.takeItem(secondarydisplayplayer)
	end
	
	if secondarydisplayplayer.mariomode.backup_pentup <= 24 then
		P_SpawnBalloonInProgress(secondarydisplayplayer, secondarydisplayplayer.mariomode.sidepowerup, secondarydisplayplayer.mariomode.backup_pentup)	
		secondarydisplayplayer.mariomode.backup_pentup = $+1		
	end
end)

addHook("TouchSpecial", function(a, t)
	if a.item then
		a.toucher = t
	end
end, MT_ITEMHOLDERBALLOON)

addHook("MobjDeath", function(a, t)
	if a.item and a.toucher then
		a.state = mobjinfo[a.item].deathstate
		pwBackupSystem.assign(a, a.toucher, true)
		if mobjinfo[a.item].deathsound
			S_StartSound(t, mobjinfo[a.item].deathsound)
		end
	end
end, MT_ITEMHOLDERBALLOON)

--addHook("PostThinkFrame", do for p in players.iterate do
--		if not mariomode then return nil end
--	
--		local get_p = p.powers[pw_shield]
--		local power = pwBackupSystem.pw_list[get_p]
--		if power then
--			p.newpowerup = power
--		end
--	end
--end)

addHook("PlayerSpawn", function(p)
	if not mariomode then return end

	if PKZ_Table.disabledSkins[p.mo.skin] == nil then p.powers[pw_shield] = SH_BIGSHFORM end
	pwBackupSystem.reset(p)
end)

//Player Damage Overwritten and active item holder after receiving damage
addHook("MobjDamage", function(actor, mo)
	if not mariomode then return end
	 
	if actor.player.state ~= S_DEATHSTATE and (actor.player.powers[pw_shield] == 0 or 
	actor.player.powers[pw_shield] == 2500 or
	actor.player.powers[pw_shield] == 2503) then
		pwBackupSystem.takeItem(actor.player)
	end

	if PKZ_Table.disabledSkins[actor.player.skin] == nil then 
		
		if (actor.player.powers[pw_shield] == SH_BIGSHFORM) then
			A_MarioPain(actor, SH_BIGSHFORM, SH_NONE, 5)
			S_StartSound(nil, sfx_mariof)
	
		elseif (actor.player.powers[pw_shield] == SH_MINISHFORM) then
			if actor.player.rings > 0 and not PKZ_Table.nosonicrings then
				P_SwitchShield(actor.player, SH_MINISHFORM)
				P_DoPlayerPain(actor.player)
				P_PlayerRingBurst(actor.player, (actor.player.rings < 3 and actor.player.rings or 3))				
				S_StartSound(nil, sfx_marwoc)
				actor.player.rings = 0
			else
				pwBackupSystem.reset(actor.player)
				P_KillMobj(actor)
			end
		elseif actor.player.powers[pw_shield] == SH_FORCE|1 then 
			A_MarioPain(actor, SH_FORCE|1, SH_FORCE, 5)
			S_StartSound(nil, sfx_mariof)			
		elseif (actor.player.powers[pw_shield] & SH_PITY) or (actor.player.powers[pw_shield] & SH_WHIRLWIND) or (actor.player.powers[pw_shield] & SH_ARMAGEDDON) or
		(actor.player.powers[pw_shield] & SH_PINK) or (actor.player.powers[pw_shield] & SH_NEWFIREFLOWER) or (actor.player.powers[pw_shield] & SH_NICEFLOWER) then	
			local currentshield = actor.player.powers[pw_shield]
			A_MarioPain(actor, currentshield, SH_BIGSHFORM, 5)
			S_StartSound(nil, sfx_mariof)		
	
		elseif (actor.player.powers[pw_shield] == SH_NONE)	
			if actor.player.rings > 0 and not PKZ_Table.nosonicrings then	
				P_DoPlayerPain(actor.player)
				P_PlayerRingBurst(actor.player, (actor.player.rings < 2 and actor.player.rings or 2))
				S_StartSound(nil, sfx_marwoc)				
				actor.player.rings = 0
			else
				pwBackupSystem.reset(actor.player)
				P_KillMobj(actor)			
			end
		end
	
		return true
	end
end, MT_PLAYER)

pwBackupSystem.assign_list = {
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
	MT_ELEMENTALSHROOM,
	MT_CLOUDSHROOM,
	MT_POISONSHROOM,
	MT_FLAMESHROOM,
	MT_BUBBLESHROOM,
	MT_THUNDERSHROOM,
	MT_PITYSHROOM,
	MT_PINKSHROOM,
	--MT_MINISHROOM, I think it shouldn't happen in game.
	MT_NEWFIREFLOWER,
	MT_ICYFLOWER
}

pwBackupSystem.pw_list = {
	[SH_ARMAGEDDON] = MT_NUKESHROOM,
	[SH_FORCE] = MT_FORCESHROOM,
	[SH_FORCE|1] = MT_FORCESHROOM, 
	[SH_ATTRACT] = MT_ELECTRICSHROOM,
	[SH_ELEMENTAL] = MT_ELEMENTALSHROOM,
	[SH_WHIRLWIND] = MT_CLOUDSHROOM,
	[SH_FLAMEAURA] = MT_FLAMESHROOM,
	[SH_BUBBLEWRAP] = MT_BUBBLESHROOM,
	[SH_THUNDERCOIN] = MT_THUNDERSHROOM,
	[SH_PITY] = MT_PITYSHROOM,
	[SH_PINK] = MT_PINKSHROOM,
	--[SH_MINISHFORM] = MT_MINISHROOM, I think it shouldn't happen in game.
	[SH_NEWFIREFLOWER] = MT_NEWFIREFLOWER,
	[SH_NICEFLOWER] = MT_ICYFLOWER,
	[SH_BIGSHFORM] = 0,
	[SH_NONE] = 0,
}

pwBackupSystem.pw_anim_list = {
	[SH_ARMAGEDDON] = 0,
	[SH_FORCE] = 0,
	[SH_FORCE|1] = 0,
	[SH_ATTRACT] = 0,
	[SH_ELEMENTAL] = 0,
	[SH_WHIRLWIND] = 0,
	[SH_FLAMEAURA] = 0,
	[SH_BUBBLEWRAP] = 0,
	[SH_THUNDERCOIN] = 0,
	[SH_PITY] = 0,
	[SH_PINK] = 0,
	--[SH_MINISHFORM] = MT_MINISHROOM, I think it shouldn't happen in game.
	[SH_NEWFIREFLOWER] = 10,
	[SH_NICEFLOWER] = 10,
	[SH_BIGSHFORM] = 0,
	[SH_NONE] = 0,
}


pwBackupSystem.balloon_list = {
	[MT_NUKESHROOM] = {frame = M, color = SKINCOLOR_RUST},
	[MT_FORCESHROOM] = {frame = D, color = SKINCOLOR_COBALT},
	[MT_ELECTRICSHROOM] = {frame = N, color = SKINCOLOR_RUST},
	[MT_ELEMENTALSHROOM] = {frame = C, color = SKINCOLOR_CRIMSON},
	[MT_CLOUDSHROOM] = {frame = G, color = SKINCOLOR_BLUEBELL},
	[MT_FLAMESHROOM] = {frame = Q, color = SKINCOLOR_CRIMSON},
	[MT_BUBBLESHROOM] = {frame = F, color = SKINCOLOR_CERULEAN},
	[MT_THUNDERSHROOM] = {frame = E, color = SKINCOLOR_OLIVE},
	[MT_PITYSHROOM] = {frame = P, color = SKINCOLOR_FOREST},
	[MT_PINKSHROOM] = {frame = H, color = SKINCOLOR_NEON},
	[MT_MINISHROOM] = {frame = L, color = SKINCOLOR_COBALT},
	[MT_NEWFIREFLOWER] = {frame = I, color = SKINCOLOR_CRIMSON},
	[MT_ICYFLOWER] = {frame = K, color = SKINCOLOR_COBALT},
}

for _,tableassignpw in pairs(pwBackupSystem.assign_list) do
addHook("TouchSpecial", pwBackupSystem.assign, tableassignpw)
end

rawset(_G, "PKZ_pwBackupSystem", pwBackupSystem)
