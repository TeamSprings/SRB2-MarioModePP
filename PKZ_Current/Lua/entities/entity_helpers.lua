// Goomba Action Thinkers
// Written by Ace
function A_MarRushChase(actor, th)
	A_FaceTarget(actor)
	A_Thrust(actor, th, 1)
end

// Goomba/Bomb-Ohm running around
// Written by Ace
function A_MarGoinAround(actor)
	local speed = FixedHypot(actor.momx, actor.momy)
	local snspeed = actor.scale<<2/5

	actor.goombatimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)

	if actor.goombatimer == 150 then
		actor.angle = $ + ANGLE_45
		actor.goombatimer = 1
	end

	if speed > 0 and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, snspeed), actor.y + P_ReturnThrustY(actor, actor.angle, snspeed), true)
		actor.angle = $+ ANGLE_180
    end

	P_InstaThrust(actor, actor.angle, snspeed)
end