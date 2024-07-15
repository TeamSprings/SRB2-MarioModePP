/*
		Pipe Kingdom Zone's Titlemap - gui_title.lua

Description:
Titlemap stuff

Contributors: Skydusk, Clone Fighter
@Team Blue Spring 2024
*/

local DEFAULT_SCALE = FRACUNIT*3/4
local REVERSE_SCALE = FRACUNIT*4/3
local timer

// Title Map Pre-Beta
addHook("HUD", function(v)

	TBSlib.statictextdrawer(
	v,
	'MA16LT',
	320 << FRACBITS,
	0,
	DEFAULT_SCALE,
	PKZ_Table.version+" DEV "+PKZ_Table.betarelease,
	V_SNAPTORIGHT|V_SNAPTOTOP,
	v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPURECYANFONT),
	"right",
	0,
	0)

	TBSlib.statictextdrawer(
	v,
	'MA16LT',
	320 << FRACBITS,
	194*REVERSE_SCALE,
	DEFAULT_SCALE,
	"@TEAM BLUE SPRING 2024",
	V_SNAPTORIGHT|V_SNAPTOBOTTOM,
	v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPURECYANFONT),
	"right",
	0,
	0)

	local scale, fsc = v.dupx()
	timer = min(max((leveltime>>1)-TICRATE<<1, 0), 29)

	if not timer then return end
	local new_scale = FRACUNIT/scale
	v.drawScaled(160 << FRACBITS, -8 << FRACBITS - FRACUNIT/3, new_scale, v.cachePatch("PKZTITLEHATS"..max(scale, 2)..min(timer, 19)))

	if timer > 20 and timer < 29 then
		v.fadeScreen(0, min((timer-20)<<1, 10))
	end

	if timer >= 29 then
		v.drawScaled(175 << FRACBITS, 140 << FRACBITS, FRACUNIT/3, v.cachePatch("TITLMARIOMOD"))
	end
end, "title")

local Cameras = {}

TBS_LUATAGGING.mobj_scripts["CameraTitleAdd"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	Cameras[arg1 or 0] = {x = a.x, y = a.y, z = a.z, angle = a.angle}
	P_RemoveMobj(a)
end

TBS_LUATAGGING.mobj_scripts["CameraTitleController"] = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, text, a)
	if not mapheaderinfo[gamemap].mariocamera or #Cameras <= 1 then return end
    //actor.angle = $- 24*ANG1/35

	camera.aiming = 0
	if not timer or timer < 27 then
		P_SetupLevelSky(1, nil)
		local pos = Cameras[2]
		P_TeleportCameraMove(camera, pos.x, pos.y, pos.z)
		camera.angle = $+(ANG1 >> 1)
	elseif timer then
		if PKZ_Table.dragonCoins < arg1 then
			local pos = Cameras[1]
			local ang = leveltime*(2*ANG1/3)
			camera.angle = R_PointToAngle(pos.x, pos.y)
			P_TeleportCameraMove(camera, pos.x+780*cos(ang), pos.y+780*sin(ang), pos.z)
			P_SetupLevelSky(93, nil)
		else
			local pos = Cameras[0]
			P_TeleportCameraMove(camera, pos.x, pos.y, pos.z)
			camera.angle = pos.angle
			P_SetupLevelSky(88, nil)
		end
	end
end
