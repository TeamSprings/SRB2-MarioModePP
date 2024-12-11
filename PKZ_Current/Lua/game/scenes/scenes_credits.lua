local creditstime = 0

local CRE_IMAGE = 1
local CRE_HEADER = 2
local CRE_ANIMATE = 4
local CRE_PAUSE = 8
local CRE_BGFADETOBLACK = 16
local CRE_FINISHLEVEL = 32


local SideBySideArt = {
  [2] = "MarioSonc",


}

local creditsgpx = {
      {str = "- PIPE KINDOM ZONE -", z = 0, flags = CRE_HEADER},
      {str = "pipe towers zone v2", z = 16, flags = 0},
      {str = "- Blue Spring Team -", z = 35, flags = CRE_HEADER, color = SKINCOLOR_BLUE},
      {str = "- Art -", z = 63, flags = CRE_HEADER},
      {str = "Ace Lite\nMotorRoach\nKamiJojo\nBendedede\nClone Fighter\nOthius\nOrdomandalore\nJatDaGamer", z = 81, flags = 0},
      {str = "- Programming -", z = 163, flags = CRE_HEADER},
      {str = "Ace Lite\nLat'\nZipper\nSMS Alfredo\nRadicalicious\nKrabs\nAshi", z = 181, flags = 0},
      {str = "- Map Design -", z = 263, flags = CRE_HEADER},
      {str = "Fawfulfan\nAce Lite\nKumin\nOthius", z = 281, flags = 0},
      {str = "- Audio Design -", z = 363, flags = CRE_HEADER},
      {str = "VAdaPEGA\nRaze\nAce Lite\ncookiefonster", z = 381, flags = 0},
      {str = "- Playtesting -", z = 463, flags = CRE_HEADER|CRE_BGFADETOBLACK},
      {str = "Ace Lite\nMotorRoach\nKamiJoJo\nKumin\nOthius\nRaze\nLazyMK\nDakras\nOrdomandalore\nZipper\nBendedede\nLach\nRevan\nZeno\nAshi\nLat'", z = 481, flags = 0},
      {str = "- Special Thanks -", z = 763, flags = CRE_HEADER},
      {str = "Lach\n- Help -\n \nMrMasato\nDashlilhog\nnythedragon\nBuggieTheBug\n-Team Springs' Discord Feedback-\n \nCobaltBW\n- Audio Feedback -\n \ntoaster\n- Code Feedback -\n \nSonic Team Junior\n- Creating the game -\n \nDoom Legacy Team\n- Creating the Source Port -\n \nId Software\n- Creating the Engine -", z = 781, flags = 0},
      {str = "Fawfulfan\nPermission to edit Pipe Towers Zone\ncreator of Pipe Towers Zone", z = 1070, flags = 0},
      {str = "And You!\nthank you for playing!", z = 1200, flags = 0},
      {str = "BTSLOGO", z = 1300, flags = CRE_PAUSE|CRE_IMAGE},
      {str = "", z = 1700, flags = CRE_FINISHLEVEL},
}


local credits = false

hud.add(function(v, p)
	if not credits then return end

	local timerz = (((5*leveltime) >> 3) % 2100)-300

	for k,cred in ipairs(creditsgpx) do
		if cred.flags & CRE_BGFADETOBLACK and timerz > cred.z then
			v.fadeScreen(0xFA00, min((timerz-cred.z)/3, 31))
		end

		if cred.flags & CRE_FINISHLEVEL and timerz > cred.z then
			G_ExitLevel()
		end

		if timerz < cred.z-250 or timerz > cred.z+250 then continue end

		if cred.flags & CRE_IMAGE then
			local z = cred.z-timerz
			local patch = v.cachePatch(cred.str)
			v.draw(160-patch.width>>1, z, patch)
		else
			local z = cred.z-timerz
			local font = cred.flags & CRE_HEADER and "MA17LT" or "MA15LT"
			local color = cred.color or (cred.flags & CRE_HEADER and SKINCOLOR_MARIOPUREGOLDFONT or SKINCOLOR_MARIOPUREWHITEFONT)

			TBSlib.drawLines(v, font, 160 << FRACBITS, z << FRACBITS, FRACUNIT, string.upper(cred.str), 0, v.getColormap(TC_DEFAULT, color), "center", 10)
		end

	end

	local contspd = (leveltime << 1) % 200
	v.draw(0, 0+contspd, v.cachePatch("WONDSIDEBAR1"), V_SNAPTOLEFT|V_SNAPTOTOP)
	v.draw(320, 0+contspd, v.cachePatch("WONDSIDEBAR2"), V_SNAPTORIGHT|V_SNAPTOTOP)

end, "game")

