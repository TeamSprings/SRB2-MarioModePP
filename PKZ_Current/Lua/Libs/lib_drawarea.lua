--[[
		Team Blue Spring's Series of Libaries.
		General Library - lib_drawarea.lua

		Description: Forces window based on parameters

Contributors: Skydusk
@Team Blue Spring 2024
]]

---@class window
---@field v videolib?
---@field x fixed_t
---@field y fixed_t
---@field width fixed_t
---@field height fixed_t
---@field flags number
---@field mount function
---@field transform function
---@field draw function
---@field drawScaled function
---@field drawStretched function

---@return window
local function new(x, y, width, height, flags)
    if not (v and x ~= nil and y ~= nil and width and height) then return end

    local win = {
        x = x,
        y = y,

        width = abs(width),
        height = abs(height),

        flags = flags,
    }

    ---@param self      window
    ---@param v         videolib        
    function win:mount(self, v)
        self.v = v
        return v and true or false
    end

    ---@param self      window
    ---@param x         fixed_t
    ---@param y         fixed_t
    ---@param width     fixed_t
    ---@param height    fixed_t    
    function win:transform(self, x, y, width, height)
        if x ~= nil then
            self.x = x
        end

        if y ~= nil then
            self.y = y
        end

        if width then
            self.width = abs(width)
        end
        
        if height then
            self.height = abs(height)
        end
    end

    ---@param self      window
    ---@param x         number
    ---@param y         number
    ---@param patch     patch_t
    ---@param flags     number
    ---@param colormap  colormap
    function win:draw(self, x, y, patch, flags, colormap)
        x = $ * FRACUNIT ---@cast x fixed_t
        y = $ * FRACUNIT ---@cast y fixed_t

        ---@cast v videolib
        v.drawCropped(
            x,
            y,
            FRACUNIT,
            FRACUNIT,
            patch,
            flags,
            colormap,
            min(x - self.x, 0),
            min(y - self.y, 0),
            abs(max(x + patch.width - self.width, 0)),
            abs(max(y + patch.height - self.height, 0)))
    end

    ---@param self      window
    ---@param x         fixed_t
    ---@param y         fixed_t
    ---@param scale     fixed_t
    ---@param patch     patch_t
    ---@param flags     number
    ---@param colormap  colormap    
    function win:drawScaled(self, x, y, scale, patch, flags, colormap)
        ---@cast v videolib
        v.drawCropped(
            x,
            y,
            scale,
            scale,
            patch,
            flags,
            colormap,
            min(x - self.x, 0),
            min(y - self.y, 0),
            abs(max(x + patch.width * scale - self.width, 0)),
            abs(max(y + patch.height * scale - self.height, 0)))
    end

    ---@param self      window
    ---@param x         fixed_t
    ---@param y         fixed_t
    ---@param width     fixed_t
    ---@param height    fixed_t
    ---@param patch     patch_t
    ---@param flags     number
    ---@param colormap  colormap    
    function win:drawStretched(self, x, y, width, height, patch, flags, colormap)
        ---@cast v videolib
        v.drawCropped(
            x,
            y,
            width,
            height,
            patch,
            flags,
            colormap,
            min(x - self.x, 0),
            min(y - self.y, 0),
            abs(max(x + patch.width * width - self.width, 0)),
            abs(max(y + patch.height * height - self.height, 0)))
    end

    ---@cast win window
    return win
end

return {new = new}