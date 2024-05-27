local entity = tbsrequire 'entities/entity_common'

// Mushroom thinker... obvi.. obviousl.. fuck
// Written by Ace


local redirect = {
	[0] = 0,
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 1,
	[5] = 1,
	[6] = 4,
	[7] = 4,
}

local MushroomSettings = {
	-- functions
	[0]	= function(mo) return end,

	[1]	= function(mo) -- static
		mo.momx = 0
		mo.momy = 0

		//Transparent Shroom
		if mo.extravalue1 == 4 then
			mo.frame = $ | FF_TRANS70
			mo.flags = $ | MF_NOGRAVITY
		end

		//Invisible Shroom
		if mo.extravalue1 == 5 then
			mo.sprite = SPR_NULL
			mo.flags = $ | MF_NOGRAVITY
		end
	end,

	[2] = function(mo) -- bunnyhop
		if P_IsObjectOnGround(mo) then
			mo.z = $ + P_MobjFlip(mo)
			P_SetObjectMomZ(mo, 4 << FRACBITS, false)
		end
	end,

	[3] = function(mo) mo.scale = mo.spawnpoint.scale*3/2 end, -- scaleup


	[4] = function(mo) -- flying/bubble
		mo.flags = $|MF_NOGRAVITY

		local anglesin = (180 & leveltime)*ANG2
		mo.momz = P_RandomRange(4, 6)*sin(anglesin)
		mo.angle = $ + P_RandomRange(-2, 2)*ANG1

		if not P_TryMove(mo,
		mo.x + P_ReturnThrustX(mo, mo.angle, mo.info.speed << FRACBITS),
		mo.y + P_ReturnThrustY(mo, mo.angle, mo.info.speed << FRACBITS), true) then
			mo.angle = $ + ANGLE_180
		end
	end,
}

local function Mushroom_Spawn(mo, mapth)
	//Behavioral setting
	mo.extravalue1 = max(min((mapth.args[0] or mapth.extrainfo) or 0, #redirect), 0)
	mo.extravalue2 = redirect[mo.extravalue1]
	local wingsa = max(mo.extravalue1-5, 0)

	local wings = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
	if wingsa == 1 then
		wings.state = S_SMALLWINGS
	else
		wings.state = S_MARIOSTARS
		wings.sprite = SPR_BUBL
		wings.frame = FF_TRANS50|FF_FULLBRIGHT|4
		wings.spriteyoffset = -12 << FRACBITS
		wings.spritexscale = 3 << FRACBITS >> 1
		wings.spriteyscale = wings.spritexscale
	end

	wings.target = mo

end

local Mushroom_Animation = {
	-- Lively mushroom animation into itemholder
	[0] = {offscale_x = 0, offscale_y = 0, tics = 4, nexts = 1},
	[1] = {offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offscale_x = -(FRACUNIT >> 3), offscale_y = (FRACUNIT >> 4), tics = 4, nexts = 3},
	[3] = {offscale_x = (FRACUNIT >> 3), offscale_y = -(FRACUNIT >> 4), tics = 3, nexts = 0},
}

local function Mushroom_Thinker(mo)
	if mo.redrewarditem then return end

	//Normal behavior
	local speed = FixedHypot(mo.momx, mo.momy)
	local newspeed = mo.scale << 2

	if speed then
		TBSlib.scaleAnimator(mo, Mushroom_Animation)
		mo.angle = R_PointToAngle2(0,0, mo.momx, mo.momy)
	end

	P_InstaThrust(mo, mo.angle, newspeed)
	//Behaviorselect
	if not (mo.redrewarditem or mo.reserved or mo.mushfall) then
		MushroomSettings[mo.extravalue2 and mo.extravalue2 or 0](mo)
	end
end

// Grouping of Items
// Thanks Amperbee!

for _,shroms in pairs({
	MT_LIFESHROOM,
	MT_NUKESHROOM,
	MT_FORCESHROOM,
	MT_ELECTRICSHROOM,
	MT_ELEMENTALSHROOM,
	MT_CLOUDSHROOM,
	MT_FLAMESHROOM,
	MT_BUBBLESHROOM,
	MT_THUNDERSHROOM,
	MT_PITYSHROOM,
	MT_PINKSHROOM,
	MT_GOLDSHROOM,
	MT_MINISHROOM,
	MT_REDSHROOM
	}) do

addHook("MobjThinker", Mushroom_Thinker, shroms)
addHook("MapThingSpawn", Mushroom_Spawn, shroms)
end

//
// Poison
//

addHook("MapThingSpawn", Mushroom_Spawn, MT_POISONSHROOM)

local POISONDIST = 728<<FRACBITS

addHook("MobjThinker", function(mo)
	if mo.redrewarditem then return end

	//Normal behavior
	local speed = FixedHypot(mo.momx, mo.momy)
	local newspeed = mo.scale << 2

	if speed then
		TBSlib.scaleAnimator(mo, MushroomAnimation)

		local player = P_LookForPlayers(mo, POISONDIST, true, false)
		if player then
			mo.angle = TBSlib.reachAngle(mo.angle, R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y), ANG10)
		else
			mo.angle = R_PointToAngle2(0,0, mo.momx, mo.momy)
		end
	end

	P_InstaThrust(mo, mo.angle, newspeed)
end, MT_POISONSHROOM)


// Spawn 1-up Score
// Written by Ace

addHook("MobjDeath", entity.A_Spawn1upScore, MT_LIFESHROOM)
