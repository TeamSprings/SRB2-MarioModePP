/* 
		Pipe Kingdom Zone's Gamemode - game_gamemodes.lua

Description:
2D and Hub scripts

Contributors: Skydusk
@Team Blue Spring 2024
*/

local FRAxThirty = 30 << FRACBITS

local tagged_moving_sectors = {}

addHook("MapLoad", function()
	if not (maptol & TOL_2D and mariomode and udmf) then return end
	tagged_moving_sectors = {}
	
	for line in lines.iterate do
		if line.special == 60 or line.special == 56 or line.special == 53 or line.special == 52 then
			tagged_moving_sectors[line.args[0]] = line.args[0]
		end
	end
end)

local COSNT_HEIGHT = 84 << FRACBITS
local COSNT_SPEED = 16 << FRACBITS

-- 2D Camera
addHook("PlayerThink", function(p)
	if not (maptol & TOL_2D) then return end
	if not p.mo and p.mo.valid then return end
	local data = p.mo.mariomode
	if not data.camera_2D_center then
		data.camera_2D_center = p.mo.z+COSNT_HEIGHT
		data.camera_calc_posz = data.camera_2D_center
		data.camera_2D_active = true
	end
	
	local z = p.mo.z+COSNT_HEIGHT
	if (mapheaderinfo[gamemap].camera_2D_min_y and (mapheaderinfo[gamemap].camera_2D_min_y << FRACBITS) >= z) 
	or p.playerstate == PST_DEAD or p.mo.state == S_PLAY_DEAD or p.mo.state == S_PLAY_DRWN then
		data.camera_calc_posz = TBSlib.reachNumber(data.camera_calc_posz, data.camera_2D_center, COSNT_SPEED)
	else
		if abs(data.camera_2D_center-z) > (320 << FRACBITS) then
			data.camera_calc_posz = TBSlib.reachNumber(data.camera_calc_posz, z, COSNT_SPEED)
			data.camera_2D_active = true
		elseif (abs(data.camera_2D_center-p.mo.floorz) > (130 << FRACBITS)) and P_IsObjectOnGround(p.mo) then		
			local moving = false
			if p.mo.floorrover and p.mo.floorrover.master and p.mo.floorrover.master.frontsector then
				local sect = p.mo.floorrover.master.frontsector
				if tagged_moving_sectors[sect.tag] then
					moving = true
				end
			end
		
			if moving then
				data.camera_calc_posz = TBSlib.reachNumber(data.camera_calc_posz, z, COSNT_SPEED)
			else
				if P_IsObjectOnGround(p.mo) then
					data.camera_2D_center = z
				end
				data.camera_calc_posz = TBSlib.reachNumber(data.camera_calc_posz, data.camera_2D_center, COSNT_SPEED)
			end
			data.camera_2D_active = true
		else
			data.camera_calc_posz = TBSlib.reachNumber(data.camera_calc_posz, data.camera_2D_center, COSNT_SPEED)
			data.camera_2D_active = true
		end
	end
	
	local runspeed = skins[p.mo.skin].runspeed-20 << FRACBITS
	--local momxcam = ((abs(p.rmomx) > runspeed) and (p.rmomx - TBSlib.signZ(p.rmomx)*runspeed) << 1 or 0)
	--local momycam = ((abs(p.rmomy) > runspeed) and (p.rmomy - TBSlib.signZ(p.rmomy)*runspeed) << 1 or 0)
	P_TeleportCameraMove(
	camera,
	p.mo.x+cos(ANGLE_270)*515, 
	p.mo.y+sin(ANGLE_270)*515, 
	data.camera_calc_posz)
	camera.momx = 0
	camera.momy = 0
	camera.momz = 0
	camera.aiming = 0
end)

local function P_AngleCheckHub()
	local result = 0
	if input.gameControlDown(GC_FORWARD) then
		result = $|1		
	end
	if input.gameControlDown(GC_BACKWARD) then
		result = $|2		
	end
	if input.gameControlDown(GC_STRAFELEFT) or input.gameControlDown(GC_TURNLEFT) then
		result = $|4		
	end
	if input.gameControlDown(GC_STRAFERIGHT) or input.gameControlDown(GC_TURNRIGHT) then
		result = $|8		
	end
	return result
end

local LOC_MAP = 1
local LOC_TOAD = 2
local LOC_WARP = 4

PKZ_Table.hub_variables = {
	MP_voting_timer = 0
}

-- PKZ Hub gameplay
addHook("PlayerThink", function(p)
	-- Camera
	if not (mapheaderinfo[gamemap].mariohubcamera and p and p.mo) then return end
	if not p.mo.mario_camera then
		p.mo.mario_camera = P_SpawnMobj(0, 0, 0, MT_ALARM)
		p.mo.mario_camera.state = S_INVISIBLE
		p.awayviewmobj = p.mo.mario_camera
	end

	p.awayviewtics = 10000
	local dist = P_AproxDistance(p.mo.x - p.mo.mario_camera.x, p.mo.y - p.mo.mario_camera.y)
	local zdist = p.mo.z - p.mo.mario_camera.z
	local jaw = R_PointToAngle2(0, 0, dist, zdist)

	P_MoveOrigin(
	p.mo.mario_camera,
	p.mo.x+cos(ANGLE_270)*400, 
	p.mo.y+sin(ANGLE_270)*400, 
	192*FRACUNIT)
	p.mo.mario_camera.angle = ANGLE_90
	p.awayviewaiming = jaw

	p.mo.mariohub_movement = P_AngleCheckHub()
	p.powers[pw_nocontrol] = 34000
	// playermovement

	if p.mo.mariohub_movement then
		if p.mo.mariohub_movement & 1 then
			p.mo.angle = ANGLE_90		
		end

		if p.mo.mariohub_movement & 2 then
			p.mo.angle = ANGLE_270
		end
	
		if p.mo.mariohub_movement & 4 then
			p.mo.angle = ANGLE_180
		end	

		if p.mo.mariohub_movement & 8 then
			p.mo.angle = 0
		end	
		
		if p.mo.mariohub_movement & 1 and p.mo.mariohub_movement & 4 then
			p.mo.angle = ANGLE_135		
		end

		if p.mo.mariohub_movement & 1 and p.mo.mariohub_movement & 8 then
			p.mo.angle = ANGLE_45
		end
	
		if p.mo.mariohub_movement & 2 and p.mo.mariohub_movement & 4 then
			p.mo.angle = ANGLE_225		
		end

		if p.mo.mariohub_movement & 2 and p.mo.mariohub_movement & 8 then
			p.mo.angle = ANGLE_315
		end		
	
		p.mo.momx = 0
		p.mo.momy = 0
		P_Thrust(p.mo, p.mo.angle, 8*FRACUNIT)
		p.panim = PA_WALK
	end
end)

-- Match Gmaemode

local function Scale_Polygon(points, scale_x, scale_y)
	local point_data = {}	
	for i = 1, #points do
		point_data[i] = {x = FixedInt(points[i].x*scale_x), y = FixedInt(points[i].y*scale_y)}
	end
	return point_data
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

local JumpANG_first = ANG1*(180/6)
local JumpANG_second = ANG1*(180/4)


local function Draw_HubLevelPrompt(v, x, y, scale, name, description, act, custom_thumbnail, color, anchor_x, anchor_y)
	//local star = v.getSpritePatch("MSTA", C, 0, leveltime * ANG1)
	local levelpic = v.cachePatch(custom_thumbnail or "MAP01P")
	local color_f = skincolors[color].ramp[3] 
	local color = v.getColormap(TC_DEFAULT, color and color or SKINCOLOR_DEFAULT)
	local twenty_frac = 20*scale
	local ten_frac = 10*scale
	local five_frac = 5*scale

	x = $-86*scale
	y = $-111*scale

	local generated_poly = {}
	local leveltime_angle = (leveltime % 360)*ANG1
	local dat = ANG1*9
	for i = 1,40, 2 do
		local xy = i*dat
		local angle = (((xy+leveltime_angle)/ANG1) % 200)*ANG1
		local angle_2 = (((xy+dat+leveltime_angle)/ANG1) % 200)*ANG1
		generated_poly[i] = {x = 64+FixedInt(cos(angle)<<5), y = 64+FixedInt(sin(angle)<<5)}
		generated_poly[i+1] = {x = 64+FixedInt(28*cos(angle_2)), y = 64+FixedInt(28*sin(angle_2))}		
	end

	local new_x = x >> FRACBITS
	local new_y = y >> FRACBITS

	Draw_PolygonFill(v, new_x-32, new_y-30, Scale_Polygon(generated_poly, scale + FRACUNIT >> 2, scale + FRACUNIT >> 2), color_f)
	Draw_PolygonFill(v, new_x-32, new_y-32, {{x = 71, y = 74}, {x = 57, y = 74}, {x = anchor_x-new_x, y = anchor_y+64-new_y}}, color_f)

	//v.drawScaled(x+ten_frac, y+twenty_frac, scale, star, 0, color)	
	v.drawScaled(x+ten_frac, y+ten_frac, scale, levelpic, 0)
	v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, color)
	
	TBSlib.fontdrawerNoPosScale(v, 'MA14LT', x+five_frac, y+five_frac, scale, name, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 1, "0")
	TBSlib.fontdrawerNoPosScale(v, 'MA14LT', x+five_frac, y+five_frac+twenty_frac, scale, description, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 1, "0")	
	
	TBSlib.fontdrawershiftyNoPosScale(v, 'MA12LT', x + 120*scale, y + 90*scale, scale, string.upper(act), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, -4*scale, 0)	
end

local point_sectors = {}

addHook("MapLoad", function()
	if not (mapheaderinfo[gamemap].mariohubcamera) then return end
	for sector in sectors.tagged(9998) do
		local max_y, min_y, max_x, min_x, var1, var2, var3 = INT32_MIN, INT32_MAX, INT32_MIN, INT32_MAX, 0, 0, 0
		for line in lines.iterate do
			max_y = max(line.v1.y - line.dy >> 1, max_y)
			min_y = min(line.v1.y - line.dy >> 1, min_y)
			max_x = max(line.v1.x - line.dx >> 1, max_x)
			min_x = min(line.v1.x - line.dx >> 1, min_x)
			var1 = max(var1, line.args[0])
			var2 = max(var2, line.args[1])
			var3 = max(var3, line.args[2])
		end
		
		local x, y = (min_x + (max_x - min_x) >> 1), (min_y + (max_y - min_y) >> 1)
		point_sectors[#sector] = {sector, x = x, y = y, var1 = var1, var2 = var2, var3 = var3}
	end
end)

hud.add(function(v, player)
	if player.mo and player.mo.valid and player.mo.mario_camera then
		local sector = player.mo.subsector.sector
		if point_sectors and point_sectors[#sector] then
			local data = point_sectors[#sector]
			local cam = player.mo.mario_camera
			local point_prompt_l = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = data.x, y = data.y, z = player.mo.floorz})
			
			//print(point_prompt_l.x >> FRACBITS, point_prompt_l.y >> FRACBITS)
			local prompt_location = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = player.mo.x-player.mo.momx, y = player.mo.y-player.mo.momy, z = player.mo.z + player.mo.height + 20*FRACUNIT})				
			Draw_HubLevelPrompt(v, prompt_location.x, prompt_location.y, prompt_location.scale, "Pipe kingdom", "Fungus Isle", "W1-1", "MAP34P", SKINCOLOR_YELLOW, FixedInt(point_prompt_l.x), FixedInt(point_prompt_l.y))
		end
	end
end, "game")
