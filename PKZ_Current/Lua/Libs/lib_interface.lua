/*
		Team Blue Spring's Series of Libaries.
		Menu Framework - lib_interface.lua

Contributors: Skydusk
@Team Blue Spring 2024
*/

//
//	MENU VARIABLES
//

rawset(_G, "TBS_Menu", {
	//	global table for menus in TBS framework

	-- version control
	major_iteration = 1, -- versions with extensive changes.
	iteration = 1, -- additions, fixes. No variable changes.
	version = "DEV", -- just a string...

	-- toggle for menu
	enabled_Menu = 0,

	-- menuitems (containers for menu info)
	menutypes = {},

	-- style variables per menu, includes:
	-- limiters of space display in Y for each menu object
	-- limitz = {start of menu contains - y1, end of menu contains - y2, space between y1-y2} >> eachitem
	-- optional usage, but required for smooth scrolling within default keydown hook behavior
	defaultstyle = 0,
	styles = {},

	-- smoothing between scrolling.
	smoothing = 0,
	transisting = FRACUNIT,

	// selection
	-- to move these please, refer to pre-built functions
	menu = nil, -- menu object
	submenu = 1, -- submenu within menu object
	selection = 1, -- selection of menu item in submenu structure
	prev_sel = 1,  -- previous selection of menu item

	-- input detector
	-- whenever you wanted that kind of thing ig.
	keypresses = {},
	pressbt = 0,
	caps = false,
	capslock = false,

	-- simple boolean to skip checking.
	edgescr = false,

	-- mouse variables
	mouse_visible = false,
	mouse_sensitivity = 0,
	mouse_delayclick = 0,
	angle_lock = 0,
	mouse_x = 0,
	mouse_y = 0,

	-- in combination with confirmed variable, pop-ups are for extra menus appearing in for example:
	-- uhhh inputs? can be text or literal kind
	input_buffer = "",

	-- in combination with confirmed variable, pop-ups are for extra menus appearing in for example:
	-- confirmation whenever or not you want delete your entire progress of hard earned coins?
	popup_type = "none",
	popup_message = {},

	-- stops menu control. Makes you click double to either confirm your choice or not.
	-- should really be used with popup or input.
	confirmed = 0,
})

rawset(_G, "TBS_MENUCONFIG", {
	-- MENU TRIGGER
	open_key1 = "h",
	open_key2 = "h",

	close_key1 = "escape",
	close_key2 = "escape",
	-- >> REST
})

//
//	Current_Menu[TBS_Menu.selection].flags
//

rawset(_G, "TBS_MENUTRG", {
	-- CONTROLLER / KEYBOARD
	LEFT_BUMPER = 1,
	RIGHT_BUMPER = 2,
	CONFIRM = 4,
	ESCAPE = 8,
	UP = 16,
	DOWN = 32,
	LEFT = 64,
	RIGHT = 128,
})

--TBS_MFLAG
rawset(_G, "TBS_MFLAG", {
	-- SKIP OVER MENU ITEM FLAG
	NOTOUCH = 1;

	-- DEFAULT MENU Current_Menu[TBS_Menu.selection].flags
	TEXTONLY = 2;
	HEADER = 4;
	SPLIT = 8;

	-- CVARS (off-on and slider require cvar flag)
	CVAR = 16;
	OFFON = 32;
	SLIDER = 64;

	SCROLLER = 128;

	-- INPUT
	INPUT = 256;
	INPUTTEXT = 512;

	-- MULTIPLAYER
	HOSTONLY = 1024;
	ONLYMP = 2048;
	ONLYSP = 4096;

	-- MISC.
	SPECIALDRAW = 8192;
})

//
//	MENU FUNCTIONS
//

TBS_Menu.toggleMenu = function(self, toggle)
	if gamestate & GS_TITLESCREEN then return end
	if toggle then
		self.enabled_Menu = 1
		if consoleplayer and consoleplayer.mo then
			self.angle_lock = consoleplayer.mo.angle
		end
	else
		self.enabled_Menu = 0
		self.confirmed = 0
	end
end

--
--	TBS_Menu:check_MouseOver(mx1, my1, mx2, my2)
TBS_Menu.check_MouseOver = function(self, mx1, my1, mx2, my2)
	TBS_Menu.mouse_delayclick = TBS_Menu.mouse_delayclick > 0 and $-1 or 0
	if mx1 <= self.mouse_x and my1 <= self.mouse_y and
	mx2 >= self.mouse_x and my2 >= self.mouse_y then
		return true
	else
		return false
	end
end

--
--	TBS_Menu.draw_ClickableImage(v, x, y, scale, patch, flags, colormap)
TBS_Menu.draw_ClickableImage = function(v, x, y, scale, patch, flags, colormap)
	v.drawScaled(x, y, scale, patch, flags, colormap)
	local nx, ny = x/scale-patch.leftoffset, y/scale-patch.topoffset
	if TBS_Menu:check_MouseOver(nx, ny, nx+patch.width*(scale>>FRACBITS), ny+patch.height*(scale>>FRACBITS)) and mouse.buttons & MB_BUTTON1 and TBS_Menu.mouse_delayclick == 0 then
		TBS_Menu.mouse_delayclick = 30
		return true
	else
		return false
	end
end

--	TBS_Menu.draw_ClickableImageCropped(v, x, y, scale, patch, flags, colormap, sx, sy, w, h)
TBS_Menu.draw_ClickableImageCropped = function(v, x, y, scale, patch, flags, colormap, sx, sy, w, h)
	v.drawCropped(x, y, scale, scale, patch, flags, colormap, sx, sy, w, h)
	local nx, ny = x/scale-patch.leftoffset, y/scale-patch.topoffset
	if TBS_Menu:check_MouseOver(nx, ny, nx+min(patch.width*(scale>>FRACBITS)-sx, w), ny+min(patch.height*(scale>>FRACBITS)-sy, h)) and mouse.buttons & MB_BUTTON1 and TBS_Menu.mouse_delayclick == 0 then
		TBS_Menu.mouse_delayclick = 30
		return true
	else
		return false
	end
end

--
--	TBS_Menu.draw_ClickableFill(v, x, y, width, height, color)
TBS_Menu.draw_ClickableFill = function(v, x, y, width, height, color)
	v.drawFill(x, y, width, height, color)
	if TBS_Menu:check_MouseOver(x, y, x+width, y+height) and mouse.buttons & MB_BUTTON1 and TBS_Menu.mouse_delayclick == 0 then
		TBS_Menu.mouse_delayclick = 30
		return true
	else
		return false
	end
end

--
--	TBS_Menu.draw_DragableFill(v, x, y, width, height, color)
TBS_Menu.draw_DragableFill = function(v, x, y, width, height, color)
	v.drawFill(x, y, width, height, color)
	if TBS_Menu:check_MouseOver(x, y, x+width, y+height) and mouse.buttons & MB_BUTTON1 and TBS_Menu.mouse_delayclick == 0 then
		return true
	else
		return false
	end
end

--
--	TBS_Menu:check_MouseOverText(mx1, my1, string, font, allign)
--TBS_Menu.check_MouseOverText = function(self, mx1, my1)
--	if mx1 < self.mouse_x and my1 < self.mouse_y
--		and mx2 > self.mouse_x and my2 > self.mouse_y then
--		return true
--	else
--		return false
--	end
--end
--

-- checks conditions
TBS_Menu.check_Condition = function(menutx)
	if menutx and menutx.condition then
		return menutx.condition()
	else
		return nil
	end
end

TBS_Menu.check_MP = function(flags)
	local toggle = true

	if (flags & TBS_MFLAG.ONLYSP and multiplayer) or
	(flags & TBS_MFLAG.ONLYMP and not multiplayer) or
	(flags & TBS_MFLAG.HOSTONLY and consoleplayer ~= server) then
		toggle = false
	end

	return toggle
end

local function P_IsMenuUntouchable(flags, condition)
	if (flags & TBS_MFLAG.HEADER or flags & TBS_MFLAG.NOTOUCH or flags & TBS_MFLAG.SPLIT or not TBS_Menu.check_MP(flags))
	or (condition ~= nil and condition == false) then
		return true
	else
		return false
	end
end

TBS_Menu.select_menu_structure = function(move)
	if TBS_Menu.smoothing and abs(TBS_Menu.smoothing) then
		TBS_Menu.smoothing = 0
	end

	TBS_Menu.selection = 1
	TBS_Menu.submenu = 1

	local xlen = TBS_Menu.menutypes

	if move then
		TBS_Menu.menu = (1 < TBS_Menu.menu and $-1 or #xlen)
	else
		TBS_Menu.menu = (#xlen > TBS_Menu.menu and $+1 or 1)
	end
end


TBS_Menu.select_sub_menu_structure = function(submenux, menutab)
	local numsel = 1
	while (true) do
		local menutx = menutab[submenux][numsel]
		local flags = menutx.flags
		if not (P_IsMenuUntouchable(flags, TBS_Menu.check_Condition(menutx))) then
			break
		end
		numsel = $+1
	end

	if TBS_Menu.smoothing and abs(TBS_Menu.smoothing) then
		TBS_Menu.smoothing = 0
	end

	if menutab[submenux].init then
		menutab[submenux].init()
	end

	TBS_Menu.selection = numsel
	TBS_Menu.submenu = submenux
end

-- TBS_Menu:confirmButtom(sel)
TBS_Menu.confirmButtom = function(self, sel)
	local pick = self.menutypes[self.menu][self.submenu][sel]
	if (pick.flags & TBS_MFLAG.INPUT or pick.flags & TBS_MFLAG.INPUTTEXT) then
		TBS_Menu.confirmed = 1
		return true
	else
		pick.func(self.menutypes[self.menu])
		return true
	end

	if self.style[self.menu].sounds and self.style[self.menu].sounds.select then
		S_StartSound(nil, self.style[self.menu].sounds.select, consoleplayer)
	end

	return false
end


local function M_selectionItemMMM(move, itemcount, skip)
	if not skip then
		TBS_Menu.prev_sel = TBS_Menu.selection
	end

	if (move and 1 < TBS_Menu.selection) or (not move and itemcount > TBS_Menu.selection) then
		TBS_Menu.edgescr = false
	else
		TBS_Menu.edgescr = true
	end

	if move then
		TBS_Menu.selection = (1 < TBS_Menu.selection and $-1 or itemcount)
	else
		TBS_Menu.selection = (itemcount > TBS_Menu.selection and $+1 or 1)
	end
end

-- TBS_Menu:scrollMenuItems(move)
TBS_Menu.scrollMenuItems = function(self, move)
	local Current_Menu = self.menutypes[self.menu][self.submenu]
	M_selectionItemMMM(move, #Current_Menu)

	-- another in case of header
	while (P_IsMenuUntouchable(Current_Menu[self.selection].flags, self.check_Condition(Current_Menu[self.selection]))) do
		M_selectionItemMMM(move, #Current_Menu, true)
	end

	if self.styles[self.menu].sounds and self.styles[self.menu].sounds.scroll then
		S_StartSound(nil, self.styles[self.menu].sounds.scroll, consoleplayer)
	end

	if Current_Menu[self.selection].init then
		Current_Menu[self.selection].init()
	end

	if move then
		if not (self.edgescr) then
			self.smoothing = (Current_Menu[self.selection].z - Current_Menu[self.prev_sel].z)/3
		end
	else
		if not (self.edgescr) then
			self.smoothing = (Current_Menu[self.prev_sel].z - Current_Menu[self.selection].z)/3
		end
	end
end

local function Scroll_Table(table, index)
	if index < 1 then
		index = #table + index
	end

	local new_index = ((index - 1) % #table) + 1

	if new_index then
		return new_index, table[new_index]
	end
end


local prev_music = nil

-- TBS_Menu:playMusic()
TBS_Menu.playMusic = function(self)
	if not prev_music then
		prev_music = S_MusicName(consoleplayer)
	end

	if self.style[self.menu].music and self.style[self.menu].music ~= S_MusicName(consoleplayer) then
		S_ChangeMusic(self.style[self.menu].music, true, player)
	end

end


local function M_selectionMenu(move)
	if move then
		TBS_Menu.select_menu_structure(true)
		TBS_Menu.pressbt = $|TBS_MENUTRG.RIGHT_BUMPER
	else
		TBS_Menu.select_menu_structure(false)
		TBS_Menu.pressbt = $|TBS_MENUTRG.LEFT_BUMPER
	end
end

COM_AddCommand("tbs_menu", function(player, arg1)
	if gamestate & GS_LEVEL and not paused then
		CONS_Printf(player, "\x82".."Menu Activated")
		if TBS_Menu.menu == nil then
			TBS_Menu.menu = (TBS_Menu.menutypes[2] ~= nil and 2 or 1)
		end
		TBS_Menu.select_sub_menu_structure(1, tonumber(arg1) or TBS_Menu.menutypes[TBS_Menu.menu])
		TBS_Menu:toggleMenu(true)
	else
		CONS_Printf(player, "\x82".."Menu can only be activated in game.")
	end
end, COM_LOCAL)

local acceptable_inputs = {
	"q","w","e","r","t","z","u","i","o","p","a","s","d","f","g","h","j","k","l","y","x","c","v","b","n","m",

	",",".","-","'",":","?","!",

	"0","1","2","3","4","5","6","7","8","9"
}

local function P_iterateInputs(input)
	for _,v in ipairs(acceptable_inputs) do
		if input == v then
			return true
		end
	end

	return false
end


addHook("KeyUp", function(key)
	if (key.name == "lshift" or key.name == "rshift") and TBS_Menu.caps and not TBS_Menu.capslock then
		TBS_Menu.caps = false
	end
end)

addHook("KeyDown", function(key)
	--print(key.name)
	if TBS_Menu.enabled_Menu == 1 then
		if not gamestate == GS_LEVEL then
			TBS_Menu:toggleMenu(false)
			return
		end

		local Menu = TBS_Menu.menutypes[TBS_Menu.menu]
		local Current_Menu = Menu[TBS_Menu.submenu]

		if Current_Menu[TBS_Menu.selection].special_input and Current_Menu[TBS_Menu.selection].special_input(key) then
			return true
		end

		TBS_Menu.keypresses[key.name] = true

		if not TBS_Menu.confirmed then
			--
			-- CLOSE
			--
			if key.name == TBS_MENUCONFIG.close_key1 or key.name == TBS_MENUCONFIG.close_key2 then
				TBS_Menu.select_sub_menu_structure(1, TBS_Menu.menutypes[TBS_Menu.menu])
				TBS_Menu:toggleMenu(false)
			end

			--
			-- SCROLL UP
			--
			if key.num == ctrl_inputs.up[1] or mouse.buttons & MB_SCROLLUP then
				TBS_Menu.mouse_visible = false
				TBS_Menu:scrollMenuItems(true)
			end


			--
			-- SCROLL DOWN
			--
			if key.num == ctrl_inputs.down[1] or mouse.buttons & MB_SCROLLDOWN then
				TBS_Menu.mouse_visible = false
				TBS_Menu:scrollMenuItems(false)
			end


			--
			-- CONFIRM
			--
			if ((key.num == ctrl_inputs.jmp[1] or key.num == ctrl_inputs.spn[1]) and (Current_Menu[TBS_Menu.selection].func or Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT or Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT)) then
				TBS_Menu.mouse_visible = false
				TBS_Menu:confirmButtom(TBS_Menu.selection)
				return true
			end


			--
			-- CVAR ADD/SUB
			--
			if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.CVAR and Current_Menu[TBS_Menu.selection].cvar and not (Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT or Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT) then
				TBS_Menu.mouse_visible = false
				if (key.num == ctrl_inputs.right[1] or key.num == ctrl_inputs.turr[1]) then
					CV_AddValue(Current_Menu[TBS_Menu.selection].cvar(), 1)
				end

				if (key.num == ctrl_inputs.left[1] or key.num == ctrl_inputs.turl[1]) then
					CV_AddValue(Current_Menu[TBS_Menu.selection].cvar(), -1)
				end

			end



			--
			-- ENUM ADD/SUB
			--
			if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.SCROLLER and Current_Menu[TBS_Menu.selection].cvar and not (Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT or Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT) then
				TBS_Menu.mouse_visible = false
				if (key.num == ctrl_inputs.right[1] or key.num == ctrl_inputs.turr[1]) then
					Current_Menu[TBS_Menu.selection].cvar.next()
				end

				if (key.num == ctrl_inputs.left[1] or key.num == ctrl_inputs.turl[1]) then
					Current_Menu[TBS_Menu.selection].cvar.prev()
				end

			end

			--
			-- SWITCH BETWEEN MENUS
			--
			if key.name == "q" then
				TBS_Menu.mouse_visible = false
				M_selectionMenu(false)
				if TBS_Menu.styles[TBS_Menu.menu] and TBS_Menu.styles[TBS_Menu.menu].init then
					TBS_Menu.styles[TBS_Menu.menu].init()
				end
			end

			if key.name == "e" then
				TBS_Menu.mouse_visible = false
				M_selectionMenu(true)
				if TBS_Menu.styles[TBS_Menu.menu] and TBS_Menu.styles[TBS_Menu.menu].init then
					TBS_Menu.styles[TBS_Menu.menu].init()
				end
			end
		else
			-- confirmation state

			--
			-- INPUTS FOR TEXT EDITING / ENTERING INPUTS
			--
			if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT or Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT then
				local inputs = TBS_Menu.input_buffer
				TBS_Menu.mouse_visible = false

				if (key.name == "enter") then
					-- Check whenever menu item is also cvar... nobody has to go through extra hassle.
					if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.CVAR then
						CV_Set(Current_Menu[TBS_Menu.selection].cvar(), TBS_Menu.input_buffer)
					else
						Current_Menu[TBS_Menu.selection].func()
					end
					TBS_Menu.input_buffer = ""
					TBS_Menu.confirmed = 0

				elseif (key.name == "escape") then
					-- GO BACK!!!
					TBS_Menu.input_buffer = ""
					TBS_Menu.confirmed = 0

				elseif (key.name == "space") and Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT and (not Current_Menu[TBS_Menu.selection].input_limit or (Current_Menu[TBS_Menu.selection].input_limit > #inputs)) then
					-- Jump..
					TBS_Menu.input_buffer = $+" "

				elseif (key.name == "lshift" or key.name == "rshift") and Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT then
					-- Dear... upper case letters...
					TBS_Menu.caps = true

				elseif (key.name == "capslock") and Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT then
					-- GUYS WE INVENTED CAPSLOCK
					TBS_Menu.capslock = (TBS_Menu.caps and false or true)
					TBS_Menu.caps = TBS_Menu.capslock

				elseif (key.name == "backspace") then
					-- delete this or else...
					if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT then
						TBS_Menu.input_buffer = ""
					elseif Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT then
						TBS_Menu.input_buffer = string.sub(TBS_Menu.input_buffer, 1, -2)
					end

				else
					-- record inputs
					if Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUT then
						TBS_Menu.input_buffer = key.name

					-- record letters
					elseif Current_Menu[TBS_Menu.selection].flags & TBS_MFLAG.INPUTTEXT then
						if P_iterateInputs(key.name) and (not Current_Menu[TBS_Menu.selection].input_limit or (Current_Menu[TBS_Menu.selection].input_limit > #inputs)) then
							TBS_Menu.input_buffer = $+(TBS_Menu.caps and string.upper(key.name) or key.name)
						end
					end

				end
			else
				TBS_Menu.mouse_visible = false

				-- pop-up confirmation variant
				if (key.num == ctrl_inputs.jmp[1]) then
					Current_Menu[TBS_Menu.selection].func()
				elseif (key.num == ctrl_inputs.spn[1]) then
					TBS_Menu.popupmessage = {}
					TBS_Menu.confirmed = 0
				end
			end
		end

		return true
	else
		--
		-- OPEN MENU
		--
		if key.name == TBS_MENUCONFIG.open_key1 or key.name == TBS_MENUCONFIG.open_key2 then
			if TBS_Menu.menu == nil then
				TBS_Menu.menu = (TBS_Menu.menutypes[2] ~= nil and 2 or 1)
			end
			TBS_Menu.select_sub_menu_structure(1, TBS_Menu.menutypes[TBS_Menu.menu])
			TBS_Menu:toggleMenu(true)
			return true
		end
	end
end)

addHook("PlayerThink", function(p)
	if TBS_Menu.enabled_Menu == 1 then
		p.mo.angle = TBS_Menu.angle_lock
	end
end)

local delay = 0
hud.add(function(v, stplyr)
	if TBS_Menu.enabled_Menu == 1 then
		TBS_Menu.mouse_x = min(max(TBS_Menu.mouse_x+mouse.dx/10, 0), v.width()/v.dupx())
		TBS_Menu.mouse_y = min(max(TBS_Menu.mouse_y+mouse.dy/10, 0), v.height()/v.dupy())

		//TBS_Menu:playMusic()

		if mouse.dx or mouse.dy then
			TBS_Menu.mouse_visible = true
		end

		if TBS_Menu.menutypes[TBS_Menu.menu][TBS_Menu.submenu].style then
			TBS_Menu.menutypes[TBS_Menu.menu][TBS_Menu.submenu].style(v)
		else
			TBS_Menu.menutypes[1][1].style(v)
		end

		local num_menus = TBS_Menu.menutypes

		if TBS_Menu.mouse_visible then
			v.drawFill(TBS_Menu.mouse_x, TBS_Menu.mouse_y, 4, 2, 1)
			v.drawFill(TBS_Menu.mouse_x, TBS_Menu.mouse_y+2, 2, 2, 1)
		end

		if #num_menus < 1 then return end

		if TBS_Menu.menutypes[TBS_Menu.menu][TBS_Menu.submenu].navigator then
			TBS_Menu.menutypes[TBS_Menu.menu][TBS_Menu.submenu].navigator(v)
		else
			local menu_name = TBS_Menu.menutypes[TBS_Menu.menu].name
			local name_len = v.stringWidth(menu_name) >> 1

			local vibes = abs((6 & leveltime/3)-3)
			local tbs = "_TBS_MENU"

			local left_key = v.cachePatch(tbs.."QP"..((TBS_Menu.pressbt & 1) and "R" or "S"))
			local right_key = v.cachePatch(tbs.."EP"..((TBS_Menu.pressbt & 2) and "R" or "S"))

			local left_arrow = v.cachePatch(tbs.."LA"..((TBS_Menu.pressbt & 1) and "R" or "S"))
			local right_arrow = v.cachePatch(tbs.."RA"..((TBS_Menu.pressbt & 2) and "R" or "S"))

			TBS_Menu.pressbt = 0

			if TBS_Menu.draw_ClickableImage(v, (160-name_len) << FRACBITS, 7 << FRACBITS, FRACUNIT, left_key, 0, v.getStringColormap(0x80)) then
				M_selectionMenu(false)
			end

			if TBS_Menu.draw_ClickableImage(v, (170+name_len) << FRACBITS, 7 << FRACBITS, FRACUNIT, right_key, 0, v.getStringColormap(0x80)) then
				M_selectionMenu(true)
			end

			--v.draw(160-name_len, 7, left_key, 0)
			--v.draw(170+name_len, 7, right_key, 0)

			-- arrow
			v.draw(160-name_len-left_key.width-vibes, 8+left_key.height >> 1, left_arrow, 0)
			v.draw(170+name_len+right_key.width+vibes, 8+right_key.height >> 1, right_arrow, 0)

			v.drawString(165, 9, menu_name, 0, "center")
		end
	else
		//prev_music = nil
	end

	if delay then
		TBS_Menu.keypresses = {}
	elseif TBS_Menu.keypresses then
		delay = 1
	end
end, "game")

-------------
----------	DEFAULT STYLE
-------------

if TBSlib then
	-- P_CheckMouseTextHover(x, y, extra, height, string, v, font, padding)
	local function P_CheckMouseTextHover(x, y, extra, height, string, v, font, padding, patch, val)
		local mx2 = 0
		if string and #string > 0 then
			for i = 1,#string do
				mx2 = $ + TBSlib.fontlenghtcal(v, patch, string, font, val, padding, i)
			end
		end
		local Zfont = v.cachePatch(font+"0")
		return TBS_Menu:check_MouseOver(x, y, x+mx2+(extra or 0), y+(height and height or Zfont.height))
	end

	-- TBSlib.fontdrawer(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
	local function P_MouseTextDrawer(v, font, x, y, value, flags, color, alligment, padding, leftadd, symbol, itemx, item)
		if item.func and P_CheckMouseTextHover(x, y, extra, height, value, v, font, padding, patch, val)
		and mouse.buttons & MB_BUTTON1 and not TBS_Menu.mouse_delayclick then
			TBS_Menu:confirmButtom(itemx)
		end
		TBSlib.fontdrawerInt(v, font, x, y, value, flags, color, alligment, padding, leftadd, symbol)
	end

	table.insert(TBS_Menu.styles, {
		limitz = {69, 164, 95}

		//music = "O_PKZMENUMUSIC"
		//sounds = {
		//			select	 	= "sfx_pkzmen3";
		//			scroll 		= "sfx_pkzmen3";
		//			accept 		= "sfx_pkzmen3";
		//			deny 		= "sfx_pkzmen3";
		//}
	})

	local curload = {}
	local xdispl = {}
	local xscale = 0

	local function style_drawer(v)
			local Menu = TBS_Menu.menutypes[TBS_Menu.menu]
			local selection = TBS_Menu.selection
			local submenu = TBS_Menu.submenu
			local limitz = TBS_Menu.styles[TBS_Menu.menu].limitz

			if not paused or confirmed then
				v.fadeScreen(0xFF00, 15)
			end

			//local leveltimdel = leveltime/2
			//local textbgwidth = (leveltimdel % (texturebackground.width/2))
			//local textbgheight = (leveltimdel % (texturebackground.height/2))

			local Menuval = Menu[submenu]

			if TBS_Menu.smoothing then
				if TBS_Menu.smoothing > 0 then
					TBS_Menu.smoothing = $ - 1
				else
					TBS_Menu.smoothing = $ + 1
				end
			end

			local lazyZ = ((Menuval[#Menuval].z > (limitz[2]+15)) and
			(Menuval[#Menuval].z <= Menuval[selection].z+limitz[3] and Menuval[#Menuval].z-limitz[2] or (Menuval[selection].z - limitz[1])) or 0)+TBS_Menu.smoothing

			local OptTimer = (leveltime % 8) >> 1

			curload = {}

			local background_scroll = (leveltime % 96)-192
			v.draw(background_scroll, background_scroll, v.cachePatch("_TBS_MENUBG"), V_50TRANS)

			local backname_img = v.cachePatch("_TBS_MENUXDNAME")
			local backname_scroll = (leveltime % 111)-55

			v.draw(backname_scroll, 0, backname_img, V_SNAPTOTOP|V_30TRANS)
			v.draw(backname_scroll, 184, backname_img, V_SNAPTOBOTTOM|V_30TRANS)


			for k,c in ipairs(Menu[submenu]) do



				table.insert(curload, k)

				if TBS_Menu.check_Condition(c) == false then
					TBSlib.fontdrawerInt(v, '_TBS_2FONT', 103, c.z-lazyZ,
					"???",
					0,
					v.getColormap(TC_DEFAULT, SKINCOLOR_GREY), "left", 0, 0)
					continue
				end

				if not ((c.flags & TBS_MFLAG.SPECIALDRAW and c.func_draw) or c.flags & TBS_MFLAG.SPLIT) then

					local widthIconItem = 0
					local xNameOfItem = 160

					local color = SKINCOLOR_WHITE

					if (k == selection and not TBS_Menu.mouse_visible) or P_CheckMouseTextHover(xNameOfItem+widthIconItem, c.z-lazyZ, 0, 10, c.name, v, 'MA2LT', 0) then
						color = SKINCOLOR_SAPPHIRE
					end

					P_MouseTextDrawer(v, k == selection and '_TBS_1FONT' or '_TBS_2FONT', xNameOfItem+widthIconItem, c.z-lazyZ,
					c.name, 0,
					v.getColormap(TC_DEFAULT, ((c.flags & TBS_MFLAG.HEADER) and SKINCOLOR_RED or color)), "center", 0, 0, 0, k, c)

					if (c.flags & TBS_MFLAG.INPUT or c.flags & TBS_MFLAG.INPUTTEXT) then

						local visinput = ""

						if k == selection and TBS_Menu.confirmed then
							visinput = (TBS_Menu.input_buffer or "")
							if (leveltime % 16)/8 and visinput ~= nil and #visinput < c.input_limit then
								visinput = $+"I"
							end
						else
							if c.flags & TBS_MFLAG.CVAR and c.cvar then
								visinput = c.cvar().string or ""
							else
								visinput = c.value or ""
							end
						end

						local txtlenght = 0
						if visinput and #visinput > 0 then
							for i = 1,#visinput do
								txtlenght = $ + TBSlib.fontlenghtcal(v, patch, visinput, '_TBS_3FONT', val, 0, i)
							end
						end

						local seperated_lines = {}
						local interval = 1
						while (string.sub(visinput, 16*(interval-1), (16*interval)-1) ~= "")
							seperated_lines[interval] = string.sub(visinput, 16*(interval-1), (16*interval)-1)
							interval = $ + 1
						end

						local lenght = max(c.input_limit*8 or 0, txtlenght)

						if TBS_Menu.draw_ClickableFill(v, xNameOfItem+widthIconItem-2, c.z-lazyZ+8, min(lenght, 128)+4, 9+(lenght/128)*9, 31) then
							TBS_Menu.confirmed = 1
						end

						for key,text in ipairs(seperated_lines) do
							TBSlib.fontdrawerInt(v, '_TBS_3FONT', xNameOfItem+widthIconItem, c.z-lazyZ+9*key,
							text or "", 0,
							v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)
						end
					end


					if c.flags & TBS_MFLAG.CVAR and c.cvar and not (c.flags & TBS_MFLAG.INPUT or c.flags & TBS_MFLAG.INPUTTEXT) then

						local cvar = c.cvar()
						local enustr = string.upper(cvar.string)

						if not (c.flags & TBS_MFLAG.SLIDER and c.difv) then

							local lenghtcvarname = 0
							local menuitemstrglng = string.upper(c.name)
							for i = 1,#menuitemstrglng do
								lenghtcvarname = $ + TBSlib.fontlenghtcal(v, patch, menuitemstrglng, '_TBS_3FONT', val, 0, i)
							end

							local ycv, xscl = 10, lenghtcvarname/2

							if Menu[submenu][selection] == c then
								if TBS_Menu.draw_ClickableImage(v, (160-OptTimer-xscl)<<FRACBITS, (c.z-lazyZ+ycv)<<FRACBITS, FRACUNIT, v.cachePatch("_TBS_MENULEFT"), 0, v.getStringColormap(0x80)) then
									CV_AddValue(c.cvar(), -1)
								end
								if TBS_Menu.draw_ClickableImage(v, (160+OptTimer+xscl)<<FRACBITS, (c.z-lazyZ+ycv)<<FRACBITS, FRACUNIT, v.cachePatch("_TBS_MENURIGHT"), 0, v.getStringColormap(0x80)) then
									CV_AddValue(c.cvar(), 1)
								end
							end

							TBSlib.fontdrawerInt(v, cvar.defaultvalue == cvar.string and '_TBS_3FONT' or '_TBS_4FONT', 160, c.z-lazyZ+ycv,
							enustr, 0,
							v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)

						else
							local oneproc = c.difv[1]
							local hundprc = FixedDiv(abs(oneproc-cvar.value)<<FRACBITS, abs(oneproc-c.difv[2])<<FRACBITS)
							local valprc = FixedMul(hundprc, 52<<FRACBITS)

							if Menu[submenu][selection] == c then
								if TBS_Menu.draw_ClickableImage(v, (105-OptTimer)<<FRACBITS, (c.z-lazyZ+8)<<FRACBITS, FRACUNIT, v.cachePatch("_TBS_MENULEFT"), 0, v.getStringColormap(0x80)) then
									CV_AddValue(c.cvar(), -1)
								end
								if TBS_Menu.draw_ClickableImage(v, (165+OptTimer)<<FRACBITS, (c.z-lazyZ+8)<<FRACBITS, FRACUNIT, v.cachePatch("_TBS_MENURIGHT"), 0, v.getStringColormap(0x80)) then
									CV_AddValue(c.cvar(), 1)
								end
							end

							v.draw(112, c.z-lazyZ+9, v.cachePatch("MENUPKSLID2"))

							//
							v.drawStretched(112<<FRACBITS-abs(valprc), (c.z-lazyZ+9)<<FRACBITS, FRACUNIT+abs(valprc), FRACUNIT, v.cachePatch("MENUPKSLID3"))
							v.draw(111+valprc>>FRACBITS, c.z-lazyZ+8, v.cachePatch("MENUPKSLID1"))


							TBSlib.fontdrawerInt(v, cvar.defaultvalue == cvar.string and '_TBS_3FONT' or '_TBS_4FONT', 180, c.z-lazyZ+9,
							enustr, 0,
							v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)


						end

					end

				else
					if c.flags & TBS_MFLAG.SPLIT then
						v.draw(160, c.z-lazyZ, v.cachePatch("_TBS_MENUSPLIT"))
					else
						c.func_draw(v, c, lazyZ)
					end
				end
		end

		if selection < #Menuval and lazyZ
		and TBS_Menu.draw_ClickableImage(v, 160<<FRACBITS, (limitz[2]+OptTimer+1)<<FRACBITS, FRACUNIT, v.cachePatch("MENUEMDOWN"), 0, v.getStringColormap(0x80)) then
			TBS_Menu:scrollMenuItems(false)
		end

		if curload[1] and curload[1] > 1
		and TBS_Menu.draw_ClickableImage(v, 160<<FRACBITS, (limitz[1]+OptTimer-11)<<FRACBITS, FRACUNIT, v.cachePatch("MENUEMUP"), 0, v.getStringColormap(0x80)) then
			TBS_Menu:scrollMenuItems(true)
		end

		if TBS_Menu.confirmed then

			if not (Menu[submenu][selection].flags & TBS_MFLAG.INPUT or Menu[submenu][selection].flags & TBS_MFLAG.INPUTTEXT) then
				local popupmessage = TBS_Menu.popup_message

				xscale = xscale and (xscale < 12 and $+1 or $) or 1
				local scale = TBSlib.quadBezier((xscale<<FRACBITS)/12, FRACUNIT>>1, FRACUNIT-FRACUNIT>>3, FRACUNIT)

				v.fadeScreen(0xFF00, 14+xscale/3)
				v.drawFill(60, 89, 210, 10+#popupmessage*popupmessage.zoff, 47-xscale>>2)

				TBSlib.fontdrawer(v, 'MA4LT', FixedDiv(160<<FRACBITS, scale), FixedDiv(74<<FRACBITS, scale), scale,
				popupmessage.head,
				0, v.getColormap(TC_DEFAULT, SKINCOLOR_RED), "center", 0, 0)
				for k,c in ipairs(popupmessage) do
					TBSlib.fontdrawer(v, 'MA2LT', FixedDiv(FixedDiv(121<<FRACBITS, FRACUNIT>>1), scale), FixedDiv(FixedDiv((popupmessage.zoff*k+84)<<FRACBITS, FRACUNIT>>1), scale), FixedMul(FRACUNIT>>1, scale),
					string.upper(popupmessage[k]),
					0, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE), "center", 0, 0)
				end
			end
		end
		xscale = 1
	end



	table.insert(TBS_Menu.menutypes, {
		name = "CONFIG MENU",
		[1] = { -- Main Menu
			style = function(v) style_drawer(v) end,

			{name = "OPEN MENU KEY BINDS", z = 50, flags = TBS_MFLAG.INPUTTEXT, difv = {0, 3}, input_limit = 1,
			func = function() return P_CheckInputedCode() end;};

			{name = "SPLIT", z = 75, flags = TBS_MFLAG.SPLIT};

			{name = "KEY OPTIONS", z = 90, flags = TBS_MFLAG.CVAR, difv = {0, 3}, icon = "MENUIC4",
			cvar = function() return CV_FindVar("pkz_hudstyles") end;};

			{name = "DEFAULT STYLE", z = 115, flags = TBS_MFLAG.CVAR, difv = {0, 3}, icon = "MENUIC4",
			cvar = function() return CV_FindVar("pkz_hudstyles") end;};

			{name = "SPLIT", z = 140, flags = TBS_MFLAG.SPLIT};

			{name = "EXIT", z = 155, flags = 0, icon = "MENUIC2",
			func = function(menut)
				TBS_Menu:toggleMenu(false)
			end};
		};
	})

end