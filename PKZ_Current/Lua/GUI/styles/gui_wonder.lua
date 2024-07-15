local function HUB_DRAWER(v, p)
	local no_coins = v.cachePatch("SMWONCOIN")
	local dg_coins = v.cachePatch("SMWONDBCOIN")
	local save_data = PKZ_Table.getSaveData()
	local total_c = save_data.coins

	v.drawScaled(15 << FRACBITS, (17+xdoffset)*modern_scaleN, modern_scaleN, no_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	TBSlib.fontdrawershifty(v, 'MA13LT', newx, (7+xdoffset) << FRACBITS, modern_scaleN, save_data.total_coins,
	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 9, ";")

	v.drawScaled(15 << FRACBITS, (67+xdoffset)*modern_scaleN, modern_scaleN, dg_coins, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	TBSlib.fontdrawershifty(v, 'MA13LT', newx, (19+xdoffset) << FRACBITS, modern_scaleN, #total_c,
	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, modern_yshift, 2, "0")
end