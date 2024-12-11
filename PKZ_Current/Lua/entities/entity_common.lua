
function dummy(a)
	local score = P_SpawnMobjFromMobj(a, 0, 0, 24*FRACUNIT, MT_POPPARTICLEMAR)

	score.fuse = TICRATE + 8
	score.fading = 8

	score.scale = 0
	score.growing = (a.scale/3) << 1
	score.rising = FRACUNIT*2

	score.source = a

	score.flags = mobjinfo[MT_SCORE].flags
	score.state = S_INVISIBLE
	score.sprite = SPR_SCOR
	score.frame = K
end

return {dummy = dummy}