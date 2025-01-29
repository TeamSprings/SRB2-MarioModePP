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
	Save_File Pipe_Kingdom_MBEdition
	Coin_Milestones 500, 1250, 2000, 3500, 5000

	-- HUB
	Map HD
	Hub
	Required_Visit false

	-- Test Level
	Map 49
	Required_Visit false

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
]])