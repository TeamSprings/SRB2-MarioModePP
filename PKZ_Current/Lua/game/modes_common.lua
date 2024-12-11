--[[
		Pipe Kingdom Zone's Gamemode - game_gamemodes.lua

Description:
2D and Hub scripts

Contributors: Skydusk
@Team Blue Spring 2024
--]]

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
local COSNT_ESPEED = FRACUNIT/14
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

local function P_HubControls(cmd, p)
	if not cmd then return 0 end
	local result = 0

	-- Movement

	if cmd.forwardmove > 8 then
		result = $|1
	end

	if cmd.forwardmove < -8 then
		result = $|2
	end

	if cmd.sidemove < -8
	or (cmd.buttons & BT_CAMLEFT) then
		result = $|4
	end

	if cmd.sidemove > 8
	or (cmd.buttons & BT_CAMRIGHT) then
		result = $|8
	end

	-- Actions

	if cmd.buttons & BT_JUMP then
		result = $|32
	end

	return result
end

local LOC_MAP = 1
local LOC_TOAD = 2
local LOC_WARP = 4

xMM_registry.hub_voting_time_const = 8*TICRATE

xMM_registry.hub_variables = {
	MP_voting_timer = 0,
	MP_voters_num = 0,
	MP_voters = {}
}

addHook("PlayerJoin", function(pnum)
	if xMM_registry.hub_variables.MP_voters[pnum] then
		xMM_registry.hub_variables.MP_voters[pnum] = nil
		xMM_registry.hub_variables.MP_voters_num = $-1
	end
end)

local point_sectors = {}
local ROT_CAMERA_SECTORS = {}
local SLO_CAMERA_SECTORS = {}

addHook("MapLoad", function()
	if not (mapheaderinfo[gamemap].mm_mario_hub) then return end
	local lvl_data = xMM_registry.getSaveData().lvl_data

	xMM_registry.hub_variables.MP_voters = {}
	xMM_registry.hub_variables.MP_voters_num = 0
	xMM_registry.hub_variables.MP_voting_timer = 0

	ROT_CAMERA_SECTORS = {}
	SLO_CAMERA_SECTORS = {}
	point_sectors = {}
	for sector in sectors.tagged(9998) do
		local max_y, min_y, max_x, min_x = INT32_MIN, INT32_MAX, INT32_MIN, INT32_MAX
		local var1, var2, var3, var4, var5 = 0, 0, 0, 0, 0
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
				var5 = max(var5, line.args[4]) -- Color
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
		point_sectors[#sector] = {sector = sector, x = x, y = y, z = sector.floorheight,
		var1 = var1, var2 = var2, var3 = var3, var4 = var4, var5 = var5,
		unlocked = unlocked}
	end

	for sector in sectors.tagged(9997) do
		ROT_CAMERA_SECTORS[#sector] = sector.ceilingangle+ANGLE_90
	end

	for sector in sectors.tagged(9996) do
		SLO_CAMERA_SECTORS[#sector] = sector.ceilingangle+ANGLE_90
	end
end)

local function Count_Votes()
	local data = xMM_registry.hub_variables
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
	if not mapheaderinfo[gamemap].mm_mario_hub then return end
	local data = xMM_registry.hub_variables
	local votes = data.MP_voters

	if xMM_registry.hub_variables.MP_voters_num > 0 and not xMM_registry.hub_variables.MP_voting_timer then
		xMM_registry.hub_variables.MP_voting_timer = xMM_registry.hub_voting_time_const
	end

	if xMM_registry.hub_variables.MP_voting_timer then
		--print(timer)
		if xMM_registry.hub_variables.MP_voters_num < 1 then
			xMM_registry.hub_variables.MP_voting_timer = 0
		else
			xMM_registry.hub_variables.MP_voting_timer = $-1
			if xMM_registry.hub_variables.MP_voting_timer == 0 then
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

local mp_debug = false

local REQUEST_TELEPORT = {}
local REQUEST_TELEPORT_TIM = 0

local HUB_CAMERA_HEIGHT = 192 << FRACBITS
local HUB_CAMERA_ROTATION = ANG1 << 3
local HUB_CAMERA_SLWROTATION = ANG1 << 1
local HUB_PROMPT_COLOR = SKINCOLOR_YELLOW
local HUB_LUT_COLORS = {
	[0] = SKINCOLOR_YELLOW,
	SKINCOLOR_GREEN,
	SKINCOLOR_RED,
	SKINCOLOR_PURPLE,
	SKINCOLOR_BLUE,
	SKINCOLOR_ORANGE,
	SKINCOLOR_GOLD,
}

local HUB_MOVEMENT_MASK = 1|2|4|8|16

-- PKZ Hub gameplay
addHook("PlayerThink", function(p)
	-- Camera
	if not (mapheaderinfo[gamemap].mm_mario_hub and p and p.mo) then return end

	-- In Hub Rings/Coins -> Total Coins Conversion Rate
	if p.rings > 0 then
		local data = xMM_registry.getSaveData()
		p.rings = $-1
		data.total_coins = $+1
	end

	if p ~= consoleplayer then return end
	if not p.mo.mario_camera then
		p.mo.mario_camera = P_SpawnMobj(0, 0, 0, MT_ALARM)
		p.mo.mario_camera.state = S_INVISIBLE
		p.mo.mario_camera.angle = ANGLE_90
		p.awayviewmobj = p.mo.mario_camera
	end

	local sector = p.mo.subsector.sector

	p.awayviewtics = 10000
	local dist = P_AproxDistance(p.mo.x - p.mo.mario_camera.x, p.mo.y - p.mo.mario_camera.y)
	local zdist = p.mo.z - p.mo.mario_camera.z
	local jaw = R_PointToAngle2(0, 0, dist, zdist)

	if ROT_CAMERA_SECTORS[#sector] then
		p.mo.mario_camera.angle = TBSlib.reachAngle(p.mo.mario_camera.angle, ROT_CAMERA_SECTORS[#sector], HUB_CAMERA_ROTATION)
	elseif SLO_CAMERA_SECTORS[#sector] then
		p.mo.mario_camera.angle = TBSlib.reachAngle(p.mo.mario_camera.angle, SLO_CAMERA_SECTORS[#sector], HUB_CAMERA_SLWROTATION)
	else
		p.mo.mario_camera.angle = TBSlib.reachAngle(p.mo.mario_camera.angle, ANGLE_90, HUB_CAMERA_ROTATION)
	end

	local angle_cam_offset = p.mo.mario_camera.angle+ANGLE_180
	local offset_movement = p.mo.mario_camera.angle-ANGLE_90

	p.awayviewaiming = jaw
	p.mariohub_movement = P_HubControls(p.cmd, p)
	p.mo.friction = 4*FRACUNIT/5
	-- playermovement

	if p.mariohub_movement and not p.mariomode.levelentry then
		if p.mariohub_movement & 1 then
			p.mo.angle = ANGLE_90+offset_movement
		end

		if p.mariohub_movement & 2 then
			p.mo.angle = ANGLE_270+offset_movement
		end

		if p.mariohub_movement & 4 then
			p.mo.angle = ANGLE_180+offset_movement
		end

		if p.mariohub_movement & 8 then
			p.mo.angle = ANGLE_MAX+offset_movement
		end

		if p.mariohub_movement & 1 and p.mariohub_movement & 4 then
			p.mo.angle = ANGLE_135+offset_movement
		end

		if p.mariohub_movement & 1 and p.mariohub_movement & 8 then
			p.mo.angle = ANGLE_45+offset_movement
		end

		if p.mariohub_movement & 2 and p.mariohub_movement & 4 then
			p.mo.angle = ANGLE_225+offset_movement
		end

		if p.mariohub_movement & 2 and p.mariohub_movement & 8 then
			p.mo.angle = ANGLE_315+offset_movement
		end

		if p.mariohub_movement & HUB_MOVEMENT_MASK then
			p.mo.momx = 11*cos(p.mo.angle)
			p.mo.momy = 11*sin(p.mo.angle)

			if P_IsObjectOnGround(p.mo) and p.mo.state ~= S_PLAY_WALK then
				p.mo.state = S_PLAY_WALK
			end
		end

		if P_IsObjectOnGround(p.mo) and p.mariohub_movement & 32 then
			p.mo.momz = P_MobjFlip(p.mo) * 8 * p.mo.scale

			if p.mo.state ~= S_PLAY_JUMP then
				p.mo.state = S_PLAY_JUMP
			end
		end
	end

	if multiplayer or mp_debug then
		if point_sectors and point_sectors[#sector] and point_sectors[#sector].unlocked and input.gameControlDown(GC_JUMP) then
			if xMM_registry.hub_variables.MP_voters[#p] ~= sector then
				xMM_registry.hub_variables.MP_voters_num = $+1
			end
			xMM_registry.hub_variables.MP_voters[#p] = sector
		end

		if xMM_registry.hub_variables.MP_voters[#p] and input.gameControlDown(GC_SPIN) then
			xMM_registry.hub_variables.MP_voters[#p] = nil
			xMM_registry.hub_variables.MP_voters_num = $-1
		end
	else
		if point_sectors and point_sectors[#sector] and point_sectors[#sector].unlocked
		and input.gameControlDown(GC_JUMP) and not p.mariomode.levelentry then
			p.mariomode.levelentry = {lvl = point_sectors[#sector].var1, timer = TICRATE/3}
			hud.mariomode.levelentry = p.mariomode.levelentry.timer
		end
	end

	if REQUEST_TELEPORT_TIM and REQUEST_TELEPORT then
		if REQUEST_TELEPORT_TIM == 2 then
			P_SetOrigin(p.mo, REQUEST_TELEPORT.x, REQUEST_TELEPORT.y, REQUEST_TELEPORT.z)
		end
		P_SetOrigin(
		p.mo.mario_camera,
		p.mo.x+cos(angle_cam_offset)*400,
		p.mo.y+sin(angle_cam_offset)*400,
		p.mo.z > HUB_CAMERA_HEIGHT
		and ease.linear(COSNT_ESPEED, p.mo.mario_camera.z, p.mo.z+HUB_CAMERA_HEIGHT)
		or ease.linear(COSNT_ESPEED, p.mo.mario_camera.z, HUB_CAMERA_HEIGHT))
		REQUEST_TELEPORT_TIM = $-1
		if REQUEST_TELEPORT_TIM == 1 then
			REQUEST_TELEPORT = {}
			REQUEST_TELEPORT_TIM = 0
		end
	else
		P_MoveOrigin(
		p.mo.mario_camera,
		p.mo.x+cos(angle_cam_offset)*400,
		p.mo.y+sin(angle_cam_offset)*400,
		p.mo.z > HUB_CAMERA_HEIGHT
		and ease.linear(COSNT_ESPEED, p.mo.mario_camera.z, p.mo.z+HUB_CAMERA_HEIGHT)
		or ease.linear(COSNT_ESPEED, p.mo.mario_camera.z, HUB_CAMERA_HEIGHT))
	end

	if p.mariomode.levelentry then
		p.mariomode.levelentry.timer = $-1
		p.mo.spritexscale = $-FRACUNIT/14
		p.mo.spriteyscale = $-FRACUNIT/14
		p.mo.momx = 0
		p.mo.momy = 0
		p.mo.momz = $-FRACUNIT<<1
		p.powers[pw_nocontrol] = TICRATE

		if not p.mariomode.levelentry.timer then
			G_SetCustomExitVars(p.mariomode.levelentry.lvl, 1)
			G_ExitLevel()

			p.mariomode.levelentry = nil
		end
	end
end)

addHook("PlayerCmd", function(p, cmd)
	if not (mapheaderinfo[gamemap].mm_mario_hub and p and p.mo) then return end
	cmd.buttons = P_IsObjectOnGround(p.mo) and (cmd.buttons & (BT_JUMP|BT_CAMLEFT|BT_CAMRIGHT)) or (cmd.buttons & (BT_CAMLEFT|BT_CAMRIGHT))
end)

addHook("NetVars", function(net)
	xMM_registry.hub_variables = net($)
end)

local QUICK_WARP_MENU = false
local QUICK_WARP_MENU_X_OFFSET = 0
local QUICK_WARP_MENU_ITEMS_DIST = 125
local QUICK_WARP_MENU_Y_OFFSET = 200
local QUICK_WARP_MENU_RANGE = 4
local QUICK_WARP_MENU_FRANGE = 1+QUICK_WARP_MENU_RANGE*2

local QUICK_WARP_MENU_SELECT = {}
local QUICK_WARP_MENU_INDEX = 0
local QUICK_WARP_MENU_ACTUAL_LENGHT = 0

local function Scroll_Table(table, index)
	if index < 1 then
		index = #table + index
	end

	local new_index = ((index - 1) % #table) + 1

	return new_index, table[new_index]
end

local function Update_Selection()
	local temp_select_lvl = {}
	QUICK_WARP_MENU_SELECT = {}

	for _,v in pairs(point_sectors) do
		if not v.unlocked then continue end
		table.insert(temp_select_lvl, v)
	end

	QUICK_WARP_MENU_ACTUAL_LENGHT = #temp_select_lvl

	for i = -QUICK_WARP_MENU_ACTUAL_LENGHT, QUICK_WARP_MENU_ACTUAL_LENGHT << 1 do
		local index, item = Scroll_Table(temp_select_lvl, i)
		QUICK_WARP_MENU_SELECT[i] = item
	end
end

addHook("KeyDown", function(key)
	if gamestate == GS_LEVEL and mapheaderinfo[gamemap].mm_mario_hub then
		if key.num == ctrl_inputs.tfg[1] then
			if QUICK_WARP_MENU then
				QUICK_WARP_MENU = false
				--print("Warp Menu Disabled")
			else
				if not point_sectors then return end

				-- Setting up
				QUICK_WARP_MENU = true
				QUICK_WARP_MENU_INDEX = 1
				Update_Selection()
				--print("Warp Menu Enabled")
			end
			return true
		end

		if QUICK_WARP_MENU then
			if key.num == ctrl_inputs.left[1] or key.num == ctrl_inputs.turl[1] then
				QUICK_WARP_MENU_X_OFFSET = QUICK_WARP_MENU_X_OFFSET > -1 and $+QUICK_WARP_MENU_ITEMS_DIST or QUICK_WARP_MENU_ITEMS_DIST
				QUICK_WARP_MENU_INDEX = QUICK_WARP_MENU_INDEX < QUICK_WARP_MENU_ACTUAL_LENGHT and QUICK_WARP_MENU_INDEX+1 or 1
				return true
			end

			if key.num == ctrl_inputs.right[1] or key.num == ctrl_inputs.turr[1] then
				QUICK_WARP_MENU_X_OFFSET = QUICK_WARP_MENU_X_OFFSET < 1 and $-QUICK_WARP_MENU_ITEMS_DIST or -QUICK_WARP_MENU_ITEMS_DIST
				QUICK_WARP_MENU_INDEX = QUICK_WARP_MENU_INDEX > 1 and QUICK_WARP_MENU_INDEX-1 or QUICK_WARP_MENU_ACTUAL_LENGHT
				return true
			end

			if key.num == ctrl_inputs.jmp[1] then
				REQUEST_TELEPORT = QUICK_WARP_MENU_SELECT[QUICK_WARP_MENU_INDEX]
				REQUEST_TELEPORT_TIM = 3
				return true
			end
		end
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
	local levelpic = v.cachePatch(custom_thumbnail or "MAP01P")
	local color_f = skincolors[color].ramp[2]
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

	local new_x = x >> FRACBITS
	local new_y = y >> FRACBITS

	if anchor_x ~= nil and anchor_y ~= nil then
		Draw_PolygonFill(v, new_x-32, new_y-30, Scale_Polygon(xMM_registry.getPolySpikyCircle((leveltime % 360) + 1), scale + FRACUNIT >> 2, scale + FRACUNIT >> 2), color_f)
		Draw_PolygonFill(v, new_x-32, new_y-32, {{x = 73, y = 50}, {x = 55, y = 50}, {x = anchor_x-new_x+32, y = anchor_y-new_y+16}}, color_f)
	end

	--v.drawScaled(x+ten_frac, y+twenty_frac, scale, star, 0, color)
	if map_data.unlocked then
		v.drawScaled(x+ten_frac, y+ten_frac, scale, levelpic, 0)
		v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, color)

		TBSlib.drawStaticTextUnadjusted(v, 'MA14LT', x+five_frac, y+five_frac, scale, name, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0)
		TBSlib.drawStaticTextUnadjusted(v, 'MA14LT', x+five_frac, y+five_frac+twenty_frac, scale, description, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0)

		TBSlib.drawTextUnadjustedShiftY(v, 'MA12LT', x + 120*scale, y + 90*scale, scale, string.upper(act), 0, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", -2, -4*scale, 0)

		local coin_data = xMM_registry.getSaveData().coins
		if xMM_registry and xMM_registry.levellist and xMM_registry.levellist[map_data.var1] then
			local coins = xMM_registry.levellist[map_data.var1].coins
			for i = 1, #coins do
				local coin = coins[i]
				if coin_data[coin] then
					v.drawScaled(x - eith_frac + twelvteen_frac*i, y+fortyfive_frac, thrddb_scale, xMM_registry.levellist[map_data.var1].new_coin == 1 and v.cachePatch("WONDSPCP") or v.cachePatch("WONDSPC"))
				else
					v.drawScaled(x - eith_frac + twelvteen_frac*i, y+fortyfive_frac, thrddb_scale, v.cachePatch("WONDSPCE"))
				end
			end
		end
	else
		v.drawScaled(x+five_frac, y+five_frac, double_scale, v.cachePatch("MARIOHUBLOCK"), 0)
		v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, color)
	end
end

local prompt_stepscale = FRACUNIT/4
local prompt_target = FRACUNIT-FRACUNIT/4
local prompt_scale = 0

local function Draw_HubLevelPromptAnim(v, x, y, scale, color)
	--local star = v.getSpritePatch("MSTA", C, 0, leveltime * ANG1)
	local coloro = v.getColormap(TC_DEFAULT, color and color or SKINCOLOR_DEFAULT)
	local five_frac = 5*scale
	local double_scale = scale << 1

	x = $-86*scale
	y = $-111*scale

	v.drawScaled(x+five_frac, y+five_frac, double_scale, v.cachePatch("MARIOHUBSTATIC"..(1+(leveltime % 2))), 0)
	v.drawScaled(x, y, scale, v.cachePatch("MARIOHUBICON1"), 0, coloro)
end

local prompts_but = 0
local deny_prt = 1
local move_prt = 2
local conf_prt = 4
local togg_prt = 8

addHook("HUD", function(v, player)
	if player.mo and player.mo.valid and player.mo.mario_camera then
		local sector = player.mo.subsector.sector
		local sel = 0

		prompts_but = togg_prt

		if xMM_registry.hub_variables.MP_voters[#player] then
			local vote = xMM_registry.hub_variables.MP_voters[#player]
			local data = point_sectors[#vote]
			--local cam = player.mo.mario_camera
			--local prompt_location = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = player.mo.x-player.mo.momx, y = player.mo.y-player.mo.momy, z = player.mo.z + player.mo.height + 20*FRACUNIT})

			prompts_but = $|deny_prt
			sel = data.var1

			--v.draw(prompt_location.x>>FRACBITS, prompt_location.y>>FRACBITS+20, v.cachePatch("MARIOHUBFLAG"))
			--v.drawString(prompt_location.x>>FRACBITS, prompt_location.y>>FRACBITS+20, data.var1)
		else
			if not QUICK_WARP_MENU then
				local cam = player.mo.mario_camera
				local prompt_location = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = player.mo.x-player.mo.momx, y = player.mo.y-player.mo.momy, z = player.mo.z + player.mo.height + 20*FRACUNIT})
				if point_sectors and point_sectors[#sector] and prompt_scale >= prompt_target then
					local data = point_sectors[#sector]
					local map = mapheaderinfo[data.var1]
					local point_prompt_l = R_WorldToScreen2({x = cam.x, y = cam.y, z = cam.z, angle = cam.angle, aiming = player.awayviewaiming}, {x = data.x, y = data.y, z = player.mo.floorz})

					//print(point_prompt_l.x >> FRACBITS, point_prompt_l.y >> FRACBITS)
					Draw_HubLevelPrompt(v, prompt_location.x, prompt_location.y, prompt_location.scale, data, map.lvlttl, map.defaultmarioname or "", map.worldprefix..map.worldassigned or map.actnum, "MAP"..(data.var1).."P", HUB_PROMPT_COLOR, FixedInt(point_prompt_l.x), FixedInt(point_prompt_l.y))
					prompts_but = $|conf_prt
				else
					if point_sectors[#sector] or prompt_scale then
						if point_sectors[#sector] then
							HUB_PROMPT_COLOR = HUB_LUT_COLORS[min(point_sectors[#sector].var5, #HUB_LUT_COLORS) or 0]
							prompt_scale = $+prompt_stepscale
							prompts_but = $|conf_prt
						else
							prompt_scale = $-prompt_stepscale
						end
						Draw_HubLevelPromptAnim(v, prompt_location.x, prompt_location.y, FixedMul(prompt_scale, prompt_location.scale), HUB_PROMPT_COLOR)
					end
				end
			end
		end

		QUICK_WARP_MENU_X_OFFSET = ease.linear(FRACUNIT >> 2, QUICK_WARP_MENU_X_OFFSET, 8)

		if QUICK_WARP_MENU then
			QUICK_WARP_MENU_Y_OFFSET = ease.linear(FRACUNIT >> 1, QUICK_WARP_MENU_Y_OFFSET, 30)
			prompts_but = $|move_prt|conf_prt
		else
			QUICK_WARP_MENU_Y_OFFSET = ease.linear(FRACUNIT >> 2, QUICK_WARP_MENU_Y_OFFSET, 210)
		end

		if QUICK_WARP_MENU_Y_OFFSET < 200 and QUICK_WARP_MENU_SELECT then
			local in_v = (#QUICK_WARP_MENU_SELECT >> 1)+QUICK_WARP_MENU_INDEX
			local zigzag = v.cachePatch("MARIOHUBIRAY")
			local zigzag_offset = (zigzag.width >> 2)

			v.draw(leveltime % zigzag_offset - zigzag_offset, 120+QUICK_WARP_MENU_Y_OFFSET, zigzag, V_SNAPTOBOTTOM|V_SNAPTOLEFT)

			for i = -in_v, in_v do
				local data = QUICK_WARP_MENU_SELECT[i+QUICK_WARP_MENU_INDEX-1]
				if not (data and data.var1) then continue end

				local map = mapheaderinfo[data.var1]
				local x = (i*QUICK_WARP_MENU_ITEMS_DIST+QUICK_WARP_MENU_X_OFFSET+30)*FRACUNIT
				local y = (QUICK_WARP_MENU_Y_OFFSET+160)*FRACUNIT
				HUB_PROMPT_COLOR = HUB_LUT_COLORS[min(data.var5, #HUB_LUT_COLORS) or 0]
				Draw_HubLevelPrompt(v, x, y, FRACUNIT >> 1, data, map.lvlttl, map.defaultmarioname or "", map.worldprefix..map.worldassigned or map.actnum, "MAP"..(data.var1).."P", HUB_PROMPT_COLOR)
			end
		end

		if xMM_registry.hub_variables.MP_voting_timer then
			local vote_count = Count_Votes()
			table.sort(vote_count)
			local i = 0

			local vote_bg = v.cachePatch("MARIOHUBIVOTEBG")
			local vote_sbg = v.cachePatch("MARIOHUBIVOTEBG2")
			local empty_bar = v.cachePatch("MARIOHUBIVOTEBARE")
			local full_bar = v.cachePatch("MARIOHUBIVOTEBARF")
			local bar_movement = max((leveltime % (full_bar.width >> 2)) << FRACBITS, 0)
			local bg_movement = max(((vote_bg.width >> 2) - (leveltime % (vote_bg.width >> 2))) << FRACBITS, 0)

			for k, num in pairs(vote_count) do
				i = $+1
			end

			TBSlib.drawTextUnadjusted(v, 'MA17LT', 302 << FRACBITS, 8 << FRACBITS, FRACUNIT, "TIMER", V_SNAPTORIGHT|V_SNAPTOTOP|V_50TRANS, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPURECYANFONT), "right", 0, 1, "0")
			v.drawCropped(175 << FRACBITS, 8 << FRACBITS, FRACUNIT, FRACUNIT, vote_sbg, V_SNAPTORIGHT|V_SNAPTOTOP, nil, 0, 0, 134 << FRACBITS, (15+22*i) << FRACBITS)
			v.drawCropped(176 << FRACBITS, 16 << FRACBITS, FRACUNIT, FRACUNIT, vote_bg, V_SNAPTORIGHT|V_SNAPTOTOP, nil, bg_movement, bg_movement, 130 << FRACBITS, (4+22*i) << FRACBITS)

			v.drawCropped(176 << FRACBITS, 8 << FRACBITS, FRACUNIT, FRACUNIT, empty_bar, V_SNAPTORIGHT|V_SNAPTOTOP, nil, bar_movement, 0, 130 << FRACBITS, 8 << FRACBITS)
			v.drawCropped(176 << FRACBITS, 8 << FRACBITS, FRACUNIT, FRACUNIT, full_bar, V_SNAPTORIGHT|V_SNAPTOTOP, nil, bar_movement, 0, max(((130 << FRACBITS) * xMM_registry.hub_variables.MP_voting_timer)/xMM_registry.hub_voting_time_const, 0), 8 << FRACBITS)
			v.draw(176, 8, v.cachePatch("MARIOHUBIVOTEBARTIMER"), V_SNAPTORIGHT|V_SNAPTOTOP|V_50TRANS)

			i = 0
			for k, num in pairs(vote_count) do
				--v.drawString(176, 16+22*i, (k).."-"..(num))
				local lvlnum = G_BuildMapName(k)

				if sel and k == sel then
					v.draw(154, (22+26*i), v.cachePatch("MARIOHUBIVOTEPICK"), V_SNAPTORIGHT|V_SNAPTOTOP)
				end

				local img_level = v.patchExists(lvlnum.."P") and v.cachePatch(lvlnum.."P") or v.cachePatch("MAP01P")
				v.drawCropped(180 << FRACBITS, (20+26*i) << FRACBITS, FRACUNIT, FRACUNIT, img_level, V_SNAPTORIGHT|V_SNAPTOTOP, nil, 0, img_level.height >> 1, 122 << FRACBITS, 18 << FRACBITS)

				TBSlib.drawTextUnadjusted(v, 'MA17LT', 302 << FRACBITS, (20+26*i) << FRACBITS, FRACUNIT, num, V_SNAPTORIGHT|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "right", 0, 1, "0")
				TBSlib.drawTextUnadjusted(v, 'MA14LT', 180 << FRACBITS, (31+26*i) << FRACBITS, FRACUNIT/3, G_BuildMapTitle(k), V_SNAPTORIGHT|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), "left", 0, 1, "0")
				i = $+1
				if i == 7 then break end
			end
		end

		local button_x = 320

		-- TOGGLE
		if prompts_but & togg_prt then
			local toggl = v.cachePatch("MARIOHUBBUT4")
			button_x = $-(toggl.width >> 1)-10
			v.drawScaled(button_x << FRACBITS, 185 << FRACBITS, FRACUNIT >> 1, toggl, V_SNAPTORIGHT|V_SNAPTOBOTTOM)
		end

		-- MOVE
		if prompts_but & move_prt then
			local toggl = v.cachePatch("MARIOHUBBUT3")
			button_x = $-(toggl.width >> 1)-10
			v.drawScaled(button_x << FRACBITS, 185 << FRACBITS, FRACUNIT >> 1, toggl, V_SNAPTORIGHT|V_SNAPTOBOTTOM)
		end

		-- DENY
		if prompts_but & deny_prt then
			local toggl = v.cachePatch("MARIOHUBBUT1")
			button_x = $-(toggl.width >> 1)-10
			v.drawScaled(button_x << FRACBITS, 185 << FRACBITS, FRACUNIT >> 1, toggl, V_SNAPTORIGHT|V_SNAPTOBOTTOM)
		end

		-- ACCEPT
		if prompts_but & conf_prt then
			local toggl = v.cachePatch("MARIOHUBBUT2")
			button_x = $-(toggl.width >> 1)-10
			v.drawScaled(button_x << FRACBITS, 185 << FRACBITS, FRACUNIT >> 1, toggl, V_SNAPTORIGHT|V_SNAPTOBOTTOM)
		end
	end
end, "game")