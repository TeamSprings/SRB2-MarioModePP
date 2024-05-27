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

addHook("MobjThinker", function(actor)
		if actor.rollangle ~= ANGLE_180 and actor.fireballp == true then
			actor.rollangle = $ - ANG15
		end

		if actor.spparticle then

			if actor.fuse > 0 then
				actor.scale = $ + FRACUNIT/(actor.spparticle == 1 and 24 or 20)
			end

			local transp = FF_TRANS90-(actor.fuse*FRACUNIT >> 1)
			actor.frame = A|transp

		end

		if actor.sprite == SPR_BEEM	and actor.fuse > 0 then
			actor.scale = $ - FRACUNIT/24
		end

end, MT_POPPARTICLEMAR)



//addHook("MobjDeath", Piss, MT_GOOMBA)
// Particle colorizer
// Written by Ace
local function ParticleSpawn(actor, collider)
	local ohthatcolor = {
		[MT_LIFESHROOM] = SKINCOLOR_EMERALD,
		[MT_NUKESHROOM]	= SKINCOLOR_RED,
		[MT_FORCESHROOM] = SKINCOLOR_BLUE,
		[MT_ELECTRICSHROOM]	= SKINCOLOR_YELLOW,
		[MT_ELEMENTALSHROOM] = SKINCOLOR_BLUE,
		[MT_CLOUDSHROOM] = SKINCOLOR_AETHER,
		[MT_POISONSHROOM] = SKINCOLOR_PURPLE,
		[MT_FLAMESHROOM] = SKINCOLOR_RED,
		[MT_BUBBLESHROOM] = SKINCOLOR_BLUE,
		[MT_MINISHROOM] = SKINCOLOR_CYAN,
		[MT_REDSHROOM] = SKINCOLOR_GOLD,
		[MT_THUNDERSHROOM] = SKINCOLOR_YELLOW,
		[MT_PITYSHROOM]	= SKINCOLOR_GREEN,
		[MT_PINKSHROOM]	= SKINCOLOR_PINK,
		[MT_GOLDSHROOM] = SKINCOLOR_GOLD,
		[MT_STARMAN] = SKINCOLOR_GOLD,
		[MT_SPEEDWINGS] = SKINCOLOR_AETHER,
		[MT_NEWFIREFLOWER] = SKINCOLOR_RED,
		[MT_ICYFLOWER] = SKINCOLOR_CYAN,
	}
	A_SpawnPickUpParticle(actor, ohthatcolor[actor.type] or SKINCOLOR_GOLD)
	--A_MarioPain(actor, actor.powers[pw_shield], , 5)
end

// Power Up Table
for _,powerups in pairs({
	MT_LIFESHROOM,
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
	MT_CLOUDSHROOM,
	MT_POISONSHROOM,
	MT_FLAMESHROOM,
	MT_BUBBLESHROOM,
	MT_THUNDERSHROOM,
	MT_PITYSHROOM,
	MT_PINKSHROOM,
	MT_GOLDSHROOM,
	MT_MINISHROOM,
	MT_NEWFIREFLOWER,
	MT_ICYFLOWER,
	MT_REDSHROOM,
	MT_STARMAN,
	MT_SPEEDWINGS
	}) do

addHook("MobjDeath", ParticleSpawn, powerups)
end