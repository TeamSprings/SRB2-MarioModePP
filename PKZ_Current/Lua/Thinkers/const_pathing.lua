/* 
		Pipe Kingdom Zone's Pathing - const_pathing.lua

Description:
Objects based on pathways

Contributors: Skydusk
@Team Blue Spring 2024
*/

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


local function Path_IfNextPoint(data, progress, pathway)
	if progress == FRACUNIT then
		data.pos = data.nextway
		data.progress = pathway[data.nextway].starttics+1
	end
	if progress == 0 then
		data.progress = pathway[data.prevway].starttics+(pathway[data.pos].spawnpoint.args[3]*TICRATE)-1
		data.pos = data.prevway
	end	
end

local FRAC_FORTYEITH = 48<<FRACBITS
local FRAC_NITESIX = FRACUNIT/96
local FRAC_TWELVE = 12 << FRACBITS

-- Edit of Homing Attack for Trains
local function P_HomingMomentumToPoint(a, point, flipObj) // Home in on your target
	// change slope
	local zdist = point.z - a.z
	local dist = P_AproxDistance(point.x - a.x, point.y - a.y)
	local dddist = P_AproxDistance(dist, zdist)
	local jaw = R_PointToAngle2(0, 0, dist, zdist)
	
	a.velocity = a.velocity ~= nil and min(a.velocity+sin(InvAngle(jaw << 1))+(FRAC_NITESIX), FRAC_FORTYEITH) or 0
	local ns = FixedMul(max(a.velocity+FRAC_TWELVE, FRAC_TWELVE), a.scale)

	if dddist <= ns then
		return flipObj and 0 or FRACUNIT
	end	

	a.momx = FixedMul(FixedDiv(point.x - a.x, dddist), ns)
	a.momy = FixedMul(FixedDiv(point.y - a.y, dddist), ns)
	a.momz = FixedMul(FixedDiv(zdist, dddist), ns)
	a.angle = TBSWaylib.pathingFixedRotate(FixedDiv(ns, dddist), a.angle, point.angle)
end

local function P_DummySpawner(a)
	local dummy_head = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_POPPARTICLEMAR)
	dummy_head.state = a.state
	dummy_head.fuse = 4*TICRATE
	dummy_head.momx = a.momx
	dummy_head.momy = a.momy
	dummy_head.momz = a.momz
	dummy_head.flags = $ &~ (MF_NOGRAVITY)
end

local function P_TrainPathwayController(a, flipObj)
	if not a.tbswaypoint then return end
	
	local current_data = a.tbswaypoint
	local current_pathway = TBSWaylib.returnGlobalPathway(current_data.id)
	local waypointobj = current_pathway[current_data.pos]
	local nextwaypoint = current_pathway[current_data.nextway]
		
	local progress = P_HomingMomentumToPoint(a, flipObj and waypointobj or nextwaypoint, flipObj)
		
	if progress == 0 or progress == FRACUNIT then
		if nextwaypoint.spawnpoint.args[6] & 1 then
			local segments = a.seg_list
			local first = current_pathway[1]
			P_DummySpawner(a)		
			for i = 1, #segments do
				local dist = i<<4
				local seg = segments[i]
				if not seg.lastpost then
					seg.lastpos = {x = seg.x, y = seg.y, z = seg.z, momx = seg.momx, momy = seg.momy, momz = seg.momz, angle = seg.angle}
				end
				P_DummySpawner(seg)
				P_MoveOrigin(seg, first.x-dist*cos(first.angle), first.y-dist*sin(first.angle), first.z)
				seg.angle = first.angle
			end
			P_MoveOrigin(a, first.x, first.y, first.z)
			a.angle = first.angle
			a.tbswaypoint.pos = 1
			progress = 1			
			a.tbswaypoint.reached = true			
		end
		Path_IfNextPoint(current_data, progress, current_pathway)
		a.tbswaypoint.nextway, a.tbswaypoint.prevway = Path_CheckPositionInWaypoints(current_data.pos, current_pathway.timeline)
	end	
end

//
// C-Lua translation of A_DragonSegment
//

local function P_Segment_Follow(a)
	if not a.nextseg then return end
	local t = a.nextseg
  
	local dist = P_AproxDistance(P_AproxDistance(a.x - t.x, a.y - t.y), a.z - t.z)
	local radius = 5*a.radius >> 1 + t.radius << 1
	local hangle = R_PointToAngle2(t.x, t.y, a.x, a.y)
	local zangle = R_PointToAngle2(0, t.z, dist, a.z)
	local hdist = P_ReturnThrustX(t, zangle, radius)
	local xdist = P_ReturnThrustX(t, hangle, hdist)
	local ydist = P_ReturnThrustY(t, hangle, hdist)
	local zdist = P_ReturnThrustY(t, zangle, radius)

	a.angle = InvAngle(hangle)
	P_MoveOrigin(a, t.x + xdist, t.y + ydist, t.z + zdist)

	if a.tracer then
		local p = a.tracer 
	end
end

//  -- Dino Skeleton Trains (PKZ 1-4) -> Re-use

addHook("MapThingSpawn", function(a, mt)
	if not mt.args[0] then return end
	
	a.seg_list = {}
	for i = 1, max(mt.args[0], 1) do
		local dist = i<<4
		local angle = InvAngle(a.angle)
		local seg = P_SpawnMobjFromMobj(a, dist*cos(angle), dist*sin(angle), 0, MT_PKZBONETRAINSEG)
		seg.angle = a.angle
		seg.seg_id = i
		a.seg_list[i] = seg
		seg.nextseg = a.seg_list[i-1] or a
		seg.head = a
	end
	
	-- Waypoint data, ('pathway id, pathway point')
	a.extravalue1 = mt.args[1]
	a.extravalue2 = mt.args[2]
	
	-- Momentum speed
	a.speed = 0
	
	if mt.args[3] then
		a.alwaysActive = true
	end
end, MT_PKZBONETRAINHEAD)

addHook("MobjThinker", function(a)
	if not a.tbswaypoint then 
		TBSWaylib.activate(a, a.extravalue1, a.extravalue2, true)	
	end
	
	if a.alwaysActive then
		a.tbswaypoint.active = true
		a.tbswaypoint.reached = false	
	end

	if a.tbswaypoint.active then
		P_TrainPathwayController(a, false)
	elseif a.tbswaypoint.reached and a.tbswaypoint.active then
		a.tbswaypoint.progress = 1
		a.tbswaypoint.reached = false
		a.tbswaypoint.active = false
	end	
end, MT_PKZBONETRAINHEAD)

addHook("MobjThinker", function(a)
	P_Segment_Follow(a)
	if a.lastpost and a.head and a.head.tbswaypoint and not a.head.tbswaypoint.reached then
		a.lastpos = nil				
	end	
end, MT_PKZBONETRAINSEG)

addHook("TouchSpecial", function(a, t)
	if not (t and t.player and t.valid and t.player.valid) then return true end
	local p = t.player

	if a.head.tbswaypoint and a.head.tbswaypoint.reached and a.lastpos then
		p.powers[pw_carry] = CR_NONE
		P_ResetPlayer(p)		
		P_MoveOrigin(t, a.lastpos.x, a.lastpos.y, a.lastpos.z)
		t.momx = a.lastpos.momx
		t.momy = a.lastpos.momy
		t.momz = a.lastpos.momz
		t.angle = a.lastpos.angle
		return true
	end

	if P_MobjFlip(t)*t.momz > 0 or p.powers[pw_carry] then
		return true
	end
	
	if (t.z > a.z + a.height >> 1)
		return true
	end

	if (t.z + t.height >> 1 < a.z)
		return true
	end

	if not p.powers[pw_ignorelatch] then
		P_ResetPlayer(p)
		t.angle = a.angle		
		t.tracer = a

		p.powers[pw_carry] = CR_GENERIC
		if a.head.tbswaypoint then
			a.head.tbswaypoint.active = true
		end
	end
	return true
end, MT_PKZBONETRAINSEG)

/*

local function P_WaterpoolSpawner()


end

local function P_WaterpoolController()
	//	-- Waterpool for PKZ2 -> Special Controller
	//		-- Allow "2D" movement while in the state
	//		-- They going to use specialized controllers
	//		-- Repeatable
	//		-- Spawn bunch of particles...

end

local all_players_ready = false


local function dragontrain_run(a)
  if not (a.spawnpoint or      TaggedObj[a.spawnpoint.tag]) then return end
  
	if not (a.tbswaypoint) then
		libWay.activate(a, a, a.spawnpoint.args[0], a.spawnpoint.args[1])
	end

  if not (a.spawnpoint.args[3] & CC_REVERSEMOVE) then
		a.tbswaypoint.flip = false				
		a.tbswaypoint.progress = $+1
	else
		a.tbswaypoint.flip = true
		a.tbswaypoint.progress = $-1
  end

	local waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
	local waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint		
		
	local progress = ((a.tbswaypoint.progress-waypointobj.starttics)*FRACUNIT)/(waypointinfo.args[3]*TICRATE)		
		
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

		progress = ((a.tbswaypoint.progress-waypointobj.starttics)*FRACUNIT)/(waypointinfo.args[3]*TICRATE)	
		libWay.pathingFixedMove(a, a, progress, waypointinfo, waypointobj, nextwaypoint)

		//
		//	SPECIAL CASES
		//
		
	if waypointinfo.args[6] & WC_DOWNMOBJ then
	  libWay.deactive(a, a, Waypoints)
		table.remove(TaggedObj, a.spawnpoint.tag)
	end
  
end


local function waterpool_run(mobj)
  if not (mobj.spawnpoint or      TaggedObj[mobj.spawnpoint.tag] or a.target) then return end
  local a = a.target
  
	if not (a.tbswaypoint) then
		libWay.activate(mobj, a, mobj.spawnpoint.args[0], a.spawnpoint.args[1])
    a.tbswaypoint.x-offset = 0
    a.tbswaypoint.y-offset = 0
	end

  if not (mobj.spawnpoint.args[3] & CC_REVERSEMOVE) then
		a.tbswaypoint.flip = false				
		a.tbswaypoint.progress = $+1
	else
		a.tbswaypoint.flip = true
		a.tbswaypoint.progress = $-1
  end

	local waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]
	local waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint		
		
	local progress = ((a.tbswaypoint.progress-waypointobj.starttics)*FRACUNIT)/(waypointinfo.args[3]*TICRATE)		
		
	if progress == 0 or progress == FRACUNIT then
			Path_IfNextPoint(a.tbswaypoint, progress)
			a.tbswaypoint.nextway, a.tbswaypoint.prevway = Path_CheckPositionInWaypoints(a.tbswaypoint.pos, Waypoints[a.tbswaypoint.id].timeline)			
	end

		//
		//	POSITION
		//		

    a.tbswaypoint.x-offset = max(min(mobj.radius, a.tbswaypoint.x-offset), -mobj.radius)
    a.tbswaypoint.y-offset = max(min(mobj.radius, a.tbswaypoint.y-offset), -mobj.radius)
  
		waypointobj = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos]	
		waypointinfo = Waypoints[a.tbswaypoint.id][a.tbswaypoint.pos].spawnpoint
		local nextwaypoint = Waypoints[a.tbswaypoint.id][a.tbswaypoint.nextway]

		progress = ((a.tbswaypoint.progress-waypointobj.starttics)*FRACUNIT)/(waypointinfo.args[3]*TICRATE)	
		libWay.pathingFixedMove(a, a, progress, waypointinfo, waypointobj, nextwaypoint)

		//
		//	SPECIAL CASES
		//
		
	if waypointinfo.args[6] & WC_DOWNMOBJ then
	  libWay.deactive(a, mobj, Waypoints)
		table.remove(TaggedObj, mobj.spawnpoint.tag)
	end
  
end

*/