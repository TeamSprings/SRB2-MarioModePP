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
		result:insert(line)
	end	
	
	return result
end

--TBSlib.parseLine(line)
TBSlib.parseLine = function(line)
	local result = {}
	
	for w in line:gmatch("%S+") do
		result:insert(w)
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
			if type(v) == "table" then
				if v then
					str = $..white_space..k.." = "
					scope = $+1
					str, scope = write_series(v, str, scope)
				else
					continue
				end
			else
				if v then
					str = $..white_space..k.." = "..v..",\n"
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

TBSlib.serializeIO = function(tab, filepath)
	local file = io.openlocal(filepath, "w")
	local serialization = ""
	serialization = write_series(tab, serialization)
	
	file:write(serialization)
	file:close()
end

local function read_series(str)
	local set_t = {table_sel = {},}
	local table_sel = {}
	local brackets = -1
	
	str = str:gsub("\n", "")
	str = str:gsub("\t", "")	
	
	local split = TBSlib.splitStr(str, ",")
	local start_v
	
	for i = 1, #split do
		local val = split[i]
		local _, add_count = val:gsub("{")
		local _, min_count = val:gsub("}")
		brackets = $+add_count-min_count
		
		if brackets > 0 then
			if not start_v then
				start_v = i
			end
			
			if i == #split then
				print("Syntax Error! Var Num: "..i)
				return "ERROR"
			end
		elseif brackets < 0 then
			if i == #split then
				break
			end
		
			print("Syntax Error! Var Num: "..i)
			return "ERROR"
		else
			if start_v then
				local found_table = ""
				for y = start_v, i do
					found_table = (found_table and ($.." ") or $)..split[y]
				end
				start_v = nil
				set_t:insert(found_table)
				table:insert(set_t.table_sel, #set_t)
			else
				set_t:insert(val)
			end
		end
	end
	
	local tb = set_t.table_sel
	
	if tb then
		for i = 1, #tb do
			local str_table = set_t[tb[i]]
			if #str_table > 2 then
				set_t[tb[i]] = read_series(str_table)
			else
				continue
			end
		end
	end
	
	return set_t
end

local function parse_stringtable(str_table)
	local table_x = {}
	local subtables = {}
	if str_table.table_sel then
		for k, v in ipairs(str_table.table_sel) do
			subtables[v] = k
		end
	end
	
	for i = 1, #str_table do
		local val = str_table[i]
		if tonumber(val[3]) ~= nil then
			table_x[val[1]] = tonumber(val[3])
		elseif subtables[i]	then
			local th = {}
			for i = 2, #val-1 do
				th:insert(val[i])
			end
		
			table_x[string.gsub(val[1], "{", "")] = parse_stringtable(th)
		else
			table_x[val[1]] = val[3]
		end
	end
	return table_x
end

TBSlib.deserializeIO = function(tab, filepath)
	local file = io.openlocal(filepath, "r")
	local n_table = {}
	local text_t
	
	if file then
		text_t = file:read("*a")
		file:close()
	end
	
	if text_t then
		local str_table = read_series(str)
		n_table = parse_stringtable(str_table)
	end
	
	return n_table
end

TBSlib.serializeIO({
	fuck = {1, 4, 8},
	value = 1,
	2,4,5,
}, "client/test.txt")

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
