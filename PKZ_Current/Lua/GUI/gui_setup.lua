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


//
// TRANSITIONS
//

local frac_half = FRACUNIT >> 1
local double_frac = FRACUNIT << 1

local function Draw_xLine(v, x_1, x_2, y, color)
	v.drawFill(x_1, y, x_2-x_1, 1, color) 
end

local function Draw_yLine(v, x, y_1, y_2, color)
	v.drawFill(x, y_1, 1, y_2-y_1, color)
end

local function Draw_Thick_Circle(v, x_center, y_center, inner, outer, color)
	local x_o = outer
	local x_i = inner
	local y = 0
	local erro = 1 - x_o
	local erri = 1 - x_i
	
	while (x_o > y) do
		Draw_xLine(v, x_center + x_i, x_center + x_o, y_center + y, color)
		Draw_yLine(v, x_center + y, y_center + x_i, y_center + x_o, color)
		Draw_xLine(v, x_center - x_o, x_center - x_i, y_center + y, color)
		Draw_yLine(v, x_center - y, y_center + x_i, y_center + x_o, color)	
		Draw_xLine(v, x_center - x_o, x_center - x_i, y_center - y, color)
		Draw_yLine(v, x_center - y, y_center - x_o, y_center - x_i, color)
		Draw_xLine(v, x_center + x_i, x_center + x_o, y_center - y, color)
		Draw_yLine(v, x_center + y, y_center - x_o, y_center - x_i, color)			
	
		y = $+1
	
		if erro < 0 then
			erro = $+2*y+1
		else
			x_o = $-1
			erro = $+2*(y-x_o+1)
		end
		
		if (y > inner) then
			x_i = y
		else
			if erri < 0 then
				erri = $+2*y+1
			else
				x_i = $-1
				erri = $+2*(y-x_i+1)
			end
		end
	end
end

local function fakeass_sqrt(num)
    if num <= 0 then return 1 end
	if num < 2 then
		return num
	end
	
	local shift = 2
	while ((num >> shift) ~= 0) do
		shift = $+2
	end
	
	local result = 0
	while (shift >= 0) do
		result = result << 1
		local large_cand = result + 1
		if ((large_cand * large_cand) <= (num >> shift)) then
			result = large_cand
		end
		shift = $-2
	end
	
	return result
end

// referenced - https://groups.csail.mit.edu/graphics/classes/6.837/F98/Lecture6/circle.html
local function Draw_inner_circle(v, x_center, y_center, radius, color)
	local x
	local rad_2 = radius*radius	
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	local rest_of_y = -(height-200)/2	
	local x_offset_central = x_center-rest_of_x
	
	for y = -radius, radius, 1 do
		x = fakeass_sqrt(((rad_2 - y*y) << FRACBITS + frac_half) >> FRACBITS)
		local new_y = y_center+y
		v.drawFill(x_center + x, new_y, width, 1, color)
		v.drawFill(rest_of_x, new_y, x_offset_central - x, 1, color)
	end
	
	v.drawFill(rest_of_x, rest_of_y, width, y_center-radius-rest_of_y, color)
	v.drawFill(rest_of_x, y_center+radius+1, width, height, color)
end

PKZ_Table.drawMarioCircle = function(v, x_center, y_center, radius, color1, color2, color3, bg_color)
	if radius < 1 then
		local width = v.width()
		local height = v.height()
		local rest_of_x = -(width-320)/2
		local rest_of_y = -(height-200)/2
		v.drawFill(rest_of_x, rest_of_y, width, height, bg_color)
	else	
		local circle_1 = max(radius-12, 0)
		local circle_2 = max(radius-6, 0)
		local circle_3 = max(radius-1, 0)
		Draw_inner_circle(v, x_center, y_center, max(radius+18, 1), bg_color or 31)

		if circle_3 then
			Draw_Thick_Circle(v, x_center, y_center, radius+1+(7-min(circle_1, 7)), radius+8, color3 or 72)
		end
		if circle_2 then
			Draw_Thick_Circle(v, x_center, y_center, radius+6+(7-min(circle_2, 7)), radius+13, color2 or 37)
		end
		if circle_1 then
			Draw_Thick_Circle(v, x_center, y_center, radius+12+(7-min(circle_3, 7)), radius+19, color1 or 150)
		end
	end
end