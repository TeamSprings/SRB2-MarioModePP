
--  Not so great Dragon Coin saving system
--  To do: Fix other states' transparency
--  Made by Ace

local num_coins = 0
local GF_HARDMODE = 2

addHook("MapLoad", function() num_coins = 0 end)

-- Upon Dragon Coin's spawn... change coloring and make variable signaling this coin was collected
addHook("MapThingSpawn", function(actor, mapthing)
	-- Tag checking for UDMF/Binary
	local vanilla_coin = 0
	local save_data = xMM_registry.getSaveData()

	num_coins = $+1
	actor.extravalue1 = num_coins

	-- Previously Special Coin ID, now merely HUD order
	if mapthing.args[1] then
		actor.dragtag = mapthing.args[1]
	else
		actor.dragtag = mapthing.angle
	end

	if xMM_registry.levellist[gamemap] then
		local coins_data = xMM_registry.levellist[gamemap].coins
		if coins_data and #coins_data >= actor.extravalue1 then
			actor.extravalue2 = coins_data[actor.extravalue1]
		end

		vanilla_coin = xMM_registry.levellist[gamemap].new_coin
		actor.color = SKINCOLOR_GOLD
		if vanilla_coin then
			if vanilla_coin == 1 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = C|FF_PAPERSPRITE
				actor.color = SKINCOLOR_BLUEBELL
			end
			if vanilla_coin == 2 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = D|FF_PAPERSPRITE
			end
			if vanilla_coin == 3 then
				actor.state = S_BLOCKVIS
				actor.sprite = SPR_DOIN
				actor.frame = E|FF_PAPERSPRITE
			end
		end
	end

	if actor.extravalue2 and (save_data.coins[actor.extravalue2] and save_data.coins[actor.extravalue2] > 0) then
		actor.color = SKINCOLOR_SAPPHIRE
		actor.blendmode = AST_ADD
		actor.colorized = true
		actor.dragoncoincolored = true
	else
		actor.colorized = false
		actor.dragoncoincolored = false
	end

	-- spawn sides
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = actor
		sideSpawn.scale = actor.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.frame = actor.frame
		sideSpawn.sprite = SPR_DOIP
	end
end, MT_DRAGONCOIN)

-- Upon Actor's Death, it should search for parameter of their's spawner...
-- Also add 1 collected to tracker
addHook("MobjDeath", function(actor, mo)
	local save_data = xMM_registry.getSaveData()

	if actor.extravalue2 then
		save_data.coins[actor.extravalue2] = (xMM_registry.gameFlags & GF_HARDMODE) and 2 or 1
	end

	A_AwardScore(actor)
	actor.flags = $ &~ MF_NOGRAVITY
	actor.momz = 8 << FRACBITS
	actor.pickinguptimer = 200

	local blast = P_SpawnMobjFromMobj(actor, 0,0,0+3*actor.height/2, MT_POPPARTICLEMAR)
	blast.state = S_NEWPICARTICLE
	blast.sprite = SPR_PUP2
	blast.fuse = 18
	blast.color = actor.color
	blast.colorized = true
	blast.blendmode = AST_TRANSLUCENT
	blast.spparticle = 1

	local star = P_SpawnMobjFromMobj(actor, 0,0,0+actor.height, MT_POPPARTICLEMAR)
	star.state = S_NEWPICARTICLE
	star.sprite = SPR_PFUF
	star.frame = K|FF_PAPERSPRITE|FF_ADD
	star.fuse = 18
	star.color = actor.color
	star.colorized = true
	star.fading = 8
	star.spinninghor = ANG1*8
end, MT_DRAGONCOIN)

--Hacky way to unlock things
--Hey don't blame me
addHook("MobjThinker", function(actor)
	if actor.health > 0 then
		if not libOpt.ConsoleCameraBool(actor, libOpt.ITEM_CONST) then return end
		actor.angle = $-ANG1*3

		-- Stars
		if actor.dragoncoincolored == false and not (leveltime % 12) then
			local star = P_SpawnMobjFromMobj(actor, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-2,50) << FRACBITS, MT_POPPARTICLEMAR)
			star.state = S_SM64SPARKLESSINGLE
			star.scale = actor.scale
			star.color = actor.color
			star.fuse = TICRATE

			if P_RandomKey(16) == 2 then
				local bgstr = P_SpawnMobjFromMobj(star, x, y, z, MT_POPPARTICLEMAR)
				bgstr.state = S_SM64BGSTAR
				bgstr.dispoffset = -3
				bgstr.color = actor.color
				bgstr.fuse = star.fuse
			end
		end
	else
		actor.angle = $+ANG1*8
	end
	if not netplay and not splitscreen then
		if actor.dragoncoincolored == true then
			actor.frame = $|FF_TRANS60
		end
	end
end, MT_DRAGONCOIN)
