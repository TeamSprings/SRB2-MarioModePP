/* 
		Pipe Kingdom Zone's Main - g_setup.lua

Description:
Merely similar to SOC, setup for levels

Contributors: Skydusk
@Team Blue Spring 2024
*/


--
-- 
--
--

/*
if PKZ_Table.ringsCoins > 500 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[1]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[1]] = 1
				print("Dragon Coin for reaching 500 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 1250 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[2]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[2]] = 1
				print("Dragon Coin for reaching 1250 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 2000 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[3]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[3]] = 1
				print("Dragon Coin for reaching 2000 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 3500 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[4]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[4]] = 1
				print("Dragon Coin for reaching 3500 coins was earned")
			end
			
			if PKZ_Table.ringsCoins > 5000 and not PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[5]] then
				PKZ_Table.dragonCoinTags[PKZ_Table.dragonCoinRingSelect[5]] = 1
				print("Final Dragon Coin for reaching 5000 coins was earned")			
			end
*/



-- MAP <MAPID>
-- REQUIRED_VISIT false/true
-- TIME_ATTACK <TICS - 35 tics = 1 sec> <Extra time special-coin>
-- SPECIAL_COIN <string enum - "Dragon_Coins", "Pipe_Coins", "A_Coins", "Star_Coins"> <Amount>

rawset(_G, "MM_setup", [[
	Save_File "Pipe_Kindom_Zone"
	Coin_Milestones 500, 1250, 2000, 3500, 5000
	
	## Pipe Kingdom Zone
	-- PKZ1	
	Map 34	
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Pipe_Coins 5
	
	-- PKZ2
	Map 35	
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Pipe_Coins 5
	
	-- PKZ3
	Map 36	
	Required_Visit false
	Time_Attack 5250 true
	
	## Mario Koopa Blast Revamped	
	-- MKB1
	Map 37
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Dragon_Coins 3
	
	-- MKB2
	Map 38	
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Dragon_Coins 3
	
	-- MKB3
	Map 39	
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Dragon_Coins 3
	
	## Legacy Levels		
	-- Edtied PTZ 
	Map 31
	Required_Visit false
	Time_Attack 1000 true
	Special_Coin A_Coins 3
	
	-- Edtied PTZ Revamped 
	Map 46
	Required_Visit false
	Time_Attack 1000 true
	Special_Coin A_Coins 3

	## Bonus Levels
	-- Edtied GFZ1
	Map 497
	Required_Visit false
	Time_Attack 1000 true
	Special_Coin A_Coins 3
]])


/*
	-- Collectibles
	dragonCoins = 0,
	maxDrgCoins = 39, //There are only 30 in levels, other 10 are gain through time/coin required means	
	dragonCoinTags = {},
	ringsCoins = 0,
	roomHubKey = 0,

	dragonCoinRingSelect = {28, 27, 26, 25, 24}, -- for dragoncoins gained through coin collection
	listoflevelIDs = {31, 34, 35, 36, 37, 38, 39, 46, 48, 49, 50, 51, 52},
	levellist = {
		[31] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 40; coins = {}, new_coin = 2},
		[34] = {reqVisit = false; recordedtime = 0; timeattack = 5250; timeattackDGid = 39; coins = {1, 2, 3, 4, 5, 29}, new_coin = 1},
		[46] = {reqVisit = false; recordedtime = 0; timeattack = 1000; timeattackDGid = 41; coins = {}, new_coin = 2},		
		[35] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 38; coins = {}, new_coin = 1},
		[36] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 37; coins = {}, new_coin = 1},
		[37] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 36; coins = {}, new_coin = 0},
		[38] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 35; coins = {}, new_coin = 0},
		[39] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 34; coins = {}, new_coin = 0},
		[48] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 33; coins = {}, new_coin = 2},
		[49] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 32; coins = {}, new_coin = 3},
		[50] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 31; coins = {}, new_coin = 2},
		[51] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 30; coins = {}, new_coin = 2},
		[52] = {reqVisit = true; recordedtime = 0; timeattack = 1000; timeattackDGid = 29; coins = {}, new_coin = 2};
	},
*/