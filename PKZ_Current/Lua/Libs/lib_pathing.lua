/*
		Team Blue Spring's Series of Libaries.
		Pathing Library - lib_pathing.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

local libWay = {
	stringversion = '0.1',
	iteration = 1,

	pathing_map = {},
}

local debug = CV_RegisterVar({
	name = "tbs_waypointdebug",
	defaultvalue = "off",
	flags = 0,
	PossibleValue = {off=0, pointsonly=1, full=2}
})


//
// Team Blue Spring's Series of Libaries.
// Simple Waypoint System
//


//
//	Todo:
//	-- Path-Target Approximation polish
//	-- Entrance point approximation (You don't want smooth camera entrance transition???????? wtf)
//

local Waypoints = {}
local TaggedObj = {}
local AvailableControllers = {}
local TBS_CamWayVars = {
	active = false;
	container = nil;
	id = 0;
	pos = 0;
	progress = 0;
	nextway = 0;
	prevway = 0;
}

addHook("MapChange", function()
	Waypoints = {}
	TaggedObj = {}
	AvailableControllers = {}
	TBS_CamWayVars = {
		active = false;
		id = 0;
		pos = 0;
		progress = 0;
		nextway = 0;
		prevway = 0;
	}
end)

-- MT_GENERALWAYPOINT
// mapthing.args[0] = Pathway ID
// mapthing.args[1] = Point ID
// mapthing.args[2] = Easing
// mapthing.args[3] = Duration(1 = TICRATE)
// mapthing.args[4] = Enum{Waypoint(0), Starting point(1), Ending point(2)}
// mapthing.args[6] = Flags WC_*
// mapthing.args[7] = Action
// mapthing.args[8] = var1
// mapthing.args[9] = var2
// mapthing.stringargs[0] = tag -- if objects allows for it

//
//	ACTION THINKERS
//

local NumToStringAction = {
	"WAY_FORCESTOP",
	"WAY_CHANGESCALE",
	"WAY_CHANGETRACK",
	"WAY_TRIGGERTAG";
}

local StringtoFunctionA = {
	//Stop movement for specific amount of time
	//var1 - stops the train for amount of time
	["WAY_FORCESTOP"] = function(a, var1, var2)
		if not a.tbswaypoint.pause then
			a.tbswaypoint.pause = var1
			a.tbswaypoint.pausebool = true
		end

		if a.tbswaypoint.pause then
			a.tbswaypoint.pause = $-1
			a.tbswaypoint.progress = $-1
		else
			a.tbswaypoint.pausebool = false
		end
	end;

	//Change object scale
	//var1 - amount of scale per tic
	//var2 - target scale
	["WAY_CHANGESCALE"] = function(a, var1, var2)
		if var2 > a.scale+var1 then
			a.scale = $+var1
		elseif var2 < a.scale-var1 then
			a.scale = $-var1
		end
	end;

	//Target Different Track
	//var1 - target track ID
	//var2 - target pathway ID
	["WAY_CHANGETRACK"] = function(a, var1, var2)
		a.tbswaypoint.id = var1
		a.tbswaypoint.pos = var2
		a.tbswaypoint.progress = Waypoints[var1][var2].starttics
	end;

	//Triggers anything using this tag
	//var1 - tag
	["WAY_TRIGGERTAG"] = function(a, var1, var2)
		P_LinedefExecute(var1, a)
	end;
}

//
//	FLAG Constants... yes WC how funny.
//

local WC_DOWNMOBJ = 1 		-- Puts mobj down.
local WC_UNBINDPLAYER = 2 	-- Unbinds player from holding contraption.
local WC_HIDEHUD = 4		-- Hides player's hud
local WC_SHOWHUD = 8		-- Shows player's hud
local WC_PUSHHUD = 16		-- Pushes away player's hud
local WC_BRINGHUD = 32		-- Brings in player's hud
local WC_STOPFORDIALOG = 64	-- Dialog stop

//
//	Flag constants for controller
//

local CC_MOVEMENTACT = 1	-- 	Movement on Activation
local CC_ORIGINSMOBJ = 2	-- 	Count Mobj's Origin point as very first point
local CC_REMOVENOGRV = 4	-- 	Remove MF_NOGRAVITY after removal from system
local CC_RESETPOSTOZ = 8	-- 	When there is no next waypoint, teleport at 0
local CC_IFZEROACTIV = 16	-- 	If on pos 0, it will require outside activation
local CC_REVERSEMOVE = 32	-- 	Reverse Movement
local CC_GRAVITYFORC = 64	-- 	Only manipulate X|Y
local CC_DONTTELEPOR = 128	-- 	Doesn't teleport object to start
local CC_APPRXTARGET = 256  --	Appoximates Object target
local CC_DONTROTATEO = 512  --	Doesn't rotate Angle
local CC_MOONWALKFOR = 1024 --  Moon walk lol
local CC_MOMENTUMEND = 2048 --  Gives momentum after end


freeslot("MT_GENERALWAYPOINT", "MT_PATHWAYCONTROLLER")
mobjinfo[MT_PATHWAYCONTROLLER] = {
//$Category TBS Library
//$Name Pathway Controller
//$Sprite BOM1A0
	doomednum = 2701,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY
}

mobjinfo[MT_GENERALWAYPOINT] = {
//$Category TBS Library
//$Name Generalize Waypoint
//$Sprite BOM1A0
	doomednum = 2700,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY
}

local function isminusorplus(s)
	if s > 0 then
		return 1
	else
		return -1
	end
end


local SwitchEasing = {
	[0] = function(t, s, e) return ease.linear(t, s, e) end;
	[1] = function(t, s, e) return ease.outsine(t, s, e) end;
	[2] = function(t, s, e) return ease.outexpo(t, s, e) end;
	[3] = function(t, s, e) return ease.outquad(t, s, e) end;
	[4] = function(t, s, e) return ease.outback(t, s, e) end;
	[5] = function(t, s, e) return TBSlib.quadBezier(t, s, s+isminusorplus(s)*abs(e-s)>>2, e) end;
	[6] = function(t, s, e) return TBSlib.quadBezier(t, s, s-isminusorplus(s)*abs(e-s)>>2, e) end;
	[7] = function(t, s, e) return TBSlib.quadBezier(t, s, s+isminusorplus(s)*abs(e-s)>>1, e) end;
	[8] = function(t, s, e) return TBSlib.quadBezier(t, s, s-isminusorplus(s)*abs(e-s)>>1, e) end;
	[9] = function(t, s, e) return TBSlib.quadBezier(t, s, s+isminusorplus(s)*abs(e-s)/3, e) end;
	[10] = function(t, s, e) return TBSlib.quadBezier(t, s, s-isminusorplus(s)*abs(e-s)/3, e) end;
}

local function Math_CheckPositive(num)
	if num > 0 then
		return true
	elseif num == 0 then
		return nil
	else
		return false
	end
end

local function Path_CheckPositionInWaypoints(current, list)
	local nextway, prevway = 0, 0

	local nextone = false
	for k, v in ipairs(list) do
		if nextone then
			nextway = v
			break
		end

		if v == current and not nextone then
			nextone = true
		else
			prevway = v
		end
	end

	if not nextway then
		nextway = list[1]
	end

	if not prevway then
		prevway = list[#list]
	end

	return nextway, prevway
end

local function Path_IfNextPoint(data, progress)
	if progress == FRACUNIT then
		data.pos = data.nextway
		data.progress = Waypoints[data.id][data.nextway].starttics+1
	end
	if progress == 0 then
		data.progress = Waypoints[data.id][data.prevway].starttics+(Waypoints[data.id][data.pos].spawnpoint.args[3]*TICRATE)-1
		data.pos = data.prevway
	end
end

local function Path_IfNextPointContainer(container, data, progress)
	if progress == FRACUNIT then
		data.pos = data.nextway
		data.progress = container[data.id][data.nextway].starttics+1
	end
	if progress == 0 then
		data.progress = container[data.id][data.prevway].starttics+(container[data.id][data.pos].spawnpoint.args[3]*TICRATE)-1
		data.pos = data.prevway
	end
end

libWay.activateMapExecute = function(line,mobj,sector)
	if not (mobj.player or AvailableControllers[line.args[1]]) then return end
	local controller = AvailableControllers[line.args[1]]

	mobj.tbswaypoint = {
		id = controller.spawnpoint.args[0];
		pos = controller.spawnpoint.args[1];
		progress = Waypoints[controller.spawnpoint.args[0]][controller.spawnpoint.args[1]].starttics;
		flip = false;
		-- original flags so, I could simply turn them on
		flags = target.flags;
		flags2 = target.flags2;
	}

	target.flags = $|MF_NOGRAVITY
	target.tbswaypoint.nextway, target.tbswaypoint.prevway = Path_CheckPositionInWaypoints(target.tbswaypoint.pos, Waypoints[target.tbswaypoint.id].timeline)
end

addHook("LinedefExecute", libWay.activateMapExecute, "TBS_WAY")

libWay.activateCameraExecute = function(line,mobj,sector)
	if not AvailableControllers.camera[line.args[1]] then return end
	local controller = AvailableControllers[line.args[1]]

	TBS_CamWayVars.id = controller.spawnpoint.args[0];
	TBS_CamWayVars.pos = controller.spawnpoint.args[1];
	TBS_CamWayVars.progress = Waypoints[controller.spawnpoint.args[0]][controller.spawnpoint.args[1]].starttics;

	TBS_CamWayVars.nextway, TBS_CamWayVars.prevway = Path_CheckPositionInWaypoints(TBS_CamWayVars.pos, Waypoints[TBS_CamWayVars.id].timeline)
	TBS_CamWayVars.active = true;
end

addHook("LinedefExecute", libWay.activateCameraExecute, "TBS_CWAY")

libWay.activate = function(target, path, point, nogravity)
	target.tbswaypoint = {
		id = path;
		pos = point;
		progress = (Waypoints[path] and (Waypoints[path][point] and Waypoints[path][point].starttics)) or 0;
		flip = false;
		-- original flags so, I could simply turn them on
		flags = target.flags;
		flags2 = target.flags2;
	}

	if not nogravity then
		target.flags = $|MF_NOGRAVITY
	end
	target.tbswaypoint.nextway, target.tbswaypoint.prevway = Path_CheckPositionInWaypoints(target.tbswaypoint.pos, Waypoints[target.tbswaypoint.id or 1].timeline)
end

libWay.activateCamera = function(target, container, path, point, progress)
	TBS_CamWayVars = {
		container = container;
		active = true;
		id = path;
		pos = point;
		progress = progress;
	}
	TBS_CamWayVars.nextway, TBS_CamWayVars.prevway = Path_CheckPositionInWaypoints(TBS_CamWayVars.pos, container[TBS_CamWayVars.id].timeline)
end

libWay.DeactivateCamera = function()
	TBS_CamWayVars = {
		active = false;
		id = 0;
		pos = 0;
		progress = 0;
		nextway = 0;
		prevway = 0;
	}
end

libWay.slotPathway = function(container, path)
	if not (container[path]) then
		container[path] = {}
		container[path].timeline = {}
	end
end

-- direct
libWay.returnGlobalPathway = function(id)
	return Waypoints[id]
end

libWay.addWaypoint = function(container, path, way, a_x, a_y, a_z, a_angle, a_roll, a_pitch, a_options, a_stringoptions)
	if not container[path][way] then
		table.insert(container[path].timeline, way)
		table.sort(container[path].timeline, function(a, b) return a < b end)

		container[path][way] = {starttics = 0; x = a_x; y = a_y; z = a_z;
		angle = a_angle; roll = a_roll; pitch = a_pitch;
		spawnpoint = {args = a_options; stringargs = a_stringoptions}}

		container[path].tics = 0
		for k,v in ipairs(container[path]) do
			if k <= way then
				container[path][way].starttics = $+container[path][way].spawnpoint.args[3]
			end
			container[path].tics = $+container[path][way].spawnpoint.args[3]
		end
	end
end

libWay.delWaypoint = function(container, path, way)
	if container[path][way] then
		container[path][way] = nil

		for k,v in ipairs(container[path]) do
			if k <= way then
				container[path][way].starttics = $+container[path][way].spawnpoint.args[3]
			end
			container[path].tics = $+container[path][way].spawnpoint.args[3]
		end
	end
end

libWay.progressConversionFixed = function(waypointinfo, progress, waypointobj, nextwaypoint)
	return SwitchEasing[waypointinfo.args[2]](progress, FixedInt(waypointobj.x), FixedInt(nextwaypoint.x)),
	SwitchEasing[waypointinfo.args[2]](progress, FixedInt(waypointobj.y), FixedInt(nextwaypoint.y)),
	SwitchEasing[waypointinfo.args[2]](progress, FixedInt(waypointobj.z), FixedInt(nextwaypoint.z))
end

libWay.pathingFixedRotate = function(t, angle, nextAngle)
	local dif = nextAngle - angle
	if dif > ANGLE_180 and dif <= ANGLE_MAX then
		dif = $ - ANGLE_MAX
	end
	return angle + FixedAngle(FixedMul(AngleFixed(dif), t))
end

libWay.pathingFixedMove = function(a, controller, progress, waypointinfo, waypointobj, nextwaypoint, flatMode)
	local x, y, z = libWay.progressConversionFixed(waypointinfo, progress, waypointobj, nextwaypoint)
	if not (controller.spawnpoint.args[3] & CC_DONTROTATEO) then
		local angleg = libWay.pathingFixedRotate(progress, waypointobj.angle, nextwaypoint.angle)
		a.angle = a.tbswaypoint.flip and InvAngle(angleg) or angleg
	end

	if flatMode then
		P_TryMove(a, x << FRACBITS, y << FRACBITS, false)
	else
		P_MoveOrigin(a, x << FRACBITS, y << FRACBITS, z << FRACBITS)
	end
end

libWay.pathingFixedMoveCamera = function(a, controller, progress, waypointinfo, waypointobj, nextwaypoint)
	local x, y, z = libWay.progressConversionFixed(waypointinfo, progress, waypointobj, nextwaypoint)
	local angleg = SwitchEasing[waypointinfo.args[2]](progress, waypointobj.angle, nextwaypoint.angle)
	a.angle = TBS_CamWayVars.flip and InvAngle(angleg) or angleg

	P_TeleportCameraMove(camera, x << FRACBITS, y << FRACBITS, z << FRACBITS)
end

libWay.lerpToPointSimple = function(a, target, t)
	local x, y, z, angle
	local fixedangle_a, fixedangle_target = AngleFixed(a.angle), AngleFixed(target.angle)

	x = a.x + FixedMul(target.x - a.x, t)
	y = a.y + FixedMul(target.y - a.y, t)
	z = a.z + FixedMul(target.z - a.z, t)
	angle = FixedAngle(fixedangle_a + FixedMul(fixedangle_target - fixedangle_a, t))

	return x, y, z, angle
end


libWay.lerpToPoint = function(a, target, t)
	local x, y, z, angle, roll, pitch
	local fixedangle_a, fixedangle_target = AngleFixed(a.angle), AngleFixed(target.angle)
	local fixedpitch_a, fixedpitch_target = AngleFixed(a.pitch), AngleFixed(target.pitch)
	local fixedroll_a, fixedroll_target = AngleFixed(a.roll), AngleFixed(target.roll)

	x = a.x + FixedMul(target.x - a.x, t)
	y = a.y + FixedMul(target.y - a.y, t)
	z = a.z + FixedMul(target.z - a.z, t)
	angle = FixedAngle(fixedangle_a + FixedMul(fixedangle_target - fixedangle_a, t))
	pitch = FixedAngle(fixedpitch_a + FixedMul(fixedpitch_target - fixedpitch_a, t))
	roll = FixedAngle(fixedroll_a + FixedMul(fixedroll_target - fixedroll_a, t))

	return x, y, z, angle, pitch, roll
end

libWay.lerpToPointTargeted = function(a, target, t)
	local x, y, z, angle, roll, pitch
	local fixedangle_a, fixedangle_target = AngleFixed(a.angle), AngleFixed(target.angle)
	local fixedpitch_a, fixedpitch_target = AngleFixed(a.pitch), AngleFixed(target.pitch)
	local fixedroll_a, fixedroll_target = AngleFixed(a.roll), AngleFixed(target.roll)

	x = a.x + FixedMul(target.x - a.x, t)
	y = a.y + FixedMul(target.y - a.y, t)
	z = a.z + FixedMul(target.z - a.z, t)
	angle = FixedAngle(fixedangle_a + FixedMul(fixedangle_target - fixedangle_a, t))
	pitch = FixedAngle(fixedpitch_a + FixedMul(fixedpitch_target - fixedpitch_a, t))
	roll = FixedAngle(fixedroll_a + FixedMul(fixedroll_target - fixedroll_a, t))

	return x, y, z, angle, pitch, roll, P_AproxDistance(a.z - target.z, P_AproxDistance(a.x - target.x, a.y - target.y)) < 5*TICRATE
end

libWay.lerpToPointTargetedSimple = function(a, target, t)
	local x, y, z, angle, roll, pitch
	local fixedangle_a, fixedangle_target = AngleFixed(a.angle), AngleFixed(target.angle)

	x = a.x + FixedMul(target.x - a.x, t)
	y = a.y + FixedMul(target.y - a.y, t)
	z = a.z + FixedMul(target.z - a.z, t)
	angle = FixedAngle(fixedangle_a + FixedMul(fixedangle_target - fixedangle_a, t))

	return x, y, z, angle, P_AproxDistance(a.z - target.z, P_AproxDistance(a.x - target.x, a.y - target.y)) < 5*TICRATE
end

libWay.lerpObjToPoint = function(self, a, target, t)
	local x, y, z, angle, pitch, roll = self.lerpToPoint(a, target, t)

	P_TeleportMove(a, x, y, z)
	a.angle = angle
	a.pitch = pitch
	a.roll = roll

	if (P_AproxDistance(a.z - target.z, P_AproxDistance(a.x - target.x, a.y - target.y)) < 3 << FRACBITS) then return true end
	return false
end

libWay.getCameraToPlayerPosition = function(mo, cam)
	local dist = FixedMul(tonumber(CV_FindVar("cam_dist").value), mo.scale)
	local height = FixedMul(tonumber(CV_FindVar("cam_height").value), mo.scale)
	local target_x, target_y, target_z = mo.x - FixedMul(dist, cos(mo.angle)), mo.y - FixedMul(dist, sin(mo.angle)), mo.z+height

	return target_x, target_y, target_z
end

libWay.lerpCameraToPlayerPosition = function(mo, cam, t)
	if not mo.valid then return end
	cam.momx = 0
	cam.momy = 0
	cam.momz = 0

	local dist = FixedMul(tonumber(CV_FindVar("cam_dist").value), mo.scale)
	local height = FixedMul(tonumber(CV_FindVar("cam_height").value), mo.scale)

	local fixedangle_a, fixedangle_target = AngleFixed(cam.angle), AngleFixed(mo.angle)
	local target_x, target_y, target_z = mo.x - FixedMul(dist, cos(mo.angle)), mo.y - FixedMul(dist, sin(mo.angle)), mo.z+height

	cam.angle = FixedAngle(fixedangle_a + FixedMul(fixedangle_target - fixedangle_a, t))
	P_TeleportCameraMove(cam, cam.x + FixedMul(target_x - cam.x, t), cam.y + FixedMul(target_y - cam.y, t), cam.z + FixedMul(target_z - cam.z, t))
end

local DEFAULT_MAX = FRACUNIT*16383

libWay.searchClosestPointPathWay = function(a, pathway)
	local point_id, start_point, sec_point_id, end_point, line_len
	local point_dist = DEFAULT_MAX
	local path = Waypoints[pathway]
	local timeline = path.timeline

	if timeline then
		for i = 1,#timeline do
			local current_point_id = timeline[i]
			local current_point = path[current_point_id]
			local current_dist = abs(R_PointToDist2(a.x, a.y, current_point.x, current_point.y))
			if point_dist > current_dist then
				point_dist = current_dist
				point_id = current_point_id
				start_point = current_point
			end
		end

		if not start_point then return end

		local next_point_id, prev_point_id = Path_CheckPositionInWaypoints(point_id, path.timeline)
		local prev_point, next_point = path[prev_point_id], path[next_point_id]
		local prev_dist = P_AproxDistance(a.z - prev_point.z, P_AproxDistance(a.x - prev_point.x, a.y - prev_point.y))
		local next_dist = P_AproxDistance(a.z - next_point.z, P_AproxDistance(a.x - next_point.x, a.y - next_point.y))

		if prev_dist < next_dist then
			sec_point_id = point_id
			point_id = prev_point_id
			line_len = prev_dist
		else
			sec_point_id = next_point_id
			line_len = next_dist
		end

		return point_id, sec_point_id, point_dist, line_len
	else
		return nil
	end
end

libWay.searchApproximatePointPathWay = function(a, pathway)
	local point_id, sec_point_id, point_dist, line_len = libWay.searchClosestPointPathWay(a, pathway)
	local path = Waypoints[pathway]
	local start_point, end_point = path[point_id], path[sec_point_id]

	if not (start_point and end_point) then return end
	local projected_len = FixedDiv(FixedMul(a.x - start_point.x, end_point.x - start_point.x)
	+ FixedMul(a.y - start_point.y, end_point.y - start_point.y) + FixedMul(a.z - start_point.z, end_point.z - start_point.z), line_len)

	local progress = min(max(abs(projected_len), 1), FRACUNIT-1)
	local x, y, z = libWay.progressConversionFixed(start_point.spawnpoint, progress, start_point, end_point)

	return x, y, z, progress, point_id
end

-- varation for Camera position adjuements
libWay.lerpCameraToPoint = function(self, cam, target, t)
	local x, y, z, angle = self.lerpToPointSimple(cam, target, t)

	P_TeleportCameraMove(cam, x, y, z)
	cam.angle = angle

	if R_PointToDist2(cam.z, target.z, R_PointToDist2(cam.x, target.x, cam.y, target.y)) < 3*FRACUNIT then return true end
	return false
end

-- direct
libWay.directionPos = function(a, path_angle)
	local ang = a.angle+path_angle
	if ang < ANGLE_180 and ang > ANGLE_MAX then
		return 1
	else
		return -1
	end
end

libWay.directPosPerMomentum = function(self, a, path_angle)
	local direction = self:directionPos(a, path_angle)
	local momentum = FixedHypot(a.momz, FixedHypot(a.momx, a.momy))
	if momentum then
		return direction
	else
		return 0
	end
end

libWay.closestPathToTarget = function(pathway, target)
	local distancefirst = INT32_MAX
	local point_idfirst = 0

	local dropDist = {}

	for k,p in ipairs(pathway) do
		dropDist[k] = P_AproxDistance(P_AproxDistance(target.x - p.x, target.y - p.y), target.z - p.z)
		if distancefirst > dropDist[k] then
			distancefirst = dropDist[k]
			point_idfirst = k
		end
	end

	local angle_h = R_PointToDist2(pathway[point_idfirst].x, pathway[point_idfirst].y, target.x, target.y)
	local angle_v = R_PointToDist2(pathway[point_idfirst].y, pathway[point_idfirst].z, target.y, target.z)

	return {distancefirst, point_idfirst, angle_h, angle_v}
end

-- less accurate approximation
-- libWay.approxDistToTarget(pathway, target)
libWay.approxDistToTarget = function(pathway, target)
	local table = libWay.closestPathToTarget(pathway, target)
	if not table[2] then return 0 end

	local nexttopath, prev = Path_CheckPositionInWaypoints(table[2], pathway.timeline)
	local pointdist = R_PointToDist2(pathway[table[2]].x, pathway[table[2]].y, pathway[nexttopath].x, pathway[nexttopath].y)

	local duration = pathway[table[2]].spawnpoint.args[3] << FRACBITS
	local starttime = pathway[table[2]].starttics

	local pyth = FixedMul(table[1], FixedMul(cos(table[3]), sin(table[4])))

	return starttime+FixedMul(FixedDiv(pyth, pointdist), duration) >> FRACBITS
end

libWay.calAvgSpeed = function(container, path, way)
	local nextway = Path_CheckPositionInWaypoints(way, container[path].timeline)
	local distance = P_AproxDistance(P_AproxDistance(
		container[path][way].x - container[path][nextway].x,
		container[path][way].y - container[path][nextway].y),
		container[path][way].z - container[path][nextway].z
	)
	return (distance / (container[path][way].spawnpoint.args[3]*TICRATE) or 0)
end

libWay.deactive = function(target, controller, container)
	target.flags = target.tbswaypoint.flags
	target.flags2 = target.tbswaypoint.flags2
	target.tbswaypoint = nil

	if controller and (controller.spawnpoint.args[3] or controller.wayflags) then
		local flags = controller.spawnpoint.args[3] or controller.wayflags
		if flags & CC_MOMENTUMEND then
			libWay.calAvgSpeed(container, target.tbswaypoint.id, target.tbswaypoint.pos)
		end
	end
end

local function WaypointSetup(a, mt)
	if not (Waypoints[mt.args[0]]) then
		Waypoints[mt.args[0]] = {}
		Waypoints[mt.args[0]].timeline = {}
	end

	if not Waypoints[mt.args[0]][mt.args[1]] then
		table.insert(Waypoints[mt.args[0]].timeline, mt.args[1])
		table.sort(Waypoints[mt.args[0]].timeline, function(a, b) return a < b end)

		Waypoints[mt.args[0]][mt.args[1]] = {starttics = 0; x = mt.x << FRACBITS; y = mt.y << FRACBITS; z = a.z;
		angle = mt.angle*ANG1; roll = mt.roll*ANG1; pitch = mt.pitch*ANG1;
		spawnpoint = {args = mt.args; stringargs = mt.stringargs}}

		Waypoints[mt.args[0]].tics = 0
		for k,v in ipairs(Waypoints[mt.args[0]]) do
			if k <= mt.args[1] then
				Waypoints[mt.args[0]][mt.args[1]].starttics = $+Waypoints[mt.args[0]][k].spawnpoint.args[3]*TICRATE
			end
			Waypoints[mt.args[0]].tics = $+Waypoints[mt.args[0]][k].spawnpoint.args[3]*TICRATE
		end
	end

	P_RemoveMobj(a)
end

local function MapThingCheck(a, mt)
	if not mt.tag then return false end
	if not (TaggedObj[mt.tag]) then
		TaggedObj[mt.tag] = {}
	end
	table.insert(TaggedObj[mt.tag], a)
end

//
//	Controller
//	mobj.spawnpoint.args[0] -- ID
//	mobj.spawnpoint.args[1]	-- Position
//	mobj.spawnpoint.args[2]	-- Movement Type -> {0 = Linear Movement, 1 = Averaging Track to Target}
//	mobj.spawnpoint.args[3] -- Flags CC_*
//	mobj.spawnpoint.tag 	-- Used for tagging object to path and activation
//



local function ControllerThinker(mobj)
	if not (mobj.spawnpoint or TaggedObj[mobj.spawnpoint.tag]) then return end
	for _,a in ipairs(TaggedObj[mobj.spawnpoint.tag]) do

		//
		//	GENERAL
		//

		if not (a.tbswaypoint) then
			libWay.activate(a, mobj.spawnpoint.args[0], mobj.spawnpoint.args[1])
		end

		//
		//	PROGRESSION
		//

		local flipObj = false

		if (mobj.spawnpoint.args[3] & CC_APPRXTARGET) and a.target then
			local targetprogress = libWay.approxDistToTarget(Waypoints[a.tbswaypoint.id], a.target)
			if targetprogress > a.tbswaypoint.progress then
				a.tbswaypoint.flip = false
				a.tbswaypoint.progress = $+1
			elseif targetprogress < a.tbswaypoint.progress then
				a.tbswaypoint.flip = true
				a.tbswaypoint.progress = $-1
			end
		else
			if not (mobj.spawnpoint.args[3] & CC_REVERSEMOVE) then
				a.tbswaypoint.flip = false
				a.tbswaypoint.progress = $+1
			else
				a.tbswaypoint.flip = true
				a.tbswaypoint.progress = $-1
			end
		end

		local waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
		local waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint

		local progress = ((a.tbswaypoint.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3]*TICRATE)

		if progress == 0 or progress == FRACUNIT then
			Path_IfNextPoint(a.tbswaypoint, progress)
			a.tbswaypoint.nextway, a.tbswaypoint.prevway = Path_CheckPositionInWaypoints(a.tbswaypoint.pos, Waypoints[a.tbswaypoint.id].timeline)
		end


		//
		//	POSITION
		//

		waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
		waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint
		local nextwaypoint = Waypoints[a.tbswaypoint.id][a.tbswaypoint.nextway]

		progress = ((a.tbswaypoint.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3]*TICRATE)
		libWay.pathingFixedMove(a, mobj, progress, waypointinfo, waypointobj, nextwaypoint)

		//	Action
		if waypointinfo.args[7] > 0 and waypointinfo.args[7] <= #NumToStringAction then
			StringtoFunctionA[NumToStringAction[waypointinfo.args[7]]](a, var1, var2)
		end

		//
		//	PLAYER
		//

		if a.p and waypointinfo.stringargs[0] ~= "" and a.state ~= waypointinfo.stringargs[0] then
			a.state = waypointinfo.stringargs[0]
		end

		//
		//	SPECIAL CASES
		//

		if waypointinfo.args[6] & WC_DOWNMOBJ then
			libWay.deactive(a, mobj, Waypoints)
			table.remove(TaggedObj, mobj.spawnpoint.tag)
		end
	end
end

libWay.SelfPathwayController = function(a, flipObj, FlatMode)
	if not a.spawnpoint then return end

	//
	//	PROGRESSION
	//

	if (a.spawnpoint.args[3] & CC_APPRXTARGET) and a.target then
		local targetprogress = libWay.approxDistToTarget(Waypoints[a.tbswaypoint.id], a.target)
		if targetprogress > a.tbswaypoint.progress then
			a.tbswaypoint.flip = false
			a.tbswaypoint.progress = $+1
		elseif targetprogress < a.tbswaypoint.progress then
			a.tbswaypoint.flip = true
			a.tbswaypoint.progress = $-1
		end
	else
		if not (a.spawnpoint.args[3] & CC_REVERSEMOVE) then
			a.tbswaypoint.flip = false
			a.tbswaypoint.progress = $+1
		else
			a.tbswaypoint.flip = true
			a.tbswaypoint.progress = $-1
		end
	end

	local waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
	local waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint

	local progress = ((a.tbswaypoint.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3]*TICRATE)

	if progress == 0 or progress == FRACUNIT then
		Path_IfNextPoint(a.tbswaypoint, progress)
		a.tbswaypoint.nextway, a.tbswaypoint.prevway = Path_CheckPositionInWaypoints(a.tbswaypoint.pos, Waypoints[a.tbswaypoint.id].timeline)
	end


	//
	//	POSITION
	//

	waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
	waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint
	local nextwaypoint = Waypoints[a.tbswaypoint.id][a.tbswaypoint.nextway]

	progress = ((a.tbswaypoint.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3]*TICRATE)
	libWay.pathingFixedMove(a, a, progress, waypointinfo, waypointobj, nextwaypoint, FlatMode)

	//	Action
	if waypointinfo.args[7] > 0 and waypointinfo.args[7] <= #NumToStringAction then
		StringtoFunctionA[NumToStringAction[waypointinfo.args[7]]](a, var1, var2)
	end
end

libWay.SelfPathwayCameraController = function(a, flipObj)

	local container = TBS_CamWayVars.container
	a.momx = 0
	a.momy = 0
	a.momz = 0

	//
	//	PROGRESSION
	//
	if TBS_CamWayVars.approximate and TBS_CamWayVars.target then
		local targetprogress = libWay.approxDistToTarget(container[TBS_CamWayVars.id], TBS_CamWayVars.target)
		if targetprogress > TBS_CamWayVars.progress then
			TBS_CamWayVars.flip = false
			TBS_CamWayVars.progress = $+1
		elseif targetprogress < TBS_CamWayVars.progress then
			TBS_CamWayVars.flip = true
			TBS_CamWayVars.progress = $-1
		end
	else
		if not flipObj then
			TBS_CamWayVars.flip = false
			TBS_CamWayVars.progress = $+1
		else
			TBS_CamWayVars.flip = true
			TBS_CamWayVars.progress = $-1
		end
	end

	local waypointobj = container[TBS_CamWayVars.id][TBS_CamWayVars.pos]
	local waypointinfo = container[TBS_CamWayVars.id][TBS_CamWayVars.pos].spawnpoint

	local progress = ((TBS_CamWayVars.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3] or 1)

	if progress == 0 or progress == FRACUNIT then
		Path_IfNextPointContainer(container, TBS_CamWayVars, progress)
		TBS_CamWayVars.nextway, TBS_CamWayVars.prevway = Path_CheckPositionInWaypoints(TBS_CamWayVars.pos, container[TBS_CamWayVars.id].timeline)
	end


	//
	//	POSITION
	//

	waypointobj = container[TBS_CamWayVars.id][TBS_CamWayVars.pos]
	waypointinfo = container[TBS_CamWayVars.id][TBS_CamWayVars.pos].spawnpoint
	local nextwaypoint = container[TBS_CamWayVars.id][TBS_CamWayVars.nextway]

	progress = ((TBS_CamWayVars.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3] or 1)
	libWay.pathingFixedMoveCamera(a, a, progress, waypointinfo, waypointobj, nextwaypoint)

	//	Action
	if waypointinfo.args[7] > 0 and waypointinfo.args[7] <= #NumToStringAction then
		StringtoFunctionA[NumToStringAction[waypointinfo.args[7]]](a, var1, var2)
	end
end

local function CameraControllerThinker(mobj)
	//
	//	GENERAL
	//

	if not (TBS_CamWayVars.active) then
		local WPdummy = Waypoints[mobj.spawnpoint.args[0]]
		TBS_CamWayVars = {
			active = true;
			id = mobj.spawnpoint.args[0];
			pos = mobj.spawnpoint.args[1];
			progress = WPdummy[mobj.spawnpoint.args[1]].starttics;
		}
		TBS_CamWayVars.nextway, TBS_CamWayVars.prevway = Path_CheckPositionInWaypoints(TBS_CamWayVars.pos, Waypoints[TBS_CamWayVars.id].timeline)
	end

	//
	//	PROGRESSION
	//

	if not (mobj.spawnpoint.args[3] & CC_REVERSEMOVE) then
		TBS_CamWayVars.progress = $+1
	else
		TBS_CamWayVars.progress = $-1
	end

	local waypointobj = Waypoints[TBS_CamWayVars.id][TBS_CamWayVars.pos]
	local waypointinfo = Waypoints[TBS_CamWayVars.id][TBS_CamWayVars.pos].spawnpoint
	local progress = ((TBS_CamWayVars.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3])

	if progress == 0 or progress == FRACUNIT then
		Path_IfNextPoint(TBS_CamWayVars, progress)
		TBS_CamWayVars.nextway, TBS_CamWayVars.prevway = Path_CheckPositionInWaypoints(TBS_CamWayVars.pos, Waypoints[TBS_CamWayVars.id].timeline)
	end


	//
	//	POSITION
	//

	waypointobj = Waypoints[TBS_CamWayVars.id][TBS_CamWayVars.pos]
	waypointinfo = Waypoints[TBS_CamWayVars.id][TBS_CamWayVars.pos].spawnpoint
	progress = ((TBS_CamWayVars.progress-waypointobj.starttics) << FRACBITS)/(waypointinfo.args[3])

	local nextwaypoint = Waypoints[TBS_CamWayVars.id][TBS_CamWayVars.nextway]
	local x = SwitchEasing[waypointinfo.args[2]](progress, waypointobj.x >> FRACBITS, nextwaypoint.x >> FRACBITS)
	local y = SwitchEasing[waypointinfo.args[2]](progress, waypointobj.y >> FRACBITS, nextwaypoint.y >> FRACBITS)
	local z = SwitchEasing[waypointinfo.args[2]](progress, waypointobj.z >> FRACBITS, nextwaypoint.z >> FRACBITS)


	camera.angle = SwitchEasing[waypointinfo.args[2]](progress, waypointobj.angle, nextwaypoint.angle)
	P_TeleportCameraMove(camera, x << FRACBITS, y << FRACBITS, z << FRACBITS)

	//	Action
	if waypointinfo.args[7] > 0 and waypointinfo.args[7] <= #NumToStringAction then
		StringtoFunctionA[NumToStringAction[waypointinfo.args[7]]](camera, var1, var2)
	end


	//
	//	SPECIAL CASES
	//

	if nextwaypoint.spawnpoint.args[6] & WC_DOWNMOBJ and progress == (FRACUNIT-1) then
		TBS_CamWayVars.active = false
	end
end

/*
addHook("MobjThinker", function(a)
	if not a.spawnpoint then return end

	if a.tbswaypoint and a.tbswaypoint.reached then
		SelfControllerThinker(a, false, false)
		a.tbswaypoint.sequencepos = nil
	else
		if not (a.tbswaypoint and a.tbswaypoint.sequencepos) then
			libWay.activate(a, a.spawnpoint.args[0], a.spawnpoint.args[1])
			local t_x, t_y, t_z, progress, pos = libWay.searchApproximatePointPathWay(a, a.spawnpoint.args[0])
			a.tbswaypoint.sequencepos = {x = t_x*FRACUNIT, y = t_y*FRACUNIT, z = t_z*FRACUNIT, angle = R_PointToAngle2(a.x, a.y, t_x*FRACUNIT, t_y*FRACUNIT)}
			a.tbswaypoint.progress = progress
			a.tbswaypoint.pos = pos
			a.tbswaypoint.reached = {}
		end
		local x, y, z, angle, reached = libWay.lerpToPointTargetedSimple(a, a.tbswaypoint.sequencepos, FRACUNIT/16)
		P_MoveOrigin(a, x, y, z)
		a.angle = angle
		a.tbswaypoint.reached = reached
	end

	return true
end, MT_BLUECRAWLA)

addHook("MobjThinker", function(a)
	if not a.spawnpoint then return end

	if a.tbswaypoint and a.tbswaypoint.reached then
		SelfControllerThinker(a, false, true)
		a.momx, a.momy = 0, 0
		a.tbswaypoint.sequencepos = nil
		return nil
	else
		if not (a.tbswaypoint and a.tbswaypoint.sequencepos) then
			libWay.activate(a, a.spawnpoint.args[0], a.spawnpoint.args[1], true)
			local t_x, t_y, t_z, progress, pos = libWay.searchApproximatePointPathWay(a, a.spawnpoint.args[0])
			a.tbswaypoint.sequencepos = {x = t_x*FRACUNIT, y = t_y*FRACUNIT, z = t_z*FRACUNIT, angle = R_PointToAngle2(a.x, a.y, t_x*FRACUNIT, t_y*FRACUNIT)}
			a.tbswaypoint.progress = progress
			a.tbswaypoint.pos = pos
			a.tbswaypoint.reached = {}
		end
		local x, y, z, angle, reached = libWay.lerpToPointTargetedSimple(a, a.tbswaypoint.sequencepos, FRACUNIT/16)
		P_MoveOrigin(a, x, y, z)
		a.angle = angle
		a.tbswaypoint.reached = reached
		return true
	end
end, MT_MINUS)
*/

//
//	PLAYER SET UP
//

addHook("KeyDown", function(key)
	if consoleplayer and consoleplayer.taggedtowaypoint then
		return true
	end
end)


//
// AI Pathfinding
//

local block_map = {}
local map_limit_size = 32767 << FRACBITS

libWay.updateBlockPathingMap = function(precision)
	local block = map_limit_size/precision
	local block_int = FixedInt(block)
	local block_hal = block/2
	block_map.precision = precision
	block_map.size = block_int

	for x = -block_int, block_int do
		block_map[x] = {}
		for y = -block_int, block_int do
			local sub_sector = R_PointInSubsectorOrNil(block*x+block_hal, block*y+block_hal)
			if sub_sector then
				local sector = sub_sector.sector
				if sector and sector.floorheight < sector.cloorheight then
					block_map[x][y] = {
						f = sector.f_slope and P_GetZAt(sector.f_slope, block*x+block_hal, block*y+block_hal) or sector.floorheight,
						c = sector.c_slope and P_GetZAt(sector.c_slope, block*x+block_hal, block*y+block_hal) or sector.cloorheight,
					}
				else
					block_map[x][y] = nil
				end
			else
				block_map[x][y] = nil
			end
		end
	end
end

libWay.getShardPathingMap = function(map, x_pos, y_pos, precision, block_radius, cblock_map)
	local shard_of_pathing_map = {}
	shard_of_pathing_map.precision = cblock_map.precision
	shard_of_pathing_map.size = block_radius

	for x = -block_radius, block_radius do
		shard_of_pathing_map[x] = {}
		for y = -block_radius, block_radius do
			if cblock_map[x_pos+x][y_pos+y] then
				shard_of_pathing_map[x][y] = cblock_map[x_pos+x][y_pos+y]
			end
		end
	end

	return shard_of_pathing_map
end

/*
libWay.findPath = function(start, goal, map, path)
	local closedset = {}
	local openset = {start}
	local came_from = {}

	local g_score = {}
	local f_score = {}

	g_score[start] = 0
	f_score[start] = P_AproxDistance(R_PointToDist2(start.x, start.y, goal.x, goal.y), goal.z-start.z)

	while #openset > 0 do



	end

end
*/

addHook("NetVars", function(net)
	Waypoints = net($)
	TaggedObj = net($)
	AvailableControllers = net($)
end)

rawset(_G, "TBSWaylib", libWay)
addHook("MapThingSpawn", MapThingCheck)
addHook("MapThingSpawn", WaypointSetup, MT_GENERALWAYPOINT)

addHook("MobjThinker", ControllerThinker, MT_PATHWAYCONTROLLER)