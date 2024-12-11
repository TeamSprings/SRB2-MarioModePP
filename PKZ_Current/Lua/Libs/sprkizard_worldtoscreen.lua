--[[
l_worldtoscreen.lua
(sprkizard)
(‎Aug 19, ‎2021, ‏‎22:51:56)
Desc: WIP

Usage: TODO
]]


-- Attempt at optimalization by Sky Dusk

local A270 = ANGLE_270
local A90 = ANGLE_90

local FU160 = 160 << FRACBITS
local FU100 = 100 << FRACBITS

local fDiv = FixedDiv
local fMul = FixedMul

local tToAngle2 = R_PointToAngle2
local tToDist2 = R_PointToDist2
local tang = tan
local cose = cos

-- vis being camera
local function R_WorldToScreen2(vis, target)
	-- Getting diffenential angle between camera and angle between camera and object
	local sx = vis.angle - tToAngle2(vis.x, vis.y, target.x, target.y)
	-- Get the h distance from the target
	local hdist = tToDist2(vis.x, vis.y, target.x, target.y)
	-- Visibility check
	local visible = (sx < A90 or sx > A270)

	return {
		x = visible and 160*tang(sx) + FU160 or sx,
		y = FU100 + 160*(tang(vis.aiming) - fDiv(target.z-vis.z, 1+fMul(hdist, cose(sx)))),

		scale = fDiv(FU160, hdist),
		onscreen = visible
	}
end

rawset(_G, "R_WorldToScreen2", R_WorldToScreen2)

