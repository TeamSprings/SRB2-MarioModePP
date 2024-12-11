local dummy = freeslot("MT_TBSDUMMY")
local font = freeslot("MT_TBSFONT")
local testfont = freeslot("SPR_MM_FONT_TEST")
local too_big = FRACUNIT*1024

local function addLayer()
	return 0
end

addHook("MobjThinker", function(mo)
	if mo.target and mo.target.valid then
		local base = mo.target

		local padding_angle = base.angle + mo.angle_offset
		local cose = cos(padding_angle)
		local sine = sin(padding_angle)

		local new_x, new_y = mo.offsetx, mo.offsety
		local offset_x = FixedMul(new_x, cose) - FixedMul(new_y, sine)
		local offset_y = FixedMul(new_x, sine) + FixedMul(new_y, cose)

		local dist_check = abs(R_PointToDist(mo.x, mo.y))

		if dist_check > too_big then
			P_SetOrigin(mo, base.x + offset_x, base.y + offset_y, base.z + (mo.offsetz or 0))
		else
			P_MoveOrigin(mo, base.x + offset_x, base.y + offset_y, base.z + (mo.offsetz or 0))
		end

		mo.angle = padding_angle + ANGLE_90
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

local test_font_LUT = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["A"] = 10,
	["B"] = 11,
	["C"] = 12,
	["D"] = 13,
	["E"] = 14,
	["F"] = 15,
	["G"] = 16,
	["H"] = 17,
	["I"] = 18,
	["J"] = 19,
	["K"] = 20,
	["L"] = 21,
	["M"] = 22,
	["N"] = 23,
	["O"] = 24,
	["P"] = 25,
	["Q"] = 26,
	["R"] = 27,
	["S"] = 28,
	["T"] = 29,
	["U"] = 30,
	["V"] = 31,
	["W"] = 32,
	["X"] = 33,
	["Y"] = 34,
	["Z"] = 35,
	["-"] = 36,
	["."] = 37,
}


for i = 32, 128 do
	ASCII[i-31] = string.char(i) or "NONE"
end

local function ASCII_spritewrite(origin, x, y, z, angle, text, setupfunc, sprite_font, frame_settings, lut, thinker)
	local charbank = {}

	local upstr = string.upper(text)
	local lent = #upstr

	for i = 1, lent do
		local symbol = string.sub(upstr, i, i)

		if lut then
			if lut[symbol] then
				symbol = lut[symbol]
			else
				continue
			end
		else
			symbol = string.byte(symbol)
		end

		local ax, ay, az, aangle, color = x, y, z, angle, color
		if setupfunc then
			ax, ay, az, aangle, color = setupfunc(origin, ax, ay, az, aangle, upstr, lent, i)
		end

		charbank[i] = P_SpawnMobjFromMobj(origin, ax, ay, az, dummy)
		local obj = charbank[i]

		obj.angle = aangle
		obj.state = S_INVISIBLE
		obj.flags = $|MF_NOGRAVITY

		obj.sprite = sprite_font
		obj.frame = symbol|(frame_settings - (frame_settings & FF_FRAMEMASK))
		obj.offsetx = ax
		obj.offsety = ay
		obj.offsetz = az
		obj.angle_offset = aangle

		obj.color = color
		obj.target = origin

		obj.func = thinker
	end

	return charbank[i]
end

local function circleText(origin, x, y, z, angle, text, lent, i)
	local pie_ang = FRACUNIT / lent
	local pie = FixedAngle(i * 180 * pie_ang)

	local circle_radius = origin.radius + 32 * origin.scale
	local origin_circle_x = FixedMul(circle_radius, cos(pie))
	local origin_circle_y = FixedMul(circle_radius, sin(pie))

	return origin_circle_x, origin_circle_y, FixedMul(z, sin(pie * 4)), pie, SKINCOLOR_WHITE
end

addHook("MobjSpawn", function(mo)
	mo.joke = ASCII_spritewrite(mo, 0, 0, 12*mo.scale, mo.angle, "TARGET TARGET TARGET TARGET ", circleText, testfont, FF_PAPERSPRITE, test_font_LUT, thinker)
end, MT_TOKEN)

addHook("MobjThinker", function(mo)
	mo.angle = $+ANG1*2
end, MT_TOKEN)
