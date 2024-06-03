local dummy = freeslot("MT_TBSDUMMY")
local font = freeslot("MT_TBSFONT")
local too_big = FRACUNIT*1024

local function addLayer()
	return 0
end


addHook("MobjThinker", function(mo)
	if mo.target and mo.target.valid then
		local base = mo.target
		local dist_check = abs(R_PointToDist2(mo.x, mo.y, base.x, base.y))

		if dist_check > too_big then
			P_SetOrigin(mo, base.x, base.y, base.z)
		else
			P_MoveOrigin(mo, base.x, base.y, base.z)
		end

		mo.angle = base.angle
		mo.flags2 = base.flags2
		mo.renderflags = base.renderflags

		mo.spritexscale = base.spritexscale
		mo.spriteyscale = base.spriteyscale

		mo.spritexoffset = base.spritexoffset
		mo.spriteyoffset = base.spriteyoffset

		if mo.func then
			mo.func(mo)
		end
	else
		P_RemoveMobj(mo)
	end
end, dummy)

local ASCII = {}

for i = 32, 128 do
	ASCII[i-31] = string.char(i) or "NONE"
end

local function ASCII_spritewrite(x, y, z, angle, text, setupfunc, sprite_font, frame_settings)
	local charbank = {}

	for i = 1, string.len(text) do
		local symbol = string.byte(string.sub(text, i, i))
		local ax, ay, az, aangle = x, y, z, angle
		if setupfunc then
			ax, ay, az, aangle = setupfunc(x, y, z, angle, text, i)
		end

		charbank[i] = P_SpawnMobj(ax, ay, az, MT_TBSFONT)
		charbank[i].angle = aangle
		charbank[i].sprite = sprite_font
		charbank[i].frame = symbol|(frame_settings - (frame_settings & FF_FRAMEMASK))
	end

	return charbank[i]
end