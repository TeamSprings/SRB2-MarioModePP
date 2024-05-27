/*
		Pipe Kingdom Zone's Misc - think_miscs.lua

Description:
All misc. stuff for thinker objects.

Contributors: Skydusk
@Team Blue Spring 2024
*/

// New Goomba's death states additions
// Written by Ace

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
