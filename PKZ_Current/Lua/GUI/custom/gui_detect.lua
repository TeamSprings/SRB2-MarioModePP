-- Translation of Hunt radar C code and edited for purposes of Moon radar

local function P_DistEmeraldHunt(player, target)
	local mo = p.mo

	local dist = (P_AproxDistance(R_PointToDist2(mo.x, mo.y, target.x, target.y), player.mo.z - target.z))>>FRACBITS
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

local itemfinder_cv = CV_FindVar("itemfinder")
local controlDown = input.gameControlDown

--Dragon Coin and Moon radars
addHook("HUD", function(v, stplyr)
	if not mariomode and controlDown(GC_SCORES) then return end
	if not itemfinder_cv.value then return end

	local dragoncoinlist = xMM_registry.curlvl.mobj_scoins
	local moonlist = xMM_registry.curlvl.mobj_smoons
	local mhuntoffset = 0
	local dhuntoffset = 0
	local di = 0
	local mi = 0

	if moonlist then
		local max_mnl = #moonlist - 1

		for i = 1,#moonlist do
			local moon = moonlist[i]
			if moon.valid then
				local intm = 0
				mi, intm = P_DistEmeraldHunt(stplyr, moon)

				if intm > 0 and leveltime and not (leveltime % intm) and not (menuactive or paused) then
					S_StartSound(nil, sfx_nmarr1, stplyr)
				end

				v.draw(hudinfo[HUD_HUNTPICS].x - 10 * max_mnl + mhuntoffset, hudinfo[HUD_HUNTPICS].y, v.cachePatch("STARRAD"..mi), hudinfo[HUD_HUNTPICS].f|V_PERPLAYER|V_HUDTRANS)
			end
			mhuntoffset = $ + 20
		end
	end

	if dragoncoinlist then
		local max_dgl = #dragoncoinlist - 1
		local dg_y = hudinfo[HUD_HUNTPICS].y - ((#moonlist) > 0 and 30 or 0)

		for i = 1,#dragoncoinlist do
			local dragoncoin = dragoncoinlist[i]
			if dragoncoin.valid and not dragoncoin.dragoncoincolored then
				local intd = 0
				di, intd = P_DistEmeraldHunt(stplyr, dragoncoin)

				if intd > 0 and leveltime and not (leveltime % intd) and not (menuactive or paused) then
					S_StartSound(nil, sfx_nmarr1, stplyr)
				end

				v.draw(hudinfo[HUD_HUNTPICS].x - 10 * max_dgl + dhuntoffset, dg_y, v.cachePatch("COINRAD"..di), hudinfo[HUD_HUNTPICS].f|V_PERPLAYER|V_HUDTRANS)
			end
			dhuntoffset = $ + 20
		end
	end
end, "game")