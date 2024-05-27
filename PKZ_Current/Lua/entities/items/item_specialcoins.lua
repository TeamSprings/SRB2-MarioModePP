
//  Not so great Dragon Coin saving system
// To do: Fix other states' transparency
//  Made by Ace
local confirmedreset = 0
local dragoncointag = {}
local dgcoincount = {
	[0] = PKZ_Table.dragonCoins, // current amount
	[1]	= PKZ_Table.maxDrgCoins,// fixed total amount, also forces to not overreach wanted number
}



COM_AddCommand("pkz_dragonlist", function(player)
	CONS_Printf(player, "\x82".."New Mario Mode debug list - DRAGON COINS:")
	for i = 1,PKZ_Table.maxDrgCoins do
		CONS_Printf(player, i+" is "+PKZ_Table.dragonCoinTags[i])
	end
end, COM_LOCAL)

COM_AddCommand("pkz_dragonreset", function(player)
	if confirmedreset == 1
		CONS_Printf(player, "\x85".."WARNING:".."\x80".." Reset of dragon coin list was successful - Map restart is required for restart to take effect")
		for i = 1,PKZ_Table.maxDrgCoins do
			PKZ_Table.dragonCoinTags[i] = 0
		end

		local file = io.openlocal("bluespring/mario/pkz_dgsave.dat", "w+")
		if file
			file:seek("set", 0)
			for i = 1,PKZ_Table.maxDrgCoins do
				file:write(PKZ_Table.dragonCoinTags[i].."\n")
			end
			file:close()
		end
		confirmedreset = 0
	else
		CONS_Printf(player, "\x85".."WARNING:".."\x80".." Are you sure you want to reset your entire progress? Type command again for confirmation.")
		confirmedreset = 1
	end
end, COM_LOCAL)


local num_coins = 0
addHook("MapLoad", function() num_coins = 0 end)

// Upon Dragon Coin's spawn... change coloring and make variable signaling this coin was collected
addHook("MapThingSpawn", function(actor, mapthing)
	//Tag checking for UDMF/Binary
	local vanilla_coin = 0
	local save_data = PKZ_Table.getSaveData()

	num_coins = $+1
	actor.extravalue1 = num_coins

	-- Previously Special Coin ID, now merely HUD order
	if mapthing.args[1] then
		actor.dragtag = mapthing.args[1]
	else
		actor.dragtag = mapthing.angle
	end

	if PKZ_Table.levellist[gamemap] then
		local coins_data = PKZ_Table.levellist[gamemap].coins
		if coins_data and #coins_data >= actor.extravalue1 then
			actor.extravalue2 = coins_data[actor.extravalue1]
		end

		vanilla_coin = PKZ_Table.levellist[gamemap].new_coin
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

// Upon Actor's Death, it should search for parameter of their's spawner...
// Also add 1 collected to tracker
addHook("MobjDeath", function(actor, mo)
	local save_data = PKZ_Table.getSaveData()

	if actor.extravalue2 then
		save_data.coins[actor.extravalue2] = PKZ_Table.hardMode and 2 or 1
	end
	A_AwardScore(actor)
	actor.flags = $ &~ MF_NOGRAVITY
	actor.momz = 8 << FRACBITS
end, MT_DRAGONCOIN)

//Hacky way to unlock things
//Hey don't blame me
local function DCoinTriggertrigger(actor)
	if actor.health > 0 then
		if not libOpt.ConsoleCameraBool(actor, libOpt.ITEM_CONST) then return end
		actor.angle = $-ANG1*3
		if actor.dragoncoincolored == false and not (8 & leveltime) then
			local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-20,20) << FRACBITS, P_RandomRange(-2,50) << FRACBITS, MT_POPPARTICLEMAR)
			poweruppar.state = S_INVINCSTAR
			poweruppar.scale = actor.scale
			poweruppar.color = actor.color
			poweruppar.fuse = TICRATE
		end
	else
		actor.angle = $+ANG1*8
	end
	if not netplay and not splitscreen then
		if actor.dragoncoincolored == true then
			actor.frame = $|FF_TRANS60
		end
	end
end

addHook("MobjThinker", DCoinTriggertrigger, MT_DRAGONCOIN)

// Oi, have you heard about saving... I know bizzare concept
// Especially upon death or rather entire removal from existance
addHook("MobjRemoved", function(actor)
	//debug lmao
	if CV_FindVar("pkz_debug").value == 1
	print("\x82"+actor.target.player.name+" got dragoncoin number "+actor.dragtag+" out of "+dgcoincount[1])
	end
end, MT_DRAGONCOIN)

