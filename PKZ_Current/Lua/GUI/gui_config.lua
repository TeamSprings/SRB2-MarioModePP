--[[
		Pipe Kingdom Zone's Config Menu - gui_config.lua

Description:
Cheats and all config menu stuff

Contributors: Skydusk
@Team Blue Spring 2024
--]]

local limits =  {
	limitz = {69, 164, 95},
	textlimitz = {61, 173, 112},
	transition_tics = TICRATE/2,

	--music = "O_PKZMENUMUSIC"
	--sounds = {
	--			select	 	= "sfx_pkzmen3";
	--			scroll 		= "sfx_pkzmen3";
	--			accept 		= "sfx_pkzmen3";
	--			deny 		= "sfx_pkzmen3";
	--}
}

table.insert(TBS_Menu.styles, limits)

--
--	MINI MENUS
--

local coincollection = {
	{name = "Pipe Kingdom 1", coins = {1, 2, 3, 4, 5}},
	{name = "Pipe Kingdom 2", coins = {7, 8, 9, 10, 11}},
	{name = "Pipe Kingdom 3"},
	{name = "Shop", coins = {12, 13, 14, 15, 16}},
	{name = "Extras", coins = {17, 18, 19, 20, 21}},
}

local settings = {
	{name = "HUD style", cvar = CV_FindVar("pkz_hudstyles")},
	{name = "Debug mode", cvar = CV_FindVar("pkz_debug")},
	{name = "Debug mode", cvar = CV_FindVar("pkz_debug")},
	{name = "Debug mode", cvar = CV_FindVar("pkz_debug")},
	{name = "Debug mode", cvar = CV_FindVar("pkz_debug")},
}


--
--	HANDLER
--

local base_menu_select = 1
local settings_select = 1
local coins_select = 1
local smoothing = 0

local function Main_Menu_Handling(key)
	if key.num == ctrl_inputs.left[1] or key.num == ctrl_inputs.turl[1] then
		base_menu_select = $ - 1
		if base_menu_select < 1 then
			base_menu_select = 3
		end
		return true
	end

	if key.num == ctrl_inputs.right[1] or key.num == ctrl_inputs.turr[1] then
		base_menu_select = $ + 1
		if base_menu_select > 3 then
			base_menu_select = 1
		end
		return true
	end
end

local function Coins_Handling(key)
	if key.num == ctrl_inputs.down[1] then
		if coins_select >= #coincollection then
			coins_select = #coincollection
			TBS_Menu.selection = 2
		else
			coins_select = $ + 1
			smoothing = FRACUNIT
		end
		return true
	end

	if key.num == ctrl_inputs.up[1] then
		if coins_select <= 1 then
			coins_select = 1
			TBS_Menu.selection = 2
		else
			coins_select = $ - 1
			smoothing = FRACUNIT
		end
		return true
	end

	return false
end

local function Settings_Handling(key)
	if key.num == ctrl_inputs.down[1] then
		if settings_select >= #settings then
			settings_select = #settings
			TBS_Menu.selection = 2
		else
			settings_select = $ + 1
			smoothing = FRACUNIT
		end
		return true
	end

	if key.num == ctrl_inputs.up[1] then
		if settings_select <= 1 then
			settings_select = 1
			TBS_Menu.selection = 2
		else
			settings_select = $ - 1
			smoothing = FRACUNIT
		end
		return true
	end

	if settings[settings_select] then
		local current = settings[settings_select]

		-- Cvar
		if current.cvar then
			if key.num == ctrl_inputs.left[1] then
				CV_AddValue(current.cvar, -1)
				return true
			end

			if key.num == ctrl_inputs.right[1] then
				CV_AddValue(current.cvar, 1)
				return true
			end

		end
	end

	return false
end

--
--	ELEMENTS
--

local function Menu_Element_HZip_Drawer(v, x, y, width, height, cur, min_i, max_i)
	local filled = width - ease.linear(((cur - min_i) * FRACUNIT) / (max_i - min_i), width, 0)
	local unfilled = width - filled

	v.drawFill(x, y, filled, height, 1)
	v.drawFill(x + filled, y, unfilled, height, 14)
end

local function Menu_Element_VZip_Drawer(v, x, y, width, height, cur, min_i, max_i)
	local filled = height - ease.linear(((cur - min_i) * FRACUNIT) / (max_i - min_i), height, 0)
	local unfilled = height - filled

	v.drawFill(x, y, width, filled, 1)
	v.drawFill(x, y + filled, width, unfilled, 14)
end

local function Main_Menu_Selector_Drawer(v, item, selected)
	local y = 56
	local dist = 75
	local colormap

	if selected then
		colormap = v.getColormap(TC_DEFAULT, 0, 'WHITETOYELLOWMENUMM')
	end

	v.draw(160-dist, y, v.cachePatch("NMARIOMENUSTART"), 0, base_menu_select == 1 and colormap or nil)
	v.draw(160, y, v.cachePatch("NMARIOMENUGENB"), 0,		base_menu_select == 2 and colormap or nil)
	v.draw(160+dist, y, v.cachePatch("NMARIOMENUGENB"), 0,	base_menu_select == 3 and colormap or nil)
end

local function CoinMenu_Drawer(v, item, selected)
	local y = 40
	local max_y = 100 + y
	local colormap

	Menu_Element_VZip_Drawer(v, 300, y, 2, 100, coins_select, 1, #coincollection)

	local unselected_setting = v.cachePatch("NMARIOMENUSETE")
	local selected_setting = v.cachePatch("NMARIOMENUSETS")
	local start_i =  max(coins_select-2, 1)
	local end_i = max(coins_select-(#coincollection-2), 0)

	for i = start_i-end_i, #coincollection do
		if i > start_i+4 then break end

		if selected and i == coins_select then
			v.draw(160, y, selected_setting)
			TBSlib.fontdrawerInt(v, 'MA16LT', 45, y+3, string.upper(coincollection[i].name), 0, v.getColormap(TC_DEFAULT, 0), 'left', 0, 0, 0)
		else
			v.draw(160, y, unselected_setting)
			TBSlib.fontdrawerInt(v, 'MA16LT', 45, y+3, string.upper(coincollection[i].name), 0, v.getColormap(TC_DEFAULT, 0), 'left', 0, 0, 0)
		end

		y = $ + 21
	end
end

local function Settings_Drawer(v, item, selected)
	local y = 40
	local max_y = 100 + y
	local colormap

	Menu_Element_VZip_Drawer(v, 300, y, 2, 100, settings_select, 1, #settings)

	local unselected_setting = v.cachePatch("NMARIOMENUSETT")
	local selected_setting = v.cachePatch("NMARIOMENUSETS")
	local start_i =  max(settings_select-2, 1)
	local end_i = max(settings_select-(#settings-2), 0)

	--y = $ - ((21 * smoothing) / FRACUNIT) -- smoothing
	for i = start_i-end_i, #settings do
		if i > start_i+4 then break end

		if selected and i == settings_select then
			v.draw(160, y, selected_setting)
			TBSlib.fontdrawerInt(v, 'MA16LT', 45, y+3, string.upper(settings[i].name), 0, v.getColormap(TC_DEFAULT, 0), 'left', 0, 0, 0)
			if settings[i].cvar then
				TBSlib.fontdrawerInt(v, 'MA16LT', 225, y+3, string.upper(settings[i].cvar.string), 0, v.getColormap(TC_DEFAULT, 0), 'center', 0, 0, 0)
			end
		else
			v.draw(160, y, unselected_setting)
			TBSlib.fontdrawerInt(v, 'MA16LT', 45, y+3, string.upper(settings[i].name), 0, v.getColormap(TC_DEFAULT, 0), 'left', 0, 0, 0)
			if settings[i].cvar then
				TBSlib.fontdrawerInt(v, 'MA16LT', 225, y+3, string.upper(settings[i].cvar.string), 0, v.getColormap(TC_DEFAULT, 0), 'center', 0, 0, 0)
			end
		end

		y = $ + 21
	end
end

local function Exit_Drawer(v, item, selected)
	local y = 155
	local colormap

	if selected then
		colormap = v.getColormap(TC_DEFAULT, 0, 'WHITETOYELLOWMENUMM')
	end

	v.draw(160, y, v.cachePatch("NMARIOMENUGEXIT"), V_SNAPTOBOTTOM, colormap)
end

local function Navigator_Drawer(v)
	return 0
end


--
--	MAIN DRAWER
--


--MENUBIGFONT
local function Menu_Drawer(v)
	-- >> Setup values

	local width, widthf = v.width()
	local height, heightf = v.height()

	-- smoothing for stuff
	if smoothing then
		smoothing = smoothing/32
	end

	-- >> Shared Background

	-- scrolling bg
	v.drawFill(0, 27, width, 2, 141|V_60TRANS|V_SNAPTOLEFT|V_SNAPTOTOP)
	v.drawFill(0, 29, width, 2, 142|V_60TRANS|V_SNAPTOLEFT|V_SNAPTOTOP)
	v.drawFill(0, 31, width, height-31, 143|V_60TRANS|V_SNAPTOLEFT|V_SNAPTOTOP)

	-- actual scrolling element
	local original_p = -(leveltime % 512)
	local scrolling_x = original_p

	while(width > scrolling_x) do
		local scrolling_y = original_p

		while(height > scrolling_y) do
			v.drawScaled(scrolling_x * FRACUNIT, scrolling_y * FRACUNIT, FRACUNIT, v.cachePatch("NMARIOMENUBG"), V_SNAPTOLEFT|V_SNAPTOTOP|V_50TRANS)
			scrolling_y = $+512
		end

		scrolling_x = $+512
	end

	-- top
	v.drawFill(0, 0, width, 27, 26|V_SNAPTOLEFT|V_SNAPTOTOP)

	-- buttom
	local base_y = 200-16
	v.drawFill(0, base_y, width, 16, 26|V_SNAPTOLEFT|V_SNAPTOBOTTOM)
	v.drawFill(0, base_y+1, width, 2, 213|V_SNAPTOLEFT|V_SNAPTOBOTTOM)
	v.drawFill(0, base_y+3, width, 2, 149|V_SNAPTOLEFT|V_SNAPTOBOTTOM)


	-- Menu Items
	local index_submenu = TBS_Menu.submenu
	local selected = TBS_Menu.selection

	local Menu = TBS_Menu.menutypes[TBS_Menu.menu]
	local Submenu = Menu[index_submenu]

	for k, item in ipairs(Submenu) do
		if item.func_draw then
			item.func_draw(v, item, selected == k)
		end
	end

	TBSlib.fontdrawerInt(v, 'MA14LT', 160, 18, Submenu.name, V_SNAPTOTOP, v.getColormap(TC_DEFAULT, 0, 'MENUBIGFONT'), 'center', 0, 0, 0)

	return 0
end

--
--	MENU CONTENTS
--

table.insert(TBS_Menu.menutypes, {
	name = "MARIO MODE++",

	[1] = {
		name = "MENU",
		style = Menu_Drawer,
		navigator = Navigator_Drawer,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			if base_menu_select == 1 then
				G_SetCustomExitVars(PKZ_Table.hub_warp, 1)
				G_ExitLevel()
				TBS_Menu:toggleMenu(false)
			else
				TBS_Menu.select_sub_menu_structure(base_menu_select, menut)
			end
		end, func_draw = Main_Menu_Selector_Drawer, special_input = Main_Menu_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			TBS_Menu:toggleMenu(false)
		end, func_draw = Exit_Drawer},
	};

	[2] = {
		name = "COINS",
		init = function()
			local list_ids = PKZ_Table.listoflevelIDs
			local tokenlist = PKZ_Table.levellist

			coincollection = {}

			for i = 1, #list_ids do
				local id = list_ids[i]
				coincollection[i] = {
					name = tostring(mapheaderinfo[id].lvlttl)..' '..tostring(mapheaderinfo[id].actnum),
					type = tokenlist[id].new_coin,
					coins = tokenlist[id].coins,
				}
			end
		end,
		style = Menu_Drawer,
		navigator = Navigator_Drawer,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			return
		end, func_draw = CoinMenu_Drawer, special_input = Coins_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			TBS_Menu.select_sub_menu_structure(1, menut)
		end, func_draw = Exit_Drawer},
	};

	[3] = {
		name = "SETTINGS",
		style = Menu_Drawer,
		navigator = Navigator_Drawer,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			return
		end, func_draw = Settings_Drawer, special_input = Settings_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			TBS_Menu.select_sub_menu_structure(1, menut)
		end, func_draw = Exit_Drawer},
	};
})


