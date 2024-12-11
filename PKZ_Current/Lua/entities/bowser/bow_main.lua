--[[
		Pipe Kingdom Zone's Bowser - bow_main.lua

Contributors: Zipper, Skydusk(edits)
@Team Blue Spring 2024
--]]

local lastmap = 0
local bow_scale = FRACUNIT+11*FRACUNIT/16
local atksounds = {sfx_bwatk1,sfx_bwatk2,sfx_bwatk3,sfx_bwatk4}

addHook("MapLoad", function()
	lastmap = gamemap
end)

local CONST_FLOOR_FALL_STRG = 6 << FRACBITS
local CONST_FLOOR_FALL_TICS = 12 * TICRATE


local function bowserSpawn(mo)
	mo.scale = bow_scale
	mo.dashcount = 0
	mo.flametic = 0
	mo.graceperiod = 0
	mo.enraged = false
	mo.firstattack = true
	mo.breakfloor = nil
	mo.floor_i = 0
	mo.floor_tics = 0

	--set to false at spawn when we implement cutscenes. and by "we" I mean "I"
	--Ace: Zipper, your prediction was way past off. It is me implementing it.
	mo.active = lastmap == gamemap and true or false
end

local function bowserMapThing(mo, mt)
	mo.from_val = mt.args[5]
	mo.to_val = mo.from_val > mt.args[6] and mo.from_val or mt.args[6]
end

local function cutsceneBowser(mo)
	if mo.state ~= S_BOWSER_STAND then
		mo.state = S_BOWSER_STAND
	end

	if leveltime == 1 then
		mo.originpoint = {x = mo.x, y = mo.y, z = mo.z}
		mo.flags = $|MF_NOGRAVITY
		P_SetOrigin(mo,
			mo.originpoint.x-256*cos(mo.angle),
			mo.originpoint.y-256*sin(mo.angle),
			mo.originpoint.z+600*FRACUNIT)
		local ang = mo.angle-ANGLE_90
		mo.cutscene = P_SpawnMobjFromMobj(mo, -25*cos(ang)-4*cos(mo.angle), -25*sin(ang)-4*cos(mo.angle), -210*FRACUNIT, MT_CUTSCENEJUNKMARIO)
		mo.cutscene.state = S_BOWSERAIRSHIP
		mo.cutscene.angle = ang
	end

	if leveltime == TICRATE and consoleplayer and
	consoleplayer.mo and consoleplayer.mo.valid then
		consoleplayer.awayviewmobj = P_SpawnMobj(camera.x, camera.y, camera.z, MT_RAY)
		consoleplayer.awayviewmobj.state = S_INVISIBLE
		consoleplayer.awayviewmobj.fuse = TICRATE*7
		consoleplayer.awayviewmobj.angle = camera.angle
		consoleplayer.awayviewtics = TICRATE*7
	end

	if mo.cutscene and leveltime <= 5*TICRATE then
		local ang = mo.angle-ANGLE_90
		P_SetOrigin(mo,
		mo.cutscene.x+25*cos(ang)+4*cos(mo.angle),
		mo.cutscene.y+25*cos(ang)+4*cos(mo.angle),
		mo.cutscene.z+420*FRACUNIT)
	end


	if leveltime > TICRATE and leveltime <= TICRATE*6+10
	and consoleplayer and consoleplayer.valid then
		local tempcamera = consoleplayer.awayviewmobj
		local lerp_x = TBSlib.lerp(FRACUNIT/16, tempcamera.x, mo.x + 350*cos(mo.angle))
		local lerp_y = TBSlib.lerp(FRACUNIT/16, tempcamera.y, mo.y + 350*sin(mo.angle))
		local lerp_z = TBSlib.lerp(FRACUNIT/16, tempcamera.z, mo.z + 16*FRACUNIT)
		local lerp_a = TBSlib.lerp(FRACUNIT/16, tempcamera.angle, R_PointToAngle2(tempcamera.x, tempcamera.y, mo.x, mo.y))

		P_MoveOrigin(tempcamera, lerp_x, lerp_y, lerp_z)
		consoleplayer.awayviewmobj.angle = lerp_a
	end

	if leveltime > TICRATE*6+10 and leveltime < TICRATE*8
	and consoleplayer and consoleplayer.valid then
		local tempcamera = consoleplayer.awayviewmobj
		local lerp_x = TBSlib.lerp(FRACUNIT/8, tempcamera.x, camera.x)
		local lerp_y = TBSlib.lerp(FRACUNIT/8, tempcamera.y, camera.y)
		local lerp_z = TBSlib.lerp(FRACUNIT/8, tempcamera.z, camera.z-12*FRACUNIT)
		local lerp_aim = TBSlib.lerp(FRACUNIT/8, consoleplayer.awayviewaiming, camera.aiming)
		local lerp_a = TBSlib.lerp(FRACUNIT/8, consoleplayer.awayviewmobj.angle, camera.angle)

		P_MoveOrigin(tempcamera, lerp_x, lerp_y, lerp_z)
		consoleplayer.awayviewaiming = lerp_aim
		consoleplayer.awayviewmobj.angle = lerp_a
	end

	if leveltime > TICRATE and leveltime <= TICRATE*2 and mo.state ~= S_BOWSER_GLOAT then
		mo.state = S_BOWSER_GLOAT
	end

	if leveltime == 3*TICRATE/2 then
		S_StartSound(nil, sfx_bwglt1)
	end

	if leveltime > 5*TICRATE and leveltime <= TICRATE*6 then
		if mo.state ~= S_BOWSER_JUMP1 then
			mo.state = S_BOWSER_JUMP1
		end

		local newleveltime = leveltime-TICRATE*5
		local maxleveltime = TICRATE
		local x = TBSlib.quadBezier((newleveltime*FRACUNIT)/maxleveltime,
		mo.originpoint.x-256*cos(mo.angle), mo.originpoint.x-128*cos(mo.angle), mo.originpoint.x)
		local y = TBSlib.quadBezier((newleveltime*FRACUNIT)/maxleveltime,
		mo.originpoint.y-256*sin(mo.angle), mo.originpoint.y-128*sin(mo.angle), mo.originpoint.y)
		local z = TBSlib.quadBezier((newleveltime*FRACUNIT)/maxleveltime,
		mo.originpoint.z+600*FRACUNIT, mo.originpoint.z+680*FRACUNIT, mo.originpoint.z)
		P_MoveOrigin(mo, x, y, z)
	end

	if leveltime == TICRATE*6 then
		P_StartQuake(15*FRACUNIT, TICRATE/2)
	end

	if leveltime == TICRATE*8 then
		P_SetOrigin(mo,
			mo.originpoint.x,
			mo.originpoint.y,
			mo.originpoint.z)
		mo.originpoint = {}
		mo.flags = $ &~ MF_NOGRAVITY
		mo.active = true
	else
		xMM_registry.hideHud = true
	end
end


local function targetBowser(mo)
	if not (mo.target and mo.target.valid and mo.target.player) then
		P_LookForPlayers(mo, 1024*FRACUNIT, true)
	end
	if not mo.waypoint then
		for mobj in mobjs.iterate() do --searchBlockmap doesn't work with MF_NOBLOCKMAP, what did you expect?
			if mobj.type == MT_FANGWAYPOINT then
				mo.waypoint = mobj
				break
			end
		end
	end
end

local function variablesBowser(mo)
	mo.graceperiod = max(0, $ - 1)
	if mo.flags2 & MF2_FRET then
		if leveltime & 1 then
			mo.flags2 = $ | MF2_DONTDRAW
		else
			mo.flags2 = $ & ~MF2_DONTDRAW
		end
	else
		mo.flags2 = $ & ~MF2_DONTDRAW
	end
end

local function behaviourBowser(mo)
	if (mo.state == S_BOWSER_STAND) and mo.enraged then
		mo.state = S_BOWSER_RAGE1
		mo.enraged = false
	end


	--if (mo.state >= S_BOWSER_FLINCH1 and mo.state <= S_BOWSER_FLINCH2) then
	if (mo.graceperiod) then
		if (P_AproxDistance(mo.momx,mo.momy) > 2*FRACUNIT) then
			P_SpawnTrail(mo, MT_SPINDUST, 5*TICRATE)
		end
	end

	if (mo.state >= S_BOWSER_LAUNCH and mo.state <= S_BOWSER_JUMP2) then
		local lava = mo.subsector.sector
		if lava and P_IsObjectOnGround(mo) and (lava.floorheight+FRACUNIT*3 > mo.z) and
		(GetSecSpecial(lava.special, 1) == 7 or GetSecSpecial(lava.special, 1) == 3 or lava.damagetype) then --thrown to lava or pit
			P_AimLaunch(mo, mo.waypoint, 3*TICRATE)
			S_StartSound(nil, sfx_bwglt1)
			mo.state = S_BOWSER_JUMP1
		end
	end

	--chargeup states
	if (mo.state >= S_BOWSER_PUNCH1 and mo.state <= S_BOWSER_PUNCH4) then
		if (mo.state ~= S_BOWSER_PUNCH4) then --regret
			A_FaceTarget(mo)
		end
		if not (mo.tics % 4) then
			P_ParticleSpawn(mo, MT_CYBRAKDEMON_FLAMESHOT, 30, 8, 16)
		end
	end

	--hurl state
	if (mo.state == S_BOWSER_PUNCH4) then
		local speed = R_PointToDist2(0,0,mo.momx, mo.momy)
		P_InstaThrust(mo, mo.angle, min(70*FRACUNIT, speed + 6*FRACUNIT))

		if not (leveltime % 2) then --consistency? what's that

			local diffang = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y) - mo.angle
			if diffang > 0 then
				mo.angle = $ + min(diffang, ANG2)
			else
				mo.angle = $ + max(diffang, -ANG2)
			end

			--A_FaceStabHurl be like
			local basesize = FRACUNIT/15
			local xo = P_ReturnThrustX(mo, mo.angle, basesize*113)
			local yo = P_ReturnThrustY(mo, mo.angle, basesize*113)
			local step = 3

			local spear = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_FACESTABBERSPEAR)

			spear.angle = mo.angle + ANGLE_90
			spear.scale = 7*FRACUNIT/2
			spear.destscale = FRACUNIT/4
			spear.scalespeed = FRACUNIT/4
			spear.fuse = 8
			spear.frame = B|FF_PAPERSPRITE|FF_TRANS30|FF_FULLBRIGHT|FF_ADD
			P_MoveOrigin(spear, mo.x + xo*(15-step), mo.y + yo*(15-step), mo.z + (mo.height - spear.height)/2 + (P_MobjFlip(mo)*(8<<FRACBITS)));

			P_SpawnTrail(mo, MT_SPINFIRE, 5*TICRATE)
		end
	end

	if (mo.state == S_BOWSER_PUNCH6) then
		if mo.flametic < (2 + (mo.info.spawnhealth - mo.health) / 2) then
			mo.flametic = $ + 1
			mo.state = S_BOWSER_PUNCH1
		end
	end


	if (mo.state >= S_BOWSER_BOUNCE1 and mo.state <= S_BOWSER_BOUNCE3) then
		if not (mo.tics % states[mo.state].var2) then
			P_SpawnTrail(mo, MT_SPINDUST, 5*TICRATE)
			mo.flametic = min($ + 1, 15)
			S_StartSound(mo, sfx_s3kab + mo.flametic)
		end
	end


	if (mo.state >= S_BOWSER_BOUNCE4 and mo.state <= S_BOWSER_BOUNCE6) then
		if mo.momz < 0 then
			mo.momz = $-7*FRACUNIT
		end
	end

	if (mo.state >= S_BOWSER_BOUNCE1 and mo.state <= S_BOWSER_BOUNCE6) then
		if mo.momz < 0 then
			if mo.spritexscale > FRACUNIT/2 then
				mo.spritexscale = $ + mo.momz/64
				mo.spriteyscale = $ - mo.momz/56
			end
		else
			mo.spritexscale = FRACUNIT
			mo.spriteyscale = FRACUNIT
		end
	else
		if mo.spritexscale ~= FRACUNIT then
			mo.spritexscale = FRACUNIT
			mo.spriteyscale = FRACUNIT
		end
	end


	--when you can't use your own goddamn SOC action because FF_ANIMATE uses both vars :)
	if (mo.state == S_BOWSER_BOUNCE5) then
		if P_IsObjectOnGround(mo) then
			mo.state = S_BOWSER_BOUNCE6
		end
	end

	if mo.breakfloor ~= nil and mo.breakfloor == false and mo.floor_tics > 0 then
		if mo.floor_i > mo.to_val then
			mo.breakfloor = true
		else
			for sect in sectors.tagged(mo.floor_i) do
				sect.floorheight = $-CONST_FLOOR_FALL_STRG
			end

			mo.floor_tics = $-1
		end
	end
end

local function bowserThink(mo)
	if mo.active then
		targetBowser(mo)
		variablesBowser(mo)
		behaviourBowser(mo)
	else
		cutsceneBowser(mo)
	end
end

addHook("MobjSpawn", bowserSpawn, MT_BOWSER)
addHook("MapThingSpawn", bowserMapThing, MT_BOWSER)
addHook("MobjThinker", bowserThink, MT_BOWSER)


local function bowserArenaTrap(mo, line)
	if line.flags & ML_IMPASSIBLE then return true end --mission impastable
	if line.frontsector and not line.backsector then return true end -- I'm writing this with a massive headache, consider not judging me yet
	if line.backsector and not line.frontsector then return true end
	local cursec = mo.subsector.sector
	local othersec = ((cursec == line.frontsector) and line.backsector) or line.frontsector

	if (cursec.floorheight > (othersec.floorheight + 80*FRACUNIT)) then
		if mo.state == S_BOWSER_PUNCH4 then
			--[[local langle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x,line.v2.y)
			if (abs(mo.angle - (langle + ANGLE_90)) < ANGLE_45) then
				return
			end--]]
			local x,y = P_ClosestPointOnLine(mo.x, mo.y, line)
			local langle = R_PointToAngle2(mo.x,mo.y, x,y) - mo.angle
			if (abs(langle) > ANGLE_90) then
				return
			end
			mo.state = S_BOWSER_PUNCH4EX
			mo.momx = -$ / 10
			mo.momy = -$ / 10
			mo.momz = 6*FRACUNIT
			S_PlayRandomSound(mo, atksounds)
		end
		--air states should not block us
		--....honestly I'd rather have a blacklist than a whitelist at this point
		return not (mo.state >= S_BOWSER_LAUNCH and mo.state <= S_BOWSER_JUMP2)
	end
end

addHook("MobjLineCollide", bowserArenaTrap, MT_BOWSER)

local BOWTIMERMAX = 8
local healthupdate = 0
local Easing_timer = nil
local last_FOV = ""
local last_Timescale = {}
local speed_cal = 0

local function bowserShouldHurt(mo, inf, src, dmg, dtype)
	if not src then return end
	if (inf and inf.flags & MF_FIRE) then return false end
	if (inf.type == MT_PLAYER or src.type == MT_PLAYER) then
		local ang = R_PointToAngle2(mo.x, mo.y, inf.x, inf.y)
		if mo.active and (mo.angle - ang < ANGLE_270 or mo.angle - ang > ANGLE_90)
		or (mo.state >= S_BOWSER_LAUNCH)
		or (mo.graceperiod > 0) then --above 180 or not in a gloat state
			if (inf.type == MT_PLAYER) then
				local speed = max(20*FRACUNIT, P_AproxDistance(inf.momx, inf.momy))
				inf.momx = FixedMul(speed, cos(ang)) / 2
				inf.momy = FixedMul(speed, sin(ang)) / 2
			end
			return false
		end
	end
end

addHook("ShouldDamage", bowserShouldHurt, MT_BOWSER)

--addHook("PlayerThink", function(p)
	--if Easing_timer then
		--if not multiplayer and healthupdate == 1 then
		--	if Easing_timer == BOWTIMERMAX-1 then
		--		CV_Set(CV_FindVar("timescale"), "0."+((last_Timescale[2] or 10)-Easing_timer))
		--	else
		--		CV_Set(CV_FindVar("timescale"), last_Timescale[1]+"."+last_Timescale[2])
		--	end
		--end

		--CV_Set(CV_FindVar("fov"), ""+last_FOV+(speed_cal/BOWTIMERMAX)*Easing_timer)

		--Easing_timer = $-1
	--elseif Easing_timer == 0 then
		--CV_Set(CV_FindVar("fov"), ""+last_FOV)
		--Easing_timer = nil
	--end
--end)

local function bowserKnock(mo, inf, src, dmg, dtype)
	local LSPEED = -45*FRACUNIT
	local ang = R_PointToAngle2(mo.x, mo.y, inf.x, inf.y)
	if not Easing_timer then
		healthupdate = mo.health
		--if not multiplayer and healthupdate == 1 then
		--	last_Timescale = {}
		--	local timescale_cvar = CV_FindVar("timescale")
		--	for token in string.gmatch(timescale_cvar.string, "[^%.]+") do
		--		if token == nil then break end
		--		table.insert(last_Timescale, tonumber(token))
		--	end
		--	CV_Set(timescale_cvar, "0."+((last_Timescale[2] or 10)-8))
		--end


		--speed_cal = max(20, P_AproxDistance(inf.momx, inf.momy)/FRACUNIT)
		--local fov_cvar = CV_FindVar("fov")
		--last_FOV = tonumber(fov_cvar.string)
		--CV_Set(fov_cvar, ""+min(last_FOV+speed_cal, 180))

		--Easing_timer = BOWTIMERMAX
	end

	if mo.health == 1 and inf.player then
		local p = inf.player
		local ang = inf.angle+ANGLE_45
		local tempcamera = P_SpawnMobjFromMobj(inf, -50*cos(ang), -50*sin(ang), -50*FRACUNIT, MT_RAY)
		tempcamera.state = S_INVISIBLE
		tempcamera.angle = R_PointToAngle2(tempcamera.x, tempcamera.y, inf.x, inf.y)
		p.awayviewmobj = tempcamera
		p.awayviewtics = 15
		tempcamera.fuse = 25
		p.awayviewaiming = 10*ANG1
		A_ForceStop(inf)
	end

	mo.state = S_BOWSER_LAUNCH
	mo.momx = FixedMul(LSPEED, cos(ang))
	mo.momy = FixedMul(LSPEED, sin(ang))
	mo.momz = 7*FRACUNIT
end



local function bowserHurt(mo, inf, src, dmg, dtype)
	if not src then return true end
	local LSPEED = -45*FRACUNIT
	if (inf.type == MT_PLAYER or src.type == MT_PLAYER) then
		local ang = R_PointToAngle2(mo.x, mo.y, inf.x, inf.y)
		mo.angle = ang
		if mo.state == S_BOWSER_FLINCH2 then
			A_ResetBowser(mo)
			bowserKnock(mo, inf, src, dmg, dtype)
		else
			mo.graceperiod = 20

			--can always be knocked back now, yeehaw
			if (mo.state >= S_BOWSER_GLOAT and mo.state <= S_BOWSER_FLINCH1) or mo.state == S_BOWSER_STAND
			or (mo.state >= S_BOWSER_FIRE1 and mo.state <= S_BOWSER_FIRE2EX) then --sometimes I wonder if I should have a wrapper for "state groups"
				A_ResetBowser(mo)

				if mo.state == S_BOWSER_GLOAT or mo.state == S_BOWSER_STAND
				or (mo.state >= S_BOWSER_FIRE1 and mo.state <= S_BOWSER_FIRE2EX) then
					local infspeed = FixedHypot(inf.momx, inf.momy)/FRACUNIT

					if inf.player and ((inf.player.panim == PA_ABILITY2 and inf.player.charability2 == CA2_MELEE) or
					inf.player.pflags & PF_GLIDING) then
						bowserKnock(mo, inf, src, dmg, dtype)
					else
						if (infspeed > 30) or (inf.player and inf.player.pflags & PF_SPINNING) then
							mo.state = S_BOWSER_FLINCH2
						else
							mo.state = S_BOWSER_FLINCH1
						end
					end
				elseif mo.state == S_BOWSER_FLINCH1 then
					mo.state = S_BOWSER_FLINCH2
				end
				mo.momx = FixedMul(LSPEED/2, cos(ang))
				mo.momy = FixedMul(LSPEED/2, sin(ang))
			else
				--"just change a multiplier and set the momentum at the end" I hear you say
				--okay, mr. unreadable code
				mo.momx = FixedMul(LSPEED/6, cos(ang))
				mo.momy = FixedMul(LSPEED/6, sin(ang))
			end
		end
		return true
	elseif (inf.type == MT_BOMBMACE) then
		mo.state = S_BOWSER_FALL1

		mo.health = $ - 1

		if (mo.health == 3) then
			mo.enraged = true
			mo.firstattack = false
		end

		P_AimLaunch(mo, mo.waypoint, 3*TICRATE)
		S_StartSound(nil, sfx_bwhurt)

		if (mo.health > 0) then
			mo.flags2 = $ | MF2_FRET
		end
		return true
	else
		return true --this probably fucks over SMS somehow
	end
end

addHook("MobjDamage", bowserHurt, MT_BOWSER)

--
--	Bowser's Death
--

addHook("MobjThinker", function(a)
	if a.state == S_BOWSER_DEFEAT3 then
		a.angle = a.ticScene*ANG1
		if a.ticScene < 3*TICRATE then
			a.spritexscale = max(FRACUNIT-a.ticScene*FRACUNIT/64, FRACUNIT/3)
			if a.ticScene > 3*TICRATE/2 then
				a.spriteyscale = max(FRACUNIT-(a.ticScene-3*TICRATE/2)*FRACUNIT/64, FRACUNIT/3)
				a.momz = (a.ticScene-3*TICRATE/2)*(FRACUNIT/4)
			end
		end

		if a.ticScene == 3*TICRATE then
			local key = P_SpawnMobjFromMobj(a, 0,0,0, MT_MARBWKEY)
			key.scale = FRACUNIT
			key.momz = 10*FRACUNIT
			a.momx = 30*sin(a.angle)
			a.momy = 30*cos(a.angle)
			xMM_registry.hideHud = true
		end

		if a.ticScene > 3*TICRATE then
			a.spritexscale = FRACUNIT
			a.spriteyscale = FRACUNIT
			a.scale = FRACUNIT-(a.ticScene-3*TICRATE)*FRACUNIT/64
			a.rollangle = a.ticScene*ANG1
		end

		a.ticScene = $+1

		if a.scale < FRACUNIT/128 then
			P_RemoveMobj(a)
			return
		end
	end

	if a.state == S_BOWSERAIRSHIP then
		if leveltime > 5*TICRATE then
			a.rollangle = 0+(((leveltime-5*TICRATE/2)/2 % 20)-9)*ANG1
		end

		if leveltime >= TICRATE*6 then
			a.momx = $+3*cos(a.angle)
			a.momy = $+3*sin(a.angle)
			a.momz = $+3*FRACUNIT/2
			a.scale = $ - FRACUNIT/64
			if a.scale < FRACUNIT/16 then
				P_RemoveMobj(a)
			end
		else
			a.momz = 2*sin(leveltime*ANG10)
		end
	end
end, MT_CUTSCENEJUNKMARIO)


