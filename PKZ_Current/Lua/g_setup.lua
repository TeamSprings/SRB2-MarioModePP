--[[
		Pipe Kingdom Zone's Main - g_setup.lua

Description:
Merely similar to SOC, setup for levels

Contributors: Skydusk
@Team Blue Spring 2024
--]]


-- MAP <MAPID>
-- REQUIRED_VISIT false/true
-- TIME_ATTACK <TICS - 35 tics = 1 sec> <Extra time special-coin>
-- SPECIAL_COIN <string enum - "Dragon_Coins", "Pipe_Coins", "A_Coins", "Star_Coins"> <Amount>

rawset(_G, "MM_setup", [[
	Save_File Pipe_Kindom_Zone
	Coin_Milestones 500, 1250, 2000, 3500, 5000

	-- HUB
	Map HD
	Hub
	Required_Visit false
	Shop COIN 2000
	Shop COIN 2000
	Shop COIN 2000

	-- Test Level
	Map 49
	Required_Visit false

	## Pipe Kingdom Zone
	-- PKZ1
	Map 34
	Required_Visit false
	Time_Attack 5250 true
	Special_Coin Pipe_Coins 5
	Shop COIN 2000
	Shop COIN 2000
	Shop COIN 2000
	Shop COIN 2000
	Shop COIN 2000

	-- PKZ2
	Map 35
	Required_Visit true
	Time_Attack 5250 true
	Special_Coin Pipe_Coins 5

	-- PKZ3
	Map 36
	Required_Visit true
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