// Follow Thinker for Wings
// Written by Ace

local capecor = {
	[1] = { 22, 10;},
	[2] = { -10, 11;},
	[3] = { 12, 0;},
	[4] = { 34, 11;},
	[5] = { 22, 0;},
	[6] = { 22, 32;},
	[7] = { 0, -11;},
}

addHook("MobjThinker", function(actor)
	if (actor and actor.valid and actor.target and actor.target.valid and actor.target.health > 0) then
		local target = actor.target
		local set = (actor.capeset and actor.capeset or 5)

		states[S_WIDEWINGS].frame = (set == 3 and A|FF_ANIMATE|FF_PAPERSPRITE or A|FF_ANIMATE)
		if capecor[set] then
			actor.angle = target.angle + ANGLE_90
			P_MoveOrigin(actor, target.x-(capecor[set][1] or 0)*cos(target.angle), target.y-(capecor[set][1] or 0)*sin(target.angle), target.z+(capecor[set][2] << FRACBITS or 0))
		end
	else
		P_RemoveMobj(actor)
	end
end, MT_WIDEWINGS)
