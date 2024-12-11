--[[ 
		Pipe Kingdom Zone's Config - g_config.lua

Description:
All console variables

Contributors: Skydusk
@Team Blue Spring 2024
--]]

rawset(_G, "pkz_cdcamera", CV_RegisterVar({
	name = "pkz_cdcamera",
	defaultvalue = "off",
	flags = 0,
	PossibleValue = {off=0, on=1}
}))
rawset(_G, "pkz_speedist", CV_RegisterVar({
	name = "pkz_speedist",
	defaultvalue = "off",
	flags = 0,
	PossibleValue = {off=0, on=1}
}))
rawset(_G, "pkz_statchanges", CV_RegisterVar({
	name = "pkz_statchanges",
	defaultvalue = "off",
	flags = CV_NETVAR,
	PossibleValue = {off=0, on=1}
}))

rawset(_G, "pkz_first_time_prompt", CV_RegisterVar({
	name = "pkz_first_time_prompt",
	defaultvalue = "on",
	flags = 0,
	PossibleValue = {off=0, on=1}
}))

rawset(_G, "pkz_hudstyles", CV_RegisterVar({
	name = "pkz_hudstyles",
	defaultvalue = "srb2",
	flags = 0,
	PossibleValue = {srb2=0, maker=1, world=2, mario64=3, modern=4}
}))

rawset(_G, "pkz_charvoice", CV_RegisterVar({
	name = "pkz_charvoice",
	defaultvalue = "0",
	flags = CV_NETVAR,
	PossibleValue = {kart=0, modern=1}
}))

rawset(_G, "pkz_charthrowableenemies", CV_RegisterVar({
	name = "pkz_charthrowableenemies",
	defaultvalue = "1",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}))

rawset(_G, "pkz_charthrowableveg", CV_RegisterVar({
	name = "pkz_charthrowableveg",
	defaultvalue = "1",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}))

rawset(_G, "pkz_charsliding", CV_RegisterVar({
	name = "pkz_charsliding",
	defaultvalue = "1",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}))

rawset(_G, "pkz_charstomping", CV_RegisterVar({
	name = "pkz_charstomping",
	defaultvalue = "1",
	flags = CV_NETVAR,
	PossibleValue = {MIN = 1, MAX = 16}
}))

addHook("GameQuit", function(quit)
	if not quit then return end
	local finalpos = 0
	local forced_variables = {
		index = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		"pkz_cdcamera",
		"pkz_speedist",
		"pkz_statchanges",
		"pkz_hudstyles",
		"pkz_first_time_prompt",		
		"pkz_charvoice",
		"pkz_charthrowableenemies",
		"pkz_charthrowableveg",
		"pkz_charsliding",
		"pkz_charstomping",
	}	

	local check = io.openlocal("bluespring/mario/pkz_config.dat", "r+")
	if check then
		for line in check:lines() do
			local w = line:match("^([%w]+)")
			for k,v in ipairs(forced_variables) do
				if v == w then
					forced_variables.index[k] = tonumber(check:seek("cur"))+2
				end
			end
		end
		local finalpos = tonumber(check:seek("end"))
		check:close()
	end
	
    local file = io.openlocal("bluespring/mario/pkz_config.dat", "w")
	if file then
		for k,v in ipairs(forced_variables) do
			file:seek("set", forced_variables.index[k] == 1 and finalpos or forced_variables.index[k]-2)
			file:write(v+" "+CV_FindVar(v).value+"\n")
		end
		file:close()
	end
end)

local function LoadConfig()
	local loadfile = io.openlocal("bluespring/mario/pkz_config.dat", "r+")

	if loadfile then
		loadfile:seek("set", 0)
		for line in loadfile:lines() do
			local tab = {}
 
			for w in string.gmatch(line, "%S+") do
				table.insert(tab, w)
			end
		
			if tab and tab[1] and tab[2] then
				local cvar = CV_FindVar(tab[1])
				if cvar then
					CV_Set(cvar, tab[2])
				end
			else
				continue
			end
		end
		loadfile:close()
	end
end
LoadConfig()