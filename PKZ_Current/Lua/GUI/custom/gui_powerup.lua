
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

	if player.powers[pw_shield] &~ SH_FIREFLOWER then result = $ + 20 end --[[ & SH_NOSTACK --]]

	if player.gotflag then result = $ + 20 end

	if player.powers[pw_sneakers] then result = $ + 20 end --[[ & SH_NOSTACK --]]

	if player.powers[pw_invulnerability] or player.powers[pw_flashing] then result = $ + 20 end --[[ & SH_NOSTACK --]]

	if player.powers[pw_gravityboots] then result = $ + 20 end

	return result
end

local chasecam = CV_FindVar("chasecam")
local pwdisplay = CV_FindVar("powerupdisplay")

--At first converted, now similar code to one found in source code
addHook("HUD", function(v, stplyr)
	local playershield = stplyr.powers[pw_shield]
	local selected = newyshields[playershield]
	local q = P_GetAmountofPWicons(stplyr)

	local pwcv_string = pwdisplay.string

	if selected and not (mapheaderinfo[gamemap].mariohubhud) and
	(pwcv_string == "Always" or pwcv_string == "First-person only" and not chasecam.value) then
		v.drawScaled((hudinfo[HUD_POWERUPS].x) << FRACBITS, (hudinfo[HUD_POWERUPS].y) << FRACBITS, FRACUNIT >> 1, v.cachePatch(selected), V_PERPLAYER|hudinfo[HUD_POWERUPS].f|V_HUDTRANS)
	end
end, "game")
