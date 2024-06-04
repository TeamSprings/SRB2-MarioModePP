/*
		Pipe Kingdom Zone's Config Menu - gui_config.lua

Description:
Cheats and all config menu stuff

Contributors: Skydusk
@Team Blue Spring 2024
*/

local limits =  {
	limitz = {69, 164, 95},
	textlimitz = {61, 173, 112}

	//music = "O_PKZMENUMUSIC"
	//sounds = {
	//			select	 	= "sfx_pkzmen3";
	//			scroll 		= "sfx_pkzmen3";
	//			accept 		= "sfx_pkzmen3";
	//			deny 		= "sfx_pkzmen3";
	//}
}

table.insert(TBS_Menu.styles, limits)

//
//	STYLE
//

local base_menu_select = 1

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

	v.draw(160-dist, y, v.cachePatch("NMARIOMENUSTART"), 0, colormap)
	v.draw(160, y, v.cachePatch("NMARIOMENUGENB"), 0)
	v.draw(160+dist, y, v.cachePatch("NMARIOMENUGENB"), 0)
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

--MENUBIGFONT
local function Menu_Drawer(v)
	-- >> Setup values

	local width, widthf = v.width()
	local height, heightf = v.height()


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
			v.draw(scrolling_x, scrolling_y, v.cachePatch("NMARIOMENUBG"), V_SNAPTOLEFT|V_SNAPTOTOP|V_50TRANS)
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

	Menu_Element_VZip_Drawer(v, 300, 24, 2, 80, selected, 1, 2)

	TBSlib.fontdrawerInt(v, 'MA14LT', 160, 18, Submenu.name, V_SNAPTOTOP, v.getColormap(TC_DEFAULT, 0, 'MENUBIGFONT'), 'center', 0, 0, 0)

	return 0
end

//
//	MENU CONTENTS
//

table.insert(TBS_Menu.menutypes, {
	name = "MARIO MODE++",
	[1] = { -- Main Menu
		name = "MENU",
		style = Menu_Drawer,
		navigator = Navigator_Drawer,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW, icon = "MENUIC2",
		func = function(menut)
			if base_menu_select == 1 then
				G_SetCustomExitVars(PKZ_Table.hub_warp, 1)
				G_ExitLevel()
				TBS_Menu:toggleMenu(false)
			else
				TBS_Menu.select_sub_menu_structure(1 + base_menu_select, menut)
			end
		end, func_draw = Main_Menu_Selector_Drawer},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			TBS_Menu:toggleMenu(false)
		end, func_draw = Exit_Drawer},

	};
})


