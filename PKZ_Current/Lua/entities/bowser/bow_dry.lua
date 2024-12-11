-- do you want me delete you in your sleep for peeing into script files for spoilers?!!?!?!?!?!?!?!?!!?
-- FINE, THAT'S IT. *presses Delete*
























































--[[ 
		Pipe Kingdom Zone's Bowser - bow_dry.lua

Contributors: Skydusk
@Team Blue Spring 2024
--]]


local function P_DryBowserMiddleJoint(point_a, joint, point_b, pos)
	local ease_x = ease.linear(pos, point_a.x, point_b.x)
	local ease_y = ease.linear(pos, point_a.y, point_b.y)
	local ease_z = ease.linear(pos, point_a.z, point_b.z)
	
	P_MoveOrigin(joint, ease_x, ease_y, ease_z)
end

-- I hate this.

-- addHook("MapthingSpawn", function(a, mt)

	--	head
	--	jaw
	--	body
	--	back
	
	-- 	left joint
	--	left hand	
	
	--	right joint	
	--	right hand

--end, MT_DRYBROWSER)

-- addHook("MobjThinker", function(a)
	-- check existence
	-- check activation

	-- major_state = "stay", scream
	-- standby
	-- summon
	-- active -- cannot swap from this when left_right state is standby
	-- flamethrower
	-- right swing
	-- left swing
	-- screaming
	-- dying
	
	-- left_state = "" 
	-- major_state has to be active
	-- standby
	-- punch 1/8
	-- fireball 1/12
	
	-- right_state = ""
	-- major_state has to be active
	-- standby
	-- punch 1/8
	-- fireball 1/12
	
	-- left_punch_cooldown = 0
	-- right_punch_cooldown = 0
	-- scream_cooldown = 0
	-- flamethrower = 0
	-- magicballs/fireballs = 0


	-- every tic, head animation


	-- WOAH, my head is spinning.

--end, MT_DRYBROWSER)