--
-- STARTING CUTSCENES
--

local current_start_cutscene = 0

local cutscene_time = {
	100, TICRATE, 100
}

-- MT_GENERALWAYPOINT
-- mapthing.args[0] == Pathway ID
-- mapthing.args[1] = Point ID
-- mapthing.args[2] = Easing
-- mapthing.args[3] = Duration(1 = TICRATE)
-- mapthing.args[4] = Enum{Waypoint(0), Starting point(1), Ending point(2)}
-- mapthing.args[6] = Flags WC_*
-- mapthing.args[7] = Action
-- mapthing.args[8] = var1
-- mapthing.args[9] = var2

-- container, path, way, a_x, a_y, a_z, a_angle, a_roll, a_pitch, a_options, a_stringoptions
local start_cutscenes = {
	[1] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1
		if timer == cutscene_time[1] then
			local x,y,z = camera.x, camera.y, camera.z
			P_SetOrigin(mo, mo.x-128*cos(mo.angle), mo.y-128*sin(mo.angle), mo.z+820 << FRACBITS)
			mo.mariomode.temp_cam_path = {}
			TBSWaylib.slotPathway(mo.mariomode.temp_cam_path, 1)
			for i = 1,5 do
				local dist = 528-i*8
				TBSWaylib.addWaypoint(mo.mariomode.temp_cam_path, 1, i,
				mo.x-dist*cos(mo.angle + ANGLE_90*i), mo.y-dist*sin(mo.angle + ANGLE_90*i), mo.z-(250 << FRACBITS)*i, mo.angle + ANGLE_90*i, 0, 0,
				{[0] = 1, i, 7, 50-i*10, 0, 0, 0, 0, 0}, {nil, nil})
			end
			TBSWaylib.activateCamera(a, mo.mariomode.temp_cam_path, 1, 1, 1)
			S_PauseMusic(p)
		end
		if timer <= 69 then
			TBSWaylib.DeactivateCamera()
			mo.mariomode.temp_cam_path = nil
			TBSWaylib.lerpCameraToPlayerPosition(mo, camera, FRACUNIT/28)
		else
			TBSWaylib.SelfPathwayCameraController(camera, false, false)
		end
		if P_IsObjectOnGround(mo) then
			hud.mariomode.title_ticker[#p] = 200
			S_SetMusicPosition(0)
			S_ResumeMusic(p)
			p.tempmariomode.cutscenetimer = nil
			p.realtime = 0
			return
		end
		if mo.state ~= S_PLAY_FALL then
			mo.state = S_PLAY_FALL
		end
		mo.momx = 8*cos(mo.angle)
		mo.momy = 8*sin(mo.angle)
		p.realtime = 0
	end,
	[2] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1
		if timer < TICRATE-10 then
			mo.momx = 20*cos(mo.angle)
			mo.momy = 20*sin(mo.angle)
			mo.momz = 20 << FRACBITS
			mo.state = S_PLAY_PAIN
			p.drawangle = mo.angle+ANG20*timer
		end
		if timer == 1 then
			hud.mariomode.title_ticker[#p] = 200
			p.tempmariomode.cutscenetimer = nil
			return
		end
	end,
	[3] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1
		if timer == cutscene_time[1] then
			P_SetOrigin(mo, mo.x-900*cos(mo.angle), mo.y-900*sin(mo.angle), mo.z+400 << FRACBITS)
			mo.momx = 30*cos(mo.angle)
			mo.momy = 30*sin(mo.angle)
		end
		if mo.state ~= S_PLAY_ROLL then
			mo.state = S_PLAY_ROLL
		end
		if P_IsObjectOnGround(mo) then
			mo.state = S_PLAY_SKID
			hud.mariomode.title_ticker[#p] = 0
			p.tempmariomode.cutscenetimer = nil
			return
		end
	end,
}

addHook("PlayerSpawn", function(p)
	if p.starpostnum > 0 then return end
	local num = mapheaderinfo[gamemap].startingcutscenenum or 0
	--print(num, mapheaderinfo[gamemap].startingcutscenenum)
	p.tempmariomode.cutscenetimer = cutscene_time[tonumber(num)] or 0
	current_start_cutscene = tonumber(num)
end)

addHook("PlayerThink", function(p)
	if p.tempmariomode.cutscenetimer then
		p.tempmariomode.cutscenetimer = $-1

		if p.mo and p.mo.valid and start_cutscenes[current_start_cutscene] then
			start_cutscenes[current_start_cutscene](p, p.mo)
		end
	else
		return
	end
end)

