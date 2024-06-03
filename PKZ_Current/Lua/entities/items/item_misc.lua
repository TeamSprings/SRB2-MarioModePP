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

addHook("MobjThinker", function(mo)
	if (mo and mo.valid and mo.target and mo.target.valid and mo.target.health > 0) then
		local target = mo.target
		local set = (mo.capeset and mo.capeset or 5)

		states[S_WIDEWINGS].frame = (set == 3 and A|FF_ANIMATE|FF_PAPERSPRITE or A|FF_ANIMATE)
		if capecor[set] then
			mo.angle = target.angle + ANGLE_90
			P_MoveOrigin(mo, target.x-(capecor[set][1] or 0)*cos(target.angle), target.y-(capecor[set][1] or 0)*sin(target.angle), target.z+(capecor[set][2] << FRACBITS or 0))
		end
	else
		P_RemoveMobj(mo)
	end
end, MT_WIDEWINGS)

addHook("MobjThinker", function(mo)
		if mo.rollangle ~= ANGLE_180 and mo.fireballp == true then
			mo.rollangle = $ - ANG15
		end

		if mo.spparticle then

			if mo.fuse > 0 then
				mo.scale = $ + FRACUNIT/(mo.spparticle == 1 and 24 or 20)
			end

			local transp = FF_TRANS90-(mo.fuse*FRACUNIT >> 1)
			mo.frame = A|transp

		end

		if mo.rayeffect then
			if mo.extravalue1 < 24 and not (mo.fuse % 3) then
				mo.extravalue1 = $+1
			end

			local transp = max(min(9-mo.fuse/3, 9), 4) << FF_TRANSSHIFT
			mo.sprite = SPR_MMBEAM
			mo.frame = ease.outsine(FRACUNIT/(mo.extravalue1 + 1), 24, 0)|transp|FF_PAPERSPRITE
			mo.blendmode = AST_ADD

			if mo.target then
				P_SetOrigin(mo, mo.target.x, mo.target.y, mo.target.z+FixedMul(mo.target.height/2, mo.target.scale))
			end
		end

		if mo.sprite == SPR_BEEM and mo.fuse > 0 then
			mo.scale = $ - FRACUNIT/24
		end

		if mo.m64part then
			mo.rollangle = $ - ANG15
			mo.angle = $ - ANG15 + mo.extravalue1 * ANG1
			mo.spriteyscale = abs((leveltime + mo.extravalue1) % 30 - 15)*FRACUNIT/15
		end

		if mo.fallingwings then
			mo.momz = $ - FRACUNIT/2
			mo.angle = $ - ANG15
			mo.spriteyscale = abs((leveltime) % 100 - 50)*FRACUNIT/50

			if P_IsObjectOnGround(mo) then
				P_RemoveMobj(mo)
				return
			end
		end
end, MT_POPPARTICLEMAR)

//addHook("MobjDeath", Piss, MT_GOOMBA)
// Particle colorizer
// Written by Ace
local function ParticleSpawn(mo, collider)
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
	A_SpawnPickUpParticle(mo, ohthatcolor[mo.type] or SKINCOLOR_GOLD)
	--A_MarioPain(mo, mo.powers[pw_shield], , 5)
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