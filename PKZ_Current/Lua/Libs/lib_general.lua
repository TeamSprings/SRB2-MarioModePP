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

TBSlib.ASCII = {}
TBSlib.registeredFont = {}
for i = 0, 128 do
	TBSlib.ASCII[i] = string.char(i) or "NONE"
end

TBSlib.registerFont = function(v, font)
	TBSlib.registeredFont[font] = {}
	for byte, char in ipairs(TBSlib.ASCII) do
		local cache = TBSlib.registeredFont[font]
		
		local char_check = font..char
		if not v.patchExists(char_check) then
			local byte_check = font..byte

			if v.patchExists(byte_check) then
				cache[char] = v.cachePatch(byte_check)
			else
				cache[char] = v.cachePatch(font..'NONE')
			end
		else
			cache[char] = v.cachePatch(char_check)
		end
	end
end

--TBSlib.cacheFont(d, patch, str, font, val, padding, i)
TBSlib.cacheFont = function(d, patch, str, font, val, padding, i)
	if not TBSlib.registeredFont[font] then
		TBSlib.registerFont(d, font)
	end

	local symbol = TBSlib.registeredFont[font][str:sub(i, i)]
	return {patch = symbol, width = symbol.width+padding}
end

--TBSlib.fontlenghtcal(d, patch, str, font, val, padding, i)
TBSlib.fontlenghtcal = function(d, patch, str, font, val, padding, i)
	if not TBSlib.registeredFont[font] then
		TBSlib.registerFont(d, font)
	end

	return TBSlib.registeredFont[font][str:sub(i, i)].width+padding
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

--TBSlib.getBoolLineNum(str)
TBSlib.getBoolLineNum = function(str)
	local t = {}
	for i = 1, string.len(str) do
		table.insert(t, tonumber(string.sub(str, i,i)))
	end
	return t
end

--TBSlib.splitStr(str, sep)
TBSlib.splitStr = function(str, sep)
	if sep == nil then return str end

	local result = {}
	for split in str:gmatch("([^"..sep.."]+)") do
		result:insert(split)
	end
	
	return result
end

--TBSlib.charStr(str, int)
TBSlib.charStr = function(str, int)
	return str:sub(int, int)
end

TBSlib.toBitsString = function(str, enum)
	if not str then return 0 end
	local bits = 0

	for bit in str:gmatch("([^|]+)") do
		if not enum[bit] then continue end
		bits = $|enum[bit]
	end

	return bits
end

--TBSlib.parsePerLine(str)
TBSlib.parsePerLine = function(str)
	local result = {}
	
	for line in str:gmatch("[^\r\n]+") do
		if not line then continue end	
		table.insert(result, line)
	end	
	
	return result
end

--TBSlib.parseLine(line)
TBSlib.parseLine = function(line)
	local result = {}
	
	for w in line:gmatch("%S+") do
		if not w then continue end
		table.insert(result, w)
	end	
	
	return result
end

TBSlib.parse = function(str)
	local result = {}
	local i = 1
	
	for line in str:gmatch("[^\r\n]+") do
		if not line then continue end
		result[i] = {}
		
		for w in line:gmatch("%S+") do
			if not w then continue end
			table.insert(result[i], w)
		end
		i = $+1
	end	
	
	return result
end

local write_series

local function write_series(current_tab, str, scope)	
	if str and current_tab then
		str = $.."{".."\n"
		scope = $ or 1
		local white_space = string.rep("\t", scope)	
	
		for k, v in pairs(current_tab) do
			local key = type(k) == "number" and "["..k.."]" or k
		
			if type(v) == "table" then
				if v then
					str = $..white_space..key.." = "
					scope = $+1
					str, scope = write_series(v, str, scope)
				else
					continue
				end
			else
				if v ~= nil then
					if type(v) == "boolean" then
						str = $..white_space..key.." = "..(v and "true" or "false")..",\n"
					elseif type(v) == "number" or type(v) == "string" then
						str = $..white_space..key.." = "..v..",\n"					
					else
						continue
					end				
				else
					continue
				end
			end
		end
		
		scope = $-1
		white_space = string.rep("\t", scope)
		str = $..white_space.."},".."\n"
		return str, scope
	end
end

TBSlib.serializeIO = function(tab, filepath, extra)
	local file = io.openlocal(filepath, "w")
	local serialization = ""..(extra and extra or "")
	serialization = write_series(tab, serialization)
	
	file:write(serialization)
	file:close()
end

TBSlib.deserializeIO = function(filepath)
	local file = io.openlocal(filepath, "r")
	local n_table = {}
	local s_table = {}
	
	if file then
		file:seek("set")
		local cur_pos = 0
		for line in file:lines() do 
			cur_pos = $+1
			if cur_pos == 1 then continue end
			
			local current = n_table
			if s_table then
				for y = 1, #s_table do
					current = current[s_table[y]]
				end
			end
			
			local parse = TBSlib.parseLine(line)
				
			local index = parse[1]
			if index:find("%[") and index:find("%]") then
				index = index:gsub("%[", "")
				index = index:gsub("%]", "")
				index = tonumber(index)
			end
				
			if line:find("{") then
				current[index] = {}
				table.insert(s_table, index)
			elseif line:find("}") then
				if not s_table then
					break
				end
				table.remove(s_table)
			else
				local val = string.gsub(parse[3], ",", "")
				if type(tonumber(val)) == "number" then
					current[index] = tonumber(val)
				elseif val == "true" then
					current[index] = true				
				elseif val == "false" then
					current[index] = false
				else
					current[index] = val						
				end
			end
		end
		file:close()
	end
	
	return n_table
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

local numbering_system = {
	["0"] = 0, ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, 
	["A"] = 10, ["B"] = 11, ["C"] = 12, ["D"] = 13, ["E"] = 14, ["F"] = 15,	["G"] = 16,	["H"] = 17,	["I"] = 18,	
	["J"] = 19, ["K"] = 20, ["L"] = 21, ["M"] = 22, ["N"] = 23, ["O"] = 24,	["P"] = 25,	["Q"] = 26,	["R"] = 27,
	["S"] = 28, ["T"] = 29, ["U"] = 30, ["V"] = 31, ["W"] = 32, ["X"] = 33,	["Y"] = 34,	["Z"] = 35,	
}

--TBSlib.extMapToInt(str)
TBSlib.extMapToInt = function(str)
	local act_str = str:gsub("MAP", "")
	local dom_num, sub_num = 0, 0

	local set_dom = numbering_system[TBSlib.charStr(str, 4)]
		
	if set_dom >= 10 then
		dom_num = ((set_dom or 10)-10)*36
		sub_num = numbering_system[TBSlib.charStr(str, 5)] or 0
	else
		dom_num = (set_dom*10) or 0
		sub_num = numbering_system[TBSlib.charStr(str, 5)] or 0			
	end

	return dom_num + sub_num
end

--TBSlib.scaleAnimator(a, data_set)
/*
Example dataset:

local MushroomAnimation = {
	[0] = {offscale_x = 0, offscale_y = 0, tics = 4, nexts = 1},
	[1] = {offscale_x = 0, offscale_y = 0, tics = 3, nexts = 2},
	[2] = {offscale_x = -(FRACUNIT >> 3), offscale_y = (FRACUNIT >> 4), tics = 4, nexts = 3},
	[3] = {offscale_x = (FRACUNIT >> 3), offscale_y = -(FRACUNIT >> 4), tics = 3, nexts = 0},	
}
*/

TBSlib.registerPatchRange = function(v, patch, start, ending)
	local array = {}
	for i = start, ending do
		if v.patchExists(patch..i) then
			array[i] = v.cachePatch(patch..i)
		end
	end
	return array
end

TBSlib.pickPatchRange = function(v, range, start, index)
	return range[max(min(index, #range), start)]
end


TBSlib.scaleAnimator = function(a, data_set)
	if not a.animator_data then
		a.animator_data = {tics = 0, state = 0}
	end
	local data = data_set
	local cur_state = data[a.animator_data.state]
	local next_state = data[cur_state.nexts]
	local progress = (FRACUNIT/cur_state.tics)*a.animator_data.tics
	
	a.spritexscale = FRACUNIT+ease.outsine(progress, cur_state.offscale_x, next_state.offscale_x)
	a.spriteyscale = FRACUNIT+ease.outsine(progress, cur_state.offscale_y, next_state.offscale_y)

	a.animator_data.tics = $+1
	if a.animator_data.tics == cur_state.tics then
		a.animator_data.state = cur_state.nexts
		a.animator_data.tics = 0
	end
end

--TBSlib.resetAnimator(a)
TBSlib.resetAnimator = function(a)
	a.animator_data = {tics = 0, state = 0}
	a.spritexscale = FRACUNIT
	a.spriteyscale = FRACUNIT
end

local function M_ReachDestination(curr_val, dest_val, step)
    local final_val = curr_val
	if final_val < dest_val then
        final_val = $ + step
        if final_val+step > dest_val then
            final_val = dest_val
        end
    elseif final_val > dest_val then
        final_val = $ - step
        if final_val-step < dest_val then
            final_val = dest_val
        end
    end
    return final_val
end

--TBSlib.reachNumber(curr_val, dest_val, step)
TBSlib.reachNumber = function(curr_val, dest_val, step)
    return M_ReachDestination(curr_val, dest_val, step)
end

--TBSlib.reachAngle(curr_val, dest_val, step)
TBSlib.reachAngle = function(curr_val, dest_val, step)
	local dif = dest_val - curr_val
	if dif > ANGLE_180 and dif <= ANGLE_MAX then
		dif = $ - ANGLE_MAX
	end

    return curr_val + M_ReachDestination(0, dif, step)
end

--TBSlib.removeMobjArray(array)
TBSlib.removeMobjArray = function(array)
	for _,mo in ipairs(array) do
		P_RemoveMobj(mo)
	end
end

rawset(_G, "TBSlib", TBSlib)
