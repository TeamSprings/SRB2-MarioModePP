
-- Cut Scenes for invidiual scenarios
-- Scenes - Ending of the level

local ENDINGVARS = {
	-- level ending
	flagdown = 0,
	flagup = 0,
	activefw = 0, -- fireworks
	sumflg = 0, -- flag check
}

local FLAGSCORETABLE = {
    100,
    100,
    200,
    200,
    400,
    400,
    800,
    800,
    1000,
    1000,
    2000,
    2000,
    4000,
    8000,
	12000,
}

local GATESCORETABLE = {
    100,
    100,
    200,
    200,
    400,
    400,
    800,
    800,
    1000,
    1000,
    2000,
    2000,
    4000,
    8000,
}

addHook("MapLoad", function()
	ENDINGVARS.flagdown = 0
	ENDINGVARS.flagup = 0
	ENDINGVARS.activefw = 0
	ENDINGVARS.sumflg = 0
end)

addHook("NetVars", function(net)
    ENDINGVARS.flagdown    = net($)
    ENDINGVARS.flagup      = net($)
    ENDINGVARS.activefw    = net($)
    ENDINGVARS.sumflg      = net($)
end)

local FLG_ACTIVATED = 1
local FLG_SKIP 		= 2
local FLG_GATE 		= 4
local FLG_GATEGAIN 	= 8

-- Mobj Collider
-- Checks if player touches pole

addHook("MobjCollide", function(flag, mo)
	if not mo.player then return end

	if (flag.z + flag.height) > mo.z
    and flag.z < (mo.z - mo.height)
    and (mo.player.pflags &~ PF_FINISHED) then
		
        if mo.mariomode.goalpole_noclip then
			return false
		end

		if mo.mariomode.goalpole == nil then
			mo.mariomode.goalpole = FLG_ACTIVATED
			mo.mariomode.goalpole_angle = flag.angle
			
            local split =  flag.height / #FLAGSCORETABLE
            local index = min(max((flag.height - (mo.z - flag.z)) / split, 1), #FLAGSCORETABLE)

			A_AddPlayerScoreMM(mo, FLAGSCORETABLE[index], 2)

			if flag.spawnpoint and flag.spawnpoint.args[1] then
				mo.mariomode.goalpole = $|FLG_SKIP
			end
		end
	end
end, MT_ENDINGPOLEFORFLAG)

addHook("TouchSpecial", function(gate, mo)
	if not (mo.player and mo.mariomode) then return true end

	if not mo.mariomode.goalscore then
		if mo.mariomode.goalpole == nil then
			mo.mariomode.goalpole = FLG_ACTIVATED|FLG_GATE
			mo.mariomode.goalpole_angle = gate.angle - ANGLE_90
		
			if gate.cusval > 0 then
				G_SetCustomExitVars(gate.cusval)
			end		
		end

		if consoleplayer and consoleplayer.valid then
			gate.flags2 = $ | MF2_DONTDRAW
		end

		local split =  gate.extravalue1 / #GATESCORETABLE
		local index = min(max((gate.extravalue1 - (gate.extravalue2 - gate.z)) / split, 1), #GATESCORETABLE)

		A_AddPlayerScoreMM(mo, GATESCORETABLE[index], 2)

		mo.mariomode.goalscore = 1
	end
	return true
end, MT_ENDGATE)

addHook("MobjCollide", function(gate, mo)
	if not (mo.player) then return end
	
	if gate.z < gate.floorz and gate.z > gate.ceilingz then
		return
	end

	if (mo.player.pflags &~ PF_FINISHED) then
		
        if mo.mariomode.goalpole_noclip then
			return
		end

		if mo.mariomode.goalpole == nil then
			mo.mariomode.goalpole = FLG_ACTIVATED|FLG_GATE
			mo.mariomode.goalpole_angle = gate.angle - ANGLE_90

			if gate.cusval > 0 then
				G_SetCustomExitVars(gate.cusval)
			end
		end
	end
end, MT_ENDGATE)

addHook("MobjSpawn", function(gate)
	if gate.extravalue1 < 1 then
		gate.extravalue1 = gate.scale * 450
	end
	
	gate.extravalue2 = gate.z
end, MT_ENDGATE)

addHook("MapThingSpawn", function(gate, mt)
	-- Move height
	if mt.args[0] then
		gate.extravalue1 = gate.spawnpoint.args[0] * FRACUNIT
	end

	-- Custom Exit
	if mt.args[1] then
		gate.cusval = gate.spawnpoint.args[1]
	end
end, MT_ENDGATE)

addHook("MapThingSpawn", function(support, mt)
	-- Sprite
	if mt.args[0] then
		support.frame = max(min(mt.args[0], 3), 0) | FF_PAPERSPRITE
	end

	-- Flip
	if mt.args[1] then
		support.frame = $|FF_HORIZONTALFLIP
	end
end, MT_ENDGATESUPPORT)

--
-- Gateway Thinker
--

addHook("MobjThinker", function(gate)
	local progress = (sin(leveltime * ANG2) + FRACUNIT)/2
	gate.z = ease.linear(progress, gate.extravalue2, gate.extravalue2 + gate.extravalue1)
end, MT_ENDGATE)


-- Player.Camera Cutaway
-- Slide by Pole, Force movement into castle and Stop characters movement in Singleplayer

addHook("PlayerThink", function(p)
	if not (p.playerstate ~= PST_DEAD and mariomode) then return end
	if p.mo.mariomode and p.mo.mariomode.goalpole then
		local data = p.mo.mariomode
        xMM_registry.hideHud = true

		p.mo.angle = data.goalpole_angle
		if data.goalpole_timer == nil then
			data.goalpole_timer = 1
			p.powers[pw_nocontrol] = 250
			if not (data.goalpole & FLG_GATE) then
				p.mo.flags = $ | MF_NOGRAVITY
				if data.goalpole_timer <= 150 then
					p.mo.state = S_PLAY_RIDE
				end
			end
		end

			if data.goalpole_timer > 0 then
				data.goalpole_timer = $ + 1
			end

		if not (data.goalpole & FLG_GATE) then			
			if data.goalpole_timer > 0 and data.goalpole_timer <= 35 then
				S_FadeMusic(0, 2*MUSICRATE, p)
				p.mo.momz = 0
				p.mo.momx = 0
				p.mo.momy = 0
			end

			if data.goalpole_timer == 35 then
				S_StartSound(p.mo, sfx_mariol)
				S_StartSound(p.mo, sfx_marion)
			end

			if data.goalpole_timer >= 35 and data.goalpole_timer < 150 then
				ENDINGVARS.flagdown = 1
				p.mo.momz = -5 << FRACBITS
				p.mo.momx = 0
				p.mo.momy = 0
			end
		end		

		if data.goalpole_timer == 150 and (p.mo.mariomode.goalpole & FLG_SKIP) then
			p.mo.mariomode.goalpole = 0
			data.goalpole_noclip = true
			P_DoPlayerFinish(p)
			S_ResumeMusic(p)
			return
		else
			if data.goalpole_timer >= 150 and data.goalpole_timer < 200 then
				data.goalpole_noclip = true
				p.mo.flags = $ &~ MF_NOGRAVITY
				if p.mo.state ~= S_PLAY_WALK and P_IsObjectOnGround(p.mo) then
					p.mo.state = S_PLAY_WALK
				end
				p.mo.momx = 10*cos(p.mo.angle)
				p.mo.momy = 10*sin(p.mo.angle)
			end

			if data.goalpole_timer == 149 then
				local flagcam = P_SpawnMobj(camera.x, camera.y, camera.z, MT_POPPARTICLEMAR)
				flagcam.state = S_INVISIBLE
				flagcam.angle = camera.angle
				flagcam.height = camera.height
				flagcam.radius = camera.radius
				flagcam.scale = p.camerascale
				flagcam.polecamera = true
				data.goalpole_ease_origin = camera.aiming
				data.goalpole_ease_prog = 0
				p.awayviewaiming = camera.aiming
				p.awayviewmobj = flagcam
				p.awayviewtics = 300
			end

			if not (data.goalpole & FLG_GATE) then 
				if data.goalpole_timer == 200 then
					if leveltime < TICRATE*150 then
						ENDINGVARS.activefw = 1
					end
					ENDINGVARS.flagup = 1
				end

				if data.goalpole_timer > 175 then
					if data.goalpole_ease_prog < FRACUNIT then
						data.goalpole_ease_prog = $ + FRACUNIT/54
					end
					p.awayviewaiming = ease.outsine(data.goalpole_ease_prog, data.goalpole_ease_origin, ANG10)
				end

				if data.goalpole_timer == 225 then
					ENDINGVARS.sumflg = 1
					ENDINGVARS.flagup = 0
					ENDINGVARS.flagdown = 0
				end

				if data.goalpole_timer >= 200 and data.goalpole_timer < 215 then
					p.mo.state = S_PLAY_JUMP
					P_InstaThrust(p.mo, p.mo.angle, 10 << FRACBITS)
					p.mo.momz = 7 << FRACBITS
				end


				if data.goalpole_timer == 275 then
					p.mo.mariomode.goalpole = 0
					P_DoPlayerFinish(p)
				end

				if data.goalpole_timer == 300 then
					ENDINGVARS.activefw = 0
					S_ResumeMusic(p)
				end
			else
				if data.goalpole_timer == 275 then
					p.mo.mariomode.goalpole = 0
					P_DoPlayerFinish(p)
				end
			end
		end
	end
end, MT_PLAYER)

-- Flag goes down too mobo and other goes up

addHook("MobjThinker", function(mo)
	if ENDINGVARS.flagdown == 1 then
		mo.momz = -5 << FRACBITS
	else
		mo.momz = 0
	end
end, MT_PTZFLAG)

addHook("MobjThinker", function(mo)
	if ENDINGVARS.flagup == 1 and ENDINGVARS.sumflg ~= 1 then
		mo.flags2 = $ &~ MF2_DONTDRAW
		mo.momz = 4 << FRACBITS
	elseif ENDINGVARS.flagup == 0 and ENDINGVARS.sumflg == 1 then
		mo.momz = 0
	else
		mo.momz = 0
		mo.flags2 = $|MF2_DONTDRAW
	end
end, MT_NSMBCASTLEFLAG2)

-- Launch Damn Fireworks

local function P_LaunchFireworks(mo)
	mo.scale = 3 << FRACBITS
	if ENDINGVARS.activefw ~= 1 then
		mo.state = S_INVISIBLE
	else
		if P_RandomChance(FRACUNIT/3) and not (leveltime % 60) then
			mo.state = mo.info.spawnstate
			S_StartSound(nil, sfx_mariom)
			
            local pop = P_SpawnMobjFromMobj(mo, 0,0,0, MT_POPPARTICLEMAR)
			pop.state = S_NEWPICARTICLE
			pop.sprite = SPR_PUP2
			pop.scale = mo.scale/2
			pop.fuse = 8
			pop.color = SKINCOLOR_GOLD
			pop.blendmode = AST_TRANSLUCENT
			pop.spparticle = 1
		end
	end
end

addHook("MobjThinker", P_LaunchFireworks, MT_MARFIREWORK1)
addHook("MobjThinker", P_LaunchFireworks, MT_MARFIREWORK2)