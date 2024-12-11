addHook("MobjSpawn", function(a)
	for i = 1,2 do
		local sideSpawn = P_SpawnMobjFromMobj(a, 0,0,0, MT_BLOCKVIS)
		sideSpawn.target = a
		sideSpawn.scale = a.scale
		sideSpawn.sprmodel = 2
		sideSpawn.id = i
		sideSpawn.state = S_BLOCKVIS
		sideSpawn.sprite = SPR_K0MO
		sideSpawn.frame = B|FF_PAPERSPRITE
	end
	return true
end, MT_MARBWKEY)


addHook("MobjDeath", function(a)
	A_ForceWin(a)
	local save_data = xMM_registry.getSaveData()
	save_data.unlocked = $|xMM_registry.unlocks_flags["KEY"]
end, MT_MARBWKEY)

addHook("MobjThinker", function(actor)
	actor.angle = $ + ANG1*3
	if not (6 & leveltime) then
		local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(0,64) << FRACBITS, MT_POPPARTICLEMAR)
		poweruppar.state = S_INVINCSTAR
		poweruppar.scale = actor.scale
		poweruppar.color = SKINCOLOR_GOLD
		poweruppar.fuse = TICRATE
	end
end, MT_MARBWKEY)