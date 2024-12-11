
local PowerMoonNum = 0

--Amount of things to add shit
addHook("PlayerSpawn", function(player)
	PowerMoonNum = 0
	for thing in mobjs.iterate() do
		if thing.type == MT_MARPOWERMOON then
			PowerMoonNum = $+1
		end
	end
end)

local function P_SpawnSpecialBGStar(a, tic, col, momz, fuse, momx, momy, scale, color)
	if (leveltime % 8)/tic then
		local randomness_jitter = P_RandomRange(-4, 4) << FRACBITS
		local x = P_RandomRange(-24,24) << FRACBITS + randomness_jitter
		local y = P_RandomRange(-24,24) << FRACBITS + randomness_jitter
		local z = P_RandomRange(0,48) << FRACBITS + randomness_jitter
		local poweruppar

		if P_RandomKey(16) == 2 then
			poweruppar = P_SpawnMobjFromMobj(a, x, y, z, MT_POPPARTICLEMAR)
			poweruppar.state = S_SM64BGSTAR
			poweruppar.dispoffset = -3
			poweruppar.angle = a.angle
			poweruppar.scale = scale or a.scale
			poweruppar.color = color or a.color
			poweruppar.colorized = col
			poweruppar.momz = momz
			poweruppar.momx = (momx or 1)/2
			poweruppar.momy = (momy or 1)/2
			poweruppar.fuse = fuse
		end

		poweruppar = P_SpawnMobjFromMobj(a, x, y, z, MT_POPPARTICLEMAR)
		poweruppar.state = S_SM64SPARKLESSINGLE
		poweruppar.angle = a.angle
		poweruppar.scale = scale or a.scale
		poweruppar.color = color or a.color
		poweruppar.colorized = col
		poweruppar.momz = momz
		poweruppar.momx = (momx or 1)/2
		poweruppar.momy = (momy or 1)/2
		poweruppar.fuse = fuse
	end
end

-- PUP2A0
-- PUP3A0

local splitunit = FRACUNIT/32
local beamscale = 4*FRACUNIT/3

addHook("MobjSpawn", function(mo)
	if mo.spawnpoint then
		if mo.args[0] then
			mo.frame = B|FF_PAPERSPRITE
		end
	end
end, MT_MARPOWERMOON)

addHook("MobjThinker", function(mo)
	mo.angle = $ + ANG1*3

	if not mo.rainbowcorona then
		mo.rainbowcorona = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)
		mo.rainbowcorona.state = S_INVISIBLE
		mo.rainbowcorona.sprite = SPR_MMPARTICLES
		mo.rainbowcorona.frame = 17|FF_TRANS70|FF_ADD

		mo.rainbowcorona.target = mo
		mo.rainbowcorona.spriteyoffset = 18*FRACUNIT
		mo.rainbowcorona.spritexscale = 5*FRACUNIT/3
		mo.rainbowcorona.spriteyscale = mo.rainbowcorona.spritexscale
	end

	if not (leveltime % 6) then
		local ray = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_POPPARTICLEMAR)
		ray.state = S_INVISIBLE
		ray.rayeffect = true
		ray.target = mo
		ray.angle = FixedAngle(P_RandomRange(1, 360) << FRACBITS)
		ray.rollangle = FixedAngle(P_RandomRange(1, 360) << FRACBITS)
		ray.scale = beamscale+P_RandomRange(-32, 16)*splitunit
		ray.fuse = P_RandomRange(1*TICRATE, 2*TICRATE)
	end

	--if not mo.corona then
	--	mo.corona = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)
	--	mo.corona.state = S_INVISIBLE
	--	mo.corona.sprite = SPR_PUP2
	--	mo.corona.frame = A|FF_TRANS60|FF_ADD
	--end

	P_SpawnSpecialBGStar(mo, 6, false, 0, TICRATE, 0, 0, FRACUNIT, SKINCOLOR_GOLD)
	if mo.extravalue2 then
		if mo.momz < -8*FRACUNIT or P_IsObjectOnGround(mo) then
			P_RemoveMobj(mo)
		end
	end
end, MT_MARPOWERMOON)

addHook("MobjDeath", function(mo)
	mo.extravalue2 = 1
	mo.z = $+P_MobjFlip(mo)
	mo.momz = 8*FRACUNIT
	mo.flags = $ &~ MF_NOGRAVITY
	return true
end, MT_MARPOWERMOON)

addHook("MobjRemoved", function(mo)
	PowerMoonNum = $-1
	for i = 1, 16 do
		P_SpawnSpecialBGStar(mo, 6, false, 0, TICRATE, 0, 0, FRACUNIT, SKINCOLOR_GOLD)
	end

	S_StartSound(nil, sfx_maodd3)
	if PowerMoonNum <= 0 then
		G_ExitLevel()
	end
end, MT_MARPOWERMOON)