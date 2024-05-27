
function A_Spawn1upScore(a)
	local spawnscore = P_SpawnMobjFromMobj(a, 0, 0, 24*FRACUNIT, MT_SCORE)
	spawnscore.fuse = TICRATE >> 1
	spawnscore.scale = (a.scale/3) << 1
	spawnscore.momz = FRACUNIT*3
	spawnscore.source = a
	spawnscore.frame = K
end

return {A_Spawn1upScore = A_Spawn1upScore}