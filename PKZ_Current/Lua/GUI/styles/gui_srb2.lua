local function HUB_DRAWER(v, p)
	local save_data = xMM_registry.getSaveData()
	local total_c = save_data.coins

	v.draw(hudinfo[HUD_SCORE].x+xdoffset, hudinfo[HUD_SCORE].y, v.cachePatch("SCTRUMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
	TBSlib.drawTextInt(v, 'STTNUM', (hudinfo[HUD_SCORENUM].x+72+xdoffset), (hudinfo[HUD_SCORENUM].y), save_data.total_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER, v.getColormap(TC_DEFAULT, 0), "right", 0, 6)

	v.draw(hudinfo[HUD_TIME].x+xdoffset, hudinfo[HUD_TIME].y, v.cachePatch("HTDCOSMAR"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
	v.drawNum(hudinfo[HUD_SECONDS].x+56+xdoffset, hudinfo[HUD_SECONDS].y, #total_c, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
end