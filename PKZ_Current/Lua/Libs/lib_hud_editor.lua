if not TBS_Polygon then return end
if not TBS_Menu then return end

local editor_toggle = false

local layers = {}
local selection = 0

local function editor(v)
	v.fadeScreen(0xFF00, 15)

	if TBS_Menu.keypresses["insert"] then
		layers:insert(layers, {
		x = TBS_Menu.mouse_x,
		y = TBS_Menu.mouse_y,
		scale = FRACUNIT,
		patch = "NONE",
		flags = 0,
		colormap = nil,
		})
	end

	for i = 1, #layers do
		local layer = layers[i]
		if not layer then continue end

		v.drawString(250, 50+i*10, i..": x "..layer.x.." y "..layer.y)
		if TBS_Menu.draw_ClickableImage(v, layer.x, layer.y, layer.scale, layer.patch, layer.flags, layer.colormap) and not selection then
			layer.x = TBS_Menu.mouse_x
			layer.y = TBS_Menu.mouse_y
			selection = i
		end
	end

	if selection and TBS_Menu.keypresses["delete"] then
		layers:remove(selection)
		layers:sort()
		selection = 0
	end

	TBSlib.drawTextInt(v, 'MA14LT', 0, 40, "TEST", 0, v.getColormap(TC_DEFAULT, xMM_registry.current_rainbowfontcolor), "left", 0, 1, "HUD")
end

table.insert(TBS_Menu.menutypes, {
	name = "HUD EDITOR",
	[1] = { -- Main Menu
		style = function(v) editor(v) end,
		{name = "dummy", z = 95, flags = TBS_MFLAG.HEADER;};
	};
})

