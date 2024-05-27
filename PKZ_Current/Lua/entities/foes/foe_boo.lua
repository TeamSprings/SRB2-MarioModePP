
local function P_AngleBoolean(ang, angc1, angc2)
	if ang < angc1 and ang > angc2 then
		return true
	else
		return false
	end
end

addHook("MapThingSpawn", function(a, mt)
	a.extravalue1 = min(max(mt.args[0], 0), 3) or 0
end, MT_BOO)

addHook("MobjSpawn", function(a, mt)
	if a.extravalue1 == 0 then
		a.extravalue1 = P_RandomRange(1,3)
	end
end, MT_BOO)

addHook("MobjThinker", function(a)
	if P_LookForPlayers(a, a.scale << 10, true, false) or P_LookForPlayers(a, a.scale << 12, false, false) then
		local t = a.target

		if a.health > 0 then
			local tangr = abs(max((t and t.angle or 0)-ANGLE_180, a.angle) - min(a.angle, (t and t.angle or 0)-ANGLE_180))/ANG1
			local state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
			if a.tracer then
				if a.state ~= state then
					a.state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
				end
				if t then
					A_FaceTarget(a)
				end
			else
				if t then
					if tangr < 30 then
						a.state = S_BOOBLOCK
						A_ForceStop(a)
					elseif tangr < 45 then -- side eye watching
						a.state = S_BOOBLOCKLOOKING
						A_ForceStop(a)
					else
						if a.state ~= state then
							a.state = S_BOOCHARGE1+(a.extravalue1 or 1)-1
						end
						P_HomingAttack(a, t)
						if (leveltime % 5) >> 2 then
							A_GhostMe(a)
						end

						if not (leveltime % 56) then
							S_StartSound(a, sfx_mar64f)
						end
					end
				else
					a.state = S_BOOSTILL
					A_ForceStop(a)
				end
			end
		end
	else
		a.target = nil
	end
end, MT_BOO)