
-- Star thinker
-- Star bunnyhops or not...
-- Written by Ace
local StarSettings = {
	-- functions
	[1]	= function(a) PwThinkers.static(a) end;
	[2] = function(a) a.scale = a.spawnpoint.scale*3>>1 end;
}

local T_InvColors = {
	--SKINCOLOR_CYAN;
	--SKINCOLOR_COBALT;
	--SKINCOLOR_PURPLE;
	--SKINCOLOR_RED;
	--SKINCOLOR_ORANGE;
	--SKINCOLOR_GREEN;
	--SKINCOLOR_MINT;
	--SKINCOLOR_AETHER;
	SKINCOLOR_MARIOINVULN1,
	SKINCOLOR_MARIOINVULN2,
	SKINCOLOR_MARIOINVULN3,
	SKINCOLOR_MARIOINVULN4,
	SKINCOLOR_MARIOINVULN5,
	SKINCOLOR_MARIOINVULN6,
	SKINCOLOR_MARIOINVULN7,
	SKINCOLOR_MARIOINVULN8,
}

local translationanim = {
	nil,
	nil,
	"STARMANTRANSLATION1",
	"STARMANTRANSLATION2",
	"STARMANTRANSLATION3",
	"STARMANTRANSLATION4",
	"STARMANTRANSLATION5",
	"STARMANTRANSLATION5",
	"STARMANTRANSLATION4",
	"STARMANTRANSLATION3",
	"STARMANTRANSLATION2",
	"STARMANTRANSLATION1",
}


addHook("MobjThinker", function(a)
	--Behavioral setting
	if a.behsetting == nil then
		if a.spawnpoint ~= nil then
			a.behsetting = a.spawnpoint.extrainfo or a.spawnpoint.args[0]
		else
			a.behsetting = a.extrainfo or 0
		end
		a.dispoffset = $+1
	end

	--Normal behavior
	if a.isInBlock == true then
		a.momx = 0
		a.momy = 0
		a.momz = $ + FRACUNIT/24
		a.flags = $|MF_NOGRAVITY
	else
		local newspeed = 5*a.scale
		local speed = FixedHypot(a.momx, a.momy)
		if speed then
			a.angle = R_PointToAngle2(0,0, a.momx, a.momy)
		end
		P_InstaThrust(a, a.angle, newspeed)
		a.flags = $ &~ MF_NOGRAVITY
	end


	if not (leveltime % 3) then
		A_GhostMe(a)
		-- follow invfog
		local color = T_InvColors[((leveltime-1 >> 3) % #T_InvColors)+1]
		local fog = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_BLOCKVIS)
		fog.state = S_WIILIKEINVFOG
		fog.color = color
		fog.frame = $| ((leveltime % 2) == 1 and FF_HORIZONTALFLIP or 0)
		fog.fuse = 3

		local poweruppar = P_SpawnMobjFromMobj(a, 0, 0, a.height/2, MT_POPPARTICLEMAR)
		poweruppar.state = S_SM64SPARKLES
		poweruppar.scale = a.scale
		poweruppar.color = color
		poweruppar.fuse = TICRATE
	end

	local translation = translationanim[(leveltime % #translationanim)+1]
	if translation then
		a.translation = translation
	else
		a.translation = nil
	end

	if P_IsObjectOnGround(a) then
		a.z = $ + P_MobjFlip(a)
		P_SetObjectMomZ(a, 12 << FRACBITS, false)
	end

	if not (a.behsetting or a.behsetting == 1 or a.behsetting == 2) then return end
	StarSettings[a.behsetting](a)

end, MT_STARMAN)