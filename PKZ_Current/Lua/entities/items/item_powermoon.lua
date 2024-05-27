
local PowerMoonNum = 0

//Amount of things to add shit
addHook("PlayerSpawn", function(player)
	PowerMoonNum = 0
	for thing in mobjs.iterate() do
		if thing.type == MT_MARPOWERMOON then
			PowerMoonNum = $+1
		end
	end
end)

addHook("MobjThinker", function(mo)
	mo.angle = $ + ANG1*3
	if (8 & leveltime)/6 then
		local poweruppar = P_SpawnMobjFromMobj(mo,
		P_RandomRange(-32,32) << FRACBITS,
		P_RandomRange(-32,32) << FRACBITS,
		P_RandomRange(0,64) << FRACBITS,
		MT_POPPARTICLEMAR)

		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = mo.scale
		poweruppar.color = SKINCOLOR_GOLD
		poweruppar.fuse = TICRATE
	end
end, MT_MARPOWERMOON)

addHook("MobjRemoved", function(mo)
	PowerMoonNum = $-1
	if PowerMoonNum <= 0 then
		G_ExitLevel()
	end
end, MT_MARPOWERMOON)