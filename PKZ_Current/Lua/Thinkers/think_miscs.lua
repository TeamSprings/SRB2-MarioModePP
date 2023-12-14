/* 
		Pipe Kingdom Zone's Misc - think_miscs.lua

Description:
All misc. stuff for thinker objects.

Contributors: Skydusk
@Team Blue Spring 2024
*/

// Koopa pop action... it literally just spawns particle... 
// Do you really need this comment? 
// Written by Ace
local function KoopaPop(actor, toucher)
	if actor.mariofrozenkilled then return end
	local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
	spawndamageparticle.fuse = TICRATE
	spawndamageparticle.scale = (actor.scale << 2)/3
	A_SpawnMarioStars(actor, toucher)	
	S_StartSound(nil, sfx_mario2)
end 

// Spawn 1-up Score
// Written by Ace

function A_Spawn1upScore(a)
	local spawnscore = P_SpawnMobjFromMobj(a, 0, 0, 24*FRACUNIT, MT_SCORE)
	spawnscore.fuse = TICRATE >> 1
	spawnscore.scale = (a.scale/3) << 1	
	spawnscore.momz = FRACUNIT*3
	spawnscore.source = a
	spawnscore.frame = K
end

addHook("MobjDeath", A_Spawn1upScore, MT_LIFESHROOM)

local FIXED_VOL_ICE = 32 << FRACBITS

// Ice Statues and GOLD!
// Written by Ace
addHook("MobjDeath", function(actor, mo, source)
	if not (actor and actor.valid and actor.flags & MF_ENEMY and actor.info.spawnhealth <= 2 and mo and mo.valid) then return end
		if mo.type == MT_PKZIB then
			local heightdif = 0
			local dummyobject = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_BLOCKVIS)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.frame = actor.frame &~ FF_ANIMATE			
			dummyobject.color = SKINCOLOR_ICY
			dummyobject.colorized = true
			dummyobject.flags = $|MF_SOLID|MF_PUSHABLE & ~(MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_NOCLIPTHING) 	
			dummyobject.fuse = 320
			dummyobject.phase = 0
			dummyobject.angle = actor.angle
			dummyobject.scale = actor.scale
			dummyobject.radius = FRACUNIT<<5
			dummyobject.height = actor.height + FIXED_VOL_ICE - (actor.height % FIXED_VOL_ICE)
			dummyobject.ogmobjtype = actor.type
			dummyobject.ogcolor = actor.color
			dummyobject.ogcolorized = actor.colorized
			dummyobject.sourcekiller = source
			dummyobject.sprmodel = 99
			dummyobject.sides = {}
			dummyobject.customfunc = function(obj)
				if not obj.sides then return end
				
				if not (obj.fuse % 80) then
					for i = 1,4 do
						local side = obj.sides[i]
						side.frame = min(obj.phase, 3)|FF_TRANS40|FF_PAPERSPRITE
					end
					obj.phase = $+1
					S_StartSound(obj, sfx_iceb)
				end

				if obj.fuse == 1 then
					local body = P_SpawnMobjFromMobj(obj, 0, 0, 0, obj.ogmobjtype)					
					body.mariofrozenkilled = true
					body.color = obj.ogcolor
					body.colorized = obj.ogcolorized
					if obj.sourcekiller then
						P_DamageMobj(body, obj.sourcekiller, obj.sourcekiller, 1)
					else
						P_KillMobj(body)					
					end
						
						
					for i = 1,10 do
						local zsp = (obj.height/10)*i
						local debries = P_SpawnMobjFromMobj(obj, 0, 0, zsp, MT_POPPARTICLEMAR)
						debries.fireballp = true
						debries.state = S_INVISIBLE
						debries.flags = $ &~ MF_NOGRAVITY
						debries.sprite = SPR_PFUF
						debries.frame = H|FF_TRANS40
						debries.angle = ANGLE_90*i+P_RandomRange(-8,8)*ANG1
						debries.momz = P_RandomRange(4,7) << FRACBITS
						debries.fuse = 38
					
						if i % 2 then
							local dust = P_SpawnMobjFromMobj(debries, 20*cos(debries.angle), 20*sin(debries.angle), 20 << FRACBITS, MT_SPINDUST)
							dust.scale = $+obj.scale>>1
						end
						P_Thrust(debries, debries.angle, 2 << FRACBITS)
					end
				end
			end
			
			if actor.height > 64*FRACUNIT then
				heightdif = (actor.height-64*FRACUNIT)/64
			elseif actor.type == MT_MGREENKOOPA or actor.type == MT_BPARAKOOPA or actor.type == MT_PARAKOOPA then
				heightdif = FRACUNIT/2
			end
			
			for i = 1,4 do
				local blockSpawn = P_SpawnMobjFromMobj(actor, 0,0,0, MT_BLOCKVIS)
				blockSpawn.target = dummyobject
				blockSpawn.scale = actor.scale
				blockSpawn.spriteyscale = FRACUNIT + heightdif
				blockSpawn.id = i
				blockSpawn.state = S_BLOCKVIS
				blockSpawn.sprite = SPR_4MIC
				blockSpawn.frame = A|FF_TRANS40|FF_PAPERSPRITE
				blockSpawn.sprmodel = 1
				table.insert(dummyobject.sides, blockSpawn)
			end
			P_RemoveMobj(actor)	
			return true
		elseif mo.type == MT_PKZGB then
			A_CoinDrop(actor, 4, 0)
		end
end)



// Shellpop... quite same as before KoopaPop
// Written by Ace

local function ShellPop(actor, toucher)
	if not (not actor.mariofrozenkilled and toucher.type == MT_PLAYER and (toucher.z > actor.z + actor.info.height) or 
	(P_IsObjectOnGround(toucher) and not (actor.momx or actor.momy))) then return end
	
	local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
	spawndamageparticle.fuse = TICRATE
	spawndamageparticle.scale = actor.scale
	A_SpawnMarioStars(actor, toucher)	
end

local function ShellvsShell(actor, toucher)
	if toucher.type == MT_SHELL and toucher.z >= actor.z and toucher.z <= actor.z+actor.height then
		local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
		spawndamageparticle.momx = 0
		spawndamageparticle.momy = 0
		spawndamageparticle.momz = 0	
		spawndamageparticle.fuse = TICRATE
		spawndamageparticle.scale = actor.scale
		if not actor.threshold then
			actor.movedir = (actor.movedir == 1 and -1 or 1)
			P_InstaThrust(actor, toucher.angle, actor.info.speed*actor.scale)
			actor.target = toucher.target or toucher
			actor.threshold = (3*TICRATE)/2
		end
		return true
	end
end

// Fire Ball Death Thinker for specific Enemies
// Written by Ace

local function FireballDeath(actor, toucher)
	if not (toucher and (toucher.type == MT_FIREBALL or actor.mariofrozenkilled or toucher.type == MT_PKZFB or toucher.type == MT_PKZGB or 
	toucher.type == MT_SHELL and toucher.type ~= MT_PKZGB)) then return end
	
	A_Scream(actor)
	A_CoinDrop(actor, (toucher.type == MT_PKZGB and 4 or 0), 0)
	
	local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
	dummyobject.state = S_MARIOSTARS
	if actor.type == MT_MGREENKOOPA or actor.type == MT_PARAKOOPA or actor.type == MT_BPARAKOOPA
		dummyobject.sprite = SPR_SHLL		
	else
		dummyobject.sprite = actor.sprite
	end
	dummyobject.color = actor.color		
	dummyobject.flags = $|MF_NOCLIPHEIGHT
	dummyobject.flags = $ &~ MF_NOGRAVITY	
	dummyobject.momz = 8*FRACUNIT
	dummyobject.momx = 3*FRACUNIT
	dummyobject.momy = 3*FRACUNIT
	dummyobject.fuse = 60
	dummyobject.angle = actor.angle
	dummyobject.fireballp = true
	P_RemoveMobj(actor)
end

// Thinker for Dummy Object repressented in previous function
// Written by Ace

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

addHook("MobjDamage", KoopaPop, MT_BPARAKOOPA)
addHook("MobjDamage", KoopaPop, MT_PARAKOOPA)
addHook("MobjDamage", KoopaPop, MT_MGREENKOOPA)
addHook("MobjDamage", KoopaPop, MT_MARIOFISH)
addHook("TouchSpecial", ShellPop, MT_SHELL)
addHook("MobjCollide", ShellvsShell, MT_SHELL)
addHook("MobjDamage", FireballDeath, MT_BPARAKOOPA)
addHook("MobjDamage", FireballDeath, MT_PARAKOOPA)
addHook("MobjDamage", FireballDeath, MT_MGREENKOOPA)
addHook("MobjDamage", FireballDeath, MT_SHELL)

// New Goomba's death states additions
// Written by Ace


-- I wouldn't do this shit, if game actually took vanilla mapthing indeficiations seriously.
addHook("MapThingSpawn", function(a, mt)
	a.gbknock = 2
end, MT_BLUEGOOMBA)

addHook("MapThingSpawn", function(a, mt)
	a.gbknock = 2
end, MT_2DBLUEGOOMBA)

local scaled_goomba_sound = { [FRACUNIT*2] = sfx_mariog, [FRACUNIT/2] = sfx_marioh, [FRACUNIT*8/10] = sfx_mario5}

local function PressureGoomba(actor, mo)
	if not (actor and actor.valid and mo and mo.valid) then return end

	if mo.state == S_PLAY_JUMP or mo.state == S_PLAY_FALL then
		for i = -45,45,90 do
			local pressgom = P_SpawnMobjFromMobj(actor, 0,0,0, MT_PRESSUREPARTICLEMAR)
			pressgom.fuse = 45
			pressgom.scale = actor.scale
			pressgom.angle = mo.angle + ANG1*i
		end
		A_SpawnMarioStars(actor, mo)
		S_StartSound(mo, scaled_goomba_sound[actor.scale] or sfx_mario5)
	end
	
	if not (mo.state == S_PLAY_ROLL or mo.type == MT_FIREBALL or mo.type == MT_SHELL or mo.type == MT_PKZFB or mo.type == MT_PKZGB and mo.type ~= MT_PKZIB) then return end
	
	if mo.type ~= MT_PKZGB
		if mo.type == MT_FIREBALL then
			A_CoinDrop(actor, 0, 0)
		else
			A_CoinProjectile(actor, 0, 0) 
		end
	end
	actor.gbknock = $ or 1
	
	local goombaknock = P_SpawnMobjFromMobj(actor, 0,0,0, MT_GOOMBAKNOCKOUT)
	goombaknock.state = (actor.gbknock == 2 and S_BLUEGOOMBA_KNOCK or S_GOOMBA_KNOCK) 
	S_StartSound(goombaknock, sfx_mario2)
	goombaknock.momx = $+mo.momx << 1
	goombaknock.momy = $+mo.momy << 1
	goombaknock.momz = 5 << FRACBITS + mo.momz
	goombaknock.angle = mo.angle+ANGLE_180
	goombaknock.scale = actor.scale
	if mo.type == MT_FIREBALL or mo.type == MT_PKZFB then
		goombaknock.color = SKINCOLOR_CARBON
		goombaknock.colorized = true
		local smoke = P_SpawnMobjFromMobj(actor, 0, 0, 0, MT_POPPARTICLEMAR)
		smoke.scale = $+FRACUNIT >> 1
		smoke.color = SKINCOLOR_CARBON
		smoke.colorized = true
	end
	P_RemoveMobj(actor)

end	

local function RemovedGoomba(actor, mo)
	local spawndamageparticle = P_SpawnMobjFromMobj(actor, 0,0,-4*FRACUNIT, MT_POPPARTICLEMAR)
	spawndamageparticle.state = S_PIRANHAPLANTDEAD
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
end	

// Bullet Bill Death
// Written by Ace
local function BulletDeathCheck(actor, mo)
	if not (actor and actor.valid) then return end
	
	if mo and mo.valid then
		if mo.state == S_PLAY_JUMP or mo.state == S_PLAY_ROLL then
		local spawndamageparticle = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
		spawndamageparticle.fuse = TICRATE
		spawndamageparticle.scale = (actor.scale << 2)/3
		S_StartSound(actor, sfx_pop)
		P_RemoveMobj(actor)
		else
			if not P_LookForPlayers(actor, 5024 << FRACBITS, true, false) then
				S_StartSound(actor, actor.info.deathsound)
				P_RemoveMobj(actor)
			else
				A_TNTExplode(actor, MT_TNTDUST)					
				S_StartSound(actor, actor.info.deathsound)
				P_RemoveMobj(actor)
			end
		end
	else
		if not P_LookForPlayers(actor, 5024 << FRACBITS, true, false) then
			S_StartSound(actor, actor.info.deathsound)
			P_RemoveMobj(actor)
		else
			A_TNTExplode(actor, MT_TNTDUST)
			S_StartSound(actor, actor.info.deathsound)
			P_RemoveMobj(actor)
		end
	end
end

addHook("MobjDeath", BulletDeathCheck, MT_BULLETBILL)
addHook("MobjDeath", BulletDeathCheck, MT_HOMINGBULLETBILL)

// Piss
// Written by Ace

local function Piss(actor, collider)	
	local skin = skins[collider.player.skin]
	if collider.skin == "hms123311" and actor.type ~= MT_EGGGOOMBA then
		local lmaogoomba = P_SpawnMobj(actor.x, actor.y, actor.z, MT_EGGGOOMBA)
		S_StartSound(lmaogoomba, sfx_mario2)
		P_RemoveMobj(actor)
		return true
	end
end	



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

// Goomba Table
for _,goombas in pairs({
	MT_GOOMBA,
	MT_BLUEGOOMBA,
	MT_2DGOOMBA,
	MT_2DBLUEGOOMBA,
	MT_EGGGOOMBA,
	}) do

addHook("MobjDeath", PressureGoomba, goombas)
addHook("MobjRemoved", RemovedGoomba, goombas)
//addHook("MobjDeath", Piss, goombas)
end

for _,piranhas in pairs({
	MT_REDPIRANHAPLANT,
	MT_FIREFPIRANHAPLANT
}) do


addHook("MapThingSpawn", function(a, tm)
	local workz, workh, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	a.scale = scale
	a.parts = {}
	-- translated A_ConnectToGround
	if a.z ~= a.floorz then
		workz = a.floorz - a.z
		workh = 21 << FRACBITS
		workb = P_SpawnMobjFromMobj(a, 0, 0, workz, MT_NSMBPALMTREE)
		workb.state = S_BLOCKVIS
		workb.sprite = SPR_MRPS	
		workb.frame = C
		workb.flags = $|MF_PAIN|MF_NOCLIPHEIGHT		
		workz = $ + workh
		table.insert(a.parts, workb)

		if workh ~= 21 << FRACBITS
			return
		end

		while (workz < 0) do
			work = P_SpawnMobjFromMobj(a, 0,0, workz, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = C
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW			
			workz = $ + workh
			table.insert(a.parts, work)
		end
		if (workz ~= 0) then
			P_SetOrigin(a, a.x, a.y, a.z + workz)
		end
	end
end, piranhas)
	
end

addHook("MapThingSpawn", function(a, tm)
	local spawn, comp, workz, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local scale = tm.scale
	local angle = tm.angle*ANG1
	a.scale = scale
	a.parts = {}
	-- translated A_ConnectToGround
	spawn = (tm.extrainfo*2 or tm.args[0]*2)+1
	comp = 0
	
		while (comp < spawn) do
			work = P_SpawnMobjFromMobj(a, -(21*comp+24)*cos(angle), -(21*comp+24)*sin(angle), 4*FRACUNIT, MT_NSMBPALMTREE)
			work.state = S_BLOCKVIS
			work.sprite = SPR_MRPS
			work.frame = D|FF_PAPERSPRITE
			work.rollangle = ANGLE_90
			work.angle = angle
			work.flags = $|MF_PAIN|MF_NOCLIP|MF_NOCLIPHEIGHT
			work.flags2 = $|MF2_LINKDRAW
			comp = $+1
			table.insert(a.parts, work)
		end
end, MT_REDHPIRANHAPLANT)


addHook("MapThingSpawn", function(a, tm)
	local workz, workh, work, workb
	local offsetxtrunk = 1
	local offsetangle = 1
	local decrease = 0
	local scale = tm.scale
	local angle = tm.angle*ANG1
	a.scale = scale
	-- translated A_ConnectToGround
	if a.frame == A
		workz = a.floorz - a.z
		workh = mobjinfo[a.type].height
		workb = P_SpawnMobjFromMobj(a, 0, 0, workz, a.type)
		workb.frame = B
		workb.spritexscale = (FRACUNIT*3) >> 1
		workz = $ + workh

		if workh ~= mobjinfo[a.type].height
			return
		end

		while (workz < 0) do
			work = P_SpawnMobjFromMobj(a, offsetxtrunk*cos(angle), offsetxtrunk*sin(angle), workz, a.type)
			work.spritexscale = workb.spritexscale - decrease
			work.frame = B
			if decrease < FRACUNIT >> 1 then
				decrease = $+FRACUNIT >> 3
			end
			if tm.extrainfo > 0 or tm.args[0] > 0
				work.roll = R_PointToAngle2(0, 0, offsetxtrunk << FRACBITS, workh)
				if offsetxtrunk < 10
					local minusorplus = tm.args[0]+tm.extrainfo-7
					offsetxtrunk = $*((minusorplus)^2)/(14+abs(minusorplus))+(minusorplus-1)/3
				end			
			end
			work.angle = angle
			workz = $ + workh
		end
		if (workz ~= 0)
			P_SetOrigin(a, a.x+offsetxtrunk*cos(angle), a.y+offsetxtrunk*sin(angle), a.z + workz)
		end
	end
end, MT_NSMBPALMTREE)

local colors = {
[0] = SKINCOLOR_NONE,
SKINCOLOR_WHITE,
SKINCOLOR_BONE,
SKINCOLOR_CLOUDY,
SKINCOLOR_GREY,
SKINCOLOR_SILVER,
SKINCOLOR_CARBON,
SKINCOLOR_JET,
SKINCOLOR_BLACK,
SKINCOLOR_AETHER,
SKINCOLOR_SLATE,
SKINCOLOR_BLUEBELL,
SKINCOLOR_PINK,
SKINCOLOR_YOGURT,
SKINCOLOR_BROWN,
SKINCOLOR_BRONZE,
SKINCOLOR_TAN,
SKINCOLOR_BEIGE,
SKINCOLOR_MOSS,
SKINCOLOR_AZURE,
SKINCOLOR_LAVENDER,
SKINCOLOR_RUBY,
SKINCOLOR_SALMON,
SKINCOLOR_RED,
SKINCOLOR_CRIMSON,
SKINCOLOR_FLAME,
SKINCOLOR_KETCHUP,
SKINCOLOR_PEACHY,
SKINCOLOR_QUAIL,
SKINCOLOR_SUNSET,
SKINCOLOR_COPPER,
SKINCOLOR_APRICOT,
SKINCOLOR_ORANGE,
SKINCOLOR_RUST,
SKINCOLOR_GOLD,
SKINCOLOR_SANDY,
SKINCOLOR_YELLOW,
SKINCOLOR_OLIVE,
SKINCOLOR_LIME,
SKINCOLOR_PERIDOT,
SKINCOLOR_APPLE,
SKINCOLOR_GREEN,
SKINCOLOR_FOREST,
SKINCOLOR_EMERALD,
SKINCOLOR_MINT,
SKINCOLOR_SEAFOAM,
SKINCOLOR_AQUA,
SKINCOLOR_TEAL,
SKINCOLOR_WAVE,
SKINCOLOR_CYAN,
SKINCOLOR_SKY,
SKINCOLOR_CERULEAN,
SKINCOLOR_ICY,
SKINCOLOR_SAPPHIRE,
SKINCOLOR_CORNFLOWER,
SKINCOLOR_BLUE,
SKINCOLOR_COBALT,
SKINCOLOR_VAPOR,
SKINCOLOR_DUSK,
SKINCOLOR_PASTEL,
SKINCOLOR_PURPLE,
SKINCOLOR_BUBBLEGUM,
SKINCOLOR_MAGENTA,
SKINCOLOR_NEON,
SKINCOLOR_VIOLET,
SKINCOLOR_LILAC,
SKINCOLOR_PLUM,
SKINCOLOR_RASPBERRY,
SKINCOLOR_ROSY
}

local function Coloring(a, tm)
	a.color = colors[max(min(tm.args[0] or 0, #colors), 0) or 0]
end

for _,colorthings in ipairs({
	MT_SPOTLESSUNDCAPSHROOM,
	MT_UNDCAPSHROOM,
	MT_PTZSHROOM1,
	MT_BSBSHROOM,
	MT_REDSHMDOTLEMARIO,
	MT_REDSHMMARIO,
	MT_REDGSHMMARIO,
	MT_BLBSHROOM,
	MT_BNWSHROOM,
	MT_TEALSHROOM,
	MT_GTEALSHROOM,
	MT_PURSHROOM,
	MT_GPURSHROOM,
}) do
	addHook("MapThingSpawn", Coloring, colorthings)
end



for _,trees in pairs({
	MT_BSBSHROOM,
	MT_NSMBPINETREE1
	}) do

addHook("MapThingSpawn", function(a, tm)
	local workz, workh, work, workb, kang, scale, plusminus, flags
	if tm.extrainfo > 0
		scale = FRACUNIT + tm.extrainfo*FRACUNIT >> 2
	else
		scale = FRACUNIT + tm.scale-FRACUNIT	
	end
	local angle = tm.angle*ANG1
	a.scale = scale

	if tm.options & MTF_OBJECTFLIP then
		workz = a.z - a.ceilingz
		plusminus = -1
		a.frame = D|FF_SEMIBRIGHT
		flags = FF_VERTICALFLIP 
	else
		workz = a.floorz - a.z
		plusminus = 1
		flags = 0
	end
	
	if a.type == MT_BSBSHROOM then
		flags = $|FF_SEMIBRIGHT
	end
	
	-- translated A_ConnectToGround
	if a.frame ~= B and a.frame ~= C
		workh = a.info.height
		workb = P_SpawnMobjFromMobj(a, 0, 0, workz*plusminus, a.type)
		workb.frame = C|flags
		workz = $ + workh

		if workh ~= a.info.height
			return
		end

		kang = angle + ANGLE_45
		while (workz < 0) do
			work = P_SpawnMobjFromMobj(a, 0, 0, workz*plusminus, a.type)
			work.frame = B|flags		
			work.angle = kang
			kang = $ + ANGLE_90
			workz = $ + workh
		end
		if (workz ~= 0)
			P_SetOrigin(a, a.x, a.y, a.z + FixedMul(workz*plusminus, a.scale))
		end
	end
end, trees)

end

addHook("MapThingSpawn", function(a, tm)
	local workz, workh, work, kang, scale
	if tm.extrainfo > 0
		scale = FRACUNIT + tm.extrainfo*FRACUNIT >> 2
	else
		scale = FRACUNIT + tm.scale-FRACUNIT		
	end
	local angle = tm.angle*ANG1
	a.scale = scale
	
	-- translated A_ConnectToGround
	if a.state ~= S_SMWSEAWEEDBODY then
		workz = a.floorz - a.z
		workh = a.info.height

		if workh ~= a.info.height then
			return
		end

		kang = angle + ANGLE_45
		while (workz < 0) do
			work = P_SpawnMobjFromMobj(a, 0, 0, workz, a.type)
			work.state = S_SMWSEAWEEDBODY
			work.flags2 = $|MF2_LINKDRAW
			work.angle = kang
			work.height = 0
			kang = $ + ANGLE_90
			workz = $ + workh
		end
		if (workz ~= 0) then
			P_SetOrigin(a, a.x, a.y, a.z + FixedMul(workz, a.scale))
		end
	end
end, MT_SMWSEAWEEDHEAD)

local function breakpotcollide(a, tm)
	if (tm.z <= (a.z+a.height)) and (tm.z >= a.z) and (((abs(tm.momx)+abs(tm.momy)+abs(tm.momz)) > 20*FRACUNIT) or tm.state == S_PLAY_ROLL or tm.state == S_PLAY_JUMP) then
		P_KillMobj(a, tm)
	end
	return false
end

addHook("MobjCollide", breakpotcollide, MT_SM2POT)
addHook("MobjCollide", breakpotcollide, MT_SM2BIGPOT)

local framesmpiecestable = {H, G, F, E}

addHook("MobjDeath", function(a, t)
		local height = {0,0,18*FRACUNIT,18*FRACUNIT}
			if t.player then
				S_StartSound(nil, a.info.deathsound, t.player)
			end
			for i = 1,4 do			
				local ang = i*ANGLE_90
				local debries = P_SpawnMobjFromMobj(a, 8*cos(ang),8*sin(ang),height[i], MT_POPPARTICLEMAR)
				debries.fireballp = true
				debries.state = S_MARIOSTARS
				debries.momz = 5*FRACUNIT
				debries.flags = $ &~ MF_NOGRAVITY
				debries.fuse = 38
				debries.sprite = SPR_MPOD
				debries.angle = ang
				debries.frame = framesmpiecestable[i]
				P_InstaThrust(debries, ang, 6*FRACUNIT)
			end
		if P_RandomChance(FRACUNIT/3) then
			local ruby = P_SpawnMobjFromMobj(a, 0,0,0, MT_POPPARTICLEMAR)
			ruby.state = S_MARIOSTARS
			ruby.momz = 16*FRACUNIT
			ruby.flags = $ &~ MF_NOGRAVITY
			ruby.fuse = 14
			ruby.sprite = SPR_MPOD
			ruby.frame = I
			if t.player then
				S_StartSound(nil, sfx_zelda1, t.player)
				t.player.rings = $+1
			end
		else
			A_CoinProjectile(a, 0, 0)
		end
end, MT_SM2POT)
			

local framepiecestable = {D, D, C, C, B, B, A, A}

addHook("MobjDeath", function(a, t)
		local height = {0,0,36*FRACUNIT,36*FRACUNIT,72*FRACUNIT, 72*FRACUNIT, 100*FRACUNIT, 100*FRACUNIT}
			if t.player then
				S_StartSound(nil, a.info.deathsound, t.player)
			end
			for i = 1,8 do
				local ang = i*ANGLE_90			
				local debries = P_SpawnMobjFromMobj(a, 8*cos(ang),8*sin(ang),height[i], MT_POPPARTICLEMAR)
				debries.fireballp = true
				debries.state = S_MARIOSTARS
				debries.momz = 5*FRACUNIT
				debries.flags = $ &~ MF_NOGRAVITY
				debries.fuse = 38
				debries.sprite = SPR_MPOD
				debries.angle = ang				
				debries.frame = framepiecestable[i]			
				P_InstaThrust(debries, ang, 6*FRACUNIT)
			end
		if P_RandomChance(FRACUNIT/12) then
			local ruby = P_SpawnMobjFromMobj(a, 0,0,0, MT_POPPARTICLEMAR)
			ruby.state = S_MARIOSTARS
			ruby.momz = 16*FRACUNIT
			ruby.flags = $ &~ MF_NOGRAVITY
			ruby.fuse = 14
			ruby.sprite = SPR_MPOD
			ruby.frame = I
			if t.player then
				S_StartSound(nil, sfx_zelda1, t.player)
				t.player.rings = $+1
			end
		else
			A_CoinProjectile(a, 0, 0, t)
		end			
end, MT_SM2BIGPOT)

local framedebtable = {D, C, B, A}

addHook("MobjDeath", function(a, t)
	if not (a.keyhole == true) then return end
	
	local height = {0,0,36*FRACUNIT,36*FRACUNIT}
	
	for i = 1,4 do
		local ang = i*ANGLE_180+a.angle+ANGLE_90	
		local debries = P_SpawnMobjFromMobj(a, 8*cos(ang),8*sin(ang),height[i], MT_POPPARTICLEMAR)
		debries.fireballp = true
		debries.state = S_MARIOSTARS
		debries.momz = 5*FRACUNIT
		debries.flags = $ &~ MF_NOGRAVITY
		debries.fuse = 38
		debries.sprite = SPR_1MDR
		debries.angle = ang				
		debries.frame = framedebtable[i]			
		P_InstaThrust(debries, ang, 6*FRACUNIT)
	end
end, MT_BLOCKVIS)
			
local framskytable = {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O}

addHook("MapThingSpawn", function(a, mt)
	local actsetting
	
	actsetting = (mt.extrainfo or mt.args[0])+1		
	a.sprite = SPR_TIM0
	a.frame = framskytable[actsetting] or 0
end, MT_MARSKYBOXTHING)

addHook("MapThingSpawn", function(a)
	local overlay = P_SpawnMobjFromMobj(a, 0,0,25*FRACUNIT, MT_OVERLAY)
	overlay.target = a
	overlay.state = S_SMALLOILLFLARE
	overlay.scale = a.scale/8	
	overlay.spriteyoffset = a.height/2		
end, MT_CASTLECANDLE)

addHook("MapThingSpawn", function(a, mt)
	local angle = FixedAngle(mt.angle << FRACBITS)
	local scale = a.info.radius
	local base = P_SpawnMobjFromMobj(a, -P_ReturnThrustX(a, angle, scale), -P_ReturnThrustY(a, angle, scale), 0, MT_BLOCKVIS)
	base.angle = angle + ANGLE_90
	base.target = a
	base.state = S_HORIZONTALCASTSPIKEBASE
end, MT_HORIZONTALCASTSPIKE)

addHook("MobjCollide", function(a, t)
	if t and t.player and t.z < a.z+a.height-4*FRACUNIT and t.z+t.height > a.z-4*FRACUNIT and 
	not (t.player.powers[pw_invulnerability] or t.player.powers[pw_flashing] or t.player.powers[pw_super]) then 
		P_DamageMobj(t)
	end
end, MT_HORIZONTALCASTSPIKE)

addHook("MobjCollide", function(a, t)
	if t and t.player and t.z > a.z+a.height and t.z <= a.z+a.height+4*FRACUNIT and a.momz == 0 and 
	not (t.player.powers[pw_invulnerability] or t.player.powers[pw_flashing] or t.player.powers[pw_super]) then 
		P_DamageMobj(t)
	end
end, MT_CASTLESPIKES)