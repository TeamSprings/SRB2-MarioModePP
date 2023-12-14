/* 
		Team Blue Spring's Series of Libaries. 
		Old Polygon Library - lib_polygon.lua

	Note: Rewrite, please.

Contributors: Skydusk
@Team Blue Spring 2024
*/


// Square for INT(Fixed)
local frac_half = FRACUNIT >> 1
local double_frac = FRACUNIT << 1

/*
local function fakeass_sqrt(num)
    if num <= FRACUNIT then
		return num
	end
	
	local x_0 = FixedDiv(num, double_frac)
	local x_1 = FixedDiv(FixedDiv(x_0 + num, x_0), double_frac)

	while (x_1 < x_0) do
		x_0 = x_1
		x_1 = FixedDiv(FixedDiv(x_0 + num, x_0), double_frac)
	end
    return x_0
end
*/

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

local function Draw_circle(v, x_center, y_center, radius, color)
	local x
	local rad_2 = radius*radius
	
	for y = -radius, radius, 1 do
		x = fakeass_sqrt(((rad_2 - y*y) << FRACBITS + frac_half) >> FRACBITS)
		local new_y = y_center+y
		v.drawFill(x_center + x, new_y, 1, 1, color)
		v.drawFill(x_center - x, new_y, 1, 1, color)
	end
end

--https://stackoverflow.com/questions/27755514/circle-with-thickness-drawing-algorithm
local function Draw_xLine(v, x_1, x_2, y, color)
	v.drawFill(x_1, y, x_2-x_1, 1, color) 
end

local function Draw_yLine(v, x, y_1, y_2, color)
	v.drawFill(x, y_1, 1, y_2-y_1, color)
end

-- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
local function Draw_LineLow(v, x_0, y_0, x_1, y_1, color)
	local dx = x_1-x_0
	local dy = y_1-y_0
	local yi = 1
	if dy < 0 then
		yi = -1
		dy = -dy
	end
	local D = 2*dy - dx
	local y = y_0
	
	for x = x_0, x_1 do
		v.drawFill(x, y, 1, 1, color)
		if D > 0 then
			y = y+yi
			D = D + (2*(dy - dx))
		else
			D = D + 2*dy			
		end
	end
end

-- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
local function Draw_LineHigh(v, x_0, y_0, x_1, y_1, color)
	local dx = x_1-x_0
	local dy = y_1-y_0
	local xi = 1
	if dx < 0 then
		xi = -1
		dx = -dx
	end
	local D = 2*dx - dy
	local x = x_0
	
	for y = y_0, y_1 do
		v.drawFill(x, y, 1, 1, color)
		if D > 0 then
			x = x+xi
			D = D + (2*(dx - dy))
		else
			D = D + 2*dx			
		end
	end
end

local function Draw_Line(v, x_0, y_0, x_1, y_1, color)
	if abs(y_1 - y_0) < abs(x_1 - x_0) then
		if x_0 > x_1 then
			Draw_LineLow(v, x_1, y_1, x_0, y_0, color)
		else
			Draw_LineLow(v, x_0, y_0, x_1, y_1, color)
		end
	else
		if y_0 > y_1 then
			Draw_LineHigh(v, x_1, y_1, x_0, y_0, color)
		else
			Draw_LineHigh(v, x_0, y_0, x_1, y_1, color)
		end	
	end
end

-- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
local function Draw_LineLowThick(v, x_0, y_0, x_1, y_1, color, thickness)
	local dx = x_1-x_0
	local dy = y_1-y_0
	local yi = 1
	if dy < 0 then
		yi = -1
		dy = -dy
	end
	local D = 2*dy - dx
	local y = y_0
	
	for x = x_0, x_1 do
		v.drawFill(x, y - thickness/2, 1, thickness, color)
		if D > 0 then
			y = y+yi
			D = D + (2*(dy - dx))
		else
			D = D + 2*dy			
		end
	end
end

-- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
local function Draw_LineHighThick(v, x_0, y_0, x_1, y_1, color, thickness)
	local dx = x_1-x_0
	local dy = y_1-y_0
	local xi = 1
	if dx < 0 then
		xi = -1
		dx = -dx
	end
	local D = 2*dx - dy
	local x = x_0
	
	for y = y_0, y_1 do
		v.drawFill(x - thickness/2, y, thickness, 1, color)
		if D > 0 then
			x = x+xi
			D = D + (2*(dx - dy))
		else
			D = D + 2*dx
		end
	end
end

local function Draw_LineThick(v, x_0, y_0, x_1, y_1, color, thickness)
	if abs(y_1 - y_0) < abs(x_1 - x_0) then
		if x_0 > x_1 then
			Draw_LineLowThick(v, x_1, y_1, x_0, y_0, color, thickness)
		else
			Draw_LineLowThick(v, x_0, y_0, x_1, y_1, color, thickness)
		end
	else
		if y_0 > y_1 then
			Draw_LineHighThick(v, x_1, y_1, x_0, y_0, color, thickness)
		else
			Draw_LineHighThick(v, x_0, y_0, x_1, y_1, color, thickness)
		end	
	end
end

local function sign(num)
	if num > 0 then
		return 1
	elseif num < 0 then
		return -1
	else
		return 0
	end
end

local function signFixed(num)
	if num > 0 then
		return FRACUNIT
	elseif num < 0 then
		return -FRACUNIT
	else
		return 0
	end
end

local function Create_Curve(point_1, point_2, detail)
	local The_Curve = {}
	if detail > 1 then
		local Ease_Detail = FRACUNIT/detail
		for i = 1, detail-1 do
			table.insert(The_Curve,
			{x = ease.insine(Ease_Detail*i, point_1.x, point_2.x),
			y = ease.insine(Ease_Detail*i, point_1.y, point_2.y)})
		end
	end
	return The_Curve
end

local function Create_CurveAuto(point_1, point_2, dist)
	local detail = R_PointToDist2(point_1.x, point_1.y, point_2.x, point_2.y)/dist
	local The_Curve = {}
	if detail > 1 then
		local Ease_Detail = FRACUNIT/detail
		for i = 1, detail-1 do
			table.insert(The_Curve,
			{x = ease.insine(Ease_Detail*i, point_1.x, point_2.x),
			y = ease.insine(Ease_Detail*i, point_1.y, point_2.y)})
		end
	end
	return The_Curve	
end

local function Draw_PolygonLine(v, x_center, y_center, points, color)
	if #points < 3 then return end
	for i = 1, #points do
		local point_1 = points[i]
		local point_2 = points[points[i+1] and i+1 or 1]
		Draw_Line(v, x_center+point_1.x, y_center+point_1.y, x_center+point_2.x, y_center+point_2.y, color)
	end
end

local function Draw_PolygonLineThick(v, x_center, y_center, points, color, thickness)
	if #points < 3 then return end
	for i = 1, #points do
		local point_1 = points[i]
		local point_2 = points[points[i+1] and i+1 or 1]
		Draw_LineThick(v, x_center+point_1.x, y_center+point_1.y, x_center+point_2.x, y_center+point_2.y, color, thickness)
	end
end

local function Draw_PolyLineThick(v, x_center, y_center, points, color, thickness)
	if #points < 2 then return end
	for i = 1, #points do
		if not points[i+1] then break end
		local point_1 = points[i]
		local point_2 = points[i+1]
		Draw_LineThick(v, x_center+point_1.x, y_center+point_1.y, x_center+point_2.x, y_center+point_2.y, color, thickness)
	end
end

-- Sorry, I used GPT...
local function Draw_PolygonFill(v, x_center, y_center, points, color)
	-- Determine the minimum and maximum x-coordinates and y-coordinates
	local ymin, ymax = INT16_MAX, -INT16_MAX
	for i = 1, #points do
		local y = points[i].y
		ymin = min(ymin, y)
		ymax = max(ymax, y)
	end

	-- Iterate over each scanline
	for y = ymin, ymax do
		local intersections = {}
    
		-- Find the intersection points of the scanline with the polygon edges
		for i = 1, #points do
			local p_1, p_2 = points[i], points[(i % #points) + 1]
			local x_1, y_1 = p_1.x, p_1.y
			local x_2, y_2 = p_2.x, p_2.y

			if (y_1 <= y and y < y_2) or (y_2 <= y and y < y_1) then
				local x = x_1 + (x_2 - x_1) * (y - y_1) / (y_2 - y_1)
				table.insert(intersections, x)
			end
		end

		-- Sort the intersection points
		table.sort(intersections)

		-- Fill the regions between consecutive intersection points
		for i = 1, #intersections, 2 do
			local x_1, x_2 = intersections[i], intersections[i + 1]
			if x_1 and x_2 then
				v.drawFill(x_center+x_1, y_center+y, x_2 - x_1, 1, color)
			end
		end
	end
end

local Dithering = {
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{1, 1, 1, 1},
	{2, 1, 2, 1},
	{1, 1, 1, 1},
	{2, 1, 2, 1},
	{1, 1, 1, 1},
	{2, 1, 2, 1},
	{1, 2, 1, 1},
	{2, 1, 2, 1},
	{1, 2, 1, 2},
	{2, 1, 2, 1},
	{1, 2, 1, 2},
	{2, 1, 2, 1},
	{1, 2, 1, 2},
	{2, 1, 2, 1},
	{1, 2, 1, 2},
	{2, 2, 2, 1},
	{1, 2, 1, 2},
	{2, 1, 2, 2},
	{1, 2, 1, 2},
	{2, 2, 2, 1},
	{1, 2, 1, 2},
	{2, 1, 2, 2},
	{1, 2, 1, 2},
	{1, 2, 1, 2},
	{2, 1, 2, 2},
	{1, 2, 1, 2},
	{2, 2, 2, 2},	
	{1, 2, 1, 2},
	{2, 2, 2, 2},
	{1, 2, 1, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},
	{2, 2, 2, 2},	
}

local Blue_Dithering = {
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{150, 150, 150, 150},
	{134, 150, 134, 150},
	{150, 150, 150, 150},
	{134, 150, 134, 150},
	{150, 150, 150, 150},
	{134, 150, 134, 150},
	{150, 134, 150, 150},
	{134, 150, 134, 150},
	{150, 134, 150, 134},
	{134, 150, 134, 150},
	{150, 134, 150, 134},
	{134, 150, 134, 150},
	{150, 134, 150, 134},
	{134, 150, 134, 150},
	{150, 134, 150, 134},
	{134, 134, 134, 150},
	{150, 134, 150, 134},
	{134, 150, 134, 134},
	{150, 134, 150, 134},
	{134, 134, 134, 150},
	{150, 134, 150, 134},
	{134, 150, 134, 134},
	{150, 134, 150, 134},
	{150, 134, 150, 134},
	{134, 150, 134, 134},
	{150, 134, 150, 134},
	{134, 134, 134, 134},	
	{150, 134, 150, 134},
	{134, 134, 134, 134},
	{150, 134, 150, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},
	{134, 134, 134, 134},	
}

local Blue_Diagonal_Dithering = {
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 134, 150, 150, 134, 150, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{134, 150, 150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{134, 150, 150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 150, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 134, 150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,}, 
	{150, 134, 134, 150, 134, 134, 134, 150, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134,},
}

local DiaLines = {
	{-1, -1, 2, 2},
	{-1, 2, 2, -1},
	{2, 2, -1, -1},
	{2, -1, -1, 2},
}

local Blue_DiaLines = {
	{-1, -1, 134, 134},
	{-1, 134, 134, -1},
	{134, 134, -1, -1},
	{134, -1, -1, 134},	
}

local function Scroll_Table(table, index)
	if index < 1 then
		index = #table + index
	end
	
	return table[((index - 1) % #table) + 1]
end

local function Merge_Tables(result, ...)
	local counter = 1
	for _, t in ipairs({...}) do
		for _, v in ipairs(t) do
			result[counter] = v
			counter = $+1
		end
	end
end

local function Split_Table(table, index)
	local actual_index = ((index - 1) % #table) + 1
	
	local table_1 = {}
	for i = 1, actual_index do
		table.insert(table_1, table[i])	
	end
	
	local table_2 = {}
	local next_index = (actual_index % #table) + 1
	for i = next_index, #table do
		table.insert(table_2, table[i])
	end
	
	return table_1, table_2
end

local function Curve_LineInPolygon(polygon, point_id, detail)
	local table_1, table_2 = Split_Table(polygon, point_id)
	local curve = Create_Curve(table_1[#table_1], table_2[1], detail)
	Merge_Tables(table_1, curve, table_2)
	return table_1
end

local function Curve_LineInPolygonAuto(polygon, point_id, dist)
	local table_1, table_2 = Split_Table(polygon, point_id)
	local curve = Create_CurveAuto(table_1[#table_1], table_2[1], dist)
	Merge_Tables(table_1, curve, table_2)
	return table_1
end


local function Draw_Fill_Graphic(v, x, y, width, height, x_offset, y_offset, graphic)
	local y_height = y+height-1
	local x_width = x+width-1
	local current_color = 0
	local next_color = 0
	local repeats = 0
	local offset_x = x_offset
	local offset_y = y_offset

	--print(width_of_graphic, height_of_graphic)

	--v.drawFill(x, y, width, height, color1)

	for current_y = y, y_height, 1 do
		local current_row = Scroll_Table(graphic, current_y+offset_y)
		current_color = Scroll_Table(current_row, x+offset_x)
		repeats = 0
		for current_x = x, x_width, 1 do
			if repeats > 0 then
				repeats = $-1
				continue
			end
			while(true) do
				local locat = Scroll_Table(current_row, current_x+offset_x+repeats)
				if locat == current_color and current_x+repeats < x_width then
					repeats = $+1
				else
					next_color = locat
					break
				end
			end
			if current_x+repeats >= x_width then
				repeats = x_width-current_x
			end
			if current_color ~= nil and current_color <= 255 and current_color >= 0 then
				v.drawFill(current_x, current_y, repeats or 1, 1, current_color)
			end
			current_color = next_color
			repeats = max(repeats-1, 0)
		end
	end
end

-- Sorry, I used GPT...
local function Draw_PolygonFillTextured(v, x_center, y_center, points, texture, x_offset, y_offset, skew_x, skew_y)
	-- Determine the minimum and maximum x-coordinates and y-coordinates
	local ymin, ymax = INT16_MAX, -INT16_MAX
	for i = 1, #points do
		local y = points[i].y
		ymin = min(ymin, y)
		ymax = max(ymax, y)
	end

	-- Iterate over each scanline
	for y = ymin, ymax do
		local intersections = {}
    
		-- Find the intersection points of the scanline with the polygon edges
		for i = 1, #points do
			local p_1, p_2 = points[i], points[(i % #points) + 1]
			local x_1, y_1 = p_1.x, p_1.y
			local x_2, y_2 = p_2.x, p_2.y

			if (y_1 <= y and y < y_2) or (y_2 <= y and y < y_1) then
				local x = x_1 + (x_2 - x_1) * (y - y_1) / (y_2 - y_1)
				table.insert(intersections, x)
			end
		end

		-- Sort the intersection points
		table.sort(intersections)

		-- Fill the regions between consecutive intersection points
		for i = 1, #intersections, 2 do
			local x_1, x_2 = intersections[i], intersections[i + 1]
			if x_1 and x_2 then
				Draw_Fill_Graphic(v, x_center+x_1, y_center+y, x_2 - x_1, 1, x_offset, y_offset, texture, skew_x, skew_y)
			end
		end
	end
end

local function Get_ComplexPolygonEdges(polygon)
	local n_edges = {}
	local ymin, ymax = INT16_MAX, -INT16_MAX
	if #polygon > 1 then
		for i = 1, #polygon do
			local polyline = polygon[i]
			local p_1, p_2
			local next_polyline = polygon[(i % #polygon) + 1]
			local connecting_edge = {}
		
			p_1 = polyline[#polyline]
			p_2 = next_polyline[1]
			table.insert(n_edges, {x_1 = p_1.x, y_1 = p_1.y, x_2 = p_2.x, y_2 = p_2.y})	

			for j = 1, #polyline do
				p_1 = polyline[j]
				p_2 = polyline[(j % #polyline) + 1]
				table.insert(n_edges, {x_1 = p_1.x, y_1 = p_1.y, x_2 = p_2.x, y_2 = p_2.y})
				ymin = min(ymin, p_1.y)
				ymax = max(ymax, p_1.y)			
			end
		
			p_1 = polyline[#polyline]
			p_2 = next_polyline[1]
			table.insert(n_edges, {x_1 = p_1.x, y_1 = p_1.y, x_2 = p_2.x, y_2 = p_2.y})	
		end
	else
		local polyline = polygon[1]
		for j = 1, #polyline do
			local p_1 = polyline[j]
			local p_2 = polyline[(j % #polyline) + 1]
			table.insert(n_edges, {x_1 = p_1.x, y_1 = p_1.y, x_2 = p_2.x, y_2 = p_2.y})
			ymin = min(ymin, p_1.y)
			ymax = max(ymax, p_1.y)	 		
		end
	end
	--print(#edges)
	n_edges.ymin = ymin
	n_edges.ymax = ymax
	return n_edges
end

local function Draw_ComplexPolygonFillTextured(v, x_center, y_center, points, texture, x_offset, y_offset, skew_x, skew_y)
	-- Determine the minimum and maximum x-coordinates and y-coordinates
	local edges = Get_ComplexPolygonEdges(points)
	local ymin, ymax = edges.ymin, edges.ymax

	-- Iterate over each scanline
	for y = ymin, ymax do
		local intersections = {}
    
		-- Find the intersection points of the scanline with the polygon edges
		for i = 1, #edges do
			local edge = edges[i]
			if (edge.y_1 <= y and y < edge.y_2) or (edge.y_2 <= y and y < edge.y_1) then
				local x = edge.x_1 + (edge.x_2 - edge.x_1) * (y - edge.y_1) / (edge.y_2 - edge.y_1)
				table.insert(intersections, x)
			end
		end

		-- Sort the intersection points
		table.sort(intersections)

		-- Fill the regions between consecutive intersection points
		for i = 1, #intersections, 2 do
			local x_1, x_2 = intersections[i], intersections[i + 1]
			if x_1 and x_2 then
				Draw_Fill_Graphic(v, x_center+x_1, y_center+y, x_2 - x_1, 1, x_offset, y_offset, texture, skew_x, skew_y)
			end
		end
	end
end


-- Another GPT assisted functions about clipping
local function Task_PointInsidePolygon(p, cp1, cp2)
	return ((cp2.x - cp1.x) * (p.y - cp1.y)) > ((cp2.y - cp1.y) * (p.x - cp1.x))
end

local function Task_Intersection(cp1, cp2, s, e)
	local dcx, dcy, dpx, dpy, n_1, n_2
	dcx = cp1.x - cp2.x
	dcy = cp1.y - cp2.y
	dpx = s.x - e.x
	dpy = s.y - e.y
	n_1 = cp1.x * cp2.y - cp1.y * cp2.x
	n_2 = s.x * e.y - s.y * e.x
	local n = dcx*dpy - dcy*dpx
	return {
		x = (n_1 * dpx - n_2 * dcx)/n,
		y = (n_1 * dpy - n_2 * dcy)/n,
	}
end

local function Clip_Polygons(subjectPolygon, clippingPolygon)
	local cp1, cp2, s, e
	
	local outputList = subjectPolygon
	
	cp1 = clippingPolygon[#clippingPolygon]
	for j = 1, #clippingPolygon do
		cp2 = clippingPolygon[j]
		local inputList = outputList
		outputList = {}
		s = inputList[#inputList]
		for i = 1, #inputList do
			e = inputList[i]
			if Task_PointInsidePolygon(e, cp1, cp2) then
				if not Task_PointInsidePolygon(s, cp1, cp2)
					table.insert(outputList, Task_Intersection(cp1, cp2, s, e))
				end
				table.insert(outputList, e)
			elseif Task_PointInsidePolygon(s, cp1, cp2) then
				table.insert(outputList, Task_Intersection(cp1, cp2, s, e))
			end
			s = e
		end
		cp1 = cp2
	end	
	return outputList
end

local function Task_GetEdges(polygons)
	local Edges = {}
	
	for i = 1, #polygons do
		local current_polygon = polygons[i]
		if #current_polygon < 3 then continue end
		for j = 1, #current_polygon do
			local point_1 = current_polygon[j]
			local point_2 = current_polygon[j+1 > #current_polygon and 1 or j+1]
			table.insert(Edges, {point_1, point_2})
		end
	end
	
	return Edges
end

local function Task_CalDimensionsEdge(edge)
	local width, height, x, y = 0, 0, 0, 0
	
	local point_1 = edge[1]
	local point_2 = edge[2]
	local edge_dimensions = {
		width = abs(edge[2].x-edge[1].x),
		height = abs(edge[2].y-edge[1].y),
		x = edge[1].x,
		y = edge[1].y,
	}
	
	return edge_dimensions
end

local function Task_HitTest(edge_1, edge_2)
	local data_edge1 = Task_CalDimensionsEdge(edge_1)
	local data_edge2 = Task_CalDimensionsEdge(edge_2)
	
	return (
		(data_edge1.x + data_edge1.width >= data_edge2.x)
		and (data_edge1.x <= data_edge2.x + data_edge2.width)
		and (data_edge1.y + data_edge1.height >= data_edge2.y)
		and (data_edge1.y <= data_edge2.y + data_edge2.height)
	)
end

local function Check_IsLeft(Start_Point, End_Point, Test_Point)
	return (End_Point.x - Start_Point.x) * (Test_Point.y - Start_Point.y) - (Test_Point.x - Start_Point.x) * (End_Point.y - Start_Point.y)
end

local function Task_RemoveInnerEdges(polygons)
	local edges = Task_GetEdges(polygons)
	local outer_edges = {}

	for i = 1, #edges do
		local hit = false
		for j = 1, #edges do
			if i == j then continue end
			if Task_HitTest(edges[i], edges[j]) then 
				hit = true 
				break
			end
		end
		if not hit then
			table.insert(outer_edges, edges[i])
		end
	end
	
	return outer_edges
end

local function Task_EdgeToPolygon(edges)
	local polygon = {}
	
	for i = 1, #edges do
		table.insert(polygon, edges[i][1])
	end
	
	return polygon
end

local function Convert_3DMultipolygonTo2DPolygon(polygons)
	return Task_EdgeToPolygon(Task_RemoveInnerEdges(polygons))
end

local function Offset_MultiPolygon(polygons, x, y)
	local polygon_data = {}
	for i = 1,#polygons do
		local points = polygons[i]
		local point_data = {}
		for l = 1, #points do
			point_data[l] = {x = points[l].x+x, y = points[l].y+y}
		end
		polygon_data[i] = point_data
	end
	return polygon_data
end

local function Offset_Polygon(points, x, y)
	local point_data = {}
	for i = 1, #points do
		point_data[i] = {x = points[i].x+x, y = points[i].y+y}
	end
	return point_data
end

local function Rotate_Polygon(points, angle)
	local point_data = {}
	for i = 1, #points do
		point_data[i] = {x = FixedInt(points[i].x*cos(angle)), y = FixedInt(points[i].y*sin(angle))}
	end
	return point_data
end

local function Shear_Polygon(points, sheer_x, sheer_y, offset_x, offset_y)
	local point_data = {}
	for i = 1, #points do
		point_data[i] = {x = points[i].x+sheer_x*(points[i].y+offset_x), y = points[i].y+sheer_y*(points[i].x+offset_y)}
	end
	return point_data
end

local function Extrude_2DPolygon(polygon, distance, x_off, y_off)
	local point_data = {}
	for i = 1, #polygon do
		local current_vertex = polygon[i]
		local next_vertex = polygon[i % #polygon + 1]
		
		local lenght = R_PointToDist2(current_vertex.x, current_vertex.y, next_vertex.x, next_vertex.y)
		local offset_x = -(next_vertex.y - current_vertex.y)/lenght
		local offset_y = (next_vertex.x - current_vertex.x)/lenght
				
		point_data[i] = {x = current_vertex.x+offset_x*distance+x_off, y = current_vertex.y+offset_y*distance+y_off}
	end
	return point_data
end


local function Rotate2D_Polygon(points, angle)
	local point_data = {}
	for i = 1, #points do
		point_data[i] = {x = FixedInt(points[i].x*cos(angle)-points[i].y*sin(angle)), y = FixedInt(points[i].y*cos(angle)+points[i].x*sin(angle))}
	end
	return point_data
end

local function Rotate2D_MultiPolygon(polygons, angle)
	local polygon_data = {}
	for i = 1,#polygons do
		local points = polygons[i]
		local point_data = {}
		for l = 1, #points do
			point_data[l] = {x = FixedInt(points[i].x*cos(angle)-points[i].y*sin(angle)), y = FixedInt(points[i].y*cos(angle)+points[i].x*sin(angle))}
		end
		polygon_data[i] = point_data
	end
	return polygon_data
end

local function Scale_MultiPolygon(polygons, scale_x, scale_y)
	local polygon_data = {}
	for i = 1,#polygons do
		local points = polygons[i]
		local point_data = {}
		for i = 1, #points do
			point_data[i] = {x = FixedInt(points[i].x*scale_x), y = FixedInt(points[i].y*scale_y)}
		end
		polygon_data[i] = point_data
	end
	return polygon_data
end


local function Scale_Polygon(points, scale_x, scale_y)
	local point_data = {}	
	for i = 1, #points do
		point_data[i] = {x = FixedInt(points[i].x*scale_x), y = FixedInt(points[i].y*scale_y)}
	end
	return point_data
end

local function Clip_MultipolyPoly(polygons, clippingPolygon)
	local new_set_polygons = {}
	for i = 1,#polygons do
		local clip_polygon = Clip_Polygons(polygons[i], clippingPolygon)
		if #clip_polygon > 2 then
			table.insert(new_set_polygons, clip_polygon)
		end
	end
	return new_set_polygons
end

local function Clip_MultipolyPolyReverse(polygons, clippingPolygon)
	local new_set_polygons = {}
	for i = 1,#polygons do
		local clip_polygon = Clip_Polygons(clippingPolygon, polygons[i])
		if #clip_polygon > 2 then
			table.insert(new_set_polygons, clip_polygon)
		end
	end
	return new_set_polygons
end

local Cube_3D = {
	{{x = 0, y = 0, z = 0},
	 {x = 10, y = 0, z = 0},
	 {x = 10, y = 10, z = 0},
	 {x = 0, y = 10, z = 0},
	},
	{{x = 0, y = 0, z = 0},
	 {x = 10, y = 10, z = 0},
	 {x = 0, y = 0, z = 10},
	 {x = 10, y = 10, z = 10},
	},
	{{x = 0, y = 0, z = 0},
	 {x = 10, y = 0, z = 0},
	 {x = 0, y = 0, z = 10},
	 {x = 10, y = 0, z = 10},
	},
	{{x = 10, y = 0, z = 0},
	 {x = 10, y = 10, z = 0},
	 {x = 10, y = 0, z = 10},
	 {x = 10, y = 10, z = 10},
	},
	{{x = 10, y = 10, z = 0},
	 {x = 0, y = 10, z = 0},
	 {x = 10, y = 10, z = 10},
	 {x = 0, y = 10, z = 10},
	},
	{{x = 0, y = 0, z = 10},
	 {x = 10, y = 0, z = 10},
	 {x = 10, y = 10, z = 10},
	 {x = 0, y = 10, z = 10},
	},
}

local emerald_txtmodel = "0.171308,0.103410,0.166015 0.005293,0.103410,0.234781 0.005293,-0.003417,0.000000 \n 0.171308,0.103410,-0.166015 0.240074,0.103410,0.000000 0.005293,-0.003417,0.000000 \n -0.160722,0.103410,-0.166015 0.005293,0.103410,-0.234781 0.005293,-0.003417,0.000000 \n -0.160722,0.103410,0.166015 -0.229488,0.103410,0.000000 0.005293,-0.003417,0.000000 \n 0.420049,1.364935,0.425803 0.591136,1.364935,0.005700 0.289734,1.364935,0.133949 \n -0.414648,1.364935,-0.435149 -0.575366,1.364935,0.000514 -0.275209,1.364935,-0.123277 \n 0.112758,1.364935,-0.289928 0.420049,1.364935,-0.429963 0.000109,1.364935,-0.611489 \n -0.100166,1.364935,0.310452 -0.409463,1.364935,0.446549 0.005293,1.364935,0.612267 \n 0.797253,0.945899,0.791960 0.861339,1.167375,0.323161 0.331914,1.169299,0.851093 \n 0.331914,1.169299,0.851093 0.861339,1.167375,0.323161 0.420049,1.364935,0.425803 \n 0.005293,0.945899,1.120000 0.331914,1.169299,0.851093 -0.367948,1.163763,0.846364 \n -0.367948,1.163763,0.846364 0.331914,1.169299,0.851093 0.005293,1.364935,0.612267 \n -0.275209,1.364935,-0.123277 -0.575366,1.364935,0.000514 -0.100166,1.364935,0.310452 \n -0.100166,1.364935,0.310452 -0.575366,1.364935,0.000514 -0.409463,1.364935,0.446549 \n -0.786667,0.945899,0.791960 -0.367948,1.163763,0.846364 -0.851585,1.169299,0.320672 \n -0.851585,1.169299,0.320672 -0.367948,1.163763,0.846364 -0.409463,1.364935,0.446549 \n -1.114707,0.945899,0.000000 -0.851585,1.169299,0.320672 -0.844095,1.167375,-0.324099 \n -0.844095,1.167375,-0.324099 -0.851585,1.169299,0.320672 -0.575366,1.364935,0.000514 \n 0.289734,1.364935,0.133949 0.591136,1.364935,0.005700 0.112758,1.364935,-0.289928 \n 0.112758,1.364935,-0.289928 0.591136,1.364935,0.005700 0.420049,1.364935,-0.429963 \n -0.786667,0.945899,-0.791960 -0.844095,1.167375,-0.324099 -0.331697,1.163763,-0.850066 \n -0.331697,1.163763,-0.850066 -0.844095,1.167375,-0.324099 -0.414648,1.364935,-0.435149 \n 0.005293,0.945899,-1.120000 -0.331697,1.163763,-0.850066 0.328454,1.167375,-0.856046 \n 0.328454,1.167375,-0.856046 -0.331697,1.163763,-0.850066 0.000109,1.364935,-0.611489 \n 0.289734,1.364935,0.133949 -0.100166,1.364935,0.310452 0.420049,1.364935,0.425803 \n 0.420049,1.364935,0.425803 -0.100166,1.364935,0.310452 0.005293,1.364935,0.612267 \n 0.797253,0.945899,-0.791960 0.328454,1.167375,-0.856046 0.867427,1.163763,-0.320672 \n 0.867427,1.163763,-0.320672 0.328454,1.167375,-0.856046 0.420049,1.364935,-0.429963 \n 0.112758,1.364935,-0.289928 -0.275209,1.364935,-0.123277 0.289734,1.364935,0.133949 \n 0.289734,1.364935,0.133949 -0.275209,1.364935,-0.123277 -0.100166,1.364935,0.310452 \n 0.000109,1.364935,-0.611489 -0.414648,1.364935,-0.435149 0.112758,1.364935,-0.289928 \n 0.112758,1.364935,-0.289928 -0.414648,1.364935,-0.435149 -0.275209,1.364935,-0.123277 \n 0.591136,1.364935,0.005700 0.861339,1.167375,0.323161 0.867427,1.163763,-0.320672 \n 0.867427,1.163763,-0.320672 0.861339,1.167375,0.323161 1.125293,0.945899,0.000000 \n 0.005293,0.103410,0.234781 0.005293,0.945899,1.120000 -0.160722,0.103410,0.166015 \n -0.160722,0.103410,0.166015 0.005293,0.945899,1.120000 -0.786667,0.945899,0.791960 \n 0.240074,0.103410,0.000000 1.125293,0.945899,0.000000 0.171308,0.103410,0.166015 \n 0.171308,0.103410,0.166015 1.125293,0.945899,0.000000 0.797253,0.945899,0.791960 \n 0.005293,0.103410,-0.234781 0.005293,0.945899,-1.120000 0.171308,0.103410,-0.166015 \n 0.171308,0.103410,-0.166015 0.005293,0.945899,-1.120000 0.797253,0.945899,-0.791960 \n -0.229488,0.103410,0.000000 -1.114707,0.945899,0.000000 -0.160722,0.103410,-0.166015 \n -0.160722,0.103410,-0.166015 -1.114707,0.945899,0.000000 -0.786667,0.945899,-0.791960 \n 0.240074,0.103410,0.000000 0.171308,0.103410,0.166015 0.005293,-0.003416,0.000000 \n 0.005293,0.103410,0.234781 -0.160722,0.103410,0.166015 0.005293,-0.003416,0.000000 \n -0.160722,0.103410,-0.166015 0.005293,-0.003416,0.000000 -0.229488,0.103410,0.000000 \n 0.005293,-0.003416,0.000000 0.005293,0.103410,-0.234781 0.171308,0.103410,-0.166015 \n 0.171308,0.103410,0.166015 0.797253,0.945900,0.791960 0.005293,0.103410,0.234781 \n 0.005293,0.103410,0.234781 0.797253,0.945900,0.791960 0.005293,0.945900,1.120000 \n -0.160722,0.103410,0.166015 -0.786667,0.945900,0.791960 -0.229488,0.103410,0.000000 \n -0.229488,0.103410,0.000000 -0.786667,0.945900,0.791960 -1.114707,0.945900,0.000000 \n -0.160722,0.103410,-0.166015 -0.786667,0.945900,-0.791960 0.005293,0.103410,-0.234781 \n 0.005293,0.103410,-0.234781 -0.786667,0.945900,-0.791960 0.005293,0.945900,-1.120000 \n 0.171308,0.103410,-0.166015 0.797253,0.945900,-0.791960 0.240074,0.103410,0.000000 \n 0.240074,0.103410,0.000000 0.797253,0.945900,-0.791960 1.125293,0.945900,-0.000000 \n -0.851585,1.169391,0.320564 -1.114707,0.945900,0.000013 -0.786667,0.946127,0.791916 \n -0.331697,1.163812,-0.850041 -0.414648,1.364810,-0.435314 0.000108,1.364759,-0.611653 \n -0.844095,1.167282,-0.324206 -0.786667,0.945945,-0.791947 -1.114707,0.945900,0.000013 \n -0.331697,1.163812,-0.850041 0.005293,0.945578,-1.120043 -0.786667,0.945945,-0.791947 \n 0.328454,1.167130,-0.856154 0.797253,0.945672,-0.792003 0.005293,0.945578,-1.120043 \n 0.867427,1.163671,-0.320778 1.125293,0.945900,-0.000044 0.797253,0.945672,-0.792003 \n -0.844095,1.167282,-0.324206 -0.575366,1.364935,0.000349 -0.414648,1.364810,-0.435314 \n 0.861339,1.167469,0.323053 0.797253,0.946127,0.791916 1.125293,0.945900,-0.000044 \n 0.331914,1.169543,0.850985 0.005293,0.946222,1.119956 0.797253,0.946127,0.791916 \n -0.367948,1.164006,0.846257 -0.786667,0.946127,0.791916 0.005293,0.946222,1.119956 \n -0.851585,1.169391,0.320564 -0.409463,1.365063,0.446385 -0.575366,1.364935,0.000349 \n -0.367948,1.164006,0.846257 0.005293,1.365111,0.612102 -0.409463,1.365063,0.446385 \n 0.331914,1.169543,0.850985 0.420049,1.365057,0.425639 0.005293,1.365111,0.612102 \n 0.861339,1.167469,0.323053 0.591136,1.364936,0.005536 0.420049,1.365057,0.425639 \n 0.328454,1.167130,-0.856154 0.000108,1.364759,-0.611653 0.420049,1.364811,-0.430127 \n 0.867427,1.163671,-0.320778 0.420049,1.364811,-0.430127 0.591136,1.364936,0.005536"
local ring_txtmodel = "0.603992,1.606003,0.698965 0.603992,1.606003,0.698965 0.018295,1.916061,1.961268 \n 0.602154,1.215805,1.281239 0.603992,1.606003,0.698965 0.018295,1.916061,1.961268 \n 0.602154,1.215805,1.281239 0.018295,1.916061,1.961268 0.012718,1.027603,2.553221 \n 0.598495,0.634888,1.668283 0.602154,1.215805,1.281239 0.012718,1.027603,2.553221 \n 0.598495,0.634888,1.668283 0.012718,1.027603,2.553221 0.005188,-0.017334,2.756467 \n 0.593601,-0.048355,1.801186 0.598495,0.634888,1.668283 0.005188,-0.017334,2.756467 \n 0.593601,-0.048355,1.801186 0.005188,-0.017334,2.756467 -0.003113,-1.059601,2.540069 \n 0.588165,-0.729843,1.659692 0.593601,-0.048355,1.801186 -0.003113,-1.059601,2.540069 \n 0.588165,-0.729843,1.659692 -0.003113,-1.059601,2.540069 -0.010941,-1.940582,1.936971 \n 0.583046,-1.305847,1.265361 0.588165,-0.729843,1.659692 -0.010941,-1.940582,1.936971 \n 0.583046,-1.305847,1.265361 -0.010941,-1.940582,1.936971 -0.017113,-2.526115,1.038986 \n 0.579014,-1.688705,0.678214 0.583046,-1.305847,1.265361 -0.017113,-2.526115,1.038986 \n 0.579014,-1.688705,0.678214 -0.017113,-2.526115,1.038986 -0.020664,-2.727066,-0.017174 \n 0.576691,-1.820099,-0.012350 0.579014,-1.688705,0.678214 -0.020664,-2.727066,-0.017174 \n 0.576691,-1.820099,-0.012350 -0.020664,-2.727066,-0.017174 -0.021099,-2.512840,-1.070726 \n 0.576408,-1.680023,-0.701211 0.576691,-1.820099,-0.012350 -0.021099,-2.512840,-1.070726 \n 0.576408,-1.680023,-0.701211 -0.021099,-2.512840,-1.070726 -0.018280,-1.916092,-1.961256 \n 0.578236,-1.289825,-1.283490 0.576408,-1.680023,-0.701211 -0.018280,-1.916092,-1.961256 \n 0.578236,-1.289825,-1.283490 -0.018280,-1.916092,-1.961256 -0.012711,-1.027588,-2.553218 \n 0.581890,-0.708908,-1.670537 0.578236,-1.289825,-1.283490 -0.012711,-1.027588,-2.553218 \n 0.581890,-0.708908,-1.670537 -0.012711,-1.027588,-2.553218 -0.005188,0.017319,-2.756467 \n 0.586803,-0.025696,-1.803429 0.581890,-0.708908,-1.670537 -0.005188,0.017319,-2.756467 \n 0.586803,-0.025696,-1.803429 -0.005188,0.017319,-2.756467 0.003113,1.059616,-2.540073 \n 0.592228,0.655807,-1.661942 0.586803,-0.025696,-1.803429 0.003113,1.059616,-2.540073 \n 0.592228,0.655807,-1.661942 0.003113,1.059616,-2.540073 0.010948,1.940567,-1.936970 \n 0.597355,1.231827,-1.267607 0.592228,0.655807,-1.661942 0.010948,1.940567,-1.936970 \n 0.597355,1.231827,-1.267607 0.010948,1.940567,-1.936970 0.017120,2.526108,-1.038985 \n 0.601387,1.614670,-0.680459 0.597355,1.231827,-1.267607 0.017120,2.526108,-1.038985 \n 0.601387,1.614670,-0.680459 0.017120,2.526108,-1.038985 0.020672,2.727081,0.017174 \n 0.603710,1.746078,0.010109 0.601387,1.614670,-0.680459 0.020672,2.727081,0.017174 \n 0.603710,1.746078,0.010109 0.020672,2.727081,0.017174 0.021095,2.512848,1.070729 \n 0.603992,1.606003,0.698965 0.603710,1.746078,0.010109 0.021095,2.512848,1.070729 \n 0.603992,1.606003,0.698965 0.021095,2.512848,1.070729 0.018295,1.916061,1.961268 \n 0.018295,1.916061,1.961268 0.603992,1.606003,0.698965 0.018295,1.916061,1.961268 \n 0.018295,1.916061,1.961268 0.018295,1.916061,1.961268 0.603992,1.606003,0.698965 \n 0.603992,1.606003,0.698965 0.018295,1.916061,1.961268 0.603992,1.606003,0.698965 \n 0.603992,1.606003,0.698965 0.603992,1.606003,0.698965 -0.576691,1.820099,0.012350 \n 0.603710,1.746078,0.010109 0.603992,1.606003,0.698965 -0.576691,1.820099,0.012350 \n 0.603710,1.746078,0.010109 -0.576691,1.820099,0.012350 -0.579014,1.688721,-0.678214 \n 0.601387,1.614670,-0.680459 0.603710,1.746078,0.010109 -0.579014,1.688721,-0.678214 \n 0.601387,1.614670,-0.680459 -0.579014,1.688721,-0.678214 -0.583046,1.305862,-1.265358 \n 0.597355,1.231827,-1.267607 0.601387,1.614670,-0.680459 -0.583046,1.305862,-1.265358 \n 0.597355,1.231827,-1.267607 -0.583046,1.305862,-1.265358 -0.588169,0.729828,-1.659693 \n 0.592228,0.655807,-1.661942 0.597355,1.231827,-1.267607 -0.588169,0.729828,-1.659693 \n 0.592228,0.655807,-1.661942 -0.588169,0.729828,-1.659693 -0.593597,0.048340,-1.801183 \n 0.586803,-0.025696,-1.803429 0.592228,0.655807,-1.661942 -0.593597,0.048340,-1.801183 \n 0.586803,-0.025696,-1.803429 -0.593597,0.048340,-1.801183 -0.598511,-0.634857,-1.668289 \n 0.581890,-0.708908,-1.670537 0.586803,-0.025696,-1.803429 -0.598511,-0.634857,-1.668289 \n 0.581890,-0.708908,-1.670537 -0.598511,-0.634857,-1.668289 -0.602150,-1.215805,-1.281237 \n 0.578236,-1.289825,-1.283490 0.581890,-0.708908,-1.670537 -0.602150,-1.215805,-1.281237 \n 0.578236,-1.289825,-1.283490 -0.602150,-1.215805,-1.281237 -0.603985,-1.605988,-0.698959 \n 0.576408,-1.680023,-0.701211 0.578236,-1.289825,-1.283490 -0.603985,-1.605988,-0.698959 \n 0.576408,-1.680023,-0.701211 -0.603985,-1.605988,-0.698959 -0.603718,-1.746063,-0.010110 \n 0.576691,-1.820099,-0.012350 0.576408,-1.680023,-0.701211 -0.603718,-1.746063,-0.010110 \n 0.576691,-1.820099,-0.012350 -0.603718,-1.746063,-0.010110 -0.601391,-1.614670,0.680458 \n 0.579014,-1.688705,0.678214 0.576691,-1.820099,-0.012350 -0.601391,-1.614670,0.680458 \n 0.579014,-1.688705,0.678214 -0.601391,-1.614670,0.680458 -0.597347,-1.231827,1.267611 \n 0.583046,-1.305847,1.265361 0.579014,-1.688705,0.678214 -0.597347,-1.231827,1.267611 \n 0.583046,-1.305847,1.265361 -0.597347,-1.231827,1.267611 -0.592236,-0.655792,1.661940 \n 0.588165,-0.729843,1.659692 0.583046,-1.305847,1.265361 -0.592236,-0.655792,1.661940 \n 0.588165,-0.729843,1.659692 -0.592236,-0.655792,1.661940 -0.586807,0.025681,1.803429 \n 0.593601,-0.048355,1.801186 0.588165,-0.729843,1.659692 -0.586807,0.025681,1.803429 \n 0.593601,-0.048355,1.801186 -0.586807,0.025681,1.803429 -0.581890,0.708893,1.670535 \n 0.598495,0.634888,1.668283 0.593601,-0.048355,1.801186 -0.581890,0.708893,1.670535 \n 0.598495,0.634888,1.668283 -0.581890,0.708893,1.670535 -0.578239,1.289841,1.283486 \n 0.602154,1.215805,1.281239 0.598495,0.634888,1.668283 -0.578239,1.289841,1.283486 \n 0.602154,1.215805,1.281239 -0.578239,1.289841,1.283486 -0.576405,1.680038,0.701215 \n 0.603992,1.606003,0.698965 0.602154,1.215805,1.281239 -0.576405,1.680038,0.701215 \n 0.603992,1.606003,0.698965 -0.576405,1.680038,0.701215 -0.576691,1.820099,0.012350 \n -0.576691,1.820099,0.012350 0.603992,1.606003,0.698965 -0.576691,1.820099,0.012350 \n -0.576691,1.820099,0.012350 -0.576691,1.820099,0.012350 -0.583046,1.305862,-1.265358 \n -0.583046,1.305862,-1.265358 -0.576691,1.820099,0.012350 -0.583046,1.305862,-1.265358 \n -0.583046,1.305862,-1.265358 -0.583046,1.305862,-1.265358 0.003113,1.059616,-2.540073 \n -0.588169,0.729828,-1.659693 -0.583046,1.305862,-1.265358 0.003113,1.059616,-2.540073 \n -0.588169,0.729828,-1.659693 0.003113,1.059616,-2.540073 -0.005188,0.017319,-2.756467 \n -0.593597,0.048340,-1.801183 -0.588169,0.729828,-1.659693 -0.005188,0.017319,-2.756467 \n -0.593597,0.048340,-1.801183 -0.005188,0.017319,-2.756467 -0.012711,-1.027588,-2.553218 \n -0.598511,-0.634857,-1.668289 -0.593597,0.048340,-1.801183 -0.012711,-1.027588,-2.553218 \n -0.598511,-0.634857,-1.668289 -0.012711,-1.027588,-2.553218 -0.018280,-1.916092,-1.961256 \n -0.602150,-1.215805,-1.281237 -0.598511,-0.634857,-1.668289 -0.018280,-1.916092,-1.961256 \n -0.602150,-1.215805,-1.281237 -0.018280,-1.916092,-1.961256 -0.021099,-2.512840,-1.070726 \n -0.603985,-1.605988,-0.698959 -0.602150,-1.215805,-1.281237 -0.021099,-2.512840,-1.070726 \n -0.603985,-1.605988,-0.698959 -0.021099,-2.512840,-1.070726 -0.020664,-2.727066,-0.017174 \n -0.603718,-1.746063,-0.010110 -0.603985,-1.605988,-0.698959 -0.020664,-2.727066,-0.017174 \n -0.603718,-1.746063,-0.010110 -0.020664,-2.727066,-0.017174 -0.017113,-2.526115,1.038986 \n -0.601391,-1.614670,0.680458 -0.603718,-1.746063,-0.010110 -0.017113,-2.526115,1.038986 \n -0.601391,-1.614670,0.680458 -0.017113,-2.526115,1.038986 -0.010941,-1.940582,1.936971 \n -0.597347,-1.231827,1.267611 -0.601391,-1.614670,0.680458 -0.010941,-1.940582,1.936971 \n -0.597347,-1.231827,1.267611 -0.010941,-1.940582,1.936971 -0.003113,-1.059601,2.540069 \n -0.592236,-0.655792,1.661940 -0.597347,-1.231827,1.267611 -0.003113,-1.059601,2.540069 \n -0.592236,-0.655792,1.661940 -0.003113,-1.059601,2.540069 0.005188,-0.017334,2.756467 \n -0.586807,0.025681,1.803429 -0.592236,-0.655792,1.661940 0.005188,-0.017334,2.756467 \n -0.586807,0.025681,1.803429 0.005188,-0.017334,2.756467 0.012718,1.027603,2.553221 \n -0.581890,0.708893,1.670535 -0.586807,0.025681,1.803429 0.012718,1.027603,2.553221 \n -0.581890,0.708893,1.670535 0.012718,1.027603,2.553221 0.018295,1.916061,1.961268 \n -0.578239,1.289841,1.283486 -0.581890,0.708893,1.670535 0.018295,1.916061,1.961268 \n -0.578239,1.289841,1.283486 0.018295,1.916061,1.961268 0.021095,2.512848,1.070729 \n -0.576405,1.680038,0.701215 -0.578239,1.289841,1.283486 0.021095,2.512848,1.070729 \n -0.576405,1.680038,0.701215 0.021095,2.512848,1.070729 0.020672,2.727081,0.017174 \n -0.576691,1.820099,0.012350 -0.576405,1.680038,0.701215 0.020672,2.727081,0.017174 \n -0.576691,1.820099,0.012350 0.020672,2.727081,0.017174 0.017120,2.526108,-1.038985 \n -0.579014,1.688721,-0.678214 -0.576691,1.820099,0.012350 0.017120,2.526108,-1.038985 \n -0.579014,1.688721,-0.678214 0.017120,2.526108,-1.038985 0.010948,1.940567,-1.936970 \n -0.583046,1.305862,-1.265358 -0.579014,1.688721,-0.678214 0.010948,1.940567,-1.936970 \n -0.583046,1.305862,-1.265358 0.010948,1.940567,-1.936970 0.003113,1.059616,-2.540073 \n 0.003113,1.059616,-2.540073 -0.583046,1.305862,-1.265358 0.003113,1.059616,-2.540073"
local TEN_FRACUNIT = 10*FRACUNIT

local function Load_TxtModel(txt)
	local str_model = {}
	for line in string.gmatch(txt, "[^\n]+") do
		table.insert(str_model, line)
	end
	
	for i = 1,#str_model do
		local tri = {}
		for line in string.gmatch(str_model[i], "%S+") do
			table.insert(tri, line)
		end	
		
		for l = 1, 3 do
			local str = tri[l]
			local get_tab = {}
			for line in string.gmatch(str, "([^,]+)") do
				local test = string.gsub(line, "%.", "")
				table.insert(get_tab, test)
			end
			tri[l] = {x = tonumber(get_tab[1]/1000)*FRACUNIT, y = tonumber(get_tab[3]/1000)*FRACUNIT, z = tonumber(get_tab[2]/1000)*FRACUNIT}
		end
		str_model[i] = tri
	end
	
	return str_model
end

local function Load_TxtModelIO(file_name)
	local str_model = {}
	local file = io.openlocal("bluespring/mario/"..file_name..".txt", "r")
	if file then
		for line in file:lines() do
			table.insert(str_model, line)
		end
		file:close()
	end
	
	for i = 1,#str_model do
		local tri = {}
		for line in string.gmatch(str_model[i], "%S+") do
			table.insert(tri, line)
		end	
		
		for l = 1, 3 do
			local str = tri[l]
			local get_tab = {}
			for line in string.gmatch(str, "([^,]+)") do
				local test = string.gsub(line, "%.", "")
				table.insert(get_tab, test)
			end
			tri[l] = {x = tonumber(get_tab[1]/1000)*FRACUNIT, y = tonumber(get_tab[3]/1000)*FRACUNIT, z = tonumber(get_tab[2]/1000)*FRACUNIT}
		end
		str_model[i] = tri
	end
	
	return str_model
end

local emerald_model = Load_TxtModel(emerald_txtmodel)
local ring_model = Load_TxtModel(ring_txtmodel)
local sonic_model = Load_TxtModelIO("sonic")
local star_model = Load_TxtModelIO("star")
local mariohead_model = Load_TxtModelIO("mariohead")


local function dotProduct(v_1, v_2)
	return v_1.x*v_2.x + v_1.y*v_2.y + v_1.z*v_2.z
end

local function dotProductFixed(v_1, v_2)
	return FixedMul(v_1.x, v_2.x) + FixedMul(v_1.y, v_2.y) + FixedMul(v_1.z, v_2.z)
end

--local view_vector = {x = 0, y = 0, z = -FRACUNIT}

local function Inter_BackfaceCulling(polygon, view_vector)
	if #polygon > 3 then return true end
	local vertex1 = polygon[1]
	local vertex2 = polygon[2]
	local vertex3 = polygon[3]
	
	local edge1 = {x = vertex2.x - vertex1.x, y = vertex2.y - vertex1.y, z = vertex2.z - vertex1.z}
	local edge2 = {x = vertex3.x - vertex1.x, y = vertex3.y - vertex1.y, z = vertex3.z - vertex1.z}
	local normal = {
		x = FixedMul(edge1.y, edge2.z) - FixedMul(edge1.z, edge2.y),
		y = FixedMul(edge1.z, edge2.x) - FixedMul(edge1.x, edge2.z),
		z = FixedMul(edge1.x, edge2.y) - FixedMul(edge1.y, edge2.x),
	}
	
	local dot = dotProductFixed(normal, view_vector)
	
	return (dot <= 0 and false or true)
end



local function Inter_3Dto2DPolygonFixed(polygons_3D, pitch, roll, yaw, dist)
	local polygons = {}
	local cosa = cos(yaw)
	local sina = sin(yaw)
	
	local cosb = cos(pitch)
	local sinb = sin(pitch)

	local cosc = cos(roll)
	local sinc = sin(roll)
	
	local Axx = FixedMul(cosa, cosb)
	local Axy = FixedMul(FixedMul(cosa, sinb), sinc) - FixedMul(sina, cosc)
	local Axz = FixedMul(FixedMul(cosa, sinb), cosc) + FixedMul(sina, sinc)
	
	local Ayx = FixedMul(sina, cosb)
	local Ayy = FixedMul(FixedMul(sina, sinb), sinc) + FixedMul(cosa, cosc)
	local Ayz = FixedMul(FixedMul(sina, sinb), cosc) - FixedMul(cosa, sinc)	
	
	local Azx = -sinb
	local Azy = FixedMul(cosb, sinc)
	local Azz = FixedMul(cosb, cosc)	
	
	for i = 1,#polygons_3D do
		local points_3D = polygons_3D[i]
		local point_data = {}
		local poly_dist = 0
		local conv_3D = {}
		local min_scale = INT32_MAX
		local max_scale = -INT32_MAX		
		for l = 1, #points_3D do
			local x_3D = FixedMul(points_3D[l].x, Axx) + FixedMul(points_3D[l].y, Axy) + FixedMul(points_3D[l].z, Axz)
			local y_3D = FixedMul(points_3D[l].x, Ayx) + FixedMul(points_3D[l].y, Ayy) + FixedMul(points_3D[l].z, Ayz)
			local z_3D = FixedMul(points_3D[l].x, Azx) + FixedMul(points_3D[l].y, Azy) + FixedMul(points_3D[l].z, Azz)
			table.insert(conv_3D, {x = x_3D, y = y_3D, z = z_3D})
			
			point_data[l] = R_WorldToScreen2({x = 0, y = 0, z = 0, angle = 0, aiming = 0}, {x = x_3D+dist*cos(0), y = y_3D+dist*sin(0), z = z_3D})
			point_data[l].x = FixedInt(point_data[l].x)
			point_data[l].y = FixedInt(point_data[l].y)
			min_scale = min(point_data[l].scale, min_scale)
			max_scale = max(point_data[l].scale, max_scale)			
		end
		if Inter_BackfaceCulling(conv_3D, {x = 0, y = 0, z = -FRACUNIT}) then
			polygons[i] = point_data		
			polygons[i].dist = max_scale-min_scale
		end
	end
	table.sort(polygons, function(a, b) return a.dist < b.dist end)
	return polygons
end

local function Inter_3Dto2DPolygonFixedPoints(polygons_3D, pitch, roll, yaw, dist)
	local polygon = {}
	local cosa = cos(yaw)
	local sina = sin(yaw)
	
	local cosb = cos(pitch)
	local sinb = sin(pitch)

	local cosc = cos(roll)
	local sinc = sin(roll)
	
	local Axx = FixedMul(cosa, cosb)
	local Axy = FixedMul(FixedMul(cosa, sinb), sinc) - FixedMul(sina, cosc)
	local Axz = FixedMul(FixedMul(cosa, sinb), cosc) + FixedMul(sina, sinc)
	
	local Ayx = FixedMul(sina, cosb)
	local Ayy = FixedMul(FixedMul(sina, sinb), sinc) + FixedMul(cosa, cosc)
	local Ayz = FixedMul(FixedMul(sina, sinb), cosc) - FixedMul(cosa, sinc)	
	
	local Azx = -sinb
	local Azy = FixedMul(cosb, sinc)
	local Azz = FixedMul(cosb, cosc)	
	
	for i = 1,#polygons_3D do
		local points_3D = polygons_3D[i]
		local point_data = {}
		local poly_dist = 0
		local conv_3D = {}
		local min_scale = INT32_MAX
		local max_scale = -INT32_MAX		
		for l = 1, #points_3D do
			local x_3D = FixedMul(points_3D[l].x, Axx) + FixedMul(points_3D[l].y, Axy) + FixedMul(points_3D[l].z, Axz)
			local y_3D = FixedMul(points_3D[l].x, Ayx) + FixedMul(points_3D[l].y, Ayy) + FixedMul(points_3D[l].z, Ayz)
			local z_3D = FixedMul(points_3D[l].x, Azx) + FixedMul(points_3D[l].y, Azy) + FixedMul(points_3D[l].z, Azz)
			table.insert(conv_3D, {x = x_3D, y = y_3D, z = z_3D})
			
			point_data[l] = R_WorldToScreen2({x = 0, y = 0, z = 0, angle = 0, aiming = 0}, {x = x_3D+dist*cos(0), y = y_3D+dist*sin(0), z = z_3D})
			point_data[l].x = FixedInt(point_data[l].x)
			point_data[l].y = FixedInt(point_data[l].y)
			min_scale = min(point_data[l].scale, min_scale)
			max_scale = max(point_data[l].scale, max_scale)
			table.insert(polygon, point_data[l])
		end
	end
	return polygon
end


local function Inter_3Dto2DPolygon(polygons_3D, pitch, roll, yaw, dist)
	local polygons = {}
	local cosa = cos(yaw)
	local sina = sin(yaw)
	
	local cosb = cos(pitch)
	local sinb = sin(pitch)

	local cosc = cos(roll)
	local sinc = sin(roll)
	
	local Axx = FixedMul(cosa, cosb)
	local Axy = FixedMul(FixedMul(cosa, sinb), sinc) - FixedMul(sina, cosc)
	local Axz = FixedMul(FixedMul(cosa, sinb), cosc) + FixedMul(sina, sinc)
	
	local Ayx = FixedMul(sina, cosb)
	local Ayy = FixedMul(FixedMul(sina, sinb), sinc) + FixedMul(cosa, cosc)
	local Ayz = FixedMul(FixedMul(sina, sinb), cosc) - FixedMul(cosa, sinc)	
	
	local Azx = -sinb
	local Azy = FixedMul(cosb, sinc)
	local Azz = FixedMul(cosb, cosc)	
	
	for i = 1,#polygons_3D do
		local points_3D = polygons_3D[i]
		local point_data = {}
		local min_scale = INT32_MAX
		local max_scale = -INT32_MAX
		for l = 1, #points_3D do
			local x = points_3D[l].x*Axx + points_3D[l].y*Axy + points_3D[l].z*Axz
			local y = points_3D[l].x*Ayx + points_3D[l].y*Ayy + points_3D[l].z*Ayz
			local z = points_3D[l].x*Azx + points_3D[l].y*Azy + points_3D[l].z*Azz
			
			point_data[l] = R_WorldToScreen2({x = 0, y = 0, z = 0, angle = 0, aiming = 0}, {x = x+dist*cos(0), y = y+dist*sin(0), z = z})
			point_data[l].x = FixedInt(point_data[l].x)
			point_data[l].y = FixedInt(point_data[l].y)
			min_scale = min(point_data[l].scale, min_scale)
			max_scale = max(point_data[l].scale, max_scale)
		end
		polygons[i] = point_data
		polygons[i].scale = max_scale-min_scale
	end
	table.sort(polygons, function(a, b) return a.scale > b.scale end)
	return polygons
end

local function Inter_3Dinto2DOutlinePolygonFixed(polygons_3D, pitch, roll, yaw, dist)
	return Convert_3DMultipolygonTo2DPolygon(Inter_3Dto2DPolygonFixed(polygons_3D, pitch, roll, yaw, dist))
end

local function Draw_MultiPolygonFill(v, x_center, y_center, polygons, color_func)
	for i = 1,#polygons do
		Draw_PolygonFill(v, x_center, y_center, polygons[i], color_func(i, polygons[i][1].x, polygons[i][1].y))
	end
end

local function Draw_MultiPolygonLine(v, x_center, y_center, polygons, color_func)
	for i = 1,#polygons do
		Draw_PolygonLine(v, x_center, y_center, polygons[i], color_func(i, polygons[i][1].x, polygons[i][1].y))
	end
end

local function Draw_MultiPolygonLineThick(v, x_center, y_center, polygons, color_func, thickness)
	for i = 1,#polygons do
		Draw_PolygonLineThick(v, x_center, y_center, polygons[i], color_func(i, polygons[i][1].x, polygons[i][1].y), thickness)
	end
end


--local sonic_precached_rotation = {}

--for i = 1, 360, 15 do
--	table.insert(sonic_precached_rotation, Inter_3Dinto2DOutlinePolygonFixed(sonic_model, 0, 0, ANG1*i, 1000))
--end


local function Init_PolylineCounterProgress(polygon, progress)
	local max_length = 0
	local inv_lengths = {}
	for i = 1,#polygon do
		if not polygon[i+1] then break end
		local x = abs(polygon[i].x-polygon[i+1].x)
		local y = abs(polygon[i].y-polygon[i+1].y)
		inv_lengths[i] = R_PointToDist2(0, 0, x, y)
		max_length = $+inv_lengths[i]
	end
	local length = FixedInt(FixedMul(max_length << FRACUNIT, progress))
	local new_polyline = {polygon[1]}
	for i = 1,#inv_lengths do
		length = $-inv_lengths[i]
		if length < 0 then
			local prog_line = ((inv_lengths[i]+length) << FRACBITS)/inv_lengths[i]
			new_polyline[i+1] = {
				x = ease.linear(prog_line, polygon[i].x, polygon[i+1].x),
				y = ease.linear(prog_line, polygon[i].y, polygon[i+1].y),
			}
			break
		else
			table.insert(new_polyline, polygon[i+1])
		end
	end
	return new_polyline
end

local function Draw_PolygonLineThickProgress(v, x_center, y_center, polygon, color, thickness, progress)
	Draw_PolyLineThick(v, x_center, y_center, Init_PolylineCounterProgress(polygon, progress), color, thickness)
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

local function Draw_Triangle_Wave(v, y_center, wave_width, wave_radius, offset, color)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = rest_of_x, width, 1 do
		local act = abs(x)+offset
		local y = (act % wave_radius*4) > (wave_radius*2) and (act % wave_radius*2) - wave_radius or -(act % wave_radius*2) + wave_radius
		local height_new = wave_radius-y
		v.drawFill(x, y_center+y, 1, height_new, color)
	end
	
	v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_Triangle_Wave_Yoffset(v, y_center, wave_width, wave_radius, x_offset, y_offset, color)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = rest_of_x, width, 1 do
		local act = abs(x)+x_offset
		local y = ((act % wave_radius*4) > (wave_radius*2) and (act % wave_radius*2) - wave_radius or -(act % wave_radius*2) + wave_radius)+FixedInt(y_offset*x)
		local height_new = rest_of_y_central+wave_radius-y
		v.drawFill(x, y_center+y, 1, height_new, color)
	end
	
	--v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_Triangle_Wave_Yoffset_XMaxMin(v, y_center, wave_width, wave_radius, x_offset, y_offset, min_x, max_x, color)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = min_x, max_x, 1 do
		local act = abs(x)+x_offset
		local y = ((act % wave_radius*4) > (wave_radius*2) and (act % wave_radius*2) - wave_radius or -(act % wave_radius*2) + wave_radius)+FixedInt(y_offset*x)
		local height_new = rest_of_y_central+wave_radius-y
		v.drawFill(x, y_center+y, 1, height_new, color)
	end
	
	--v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_Fill_Pattern(v, x, y, width, height, square_width, square_height, x_offset, y_offset, skew, color1, color2, color3)
	local colorswitch, square_cal
	local y_height = y+height
	local x_width = x+width
	local actual_widthness = 2*square_width

	for current_y = y, y_height do
		square_cal = square_width*((current_y+y_offset)/square_height)+x_offset+FixedInt(current_y*skew)
		for current_x = x, x_width do
			colorswitch = ((current_x+square_cal) % actual_widthness)-square_width
			v.drawFill(current_x, current_y, 1, 1, (colorswitch > 0 and color1 or (colorswitch < 0 and color2 or color3)))
		end
	end
end

local function Draw_Triangle_Wave_Yoffset_Pattern(v, y_center, wave_width, wave_radius, x_offset, y_offset, square_width, square_height, square_offset_x, square_offset_y, sqaure_skew, color1, color2, color3)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = 0, width, 1 do
		local act = abs(x)+x_offset
		local y = ((act % wave_radius*4) > (wave_radius*2) and (act % wave_radius*2) - wave_radius or -(act % wave_radius*2) + wave_radius)+FixedInt(y_offset*x)
		local height_new = rest_of_y_central+wave_radius-y
		Draw_Fill_Pattern(v, x, y_center+y, 1, height_new, square_width, square_height, square_offset_x, square_offset_y, sqaure_skew, color1, color2, color3)
	end
	
	--v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_Triangle_LineWave_Yoffset(v, y_center, wave_width, wave_radius, x_offset, y_offset, line_radius, color)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = rest_of_x, width, 1 do
		local act = abs(x)+x_offset
		local y = ((act % wave_radius*4) > (wave_radius*2) and (act % wave_radius*2) - wave_radius or -(act % wave_radius*2) + wave_radius)+FixedInt(y_offset*x)
		v.drawFill(x, y_center+y, 1, line_radius, color)
	end
	
	--v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_Inner_Sin_Wave(v, y_center, wave_width, wave_radius, offset, color)
	local width = v.width()
	local height = v.height()
	local rest_of_x = -(width-320)/2
	--local rest_of_y = -(height-200)/2
	local rest_of_y_central = height-(y_center+wave_radius)
	local actual_width = wave_width

	for x = rest_of_x, width, 1 do
		local y = FixedInt(wave_radius*sin(actual_width*x+offset))
		local height_new = wave_radius-y
		v.drawFill(x, y_center+y, 1, height_new, color)
	end
	
	v.drawFill(rest_of_x, y_center+wave_radius, width-rest_of_x, y_offset_central, color)
end

local function Draw_MarioCircle(v, x_center, y_center, radius)
	Draw_inner_circle(v, x_center, y_center, radius+18, 31)
	--for i = 1,6 do
	--	Draw_circle(v, x_center, y_center, radius+i, 72)
	--	Draw_circle(v, x_center, y_center, radius+6+i, 37)
	--	Draw_circle(v, x_center, y_center, radius+12+i, 150)
	--end
	Draw_Thick_Circle(v, x_center, y_center, radius+1, radius+8, 72)
	Draw_Thick_Circle(v, x_center, y_center, radius+6, radius+13, 37)
	Draw_Thick_Circle(v, x_center, y_center, radius+12, radius+19, 150)
end

local function Generate_Triangular_Pattern(x, y, color_1, color_2)
	return ((x + y) % 2) == 0 and color_1 or color_2
end

local dot_img = { 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 136, 136, 136, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 137, 137, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 138, -1, 138, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 138, 138, 138, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 138, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 137, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, -1, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 138, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 137, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 138, 138, 138, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 138, -1, 138, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 136, 136, 136, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 137, 137, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, 137, 137, 137, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 137, 137, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 138, -1, 138, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 137, 137, -1, 138, 138, 138, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 137, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, -1, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 137, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, 138, -1, 138, 137, 137, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 136, 136, -1, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 137, 137, -1, 138, 138, 138, 137, 137, 137, 137, 137, 137, 137, 138, 137, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, -1, -1, -1, -1, -1, -1, 136, 136, 136, 136, 136, 136, 136, 138, -1, 138, -1, 138, -1, 137, 137, 137, 137, 137, 137, 137, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 136, 136, 136, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, 137, 137, 137, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 137, 137, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 137, 138, 137, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
 {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, -1, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 138, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, }, 
}

local function Replace_Color(img, rep_table)
	local new_img = {}
	for y = 1, #img do
		local x_row = img[y]
		new_img[y] = {} 
		for x = 1, #x_row do
			table.insert(new_img[y], rep_table[x_row[x]] or x_row[x])
		end
	end
	return new_img
end


local bayerMatrix = {
	{1, 9, 3, 11},
	{13, 5, 15, 7},
	{4, 12, 2, 10},
	{16, 8, 14, 6},
}

local function Generate_Dithering_Pattern(x, y, color_1, color_2)
	local threshold = bayerMatrix[(y-1) % 4 + 1][(x-1) % 4 + 1]
	return (threshold <= (x % 16)) and color_1 or color_2
end

local function Generate_PatternGraphic(width, height, pattern_fn)
	local pattern
	for y = 1, height do
		pattern[y] = {}
		for x = 1, width do
			pattern[y][x] = pattern_fn(x, y) 
		end
	end

	return pattern
end

local poly_line_pr_test = {
	{x = 200, y = 100},
	{x = 200-47, y = 100},
	{x = 200-53, y = 106},
	{x = 200-59, y = 100},
	{x = 200-125, y = 100},
}

local poly_line_pr_test_og = {
	{x = 0, y = 0},
	{x = -47, y = 0},
	{x = -53, y = 6},
	{x = -59, y = 0},
	{x = -125, y = 0},
}

local poly_line_pr_test_waveline = {
	{x = 0, y = 0},
	{x = 8, y = 8},
	{x = 16, y = 0},
	{x = 24, y = 8},
	{x = 32, y = 0},
	{x = 40, y = 8},
}

local ANGLE_1st = ANGLE_180-ANG1*60
local ANGLE_2nd = ANGLE_1st+ANGLE_90

local poly_line_star_waveline = {
	{x = -24, y = 8},
	{x = -8, y = 8},
	{x = 0, y = 24},
	{x = 8, y = 8},
	{x = 24, y = 8},
	{x = 10, y = -8},
	{x = 20, y = -28},
	{x = 0, y = -18},
	{x = -20, y = -28},
	{x = -10, y = -8},	
}

//
// FIX!
//

// local poly_line_star_waveline_curved = Curve_LineInPolygonAuto(poly_line_star_waveline, 3, 4)

local frontiers_font_latex = [[
$newpath
$point(326.34374929,46.70313215)
$point(323.58789165,36.75586916)
$point(320.72656252,26.83400459)
$point(318.15429543,16.84569593)
$point(317.09961071,11.79881719)
$point(316.26562394,6.70314475)
$point(325.2636737,6.76361719)
$point(329.50195276,22.52341562)
$point(332.11523528,31.50776837)
$point(333.80468787,38.10542506)
$point(335.26562646,46.70309436)
$newpath
$point(290.17577953,46.70313215)
$point(286.79297008,45.0859479)
$point(285.2656252,41.79492428)
$point(285.2656252,27.92579672)
$point(287.01953008,24.70900302)
$point(289.15038992,23.6523605)
$point(291.40039181,22.70313215)
$point(293.40820157,22.36146286)
$point(295.25781165,22.20310065)
$point(287.27343874,10.20310065)
$point(287.26550173,6.70310695)
$point(295.08971717,6.70310695)
$point(305.26550173,23.19526443)
$point(305.26550173,41.79488648)
$point(303.38073449,44.96677939)
$point(300.35729764,46.70309436)
$point(295.26549921,46.70309436)
$closepath
$point(295.20702992,39.22068806)
$point(296.76562394,38.20312585)
$point(296.76562394,34.78711325)
$point(296.76562394,31.3691353)
$point(295.12890709,30.41601404)
$point(293.78906079,31.22460617)
$point(293.76562772,38.20312585)
$newpath
$point(259.3719874,46.81171798)
$point(255.93058016,45.16524239)
$point(254.46182929,41.9035101)
$point(254.46182929,30.21210853)
$point(255.3641726,28.62225026)
$point(256.86222236,27.81173058)
$point(255.30362835,27.09101247)
$point(254.46182929,25.41131483)
$point(254.46182929,11.72186601)
$point(255.98917417,8.60859357)
$point(259.3719874,6.81173058)
$point(269.55362646,6.81173058)
$point(272.87589165,8.39958569)
$point(274.46183055,11.72186601)
$point(274.46183055,25.41131483)
$point(273.56144126,27.1203038)
$point(272.0633915,27.81173058)
$point(273.50089323,28.53437624)
$point(274.46183055,30.21210853)
$point(274.46183055,36.05779042)
$point(274.46183055,41.9035101)
$point(272.66495622,45.2843731)
$point(269.55362646,46.81171798)
$closepath
$point(264.22354772,41.53825656)
$point(265.96183181,40.31172428)
$point(265.81340976,32.01679514)
$point(264.20403402,30.34492113)
$point(262.71380031,32.04412113)
$point(262.61224441,36.21210853)
$point(262.78217197,40.34101562)
$closepath
$point(264.46184693,24.31169908)
$point(265.84270488,23.26484554)
$point(265.88957102,18.92303766)
$point(265.72353638,14.5851605)
$point(264.38369386,13.00312585)
$point(264.20401512,13.15166128)
$point(263.2235452,13.83722979)
$point(262.87783181,14.15773373)
$point(262.63563969,14.77685813)
$point(262.59463181,19.05615262)
$point(262.81339087,23.32569593)
$newpath
$point(221.26562646,46.70313215)
$point(221.26562646,37.70313215)
$point(227.26562646,37.70313215)
$point(227.26562646,39.70314475)
$point(233.26562646,39.70314475)
$point(233.20118551,35.27342506)
$point(228.53712378,21.04686758)
$point(224.05274835,6.70314475)
$point(232.16017134,6.70314475)
$point(237.41017323,22.29297782)
$point(239.75392252,30.169929)
$point(241.56837543,38.16797624)
$point(241.52929512,46.70313215)
$newpath
$point(194.17577953,46.70313215)
$point(190.91797039,44.84179042)
$point(189.2656252,41.79492428)
$point(189.2656252,26.70311955)
$point(189.2656252,11.61328018)
$point(191.04492094,8.60742191)
$point(194.17577953,6.70314475)
$point(204.35742236,6.70314475)
$point(207.53125039,8.39648648)
$point(209.26562646,11.61328018)
$point(209.26562646,25.79493687)
$point(207.36132661,28.88281089)
$point(204.35742236,30.70314475)
$point(197.26562646,30.70314475)
$point(197.26562646,38.70311955)
$point(201.2656252,38.70311955)
$point(201.2656252,36.70314475)
$point(209.26562646,36.70314475)
$point(209.26562646,41.79492428)
$point(207.53125039,44.84179042)
$point(204.35742236,46.70313215)
$closepath
$point(199.26562394,22.20313845)
$point(200.68163906,20.89258727)
$point(200.76562016,15.3691479)
$point(199.22070047,14.44531798)
$point(197.67577701,15.29881089)
$point(197.50195654,18.18553845)
$point(197.53521638,19.52734632)
$point(197.76569197,21.1035227)
$newpath
$point(157.26562394,46.70313215)
$point(157.26562394,24.80470065)
$point(169.10547024,24.71096837)
$point(169.0801474,19.71488648)
$point(169.33405606,14.72466286)
$point(167.80476094,13.31255577)
$point(165.00397984,13.41989436)
$point(163.66217953,14.66010853)
$point(163.54497638,16.70309436)
$point(157.22466142,16.91399199)
$point(157.26566929,11.61320459)
$point(158.83207559,8.43938412)
$point(162.1758274,6.70306916)
$point(172.35746646,6.70306916)
$point(175.40434394,8.22844869)
$point(177.26567055,11.61320459)
$point(177.26567055,27.55850223)
$point(175.01176441,30.26555105)
$point(171.99613984,31.70305656)
$point(165.26567055,31.70305656)
$point(165.26567055,39.70306916)
$point(177.26567055,39.70306916)
$point(177.26567055,46.70305656)
$newpath
$point(133.71093921,46.70313215)
$point125.26562646,25.45118884)
$point(125.26562646,16.70313215)
$point(135.2656252,16.70313215)
$point(135.2656252,6.70314475)
$point(143.26562646,6.70314475)
$point(143.26562646,16.70313215)
$point(145.26562394,16.70313215)
$point(145.26562394,22.70313215)
$point(143.26562646,22.70313215)
$point(143.26562646,26.70311955)
$point(135.2656252,26.70311955)
$point(135.2656252,22.70313215)
$point(133.26562394,22.70313215)
$point(133.26562394,24.32814002)
$point(139.26562394,42.07812428)
$point(139.26562394,46.70313215)
$newpath
$point(98.17577953,46.70313215)
$point(95.15625071,44.88087073)
$point(93.2656252,41.79295892)
$point(93.2656252,34.70313215)
$point(101.13281386,34.70313215)
$point(101.16796346,40.20313845)
$point(104.76562016,40.20313845)
$point(104.76562016,35.70311955)
$point(104.76562016,31.20313845)
$point(99.31640315,31.1619416)
$point(99.2656063,22.83579357)
$point(104.76560504,22.71069121)
$point(104.76560504,13.20287388)
$point(101.08982551,13.28677939)
$point(101.13279874,18.70280459)
$point(93.26561008,18.95678884)
$point(93.26561008,11.61305341)
$point(94.93943811,8.65406128)
$point(98.17576441,6.70291798)
$point(108.35740724,6.70291798)
$point(111.65037732,8.44119829)
$point(113.43943937,11.78494632)
$point(113.35742362,22.73023136)
$point(112.26171969,24.20288648)
$point(112.26171969,29.20289908)
$point(113.27343874,31.22437939)
$point(113.43947339,41.62087703)
$point(111.46681701,44.84938727)
$point(108.35744126,46.70290538)
$newpath
$point(69.17578205,46.70313215)
$point(65.9804674,45.00975262)
$point(64.26562394,41.79492428)
$point(64.26562394,34.70313215)
$point(71.26562646,34.70313215)
$point(71.26562646,40.70313215)
$point(75.2656252,40.70313215)
$point(75.2656252,33.6699227)
$point(64.26562394,11.7363416)
$point(64.26562394,6.70314475)
$point(83.26562646,6.70314475)
$point(83.26562646,12.70314475)
$point(74.26562646,12.70314475)
$point(74.26562646,13.56638884)
$point(83.26562646,32.05859672)
$point(83.26562646,41.79492428)
$point(81.21288945,44.86133058)
$point(78.35742236,46.70313215)
$newpath
$point(45.38476724,46.70313215)
$point(44.14843843,44.70311955)
$point(39.2656252,44.70311955)
$point(39.2656252,36.70314475)
$point(45.2656252,36.70314475)
$point(45.2656252,6.70314475)
$point(53.26562646,6.70314475)
$point(53.26562646,46.70313215)
$newpath
$point(16.17578079,46.70313215)
$point(12.93750047,45.15821247)
$point(11.26562646,41.79492428)
$point(11.26562646,26.70311955)
$point(11.26562646,11.61328018)
$point(12.79296756,8.66407703)
$point(16.17578079,6.70314475)
$point(26.35742362,6.70314475)
$point(29.61523276,8.39648648)
$point(31.26562394,11.61328018)
$point(31.26562394,26.70311955)
$point(31.26562394,41.79492428)
$point(29.6582022,44.96681719)
$point(26.35742362,46.70313215)
$closepath
$point(21.05273575,40.18163294)
$point(22.79492031,39.14649593)
$point(22.76544,13.53906286)
$point(21.89239181,12.57422506)
$point(21.46270488,12.34367388)
$point(20.7537222,12.36635105)
$point(19.20489449,13.54408963)
$point(19.38457323,39.08118569)
]]

local ld_string = "$point"
local len_string = ld_string:len()

//print(frontiers_font_svg)
local function Parse_SRBLatex(latex)
	local points = {}
	local id = 0

	-- getting string latex lines
	local latex_lines = {}
	for line in string.gmatch(latex, "[^\n]+") do
		local polygons_id = 1
		if string.find(line, "$newpath") then
			id = $+1
			polygons_id = 1
			latex_lines[id] = {}
			latex_lines[id][polygons_id] = {}			
			continue
		end
		if string.find(line, "$closepath") then
			polygons_id = $+1
			latex_lines[id][polygons_id] = {}
			continue
		end		
		table.insert(latex_lines[id][polygons_id], line)
	end

	-- Iterate over each path and extract the points
	for i = 1, #latex_lines do
		local latex_polygons = latex_lines[i]		
		points[i] = {}

		for j = 1, #latex_polygons do
			local latex_polygon = latex_polygons[j]
			points[i][j] = {}			
			for k = 1, #latex_polygon do
			-- Split the coordinate pairs and extract the points
				local line = latex_polygon[k]
				local point_data = string.sub(line, len_string+1, string.len(line)-1)			
				for x, y in point_data:gmatch("([%d.-]+)%s*,%s*([%d.-]+)") do
					local x_dot = string.find(x, "%.")-1
					local y_dot = string.find(y, "%.")-1	
					local x_edit = string.sub(x, 1, x_dot)
					local y_edit = string.sub(y, 1, y_dot)
					table.insert(points[i][j], {x = tonumber(x_edit), y = tonumber(-y_edit)})
				end
			end
		end
	end

	return points
end

local function Cut_SRBLatexSheet(latex)
	local Sheet = Parse_SRBLatex(latex)
	local default = {}

	for i = 1, #Sheet do
		local polygons = Sheet[i]
		default[i] = {x = INT16_MAX, y = INT16_MAX}
		for j = 1, #polygons do
			local polygon = polygons[j]
			for k = 1, #polygon do
				default[i].x = min(Sheet[i][j][k].x, default[i].x)
				default[i].y = min(Sheet[i][j][k].y, default[i].y)
			end
		end
	end
	
	
	for i = 1, #Sheet do
		local polygons = Sheet[i]	
		for j = 1, #polygons do
			local polygon = polygons[j]
			if not (polygon and polygon[1]) then continue end
			for k = 1, #polygon do
				Sheet[i][j][k].x = $-default[i].x
				Sheet[i][j][k].y = $-default[i].y
			end
		end
	end
	
	return Sheet
end

local Frontiers_font = Cut_SRBLatexSheet(frontiers_font_latex)


-- Testing function
hud.add(function(v, player)
	local leveltime_angle = (leveltime % 360)*ANG1
	local leveltime_scale = FRACUNIT+(leveltime % (TICRATE*2))*(FRACUNIT/70)
	local star = Rotate2D_Polygon(poly_line_star_waveline, leveltime_angle) 
	--local curved_star = Rotate2D_Polygon(poly_line_star_waveline_curved, leveltime_angle)
	--local shadow = Extrude_2DPolygon(star, 80, 2, 80)
	
	Draw_ComplexPolygonFillTextured(v, 120, 0, Offset_MultiPolygon(Frontiers_font[(leveltime/70 % #Frontiers_font)+1], 40, 40), dot_img, 130, 50, FRACUNIT/2, FRACUNIT/2)

	Draw_PolygonLineThick(v, 40, 0, Offset_Polygon(Scale_Polygon(star, FRACUNIT+FRACUNIT/14, FRACUNIT+FRACUNIT/14), 100, 100), 152, 2)
	Draw_PolygonLineThick(v, 40, 100, star, 134, 2)
	Draw_PolygonFillTextured(v, 40, 0, Offset_Polygon(star, 100, 100), Blue_Diagonal_Dithering, -4, 50, FRACUNIT/2, FRACUNIT/2)
	Draw_PolygonFillTextured(v, -60, 0, Offset_Polygon(star, 100, 100), Blue_DiaLines, -4, 50, FRACUNIT/2, FRACUNIT/2)
	--Draw_PolygonFillTextured(v, 60, 0, Offset_Polygon(curved_star, 100, 100), Blue_Diagonal_Dithering, -4, 50, FRACUNIT/2, FRACUNIT/2)	
end, "game")


local editor_toggle = false


hud.add(function(v, player)

end, "game")

--if player.mo and player.mo.valid then
	--	local location = R_WorldToScreen2(camera, player.mo)
	--	if leveltime <= 135 then
	--		Draw_MarioCircle(
	--			v, 
	--			FixedInt(location.x),
	--			FixedInt(location.y)-5,
	--			ease.outquint(((max(leveltime-110, 0) or 0) << FRACBITS)/40, 0, 197) + 
	--			ease.outcubic((min(leveltime, 15) << FRACBITS)/15, 0, 40)
	--		)
	--	end
	--end
	--local leveltime_thirty = (leveltime % 32)
	--Draw_Triangle_LineWave_Yoffset(v, 100, 20, 24, (leveltime % 512), FRACUNIT/4-(leveltime % 512)*(FRACUNIT/128), 2, 68)	
	--Draw_Triangle_LineWave_Yoffset(v, 102, 20, 24, (leveltime % 512), FRACUNIT/4-(leveltime % 512)*(FRACUNIT/128), 8, 64)
	--Draw_Triangle_LineWave_Yoffset(v, 110, 20, 24, (leveltime % 512), FRACUNIT/4-(leveltime % 512)*(FRACUNIT/128), 2, 154)	
	--Draw_Triangle_Wave_Yoffset_Pattern(v, 112, 20, 24, (leveltime % 512), FRACUNIT/4-(leveltime % 512)*(FRACUNIT/128), 24, 24, (leveltime % 512), (leveltime % 512), FRACUNIT/4, 152, 154, 157)
	--Draw_Triangle_Wave_Yoffset(v, 112, 20, 24, (leveltime % 512), FRACUNIT/4-(leveltime % 512)*(FRACUNIT/128), 150)
	
	//Draw_Fill_Graphic(v, 100, 20, 120, 80, (leveltime % 512)/8, (leveltime % 512)/8, random_graphic, 0, 8, 24, 50)
	
	--v, x, y, width, height, square_width, square_height, x_offset, y_offset, skew, color1, color2, color3
	--local sizable = 1 --(leveltime % 80)/20
	--Draw_Fill_Pattern(v, 80, 40, 120, 79, 8 + sizable, 8 + sizable, (leveltime % 79), (leveltime % 79), FRACUNIT/4+(leveltime % 70)*(FRACUNIT/35), 8, 24, 50)
	--local generated_poly = {}

	--local leveltime_angle = (leveltime % 360)*ANG1
	--local leveltime_c = leveltime % 78
	--local progress = (min(leveltime_c, 64))*(FRACUNIT/64)
	--local progress_shift = min(max(leveltime_c-35, 0), 16)
	--local progress_fill = ease.outquad(progress, 0, FRACUNIT)
	--local progress_line = ease.outquad(progress, 0, FRACUNIT)
	
	--local star = Rotate2D_Polygon(poly_line_star_waveline, leveltime_angle) 
	--local shadow = Shadow_Polygon(v, star)
	
	
	--local poly = Init_PolylineCounterProgress(poly_line_pr_test, min(progress_fill, 6*FRACUNIT/7))
	--table.insert(poly, {x = poly[#poly].x + progress_shift, y = 75})
	--table.insert(poly, {x = 200, y = 75})
	
	--local sonic_model_viz = sonic_precached_rotation[(leveltime % 360)/15+1]
	--print(sonic_model[1][1].y)
	--local clipped_sonicModel = Clip_Polygons(poly, sonic_model)
	--if (leveltime % 25)/24 then
	--	print(#clipped_sonicModel, leveltime % 250)
	--end
	
	
	
	--Draw_PolygonFill(v, -40, 0, poly, 31)
	--Draw_PolygonFill(v, 40, 0, Offset_Polygon(shadow, 100, 100), 42)		
	--Draw_PolygonFill(v, 40, 0, Offset_Polygon(star, 100, 100), 37)
	--Draw_PolygonLineThickProgress(v, 162, 102, poly_line_pr_test_og, 31, 2, progress_line)
	--Draw_PolygonLineThickProgress(v, 160, 100, poly_line_pr_test_og, 37, 2, progress_line)
	--Draw_PolygonFill(v, 0, 0, sonic_model_viz, 154)

	--local leveltime_angle = (leveltime % 360)*ANG1
	--local dat = ANG1*9

	--local new_dat = (360/28)*ANG1
	--for i = 1,28, 2 do
	--	local xy = i*new_dat
	--	local angle = xy+leveltime_angle
	--	local angle_2 = xy-dat+leveltime_angle
	--	generated_poly[i] = {x = 64+FixedInt((40)*cos(angle)), y = 64+FixedInt((40)*sin(angle))}
	--	generated_poly[i+1] = {x = 64+FixedInt((28)*cos(angle_2)), y = 64+FixedInt((28)*sin(angle_2))}		
	--end
	--local viz_cube = Offset_MultiPolygon(Inter_3Dto2DPolygonFixed(ring_model, 0, 0, leveltime_angle, 10000), 0, 0)
	--print(viz_cube[1][1].x, viz_cube[1][1].y)
	--local min_y = INT16_MAX
	--local max_y = -INT16_MAX
	--for i = 1, #viz_cube do
	--	min_y = min(viz_cube[i][1].y, min_y)
	--	max_y = max(viz_cube[i][1].y, max_y)
	--end
	--local y_range = (max_y-min_y)/7
	-- +((y-min_y)/y_range % 8) flat shading of gold ring
	--Draw_MultiPolygonLineThick(v, 32, 32, viz_cube, function(i, x, y) return 31 end, 5)
	--Draw_MultiPolygonLine(v, 32, 32, viz_cube, function(i, x, y) return 64+((y-min_y)/y_range % 8) end)	
	--Draw_MultiPolygonFill(v, 32, 32, viz_cube, function(i, x, y) return 64+((y-min_y)/y_range % 8) end)
	--local viz_sonic = Inter_3Dto2DPolygonFixed(sonic_model, 0, 0, leveltime_angle, 1000)
	--Draw_MultiPolygonLine(v, 32, 32, viz_sonic, function(i, x, y) return 154 end)
	
	--local location = R_WorldToScreen2(camera, player.realmo)
	--local viz_mario = Inter_3Dto2DPolygonFixed(mariohead_model, 0, 0, leveltime_angle, 10000)
	--Draw_MultiPolygonLine(v, 0, 0, viz_mario, function(i, x, y) return 154 end)
	--Draw_MultiPolygonFill(v, 32-6, 32-6, viz_sonic, function(i, x, y) return 154 end)	

	--Draw_PolygonFill(v, 154+8, 36+8, Shear_Polygon(generated_poly, 1, 0, -64, -64), (leveltime/2 % 255))	
	--Draw_PolygonFill(v, 154, 36, Shear_Polygon(generated_poly, 1, 0, -64, -64), 151)
	--Draw_PolygonLine(v, 90, 30, graphic_test, 25)