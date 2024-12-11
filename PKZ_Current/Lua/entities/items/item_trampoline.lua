local trampoline_database = {
	MT_VRMBLUMARPRNG,
	MT_VRMYELMARPRNG,
	MT_VRMREDMARPRNG,
	MT_HRMBLUMARPRNG,
	MT_HRMYELMARPRNG,
	MT_HRMREDMARPRNG,
	MT_VGREENMARPRNG,
	MT_DIABLUMARPRNG,
	MT_DIAYELMARPRNG,
	MT_DIAREDMARPRNG,
}

-- #region functions

-- TODO: add animation
-- TODO: add hooks
-- TODO: add tiny delay
-- TODO: account for all things like (Amy's hammer, etc.)

local function TrampolineWave()


end


local function P_SpringTrampoline(mo, th)
	-- Spring Action
	local prev_state = th.state
	
	P_DoSpring(mo, th)
	A_Pain(mo)

	if mo.info.painstate then
		mo.state = mo.info.painstate
	end

	if prev_state == S_PLAY_JUMP then
		th.state = S_PLAY_WALK
	else
		th.state = prev_state
	end
end

-- #endregion
-- #region Hooks

	--for _,hook in ipairs(trampoline_database) do
		--addHook("MobjMoveCollide", P_SpringTrampoline, hook)
	--end

	--addHook("MobjThinker", function(actor)
	--	actor.angle = $ + ANG1*3
	--	if not (6 & leveltime) then
	--		local poweruppar = P_SpawnMobjFromMobj(actor, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(-32,32) << FRACBITS, P_RandomRange(0,64) << FRACBITS, MT_POPPARTICLEMAR)
	--		poweruppar.state = S_INVINCSTAR
	--		poweruppar.scale = actor.scale
	--		poweruppar.color = SKINCOLOR_GOLD
	--		poweruppar.fuse = TICRATE
	--	end
	--end, MT_MARBWKEY)

-- #endregion

