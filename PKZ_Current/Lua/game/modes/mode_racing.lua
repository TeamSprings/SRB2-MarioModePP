/* 
		Pipe Kingdom Zone's Goomba Race - game_race.lua

Description:
Time attack substitude

Contributors: Skydusk
@Team Blue Spring 2024
*/

local difficulty = CV_RegisterVar({
	name = "pkz_goomb_difficulty",
	defaultvalue = "easy",
	flags = 0,
	PossibleValue = {easy=0, medium=1, hard=2},
})

local ReqMaps = {
	34,35,37
}

local BeatedMaps = {}

local dialogchar = {
	[34] = {
		--["default"] = ""
		["sonic"] = "Huh, who might you be? You and the fastest thing alive? No one is as fast in these lands as me... Koopa the Quick. You better prove your proclamation in a race with me",
		["tails"] = "Huh, who might you be? Miles per a hour? You better propper your tails fast enough, as you are going up against Koopa the Quick! Let's Race!",
		["knuckles"] = "Nice ",	
		["fang"] = "Nice ",	
		--["metalsonic"]
		--[""]
	}


}


