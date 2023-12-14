/* 
		Team Blue Spring's Series of Libaries. 
		Optimalization Library - lib_optimal.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

local libOpt = {
	stringversion = '1.0',
	iteration = 1,
	
	ENEMY_CONST = 3000*FRACUNIT,
	LENEMY_CONST = 5000*FRACUNIT,	
	ITEM_CONST = 2750*FRACUNIT,
}

rawset(_G, "libOpt", libOpt)

//
// FUNCTIONS
//

libOpt.ConsoleCameraBool = function(a, limit_dist)
	local result = R_PointToDist(a.x, a.y) 
	return (limit_dist >= result)
end

libOpt.LODConsole = function(a, limit_dist, spr_model, lod_model, bool)
	if not (a and a.valid) then return end

	local cam_dist = R_PointToDist(a.x, a.y)
	
	if limit_dist >= cam_dist and bool and P_CheckPosition(a, camera.x, camera.y, camera.z) then
		if spr_model then spr_model(a, a.spawnpoint) end
		bool = false
	elseif limit_dist < cam_dist and not bool then
		if lod_model then lod_model(a, a.spawnpoint) end
		bool = true
	end
	
	return bool
end

local x_4FRAC = 4*FRACUNIT
local function P_CalculateSidesDist(a)
	local n_sides = {}
	local radius = a.radius<<1+x_4FRAC
	for i = 1,4 do
		local ang = a.angle + ANGLE_90*i
		local x = a.x + FixedMul(a.radius, cos(ang))
		local y = a.y + FixedMul(a.radius, sin(ang))
		local check = false
		if not a.activate then
			searchBlockmap("objects", function(ref, found) 
				if found.blocktype then
					local dist = R_PointToDist2(a.x, a.y, found.x, found.y)
					local angle = R_PointToAngle2(a.x, a.y, found.x, found.y)
					if dist < radius and ang == angle and a.z == found.z then
						check = true
						return true
					end		
				end
			end, a)
		end
		n_sides[i] = {dist = R_PointToDist(x, y), key = i, collide = check}
	end
	table.sort(n_sides, function(a, b) return a.dist > b.dist end)
	return n_sides
end

libOpt.BlockCulling = function(a)
	local block_sides = {false, false, false, false, false, false}
	if not (a.sides and a.sides[1]) then return block_sides end
	local n_sides = P_CalculateSidesDist(a)

	for i = 1,4 do
		local side = n_sides[i]
		block_sides[side.key] = side.collide or (3 > i)
	end

	if camera.z < a.z and not P_IsObjectOnGround(a) then
		block_sides[5] = true
	end
	if camera.z > a.z+a.height then
		block_sides[6] = true
	end	

	return block_sides
end

