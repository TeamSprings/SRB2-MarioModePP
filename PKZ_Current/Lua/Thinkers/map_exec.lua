/*
		Pipe Kingdom Zone's Map Scripts - map_exec.lua

Description:
Map execs and node scripts

Contributors: Skydusk
@Team Blue Spring 2024

Used to have:
	Zipper - Bounce Map Executor
*/

//
// MAP EXECUTORS
//

local function seatcheck(l,a,s)
    if not a.player then return end

	if a.subsector.sector == s then
		a.playerconfirm = true
		if CV_FindVar("pkz_debug").value == 1
			print("seated")
		end
	end
end

addHook("LinedefExecute", seatcheck, "SEATSCH")

//  Static bounce special used for purple mushrooms
//	Custom linedef executer by Zipper

local function minuscomp(num)	return (num > 0 and true or false)
end

local function minusorplus(num)
	return (num > 0 and 1 or -1)
end


local function bigBounce(line,mobj,sector)
	local normal = {}
	local strength = FixedHypot(line.dx, line.dy) >> 3
	if sector.c_slope or sector.f_slope then
		if line.args[0] > 0 and sector.f_slope then
			local tempnormal = sector.f_slope.normal
			normal.x = -tempnormal.x
			normal.y = -tempnormal.y
			normal.z = -tempnormal.z
		elseif sector.c_slope then
			normal = sector.c_slope.normal
		end
		mobj.momx = FixedMul(strength, normal.x)
		mobj.momy = FixedMul(strength, normal.y)
		mobj.angle = R_PointToAngle2(0, 0, normal.x, normal.y)
	else
		normal = {x = 0, y = 0, z = line.args[0] > 0 and -FRACUNIT or FRACUNIT}
	end

    mobj.momz = FixedMul(strength, normal.z)

	S_StartSound(nil, sfx_mar64d)
	local spawnbounceparticle = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_POPPARTICLEMAR)
	spawnbounceparticle.fuse = 45
	spawnbounceparticle.scale = mobj.scale << 1
	spawnbounceparticle.angle = mobj.angle
	spawnbounceparticle.source = mobj
	spawnbounceparticle.renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD|RF_SLOPESPLAT

	if not mobj.player then return end

	mobj.player.pflags = $ | PF_JUMPED
	if (skins[mobj.skin].flags & SF_NOJUMPSPIN) then
		mobj.state = S_PLAY_SPRING
	else
	    mobj.state = S_PLAY_JUMP
    end

end

addHook("LinedefExecute", bigBounce, "MUSHBNC")

local function waterSwoosh(line,mobj,sector)
	local xyangle, zangle

	if not line.args[2] then return end

	if line.args[0] then
		zangle = (line.args[0]*ANG1) or 0
		xyangle = (line.args[1]*ANG1) or 0
	else
		xyangle, zangle = 0, 0
	end

    mobj.momz = $+(zangle and sin(zangle)*8 or FRACUNIT*8)/line.args[2]
	if zangle ~= 0 then
		mobj.momx = $+cos(xyangle)*8/line.args[2]
		mobj.momy = $+sin(xyangle)*8/line.args[2]
	end

    --S_StartSound(nil, sfx_mar64d)

	if not mobj.player then return end

	mobj.player.pflags = $ | PF_JUMPED | PF_THOKKED
	mobj.player.ticrotatedraw = (mobj.player.ticrotatedraw and $+2 or 2)
	mobj.player.rotatecalldraw = true
	mobj.state = S_PLAY_PAIN
end


addHook("PlayerThink", function(p)
	if p.ticrotatedraw and p.ticrotatedraw > 0 then
		p.drawangle = ANG1*p.ticrotatedraw*20
		p.ticrotatedraw = $-1
		if p.ticrotatedraw and p.rotatecalldraw == false then
			p.mo.state = S_PLAY_FALL
			p.ticrotatedraw = 0
		end
		if p.rotatecalldraw == true then
			p.rotatecalldraw = false
		end
	end

	if p.mo and p.mo.valid then
		if p.mo.lastrecordedimpactmomz == nil then
			p.mo.lastrecordedimpactmomz = 0
		end

		if ((P_MobjFlip(p.mo) > 0 and p.mo.lastrecordedimpactmomz > p.mo.momz) or
		(P_MobjFlip(p.mo) < 0 and p.mo.lastrecordedimpactmomz < p.mo.momz)) then
			p.momzimpacttimer = 9
			p.mo.lastrecordedimpactmomz = p.mo.momz
			--print(p.mo.lastrecordedimpactmomz..''..p.momzimpacttimer)
		end

		if p.momzimpacttimer then
			p.momzimpacttimer = $-1
			if p.momzimpacttimer == 0 then
				p.mo.lastrecordedimpactmomz = 0
			end
		end

	end
end)

addHook("LinedefExecute", waterSwoosh, "SWOOMAR")


local function chanLvlTag(line,mobj,sector)
    if not mobj.player then return end
	local player = mobj.player

	if line.stringargs[1] and player.marlevnum ~= line.stringargs[1] then
		player.marlevnum = line.args[0].."-"..line.args[1]
		player.marlevname = line.stringargs[1]
		player.marlevnumgm = gamemap
		hud.mariomode.title_ticker[#player] = 200
	end

end

addHook("MapLoad", function()
	for player in players.iterate() do
		if player.marlevnumgm and gamemap ~= player.marlevnumgm then
			player.marlevnum = nil
			player.marlevnumgm = nil
		end

		hud.mariomode.title_ticker[#player] = 200
	end

end)

addHook("LinedefExecute", chanLvlTag, "LVLTAGC")

local c5 = FixedDiv(AngleFixed(ANGLE_MAX), 4*FRACUNIT+FRACUNIT/2)

local function easeInOutElastic(x)
	local X_20X = 20*x
	return x == 0 and 0 or x == FRACUNIT and 1 or x < FRACUNIT/2 and
	-(FixedMul(FixedMul(X_20X-10*FRACUNIT, X_20X-10*FRACUNIT), sin(FixedAngle(FixedMul(X_20X - 729088, c5)))))/2 or
	(FixedMul(FixedMul(X_20X-10*FRACUNIT, X_20X-10*FRACUNIT), sin(FixedAngle(FixedMul(X_20X - 729088, c5))))/2)+1
end

local function elasticMoveSector(line,mobj,sector)
	if line.frontsector and line.backsector and sector then
		local control_sector = line.frontsector
		local back_sector = line.backsector
		local easing = sin(leveltime*ANG1/16)
		local floor_lenght = abs(control_sector.floorheight - back_sector.floorheight)
		local ceiling_lenght = abs(control_sector.ceilingheight - back_sector.ceilingheight)
		sector.floorheight = control_sector.floorheight+FixedMul(floor_lenght, easing)
		sector.ceilingheight = control_sector.floorheight+FixedMul(ceiling_lenght, easing)
	end
end

addHook("LinedefExecute", elasticMoveSector, "ELASTSEC")

-- arg1: offset floor, arg2: offset ceiling, arg3: time, arg4: offset per item, arg5: pause_delay
TBS_LUATAGGING.scripts["WONDESC"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {floorheight = sector.floorheight, ceilingheight = sector.ceilingheight, time = 0,
			flip = false, pause = 0, const_time = FRACUNIT/(arg3 or 1), dest_floor = sector.floorheight+arg1 << FRACBITS, dest_ceil = sector.ceilingheight+arg2 << FRACBITS}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]

		if origin.time == arg3+1 then
			origin.flip = (not origin.flip)
			origin.pause = arg5 or 0
			origin.time = 0
		end

		if not origin.pause then
			local progress = origin.time*origin.const_time
			if origin.flip then
				sector.floorheight = ease.inoutquint(progress, origin.floorheight, origin.dest_floor)
				sector.ceilingheight = ease.inoutquint(progress, origin.ceilingheight, origin.dest_ceil)
			else
				sector.floorheight = ease.inoutquint(progress, origin.dest_floor, origin.floorheight)
				sector.ceilingheight = ease.inoutquint(progress, origin.dest_ceil, origin.ceilingheight)
			end
			origin.time = $+1
		else
			origin.pause = $-1
		end
	end
end

-- arg1: radius
TBS_LUATAGGING.scripts["WHEIGHTSLOPEDPLATFORM"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {angle = nil, standed_on = false, weight = 0, floorheight = sector.floorheight, ceilingheight = sector.ceilingheight}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]

		if not (sector.f_slope and sector.c_slope) then return end
		local floor = sector.f_slope
		local ceiling = sector.c_slope
		floor.o = {x = a.x, y = a.y, z = origin.floorheight}
		ceiling.o = {x = a.x, y = a.y, z = origin.ceilingheight}
		//print("slope found!")

		local radius = (arg1 << FRACBITS)
		local x_1 = a.x-radius
		local x_2 = a.x+radius
		local y_1 = a.y-radius
		local y_2 = a.y+radius

		if origin.weight > 0 then
			origin.weight = max(origin.weight, -ANGLE_45)
			floor.zangle = -origin.weight
			ceiling.zangle = -origin.weight
		end

		if origin.angle then
			floor.xydirection = origin.angle
			ceiling.xydirection = origin.angle
		end

		searchBlockmap("objects", function(ref, found)
			if found.standingslope and (found.standingslope == ceiling or found.standingslope == floor) then
				local distance = R_PointToDist2(ref.x, ref.y, found.x, found.y)
				origin.weight = $+FixedDiv(FixedDiv(distance, FixedMul(found.radius, found.height)), radius)*125000
				origin.standed_on = true
				origin.z = P_GetZAt(found.standingslope, found.x, found.y)
				if not origin.angle then
					origin.angle = R_PointToAngle2(ref.x, ref.y, found.x, found.y)
				else
					origin.angle = TBSWaylib.pathingFixedRotate(FRACUNIT/24, origin.angle, R_PointToAngle2(ref.x, ref.y, found.x, found.y))
				end
				--print(origin.weight)
			end
		end, a, x_1, x_2, y_1, y_2)

		if not origin.standed_on then
			origin.weight = TBSlib.lerp(FRACUNIT/38, origin.weight, 0)
			if origin.weight < FRACUNIT then
				origin.angle = nil
				origin.weight = 0
			end
		end

		origin.standed_on = false
	end
end

-- arg1: radius, arg2: max_offset, arg3: transfer sector weight tag, arg4: transfer weight linedef scroll tag,
TBS_LUATAGGING.scripts["WHEIGHTPLATFORM"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {currentlyused = false, floorweight = 0, ceilweight = 0, floorheight = sector.floorheight, ceilingheight = sector.ceilingheight}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]

		local radius = arg1 << FRACBITS
		local max_offset = arg2 << FRACBITS

		local x_1 = a.x-radius
		local x_2 = a.x+radius
		local y_1 = a.y-radius
		local y_2 = a.y+radius
		local current_floor_offset = abs(origin.floorheight - sector.floorheight)
		local current_ceil_offset = abs(origin.ceilingheight - sector.ceilingheight)


		if origin.floorweight ~= 0 and current_floor_offset < max_offset then
			sector.floorheight = $+origin.floorweight
		end

		if origin.ceilweight ~= 0 and current_ceil_offset < max_offset then
			sector.ceilingheight = $+origin.ceilweight
		end

		searchBlockmap("objects", function(ref, found)
			if P_IsObjectOnGround(found) and found.lastrecordedimpactmomz and (found.floorrover == sector or found.subsector.sector == sector) then
				if P_MobjFlip(found) > 0 then
					origin.floorweight = $+found.lastrecordedimpactmomz
				else
					origin.ceilweight = $+found.lastrecordedimpactmomz
				end
				found.lastrecordedimpactmomz = 0
				origin.currentlyused = true
				--print('floor:'..origin.floorweight..' ceiling:'..origin.ceilweight)
			end
		end, a, x_1, x_2, y_1, y_2)

		if origin.floorweight == 0 then
			sector.floorheight = TBSlib.lerp(FRACUNIT/38, sector.floorheight, origin.floorheight)
		end

		if origin.ceilweight == 0 then
			sector.ceilingheight = TBSlib.lerp(FRACUNIT/38, sector.ceilingheight, origin.ceilingheight)
		end

		if origin.currentlyused then
			if arg3 then
				for off_sector in sectors.tagged(arg3) do
					if not TBS_LUATAGGING.sector_custom_vars[#off_sector] then
						TBS_LUATAGGING.sector_custom_vars[#off_sector] = {floorweight = 0, ceilweight = 0, floorheight = off_sector.floorheight, ceilingheight = off_sector.ceilingheight}
					end
					TBS_LUATAGGING.sector_custom_vars[#off_sector].floorweight = -origin.floorweight
					TBS_LUATAGGING.sector_custom_vars[#off_sector].ceilweight = -origin.ceilweight
				end
			end

			if arg4 then
				for line in lines.tagged(arg4) do
					if not TBS_LUATAGGING.line_custom_vars[#line] then
						TBS_LUATAGGING.line_custom_vars[#line] = {current_yshift = 0, front_offset_y = line.frontside.rowoffset, back_offset_y = line.backside.rowoffset,}
					end
					TBS_LUATAGGING.line_custom_vars[#line].current_yshift = -(origin.floorweight+origin.ceilweight) << 1
				end
			end
		end

		origin.currentlyused = false
		origin.floorweight = abs(origin.floorweight) > FRACUNIT and TBSlib.lerp(FRACUNIT/20, origin.floorweight, 0) or 0
		origin.ceilweight = abs(origin.ceilweight) > FRACUNIT and TBSlib.lerp(FRACUNIT/20, origin.ceilweight, 0) or	0
	end
end

local MAX_LINE_OFFSETY = (1 << 12) << FRACBITS

TBS_LUATAGGING.scripts["IMPACTYOFFSETSLINEDEF"] = function(line_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	for i = 1, #line_list do
		local line = line_list[i]
		if not TBS_LUATAGGING.line_custom_vars[#line] then
			TBS_LUATAGGING.line_custom_vars[#line] = {current_yshift = 0, front_offset_y = line.frontside.rowoffset, back_offset_y = line.backside.rowoffset,}
		end
		local origin = TBS_LUATAGGING.line_custom_vars[#line]
		origin.current_yshift = min(max(origin.current_yshift, -MAX_LINE_OFFSETY), MAX_LINE_OFFSETY)
		local linear_v = origin.current_yshift and FixedDiv(FRACUNIT, origin.current_yshift)
		local front_y_delta = abs(origin.front_offset_y - line.frontside.rowoffset)
		local back_y_delta =  abs(origin.back_offset_y - line.backside.rowoffset)

		if origin.current_yshift == 0 then
			line.frontside.rowoffset = TBSlib.lerp(front_y_delta and FixedDiv(FRACUNIT, front_y_delta), line.frontside.rowoffset, origin.front_offset_y)
			line.backside.rowoffset = TBSlib.lerp(front_y_delta and FixedDiv(FRACUNIT, back_y_delta), line.backside.rowoffset, origin.back_offset_y)
		else
			line.frontside.rowoffset = $ + origin.current_yshift
			line.backside.rowoffset = $ + origin.current_yshift
		end

		origin.current_yshift = abs(origin.current_yshift) > FRACUNIT and TBSlib.lerp(linear_v, origin.current_yshift, 0) or 0
	end
end

-- arg1: radius, arg2: offset_floor, arg3: offset_ceiling, arg4: time, arg5: delay, arg6: earthquake
TBS_LUATAGGING.scripts["ONCEPLATFORMMOVEWHENPLAYERCLOSE"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	if not arg7 and arg6 then
		P_StartQuake(8, arg4)
		arg7 = 1
	end
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {time = 0, finished = false, activated = false, floorheight = sector.floorheight, ceilingheight = sector.ceilingheight}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]
		if origin.finished then continue end

		local radius = arg1 << FRACBITS
		local floor_offset = origin.floorheight+arg2 << FRACBITS
		local ceil_offset = origin.ceilingheight+arg3 << FRACBITS
		local specific_time = min(max(origin.time-i*arg5, 0), arg4)*(FRACUNIT/arg4)

		local x_1 = a.x-radius
		local x_2 = a.x+radius
		local y_1 = a.y-radius
		local y_2 = a.y+radius

		if origin.activated == false then
			searchBlockmap("objects", function(ref, found)
				if found.type == MT_PLAYER then
					origin.activated = true
				end
			end, a, x_1, x_2, y_1, y_2)
		end

		if origin.activated and specific_time <= FRACUNIT then
			origin.time = $+1
			sector.floorheight = ease.insine(specific_time, origin.floorheight, floor_offset)
			sector.ceilingheight = ease.insine(specific_time, origin.ceilingheight, ceil_offset)
			if sector.f_slope then
				sector.f_slope.zdelta = ease.insine(specific_time, origin.floorheight, floor_offset)
			end
			if sector.c_slope then
				sector.c_slope.zdelta = ease.insine(specific_time, origin.ceilingheight, ceil_offset)
			end
		end

		if origin.time == arg4 then
			origin.finished = true
		end
	end
end

-- arg1: size, arg2: wave_shortening, arg3: wave_speed
TBS_LUATAGGING.scripts["LAVAWAVES"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	if not a.ordered then
		table.sort(sect_list, function(a, b) return a.triggertag > b.triggertag end)
		a.ordered = true
	end
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {floorheight = sector.floorheight, ceilingheight = sector.ceilingheight,
			wave_size = arg1, wave_shortening = arg2*ANG1*i, wave_speed = max(arg3, 1)*ANG1}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]

		if origin then
			local wave = origin.wave_size*sin((origin.wave_shortening)+(leveltime*origin.wave_speed))
			--if sector.f_slope then
			--	sector.f_slope.zdelta = origin.floorheight + wave
			--else
				sector.floorheight = origin.floorheight + wave
			--end

			--if sector.c_slope then
			--	sector.c_slope.zdelta = origin.ceilingheight + wave
			--else
				sector.ceilingheight = origin.ceilingheight + wave
			--end
		end
	end
end

-- arg1: time, arg2: tic_delay, arg3: sine_range, arg4: brightness_range
TBS_LUATAGGING.scripts["LAVALIGHT"] = function(sect_list, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, a)
	for i = 1, #sect_list do
		local sector = sect_list[i]
		if not TBS_LUATAGGING.sector_custom_vars[#sector] then
			TBS_LUATAGGING.sector_custom_vars[#sector] = {floorheight = sector.floorheight, ceilingheight = sector.ceilingheight,
			lightlevel = sector.lightlevel}
		end
		local origin = TBS_LUATAGGING.sector_custom_vars[#sector]

		if origin then
			local sine = sin(((leveltime*(ANG1/(arg2 or 1)))*arg1))
			local geo_wave = arg3*sine
			local lit_wave = (arg4*sine) >> FRACBITS

			sector.floorheight = origin.floorheight + geo_wave
			sector.ceilingheight = origin.ceilingheight + geo_wave
			sector.lightlevel = min(max(origin.lightlevel + lit_wave, 0), 255)
		end
	end
end

// one-thing at time spawner,
-- text: mobj_type, arg1: limit, arg2: horizontal_momentum, arg3: vertical_momentum, arg4: fuse,
TBS_LUATAGGING.mobj_scripts["SpawnerPerOneTime"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if (arg1 == 0 or a.spawned == nil or arg1 >= a.spawned) and not (a.mobj and a.mobj.valid) then
		a.mobj = P_SpawnMobjFromMobj(a, 0, 0, 0, _G[text] or MT_NULL)
		a.mobj.momx = arg2*cos(a.angle)
		a.mobj.momy = arg2*sin(a.angle)
		a.mobj.momz = arg3 << FRACBITS
		if arg4 then
			a.mobj.fuse = arg4
		end
		if arg1 then
			 a.spawned = a.spawned and $+1 or 1
		end
	end
end

// one-thing at time spawner,
-- text: mobj_type, arg1: tag, arg2: horizontal_momentum, arg3: vertical_momentum, arg4: fuse,
TBS_LUATAGGING.mobj_scripts["SpawnerWhenCollected"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if arg1 == 0 then return end
	local exist = false
	for thing in mapthings.tagged(arg1) do
		if thing.mobj and thing.mobj.valid and thing.mobj.health > 0 then
			exist = true
			break
		end
	end


	if exist == false then
		local mobj = P_SpawnMobjFromMobj(a, 0, 0, 0, _G[text] or MT_NULL)
		mobj.momx = arg2*cos(a.angle)
		mobj.momy = arg2*sin(a.angle)
		mobj.momz = arg3 << FRACBITS
		if arg4 then
			mobj.fuse = arg4
		end
		P_RemoveMobj(a)
	end
end

// one-thing at time spawner,
-- arg1: mobj tag, arg2: sectors tag,
TBS_LUATAGGING.mobj_scripts["MoveNearestWhenRemoved"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if arg1 == 0 then return end
	local exist = false
	for thing in mapthings.tagged(arg1) do
		if thing.mobj and thing.mobj.valid and thing.mobj.health > 0 then
			exist = true
			a.fuse = TICRATE*8
			break
		end
	end

	if not exist then
		for sector in sectors.tagged(arg2) do
			sector.ceilingheight = ease.outsine(FRACUNIT >> 3, sector.ceilingheight, P_FindHighestCeilingSurrounding(sector))
			sector.floorheight = ease.outsine(FRACUNIT >> 3, sector.floorheight, P_FindLowestFloorSurrounding(sector))
		end
	end
end

// one-thing at time spawner,
-- arg1: mobj tag, arg2: sectors tag, arg3: steps, arg4: delay, arg5: fof tag
TBS_LUATAGGING.mobj_scripts["DestroyWhenRemoved"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if arg1 == 0 then return end
	local act_num_steps = abs(arg3)+1


	if a.toggle then
		local current_sect = a.extravalue1/arg4
		if a.cusval == arg4 then
			for sector in sectors.tagged((arg2-1)+TBSlib.signZ(arg3)*current_sect) do
				for rover in sector.ffloors() do
					if rover.sector.tag == arg5 then
						EV_StartCrumble(rover.sector, rover, false, nil, rover.alpha, false)
					end
				end
			end
			a.cusval = 0
		end
		a.extravalue1 = $-1
		a.cusval = $+1
		if not a.extravalue1 then
			P_RemoveMobj(a)
		end
	else
		for thing in mapthings.tagged(arg1) do
			if (thing.mobj and thing.mobj.health <= 0) or not thing.mobj then
				a.toggle = true
				a.extravalue1 = act_num_steps*arg4
				a.cusval = 1
				break
			end
		end
	end
end

-- text: mobj_type, arg1: sectors tag, arg2: offset_z, arg3: amount per tic, arg4: horizontal momentum, arg5: vertical momentum, arg6: fuse
TBS_LUATAGGING.mobj_scripts["PlaneParticles"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if arg1 == 0 then return end
	if not a.planes then
		if not a.min_x then
			a.planes = {}
			a.min_x = INT32_MAX
			a.max_x = -INT32_MAX
			a.min_y = INT32_MAX
			a.max_y = -INT32_MAX
		end
		for sector in sectors.tagged(arg1) do
			local s_lines = sector.lines

			for i = 1, #s_lines do
				local line = s_lines[i]
				if line and line.valid then
					--print('exists')
					a.min_x = min(line.v1.x, a.min_x)
					a.min_x = min(line.v2.x, a.min_x)
					a.max_x = max(line.v1.x, a.max_x)
					a.max_x = max(line.v2.x, a.max_x)

					a.min_y = min(line.v1.y, a.min_y)
					a.min_y = min(line.v2.y, a.min_y)
					a.max_y = max(line.v1.y, a.max_y)
					a.max_y = max(line.v2.y, a.max_y)
				end
			end
			a.planes[#sector] = sector
		end
	else
		for i = 1, (max(arg3, 1)) do
			local random_x = P_RandomRange(a.min_x >> FRACBITS, a.max_x >> FRACBITS)  << FRACBITS
			local random_y = P_RandomRange(a.min_y >> FRACBITS, a.max_y >> FRACBITS)  << FRACBITS
			local position = R_PointInSubsectorOrNil(random_x, random_y)
			if position then
				local position_sector = position.sector
				if a.planes[#position_sector] then
					local random_angle = P_RandomKey(360)*ANG1
					local mobj = P_SpawnMobj(random_x, random_y, a.z+(arg2 << FRACBITS), _G[text] or MT_NULL)
					mobj.angle = random_angle
					mobj.momx = arg4*sin(random_angle)
					mobj.momy = arg4*sin(random_angle)
					mobj.momz = arg5 << FRACBITS
					mobj.fuse = arg6
					--print('goomba spawned: '..mobj.x..' '..mobj.y)
				end
			end
		end
	end
end

local splashtics = 11

local function fusingwaterfallparticles(a)
	a.momz = 6*FRACUNIT+(a.scaleinit-a.scale)
	if a.initfuse then
		local procentile = (a.fuse << FRACBITS)/a.initfuse
		local transparency = ease.linear(procentile, 9, 1) << FF_TRANSSHIFT
		a.scale = ease.outsine(procentile, FRACUNIT >> 3, a.scaleinit)
		a.frame = $|transparency
		if procentile > (FRACUNIT << 1) then
			a.translation = "MarioWaterfallsSmoke2"
		end
	end
end

-- arg0: line tag, arg1: space widthness, arg2: distance activation, arg3: groundoffset,
TBS_LUATAGGING.mobj_scripts["LineWaterFallParticles"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if a.players_nearby == nil then
		a.tracking = {}
		a.players_nearby = false
		a.extravalue1 = arg3 * FRACUNIT
		a.extravalue2 = arg2 * FRACUNIT
		a.cusval = arg1 * FRACUNIT
		a.tracked = 0
	end

	if not (leveltime % TICRATE) then
		a.tracked = 0
		a.players_nearby = P_LookForPlayers(a, a.extravalue2, true, false)
		searchBlockmap("objects", function(ref, found)
			table.insert(a.tracking, found)
			a.tracked = $+1
		end, a, a.x+a.extravalue2, a.x-a.extravalue2, a.y+a.extravalue2, a.y-a.extravalue2)
	end

	local bool_smoke = (not (leveltime % 10))
	local bool_splash = (not (leveltime % splashtics))

	if a.players_nearby then
		for line in lines.tagged(arg0) do
			local vertex_1 = line.v1
			local vertex_2 = line.v2
			local sector = line.frontsector
			local floorheight = sector.floorheight
			local noslopebool = (sector.f_slope ~= nil)
			local lenght = R_PointToDist2(vertex_1.x, vertex_1.y, vertex_2.x, vertex_2.y)
			local goal = lenght / a.cusval
			local interval = FRACUNIT/goal
			local i = 0

			/*
			local colliding = {}

			for i = 1, a.tracked do
				local found = a.tracking[i]
				if not (found and found.valid) then continue end
				local closet_x, closet_y = P_ClosestPointOnLine(found.x, found.y, line)
				local on_line_dist = FixedInt(FixedDiv(R_PointToDist2(vertex_1.x, vertex_1.y, closet_x, closet_y), divlenght))
				if on_line_dist < 1 or on_line_dist > FixedInt(divlenght) then
					continue
				elseif R_PointToDist2(found.x, found.y, closet_x, closet_y) < a.cusval then
					if (colliding[on_line_dist] and colliding[on_line_dist] < found.z) or not colliding[on_line_dist] then
						colliding[on_line_dist] = found.z
					end
				end
			end
			*/

			while (goal + 1 > i) do
				local current = interval*i
				local mid_current = interval*i-(interval >> 1)
				local x = ease.linear(current, vertex_1.x, vertex_2.x)
				local y = ease.linear(current, vertex_1.y, vertex_2.y)

				if noslopebool then
					floorheight = P_GetZAt(sector.f_slope, x, y)
				end

				local z = floorheight + a.extravalue1
				--if i == 1 then print(z/FRACUNIT) end

				--if colliding[i] then
				--	z = $+max(z-colliding[i], 0)
				--end
				if bool_splash then
					local splash = P_SpawnMobj(x, y, z, MT_BLOCKVIS)
					splash.target = a
					splash.state = S_WATERFALLSPLASHMARIO
					splash.angle = a.angle
					splash.scale = a.scale
					splash.dispoffset = 8
					splash.fuse = 12
					splash.translation = "MarioWaterfalls"
					splash.tics = (i*3) % splashtics
				end

				if bool_smoke then
					local x2 = ease.linear(mid_current, vertex_1.x, vertex_2.x)
					local y2 = ease.linear(mid_current, vertex_1.y, vertex_2.y)

					for m = 1, 2 do
						local lx
						local ly
						if m == 1 then
							lx = x
							ly = y
						else
							lx = x2
							ly = y2
						end

						local light_steam = P_SpawnMobj(lx, ly, z, MT_BLOCKVIS)
						light_steam.state = S_WATERFALLSPLASHMARIO
						light_steam.angle = a.angle
						light_steam.scale = a.scale
						light_steam.target = a
						light_steam.dispoffset = -16
						light_steam.fuse = TICRATE << 1 + P_RandomRange(-16, 16)
						light_steam.translation = "MarioWaterfallsSmoke1"
						light_steam.tics = (i*3) % splashtics
						light_steam.sprmodel = 99

						light_steam.customfunc = fusingwaterfallparticles
						light_steam.scaleinit = a.scale-FRACUNIT>>2
						light_steam.initfuse = light_steam.fuse
					end
				end

				i = $+1
			end

			--print(i)
		end
	end
end