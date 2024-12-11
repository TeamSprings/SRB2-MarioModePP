--[[
		Pipe Kingdom Zone's GUI Hud - gui_hud.lua

Description:
Gameplay Hud Logic

Contributors: Skydusk, Clone Fighter
@Team Blue Spring 2024

Contains:

Emblem Tracker, edited into Dragon Coin & Emblem Tracker
Original for 2.3 Vanilla by Tatsuru, Recreated by Radicalicious, Edited by Skydusk
--]]

local xdoffset = 0
local livx = hudinfo[HUD_LIVES].x
local timx = hudinfo[HUD_TIME].x
local minutesx = hudinfo[HUD_MINUTES].x
local timecolonx = hudinfo[HUD_TIMECOLON].x
local secondx = hudinfo[HUD_SECONDS].x
local ticsx = hudinfo[HUD_TICS].x
local timeticcolonx = hudinfo[HUD_TIMETICCOLON].x
local ringx = hudinfo[HUD_RINGS].x
local ringnumx = hudinfo[HUD_RINGSNUM].x
local ringnumticsx = hudinfo[HUD_RINGSNUMTICS].x
local scorex = hudinfo[HUD_SCORE].x
local scorenumx = hudinfo[HUD_SCORENUM].x
local offset = 1075
local newx = 14*FRACUNIT
local modern_yshift = -FRACUNIT/2
local modern_scaleH = FRACUNIT
local modern_scaleN = FRACUNIT/2
local modern_scaleItem = FRACUNIT/3
local modern_dgcoinAnim = {}
local modern_dgcoinShow = 0

--Add those damn dragon coins into table, damn it.
addHook("PlayerSpawn", function(player)
	xMM_registry.curlvl.mobj_scoins = {}
	xMM_registry.curlvl.mobj_smoons = {}
	modern_dgcoinAnim = {}

	player.yesdc1up = nil

	if xMM_registry.levellist[gamemap] and xMM_registry.levellist[gamemap].new_coin then
		xMM_registry.curlvl.new_coin = xMM_registry.levellist[gamemap].new_coin
	else
		xMM_registry.curlvl.new_coin = 0
	end

	for thing in mobjs.iterate() do
		if thing.type == MT_DRAGONCOIN then
			table.insert(xMM_registry.curlvl.mobj_scoins, thing)
			table.insert(modern_dgcoinAnim, -1)
		end

		if thing.type == MT_MARPOWERMOON then
			table.insert(xMM_registry.curlvl.mobj_smoons, thing)
		end
	end
	table.sort(xMM_registry.curlvl.mobj_scoins, function(a, b) return a.dragtag > b.dragtag end)
end)

local ITEMHOLDSICON, ITEMHOLDSICON_WOND
local ITEMHOLDER, ITEMHOLDERHARD
local ITEMSHOLDER, ITEMHOLDERSHARD
local SMWITEMHOLD, SMWITEMBG, SMWITEMBUT
local SMWITEMHOLDHUB, SMWITEMBGHUB

--Item Holder Drawer Hud
addHook("HUD", function(v, stplyr)
	if not (mariomode and stplyr.mo and stplyr.mo.valid) then return end
	local prefix = mapheaderinfo[gamemap].worldprefix
	local cstate = PKZ_pwBackupSystem.drawer_data

	if stplyr.mariomode.sidepowerup then
		PKZ_pwBackupSystem.drawerAnim()
	end

	if not ITEMHOLDSICON then
		ITEMHOLDSICON_WOND = TBSlib.registerPatchRange(v, "SMWONITHANIM", 0, 21)
		ITEMHOLDSICON = TBSlib.registerPatchRange(v, "ITEMHOLDSICON", 1, 12)
		ITEMHOLDERHARD = v.cachePatch("ITEMHOLDSH")
		ITEMHOLDER = v.cachePatch("ITEMHOLDS")
		ITEMHOLDERSHARD = v.cachePatch("ITEMHOLDERH")
		ITEMSHOLDER = v.cachePatch("ITEMHOLDER")
		SMWITEMHOLDHUB = v.cachePatch("SMWONITEMHOLDHUB")
		SMWITEMBGHUB = v.cachePatch("SMWONDITEMBGHUB")
		SMWITEMHOLD = v.cachePatch("SMWONITEMHOLD")
		SMWITEMBG = v.cachePatch("SMWONDITEMBG")

		SMWITEMBUT = v.cachePatch("SMWONITEMHOLDBT")
	end

	if pkz_hudstyles.value ~= 4 then
		local x,y, patch, right = 229-xdoffset,10, ((xMM_registry.gameFlags & GF_HARDMODE) and ITEMHOLDERSHARD or ITEMSHOLDER), V_SNAPTORIGHT|V_SNAPTOTOP
		local flag_x_offset = 0
		if pkz_hudstyles.value ~= 0 then
			patch = (xMM_registry.gameFlags & GF_HARDMODE) and ITEMHOLDERHARD or ITEMHOLDER

			if pkz_hudstyles.value == 1 then
				x,y = 279-xdoffset,20
			elseif pkz_hudstyles.value == 2 then
				x,y, right = 141-xdoffset,6, V_SNAPTOTOP
			elseif pkz_hudstyles.value == 3 then
				x,y = 15+xdoffset,160
				right = V_SNAPTOLEFT|V_SNAPTOBOTTOM
			end
		else
			flag_x_offset = 22
		end
		v.draw(x,y, patch, V_PERPLAYER|V_HUDTRANS|right)
		v.drawStretched(((pkz_hudstyles.value == 0) and x+64+cstate.offset_x or x+16+cstate.offset_x) << FRACBITS, (y+25+cstate.offset_y) << FRACBITS, (3<<FRACBITS>>2+cstate.offscale_x), (3<<FRACBITS>>2+cstate.offscale_y),
		(stplyr.mariomode.sidepowerup and v.getSpritePatch(states[mobjinfo[stplyr.mariomode.sidepowerup].spawnstate].sprite, A, 0) or v.cachePatch("MA2LTNONE")),
		V_PERPLAYER|V_HUDTRANS|right)
		if not stplyr.mo.mario_camera then
			v.draw(x+flag_x_offset,y, TBSlib.pickPatchRange(v, ITEMHOLDSICON, 1, stplyr.mariomode.backup_pentup >> 1), V_PERPLAYER|V_HUDTRANS|right)
		end
	else
		local scr_scale = v.dupx()
		local left_side = -((v.width()/scr_scale-320) >> 1)
		local top_side = -((v.height()/scr_scale-200) >> 1)
		local smwh_x, smwh_y, smwh_scale = 16 << FRACBITS, (56+xdoffset) << FRACBITS, FRACUNIT >> 1
		v.drawScaled(smwh_x, smwh_y, smwh_scale, stplyr.mo.mario_camera and SMWITEMHOLDHUB or SMWITEMHOLD, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANSHALF)
		v.drawStretched((28+cstate.offset_x) << FRACBITS, (74+xdoffset+cstate.offset_y) << FRACBITS + FRACUNIT >> 1, FRACUNIT >> 1 + cstate.offscale_x, FRACUNIT >> 1 + cstate.offscale_y,
		(stplyr.mariomode.sidepowerup and v.getSpritePatch(states[mobjinfo[stplyr.mariomode.sidepowerup].spawnstate].sprite, A, 0) or v.cachePatch("MA2LTNONE")),
		V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)

		if not stplyr.mo.mario_camera then
			v.drawScaled(smwh_x, smwh_y, smwh_scale, SMWITEMBG, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)

			--TBS_Polygon.drawPolygon(v, left_side+28, top_side+xdoffset+68, TBS_Polygon.progressLine(wonder_windup_poly, (stplyr.backup_pentup << FRACBITS)/24), 37, 2, false)
			if stplyr.mariomode.backup_pentup then
				v.drawScaled(smwh_x, smwh_y, smwh_scale, TBSlib.pickPatchRange(v, ITEMHOLDSICON_WOND, 0, stplyr.mariomode.backup_pentup), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
			end


			v.drawScaled(smwh_x, smwh_y, smwh_scale, SMWITEMBUT, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		else
			v.drawScaled(smwh_x, smwh_y, smwh_scale, SMWITEMBGHUB, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		end
	end

	--v.draw(242, 12, v.cachePatch("WORLD11"), V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS)
	if pkz_hudstyles.value == 0 then
		TBSlib.drawTextInt(v, 'MA3LT', 253-xdoffset, 12, (stplyr.marlevnum and prefix..' '..stplyr.marlevnum or prefix..' '..mapheaderinfo[gamemap].worldassigned) or "W 1-1", V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, SKINCOLOR_SAPPHIRE), "center", 0, 0)
	elseif pkz_hudstyles.value == 2 then
		TBSlib.drawText(v, 'MA2LT', (103+xdoffset) << FRACBITS - FRACUNIT >> 1, 14 << FRACBITS, FRACUNIT,
		(stplyr.marlevnum and string.lower(prefix..''..stplyr.marlevnum) or string.lower(prefix..''..mapheaderinfo[gamemap].worldassigned)) or "w1-1",
		V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD), "center", 0, 0)
	end

end, "game")

local SRB2_DGCOIN_UNCOLLECTED, SRB2_DGCOIN_COLORED, SRB2_DGCOIN_COLLECTED
local SMM_DGCOIN_UNCOLLECTED, SMM_DGCOIN_COLORED, SMM_DGCOIN_COLLECTED, SMM_BRACKET
local SMW_DGCOIN_UNCOLLECTED, SMW_DGCOIN_COLORED, SMW_DGCOIN_COLLECTED

local modern_coin_counteroffset = 200
local modern_coin_moveout = FRACUNIT/5
local modern_coin_movein = FRACUNIT-modern_coin_moveout
local modern_coin_speed = FRACUNIT/72

local function clampTimer(min_, x, max_)
	return abs(max(min(x, max_), min_) - min_) * FRACUNIT / (max_ - min_)
end

--Dragon Coins
addHook("HUD", function(d, p)
	if not mariomode or splitscreen then return end -- I dunno why this was in the iterator instead of here
	local dragoncoinlist = xMM_registry.curlvl.mobj_scoins

	if not SRB2_DGCOIN_UNCOLLECTED then
		SRB2_DGCOIN_UNCOLLECTED = d.cachePatch("YOSHCB")
		SRB2_DGCOIN_COLLECTED = d.cachePatch("YOSHCO")
		SRB2_DGCOIN_COLORED = d.cachePatch("YOSHCD")

		SMM_DGCOIN_UNCOLLECTED = d.cachePatch("SMMDCOI")
		SMM_DGCOIN_COLLECTED = d.cachePatch("SMMDCOI")
		SMM_DGCOIN_COLORED = d.cachePatch("SMMDCBL")
		SMM_BRACKET = d.cachePatch("SMMBRACK")

		SMW_DGCOIN_UNCOLLECTED = d.cachePatch("MA2LTNONE")
		SMW_DGCOIN_COLLECTED = d.cachePatch("SMWDCOI")
		SMW_DGCOIN_COLORED = d.cachePatch("SMWDCBL")
	end

	if pkz_hudstyles.value == 0 then -- SRB2... Oh boy.
		local loffset = offset

		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw((loffset >> 2 + (SRB2_DGCOIN_COLLECTED.width >> 6) - xdoffset), 22, SRB2_DGCOIN_COLLECTED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid then
				d.draw((loffset >> 2 + (SRB2_DGCOIN_COLORED.width >> 6) - xdoffset), 22, SRB2_DGCOIN_COLORED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			else
				d.draw((loffset >> 2 + (SRB2_DGCOIN_UNCOLLECTED.width >> 6) - xdoffset), 22, SRB2_DGCOIN_UNCOLLECTED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
			loffset = $ - 36
		end

	elseif pkz_hudstyles.value == 1 then -- Super Mario Maker
		d.draw(269 - xdoffset, 20, SMM_BRACKET, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP)

		local i = 0
		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, SMM_DGCOIN_COLLECTED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid then
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, SMM_DGCOIN_COLORED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			else
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, SMM_DGCOIN_UNCOLLECTED, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
			i = embnum-1
		end

		d.draw(260 - (i*10)-2 - xdoffset, 20, SMM_BRACKET, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_FLIP)

	elseif pkz_hudstyles.value == 2 then -- Super Mario World

		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, SMW_DGCOIN_COLLECTED, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid then
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, SMW_DGCOIN_COLORED, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			else
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, SMW_DGCOIN_UNCOLLECTED, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
		end
	elseif pkz_hudstyles.value == 4 then -- Modern
		local count = #dragoncoinlist
		if count < 1 then return end

		local t = (clampTimer(0, modern_dgcoinShow, modern_coin_moveout) - clampTimer(modern_coin_movein, modern_dgcoinShow, FRACUNIT))

		modern_coin_counteroffset = ease.outsine(t, 200, 0)
		local lenght = count * 20
		local start_x = 290 - lenght
		local typeofcoin = "WONDER"..(xMM_registry.curlvl.new_coin).."COIN"
		local empty = typeofcoin..'0'

		if modern_dgcoinShow > 0 then
			xMM_registry.drawWonderTextBox(d, start_x - 15 - xdoffset + modern_coin_counteroffset, 36, lenght + 30, 35, 31|V_SNAPTORIGHT|V_SNAPTOTOP|V_50TRANS)

			modern_dgcoinShow = $-modern_coin_speed

			if modern_dgcoinShow < 0 then
				modern_dgcoinShow = 0
			end
		end

		if input.gameControlDown(GC_SCORES) or input.gameControl2Down(GC_SCORES) then
			if modern_dgcoinShow < modern_coin_movein and modern_dgcoinShow > modern_coin_moveout then
				modern_dgcoinShow = modern_coin_movein - 1
			elseif modern_dgcoinShow < modern_coin_moveout then
				modern_dgcoinShow = FRACUNIT - modern_dgcoinShow
			elseif modern_dgcoinShow <= 0 then
				modern_dgcoinShow = FRACUNIT
			end
		end

		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				if modern_dgcoinAnim[embnum] < 0 then
					modern_dgcoinAnim[embnum] = 64

					if modern_dgcoinShow < modern_coin_movein and modern_dgcoinShow > modern_coin_moveout then
						modern_dgcoinShow = modern_coin_movein - 1
					elseif modern_dgcoinShow < modern_coin_moveout then
						modern_dgcoinShow = FRACUNIT - modern_dgcoinShow
					elseif modern_dgcoinShow <= 0 then
						modern_dgcoinShow = FRACUNIT
					end
				elseif modern_dgcoinAnim[embnum] > 0
				and modern_dgcoinShow < modern_coin_movein and modern_dgcoinShow > modern_coin_moveout then
					if modern_dgcoinAnim[embnum] > 48 then
						modern_dgcoinAnim[embnum] = $-4
					elseif modern_dgcoinAnim[embnum] > 24 then
						modern_dgcoinAnim[embnum] = $-2
					else
						modern_dgcoinAnim[embnum] = $-1
					end

					if modern_dgcoinAnim[embnum] < 0 then
						modern_dgcoinAnim[embnum] = 0
					end
				elseif modern_dgcoinShow == 0 then
					modern_dgcoinAnim[embnum] = 0
				end

				local frame = typeofcoin..(modern_dgcoinAnim[embnum] > 0 and ((modern_dgcoinAnim[embnum] % 8) + 1) or 1)
				if modern_dgcoinAnim[embnum] > 30 then
					frame = typeofcoin..'0'
				end

				if modern_dgcoinShow > 0 then
					d.draw(start_x + ((embnum-1)*20) - xdoffset + modern_coin_counteroffset, 44, d.cachePatch(frame), V_SNAPTOTOP|V_SNAPTORIGHT|V_HUDTRANS|V_PERPLAYER)
				end
			else
				if modern_dgcoinShow > 0 then
					d.draw(start_x + ((embnum-1)*20) - xdoffset + modern_coin_counteroffset, 44, d.cachePatch(empty), V_SNAPTOTOP|V_SNAPTORIGHT|V_HUDTRANS|V_PERPLAYER)
				end
			end
		end
	end

end, "game")

local life_xyz = {{1,0},{0,1},{-1,0},{0,-1}}
hud.pkz_registeredlives = 0
hud.pkz_registeredcoins = 0

-- Swap Ring Counter with Coins in SRB2 HUD
-- All other Hud Styles.
local function V_DrawMarioModeHud(v, player)
	hud.playercoins = player.rings
	hud.playerlives = player.lives
	hud.playerskin = player.mo and player.mo.skin or SKINCOLOR_NONE
	hud.playercolor = player.skincolor
	hud.playeroppositecolor = ColorOpposite(player.skincolor or 1)
	hud.skip = false

	local save_data = xMM_registry.getSaveData()
	local total_c = save_data.coins

	if xMM_registry.hideHud then
		xdoffset = xdoffset >= -350 and $-10 or -350
		xMM_registry.hideHud = false
	else
		xdoffset = xdoffset < 0 and $+10 or 0
	end

	if xdoffset then
		hudinfo[HUD_LIVES].x = livx + xdoffset
		hudinfo[HUD_TIME].x = timx + xdoffset
		hudinfo[HUD_MINUTES].x = minutesx + xdoffset
		hudinfo[HUD_TIMECOLON].x = timecolonx + xdoffset
		hudinfo[HUD_SECONDS].x = secondx + xdoffset
		hudinfo[HUD_TICS].x = ticsx + xdoffset
		hudinfo[HUD_TIMETICCOLON].x = timeticcolonx + xdoffset
		hudinfo[HUD_RINGS].x = ringx + xdoffset
		hudinfo[HUD_RINGSNUM].x = ringnumx + xdoffset
		hudinfo[HUD_RINGSNUMTICS].x = ringnumticsx + xdoffset
		hudinfo[HUD_SCORE].x = scorex + xdoffset
		hudinfo[HUD_SCORENUM].x = scorenumx	+ xdoffset
	elseif hudinfo[HUD_LIVES].x ~= livx then
		hudinfo[HUD_LIVES].x = livx
		hudinfo[HUD_TIME].x = timx
		hudinfo[HUD_MINUTES].x = minutesx
		hudinfo[HUD_TIMECOLON].x = timecolonx
		hudinfo[HUD_SECONDS].x = secondx
		hudinfo[HUD_TICS].x = ticsx
		hudinfo[HUD_TIMETICCOLON].x = timeticcolonx
		hudinfo[HUD_RINGS].x = ringx
		hudinfo[HUD_RINGSNUM].x = ringnumx
		hudinfo[HUD_RINGSNUMTICS].x = ringnumticsx
		hudinfo[HUD_SCORE].x = scorex
		hudinfo[HUD_SCORENUM].x = scorenumx
	end

	if not mariomode and not mapheaderinfo[gamemap].mariohubhud then
		hud.enable("rings")
		hud.enable("time")
 		hud.enable("score")
		hud.enable("lives")
		hud.enable("weaponrings")
	elseif mapheaderinfo[gamemap].mariohubhud then
		if pkz_hudstyles.value == 4 then -- Modern
			local no_coins = v.cachePatch("SMWONCOIN")
			local dg_coins = v.cachePatch("SMWONDBCOIN")

			v.drawScaled(15 << FRACBITS, (17+xdoffset)*modern_scaleN, modern_scaleN, no_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
			TBSlib.drawTextShiftY(v, 'MA13LT', newx, (7+xdoffset) << FRACBITS, modern_scaleN, save_data.total_coins,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 9, ";")

			v.drawScaled(15 << FRACBITS, (67+xdoffset)*modern_scaleN, modern_scaleN, dg_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
			TBSlib.drawTextShiftY(v, 'MA13LT', newx, (19+xdoffset) << FRACBITS, modern_scaleN, #total_c,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")
		else
			v.draw(hudinfo[HUD_SCORE].x+xdoffset, hudinfo[HUD_SCORE].y, v.cachePatch("SCTRUMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			TBSlib.drawTextInt(v, 'STTNUM', (hudinfo[HUD_SCORENUM].x+72+xdoffset), (hudinfo[HUD_SCORENUM].y), save_data.total_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, 0), "right", 0, 6)

			v.draw(hudinfo[HUD_TIME].x+xdoffset, hudinfo[HUD_TIME].y, v.cachePatch("HTDCOSMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			v.drawNum(hudinfo[HUD_SECONDS].x+56+xdoffset, hudinfo[HUD_SECONDS].y, #total_c, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
		end

		hud.disable("rings")
		hud.disable("time")
		hud.disable("score")
		hud.disable("lives")

	else
		if xMM_registry.replaceHud then
			if pkz_hudstyles.value == 0 then -- SRB2-style, default
				hud.disable("rings")
				hud.enable("time")
				hud.enable("score")
				hud.enable("lives")
				v.drawNum(hudinfo[HUD_RINGSNUM].x, hudinfo[HUD_RINGSNUM].y, player.rings, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
				v.draw(hudinfo[HUD_RINGS].x, hudinfo[HUD_RINGS].y, (player.rings ~= 0 and v.cachePatch("HCOINSMAR") or ((10 & leveltime)/5 and v.cachePatch("HCOINSMAR") or v.cachePatch("HRCOINMAR"))), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER) -- jeezus Dave, you can break up function arguments, y'know

			else
				hud.disable("rings")
				hud.disable("time")
				hud.disable("score")
				hud.disable("lives")

				if pkz_hudstyles.value == 1 then -- Super Mario Maker
					local life = v.getSprite2Patch(player.mo.skin, SPR2_LIFE)
					local clock = v.cachePatch("SMMCLOCK")
					local coins = v.cachePatch("SMMCOINS")

					local lives = (player.playerstate == PST_DEAD and (player.lives <= 0 and player.deadtimer < 2*TICRATE or player.lives > 0)) and player.lives + 1 or player.lives
					lives = $ > 9 and $ or "0"..$
					local coin = player.rings > 99 and player.rings or (player.rings > 9 and "0"..player.rings or "00"..player.rings)
					local minutes = G_TicsToMinutes(player.realtime, true)
					local seconds = G_TicsToSeconds(player.realtime)
					minutes = ($ < 10 and '0'..$ or $)
					seconds = ($ < 10 and '0'..$ or $)

					v.draw(3+life.leftoffset+xdoffset, 2+life.topoffset, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS|V_FLIP, v.getColormap(player.mo.skin, player.mo.color, player.mo.translation))
					TBSlib.drawTextInt(v, 'MA2LT', 20+xdoffset, 8, "\042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")

					v.draw(6+xdoffset, 22, coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextInt(v, 'MA2LT', 20+xdoffset, 24, "\042"..coin,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")

					TBSlib.drawTextInt(v, 'MA2LT', 174-xdoffset, 6, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left", 0, 8, "0")

					v.draw(255-xdoffset, 3, clock, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextInt(v, 'MA2LT', 271-xdoffset, 6, minutes..":"..seconds,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")

				elseif pkz_hudstyles.value == 2 then -- Super Mario World
					local time = v.cachePatch("SMWTIME")
					local coins = v.cachePatch("SMWCOINS")

					local lives = (player.playerstate == PST_DEAD and (player.lives <= 0 and player.deadtimer < 2*TICRATE or player.lives > 0)) and player.lives + 1 or player.lives
					lives = $ > 9 and $ or "0"..$
					local coin = player.rings > 99 and player.rings or (player.rings > 9 and " "..player.rings or " 0"..player.rings)
					local minutes = G_TicsToMinutes(player.realtime, true)
					local seconds = G_TicsToSeconds(player.realtime)
					minutes = ($ < 10 and '0'..$ or $)
					seconds = ($ < 10 and '0'..$ or $)

					TBSlib.drawText(v, 'MA5LT', (35+xdoffset) << FRACBITS - FRACUNIT >> 1, 15 << FRACBITS, FRACUNIT,
					string.upper(''..skins[player.mo.skin].hudname), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, player.skincolor, player.mo.translation), "center")
					TBSlib.drawTextInt(v, 'MA2LT', 23+xdoffset, 23, "\042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")

					v.draw(267-xdoffset, 15, coins, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextInt(v, 'MA2LT', 276-xdoffset, 15, "\042"..coin,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")

					TBSlib.drawTextInt(v, 'MA2LT', 244-xdoffset, 23, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left", 0, 8, "0")

					v.draw(197+xdoffset, 15, time, V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD))
					TBSlib.drawText(v, 'MA2LT', (209+xdoffset) << FRACBITS - FRACUNIT >> 1, 23 << FRACBITS, FRACUNIT, minutes..":"..seconds,
					V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD), "center")

				elseif pkz_hudstyles.value == 3 then -- Super Mario 64
					local coins, dc = v.cachePatch("SM64COIA"), v.cachePatch("SM64COIB")
					local life = v.getSprite2Patch(player.mo.skin, SPR2_LIFE)
					local minutes = G_TicsToMinutes(player.realtime, true)
					local seconds = G_TicsToSeconds(player.realtime)
					local lives = (player.playerstate == PST_DEAD and (player.lives <= 0 and player.deadtimer < 2*TICRATE or player.lives > 0)) and player.lives + 1 or player.lives
					seconds = ($ < 10 and '0'..$ or $)
					local cent = G_TicsToCentiseconds(player.realtime)/10

					TBSlib.drawTextInt(v, 'MA6LT', 29+xdoffset, 7, " \042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)

					v.draw(21+life.leftoffset+xdoffset, 6+life.topoffset, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(player.mo.skin, player.mo.color, player.mo.translation))

					v.draw(168-xdoffset, 7, coins, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextInt(v, 'MA6LT', 185-xdoffset, 7, "\042"..min(player.rings, 999),
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)

					v.draw(244-xdoffset, 7, dc, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextInt(v, 'MA6LT', 261-xdoffset, 7, "\042"..#total_c,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)

					TBSlib.drawTextInt(v, 'MA6LT', 298-xdoffset, 31, "TIME "..minutes.."\039"..seconds.."\034"..cent,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "right", -2)
				elseif pkz_hudstyles.value == 4 then -- Modern
					local coins = v.cachePatch("SMWONCOIN")
					local life = v.getSprite2Patch(player.mo.skin, SPR2_LIFE)
					local minutes = G_TicsToMinutes(player.realtime, true)
					local seconds = G_TicsToSeconds(player.realtime)
					local lives = (player.playerstate == PST_DEAD and (player.lives <= 0 and player.deadtimer < 2*TICRATE or player.lives > 0)) and player.lives + 1 or player.lives
					local cent = G_TicsToCentiseconds(player.realtime)/10

					minutes = ($ < 10 and '0'..$ or $)
					seconds = ($ < 10 and '0'..$ or $)
					cent = ($ < 10 and '0'..$ or $)
					--TBSlib.fontdrawershifty(d, font, x, y, scale, value, flags, color, alligment, padding, shifty, leftadd, symbol)
					if not hud.wonder_hud_timer then
						hud.wonder_hud_timer = {}
						hud.wonder_hud_timer.coinst = 0
						hud.wonder_hud_timer.livest = 0
						hud.wonder_hud_timer.coins = 0
						hud.wonder_hud_timer.lives = 0
					end

					if hud.wonder_hud_timer.coins ~= player.rings then
						hud.wonder_hud_timer.coinst = 4
					end

					if hud.wonder_hud_timer.lives ~= player.lives then
						hud.wonder_hud_timer.livest = 4
					end

					local is_cointimer_active = (hud.wonder_hud_timer.coinst > 0)
					local is_livestimer_active = (hud.wonder_hud_timer.livest > 0)

					local coins_counter_y = (7+xdoffset) << FRACBITS +(is_cointimer_active and (hud.wonder_hud_timer.coinst > 2 and
					ease.inoutquart(((hud.wonder_hud_timer.coinst-2) << FRACBITS) >> 2, FRACUNIT, 0) or ease.inoutquart(((hud.wonder_hud_timer.coinst) << FRACUNIT) >> 2, 0, FRACUNIT)) or 0)
					local lives_counter_y = (19+xdoffset) << FRACBITS +(is_livestimer_active and (hud.wonder_hud_timer.livest > 2 and
					ease.inoutquart(((hud.wonder_hud_timer.livest-2) << FRACBITS) >> 2, FRACUNIT, 0) or ease.inoutquart(((hud.wonder_hud_timer.livest) << FRACUNIT) >> 2, 0, FRACUNIT)) or 0)

					hud.wonder_hud_timer.coinst = is_cointimer_active and $-1 or 0
					hud.wonder_hud_timer.livest = is_livestimer_active and $-1 or 0

					v.drawScaled(15 << FRACBITS, (17+xdoffset)*modern_scaleN, modern_scaleN, coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.drawTextShiftY(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")

					if player.rings <= 0 and not xdoffset then
						local blinking = ease.outsine(abs(((leveltime << FRACBITS /11) % (FRACUNIT << 1))+1-FRACUNIT), 0, 9) << V_ALPHASHIFT
						TBSlib.drawTextShiftY(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREREDFONT), "left", -2, modern_yshift, 2, "0")
					end

					if is_cointimer_active and not xdoffset then
						local blinking = ease.outsine((hud.wonder_hud_timer.coinst << FRACBITS) >> 2, 9, 1) << V_ALPHASHIFT
						TBSlib.drawTextShiftY(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT), "left", -2, modern_yshift, 2, "0")
					end

					local custom_life_patch = "WONDERLIFEICON_"..string.upper(skins[player.skin].name or "")

					if v.patchExists(custom_life_patch) then
						v.drawScaled(15 << FRACBITS, (67+xdoffset)*modern_scaleN, modern_scaleN, v.cachePatch(custom_life_patch), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(player.mo.skin, player.mo.color, player.mo.translation))
					else
						local life_x = 17+life.leftoffset
						local life_y = 32+life.topoffset+xdoffset

						for i = 1,4 do
							v.draw(life_x+life_xyz[i][1], life_y+life_xyz[i][2], life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
						end
						v.draw(life_x, life_y, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(player.mo.skin, player.mo.color))
					end

					TBSlib.drawTextShiftY(v, 'MA13LT', newx, lives_counter_y, modern_scaleN, lives,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")

					if is_livestimer_active and not xdoffset then
						local blinking = ease.outsine((hud.wonder_hud_timer.livest << FRACUNIT) >> 2, 9, 1) << V_ALPHASHIFT
						TBSlib.drawTextShiftY(v, 'MA13LT', newx, lives_counter_y, modern_scaleN, lives,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGREENFONT), "left", -2, modern_yshift, 2, "0")
					end

					TBSlib.drawText(v, 'MA9LT', 610 << FRACBITS, (28+xdoffset) << FRACBITS, FRACUNIT >> 1, minutes..":"..seconds..":"..cent,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "right", -2)
					TBSlib.drawText(v, 'MA10LT', 610 << FRACBITS, (42+xdoffset) << FRACBITS, FRACUNIT >> 1, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "right", -2, 8, "0")

					hud.wonder_hud_timer.coins = player.rings
					hud.wonder_hud_timer.lives = lives


					--if G_RingSlingerGametype() then
					--	v.drawString(160, 180, "Drop of items", 0, "center")
					--	v.drawString(160, 190, "128", 0, "center")
					--	hud.disable("weaponrings")
					--end

				end
			end
		end
	end

	if hud.mariomode.levelentry ~= nil then
		local radius = ease.outsine(FRACUNIT*(hud.mariomode.levelentry)/(TICRATE/3), -40, 150)
		xMM_registry.drawMarioCircle(v, 160, 100, radius)
		xMM_registry.hideHud = true
		if hud.mariomode.levelentry then
			hud.mariomode.levelentry = $-1
		end
	end
end

addHook("MapLoad", function()
	hud.mariomode.levelentry = nil
end)

addHook("HUD", V_DrawMarioModeHud, "game")