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

local shopitems = {}

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
local shop_select = 1
local smoothing = 0

local global_opacity = 0
local exit_opacity = 0

local transition_plane = 0
local transition_anim = 0
local transition_dur = 3*TICRATE/10
local transition_speed = FRACUNIT/transition_dur
local transition_direction = true

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

local function Shop_Handling(key)
	if key.num == ctrl_inputs.right[1] then
		if shop_select >= #shopitems then
			shop_select = #shopitems
		else
			shop_select = $ + 1
			smoothing = FRACUNIT
		end
		return true
	end

	if key.num == ctrl_inputs.left[1] then
		if shop_select <= 1 then
			shop_select = 1
		else
			shop_select = $ - 1
			smoothing = FRACUNIT
		end
		return true
	end

	if key.num == ctrl_inputs.up[1]
	or key.num == ctrl_inputs.down[1] then
		TBS_Menu.selection = 2
		return true
	end

	return false
end

--
--	ELEMENTS
--

local function Menu_Element_HZip_Drawer(v, x, y, width, height, cur, min_i, max_i)
	local filled = width - ease.linear(((cur - min_i) * FRACUNIT) / (max_i - min_i), width, 0)
	local unfilled = width - filled

	v.drawFill(x, y, filled, height, 1|global_opacity)
	v.drawFill(x + filled, y, unfilled, height, 14|global_opacity)
	v.draw(x + filled - 4, y - 1, v.cachePatch("NMARIOMENUSCHOR"), global_opacity)
end

local function Menu_Element_VZip_Drawer(v, x, y, width, height, cur, min_i, max_i)
	local filled = height - ease.linear(((cur - min_i) * FRACUNIT) / (max_i - min_i), height, 0)
	local unfilled = height - filled

	v.drawFill(x, y, width, filled, 1|global_opacity)
	v.drawFill(x, y + filled, width, unfilled, 14|global_opacity)
	v.draw(x - 1, y + filled -4, v.cachePatch("NMARIOMENUSCVER"), global_opacity)
end

local function Main_Menu_Selector_Drawer(v, item, selected, extras)
	local y = 56
	local dist = 75
	local colormap

	-- Transitional animation
	local direction = transition_direction == true and 1 or -1
	local progress = transition_anim
	local way = 400
	if extras then
		progress = FRACUNIT - transition_anim
		way = -way
	end
	local extras_x = ease.outsine(progress, 0, way)*direction


	if selected then
		colormap = v.getColormap(TC_DEFAULT, 0, 'WHITETOYELLOWMENUMM')
	end

	--local purse_y = 154+abs(extras_x/8)
	--local save = xMM_registry.getSaveData()
	--v.draw(210, purse_y, v.cachePatch("NMARIOMENUPOCKET"), global_opacity|V_SNAPTOBOTTOM)
	--v.draw(210+8, purse_y+16, v.cachePatch("TALLCOIN"), global_opacity|V_SNAPTOBOTTOM)
	--TBSlib.fontdrawerInt(v, 'MA9LT', 210+16, purse_y+12, save.total_coins or 0, global_opacity|V_SNAPTOBOTTOM, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'left', 0, 8, 0)

	v.draw(extras_x+160-dist, 	y, v.cachePatch("NMARIOMENUSTART"), 		global_opacity, base_menu_select == 1 and colormap or nil)
	v.draw(extras_x+160, 		y, v.cachePatch("NMARIOMENUCOINSBT"), 		global_opacity, base_menu_select == 2 and colormap or nil)
	v.draw(extras_x+160+dist, 	y, v.cachePatch("NMARIOMENUOPTIONS"), 		global_opacity, base_menu_select == 3 and colormap or nil)
end

local function CoinMenu_Drawer(v, item, selected, extras)
	local y = 40
	local max_y = 100 + y
	local colormap

	-- Transitional animation
	local direction = transition_direction == true and 1 or -1
	local progress = transition_anim
	local way = 400
	if extras then
		progress = FRACUNIT - transition_anim
		way = -way
	end
	local extras_x = ease.outsine(progress, 0, way)*direction

	Menu_Element_VZip_Drawer(v, extras_x+300, y, 2, 100, coins_select, 1, #coincollection)

	local unselected_setting = v.cachePatch("NMARIOMENUSETE")
	local selected_setting = v.cachePatch("NMARIOMENUSETS")
	local start_i =  max(coins_select-2, 1)
	local end_i = max(coins_select-(#coincollection-2), 0)

	local half_global = min(5 + (global_opacity >> V_ALPHASHIFT) / 2, 9) << V_ALPHASHIFT

	local save = xMM_registry.getSaveData()
	local dgcount = save.coins
	v.draw(extras_x+41, 28, v.cachePatch("NMARIOMENUAMMSPECIAL"), global_opacity|V_SNAPTOTOP)
	TBSlib.drawTextInt(v, 'MA9LT', extras_x+65, 33, #dgcount.."/"..(xMM_registry.maxDrgCoins), global_opacity|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'left', 0, 0, 0)

	for i = start_i-end_i, #coincollection do
		if i > start_i+4 then break end

		local collection = coincollection[i]

		if selected and i == coins_select then
			v.draw(extras_x+160, y, selected_setting, global_opacity)
			TBSlib.drawTextInt(v, 'MA16LT', extras_x+45, y+3, string.upper(collection.name), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT), 'left', 0, 0, 0)
		else
			v.draw(extras_x+160, y, unselected_setting, global_opacity)
			TBSlib.drawTextInt(v, 'MA16LT', extras_x+45, y+3, string.upper(collection.name), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'left', 0, 0, 0)
		end

		local type_coin = collection.type
		local locks = collection.toggle

		if type_coin and locks then
			local graph_unlo = "NMARIOMENUCOIN"..collection.type
			local graph_lock = graph_unlo.."E"

			local patch_u = v.cachePatch(graph_unlo)
			local patch_l = v.cachePatch(graph_lock)

			local left = -(17 * #locks)

			for gold = 1, #locks do
				if locks[gold] then
					v.draw(extras_x + 276 + left, y, patch_u, global_opacity)
				else
					v.draw(extras_x + 276 + left, y, patch_l, half_global)
				end

				left = $+17
			end
		end

		y = $ + 21
	end
end

local function Settings_Drawer(v, item, selected, extras)
	local y = 40
	local max_y = 100 + y
	local colormap

	-- Transitional animation
	local direction = transition_direction == true and 1 or -1
	local progress = transition_anim
	local way = 400
	if extras then
		progress = FRACUNIT - transition_anim
		way = -way
	end
	local extras_x = ease.outsine(progress, 0, way)*direction

	Menu_Element_VZip_Drawer(v, extras_x+300, y, 2, 100, settings_select, 1, #settings)

	local unselected_setting = v.cachePatch("NMARIOMENUSETT")
	local selected_setting = v.cachePatch("NMARIOMENUSETS")
	local start_i =  max(settings_select-2, 1)
	local end_i = max(settings_select-(#settings-2), 0)

	--y = $ - ((21 * smoothing) / FRACUNIT) -- smoothing
	for i = start_i-end_i, #settings do
		if i > start_i+4 then break end

		if selected and i == settings_select then
			v.draw(extras_x+160, y, selected_setting, global_opacity)
			TBSlib.drawTextInt(v, 'MA16LT', extras_x+45, y+3, string.upper(settings[i].name), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREGOLDFONT), 'left', 0, 0, 0)
			if settings[i].cvar then
				TBSlib.drawTextInt(v, 'MA16LT', extras_x+225, y+3, string.upper(settings[i].cvar.string), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'center', 0, 0, 0)
			end
		else
			v.draw(extras_x+160, y, unselected_setting, global_opacity)
			TBSlib.drawTextInt(v, 'MA16LT', extras_x+45, y+3, string.upper(settings[i].name), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'left', 0, 0, 0)
			if settings[i].cvar then
				TBSlib.drawTextInt(v, 'MA16LT', extras_x+225, y+3, string.upper(settings[i].cvar.string), global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'center', 0, 0, 0)
			end
		end

		y = $ + 21
	end
end

local shop_coin_frames = {
	[0] = A,
	[1] = C,
	[2] = D,
	[3] = E,
}

local coin_scale = {
	[0] = 8*FRACUNIT/13,
	[1] = 7*FRACUNIT/12,
	[2] = 8*FRACUNIT/13,
	[3] = 7*FRACUNIT/12,
}

local function Shop_Drawer(v, item, selected)
	local x = 39
	local colormap

	-- Transitional animation
	local direction = transition_direction == true and 1 or -1
	local progress = transition_anim
	local way = 400
	if extras then
		progress = FRACUNIT - transition_anim
		way = -way
	end
	local extras_x = ease.outsine(progress, 0, way)*direction

	Menu_Element_HZip_Drawer(v, extras_x+41, 142, 240, 2, shop_select, 1, #shopitems)

	local unselected_setting = v.cachePatch("NMARIOMENUBUYITEM")
	local selected_setting = v.cachePatch("NMARIOMENUBUYITEMSEL")
	local start_i =  max(shop_select-1, 1)
	local end_i = max(shop_select-(#shopitems-1), 0)

	local save = xMM_registry.getSaveData()
	v.draw(extras_x+39, 28, v.cachePatch("NMARIOMENUSHOPCOINS"), global_opacity|V_SNAPTOTOP)
	TBSlib.drawTextInt(v, 'MA9LT', extras_x+63, 33, save.total_coins or 0, global_opacity|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'left', 0, 8, 0)

	for i = start_i-end_i, #shopitems do
		if i > start_i+2 then break end

		local item = shopitems[i]

		if selected and i == shop_select then
			v.draw(extras_x+x, 60, selected_setting, global_opacity)
		else
			v.draw(extras_x+x, 60, unselected_setting, global_opacity)
		end

		if item.type == 'OBJECT' then
			local sprite = v.getSpritePatch(states[mobjinfo[item.object].spawnstate].sprite, A, 0)
			v.draw(extras_x+x+35, 102, sprite, global_opacity)
			TBSlib.drawTextInt(v, 'MA9LT', extras_x+x+32, 110, item.cost, global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'left', 0, 3, 0)
		elseif item.type == 'COIN' then
			local coin = xMM_registry.levellist[item.mapid].new_coin or 0
			local sprite = v.getSpritePatch(SPR_DOIP, shop_coin_frames[coin], 0)
			v.drawScaled((extras_x+x+35)*FRACUNIT, 100*FRACUNIT, coin_scale[coin], sprite, global_opacity)
			TBSlib.drawTextInt(v, 'MA9LT', extras_x+x+32, 110, item.cost, global_opacity, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOPUREWHITEFONT), 'left', 0, 3, 0)
		else
			v.drawString(extras_x+x+12, 66, 'ID: '..i..'\n'..item.type..'\n'..item.cost)
		end

		x = $ + 85
	end
end

local function Exit_Drawer(v, item, selected)
	local y = 155
	local colormap

	if selected then
		colormap = v.getColormap(TC_DEFAULT, 0, 'WHITETOYELLOWMENUMM')
	end

	v.draw(160, y, v.cachePatch("NMARIOMENUGEXIT"), exit_opacity|V_SNAPTOBOTTOM, colormap)
end

local function Navigator_Drawer(v)
	return 0
end


local enabledcfg = false
local anim_cfg = 0
local anim_dur = 2*TICRATE/9
local anim_speed = FRACUNIT/anim_dur

local exit_delay = 0
local exit_lvl = false

--
--	MAIN DRAWER
--

local false_min = FRACUNIT/4
local false_max = FRACUNIT-false_min

local function clampTimer(min_, x, max_)
	return abs(max(min(x, max_), min_) - min_) * FRACUNIT / (max_ - min_)
end

--MENUBIGFONT
local function Menu_Drawer(v)
	-- Hide the hud :)
	xMM_registry.hideHud = true
	enabledcfg = true

	-- >> Setup values

	local width, widthf = v.width()
	local height, heightf = v.height()

	-- smoothing for stuff
	if smoothing then
		smoothing = smoothing/32
	end

	-- >> Animation Stuff

	local fillanim_y = ease.outsine(anim_cfg, 256, 0)
	local bgfillanim_opacity = ease.outsine(anim_cfg, 9, 6) << V_ALPHASHIFT
	local backanim_opacity = ease.outsine(anim_cfg, 9, 5) << V_ALPHASHIFT

	local in_timing = clampTimer(0, transition_anim, false_min)/2
	local out_timing = clampTimer(false_max, transition_anim, FRACUNIT)/2

	local transition_global = abs(9-abs(ease.inoutsine(in_timing+out_timing, -9, 9)))
	local pre_global = ease.outsine(anim_cfg, 9, 0)
	global_opacity = ((pre_global+transition_global) > 0) and max(pre_global, transition_global) << V_ALPHASHIFT or 0
	exit_opacity = pre_global > 0 and pre_global << V_ALPHASHIFT or 0

	-- >> Shared Background

	-- scrolling bg
	v.drawFill(0, 0, width, 29, 141|bgfillanim_opacity|V_SNAPTOLEFT|V_SNAPTOTOP)
	v.drawFill(0, 29, width, 2, 142|bgfillanim_opacity|V_SNAPTOLEFT|V_SNAPTOTOP)
	v.drawFill(0, 31, width, height-31, 143|bgfillanim_opacity|V_SNAPTOLEFT|V_SNAPTOTOP)

	-- actual scrolling element
	local original_p = -(leveltime % 512)
	local scrolling_x = original_p

	while(width > scrolling_x) do
		local scrolling_y = original_p

		while(height > scrolling_y) do
			v.drawScaled(scrolling_x * FRACUNIT, scrolling_y * FRACUNIT, FRACUNIT, v.cachePatch("NMARIOMENUBG"), V_SNAPTOLEFT|V_SNAPTOTOP|backanim_opacity)
			scrolling_y = $+512
		end

		scrolling_x = $+512
	end

	-- top
	v.drawFill(0, -fillanim_y, width, 27, 26|V_SNAPTOLEFT|V_SNAPTOTOP)

	-- buttom
	local base_y = 200-16+fillanim_y
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

	-- Transitional animation
	if transition_anim > 0 then
		local direction = transition_direction == true and 1 or -1
		local progress = transition_anim

		local way = 400
		local x_1 = ease.outsine(FRACUNIT-progress, 0, -way)*direction
		local x_2 = ease.outsine(progress, 0, way)*direction

		local PrevSubmenu = Menu[transition_plane]

		TBSlib.drawTextInt(v, 'MA14LT', x_1+160+fillanim_y, 18, PrevSubmenu.name, transition_global|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'center', 0, 0, 0)
		TBSlib.drawTextInt(v, 'MA14LT', x_2+160+fillanim_y, 18, Submenu.name, transition_global|V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'center', 0, 0, 0)
	else
		TBSlib.drawTextInt(v, 'MA14LT', 160+fillanim_y, 18, Submenu.name, V_SNAPTOTOP, v.getColormap(TC_DEFAULT, SKINCOLOR_MARIOTINTAQUAFONT), 'center', 0, 0, 0)
	end


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
				hud.mariomode.levelentry = TICRATE/3

				if exit_delay == 0 then
					exit_delay = anim_dur
					exit_lvl = true
				end
			else
				transition_plane = 1
				transition_direction = false
				transition_anim = FRACUNIT
				TBS_Menu.select_sub_menu_structure(base_menu_select, menut)
			end
		end, func_draw = Main_Menu_Selector_Drawer, special_input = Main_Menu_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			if exit_delay == 0 then
				exit_delay = anim_dur
				exit_lvl = false
			end
		end, func_draw = Exit_Drawer},
	};

	[2] = {
		name = "COINS",
		init = function()
			local list_ids = xMM_registry.listoflevelIDs
			local tokenlist = xMM_registry.levellist
			local save = xMM_registry.getSaveData()

			coincollection = {}

			for i = 1, #list_ids do
				local id = list_ids[i]
				local list_coins = tokenlist[id].coins

				coincollection[i] = {
					name = tostring(mapheaderinfo[id].lvlttl)..' '..tostring(mapheaderinfo[id].actnum),
					type = tokenlist[id].new_coin,
					coins = list_coins,
					toggle = {}
				}

				local array = coincollection[i]

				for y = 1, #list_coins do
					if list_coins[y] and save.coins[list_coins[y]] then
						array.toggle[y] = true
					else
						array.toggle[y] = false
					end
				end
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
			transition_plane = 2
			transition_direction = true
			transition_anim = FRACUNIT
			TBS_Menu.select_sub_menu_structure(1, menut)
		end, func_draw = Exit_Drawer},
	};

	[3] = {
		name = "OPTIONS",
		style = Menu_Drawer,
		navigator = Navigator_Drawer,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			return
		end, func_draw = Settings_Drawer, special_input = Settings_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			transition_plane = 3
			transition_direction = true
			transition_anim = FRACUNIT
			TBS_Menu.select_sub_menu_structure(1, menut)
		end, func_draw = Exit_Drawer},
	};

	[4] = {
		name = "SHOP",
		style = Menu_Drawer,
		navigator = Navigator_Drawer,
		init = function()
			local list_ids = xMM_registry.listoflevelIDs
			local tokenlist = xMM_registry.levellist
			local save = xMM_registry.getSaveData()

			shop_select = 1
			shopitems = {}

			for i = 1, #list_ids do
				local id = list_ids[i]
				local lvllist = save.lvl_data[id] or tokenlist[id]
				local list_shop = lvllist.shop ~= nil and lvllist.shop or tokenlist[id].shop

				if not (list_shop and #list_shop) then continue end
				local level_visited = lvllist.reqVisit ~= nil and lvllist.reqVisit or false

				for y = 1, #list_shop do
					local item = list_shop[y]

					if level_visited == false or item.forced then
						table.insert(shopitems, item)
						shopitems[#shopitems].mapid = id
						shopitems[#shopitems].itemid = y
					end
				end
			end
		end,

		{name = "CUSTOMSELECTION", z = 134, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			return
		end, func_draw = Shop_Drawer, special_input = Shop_Handling},

		{name = "EXIT", z = 325, flags = TBS_MFLAG.SPECIALDRAW,
		func = function(menut)
			if exit_delay == 0 then
				exit_delay = anim_dur
			end
		end, func_draw = Exit_Drawer},
	};
})

local men = TBS_Menu.menutypes
local menu_position = #men
addHook("HUD", function(v)
	if enabledcfg == true and not exit_delay then
		if anim_cfg < FRACUNIT then
			anim_cfg = $+anim_speed
		end

		if anim_cfg > FRACUNIT then
			anim_cfg = FRACUNIT
		end
		enabledcfg = false
	elseif anim_cfg > 0 then
		anim_cfg = $-anim_speed

		if anim_cfg < 0 then
			anim_cfg = 0
		end

		if exit_delay then
			exit_delay = $-1
			if exit_delay < 1 then
				TBS_Menu:toggleMenu(false)
				exit_delay = 0
				enabledcfg = false
			end
		end
	end

	if transition_anim > 0 then
		transition_anim = $-transition_speed

		if transition_anim < 0 then
			transition_anim = 0
		end

		if men[menu_position]
		and men[menu_position][transition_plane]
		and men[menu_position][transition_plane][1]
		and men[menu_position][transition_plane][1].func_draw then
			men[menu_position][transition_plane][1].func_draw(v, men[menu_position][transition_plane], 0, true)
		end
	else
		transition_anim = 0
	end
end)

addHook("PlayerThink", function(p)
	if exit_lvl and not exit_delay and not hud.mariomode.levelentry then
		G_SetCustomExitVars(xMM_registry.hub_warp, 1)
		G_ExitLevel()
		exit_lvl = false
	end
end)

--
--	DEBUG
--

COM_AddCommand("mm_debugopenshop", function()
	TBS_Menu:toggleMenu(true)
	TBS_Menu.select_sub_menu_structure(4, TBS_Menu.menutypes[TBS_Menu.menu])
end, COM_LOCAL)
