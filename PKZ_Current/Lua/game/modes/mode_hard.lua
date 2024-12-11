

local hard_mode_flats = {
	["PTZWCT3"] = "MAROWRGA",
	["PTZWCT5"] = "MAROWRGB",
	["MAROWRG1"] = "MAROWRGC",
	["MAROWRG2"] = "MAROWRGD",
	["MAROWRG3"] = "MAROWRGE",
	["MAROWRG4"] = "MAROWRGF",
	["MAROWRG5"] = "MAROWRGG",
	["MAROWRG6"] = "MAROWRGH",
	["MARGR1F"] = "MAHGR1F",
	["MARGR2F"] = "MAHGR2F",
	["MARGR3F"] = "MAHGR3F",
	["MARGR4F"] = "MAHGR4F",
	["MARGRA1"] = "MAHGRA1",
	["MARGRA2"] = "MAHGRA2",
	["MARGRAF"] = "MAHGRAF",
	["MARGRAS"] = "MAHGRAS",
	["MARG1F1"] = "MAHG1F1",
	["MARG1F3"] = "MAHG1F3",
	["MARG1F4"] = "MAHG1F4",
	["MARG1F5"] = "MAHG1F5",
	["MARG1F6"] = "MAHG1F6",
	["MARG1F7"] = "MAHG1F7",
	["MARG1F8"] = "MAHG1F8",
	["MARG1F9"] = "MAHG1F9",
	["MARG1FA"] = "MAHG1FA",
	["MARG1FB"] = "MAHG1FB",
	["MARG1FC"] = "MAHG1FC",
	["MARG1FE"] = "MAHG1FE",
	["MARG1FF"] = "MAHG1FF",
	["MARG1FG"] = "MAHG1FG",
}

local hard_mode_textur = {}

local hard_mode_replacements = {
	[MT_MGREENKOOPA] = function(a)
		a.color = P_RandomRange(0,1) and SKINCOLOR_RED or SKINCOLOR_SAPPHIRE
		a.extravalue1 = 2
		local head = P_SpawnMobjFromMobj(a, 0,0,0, MT_OVERLAY)
		head.target = a
		head.state = S_INVISIBLE
		head.sprite = SPR_MKOP
		head.frame = H
		head.color = a.color
	end,
	[MT_GOOMBA] = function(a)
		--local galoom = P_SpawnMobjFromMobj(a, 0,0,0, MT_GALOOMBA)
		--galoom.scale = a.scale
		--P_RemoveMobj(a)
		a.scale = $+FRACUNIT
		a.health = 2
	end,
	[MT_BLUEGOOMBA] = function(a)
		local buzz = P_SpawnMobjFromMobj(a, 0,0,0, MT_BUZZYBEETLE)
		buzz.scale = a.scale+FRACUNIT/4
		P_RemoveMobj(a)
	end,
	--[MT_BLUEGOOMBA] = function(a)
	--	P_SpawnMobjFromMobj(a, 0,0,0, MT_BUZZYBEETLE)
	--	P_RemoveMobj(a)
	--end,
	[MT_MARIOBUSH1] = function(a) a.color = SKINCOLOR_RED end,
	[MT_MARIOBUSH2] = function(a) a.color = SKINCOLOR_RED end,
	[MT_MARIOBUSH] = function(a) a.color = SKINCOLOR_ORANGE end,
	[MT_MAR64TREE] = function(a) a.color = P_RandomRange(0,1) and SKINCOLOR_ORANGE or SKINCOLOR_RED end,
}


--[[
local cheats_transfer = {
	["evil"] = function()
		if netgame and consoleplayer ~= server then
			CONS_Printf(consoleplayer, "\x85".."WARNING:".."\x80".."This cheat is only available to host.")
			return
		end
		xMM_registry.evil = true
		xMM_registry.cheatrecord = true

		if not netgame then
			G_SetCustomExitVars(gamemap, 1)
			G_ExitLevel()
			TBS_Menu:toggleMenu(false)
		end

		print("\x85".."NOTE:".."\x80".."Evil setting is on, prepare for cosequences. Requires restart of map.")
	end,
	["hard"] = function()
		if netgame and consoleplayer ~= server then
			CONS_Printf(consoleplayer, "\x85".."WARNING:".."\x80".."This cheat is only available to host.")
			return
		end
		xMM_registry.hardMode = true
		if not netgame then
			G_SetCustomExitVars(gamemap, 1)
			G_ExitLevel()
			TBS_Menu:toggleMenu(false)
		end
		print("\x85".."NOTE:".."\x80".."Hard difficulty is on. Requires restart of map.")
	end,
	["nosonicrings"] = function()
		xMM_registry.nosonicrings = xMM_registry.nosonicrings ~= true and true or false
	end
}



addHook("MapLoad", function()
	if #hard_mode_textur == 0 then
		hard_mode_textur = {
		[R_TextureNumForName("PTZWCT3")] = R_TextureNumForName("MAROWRGA"),
		[R_TextureNumForName("PTZWCT5")] = R_TextureNumForName("MAROWRGB"),
		[R_TextureNumForName("MAROWRG1")] = R_TextureNumForName("MAROWRGC"),
		[R_TextureNumForName("MAROWRG2")] = R_TextureNumForName("MAROWRGD"),
		[R_TextureNumForName("MAROWRG3")] = R_TextureNumForName("MAROWRGE"),
		[R_TextureNumForName("MAROWRG4")] = R_TextureNumForName("MAROWRGF"),
		[R_TextureNumForName("MAROWRG5")] = R_TextureNumForName("MAROWRGG"),
		[R_TextureNumForName("MAROWRG6")] = R_TextureNumForName("MAROWRGH"),
		[R_TextureNumForName("MARGR1F")] = R_TextureNumForName("MAHGR1F"),
		[R_TextureNumForName("MARGR2F")] = R_TextureNumForName("MAHGR2F"),
		[R_TextureNumForName("MARGR3F")] = R_TextureNumForName("MAHGR3F"),
		[R_TextureNumForName("MARGR4F")] = R_TextureNumForName("MAHGR4F"),
		[R_TextureNumForName("MARGRA1")] = R_TextureNumForName("MAHGRA1"),
		[R_TextureNumForName("MARGRA2")] = R_TextureNumForName("MAHGRA2"),
		[R_TextureNumForName("MARGRAF")] = R_TextureNumForName("MAHGRAF"),
		[R_TextureNumForName("MARGRAS")] = R_TextureNumForName("MAHGRAS"),
		}
	end

	if xMM_registry.evil then
		local exchangetable = {}

		for mobj in mobjs.iterate() do
			if mobj.type ~= MT_COIN then continue end
			table.insert(exchangetable, mobj)
		end

		for k,v in ipairs(exchangetable) do
			P_RemoveMobj(v)
		end
	end

	if xMM_registry.hardMode then
		local exchangetable = {}

		for mobj in mobjs.iterate() do
			if not hard_mode_replacements[mobj.type] then continue end
			table.insert(exchangetable, mobj)
		end

		for k,v in ipairs(exchangetable) do
			hard_mode_replacements[v.type](v)
		end

		for s in sectors.iterate do
			if hard_mode_flats[s.ceilingpic] then
				s.ceilingpic = hard_mode_flats[s.ceilingpic]
			end
			if hard_mode_flats[s.floorpic] then
				s.floorpic = hard_mode_flats[s.floorpic]
			end
		end

		for k,v in ipairs(hard_mode_textur) do
			print(k+" "+v)
		end

		for side in sides.iterate do
			if hard_mode_textur[side.toptexture] ~= nil then
				side.toptexture = hard_mode_textur[side.toptexture]
			end
			if hard_mode_textur[side.midtexture] ~= nil then
				side.midtexture = hard_mode_textur[side.midtexture]
			end
			if hard_mode_textur[side.bottomtexture] ~= nil then
				side.bottomtexture = hard_mode_textur[side.bottomtexture]
			end
		end




addHook("PlayerSpawn", function(p)
	if gamemap == 1 then
		CONS_Printf(p, "To get into PKZ, press 'H' to access it.")
	end
	if not xMM_registry.evil then return end
	p.lives = 1
	p.rings = 0
end)

addHook("MobjDeath", function(a)
	if not xMM_registry.evil then return end
	if not (a.player and a.player.valid) then return end
	a.player.lives = 0
	a.player.rings = 0
end, MT_PLAYER)
]]