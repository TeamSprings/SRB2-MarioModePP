--[[
		Pipe Kingdom Zone's Intermission - gui_inter.lua

Description:
Intermission stuff and stage card

Contributors: Skydusk
@Team Blue Spring 2024
]]

--
--	TITLE CARD
--

addHook("MapLoad", function()
	if not xMM_registry.replaceHud then return end
	if mariomode then
		hud.disable("stagetitle")
	else
		hud.enable("stagetitle")
	end

end)

local intro_cutscene = false
local JumpANG_first = ANG1*(180/6)
local JumpANG_second = ANG1*(180/4)

local alt_tick = 0
local alt_tick_second = 0

local function font_waving(v, x, y, scale, patch, flags, color, i)
	local y_anim = 0
	local delay_i = i << 2
	local timer_one = alt_tick+delay_i
	local timer_two = alt_tick_second+delay_i
	if timer_one < 7 and timer_one > 0 then
		y_anim = (sin(min(timer_one-5, 7)*JumpANG_first) << 3)
	end
	if timer_two < 4 and timer_two > 0 then
		y_anim = (sin(min(timer_two-4, 4)*JumpANG_second) << 1)
	end

	v.drawScaled(x, y+y_anim, scale, patch, flags, color)
end

local alt_title_tick = 0
local alt_title_tick_second = 0

local function font_wavingTitle(v, x, y, scale, patch, flags, color, i)
	local y_anim = 0
	local delay_i = i*2
	local timer_one = alt_title_tick+delay_i
	local timer_two = alt_title_tick_second+delay_i
	if timer_one < 7 and timer_one > 0 then
		y_anim = (sin(min(timer_one-5, 7)*JumpANG_first) << 4)
	end
	if timer_two < 4 and timer_two > 0 then
		y_anim = (sin(min(timer_two-4, 4)*JumpANG_second) << 2)
	end

	v.drawScaled(x, y+y_anim, scale, patch, flags, color)
end

addHook("HUD", function(v, player, ticker, endtime)
	if gamemap == 1 and pkz_first_time_prompt.value then
		if ticker < TICRATE << 1 then
			local trans = min(max(ticker - 60, 0), 9) << FF_TRANSSHIFT
			alt_tick = TICRATE - (ticker+48)
			alt_tick_second = TICRATE - (ticker+34)
			TBSlib.drawStaticTextMod(v,
				'MA14LT',
				160 << FRACBITS,
				180 << FRACBITS,
				FRACUNIT,
				"Press 'H' to access MM++",
				trans,
				v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT),
				"center",
				-2,
				font_waving
			)
		end
	end
	if mapheaderinfo[gamemap].mm_mario_hub then return end
	if mariomode and (ticker < endtime+120 or hud.mariomode.title_ticker[#player]) then
		if player.tempmariomode.cutscenetimer and mapheaderinfo[gamemap].startingcutscenenotitlecard then
			intro_cutscene = true
			return
		elseif not player.tempmariomode.cutscenetimer or mapheaderinfo[gamemap].startingcutscenenotitlecard then
			intro_cutscene = false
		end

		if ticker > TICRATE then
			v.fadeScreen(0xFF00, max(0, min(31-ticker+TICRATE, 31)))
		elseif ticker <= TICRATE then
			v.fadeScreen(0xFF00, 31)
		else
			v.fadeScreen(0xFF00, 0)
		end

		if ticker == TICRATE then
			hud.mariomode.title_ticker[#player] = 200
		end

		if ticker <= endtime+99 then
			hud.ttcardon = true
		else
			hud.ttcardon = false
		end
	end
end, "titlecard")

addHook("PlayerSpawn", function(p)
	if not mapheaderinfo[gamemap].defaultmarioname then
		p.marlevname = nil
	end

	if p.marlevnum == nil or mapheaderinfo[gamemap].worldassigned == p.marlevnum and mapheaderinfo[gamemap].defaultmarioname then
		p.marlevname = mapheaderinfo[gamemap].defaultmarioname
	end
end)

local last_hud_level_name = ""
local last_lenght_level_name = 0
local centerlize = 0


-- Title card
local function P_MarioModeTitleCard(player, v, tick, wonder)
	hud.mariomode.title_ticker[#player] = tick and $ - 1 or 0

	if tick > 30 then
		xMM_registry.hideHud = true
	end

	local gbp1 = v.cachePatch("MMTTORDW1")
	local gbp2 = v.cachePatch("MMTTORDM1")
	local gbp3 = v.cachePatch("MMTTORDW2")
	local gbp4 = v.cachePatch("MMTTORDM2")
	local marmar = v.cachePatch("MMTTORDM3")
	local gbp1_wonder = v.cachePatch("MMTTWOND1")
	local gbp2_wonder = v.cachePatch("MMTTWOND2")
	--endtime = 30*TICRATE

	local contspd = (leveltime << 1) % (gbp1.width/3)
	local marmspd = (leveltime << 1) % (marmar.width/3)
	local timerspdfront = tick >= 185 and ease.outcubic(((tick-185) << FRACBITS)/15, 0, 70) or 0
	local timerspdback = tick <= 100 and ease.outcubic(max(((tick-50) << FRACBITS)/50, 0), 150, 0) or 0

	if tick > 0 and not intro_cutscene then
		local levelname = ((player.marlevname or mapheaderinfo[gamemap].lvlttl).." ") or "No Zone"
		local prefixlvl = ""..(mapheaderinfo[gamemap].worldprefix == "W" and "w" or string.upper(""..(mapheaderinfo[gamemap].worldprefix or ""))) or ""
		local worldlvl = string.upper(""..(player.marlevnum and player.marlevnum or mapheaderinfo[gamemap].worldassigned)) or ""
		local save_data = xMM_registry.getSaveData()
		local coincount = ""..save_data.total_coins

		hud.mariomode.stagecard_ticker = hud.mariomode.stagecard_ticker and $ or {}

		if wonder then

			-- upper row of graphics
			v.draw(-gbp2.width >> 3 + contspd, gbp1.height >> 2 - timerspdback - timerspdfront, gbp2_wonder, V_SNAPTOTOP)

			-- lower row of graphics
			v.draw(gbp1.width >> 3 - contspd, 200 - gbp1.height >> 1 + timerspdback + timerspdfront, gbp1_wonder, V_SNAPTOBOTTOM)

			if tick >= 165 then
				hud.mariomode.stagecard_ticker[1] = hud.mariomode.stagecard_ticker[1] and $ + FRACUNIT/35 or 1
			end

			if tick <= 85 and tick >= 30 then
				hud.mariomode.stagecard_ticker[2] = hud.mariomode.stagecard_ticker[2] and $ + FRACUNIT/55 or 1
			end

			local tickprev = 400+ease.outback(hud.mariomode.stagecard_ticker[1] or 0, 0, -400, -10)
			local ticknext = ease.outexpo(hud.mariomode.stagecard_ticker[2] or 0, 400)
			local slow_ticknext = ease.outcubic(hud.mariomode.stagecard_ticker[2] or 0, 300)

			if last_hud_level_name ~= levelname then
				last_lenght_level_name = 0
				for i = 1, #levelname do
					last_lenght_level_name = $+TBSlib.getTextLenght(v, patch, levelname, 'MA14LT', val, 0, i)
				end
				last_lenght_level_name = $-29
				centerlize = 160-last_lenght_level_name >> 1
				last_hud_level_name = levelname
			end

			local centerlized_offset = centerlize - 16 - tickprev + ticknext
			local centerlized_rev_offset = centerlize - 16 + tickprev - ticknext
			local centerlized_actual = centerlize - tickprev + ticknext

			v.draw(centerlized_actual, 110, v.cachePatch("MMTTWOND3"))
			v.draw(centerlized_actual + last_lenght_level_name, 110, v.cachePatch("MMTTWOND5"))
			v.drawStretched(centerlized_actual*FRACUNIT, 110*FRACUNIT, last_lenght_level_name*FRACUNIT, FRACUNIT, v.cachePatch("MMTTWOND4"))
			--TBSlib.fontdrawerInt(v, 'MA14LT', centerlized_offset, 92, levelname, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 0)

			alt_title_tick = 		tick - 163
			alt_title_tick_second = tick - 156

			TBSlib.drawStaticTextMod(v,
				'MA14LT',
				centerlized_offset << FRACBITS,
				92 << FRACBITS,
				FRACUNIT,
				levelname or "0",
				0,
				v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT),
				"left",
				0,
				font_wavingTitle
			)

			TBSlib.drawTextShiftY(v, 'MA12LT', (centerlized_rev_offset + last_lenght_level_name - 12)*FRACUNIT, (113 - tickprev + slow_ticknext)*FRACUNIT, FRACUNIT, worldlvl..string.upper(prefixlvl), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, -4*FRACUNIT, 0)


			if not xMM_registry.cheatrecord then
				v.draw(centerlized_offset, 115, v.cachePatch("WONDCOIN"))

				TBSlib.drawTextInt(v, 'MA9LT', centerlized_actual, 116, coincount, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -1, 9)
			end
		else

			-- upper row of graphics
			v.draw(-gbp2.width >> 3 + contspd, gbp1.height >> 2 - timerspdback - timerspdfront, gbp2, V_SNAPTOTOP, v.getColormap(TC_DEFAULT, player.mo.color))
			v.draw(gbp4.width >> 3 - contspd, gbp1.height >> 2 - timerspdback - timerspdfront, gbp4, V_SNAPTOTOP, v.getColormap(TC_DEFAULT, player.mo.color))

			-- lower row of graphics
			v.draw(gbp1.width >> 3 - contspd, 200 - gbp1.height >> 1 + timerspdback + timerspdfront, gbp1, V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, player.mo.color))
			v.draw(-gbp3.width >> 3 + contspd, 200 - gbp3.height/3 + timerspdback + timerspdfront, gbp3, V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, player.mo.color))

			-- MARIO MODE	 MARIO MODE	   MARIO MODE
			v.draw(-marmar.width >> 2 +marmspd, marmar.height << 1 - timerspdback - timerspdfront, marmar, V_SNAPTOTOP)
			v.draw(marmar.width >> 2 -marmspd, 200 + timerspdback + timerspdfront, marmar, V_SNAPTOBOTTOM)

			if tick >= 150 then
				hud.mariomode.stagecard_ticker[1] = hud.mariomode.stagecard_ticker[1] and $ + FRACUNIT/50 or 1
			end

			if tick <= 50 and tick >= 2 then
				hud.mariomode.stagecard_ticker[2] = hud.mariomode.stagecard_ticker[2] and $ + FRACUNIT/50 or 1
			end

			local tickprev = 400+ease.outcubic(hud.mariomode.stagecard_ticker[1] or 0, -400)
			local ticknext = ease.outcubic(hud.mariomode.stagecard_ticker[2] or 0, 400)

			v.draw(253 - tickprev + ticknext, 110, v.cachePatch("MMTTMBL" + ((xMM_registry.gameFlags & GF_HARDMODE) and "H" or "")))

			TBSlib.drawTextInt(v, 'MA4LT', 160 - tickprev + ticknext, 92, levelname:upper()..prefixlvl..worldlvl, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "center", 0, 0)

			if not xMM_registry.cheatrecord then
				v.draw(130 - tickprev + ticknext, 108, v.cachePatch("TALLCOIN"))

				TBSlib.drawTextInt(v, 'MA2LT', 140 - tickprev + ticknext, 108, coincount, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 6, "0")
			end
		end

		if tick < 2 then
			hud.mariomode.stagecard_ticker = {}
		end

	end
end

addHook("HUD", function(v, player)
	hud.mplrings = player.rings
	hud.mpltime = player.realtime
	hud.timeshit = player.timeshit

	if mapheaderinfo[gamemap].mm_mario_hub then return end
	if mariomode then
		P_MarioModeTitleCard(player, v, hud.mariomode.title_ticker and hud.mariomode.title_ticker[#player] or 0, pkz_hudstyles.value == 4)
	end
end, "game")

--
--	INTERMISSION/TALLY SCREEN
--


-- setting functions:

local totalcoinnum = 0
local perfectbonus = 0

local function Y_ResetCounters()
	totalcoinnum = 0
	perfectbonus = 0
end

addHook("MapChange", Y_ResetCounters)

local function Y_GetTotalCoins(a)
	local totalrings, perfectbonus

	if (a.type == MT_RING or a.type == MT_COIN or a.type == MT_NIGHTSSTAR) then
		totalcoinnum = $ + 1
	end

	if (a.type == MT_RING_BOX) then
		totalcoinnum = $ + 10
	end

	if (a.type == MT_NIGHTSDRONE) then
		perfectbonus = -1
	end

end

addHook("MobjSpawn", Y_GetTotalCoins)
addHook("MapThingSpawn", Y_GetTotalCoins)

local function Y_GetTimeBonus(time)
	local secs = time/TICRATE
	local result

	if (secs <  30) then --[[   :30 ]] result = 50000
	elseif (secs <  60) then --[[  1:00 ]] result = 10000
	elseif (secs <  90) then --[[  1:30 ]] result = 5000
	elseif (secs < 120) then --[[  2:00 ]] result = 4000
	elseif (secs < 180) then --[[  3:00 ]] result = 3000
	elseif (secs < 240) then --[[  4:00 ]] result = 2000
	elseif (secs < 300) then --[[  5:00 ]] result = 1000
	elseif (secs < 360) then --[[  6:00 ]] result = 500
	elseif (secs < 420) then --[[  7:00 ]] result = 400
	elseif (secs < 480) then --[[  8:00 ]] result = 300
	elseif (secs < 540) then --[[  9:00 ]] result = 200
	elseif (secs < 600) then --[[ 10:00 ]] result = 100
	else  --[[ TIME TAKEN: TOO LONG ]] result = 0
	end

	return result
end

local function Y_GetGuardBonus(guardtime)
	local guardscoretype = {[0] = 10000, [1] = 5000, [2] = 1000, [3] = 500, [4] = 100}
	return (guardscoretype[guardtime] and guardscoretype[guardtime] or 0)
end

local function Y_GetRingsBonus(rings)
	return (max(0, (rings)*100))
end

local function Y_GetPerfectBonus(rings, perfectb, totrings)
	if (totrings == 0 or perfectb == -1 or rings < totrings) then
		return 0
	end

	if rings >= totrings then
		return 5000
	end
end

local debug_mp_voting = true
local MP_REHUB_VOTES = {}
local MP_PLAYERS = 0
local MP_VOTES = 0

local MP_RETURN_HUB = false

addHook("IntermissionThinker", function()
	if not mariomode then return end
	S_StopMusic(consoleplayer)

	if multiplayer or debug_mp_voting then
		if input.gameControlDown(GC_JUMP) then
			MP_REHUB_VOTES[#consoleplayer] = 1
		end

		if input.gameControlDown(GC_SPIN) then
			MP_REHUB_VOTES[#consoleplayer] = nil
		end

		return
	end
end)

-- New Intermission
addHook("HUD", function(v)
	local coincollected = false
	if not mariomode then
		hud.enable("intermissiontally")
	else

		-- set up
		hud.disable("intermissiontally")
		v.fadeScreen(0xFF00, 15)
		local totalcal = 0

		-- All variables

		local perfect = Y_GetPerfectBonus(hud.mplrings, perfectbonus, totalcoinnum)
		local rings = Y_GetRingsBonus(hud.mplrings) or 0

		if mapheaderinfo[gamemap].bonustype == 0 then
			totalcal = Y_GetTimeBonus(hud.mpltime) + rings + perfect
		elseif mapheaderinfo[gamemap].bonustype == 1 or mapheaderinfo[gamemap].bonustype == 2 then
			totalcal = Y_GetGuardBonus(hud.timeshit) + rings
		end

		local secs = hud.mpltime/TICRATE
		local time = (mapheaderinfo[gamemap].bonustype == 0 and Y_GetTimeBonus(hud.mpltime) or Y_GetGuardBonus(hud.mpltime)) or 0

		if hud.mariomode.intermission_tic == nil then
			hud.mariomode.intermission_tic = 1
			hud.skip = false
		end

		hud.mariomode.intermission_tic = (hud.mariomode.intermission_tic and $ + 1 or $)

		S_StopSoundByID(nil, sfx_chchng)
		if hud.mariomode.intermission_tic == 4 then
			S_StartSound(nil, sfx_marwoe)
			--S_StartSound(nil, sfx_martal)
		end
		-- skip
		if input.gameControlDown(GC_SPIN) and (hud.mariomode.intermission_tic >= TICRATE) then hud.skip = true end

		-- Calculations

		if (hud.mariomode.intermission_tic >= TICRATE) and (hud.totalcal ~= totalcal) and hud.skip ~= true then

			hud.ringcal = (hud.ringcal ~= nil and min(hud.ringcal+222, rings) or 0)
			hud.timecal = (hud.timecal ~= nil and min(hud.timecal+222, time) or 0)
			if hud.ringcal == rings and hud.timecal == time then
				hud.perfectcal = (hud.perfectcal ~= nil and min(hud.perfectcal+222, perfect) or 0)
			end

			hud.totalcal = (hud.totalcal ~= nil and min(hud.ringcal+hud.timecal+(hud.perfectcal or 0), totalcal) or 0)

		elseif (hud.skip == true) or (hud.totalcal and hud.totalcal+222 > totalcal) then
			hud.perfectcal = perfect
			hud.ringcal = rings
			hud.timecal = time
			hud.totalcal = totalcal

			if not (xMM_registry.cheatrecord or hud.mariomode.saved_progress) then
				local save_data = xMM_registry.getSaveData()

				save_data.total_coins = min(save_data.total_coins+hud.mplrings, 999999999)
				if save_data.lvl_data[gamemap] == nil then
					save_data.lvl_data[gamemap] = {}
				end

				save_data.lvl_data[gamemap].visited = true
				if (not save_data.lvl_data[gamemap].recordedtime) or save_data.lvl_data[gamemap].recordedtime > hud.mpltime then
					save_data.lvl_data[gamemap].recordedtime = hud.mpltime
				end
				hud.mariomode.saved_progress = true
			end
		end

		-- Drawer

		if pkz_hudstyles.value == 4 then

			local contspd = (2*hud.mariomode.intermission_tic % 200)
			v.draw(0, 0+contspd, v.cachePatch("WONDSIDEBAR1"), V_SNAPTOLEFT|V_SNAPTOTOP)
			v.draw(320, 0+contspd, v.cachePatch("WONDSIDEBAR2"), V_SNAPTORIGHT|V_SNAPTOTOP)
			v.draw(81, 101, v.cachePatch("WONDBARTALLY1"))
			v.draw(81, 126, v.cachePatch("WONDBARTALLY1"))
			v.draw(120, 150, v.cachePatch("WONDBARTALLY2"))


			--TBSlib.fontdrawerInt(v, 'MA5LT', 164, 50, string.upper(''..hud.playerskin), 0, v.getColormap(TC_DEFAULT, hud.playercolor), "center", -1, 0)

			TBSlib.drawTextModInt(v, 'MA14LT', 170, 55, "ACT CLEAR!", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT), "center", 0, 0, "0", function(v, x, y, patch, flags, color, i)
				v.draw(x, y+8*sin((hud.mariomode.intermission_tic+i*3)*ANG10)/FRACUNIT, patch, flags, color)
			end)

			TBSlib.drawTextInt(v, 'MA16LT', 192, 100, (secs or 0)+" SECS =", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTCYANFONT), "right", 0, 0)
			TBSlib.drawTextInt(v, 'MA16LT', 192, 125, (hud.mplrings)+" *100 =", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTCYANFONT), "right", 0, 0)

			TBSlib.drawTextInt(v, 'MA15LT', 200, 100, hud.timecal or 0, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 0, 0, 1)
			TBSlib.drawTextInt(v, 'MA15LT', 200, 125, hud.ringcal or 0, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 0, 0, 1)

			v.draw(77, 96, v.cachePatch("WONDCLOCK"))
			v.draw(77, 121, v.cachePatch("WONDCOIN"))

			TBSlib.drawTextInt(v, 'MA15LT', 165, 150, hud.totalcal or 0, 0, v.getColormap(TC_DEFAULT, hud.totalcal == totalcal and SKINCOLOR_MARIOPUREGOLDFONT or SKINCOLOR_MARIOPUREWHITEFONT), "center", 0, 1)
			TBSlib.drawTextInt(v, 'MA16LT', 165, 175, (perfect > 0 and "PERFECT BONUS!! 5000PTS'" or ""), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "center", 0, 0)

		else

			TBSlib.drawTextInt(v, 'MA5LT', 164, 48, string.upper(''..hud.playerskin), 0, v.getColormap(TC_DEFAULT, hud.playercolor), "center", -1, 0)

			TBSlib.drawTextInt(v, 'MA2LT', 165, 75, "ACT CLEAR!", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)

			TBSlib.drawTextInt(v, 'MA2LT', 192, 100, (secs or 0)+" SECS =", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "right", 0, 0)
			TBSlib.drawTextInt(v, 'MA2LT', 192, 125, (hud.mplrings)+" *100 =", 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "right", 0, 0)

			TBSlib.drawTextInt(v, 'MA2LT', 200, 100, hud.timecal or 0, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), 0, 0, 1)
			TBSlib.drawTextInt(v, 'MA2LT', 200, 125, hud.ringcal or 0, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), 0, 0, 1)

			v.draw(72, 100, v.cachePatch("TALLTIME"))
			v.draw(72, 125, v.cachePatch("TALLCOIN"))

			TBSlib.drawTextInt(v, 'MA2LT', 165, 150, hud.totalcal or 0, 0, v.getColormap(TC_DEFAULT, hud.totalcal == totalcal and SKINCOLOR_YELLOW or SKINCOLOR_WHITE), "center", 0, 1)
			TBSlib.drawTextInt(v, 'MA2LT', 165, 175, (perfect > 0 and "PERFECT BONUS!! 5000PTS'" or ""), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)

		end

		if multiplayer or debug_mp_voting then
			MP_VOTES = 0
			MP_PLAYERS = 0

			for p in players.iterate do
				if p.bot then continue end
				MP_PLAYERS = $+1
				if MP_REHUB_VOTES[#p] then
					MP_VOTES = $+1
				end
			end

			TBSlib.drawStaticTextUnadjusted(v, 'MA2LT', 240 << FRACBITS, 165 << FRACBITS, FRACUNIT >> 1, "RETURN TO HUB", V_SNAPTORIGHT|V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0)
			TBSlib.drawTextInt(v, 'MA2LT', 240, 170, MP_VOTES.."/"..MP_PLAYERS, V_SNAPTORIGHT|V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, #MP_REHUB_VOTES == p_amount and SKINCOLOR_YELLOW or SKINCOLOR_WHITE), "right", 0, 1)
			v.draw(240, 170, v.cachePatch("MARIOHUBRETURN0"), V_SNAPTORIGHT|V_SNAPTOBOTTOM)
			if MP_REHUB_VOTES[#consoleplayer] then
				v.draw(240, 170, v.cachePatch("MARIOHUBRETURN1"), V_SNAPTORIGHT|V_SNAPTOBOTTOM)
			end
		end

		if (hud.totalcal and hud.totalcal == totalcal) and MP_VOTES >= MP_PLAYERS then
			MP_RETURN_HUB = true
		end
	end
end, "intermission")

local BLACKSCREEN_UNTIL_HUB = false

addHook("GameQuit", function(quit)
	if not quit then
		BLACKSCREEN_UNTIL_HUB = false
		MP_RETURN_HUB = false
		MP_VOTES = 0
	end
end)

addHook("PlayerThink", function()
	if leveltime and MP_RETURN_HUB then
		MP_RETURN_HUB = false
		BLACKSCREEN_UNTIL_HUB = true
		--print("HAHA")

		G_SetCustomExitVars(xMM_registry.hub_warp, 2)
		G_ExitLevel()
	end
end)

addHook("MapLoad", function()
	BLACKSCREEN_UNTIL_HUB = false
	MP_REHUB_VOTES = {}
	MP_PLAYERS = 0
	MP_VOTES = 0

	hud.mariomode.intermission_tic = nil
	hud.mariomode.saved_progress = nil
end)

addHook("HUD", function(v)
	if MP_RETURN_HUB or BLACKSCREEN_UNTIL_HUB then
		v.fadeScreen(0xFF00, 15)
	else
		v.fadeScreen(0xFF00, 0)
	end
end, "game")

-- Just small addition to pause screen for no reason
addHook("HUD", function(v)
	if (MP_RETURN_HUB or BLACKSCREEN_UNTIL_HUB) then
		v.fadeScreen(0xFF00, 31)
	elseif (mariomode and paused) then
		v.fadeScreen(0xFF00, 15)
	else
		v.fadeScreen(0xFF00, 0)
	end
end, "game")

--[[
// custom mario titlescreen inspired by SMB1, uncomment it... if you feel like having it.
//
//addHook("HUD", function(v, player, ticker, endtime)
//	if not mariomode
//		hud.enable("stagetitle")
//		else
//		hud.disable("stagetitle")
//		hud.toffset = 0
//		if ticker < 1*TICRATE
//		v.fadeScreen(0xFF00, 32)
//		end
//
//		local world = mapheaderinfo[gamemap].worldassigned
//		if world == nil
//		return
//		end
//		if ticker < 2*TICRATE
//			local lifeicon = v.getSprite2Patch(hud.playerskin, SPR2_XTRA, false, C, 0)
//			v.drawString(120, 75, world)
//			if player.lives ~= INFLIVES
//			v.drawString(181, 115, hud.playerlives)
//			else
//			v.drawString(181, 115, "oo")
//			end
//			v.drawString(145, 115, "x")
//			v.draw(131, 130, lifeicon)
//		end
//
//		if ticker > 10/3*TICRATE and ticker < 4*TICRATE
//		v.fadeScreen(0xFF00, 0)
//		end
//
//		endtime = (4*TICRATE)+1
//	end
//end, "titlecard")

//addHook("HUD", function(v, player, ticker, endtime)
//	if not mariomode then return end
//		hud.disable("stagetitle")
//		hud.toffset = 0
//		local levelfade = 0
//		endtime = 9*TICRATE

//		if ticker ~= endtime


//		if (ticker*TICRATE < NUMTRANSMAPS) and ticker > TICRATE
//		levelfade = (NUMTRANSMAPS - ticker/2) << V_ALPHASHIFT
//		end

//		if (ticker-3*TICRATE < NUMTRANSMAPS)
//		levelfade = (NUMTRANSMAPS + ticker/8) << V_ALPHASHIFT
//		end

//		if ticker < 4*TICRATE
//		v.draw(235, 115, v.cachePatch("LTACTM"), V_PERPLAYER|levelfade)
//		end

//		if ticker < 4*TICRATE and ticker < 5*TICRATE
//		v.fadeScreen(0xFF00, levelfade)
//		end
//
//		end
//
//end, "titlecard")
]]