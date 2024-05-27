
// Bomb-Omh Action Thinker
// Written by Ace
local function P_MarBombohmexp(actor)
	if not (actor and actor.valid) then return end

	actor.bombohmtimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)

	if actor.bombohmtimer == 2 then
		local tirefire = P_SpawnMobjFromMobj(actor, 0,0,39 << FRACBITS, MT_FLAME)
		tirefire.fuse = 32
		tirefire.scale = actor.scale >> 2
		tirefire.flags = MF_NOGRAVITY
	end

	actor.scale = (((actor.bombohmtimer % 10)+1 /5) and $ + FRACUNIT/25 or $ - FRACUNIT/25)
	actor.color = Bombohmcolor[((actor.bombohmtimer % 36) % #Bombohmcolor) + 1]

	if actor.bombohmtimer > 0 and actor.bombohmtimer < 6 then S_StartSound(actor, sfx_fubo64) end

	if actor.bombohmtimer > 29 then
		S_StartSound(actor, sfx_mar64c)
		A_TNTExplode(actor, MT_TNTDUST)
		P_RemoveMobj(actor)
	end
end

// Bomb-Omh Mobj Thinker
// Written by Ace
addHook("MobjThinker", function(actor)
	if not P_LookForPlayers(actor, libOpt.ENEMY_CONST, true, false) then return end

	if actor.state == S_BOMBOHM1 then
		actor.color = SKINCOLOR_SILVER
		if P_LookForPlayers(actor, 46 << FRACBITS, true, false) then
			P_KillMobj(actor)
		elseif P_LookForPlayers(actor, 386 << FRACBITS, true, false) then
			states[S_BOMBOHM1].tics = 12
			states[S_BOMBOHM1].var2 = 3
			if P_IsObjectOnGround(actor) then
				A_MarRushChase(actor, 6)
			end
		else
			A_MarGoinAround(actor)
			states[S_BOMBOHM1].tics = 32
			states[S_BOMBOHM1].var2 = 8
		end
	end

	if actor.state == S_BOMBOHMEXP then
		P_MarBombohmexp(actor)
	end
end, MT_BOMBOHM)

local Bombohmcolor = {
	SKINCOLOR_YELLOW;
	SKINCOLOR_GOLD;
	SKINCOLOR_RED;
	SKINCOLOR_WHITE;
	SKINCOLOR_YELLOW;
	SKINCOLOR_RUBY;
}