--[[
	Dialog system

	(C) 2022 by Ashi

	Heavily modified by Skydusk for purposes of MM++
--]]

-- logging purposes
print("Initializing Dialog System...")

-- input variables that we use very often
local ctrl_inputs = {
    -- movement
    up = {}, down = {}, left = {}, right = {}, turr = {}, turl = {},
    -- main
    jmp = {}, spn = {}, cb1 = {}, cb2 = {}, cb3 = {}, tfg = {},
    -- sys
    sys = {}, pause = {}, con = {}
}
-- fill out these on map load
addHook("MapLoad", function()
    ctrl_inputs.up[1], ctrl_inputs.up[2] = input.gameControlToKeyNum(GC_FORWARD)
	ctrl_inputs.down[1], ctrl_inputs.down[2] = input.gameControlToKeyNum(GC_BACKWARD)
	ctrl_inputs.left[1], ctrl_inputs.left[2] = input.gameControlToKeyNum(GC_STRAFELEFT)
	ctrl_inputs.right[1], ctrl_inputs.right[2] = input.gameControlToKeyNum(GC_STRAFERIGHT)
	ctrl_inputs.turl[1], ctrl_inputs.turl[2] = input.gameControlToKeyNum(GC_TURNLEFT)
	ctrl_inputs.turr[1], ctrl_inputs.turr[2] = input.gameControlToKeyNum(GC_TURNRIGHT)

	ctrl_inputs.jmp[1], ctrl_inputs.jmp[2] = input.gameControlToKeyNum(GC_JUMP)
	ctrl_inputs.spn[1], ctrl_inputs.spn[2] = input.gameControlToKeyNum(GC_SPIN)
	ctrl_inputs.cb1[1], ctrl_inputs.cb1[2] = input.gameControlToKeyNum(GC_CUSTOM1)
    ctrl_inputs.cb2[1], ctrl_inputs.cb2[2] = input.gameControlToKeyNum(GC_CUSTOM2)
    ctrl_inputs.cb3[1], ctrl_inputs.cb3[2] = input.gameControlToKeyNum(GC_CUSTOM3)
	ctrl_inputs.tfg[1], ctrl_inputs.tfg[2] = input.gameControlToKeyNum(GC_TOSSFLAG)

    ctrl_inputs.con[1], ctrl_inputs.con[2] = input.gameControlToKeyNum(GC_CONSOLE)
end)

-- actually make these global
rawset(_G, "ctrl_inputs", ctrl_inputs)

-- variables (derogatory)
local eventinfo = {}
local page = 1
local textprogress = {}
local MAXLINE = 22

local prev_page

-- event_CallDialog
-- Call open the dialog box for your event
-- Sets everything up for a new event
---@param event table Event information
local function event_CallDialog(event)
	if (type(event) ~= "table") then
		error("CALL_FAILED: no valid event table")
		return
	end
	if (eventinfo.current and eventinfo.current.active) then
		error("CALL_FAILED: event currently active")
		return
	end
	-- Reset page variables on a new event
	prev_page = nil
	page = 1
	eventinfo.current = event
end

local function hud_dialogdraw(v, p)
	if (eventinfo.current == nil) then return end
	if (eventinfo.current.active == false) then return end

	-- reset everything on a new page.
	if (prev_page ~= page) then
		prev_page = page
		-- make sure every text progress is 1
		for ln=1,6 do
			textprogress[ln] = 0
		end
	end

	-- draw the dialog box
	xMM_registry.drawWonderTextBox(v, 78, 35, 168, 70, 31)
	--v.drawFill(78, 35, 168, 70, 31)

	-- draw the character picture
	if eventinfo.current[page].charpic then
		v.draw(68, 78, v.cachePatch(eventinfo.current[page].charpic))
	end


	local words = {}

	for str in string.gmatch(eventinfo.current[page].line, "([^%s]+)") do
		table.insert(words, str)
	end

	local new_lines = {}
	local num_line = 1
	local num_char_per_line = 0

	for i = 1,#words do
		local word = new_lines[num_line] and " "..words[i] or words[i]
		num_char_per_line = num_char_per_line+string.len(word)
		if num_char_per_line > 22 then
			word = words[i]
			num_char_per_line = string.len(word)
			num_line = num_line+1
		end
		new_lines[num_line] = new_lines[num_line] and new_lines[num_line]..word or word
	end

	eventinfo.current[page].sep_line = new_lines

	-- Variable for the text height
	local y = 40
	for ln=1,#new_lines do
		-- self explanatory
		TBSlib.drawText(v, 'MA7LT', FixedDiv(86*FRACUNIT, FRACUNIT*9/10), FixedDiv(y*FRACUNIT, FRACUNIT*9/10), FRACUNIT*9/10, string.sub(new_lines[ln], 0, textprogress[ln]), 0, v.getColormap(TC_DEFAULT, 0), 0, 0, 0)
		--v.drawString(86, y, string.sub(sep_line[ln], 0, textprogress[ln]))

		--print(eventinfo.current.speedup)

		if (ln > 1) then
			-- wait your turn
			if (textprogress[ln-1] < #new_lines[ln-1]) then
				return
			end
			-- I control the speed at which the text draws!
			if (leveltime % 2 == 0)
			or (eventinfo.current.speedup == true) then
				textprogress[ln] = $ + 1
			end
		else
			-- :P
			if (leveltime % 2 == 0)
			or (eventinfo.current.speedup == true) then
				textprogress[ln] = $ + 1
			end
		end

		y = $ + 12
	end

	if eventinfo.current.speedup then
		eventinfo.current.speedup = false
	end

	-- we are at the end of the dialog. dismiss and clean up
	--eventinfo.current = nil
	--page = 0
	--textprogress = 0
end

-- input handler for dialog events
addHook("PlayerCmd", function(player, cmd)
	-- do we even have an event?
	if (eventinfo.current == nil) then return end
	if (eventinfo.current.active == false) then return end

	local buttons = cmd.buttons
	cmd.forwardmove = 0
	cmd.sidemove = 0

	-- funny shortcut
	local sep_line = eventinfo.current[page].sep_line

	if (eventinfo.current.inputblock == true) then
		if (buttons & BT_JUMP) and sep_line then

			-- ACTIONS:
			-- //While unfinished: speed up
			-- //Finished: Next page/Finish
			if (textprogress[#sep_line] >= #sep_line[#sep_line]) then
				if (page == #eventinfo.current) then
					eventinfo.current = nil
				else
					page = $ + 1
				end
			else
				eventinfo.current.speedup = true
			end

		elseif (buttons & BT_SPIN) then

			-- ACTIONS:
			-- DISMISS
			eventinfo.current = nil -- yes, dismiss the event
		end
	end

	cmd.buttons = 0
end)

-- create global functions
rawset(_G, "event_CallDialog", event_CallDialog)

-- add hud elements
hud.add(hud_dialogdraw, "game")

-- Print out a success message
print("Dialog System Initialized")

