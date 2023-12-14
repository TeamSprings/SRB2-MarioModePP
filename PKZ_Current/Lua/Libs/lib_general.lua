/* 
		Team Blue Spring's Series of Libaries. 
		General Library - lib_general.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

local TBSlib = {
	stringversion = '0.015',
	iteration = 4,
	
	-- string drawing library
	textCache = {},
	fontCache = {},
}


//
// Utilities
//

-- Crappy font drawer
--TBSlib.fontdrawer(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
TBSlib.fontdrawer = function(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
	if value == nil then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end
	
	x = FixedMul(x, scale)
	y = FixedMul(y, scale)

	if alligment == "center" then
		x = $-(lenght*scale >> 1)
	elseif alligment == "right" then
		x = $-lenght*scale
	end

	for i = 1,maxv do
		d.drawScaled(x+fontoffset*scale, y, scale, cache[i].patch, flags, color)
		fontoffset = $+cache[i].width
	end
end

-- Crappy font drawer
--TBSlib.fontdrawerNoPosScale(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
TBSlib.fontdrawerNoPosScale = function(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
	if value == nil then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end

	if alligment == "center" then
		x = $-(lenght*scale >> 1)
	elseif alligment == "right" then
		x = $-lenght*scale
	end

	for i = 1,maxv do
		d.drawScaled(x+fontoffset*scale, y, scale, cache[i].patch, flags, color)
		fontoffset = $+cache[i].width
	end
end

--TBSlib.fontdrawerInt(d, font, x, y, value, flags, color, alligment, padding, leftadd, symbol)
TBSlib.fontdrawerInt = function(d, font, x, y, value, flags, color, alligment, padding, leftadd, symbol)
	if value == nil then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end
	
	if alligment == "center" then
		x = $-lenght >> 1
	elseif alligment == "right" then
		x = $-lenght
	end

	for i = 1,maxv do
		d.draw(x+fontoffset, y, cache[i].patch, flags, color)
		fontoffset = $+cache[i].width
	end
end

--Moddifiable Text
--TBSlib.fontdrawerIntMod(d, font, x, y, value, flags, color, alligment, padding, leftadd, symbol, function(x, y, patch, flags, color, i) end)
TBSlib.fontdrawerIntMod = function(d, font, x, y, value, flags, color, alligment, padding, leftadd, symbol, func)
	if not (value ~= nil and func) then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end
	
	if alligment == "center" then
		x = $-lenght >> 1
	elseif alligment == "right" then
		x = $-lenght
	end

	for i = 1,maxv do
		func(x+fontoffset, y, cache[i].patch, flags, color, i)
		fontoffset = $+cache[i].width
	end
end

-- Crappy font drawer
--TBSlib.fontdrawershifty(d, font, x, y, scale, value, flags, color, alligment, padding, shifty, leftadd, symbol)
TBSlib.fontdrawershifty = function(d, font, x, y, scale, value, flags, color, alligment, padding, shifty, leftadd, symbol)
	if value == nil then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end
	
	x = FixedDiv(x, scale)
	y = FixedDiv(y, scale)

	if alligment == "center" then
		x = $-(lenght*scale >> 1)
	elseif alligment == "right" then
		x = $-lenght*scale
	end

	for i = 1,maxv do
		d.drawScaled(x+fontoffset*scale, y, scale, cache[i].patch, flags, color)
		fontoffset = $+cache[i].width
		y = $+shifty
	end
end

-- Crappy font drawer
--TBSlib.fontdrawershifty(d, font, x, y, scale, value, flags, color, alligment, padding, shifty, leftadd, symbol)
TBSlib.fontdrawershiftyNoPosScale = function(d, font, x, y, scale, value, flags, color, alligment, padding, shifty, leftadd, symbol)
	if value == nil then return end
	local str = ''..value
	local fontoffset = 0
	padding = padding or 0

	local strlefttofill = (leftadd or 0)-#str
	if strlefttofill > 0 then
		str = string.rep(symbol or ";", strlefttofill)..str
	end

	local maxv = #str
	local lenght = 0
	local cache = {}

	for i = 1,maxv do
		local cur = TBSlib.cacheFont(d, patch, str, font, val, padding, i)
		table.insert(cache, cur)
		lenght = $+cur.width
	end

	if alligment == "center" then
		x = $-(lenght*scale >> 1)
	elseif alligment == "right" then
		x = $-lenght*scale
	end

	for i = 1,maxv do
		d.drawScaled(x+fontoffset*scale, y, scale, cache[i].patch, flags, color)
		fontoffset = $+cache[i].width
		y = $+shifty
	end
end


TBSlib.breakfontdrawer = function(d, font, x, y, scale, value, flags, color, alligment, spacing)
	local text = ""..value
	local i = 0
	
	for breaks in text:gmatch("[^\r\n]+") do
		TBSlib.fontdrawer(d, font, x, y+i*(spacing or 10)*scale, scale, breaks, flags, color, alligment)
		i = $+1
	end
end

--TBSlib.cacheFont(d, patch, str, font, val, padding, i)
TBSlib.cacheFont = function(d, patch, str, font, val, padding, i)
	val = string.sub(str, i,i)
	if not (TBSlib.fontCache[font] and TBSlib.fontCache[font][val]) then
		if not TBSlib.fontCache[font] then
			TBSlib.fontCache[font] = {}
		end
	
		local ogcheck = font..val
	
		if not d.patchExists(ogcheck) then
			local check = font..string.byte(val)
		
			if d.patchExists(check) then
				TBSlib.fontCache[font][val] = d.cachePatch(check)
			else
				TBSlib.fontCache[font][val] = d.cachePatch(font..'NONE')
			end
		else
			TBSlib.fontCache[font][val] = d.cachePatch(ogcheck)
		end
	end
	local symbol = TBSlib.fontCache[font][val]
	return {patch = symbol, width = symbol.width+padding}
end

--TBSlib.fontlenghtcal(d, patch, str, font, val, padding, i)
TBSlib.fontlenghtcal = function(d, patch, str, font, val, padding, i)
	val = string.sub(str, i,i)
	if not (TBSlib.fontCache[font] and TBSlib.fontCache[font][val]) then
		if not TBSlib.fontCache[font] then
			TBSlib.fontCache[font] = {}
		end
	
		local ogcheck = font..val
	
		if not d.patchExists(ogcheck) then
			local check = font..string.byte(val)
		
			if d.patchExists(check) then
				TBSlib.fontCache[font][val] = d.cachePatch(check)
			else
				TBSlib.fontCache[font][val] = d.cachePatch(font..'NONE')
			end
		else
			TBSlib.fontCache[font][val] = d.cachePatch(ogcheck)
		end
	end
	return TBSlib.fontCache[font][val].width+padding
end

//
// Extra Math Section
//

local function pow(x, n)
	local ogx = x
	for i = 1, (n-1) do
		x = FixedMul(x, ogx)
	end
	return x
end

--TBSlib.FixedPointPower(x, n)
TBSlib.FixedPointPower = function(x, n)
	return pow(x, n)
end

local function atan(x)
	local y = FRACUNIT + pow(x, 2)
	return asin(FixedDiv(x or FRACUNIT,FixedMul(y, FixedSqrt(y)) or FRACUNIT))
end

--TBSlib.clamp(x, min_x, max_x)
TBSlib.clamp = function(x, min_x, max_x)
    return min(max(x, min_x), max_x)
end

--TBSlib.sign(x)
TBSlib.sign = function(x)
	if x > 0 then
		return 1
	else
		return -1
	end
end

--TBSlib.signZ(x)
TBSlib.signZ = function(x)
	if x > 0 then
		return 1
	elseif x == 0 then
		return 0
	else
		return -1
	end
end

--TBSlib.atan(x)
TBSlib.atan = function(x)
    return atan(x)  
end

--TBSlib.atan2(y, x)
TBSlib.atan2 = function(y,x)
    return atan(FixedDiv(y,x))  
end

--TBSlib.sign(x)
TBSlib.projectJRPAngles = function(jaw, roll, pitch)
	local directionXY = TBSlib.atan2(sin(jaw), cos(jaw)) - roll
	
	local zAngle = TBSlib.atan2(sin(pitch), cos(pitch))
	
	return directionXY, zAngle
end

--TBSlib.atan2f(y, x)
TBSlib.atan2f = function(y,x)
    return atan(FixedDiv(y, x))  
end

--TBSlib.toHex(str)
TBSlib.toHex = function(str)
	return string.format('%x', ''..str)
end

--TBSlib.fromHex(str)
TBSlib.fromHex = function(str)
	return tonumber('0x'..str)
end

--TBSlib.getBoolLine(str)
TBSlib.getBoolLine = function(str)
	local t = {}
	for i = 1, string.len(str) do
		table.insert(t, string.sub(str, i,i))
	end
	return t
end

// shoots a ray, in direction of choosing. 
--TBSlib.shootRay(vector3 origin, angle_t angleh, angle_t anglev)
TBSlib.ray = function(origin, angleh, anglev)
	if not (origin and origin == {} and origin.x and origin.y and origin.z and angleh and anglev) then return end

	local ray = P_SpawnMobj(origin.x, origin.y, origin.z, MT_RAY)
	P_TeleportMove(origin.x, origin.y, origin.z+P_ReturnThrustY(ray, anglev, INT8_MAX))
	P_InstaThrust(ray, angleh, INT8_MAX)
	ray.fuse = 2

	return {ray.x, ray.y, ray.z}
end

// Lerp
--TBSlib.lerp(t, a, b)
TBSlib.lerp = function(t, a, b)
	return a + FixedMul(b - a, t)
end

//TBS's Fixedpoint interpretation of Roblox's lua doc interpretation's of Bezier's curves.
--TBSlib.quadBezier(t, p0, p1, p2)
TBSlib.quadBezier = function(t, p0, p1, p2)
	return FixedMul(pow(FRACUNIT - t, 2), p0) + FixedMul(FixedMul(FRACUNIT - t, t), p1)<<1 + FixedMul(pow(t, 2), p2)
end

rawset(_G, "TBSlib", TBSlib)
