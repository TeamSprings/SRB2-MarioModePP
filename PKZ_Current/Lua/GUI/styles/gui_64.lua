
local function LIFECOUNTER_DRAWER(v, p, x_offset)
	local life = v.getSprite2Patch(p.mo.skin, SPR2_LIFE)
	local lives = (p.playerstate == PST_DEAD and
	(p.lives <= 0 and p.deadtimer < 2*TICRATE or p.lives > 0)) and
	p.lives + 1 or p.lives

	TBSlib.fontdrawerInt(v, 'MA6LT', 29 + x_offset, 7, " \042"..(lives == 127 and "INF" or lives),
	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)

	v.draw(21+life.leftoffset+x_offset, 6 + life.topoffset, life,
	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS,
	v.getColormap(p.mo.skin, p.mo.color, p.mo.translation))
end

local function TIMER_DRAWER(v, p, x_offset)
	local minutes = G_TicsToMinutes(p.realtime, true)
	local seconds = G_TicsToSeconds(p.realtime)
	local cent = G_TicsToCentiseconds(p.realtime)/10

	seconds = ($ < 10 and '0'..$ or $)

	TBSlib.fontdrawerInt(v, 'MA6LT', 298 - x_offset, 31,
	"TIME "..minutes.."\039"..seconds.."\034"..cent,
	V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "right", -2)
end

local function COIN_DRAWER(v, p, x_offset)
	local coins, dc = v.cachePatch("SM64COIA"), v.cachePatch("SM64COIB")

	v.draw(168 - x_offset, 7, coins, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	TBSlib.fontdrawerInt(v, 'MA6LT', 185 - x_offset, 7, "\042"..min(p.rings, 999),
	V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT), "left", -2)
end

return {coin = COIN_DRAWER, time = TIMER_DRAWER, life = LIFECOUNTER_DRAWER}