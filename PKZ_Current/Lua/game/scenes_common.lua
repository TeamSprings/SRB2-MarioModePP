--[[
		Pipe Kingdom Zone's Scenes  - game_scenes.lua

Description:
Various scene thinkers, functions

Contributors: Ace Lite, Ashi
@Team Blue Spring 2024
--]]

--
-- CUT SCENES
--

addHook("MobjCollide", function(a, tm)
	if not tm.player then return end
	local save_data = xMM_registry.getSaveData()
	if save_data.unlocked & 1 and (a.spawnpoint.extrainfo or a.spawnpoint.args[0]) then
		if a.activated ~= true then
			if a.spawnpoint.extrainfo > 0 or 0 < a.spawnpoint.args[0] then
				local xdkey = P_SpawnMobjFromMobj(tm, 0,0,0, MT_MARBWKEY)
				xdkey.momz = 8*FRACUNIT
				xdkey.fuse = 32
				xdkey.scale = tm.scale
				xdkey.flags = $ &~ MF_SPECIAL
			end
			a.flags = $ | MF_NOCLIP &~ MF_SOLID
			if a.keyhole[1] ~= nil then
				P_KillMobj(a.keyhole[1])
				P_KillMobj(a.keyhole[2])
			end
			a.activated = true
		end
	else
		a.timemessage = true
		a.lastplayer = tm
		if a.countdown == nil or a.countdown < 1 then
			a.countdown = TICRATE
		end
		return true
	end
end, MT_MARIOSTARDOOR)

addHook("MobjCollide", function(a, tm)
	if not tm.player then return end

	local save_data = xMM_registry.getSaveData()
	local total_c = save_data.coins

	if #total_c >= a.requirement then
		if a.activated ~= true then
			a.activated = true
		end
		return false
	else
		a.timemessage = true
		a.lastplayer = tm
		if a.countdown == nil or a.countdown < 1 then
			a.countdown = TICRATE
		end
		return true
	end
end, MT_MARIODOOR)


addHook("MobjThinker", function(a)
	local sp = a.spawnpoint
	a.dis = P_AproxDistance(a.x - sp.x << FRACBITS, a.y - sp.y << FRACBITS)
	if a.activated == true then
		if a.dis < FixedMul(64 << FRACBITS, a.scale) then
			a.momx = 3*cos(a.angle)
			a.momy = 3*sin(a.angle)
		else
			A_ForceStop(a)
			return
		end
	end
	if a.countdown ~= nil then
		if a.timemessage == true and a.countdown == 34 then
			CONS_Printf(a.lastplayer.player, "To open this door you need key")
			a.timemessage = false
		end
		if a.countdown >= 0 then
			a.countdown = $-1
		end
	end
end, MT_MARIOSTARDOOR)

addHook("MobjThinker", function(a)
	local sp = a.spawnpoint

	a.doorease = a.doorease and $ or 0

	if a.activated == true then

		if a.timer == nil then
			a.timer = 50
		end
		if a.timer > 0 then
			a.timer = $-1
		end

		if a.timer == 0 then
			a.activated = false
			a.timer = nil
		end

		if a.doorease < FRACUNIT then
			a.doorease = $+FRACUNIT >> 5
		end
	else
		if a.doorease > 0 then
			a.doorease = $-FRACUNIT >> 5
		end
	end

	a.angle = ease.outquad(a.doorease, sp.angle, sp.angle-90)*ANG1

	if a.countdown ~= nil then
		if a.timemessage == true and a.countdown == 34 then
			CONS_Printf(a.lastplayer.player, "You lack sufficient amount of Dragon Coins to open this door")
			a.timemessage = false
		end
		if a.countdown >= 0 and a.countdown ~= nil then
			a.countdown = $-1
		end
	end
end, MT_MARIODOOR)

--Camera movement

addHook("MobjThinker", function(actor)
	if not (actor and actor.valid) then return end
	if actor.polecamera == true then
		if actor.cameratics == nil then
			actor.cameratics = 1
		end

		if actor.cameratics > 0 then
			actor.cameratics = $ + 1
		end


		if actor.cameratics >= 25 and actor.cameratics <= 75 then
			P_InstaThrust(actor, actor.angle, -5 << FRACBITS)
			if actor.momz < 15 << FRACBITS then
				actor.momz = $ + 2 << FRACBITS
			else
				actor.momz = 15 << FRACBITS
			end
		end

		if actor.cameratics == 76 then
			actor.momz = 0
			actor.momx = 0
			actor.momy = 0
		end

	end
end, MT_POPPARTICLEMAR)