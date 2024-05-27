
// Star thinker
// Star bunnyhops or not...
// Written by Ace
local StarSettings = {
	-- functions
	[1]	= function(a) PwThinkers.static(a) end;
	[2] = function(a) a.scale = a.spawnpoint.scale*3>>1 end;
}

addHook("MobjThinker", function(a)
	//Behavioral setting
	if a.behsetting == nil then
		if a.spawnpoint ~= nil then
			a.behsetting = a.spawnpoint.extrainfo or a.spawnpoint.args[0]
		else
			a.behsetting = a.extrainfo or 0
		end
		a.dispoffset = $+1
	end

	//Normal behavior
	if a.isInBlock == true then
		a.momx = 0
		a.momy = 0
		a.momz = $ + FRACUNIT/24
		a.flags = $|MF_NOGRAVITY
	else
		local newspeed = 5*a.scale
		local speed = FixedHypot(a.momx, a.momy)
		if speed
			a.angle = R_PointToAngle2(0,0, a.momx, a.momy)
		end
		P_InstaThrust(a, a.angle, newspeed)
		a.flags = $ &~ MF_NOGRAVITY
	end

	if (8 & leveltime) >> 2
		local poweruppar = P_SpawnMobjFromMobj(a, P_RandomRange(-16,16) << FRACBITS, P_RandomRange(-16,16) << FRACBITS, P_RandomRange(0,32) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = a.scale
		poweruppar.color = SKINCOLOR_AETHER
		poweruppar.fuse = TICRATE
	end

	A_GhostMe(a)
	if P_IsObjectOnGround(a)
		a.z = $ + P_MobjFlip(a)
		P_SetObjectMomZ(a, 12 << FRACBITS, false)
	end

	if not (a.behsetting or a.behsetting == 1 or a.behsetting == 2) then return end
	StarSettings[a.behsetting](a)

end, MT_STARMAN)