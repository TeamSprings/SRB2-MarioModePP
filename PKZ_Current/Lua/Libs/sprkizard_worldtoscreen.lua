/*
l_worldtoscreen.lua
(sprkizard)
(‎Aug 19, ‎2021, ‏‎22:51:56)
Desc: WIP

Usage: TODO
*/

local FU160 = 160 << FRACBITS
local FU100 = 100 << FRACBITS

-- vis being camera
local function R_WorldToScreen2(vis, target)

	-- local sx = vis.angle - R_PointToAngle2(p.mo.x, p.mo.y, target.x, target.y)
	local sx = vis.angle - R_PointToAngle2(vis.x, vis.y, target.x, target.y)
	local visible = false

	-- Get the h distance from the target
	local hdist = R_PointToDist2(vis.x, vis.y, target.x, target.y)
	-- print(AngleFixed(sx)/FU )
	if sx > ANGLE_90 or sx < ANGLE_270 then
		-- sx = 0 -- return {x=0, y=0, scale=0}
		visible = false
	else
		sx = FixedMul(FU160, tan($1)) + FU160
		visible = true
	end

	-- local sx = 160*FU + (160 * tan(vis.angle - R_PointToAngle(target.x, target.y)))
	-- local sy = 100*FU + (100 * (tan(vis.aiming) - FixedDiv(target.z, hdist)))
	local sy = FU100 + 160 * (tan(vis.aiming) - FixedDiv(target.z-vis.z, 1 + FixedMul(hdist, cos(vis.angle - R_PointToAngle2(vis.x, vis.y, target.x, target.y))) ))
	
	-- local c = cos(p.viewrollangle)
	-- local s = sin(p.viewrollangle)
	-- sx = $1+FixedMul(c, target.x) + FixedMul(s, target.y)
	-- sy = $1+FixedMul(c, target.y) - FixedMul(s, target.x)

	local ss = FixedDiv(FU160, hdist)

	return {x=sx, y=sy, scale=ss, onscreen=visible}
end

rawset(_G, "R_WorldToScreen2", R_WorldToScreen2)

