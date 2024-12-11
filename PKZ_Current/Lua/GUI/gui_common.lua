local function P_CheckInputedCode()
	local x = cheat_codes[TBS_Menu.input_buffer]
	if x then
		x()
	else
		CONS_Printf(consoleplayer, "\x85".."WARNING:".."\x80".."Invalid code.")
	end
end

-- P_CheckMouseTextHover(x, y, extra, height, string, v, font, padding)
local function P_CheckMouseTextHover(x, y, extra, height, string, v, font, padding, patch, val)
	local mx2 = 0
	if string and #string > 0 then
		for i = 1,#string do
			mx2 = $ + TBSlib.getTextLenght(v, patch, string, font, val, padding, i)
		end
	end
	local Zfont = v.cachePatch(font+"0")
	return TBS_Menu:check_MouseOver(x, y, x+mx2+(extra or 0), y+(height and height or Zfont.height))
end

-- TBSlib.fontdrawer(d, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol)
local function P_MouseTextDrawer(v, font, x, y, scale, value, flags, color, alligment, padding, leftadd, symbol, itemx, item)
	if item.func and P_CheckMouseTextHover(x, y, extra, height, value, v, font, padding, patch, val)
	and mouse.buttons & MB_BUTTON1 and not TBS_Menu.mouse_delayclick then
		TBS_Menu:confirmButtom(itemx)
	end
	--print(limits.limitz[1], limits.limitz[2])
	local crop_1 = max(limits.textlimitz[1]*FRACUNIT-y, 0)
	local crop_2 = max(limits.textlimitz[2]*FRACUNIT-y, 0)
	--if not (leveltime % 32) then print('\x82y:  '..FixedInt(y), 'y1: '..crop_1..' '..FixedInt(crop_1)..' '..limits.limitz[1], 'y2: '..crop_2..' '..FixedInt(crop_2)..' '..limits.limitz[2]) end
	TBSlib.drawStaticTextCropped(v, font, x, y, scale, value, flags, color, alligment, padding, 0, crop_1, 123*FRACUNIT, crop_2)
	--TBSlib.statictextdrawer(v, font, x, y, scale, value, flags, color, alligment, padding)
end

local function G_NumLeftAdd(num, leftadd)
	local str = ""+num
	local num_loops = leftadd-#str
	if num_loops <= 0 then return str end
	for i = 1,num_loops do
		str = "0"..str
	end
	return str
end

local function G_TicsToTimeStruct(tics, leftadd)
	return G_NumLeftAdd(G_TicsToMinutes(tics), leftadd)+":"
	+G_NumLeftAdd(G_TicsToSeconds(tics), leftadd)+":"
	+G_NumLeftAdd(G_TicsToCentiseconds(tics), leftadd)
end
