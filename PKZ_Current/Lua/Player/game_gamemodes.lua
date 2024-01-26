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
	if p ~= consoleplayer then return end	
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

PKZ_Table.hub_voting_time_const = 8*TICRATE 

PKZ_Table.hub_variables = {
	MP_voting_timer = 0,
	MP_voters_num = 0,
	MP_voters = {}
}

addHook("PlayerJoin", function(pnum)
	if PKZ_Table.hub_variables.MP_voters[pnum] then
		PKZ_Table.hub_variables.MP_voters[pnum] = nil
		PKZ_Table.hub_variables.MP_voters_num = $-1
	end
end)

local point_sectors = {}

addHook("MapLoad", function()
	if not (mapheaderinfo[gamemap].mariohubcamera) then return end
	local lvl_data = PKZ_Table.getSaveData().lvl_data
	
	point_sectors = {}
	for sector in sectors.tagged(9998) do
		local max_y, min_y, max_x, min_x = INT32_MIN, INT32_MAX, INT32_MIN, INT32_MAX
		local var1, var2, var3, var4 = 0, 0, 0, 0
		local unlocked = true
		local lines_sector = sector.lines
		for i = 1, #lines_sector do
			local line = sector.lines[i]
			if line and line.valid then
				max_y = max(line.v2.y, max_y)
				min_y = min(line.v2.y, min_y)
				max_x = max(line.v2.x, max_x)
				min_x = min(line.v2.x, min_x)
				var1 = max(var1, line.args[0]) -- Warp to Map (0 - disabled)
				var2 = max(var2, line.args[1]) -- Type
				var3 = max(var3, line.args[2]) -- Special Coin Requirement
				var4 = max(var4, line.args[3]) -- Visit Requirement	
			end
		end
		
		--HUBMAL00 -- GRAY
		--HUBMAL01 -- BLUE
		--HUBMAL05 -- RED
		
		if var1 then
			if (not var4) or (lvl_data[var4] and lvl_data[var4].visited) then
				if lvl_data[var1] and lvl_data[var1].visited then
					sector.floorpic = "HUBMAL01"
					unlocked = true
				else
					sector.floorpic = "HUBMAL05"
					unlocked = true
				end
			else
				sector.floorpic = "HUBMAL00"
				unlocked = false
			end
		end
		
		local x, y = (min_x + (max_x - min_x) >> 1), (min_y + (max_y - min_y) >> 1)
		point_sectors[#sector] = {sector = sector, x = x, y = y, 
		var1 = var1, var2 = var2, var3 = var3, var4 = var4,
		unlocked = unlocked}
	end
end)

local function Count_Votes()
	local data = PKZ_Table.hub_variables
	local timer = data.MP_voting_timer
	local votes = data.MP_voters

	local vote_count = {}
	for k, v in pairs(votes) do
		local sector = v
		if point_sectors and point_sectors[#sector] then
			local name = point_sectors[#sector].var1
			if not vote_count[name] then
				vote_count[name] = 1
			else
				vote_count[name] = $+1
			end
		end
	end
	
	return vote_count
end

addHook("ThinkFrame", function() 
	if not mapheaderinfo[gamemap].mariohubcamera then return end
	local data = PKZ_Table.hub_variables
	local timer = data.MP_voting_timer
	local votes = data.MP_voters
	
	if PKZ_Table.hub_variables.MP_voters_num > 0 and not timer then
		PKZ_Table.hub_variables.MP_voting_timer = PKZ_Table.hub_voting_time_const
	end

	if timer then
		--print(timer)
		if PKZ_Table.hub_variables.MP_voters_num < 1 then
			PKZ_Table.hub_variables.MP_voting_timer = 0
		else
			PKZ_Table.hub_variables.MP_voting_timer = $-1
			if PKZ_Table.hub_variables.MP_voting_timer == 0 then
				local vote_count = Count_Votes()
			
				local max_votes = 0
				local current_lvl = 0

				for k, v in pairs(vote_count) do
					if v > max_votes then
						max_votes = v
						current_lvl = k
					end
				end
			
				G_SetCustomExitVars(current_lvl, 1)
				G_ExitLevel()
			end
		end
	end
end)

-- PKZ Hub gameplay
addHook("PlayerThink", function(p)
	-- Camera
	if not (mapheaderinfo[gamemap].mariohubcamera and p and p.mo) then return end
	if p ~= consoleplayer then return end
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
	(p.mo.floorz > 192<<FRACBITS and p.mo.z or 0) +(192 << FRACBITS))
	p.mo.mario_camera.angle = ANGLE_90
	p.awayviewaiming = jaw

	p.mo.mariohub_movement = P_AngleCheckHub()
	
	// playermovement

	--p.mo.angle = (p.mo.angle >> 3) << 3

	if p.mo.mariohub_movement then
		p.cmd.forwardmove = 50
	
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
			p.mo.angle = ANGLE_MAX
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
	
		if P_IsObjectOnGround(p.mo) and p.mo.state ~= S_PLAY_WALK then
			p.mo.state = S_PLAY_WALK
		end
		--p.mo.fiction = FRACUNIT >> 2
		--local div = R_PointToAngle2(0, 0, p.mo.momx, p.mo.momy)
		p.mo.momx = 11*cos(p.mo.angle)
		p.mo.momy = 11*sin(p.mo.angle)
	end
	
	local sector = p.mo.subsector.sector
	
	if point_sectors and point_sectors[#sector] and point_sectors[#sector].unlocked and input.gameControlDown(GC_JUMP) then
		PKZ_Table.hub_variables.MP_voters[#p] = sector
		PKZ_Table.hub_variables.MP_voters_num = $+1
	end
	
	if PKZ_Table.hub_variables.MP_voters[#p] and input.gameControlDown(GC_SPIN) then
		PKZ_Table.hub_variables.MP_voters[#p] = nil
		PKZ_Table.hub_variables.MP_voters_num = $-1
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

local function Draw_HubLevelPrompt(v, x, y, scale, map_data, name, description, act, custom_thumbnail, color, anchor_x, anchor_y)
	//local star = v.getSpritePatch("MSTA", C, 0, leveltime * ANG1)
	local levelpic = v.cachePatch(custom_thumbnail or "MAP01P")
	local color_f = skincolors[color].ramp[3] 
	local color = v.getColormap(TC_DEFAULT, color and color or SKINCOLOR_DEFAULT)
	local ten_frac = 10*scale
	local eith_frac = scale<<3	
	local five_frac = 5*scale
	local twelvteen_frac = 12*scale
	local twenty_frac = 20*scale	
	local forty_frac = 40*scale
	local fortyfive_frac = forty_frac+five_frac
	local double_scale = scale << 1
	local thrddb_scale = (scale << 2)/3

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
	Draw_PolygonFill(v, new_x-32, new_y-32, {{x = 73, y = 40}, {x = 55, y = 40}, {x = anchor_x-new_x+32, y = anchor_y-new_y+16}}, color_f)

	//v.drawScaled(x+ten_frac, y+twenty_frac, scale, star, 0, color)
	if map_data.unlocked then
		v.drawScaled(x+ten_frac, y+ten_frac, scale, levelpic, 0)
		v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, color)
		
		TBSlib.fontdrawerNoPosScale(v, 'MA14LT', x+five_frac, y+five_frac, scale, name, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 1, "0")
		TBSlib.fontdrawerNoPosScale(v, 'MA14LT', x+five_frac, y+five_frac+twenty_frac, scale, description, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 1, "0")	
	
		TBSlib.fontdrawershiftyNoPosScale(v, 'MA12LT', x + 120*scale, y + 90*scale, scale, string.upper(act), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, -4*scale, 0)			
	
		local coin_data = PKZ_Table.getSaveData().coins
		if PKZ_Table and PKZ_Table.levellist and PKZ_Table.levellist[map_data.var1] then
			local coins = PKZ_Table.levellist[map_data.var1].coins
			for i = 1, #coins do
				local coin = coins[i]
				if coin_data[coin] then
					v.drawScaled(x - eith_frac + twelvteen_frac*i, y+fortyfive_frac, thrddb_scale, v.cachePatch("WONDSPC"))
				else
					v.drawScaled(x - eith_frac + twelvteen_frac*i, y+fortyfive_frac, thrddb_scale, v.cachePatch("WONDSPCE"))
				end
			end
		end	
	else
		v.drawScaled(x+five_frac, y+five_frac, double_scale, v.cachePatch("MENUPKLELOC"), 0)
		v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, color)
	end
end

hud.add(function(v, player)
	if player.mo and player.mo.valid and player.mo.mario_camera then
		local sector = player.mo.subsector.sector
		if PKZ_Table.hub_variables.MP_voters[#player] then
			local vote = PKZ_Table.hub_variables.MP_voters[#player]
			local data = point_sectors[#vote]
			local cam = player.mo.mario_camera
			local prompt_location = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = player.mo.x-player.mo.momx, y = player.mo.y-player.mo.momy, z = player.mo.z + player.mo.height + 20*FRACUNIT})
			
			v.draw(prompt_location.x>>FRACBITS, prompt_location.y>>FRACBITS+20, v.cachePatch("MARIOHUBFLAG"))
			v.drawString(prompt_location.x>>FRACBITS, prompt_location.y>>FRACBITS+20, data.var1)
		else
			if point_sectors and point_sectors[#sector] then
				local data = point_sectors[#sector]
				local cam = player.mo.mario_camera
				local map = mapheaderinfo[data.var1]
				local point_prompt_l = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = data.x, y = data.y, z = player.mo.floorz})
			
				//print(point_prompt_l.x >> FRACBITS, point_prompt_l.y >> FRACBITS)
				local prompt_location = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = player.mo.x-player.mo.momx, y = player.mo.y-player.mo.momy, z = player.mo.z + player.mo.height + 20*FRACUNIT})				
				Draw_HubLevelPrompt(v, prompt_location.x, prompt_location.y, prompt_location.scale, data, map.lvlttl, map.defaultmarioname or "", map.worldprefix..map.worldassigned or map.actnum, "MAP"..(data.var1).."P", SKINCOLOR_YELLOW, FixedInt(point_prompt_l.x), FixedInt(point_prompt_l.y))
			end
		end
		
		if PKZ_Table.hub_variables.MP_voting_timer then
			local vote_count = Count_Votes()
			local i = 0
			
			for k, num in pairs(vote_count) do
				i = $+1
				v.drawString(20+40*i, 120, (k).."-"..(num))
			end
		
			v.drawFill(0, 195, 320, 5, 158)
			v.drawFill(0, 195, (320*PKZ_Table.hub_variables.MP_voting_timer)/PKZ_Table.hub_voting_time_const, 5, 153)			
		end
	end
end, "game")