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
hud.add(function(v)
	--local width = (v.levelTitleWidth("PIPE KINGDOM ZONE"))/2
	--v.drawLevelTitle(160-width, 0, "PIPE KINGDOM ZONE")
	
	TBSlib.fontdrawer(v, 'MA16LT', 320 << FRACBITS, 0, DEFAULT_SCALE, PKZ_Table.version+" PRE-BETA "+PKZ_Table.betarelease, V_SNAPTORIGHT|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPURECYANFONT), "right", 0, 0)
	TBSlib.fontdrawer(v, 'MA16LT', 320 << FRACBITS, 194*REVERSE_SCALE, DEFAULT_SCALE, "@TEAM BLUE SPRING 2023", V_SNAPTORIGHT|V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPURECYANFONT), "right", 0, 0)
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

addHook("MapThingSpawn", function(a, tm)
	if not mapheaderinfo[gamemap].mariocamera then return end
	Cameras[tm.extrainfo or 0] = {x = a.x, y = a.y, z = a.z, angle = a.angle}
end, MT_ALTVIEWMAN)

//Title screen camera
addHook("MobjThinker", function(a)
	if not mapheaderinfo[gamemap].mariocamera or #Cameras <= 0 then return end
    //actor.angle = $- 24*ANG1/35
	
	
	if not timer or timer < 27 then
		P_SetupLevelSky(1, nil)
		local pos = Cameras[2]
		P_SetOrigin(a, pos.x, pos.y, pos.z)
		a.angle = $+ANG1
	elseif timer then
		if PKZ_Table.dragonCoins < 30 then
			local pos = Cameras[0]
			local ang = leveltime*ANG1
			a.angle = R_PointToAngle2(a.x, a.y, pos.x, pos.y)
			P_MoveOrigin(a, pos.x+780*cos(ang), pos.y+780*sin(ang), pos.z)
			P_SetupLevelSky(93, nil)
		else
			local pos = Cameras[1]	
			P_SetOrigin(a, pos.x, pos.y, pos.z)
			a.angle = pos.angle
			P_SetupLevelSky(88, nil)
		end
	end
end, MT_ALTVIEWMAN)
