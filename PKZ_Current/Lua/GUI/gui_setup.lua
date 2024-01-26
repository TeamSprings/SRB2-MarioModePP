/* 
		Pipe Kingdom Zone's Intermission - gui_setup.lua

Description:
Setup for all HUD stuff

Contributors: Skydusk
@Team Blue Spring 2024
*/

-- REGISTER FONTS!
-- IT DEFINITELY CAUSES LAG SPIKE, but it is essentially optimalization
-- No need to cache font continously, once is enough!

local registered_fonts = false

if not registered_fonts then
	hud.add(function(v)
		if TBSlib.registeredFont["MA10LT"] then return end
		for i = 1, 17 do
			TBSlib.registerFont(v, "MA"..i.."LT")
		end
		TBSlib.registerFont(v, "STTNUM")
		registered_fonts = true
	end, "game")

	hud.add(function(v)
		if TBSlib.registeredFont["MA10LT"] then return end
		for i = 1, 17 do
			TBSlib.registerFont(v, "MA"..i.."LT")
		end
		TBSlib.registerFont(v, "STTNUM")	
		registered_fonts = true
	end, "title")
end