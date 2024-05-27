// Bowser JR Edits
// Written by Ace
local function BowserJRSpawn(actor)
	actor.health = 8
end

addHook("MobjThinker", function(a)
	if not P_LookForPlayers(a, libOpt.ENEMY_CONST, true, false) then return end

	if P_IsObjectOnGround(a) then
		if a.momx or a.momy then
			a.frame = ((leveltime % 8) >> 2 and D or E)
		else
			a.frame = A
		end
	else
		a.frame = C
	end

	--if a.z <= a.watertop and a.health > 0 then
	--	P_KillMobj(a)
	--end
end, MT_KOOPA)

local function BowserJRDamage(actor, collider)
	if collider and collider.valid and collider.type == MT_FIREBALL and (collider.z) >= (actor.z) and (collider.z) < (actor.z+actor.height+FRACUNIT) then
		actor.health = $-1
		-- Remove Fire Ball
		P_RemoveMobj(collider)
		if actor.health <= 0 then
			local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.color = actor.color
			dummyobject.flags = $|MF_NOCLIPHEIGHT
			dummyobject.flags = $ &~ MF_NOGRAVITY
			dummyobject.momz = FRACUNIT<<3
			dummyobject.momx = 3<<FRACBITS
			dummyobject.momy = 3<<FRACBITS
			dummyobject.fuse = 60
			dummyobject.angle = actor.angle
			dummyobject.fireballp = true
			P_RemoveMobj(actor)
		end
	end
end

addHook("MapThingSpawn", BowserJRSpawn, MT_KOOPA)
addHook("MobjCollide", BowserJRDamage, MT_KOOPA)
addHook("MobjRemoved", function(a)
	P_LinedefExecute(650)
	return true
end, MT_KOOPA)


addHook("MobjThinker", function(a)
	if a.state ~= S_HAMMERX then
		a.state = S_HAMMERX
	end

	a.rollangle = $ + ANG10
end, MT_HAMMER)