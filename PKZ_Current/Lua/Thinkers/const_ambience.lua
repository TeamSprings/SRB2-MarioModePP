/*
		Pipe Kingdom Zone's Ambience - const_ambience.lua

Description:
All ambient objects thinkers

Contributors: Skydusk
@Team Blue Spring 2024
*/

addHook("MapThingSpawn", function(a, mt)
	local selection = {
		sfx_nmara1, -- 1
		sfx_nmara2, -- 2
		sfx_nmara3, -- 3
		sfx_nmara4, -- 4
		sfx_nmara5, -- 5
		sfx_nmara6, -- 6
		sfx_nmara7, -- 7
		sfx_mawii2, -- 8
		sfx_mawii9, -- 9
		sfx_zelda3, -- 10
		sfx_mar64h, -- Bowser Echo 11
	}

	a.sound = selection[mt.args[0] or 1] -- Sound SFX ID
	a.extravalue2 = mt.args[1]	-- Freqvency
	a.newradius = mt.args[2]*FRACUNIT -- Radius
	a.cusval = mt.args[3]*FRACUNIT -- Ease Radius
	a.easeradius = ((mt.args[2]*FRACUNIT)-a.cusval)*FRACUNIT -- Ease Radius

end, MT_AMBIENTMARIOSFX)

addHook("MobjThinker", function(a)
	if not (consoleplayer and consoleplayer.valid) then return end

	local dist = R_PointToDist2(a.x, a.y, consoleplayer.mo.x, consoleplayer.mo.y)

	if dist > a.newradius then return end

	if not (leveltime % a.extravalue2) then
		local easedist = FixedDiv(max(dist-a.cusval, 0) or 1, a.newradius-a.easeradius) or 0
		S_StartSoundAtVolume(consoleplayer, a.sound, ease.linear(easedist, 255, 0), p)
	end
end, MT_AMBIENTMARIOSFX)

local FRAME_TIME_WISP = TICRATE/8
local FRAME_BITS_WISP = 15
local WISP_DOWN = -FRACUNIT >> 1
local WISP_SCALE = (FRACUNIT/9)*5

local LUT_RANDOM = {
	175,10,170,46,336,292,357,72,
	29,17,78,25,19,53,174,300,
	123,35,14,239,160,140,164,
	301,218,23,358,56,67,3,213,
	303,81,90,309,353,225,53,351,
	251,98,171,152,337,74,115,
	138,236,312,124,13,41,314,133,254,181,
	131,190,89,282,114,255,174,15,
}

local function P_GetRandomFromLut(int)
	local val = abs((int+leveltime) % 64)+1
	return LUT_RANDOM[val]
end

local function P_GetRandomFromNon(int_1, int_2)
	local val = abs((int_1+int_2) % 64)+1
	return LUT_RANDOM[val]
end

addHook("MapThingSpawn", function(a, mt)
	if mt then
		a.extravalue1 = mt.args[0]
		if a.extravalue1 == 1 then
			-- Bird
			a.state = S_YOSHIBIRDAMB
			if not a.tbswaypoint then
				TBSWaylib.activate(a, mt.args[1], mt.args[2], true)
			end
		else
			-- Wisp
			a.state = S_MARWISPAMB
			a.extravalue2 = P_RandomRange(0,16) << 2
			a.cusval = (a.scale*3 >> 1) - (P_RandomRange(0,8) << FRACBITS) >> 3
			a.n_tics = 0
			--local base = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_BLOCKVIS)
			--base.state = S_MARWISPAMB
			--base.target = a
			--base.scale = a.cusval+WISP_DOWN
			--base.sprmodel = 6
		end
	end
end, MT_PKZAMBIENCEOBJECT)

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, 1280 << FRACBITS, true, false) == false then return end
	if a.extravalue1 == 1 then
		-- Bird
		TBSWaylib.SelfPathwayController(a, false, false)
	else
		-- Wisp
		local timing = abs(5-(((leveltime+a.extravalue2)/4) % 10))
		local transparency = timing << FF_TRANSSHIFT
		a.scale = a.cusval+ease.inoutsine((timing << FRACBITS)/10, WISP_SCALE, 0)
		a.frame = A|FF_ADD|FF_FULLBRIGHT|transparency
		if not (leveltime % FRAME_TIME_WISP) then
			a.momx = 0
			a.momy = 0
			a.momz = 0
			if P_LookForPlayers(a, 64 << FRACBITS, true, false) then
				local angle_3 = (P_GetRandomFromNon(a.extravalue2, a.n_tics)<<1-360)*ANG1
				local angle_12 = R_PointToAngle2(a.target.x, a.target.y, a.x, a.y)
				a.momx = cos(angle_12) >> FRAME_BITS_WISP
				a.momy = sin(angle_12) >> FRAME_BITS_WISP
				a.momz = TBSlib.sign(angle_3)*(WISP_DOWN-sin(angle_3)) >> FRAME_BITS_WISP
			else
				local angle_12, angle_3 = (P_GetRandomFromNon(a.extravalue2, a.n_tics)<<1-360)*ANG1, (P_GetRandomFromNon(a.extravalue2+32, a.n_tics)<<1-360)*ANG1
				a.momx = TBSlib.sign(angle_12)*cos(angle_12) >> FRAME_BITS_WISP
				a.momy = TBSlib.sign(angle_12)*sin(angle_12) >> FRAME_BITS_WISP
				a.momz = TBSlib.sign(angle_3)*(WISP_DOWN-sin(angle_3)) >> FRAME_BITS_WISP
			end
			a.n_tics = ((a.n_tics+1) % 64)+1
		end
	end
end, MT_PKZAMBIENCEOBJECT)