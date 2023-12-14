
/* 





	Wait... are you sure? Aren't you willing to play for this feature or have you already got it in game?























	Please re-consider... gain all dragon coins possible in PKZ to unlock this



















	Honestly... you are just making me sad 







*/

























/* 
		Pipe Kingdom Zone's Toad - game_yahoo.lua

Description:
All scripting for toad character

Skydusk: Buy another Skyrim or Todd Howard will put you into spoiler jail with adoring fan from oblivion.

Contributors: Skydusk
@Team Blue Spring 2024
*/

//

// Table of vegetables to throw
local vegetlist = {}

// Table of grabable enemies
local throwableEnemies = {
	[MT_BLUECRAWLA] = true,
	[MT_REDCRAWLA] = true,
	[MT_GOOMBA] = true,
	[MT_BLUEGOOMBA] = true,	
	[MT_RING_BOX] = true,	
	[MT_REDBUZZ] = true
}

freeslot("MT_TOADJUNKYJARD")

mobjinfo[MT_TOADJUNKYJARD] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 1*FRACUNIT,
	height = 1*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY,
	dispoffset = 1
}



local HALFFRAC = FRACUNIT/2

-- Borrowed Code from bowser's handlers. In case of needing edits
local function P_AimLaunchThrow(m1, m1target, airtime)
	local hordist = R_PointToDist2(m1.x,m1.y, m1target.x, m1target.y)
	local ang = R_PointToAngle2(m1.x,m1.y, m1target.x, m1target.y)
	local verdist = m1.target.z - m1.z
	local fulldist = hordist + FixedDiv(FixedMul(verdist,verdist),hordist) * (verdist > 0 and -1 or 1)
	
	local horspeed = fulldist / airtime
	local verspeed = FixedMul((gravity*airtime)/2, m1.scale)
	
	m1.momx = FixedMul(horspeed, cos(ang))
	m1.momy = FixedMul(horspeed, sin(ang))
	m1.momz = verspeed
	m1.angle = ang
end


// Abilities
addHook("PlayerThink", function(p)
	if not (p.mo and p.mo.valid and p.mo.skin == "toad") then return end 
		 -- write abilities there
	if p.mo.toadpickdelay then
		p.mo.toadpickdelay = $-1
	end		 
	
	
		 
	if pkz_charthrowableenemies.value and p.mo.toadpick and p.mo.toadpick.valid then
		p.mo.friction = FRACUNIT
		p.mo.toadpick.flags = $|MF_NOCLIP|MF_NOGRAVITY &~ (MF_ENEMY|MF_SPECIAL)
		p.mo.toadpick.renderflags = $|RF_VERTICALFLIP
		p.mo.toadpick.spriteyoffset = -p.mo.toadpick.height/2
		P_MoveOrigin(p.mo.toadpick, p.mo.x, p.mo.y, p.mo.z+p.mo.height-5*p.mo.scale)
		local target = P_LookForEnemies(p, false, true)
		if target then
			local visual = P_SpawnMobj(target.x, target.y, target.z, MT_LOCKON)
			visual.target = target	
		end
		if p.cmd.buttons & BT_SPIN and not p.mo.toadpickdelay then
			local throw = p.mo.toadpick.type ~= MT_TOADJUNKYJARD and 
			P_SpawnMobjFromMobj(p.mo.toadpick, 0, 0, 0, MT_TOADJUNKYJARD) or throw
			throw.sprite = p.mo.toadpick.sprite
			throw.frame = p.mo.toadpick.frame
			throw.height = p.mo.toadpick.height
			throw.renderflags = p.mo.toadpick.renderflags
			throw.flags = p.mo.toadpick.flags &~ (MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY)
			throw.target = p.mo
			throw.extravalue1 = p.mo.toadpick.type
			if target then
				throw.momx = 0
				throw.momy = 0
				throw.momz = 0
				P_AimLaunchThrow(throw, {x = target.x, y = target.y, z = target.z + target.height/2}, TICRATE/2)
			else
				throw.momx = 10*cos(p.mo.angle)
				throw.momy = 10*sin(p.mo.angle)
				throw.momz = 10*FRACUNIT
			end
			P_RemoveMobj(p.mo.toadpick)
			p.mo.toadpick = nil
		end
	end
			-- if toadSettings.throwableveg end
	if p.pflags & PF_SPINNING then
		p.mo.state = S_PLAY_PAIN		
		p.mo.friction = FRACUNIT
		if not (p.mo.standingslope or p.mo.lastdetectedslope) then
			p.mo.momx = p.mo.momx > HALFFRAC and $-HALFFRAC or $+HALFFRAC
			p.mo.momy = p.mo.momy > HALFFRAC and $-HALFFRAC or $+HALFFRAC
		else
			p.mo.lastdetectedslope = p.mo.standingslope		
		end
	else
		if p.mo.lastdetectedslope and not p.mo.standingslope then
			p.mo.lastdetectedslope = nil
		end		
		if pkz_charsliding.value and P_IsObjectOnGround(p.mo) and not p.mo.toadpickdelay
		and p.cmd.buttons & BT_SPIN and p.cmd.forwardmove and not p.mo.toadpick then 
			p.pflags = $|PF_SPINNING
			p.mo.momx = max(20*cos(p.mo.angle), p.mo.momx)
			p.mo.momy = max(20*sin(p.mo.angle), p.mo.momy)		
		end
	end
	
	if P_IsObjectOnGround(p.mo) then
		p.mo.toadspin = 0
	else
		if p.mo.toadspin and p.mo.toadspin > 0 then
			p.mo.state = S_PLAY_STND
			p.mo.friction = FRACUNIT
			p.mo.toadspin = $-1
			p.drawangle = p.mo.angle-24*p.mo.toadspin*ANG1
		elseif p.mo.toadspin ~= nil then
			if p.pflags & PF_THOKKED then
				p.pflags = $|PF_NOJUMPDAMAGE			
				p.mo.state = S_PLAY_FALL
			end
			p.mo.toadspin = nil
		end
	end
			-- if toadSettings.stomping end

end)

local function pow(x, n)
	local ogx = x
	for i = 1, (n-1) do
		x = FixedMul(x, ogx)
	end
	return x
end

addHook("MobjThinker", function(a)
	if a.extravalue1 and a.health > 0 then
		if P_IsObjectOnGround(a) then
			a.renderflags = $ &~ RF_VERTICALFLIP
			P_KillMobj(a, a.source, a.source)
		elseif a.tracer then
			a.spriteyoffset = -a.height/2
		end
	end
end, MT_TOADJUNKYJARD)

addHook("MobjDeath", function(a)
	S_StartSound(a, mobjinfo[a.extravalue1].deathsound or sfx_pop)
	if not a.extravalue1 then return false end 	
	a.flags = mobjinfo[a.extravalue1].flags
	a.damage = mobjinfo[a.extravalue1].damage
	a.speed = mobjinfo[a.extravalue1].speed
	a.mass = mobjinfo[a.extravalue1].mass			
	a.state = mobjinfo[a.extravalue1].deathstate or S_NULL
	a.reactiontime = mobjinfo[a.extravalue1].reactiontime		
	a.spriteyoffset = 0
	return false
end, MT_TOADJUNKYJARD)

addHook("MobjCollide", function(a, co)
	if co.flags & MF_ENEMY and co and co.valid and co.health > 0 then 
		local val = co.z+co.height+a.height
		if co.z <= a.z and val >= a.z then
			local target
			P_DamageMobj(co, a.source, a.source, 1)
			if target then
				a.momx = 0
				a.momy = 0
				a.momz = 0
				P_AimLaunchThrow(a, {x = target.x, y = target.y, z = target.z + target.height/2}, TICRATE/2)
			else
				a.momx = FixedMul(10*cos(a.angle), a.scale)
				a.momy = FixedMul(10*sin(a.angle), a.scale)
				a.momz = 10*a.scale
			end
			return true
		end
	else
		return
	end
end, MT_TOADJUNKYJARD)

addHook("MobjCollide", function(a, co)
	if throwableEnemies[a.type] == nil or co.type ~= MT_PLAYER or co.skin ~= "toad" then return end
	local val = a.z+a.height
	if co.z <= val+8*FRACUNIT and co.z > val and not (co.player.pflags & PF_JUMPDOWN) then 
		if co.state == S_PLAY_FALL then
			co.state = S_PLAY_STND
		end
		co.player.pflags = $ &~ (PF_JUMPED)	
		co.momz = a.momz
		if co.player.cmd.buttons & BT_SPIN and pkz_charthrowableenemies.value and not co.toadpick then
			co.toadpickdelay = 12
			co.toadpick = a
		end
	end
end)

addHook("AbilitySpecial", function(p)
	if p.mo.skin ~= "toad" or p.pflags & PF_THOKKED then return end
	p.mo.momz = 8*p.mo.scale
	p.mo.toadspin = 15
	p.pflags = $|PF_JUMPED|PF_THOKKED	& ~(PF_NOJUMPDAMAGE)
end)
