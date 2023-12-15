/* 
		Pipe Kingdom Zone's GUI Hud - gui_hud.lua

Description:
Gameplay Hud Logic

Contributors: Skydusk, Clone Fighter
@Team Blue Spring 2024

Contains:

Emblem Tracker, edited into Dragon Coin & Emblem Tracker 
Original for 2.3 Vanilla by Tatsuru, Recreated by Radicalicious, Edited by Skydusk
*/

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
local dragoncoinlist = {}
local moonlist = {}
local offset = 1075
local newx = 14*FRACUNIT
local modern_yshift = -FRACUNIT/2
local modern_scaleH = FRACUNIT
local modern_scaleN = FRACUNIT/2
local modern_scaleItem = FRACUNIT/3

//Add those damn dragon coins into table, damn it.
addHook("PlayerSpawn", function(player)
	dragoncoinlist = {}
	moonlist = {}	
	player.yesdc1up = nil
	
	for thing in mobjs.iterate() do
		if thing.type == MT_DRAGONCOIN then
			table.insert(dragoncoinlist, thing)
		end
		
		if thing.type == MT_MARPOWERMOON then
			table.insert(moonlist, thing)
		end
	end
	table.sort(dragoncoinlist, function(a, b) return a.dragtag > b.dragtag end)
end)

local item_holder_drawer_backend = {
	current_state = 0,
	offset_x = 0,
	offset_y = 0,
	offscale = 0,
	
	-- change animation into itemholder
	[-2] = {offset_x = 0, offset_y = 0, offscale = 0},
	[-1] = {offset_x = 0, offset_y = 0, offscale = 0},
	
	-- Lively animation into itemholder
	[0] = {offset_x = 0, offset_y = 0, offscale = 0},
	[1] = {offset_x = 0, offset_y = 0, offscale = 0},
	[2] = {offset_x = 0, offset_y = 0, offscale = 0},
	[3] = {offset_x = 0, offset_y = 0, offscale = 0},
	[4] = {offset_x = 0, offset_y = 0, offscale = 0},
	[5] = {offset_x = 0, offset_y = 0, offscale = 0},
	[6] = {offset_x = 0, offset_y = 0, offscale = 0},
}

//Item Holder Drawer Hud
hud.add(function(v, stplyr)	
	if not (mariomode and stplyr.playerstate ~= PST_DEAD) then return end
	local prefix = mapheaderinfo[gamemap].worldprefix
	local cstate = item_holder_drawer_backend
	
	local windup = max(min((stplyr.mariomode.backup_pentup or 0)/2, 12), 1)
	
	if pkz_hudstyles.value != 4 then
		local x,y, patch, right = 229-xdoffset,10, v.cachePatch("ITEMHOLDER" + (PKZ_Table.hardMode and "H" or "")), V_SNAPTORIGHT|V_SNAPTOTOP
		if pkz_hudstyles.value != 0 then
			patch = v.cachePatch("ITEMHOLDS" + (PKZ_Table.hardMode and "H" or ""))
		
			if pkz_hudstyles.value == 1 then
				x,y = 279-xdoffset,20
			elseif pkz_hudstyles.value == 2 then
				x,y, right = 141-xdoffset,6, V_SNAPTOTOP
			elseif pkz_hudstyles.value == 3 then
				x,y = 15+xdoffset,160
				right = V_SNAPTOLEFT|V_SNAPTOBOTTOM
			end
		end
		v.draw(x,y, patch, V_PERPLAYER|V_HUDTRANS|right)
		v.drawScaled(((pkz_hudstyles.value == 0) and x+64+cstate.offset_x or x+16+cstate.offset_x) << FRACBITS, (y+25+cstate.offset_y) << FRACBITS, (3<<FRACBITS>>2+cstate.offscale), 
		(stplyr.mariomode.sidepowerup and v.getSpritePatch(states[mobjinfo[stplyr.mariomode.sidepowerup].spawnstate].sprite, A, 0) or v.cachePatch("MA2LTNONE")), 
		V_PERPLAYER|V_HUDTRANS|right)
		v.draw(x,y, v.cachePatch("ITEMHOLDSICON"..windup), V_PERPLAYER|V_HUDTRANS|right)
	else
		local scr_scale = v.dupx()
		local left_side = -((v.width()/scr_scale-320) >> 1)
		local top_side = -((v.height()/scr_scale-200) >> 1)
		local smwh_x, smwh_y, smwh_scale = 16 << FRACBITS, (56+xdoffset) << FRACBITS, FRACUNIT >> 1
		v.drawScaled(smwh_x, smwh_y, smwh_scale, v.cachePatch("SMWONITEMHOLD"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANSHALF)
		v.drawScaled((28+cstate.offset_x) << FRACBITS, (74+xdoffset+cstate.offset_y) << FRACBITS + FRACUNIT >> 1, FRACUNIT >> 1 +cstate.offscale, 
		(stplyr.mariomode.sidepowerup and v.getSpritePatch(states[mobjinfo[stplyr.mariomode.sidepowerup].spawnstate].sprite, A, 0) or v.cachePatch("MA2LTNONE")), 
		V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		
		v.drawScaled(smwh_x, smwh_y, smwh_scale, v.cachePatch("SMWONDITEMBG"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)		
		
		--TBS_Polygon.drawPolygon(v, left_side+28, top_side+xdoffset+68, TBS_Polygon.progressLine(wonder_windup_poly, (stplyr.backup_pentup << FRACBITS)/24), 37, 2, false)
		if stplyr.mariomode.backup_pentup then
			v.drawScaled(smwh_x, smwh_y, smwh_scale, v.cachePatch("SMWONITHANIM"..min(max((stplyr.mariomode.backup_pentup or 0), 0), 21)), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)		
		end

		v.drawScaled(smwh_x, smwh_y, smwh_scale, v.cachePatch("SMWONITEMHOLDBT"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	end

	--v.draw(242, 12, v.cachePatch("WORLD11"), V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS)	
	if pkz_hudstyles.value == 0 then
		TBSlib.fontdrawerInt(v, 'MA3LT', 253-xdoffset, 12, (stplyr.marlevnum and prefix..' '..stplyr.marlevnum or prefix..' '..mapheaderinfo[gamemap].worldassigned) or "W 1-1", V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, SKINCOLOR_SAPPHIRE), "center", 0, 0)
	elseif pkz_hudstyles.value == 2 then
		TBSlib.fontdrawer(v, 'MA2LT', (103+xdoffset) << FRACBITS - FRACUNIT >> 1, 14 << FRACBITS, FRACUNIT,
		(stplyr.marlevnum and string.lower(prefix..''..stplyr.marlevnum) or string.lower(prefix..''..mapheaderinfo[gamemap].worldassigned)) or "w1-1",
		V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD), "center", 0, 0)
	end

end, "game")


//Dragon Coins
hud.add(function(d, p)
	if not mariomode or splitscreen then return end -- I dunno why this was in the iterator instead of here
	
	if pkz_hudstyles.value == 0 then -- SRB2... Oh boy.
		local loffset = offset
		
		
		local dragoncoinpatch = d.cachePatch("YOSHCO")
		local uncollectedcoin = d.cachePatch("YOSHCB")
		local colloredcoin = d.cachePatch("YOSHCD")
		
		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw((loffset >> 2 + (dragoncoinpatch.width >> 6) - xdoffset), 22, dragoncoinpatch, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid
				d.draw((loffset >> 2 + (uncollectedcoin.width >> 6) - xdoffset), 22, colloredcoin, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)			
			else
				d.draw((loffset >> 2 + (colloredcoin.width >> 6) - xdoffset), 22, uncollectedcoin, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
			loffset = $ - 36
		end
		
	elseif pkz_hudstyles.value == 1 then -- Super Mario Maker
		local bracket = d.cachePatch("SMMBRACK")
		d.draw(269 - xdoffset, 20, bracket, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP)
		
		local dragoncoinpatch = d.cachePatch("SMMDCOI")
		local uncollectedcoin = d.cachePatch("SMMNODC")
		local colloredcoin = d.cachePatch("SMMDCBL")
		local i = 0
		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, dragoncoinpatch, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, colloredcoin, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)			
			else
				d.draw(260 - ((embnum-1)*10) - xdoffset, 23, uncollectedcoin, V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
			i = embnum-1
		end
		
		d.draw(260 - (i*10)-2 - xdoffset, 20, bracket, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_FLIP)
	
	elseif pkz_hudstyles.value == 2 then -- Super Mario World
		local dragoncoinpatch = d.cachePatch("SMWDCOI")
		local uncollectedcoin = d.cachePatch("MA2LTNONE")
		local colloredcoin = d.cachePatch("SMWDCBL")
		for embnum, dragoncoin in ipairs(dragoncoinlist) do
			if not dragoncoin.valid then
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, dragoncoinpatch, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			elseif dragoncoin.dragoncoincolored and dragoncoin.valid
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, colloredcoin, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)			
			else
				d.draw(117 - ((embnum-1)*9) - xdoffset, 24, uncollectedcoin, V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
		end
	end

end, "game")

local life_xyz = {{1,0},{0,1},{-1,0},{0,-1}}
hud.pkz_registeredlives = 0
hud.pkz_registeredcoins = 0

// Swap Ring Counter with Coins in SRB2 HUD
// All other Hud Styles.
hud.add(function(v, player)
	hud.playercoins = player.rings
	hud.playerlives = player.lives
	hud.playerskin = player.mo and player.mo.skin or SKINCOLOR_NONE
	hud.playercolor = player.skincolor
	hud.playeroppositecolor = ColorOpposite(player.skincolor or 1)
	hud.skip = false
	
	if PKZ_Table.hideHud then
		xdoffset = xdoffset >= -350 and $-10 or -350
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
			local dg_coins = v.cachePatch("YOSHWONCOA")
		
			v.drawScaled(15 << FRACBITS, (17+xdoffset)*modern_scaleN, modern_scaleN, no_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)					
			TBSlib.fontdrawershifty(v, 'MA13LT', newx, (7+xdoffset) << FRACBITS, modern_scaleN, player.rings,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")
					
			v.drawScaled(15 << FRACBITS, (29+xdoffset)*modern_scaleN, modern_scaleN, dg_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
			TBSlib.fontdrawershifty(v, 'MA13LT', newx, (19+xdoffset) << FRACBITS, modern_scaleN, PKZ_Table.dragonCoins,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")			
		else
			v.draw(hudinfo[HUD_SCORE].x+xdoffset, hudinfo[HUD_SCORE].y, v.cachePatch("SCTRUMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			--v.draw(hudinfo[HUD_SCORENUM].x+24+xdoffset, hudinfo[HUD_SCORENUM].y, v.cachePatch("COTRUMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		
			TBSlib.fontdrawerInt(v, 'STTNUM', (hudinfo[HUD_SCORENUM].x+72+xdoffset), (hudinfo[HUD_SCORENUM].y), PKZ_Table.ringsCoins, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, 0), "right", 0, 6)
			--v.drawNum(hudinfo[HUD_SCORENUM].x+72+xdoffset, hudinfo[HUD_SCORENUM].y, PKZ_Table.ringsCoins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		
			v.draw(hudinfo[HUD_TIME].x+xdoffset, hudinfo[HUD_TIME].y, v.cachePatch("HTDCOSMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)			
			v.drawNum(hudinfo[HUD_SECONDS].x+56+xdoffset, hudinfo[HUD_SECONDS].y, PKZ_Table.dragonCoins, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)		
		end
		
		hud.disable("rings")
		hud.disable("time")
		hud.disable("score")
		hud.disable("lives")
		
	else
		if PKZ_Table.replaceHud then
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
					
					v.draw(3+life.leftoffset+xdoffset, 2+life.topoffset, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS|V_FLIP, v.getColormap(player.mo.skin, player.mo.color))
					TBSlib.fontdrawerInt(v, 'MA2LT', 20+xdoffset, 8, "\042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")
					
					v.draw(6+xdoffset, 22, coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.fontdrawerInt(v, 'MA2LT', 20+xdoffset, 24, "\042"..coin,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")
					
					TBSlib.fontdrawerInt(v, 'MA2LT', 174-xdoffset, 6, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left", 0, 8, "0")
					
					v.draw(255-xdoffset, 3, clock, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.fontdrawerInt(v, 'MA2LT', 271-xdoffset, 6, minutes..":"..seconds,
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
					
					TBSlib.fontdrawer(v, 'MA5LT', (35+xdoffset) << FRACBITS - FRACUNIT >> 1, 15 << FRACBITS, FRACUNIT,
					string.upper(''..skins[player.mo.skin].hudname), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, player.skincolor), "center")
					TBSlib.fontdrawerInt(v, 'MA2LT', 23+xdoffset, 23, "\042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")
					
					v.draw(267-xdoffset, 15, coins, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.fontdrawerInt(v, 'MA2LT', 276-xdoffset, 15, "\042"..coin,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left")
					
					TBSlib.fontdrawerInt(v, 'MA2LT', 244-xdoffset, 23, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "left", 0, 8, "0")
					
					v.draw(197+xdoffset, 15, time, V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD))
					TBSlib.fontdrawer(v, 'MA2LT', (209+xdoffset) << FRACBITS - FRACUNIT >> 1, 23 << FRACBITS, FRACUNIT, minutes..":"..seconds,
					V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_GOLD), "center")
				
				elseif pkz_hudstyles.value == 3 then -- Super Mario 64
					local coins, dc = v.cachePatch("SM64COIA"), v.cachePatch("SM64COIB")
					local life = v.getSprite2Patch(player.mo.skin, SPR2_LIFE)
					local minutes = G_TicsToMinutes(player.realtime, true)
					local seconds = G_TicsToSeconds(player.realtime)
					local lives = (player.playerstate == PST_DEAD and (player.lives <= 0 and player.deadtimer < 2*TICRATE or player.lives > 0)) and player.lives + 1 or player.lives
					seconds = ($ < 10 and '0'..$ or $)
					local cent = G_TicsToCentiseconds(player.realtime)/10
					
					
					TBSlib.fontdrawerInt(v, 'MA6LT', 29+xdoffset, 7, " \042"..(lives == 127 and "INF" or lives),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)
					
					v.draw(21+life.leftoffset+xdoffset, 6+life.topoffset, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(player.mo.skin, player.mo.color))
				
					v.draw(168-xdoffset, 7, coins, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.fontdrawerInt(v, 'MA6LT', 185-xdoffset, 7, "\042"..min(player.rings, 999),
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)
					
					v.draw(244-xdoffset, 7, dc, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					TBSlib.fontdrawerInt(v, 'MA6LT', 261-xdoffset, 7, "\042"..PKZ_Table.dragonCoins,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)	
					
					TBSlib.fontdrawerInt(v, 'MA6LT', 298-xdoffset, 31, "TIME "..minutes.."\039"..seconds.."\034"..cent,
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
					TBSlib.fontdrawershifty(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")

					if player.rings <= 0 and not xdoffset then
						local blinking = ease.outsine(abs(((leveltime << FRACBITS /11) % (FRACUNIT << 1))+1-FRACUNIT), 0, 9) << V_ALPHASHIFT
						TBSlib.fontdrawershifty(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREREDFONT), "left", -2, modern_yshift, 2, "0")
					end
					
					if is_cointimer_active and not xdoffset then
						local blinking = ease.outsine((hud.wonder_hud_timer.coinst << FRACBITS) >> 2, 9, 1) << V_ALPHASHIFT						
						TBSlib.fontdrawershifty(v, 'MA13LT', newx, coins_counter_y, modern_scaleN, player.rings,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT), "left", -2, modern_yshift, 2, "0")
					end
					
					local life_x = 17+life.leftoffset
					local life_y = 32+life.topoffset+xdoffset

					for i = 1,4 do
						v.draw(life_x+life_xyz[i][1], life_y+life_xyz[i][2], life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
					end
					v.draw(life_x, life_y, life, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(player.mo.skin, player.mo.color))
					TBSlib.fontdrawershifty(v, 'MA13LT', newx, lives_counter_y, modern_scaleN, lives,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")					

					if is_livestimer_active and not xdoffset then
						local blinking = ease.outsine((hud.wonder_hud_timer.livest << FRACUNIT) >> 2, 9, 1) << V_ALPHASHIFT
						TBSlib.fontdrawershifty(v, 'MA13LT', newx, lives_counter_y, modern_scaleN, lives,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|blinking, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGREENFONT), "left", -2, modern_yshift, 2, "0")
					end
					
					TBSlib.fontdrawer(v, 'MA9LT', 610 << FRACBITS, (28+xdoffset) << FRACBITS, FRACUNIT >> 1, minutes..":"..seconds..":"..cent,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "right", -2)
					TBSlib.fontdrawer(v, 'MA10LT', 610 << FRACBITS, (42+xdoffset) << FRACBITS, FRACUNIT >> 1, player.score,
					V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "right", -2, 8, "0")
					
					hud.wonder_hud_timer.coins = player.rings
					hud.wonder_hud_timer.lives = lives
					
					
					if G_RingSlingerGametype() then
						v.drawString(160, 180, "Drop of items", 0, "center")
						v.drawString(160, 190, "128", 0, "center")
						hud.disable("weaponrings")
					end
					
				end
			end
		end
	end
end)

local activeshields = {
	SH_WHIRLWIND,
	SH_ELEMENTAL,   
	SH_ARMAGEDDON,  
	SH_ATTRACT,  
	SH_PITY,     
	SH_PINK,        
	SH_FLAMEAURA,   
	SH_BUBBLEWRAP,  
	SH_THUNDERCOIN,
	SH_GOLDENSHFORM,
	SH_NICEFLOWER,
	SH_NEWFIREFLOWER,
	SH_BIGSHFORM,
	SH_MINISHFORM,
}

local newyshields = {
	[SH_GOLDENSHFORM] = SH_GOLDENSHFORM,
	[SH_NICEFLOWER] = SH_NICEFLOWER,
	[SH_NEWFIREFLOWER] = SH_NEWFIREFLOWER,
	[SH_BIGSHFORM] = SH_BIGSHFORM,
	[SH_MINISHFORM] = SH_MINISHFORM,
}

local newxshields = {
	[SH_GOLDENSHFORM] = "GSHPICON",
	[SH_NICEFLOWER] = "ICFLICON",
	[SH_NEWFIREFLOWER] = "NFFLICON",
	[SH_BIGSHFORM] = "RESHICON",
	[SH_MINISHFORM] = "MISHICON",
}

local function P_GetAmountofPWicons(player)
	local result = 0
	
	if player.powers[pw_shield] &~ SH_FIREFLOWER then result = $ + 20 end /* & SH_NOSTACK */

	if player.gotflag then result = $ + 20 end

	if player.powers[pw_sneakers] then result = $ + 20 end /* & SH_NOSTACK */

	if player.powers[pw_invulnerability] or player.powers[pw_flashing] then result = $ + 20 end /* & SH_NOSTACK */

	if player.powers[pw_gravityboots] then result = $ + 20 end

	return result
end

//At first converted, now similar code to one found in source code
hud.add(function(v, stplyr)	
	local playershield = stplyr.powers[pw_shield]
	local q = P_GetAmountofPWicons(stplyr)
	
	if stplyr.powers[pw_shield] & SH_FIREFLOWER and not (mapheaderinfo[gamemap].mariohubhud) and (CV_FindVar("powerupdisplay").string == "Always" or CV_FindVar("powerupdisplay").string == "First-person only" and not CV_FindVar("chasecam").value) then
		v.drawScaled((hudinfo[HUD_POWERUPS].x-q) << FRACBITS, (hudinfo[HUD_POWERUPS].y) << FRACBITS, FRACUNIT >> 1, v.cachePatch("FIFLICON"), V_PERPLAYER|hudinfo[HUD_POWERUPS].f|V_HUDTRANS)
	end
	
	if stplyr.powers[pw_shield] == newyshields[playershield] and not (mapheaderinfo[gamemap].mariohubhud) and (CV_FindVar("powerupdisplay").string == "Always" or CV_FindVar("powerupdisplay").string == "First-person only" and not CV_FindVar("chasecam").value) then
		v.drawScaled((hudinfo[HUD_POWERUPS].x) << FRACBITS, (hudinfo[HUD_POWERUPS].y) << FRACBITS, FRACUNIT >> 1, v.cachePatch(newxshields[playershield]), V_PERPLAYER|hudinfo[HUD_POWERUPS].f|V_HUDTRANS)
	end
end, "game")

// Translation of Hunt radar C code and edited for purposes of Moon radar

local function P_DistEmeraldHunt(player, target)
	local dist = (P_AproxDistance(P_AproxDistance(player.mo.x - target.x, player.mo.y - target.y), player.mo.z - target.z))>>FRACBITS
	if dist < 128 then
		return 6, 5
	elseif dist < 512 then
		return 5, 10
	elseif dist < 1024 then
		return 4, 20
	elseif dist < 2048 then
		return 3, 30
	elseif dist < 3072 then
		return 2, 35
	else
		return 1, 0
	end
end

//Dragon Coin and Moon radars
hud.add(function(v, stplyr)
	if not mariomode and (input.gameControlDown(GC_SCORES)) then return end
	local mhuntoffset = 0
	local dhuntoffset = 0
	local di = 0
	local mi = 0	
	
	if moonlist then
		for i = 1,#moonlist do
			local moon = moonlist[i]
			if moon.valid
				local intm = 0
				mi, intm = P_DistEmeraldHunt(stplyr, moon)
				
				if intm > 0 and leveltime and not (leveltime % intm) and not paused then
					S_StartSound(nil, sfx_emfind, stplyr)
				end
				
				v.draw((hudinfo[HUD_HUNTPICS].x-10*((#moonlist)-1))+mhuntoffset, hudinfo[HUD_HUNTPICS].y, v.cachePatch("STARRAD"..mi), hudinfo[HUD_HUNTPICS].f|V_PERPLAYER|V_HUDTRANS)
			end
			mhuntoffset = $ + 20
		end
	end

	if not CV_FindVar("itemfinder").value then return end

	if dragoncoinlist then
		for i = 1,#dragoncoinlist do
			local dragoncoin = dragoncoinlist[i]	
			if dragoncoin.valid and not dragoncoin.dragoncoincolored then
				local intd = 0
				di, intd = P_DistEmeraldHunt(stplyr, dragoncoin)
				
				if intd > 0 and leveltime and not (leveltime % intd) and not paused then
					S_StartSound(nil, sfx_emfind, stplyr)
				end			
				v.draw((hudinfo[HUD_HUNTPICS].x-10*((#dragoncoinlist)-1))+dhuntoffset, hudinfo[HUD_HUNTPICS].y-((#moonlist) > 0 and 30 or 0), v.cachePatch("COINRAD"..di), hudinfo[HUD_HUNTPICS].f|V_PERPLAYER|V_HUDTRANS)
			end
			dhuntoffset = $ + 20
		end
	end
end, "game")