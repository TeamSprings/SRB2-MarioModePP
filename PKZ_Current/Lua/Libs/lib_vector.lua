--[[
		Team Blue Spring's Series of Libaries.
		Vector Library - lib_vector.lua

	NOT TESTED!

Contributors: Skydusk
@Team Blue Spring 2024
--]]

local libVec = {
	stringversion = '1.1',
	iteration = 2,
}

local meta_vector_t

--Vector libary

function libVec.len(vector)
	if vector1.type == "vector" then return end
	return R_PointToDist2(0, 0, R_PointToDist2(0, 0, vector.x, vector.y), vector.z)
end

function libVec.dist(vector1, vector2)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	return FixedHypot(R_PointToDist2(vector1.x, vector1.y, vector2.x, vector2.y), abs(vector2.z - vector1.z))
end

function libVec.angle(vector1, vector2)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	return R_PointToAngle2(0, vector1.z, R_PointToDist2(vector1.x, vector2.x, vector1.y, vector1.y), vector2.z)
end

function libVec.lerp(vector1, vector2, t)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	return setmetatable({
	x = ease.linear(t, vector1.x, vector2.x),
	y = ease.linear(t, vector1.y, vector2.y),
	z = ease.linear(t, vector1.z, vector2.z)
	},
	meta_vector_t)
end

function libVec.max(vector1, vector2)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	local len_1 = libVec.len(vector1)
	local len_2 = libVec.len(vector2)

	return len_1 > len_2 and vector1 or vector2
end

function libVec.min(vector1, vector2)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	local len_1 = libVec.len(vector1)
	local len_2 = libVec.len(vector2)

	return len_1 < len_2 and vector1 or vector2
end

function libVec.rotate(vector, yaw, roll, pitch)
	if vector.type ~= "vector" then return end
	local new_vector = {x = vector.x, y = vector.y, z = vector.z}

	new_vector.type = "vector"
	new_vector.x = FixedMul(FixedMul(vector.x, cos(yaw)), cos(pitch))
	new_vector.y = FixedMul(FixedMul(vector.y, sin(roll)), cos(pitch))
	new_vector.z = FixedMul(vector.z, sin(pitch))

	return setmetatable(new_vector, meta_vector_t)
end

function libVec.pushMobj(vector, mobj)
	mobj.momx = vector.x
	mobj.momy = vector.y
	mobj.momz = vector.z
end

libVec.dotProduct = function(vector1, vector2)
	if vector1.type ~= "vector" then return end
	if vector2.type ~= "vector" then return end
	return FixedMul(vector1.x, vector2.x) + FixedMul(vector1.y, vector2.y) + FixedMul(vector1.z, vector2.z)
end

-- 	Returns a normalized vector based on the current vector. The normalized vector has a magnitude of 1 and is in the same direction as the current vector. Returns a zero vector If the current vector is too small to be normalized.
libVec.magnitude = function(vector)
	if vector.type ~= "vector" then return end
	return FixedSqrt(FixedMul(vec.x, vec.x) + FixedMul(vec.y, vec.y) + FixedMul(vec.z, vec.z))
end

-- Offsets Mobj by vector size
libVec.offsetMobj = function(vector, mobj)
	if vector.type ~= "vector" then return end
	P_SetOrigin(mobj, mobj.x+vector.x, mobj.y+vector.y, mobj.z+vector.z)
end

local function biggestnum(num, num2)
	return num > num2 and num or num2
end

libVec.normalized = function(vector)
	if vector.type ~= "vector" then return end
	local biggest_direction = biggest(biggest(vector.x, vector.y), vector.z)
	return setmetatable({
	x = FixedDiv(vector.x, biggest_direction),
	y = FixedDiv(vector.y, biggest_direction),
	z = FixedDiv(vector.z, biggest_direction},
	meta_vector_t)
end

meta_vector_t = {
	__metatable = false,

	-- + operator
	__add = function(self, next_vector)
		local val = {}
		val.type = "vector"
		if type(next_vector) == "number" then
			val.x = self.x + next_vector
			val.y = self.y + next_vector
			val.z = self.z + next_vector
		elseif next_vector.type == "vector" then
			val.x = self.x + next_vector.x
			val.y = self.y + next_vector.y
			val.z = self.z + next_vector.z
		end
		return setmetatable(val, meta_vector_t)
	end,

	-- - operator
	__sub = function(self, next_vector)
		local val = {}
		val.type = "vector"
		if type(next_vector) == "number" then
			val.x = self.x - next_vector
			val.y = self.y - next_vector
			val.z = self.z - next_vector
		elseif next_vector.type == "vector" then
			val.x = self.x - next_vector.x
			val.y = self.y - next_vector.y
			val.z = self.z - next_vector.z
		end
		return setmetatable(val, meta_vector_t)
	end,

	-- * operator
	__mul = function(self, next_vector)
		local val = {}
		val.type = "vector"
		if type(next_vector) == "number" then
			val.x = FixedMul(self.x, next_vector)
			val.y = FixedMul(self.y, next_vector)
			val.z = FixedMul(self.z, next_vector)
		elseif next_vector.type == "vector" then
			val.x = FixedMul(self.x, next_vector.x)
			val.y = FixedMul(self.y, next_vector.y)
			val.z = FixedMul(self.z, next_vector.z)
		end
		return setmetatable(val, meta_vector_t)
	end,

	-- / operator
	__div = function(self, next_vector)
       local val = {}
		val.type = "vector"
		if type(next_vector) == "number" then
			val.x = FixedDiv(self.x, next_vector)
			val.y = FixedDiv(self.y, next_vector)
			val.z = FixedDiv(self.z, next_vector)
		elseif next_vector.type == "vector" then
			val.x = FixedDiv(self.x, next_vector.x)
			val.y = FixedDiv(self.y, next_vector.y)
			val.z = FixedDiv(self.z, next_vector.z)
		end
		return setmetatable(val, meta_vector_t)
   end,

	-- % operator
	__mod = function(self, next_vector)
       local val = {}
		val.type = "vector"
		if type(next_vector) == "number" then
			val.x = self.x % next_vector
			val.y = self.y % next_vector
			val.z = self.z % next_vector
		elseif next_vector.type == "vector" then
			val.x = self.x % next_vector.x
			val.y = self.y % next_vector.y
			val.z = self.z % next_vector.z
		end
		return setmetatable(val, meta_vector_t)
	end,

	-- Unary negation
	__unm = function(self)
		local val = {}
		val.type = "vector"
		val.x = -self.x
		val.y = -self.y
		val.z = -self.z
		return setmetatable(val, meta_vector_t)
	end,

	-- Equal check
	__eq = function(self, next_vector)
		if next_vector.type and (libVec.len(self) == libVec.len(next_vector)) then
			return true
		elseif type(next_vector) == "number" and libVec.len(self) == next_vector then
			return true
		else
			return false
		end
	end,

	-- less check (or Greater-than -- automatically flipped)
	__lt = function(self, next_vector)
		if next_vector.type and (libVec.len(self) < libVec.len(next_vector)) then
			return true
		elseif type(next_vector) == "number" and libVec.len(self) < next_vector then
			return true
		else
			return false
		end
	end,

	-- less or equal check (or Greater/equal-than -- automatically flipped)
	__le = function(self, next_vector)
		if next_vector.type and (libVec.len(self) <= libVec.len(next_vector)) then
			return true
		elseif type(next_vector) == "number" and libVec.len(self) <= next_vector then
			return true
		else
			return false
		end
	end,

	__tostring = function(self)
		return (self.z ~= nil and "2D " or "3D ")..(string.format("x: %f y: %f z: %f", self.x, self.y, self.z))
	end,

	__concat = function(self, str)
		return (string.format("x: %f y: %f z: %f", self.x, self.y, self.z))..str
	end,

	__len = function(self)
		return libVec.len(self)
	end,

	__index = function(self, index)
		if rawget(self, index) then
			return rawget(self, index)
		elseif libVec[index] then
			return libVec[index]
		else
			error("Wrong index")
		end
	end,
}

rawset(_G, "Vector", function(x, y, z)
	if type(x) == "table" then
		if x.x ~= nil and x.y ~= nil then
			return setmetatable({type = vector, x = x.x, y = x.y, z = x.z or 0}, meta_vector_t)
		else
			error("Invalid Vector, either x and y parameters missing or are invalid")
		end
	else
		if x ~= nil and y ~= nil then
			return setmetatable({type = vector, x = x, y = y, z = z}, meta_vector_t)
		else
			error("Invalid Vector, either x and y parameters missing or are invalid")
		end
	end
end)
rawset(_G, "VectorTBSlib", libVec)

--local vector_t = setmetatable({type = "2D", x = 0, y = 0, z = 0}, meta_vector_t)

--local vec1 = vector_t(vec1, 4*FRACUNIT, 7*FRACUNIT, 3*FRACUNIT)
--local vec2 = vector_t(vec2, 3*FRACUNIT, 2*FRACUNIT, FRACUNIT)

--print(vec1+vec2, vec1-vec2, vec1*vec2, vec1/vec2)
