/*
l_worldtoscreen.lua
(sprkizard)
(‎Aug 19, ‎2021, ‏‎22:51:56)
Desc: WIP

Usage: TODO
*/


-- Attempt at optimalization by Sky Dusk

local FU160 = 160 << FRACBITS
local FU100 = 100 << FRACBITS

-- vis being camera
local function R_WorldToScreen2(vis, target)
	-- Getting diffenential angle between camera and angle between camera and object
	local sx = vis.angle - R_PointToAngle2(vis.x, vis.y, target.x, target.y)
	-- Get the h distance from the target
	local hdist = R_PointToDist2(vis.x, vis.y, target.x, target.y)
	-- Visibility check
	local visible = (sx < ANGLE_90 or sx > ANGLE_270)

	return {
	x = visible and FixedMul(FU160, tan(sx)) + FU160 or sx,
	y = FU100 + 160*(tan(vis.aiming) - FixedDiv(target.z-vis.z, 1+FixedMul(hdist, cos(sx)))),
	scale = FixedDiv(FU160, hdist),
	onscreen = visible
	}
end

rawset(_G, "R_WorldToScreen2", R_WorldToScreen2)

