/* 
		Team Blue Spring's Series of Libaries. 
		Vector Library - lib_vector.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

local libVec = {
	stringversion = '1.1',
	iteration = 2,
}

//Vector libary

local meta_vector_t
meta_vector_t = {
   __call = function(self, vec, x, y, z)
      vec = {}
      vec.type = self.type 
      vec.x = x or self.x
      vec.y = y or self.y
      if z ~= nil then
        vec.type = "3D"
        vec.z = z or self.z
      end
      return setmetatable(vec, meta_vector_t)
   end,
   __add = function(self, next_vector)
      local val = {}
      val.x = self.x + next_vector.x 
      val.y = self.y + next_vector.y
      if self.type == "2D" or next_vector.type == "2D" then return setmetatable(val, meta_vector_t) end
      val.type = "3D"      
      val.z = self.z + next_vector.z
      return setmetatable(val, meta_vector_t)
   end,
   __sub = function(self, next_vector)
       local val = {}
      val.x = self.x - next_vector.x 
      val.y = self.y - next_vector.y
      if self.type == "2D" or next_vector.type == "2D" then return setmetatable(val, meta_vector_t) end
      val.type = "3D"      
      val.z = self.z - next_vector.z
      return setmetatable(val, meta_vector_t)  
   end,
   __mul = function(self, next_vector)
       local val = {}
      val.x = FixedMul(self.x, next_vector.x) 
      val.y = FixedMul(self.y, next_vector.y)
      if self.type == "2D" or next_vector.type == "2D" then return setmetatable(val, meta_vector_t) end
      val.type = "3D"      
      val.z = FixedMul(self.z, next_vector.z)
      return setmetatable(val, meta_vector_t)  
   end,
   __div = function(self, next_vector)
       local val = {}
      val.x = FixedDiv(self.x, next_vector.x) 
      val.y = FixedDiv(self.y, next_vector.y)
      if self.type == "2D" or next_vector.type == "2D" then return setmetatable(val, meta_vector_t) end
      val.type = "3D"      
      val.z = FixedDiv(self.z, next_vector.z)
      return setmetatable(val, meta_vector_t)  
   end,
   __mod = function(self, next_vector)
       local val = {}
      val.x = self.x % next_vector.x 
      val.y = self.y % next_vector.y
      if self.type == "2D" or next_vector.type == "2D" then return setmetatable(val, meta_vector_t) end
      val.type = "3D"      
      val.z = self.z % next_vector.z
      return setmetatable(val, meta_vector_t)  
   end,
	__tostring = function(self)
		return self.type+" "+self.x/FRACUNIT+"."+self.x % FRACUNIT
						+" "+self.y/FRACUNIT+"."+self.y % FRACUNIT
						+" "+self.z/FRACUNIT+"."+self.z % FRACUNIT
	end
}

local vector_t = setmetatable({type = "2D", x = 0, y = 0, z = 0}, meta_vector_t)

local vec1 = vector_t(vec1, 4*FRACUNIT, 7*FRACUNIT, 3*FRACUNIT)
local vec2 = vector_t(vec2, 3*FRACUNIT, 2*FRACUNIT, FRACUNIT)

print(vec1+vec2, vec1-vec2, vec1*vec2, vec1/vec2)


// Example:
// Vector 1(2D or 3D) + Vector 2(2D or 3D) = result Vector

-- tbsVec.Add(v1, v2)

libVec.Add = function(v1, v2)
	return {v1[1] + v2[1], v1[2] + v2[2], (v1[3] or 0) + (v2[3] or 0)}
end

// Example:
// Vector 1(2D or 3D) - Vector 2(2D or 3D) = result Vector

-- tbsVec.Sub(v1, v2)

libVec.Sub = function(v1, v2)
	return {v1[1] - v2[1], v1[2] - v2[2], (v1[3] or 0) - (v2[3] or 0)}
end

// Example:
// Dist

-- tbsVec.Dist(v1, v2, boolean)

libVec.Dist = function(v1, v2, fx)
	if fx then
		local result = {FixedMul(v1[1], v1[1]) + FixedMul(v2[1], v2[1]),
		FixedMul(v1[2], v1[2]) + FixedMul(v2[2], v2[2]), 
		FixedMul((v1[3] or 0), (v1[3] or 0)) + FixedMul((v2[3] or 0), (v2[3] or 0))}	
	else
		local result = {v1[1] + v2[1], v1[2] + v2[2], (v1[3] or 0) + (v2[3] or 0)}		
	end
	
	return result
end

libVec.Rotate = function(v, fixedpoint, hangle, vangle)
	local vector = {v[1], v[2], (v[3] or 0)}
	
	vector[1] = fixedpoint and v[1]/FRACUNIT*cos(hangle) or v[1]*cos(hangle)
	vector[2] = fixedpoint and v[2]/FRACUNIT*sin(hangle) or v[2]*sin(hangle)
	
	if vangle then
		vector[3] = fixedpoint and v[3]/FRACUNIT*sin(vangle) or v[3]*sin(vangle)
	end
	
	return vector
end

libVec.objPush = function(mobj, v)
	if v[1] == nil or v[2] == nil then return end
	mobj.momx = v[1]
	mobj.momy = v[2]

	if v[3] == nil then return end	
	mobj.momz = v[3]
end

libVec.dotProduct = function(point1, point2)
	return FixedMul(point1.x, point2.x) + FixedMul(point1.y, point2.y) + FixedMul(point1.z, point2.z)
end

libVec.magnitude = function(vec)
	return FixedSqrt(FixedMul(vec.x, vec.x) + FixedMul(vec.y, vec.y) + FixedMul(vec.z, vec.z))
end

libVec.setObjOrg = function(mobj, v)
	P_TeleportMove(mobj, mobj.x+v[1], mobj.y+v[2], mobj.z+v[3])
end

rawset(_G, "tbsVec", libVec)
