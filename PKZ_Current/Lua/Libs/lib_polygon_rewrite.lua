/* 
		Team Blue Spring's Series of Libaries. 
		Polygon Library - lib_polygon.lua

	Note: Make conveinent architecture for this

Contributors: Skydusk
@Team Blue Spring 2024
*/

//
//	struct_t multi_polygon_t
//
//	int offset_x, offset_y
//	int center_x, center_y
//
//	table polygon_t polygons
//
//	table extrainfo
//

//
//	struct_t polygon_t
//
//	table point_t point
//	table keyanim_t keyanim
//

//
//	struct_t point_t
//
//	int x, y,
//	int depth -- for 3D
//

//
//	struct_t keyanim
//
//	table keyframe_t keyframe
//

//
//	struct_t keyframe
//
//	int vec_x, vec_y = 0, 0
//	int tics = 0
//

rawset(_G, "TBS_Polygon", {
	-- version control
	major_iteration = 1, -- versions with extensive changes. 	
	iteration = 1, -- additions, fixes. No variable changes.
	version = "DEV", -- just a string...
})

local function Draw_LineLow(v, x_0, y_0, x_1, y_1, color)
	local dx = x_1-x_0
	local dy = y_1-y_0
	local yi = 1
	if dy < 0 then
		yi = -1
		dy = -dy
	end
	local D = dy << 1 - dx
	local y = y_0
	
	for x = x_0, x_1 do
		v.drawFill(x, y, 1, 1, color)
		if D > 0 then
			y = y+yi
			D = D + ((dy - dx) << 1)
		else
			D = D + dy << 1			
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
	local D = dx << 1 - dy
	local x = x_0
	
	for y = y_0, y_1 do
		v.drawFill(x, y, 1, 1, color)
		if D > 0 then
			x = x+xi
			D = D + ((dx - dy) << 1)
		else
			D = D + dx << 1
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
		v.drawFill(x, y - thickness >> 1, 1, thickness, color)
		if D > 0 then
			y = y+yi
			D = D + ((dy - dx) << 1)
		else
			D = D + dy << 1
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
	local D = dx << 1 - dy
	local x = x_0
	
	for y = y_0, y_1 do
		v.drawFill(x - thickness >> 1, y, thickness, 1, color)
		if D > 0 then
			x = x+xi
			D = D + ((dx - dy) << 1)
		else
			D = D + dx << 1
		end
	end
end

TBS_Polygon.drawLine = function(v, x_0, y_0, x_1, y_1, color, thickness)
	if thickness > 1 then
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
	else
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
end

local function Scroll_Table(table, index)
	if index < 1 then
		index = #table + index
	end
	
	return table[((index - 1) % #table) + 1]
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

-- TBS_Polygon.progressLine(polygon, progress)
TBS_Polygon.progressLine = function(polygon, progress)
	local max_length = 0
	local inv_lengths = {}
	for i = 1,#polygon do
		if not polygon[i+1] then break end
		local x = abs(polygon[i].x-polygon[i+1].x)
		local y = abs(polygon[i].y-polygon[i+1].y)
		inv_lengths[i] = R_PointToDist2(0, 0, x, y)
		max_length = $+inv_lengths[i]
	end
	local length = FixedInt(FixedMul(max_length << FRACBITS, progress))
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

-- TBS_Polygon.drawPolygon(v, x_center, y_center, points, color, thickness, enclose)
TBS_Polygon.drawPolygon = function(v, x_center, y_center, points, color, thickness, enclose)
	if enclose then
		if #points < 3 then return end
		for i = 1, #points do
			local point_1 = points[i]
			local point_2 = points[points[i+1] and i+1 or 1]
			TBS_Polygon.drawLine(v, x_center+point_1.x, y_center+point_1.y, x_center+point_2.x, y_center+point_2.y, color, thickness)
		end	
	else
		if #points < 2 then return end
		for i = 1, #points do
			if not points[i+1] then break end
			local point_1 = points[i]
			local point_2 = points[i+1]
			TBS_Polygon.drawLine(v, x_center+point_1.x, y_center+point_1.y, x_center+point_2.x, y_center+point_2.y, color, thickness)
		end
	end
end

TBS_Polygon.drawPolygonFill = function(v, x_center, y_center, points, texture, x_offset, y_offset, skew_x, skew_y)
	if not points[1] then return end
	if points[1].x then
		Draw_PolygonFillTextured(v, x_center, y_center, points, texture, x_offset, y_offset, skew_x, skew_y)
	else
		Draw_ComplexPolygonFillTextured(v, x_center, y_center, points, texture, x_offset, y_offset, skew_x, skew_y)
	end
end
