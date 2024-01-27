/* 
		Pipe Kingdom Zone's Scenes  - game_scenes.lua

Description:
Various scene thinkers, functions

Contributors: Ace Lite, Ashi
@Team Blue Spring 2024
*/

//
// CUT SCENES
//


// Cut Scenes for invidiual scenarios
// Scenes - Ending of the level

local ed_data = {
	-- level ending
	flagdown = 0,
	flagup = 0,
	activefw = 0, -- fireworks
	sumflg = 0, -- flag check
	scoretable = {
		{maxh = 75 << FRACBITS, minh = -1 << FRACBITS, score = 100},
		{maxh = 150 << FRACBITS, minh = 75 << FRACBITS, score = 200},
		{maxh = 200 << FRACBITS, minh = 150 << FRACBITS, score = 400},
		{maxh = 300 << FRACBITS, minh = 200 << FRACBITS, score = 800},
		{maxh = 380 << FRACBITS, minh = 300 << FRACBITS, score = 1000},
		{maxh = 430 << FRACBITS, minh = 380 << FRACBITS, score = 2000},
		{maxh = 497 << FRACBITS, minh = 430 << FRACBITS, score = 4000},
		{maxh = 513 << FRACBITS, minh = 497 << FRACBITS, score = 8000}
	}	
}



addHook("MapLoad", function()
	ed_data.flagdown = 0
	ed_data.flagup = 0
	ed_data.activefw = 0
	ed_data.sumflg = 0	
end)

local FLG_ACTIVATED = 1
local FLG_SKIP = 2

// Mobj Collider
// Checks if player touches pole

addHook("MobjCollide", function(actor, mo)
	if not mo.player then return end 
	if (actor.z + actor.height) > mo.z and mo.player.pflags &~ PF_FINISHED then
		
		if mo.mariomode.goalpole_noclip then
			return false
		end		
		
		if mo.mariomode.goalpole == nil then
			mo.mariomode.goalpole = FLG_ACTIVATED
			mo.mariomode.goalpole_angle = actor.angle
			for i = 1,8 do
				if (actor.z+ed_data.scoretable[i].maxh >= mo.z) and (actor.z+ed_data.scoretable[i].minh < mo.z)
					actor.bscore = ed_data.scoretable[i].score
				end
			end
			A_AddNoMPScore(mo, actor.bscore, 2)
			if actor.spawnpoint and actor.spawnpoint.args[1] then
				mo.mariomode.goalpole = $|FLG_SKIP
			end
		end
	end
end, MT_ENDINGPOLEFORFLAG)

// Player.Camera Cutaway
// Slide by Pole, Force movement into castle and Stop characters movement in Singleplayer 

addHook("PlayerThink", function(player)
	if not (player.playerstate ~= PST_DEAD and mariomode) then return end
	if player.mo.mariomode and player.mo.mariomode.goalpole then
		local mar_data = player.mo.mariomode
		player.mo.angle = mar_data.goalpole_angle
		if mar_data.goalpole_timer == nil then
			mar_data.goalpole_timer = 1
			player.powers[pw_nocontrol] = 250
			player.mo.flags = $ | MF_NOGRAVITY
			if mar_data.goalpole_timer <= 150 then
				player.mo.state = S_PLAY_RIDE
			end
		end
		
		if mar_data.goalpole_timer > 0 then
			mar_data.goalpole_timer = $ + 1
		end		
		
		if mar_data.goalpole_timer > 0 and mar_data.goalpole_timer <= 35 then
			S_FadeMusic(0, 2*MUSICRATE, player)
			player.mo.momz = 0
			player.mo.momx = 0
			player.mo.momy = 0
		end

		if mar_data.goalpole_timer == 35 then
			S_StartSound(player.mo, sfx_mariol)
			S_StartSound(player.mo, sfx_marion)
		end

		if mar_data.goalpole_timer >= 35 and mar_data.goalpole_timer < 150 then
			ed_data.flagdown = 1
			player.mo.momz = -5 << FRACBITS
			player.mo.momx = 0
			player.mo.momy = 0
		end
		
		if mar_data.goalpole_timer == 150 and (player.mo.mariomode.goalpole & FLG_SKIP) then
			player.mo.mariomode.goalpole = 0
			mar_data.goalpole_noclip = true
			P_DoPlayerFinish(player)
			S_ResumeMusic(player)
			return
		else
			if mar_data.goalpole_timer >= 150 and mar_data.goalpole_timer < 200 then
				mar_data.goalpole_noclip = true
				player.mo.flags = $ &~ MF_NOGRAVITY
				if player.mo.state ~= S_PLAY_WALK
					player.mo.state = S_PLAY_WALK
				end
				player.mo.momx = 10*cos(player.mo.angle)
				player.mo.momy = 10*sin(player.mo.angle)			
			end
		
			if mar_data.goalpole_timer == 149 then
				local flagcamera = P_SpawnMobj(camera.x, camera.y, camera.z, MT_POPPARTICLEMAR)
				flagcamera.state = S_INVISIBLE
				flagcamera.angle = camera.angle
				flagcamera.height = camera.height
				flagcamera.radius = camera.radius
				flagcamera.scale = player.camerascale
				flagcamera.polecamera = true			
				mar_data.goalpole_ease_origin = camera.aiming
				mar_data.goalpole_ease_prog = 0
				player.awayviewaiming = camera.aiming
				player.awayviewmobj = flagcamera
				player.awayviewtics = 300
			end
		
			if mar_data.goalpole_timer == 200 then
				if leveltime < TICRATE*150
					ed_data.activefw = 1
				end
				ed_data.flagup = 1
			end
		
			if mar_data.goalpole_timer > 175 then
				PKZ_Table.hideHud = true
				if mar_data.goalpole_ease_prog < FRACUNIT then
					mar_data.goalpole_ease_prog = $ + FRACUNIT/54
				end
				player.awayviewaiming = ease.outsine(mar_data.goalpole_ease_prog, mar_data.goalpole_ease_origin, ANG10)
			end

			if mar_data.goalpole_timer == 225 then
				ed_data.sumflg = 1
				ed_data.flagup = 0
				ed_data.flagdown = 0
			end
		
			if mar_data.goalpole_timer >= 200 and mar_data.goalpole_timer < 215 then
				player.mo.state = S_PLAY_JUMP
				P_InstaThrust(player.mo, player.mo.angle, 10 << FRACBITS)
				player.mo.momz = 7 << FRACBITS
			end		


			if mar_data.goalpole_timer == 275 then
				player.mo.mariomode.goalpole = 0
				P_DoPlayerFinish(player)
			end
		
			if mar_data.goalpole_timer == 300 then
				ed_data.activefw = 0
				S_ResumeMusic(player)
			end
		end
		
	end
end, MT_PLAYER)

// Flag goes down too mobo and other goes up

addHook("MobjThinker", function(actor) 
	if ed_data.flagdown == 1
		actor.momz = -5 << FRACBITS
	else
		actor.momz = 0
	end
end, MT_PTZFLAG)

addHook("MobjThinker", function(actor) 
	if ed_data.flagup == 1 and ed_data.sumflg ~= 1
		actor.flags2 = $ &~ MF2_DONTDRAW 
		actor.momz = 4 << FRACBITS
	elseif ed_data.flagup == 0 and ed_data.sumflg == 1
		actor.momz = 0		
	else
		actor.momz = 0
		actor.flags2 = $|MF2_DONTDRAW 		
	end	
end, MT_NSMBCASTLEFLAG2)

// Launch Damn Fireworks

local function launchfireworks(actor) 
	actor.scale = 3 << FRACBITS
	if ed_data.activefw ~= 1 then
		actor.state = S_INVISIBLE
	else
		if P_RandomChance(FRACUNIT/3) and not (leveltime % 60) then
			actor.state = actor.info.spawnstate
			S_StartSound(nil, sfx_mariom)
			local spparticle = P_SpawnMobjFromMobj(actor, 0,0,0, MT_POPPARTICLEMAR)
			spparticle.state = S_NEWPICARTICLE
			spparticle.sprite = SPR_PUP2
			spparticle.scale = actor.scale/2
			spparticle.fuse = 8
			spparticle.color = SKINCOLOR_GOLD
			spparticle.blendmode = AST_TRANSLUCENT
			spparticle.spparticle = 1
		end
	end
end

addHook("MobjThinker", launchfireworks, MT_MARFIREWORK1)
addHook("MobjThinker", launchfireworks, MT_MARFIREWORK2)

// -------------
// Start of PKZ1



// Transition between PKZ1A and PKZ1B




// Bowser

// Theater


addHook("MobjCollide", function(a, tm)
	if not tm.player then return end
	local save_data = PKZ_Table.getSaveData()
	if save_data.unlocked & PKZ_Table.unlocks_flags["KEY"] and (a.spawnpoint.extrainfo or a.spawnpoint.args[0]) then
		if a.activated ~= true then
			if a.spawnpoint.extrainfo > 0 or 0 < a.spawnpoint.args[0] then
				local xdkey = P_SpawnMobjFromMobj(tm, 0,0,0, MT_MARBWKEY)
				xdkey.momz = 8*FRACUNIT
				xdkey.fuse = 32
				xdkey.scale = tm.scale
				xdkey.flags = $ &~ MF_SPECIAL
			end
			a.flags = $ | MF_NOCLIP &~ MF_SOLID
			if a.keyhole[1] ~= nil then
				P_KillMobj(a.keyhole[1])
				P_KillMobj(a.keyhole[2])
			end
			a.activated = true			
		end
	else
		a.timemessage = true
		a.lastplayer = tm
		if a.countdown == nil or a.countdown < 1 then
			a.countdown = TICRATE
		end		
		return true
	end
end, MT_MARIOSTARDOOR)

addHook("MobjCollide", function(a, tm)
	if not tm.player then return end
	if PKZ_Table.dragonCoins >= a.requirement then
		if a.activated ~= true
			a.activated = true
		end
		return false
	else
		a.timemessage = true
		a.lastplayer = tm
		if a.countdown == nil or a.countdown < 1  
			a.countdown = TICRATE
		end
		return true		
	end
end, MT_MARIODOOR)


addHook("MobjThinker", function(a)
	local sp = a.spawnpoint
	a.dis = P_AproxDistance(a.x - sp.x << FRACBITS, a.y - sp.y << FRACBITS)
	if a.activated == true then
		if a.dis < FixedMul(64 << FRACBITS, a.scale)
			a.momx = 3*cos(a.angle)
			a.momy = 3*sin(a.angle)
		else
			A_ForceStop(a)
			return
		end
	end
	if a.countdown ~= nil then
		if a.timemessage == true and a.countdown == 34 then
			CONS_Printf(a.lastplayer.player, "To open this door you need key")
			a.timemessage = false			
		end
		if a.countdown >= 0 
			a.countdown = $-1
		end
	end
end, MT_MARIOSTARDOOR)

addHook("MobjThinker", function(a)
	local sp = a.spawnpoint
	
	a.doorease = a.doorease and $ or 0
	
	if a.activated == true then
		
		if a.timer == nil then
			a.timer = 50	
		end
		if a.timer > 0 then
			a.timer = $-1	
		end
		
		if a.timer == 0
			a.activated = false
			a.timer = nil			
		end
		
		if a.doorease < FRACUNIT then
			a.doorease = $+FRACUNIT >> 5
		end
	else
		if a.doorease > 0 then
			a.doorease = $-FRACUNIT >> 5
		end		
	end
	
	a.angle = ease.outquad(a.doorease, sp.angle, sp.angle-90)*ANG1
	
	if a.countdown ~= nil then
		if a.timemessage == true and a.countdown == 34 then
			CONS_Printf(a.lastplayer.player, "You lack sufficient amount of Dragon Coins to open this door")
			a.timemessage = false		
		end
		if a.countdown >= 0 and a.countdown ~= nil then
			a.countdown = $-1
		end
	end
end, MT_MARIODOOR)

//Camera movement

addHook("MobjThinker", function(actor)
	if actor.polecamera == true then
		if actor.cameratics == nil then
			actor.cameratics = 1
		end
		
		if actor.cameratics > 0 then
			actor.cameratics = $ + 1
		end		
		
		
		if actor.cameratics >= 25 and actor.cameratics <= 75 then
			P_InstaThrust(actor, actor.angle, -5 << FRACBITS)
			if actor.momz < 15 << FRACBITS then
				actor.momz = $ + 2 << FRACBITS
			else
				actor.momz = 15 << FRACBITS	
			end
		end
		
		if actor.cameratics == 76 then
			actor.momz = 0
			actor.momx = 0
			actor.momy = 0
		end		
		
	end
end, MT_POPPARTICLEMAR)

addHook("MapLoad", function()	
	PKZ_Table.hideHud = false
end)


/*
	Dialog system

	(C) 2022 by Ashi
*/
-- logging purposes
print("Initializing Dialog System...")

-- variables (derogatory)
local eventinfo = {}
local page = 1
local textprogress = {}
local MAXLINE = 22

mobjinfo[MT_TOAD].health = 1
mobjinfo[MT_TOAD].deathstate = mobjinfo[MT_TOAD].spawnstate
mobjinfo[MT_TOAD].flags = $|MF_SPECIAL &~ MF_NOBLOCKMAP|MF_NOCLIP

-- testing command
COM_AddCommand("test_dialog", function(player)
	-- testing dialog table
	local testevent = {
		active = true,
		inputblock = true;
		[1] = {
			charpic = "TOADY",
			line = "It is meeeeee!            - Grand Dad."
		},
		[2] = {
			charpic = "INFOBLOCK",
			line = "Here is the second page for this dialog box. I didn't care about making sure words didn't get cut up on this one. but hey. It's still cool"
		},
		[3] = {
			charpic = "INFOBLOCK",
			line = "Did you know that pressing spin at the end of the dialog box will go back a page? bet you didn't! try it at the end of this page!"
		}
	}
	event_CallDialog(testevent)
end)

local prev_page

-- event_CallDialog
-- Call open the dialog box for your event
-- Sets everything up for a new event
---@param event table Event information
local function event_CallDialog(event)
	if (type(event) != "table") then
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
	if (prev_page != page) then
		prev_page = page
		-- make sure every text progress is 1
		for ln=1,6 do
			textprogress[ln] = 0
		end
	end
	
	-- draw the dialog box
	v.drawFill(78, 35, 168, 70, 31)

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
		TBSlib.fontdrawer(v, 'MA7LT', FixedDiv(86*FRACUNIT, FRACUNIT*9/10), FixedDiv(y*FRACUNIT, FRACUNIT*9/10), FRACUNIT*9/10, string.sub(new_lines[ln], 0, textprogress[ln]), 0, v.getColormap(TC_DEFAULT, 0), 0, 0, 0)		
		//v.drawString(86, y, string.sub(sep_line[ln], 0, textprogress[ln]))

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

	-- we are at the end of the dialog. dismiss and clean up
	--eventinfo.current = nil
	--page = 0
	--textprogress = 0
end

-- input handler for dialog events
addHook("KeyDown", function(key)
	-- do we even have an event?
	if (eventinfo.current == nil) then return end
	if (eventinfo.current.active == false) then return end

	/*funny shortcut*/ local sep_line = eventinfo.current[page].sep_line

	-- do we brick wall the controller?
	if (eventinfo.current.inputblock == true) then
		for i=1,2 do
			if (key.num == ctrl_inputs.jmp[i]) then -- is the player pressing jump?
				if (textprogress[#sep_line] >= #sep_line[#sep_line]) then -- are we finished displaying text?
					if (page == #eventinfo.current) then -- Is this the end of the event?
						eventinfo.current = nil -- yes, dismiss the event
						return true
					else
						page = $ + 1 -- no, progress a page
					end
					return true
				end
				return true
			elseif (key.num == ctrl_inputs.spn[i]) then -- is the player pressing spin?
				if not(sep_line) then return true end
				if (textprogress[#sep_line] >= #sep_line[#sep_line]) -- If we are at the end of a dialog box
				and (eventinfo.current.speedup == false) then -- don't want to accidentally trigger it
					if (page != 1) then -- and we are not on page 1
						page = $ - 1 -- go back a page
						return true
					end
					return true
				else
					eventinfo.current.speedup = true
					return true
				end
				return true
			end

			-- *holding sonic* >:P no move. only dialog.
			if (key.num == ctrl_inputs.up[i] or key.num == ctrl_inputs.down[i])
			or (key.num == ctrl_inputs.left[i] or key.num == ctrl_inputs.right[i])
			-- no custom ability either. only dialog. >:P
			or (key.num == ctrl_inputs.cb1[i] or key.num == ctrl_inputs.cb2[i])
			or (key.num == ctrl_inputs.cb3[i]) then
				return true
			end
		end
	end
end)

addHook("KeyUp", function(key)
	-- do we even have an event?
	if (eventinfo.current == nil) then return end
	if (eventinfo.current.active == false) then return end

	if (eventinfo.current.inputblock == true) then
		for i=1,2 do
			if (key.num == ctrl_inputs.spn[i]) then -- Is the player releasing spin?
				eventinfo.current.speedup = false -- set speedup to false
			end
		end
	end
end)

-- create global functions
rawset(_G, "event_CallDialog", event_CallDialog)

-- add hud elements
hud.add(hud_dialogdraw, "game")

-- Print out a success message
print("Dialog System Initialized")




--
-- STARTING CUTSCENES
--

local current_start_cutscene = 0

local cutscene_time = {
	100, TICRATE, 100
}

-- MT_GENERALWAYPOINT
// mapthing.args[0] = Pathway ID
// mapthing.args[1] = Point ID
// mapthing.args[2] = Easing
// mapthing.args[3] = Duration(1 = TICRATE)
// mapthing.args[4] = Enum{Waypoint(0), Starting point(1), Ending point(2)}
// mapthing.args[6] = Flags WC_*
// mapthing.args[7] = Action
// mapthing.args[8] = var1
// mapthing.args[9] = var2

-- container, path, way, a_x, a_y, a_z, a_angle, a_roll, a_pitch, a_options, a_stringoptions
local start_cutscenes = {
	[1] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1
		if timer == cutscene_time[1] then
			local x,y,z = camera.x, camera.y, camera.z
			P_SetOrigin(mo, mo.x-128*cos(mo.angle), mo.y-128*sin(mo.angle), mo.z+820 << FRACBITS)		
			mo.mariomode.temp_cam_path = {}
			TBSWaylib.slotPathway(mo.mariomode.temp_cam_path, 1)
			for i = 1,5 do
				local dist = 528-i*8
				TBSWaylib.addWaypoint(mo.mariomode.temp_cam_path, 1, i, 
				mo.x-dist*cos(mo.angle + ANGLE_90*i), mo.y-dist*sin(mo.angle + ANGLE_90*i), mo.z-(250 << FRACBITS)*i, mo.angle + ANGLE_90*i, 0, 0,
				{[0] = 1, i, 7, 50-i*10, 0, 0, 0, 0, 0}, {nil, nil})
			end
			TBSWaylib.activateCamera(a, mo.mariomode.temp_cam_path, 1, 1, 1)
			S_PauseMusic(p)
		end
		if timer <= 69 then
			TBSWaylib.DeactivateCamera()
			mo.mariomode.temp_cam_path = nil
			TBSWaylib.lerpCameraToPlayerPosition(mo, camera, FRACUNIT/28)			
		else
			TBSWaylib.SelfPathwayCameraController(camera, false, false)
		end
		if P_IsObjectOnGround(mo) then
			hud.mariomode.title_ticker[#p] = 200
			S_SetMusicPosition(0)
			S_ResumeMusic(p)
			p.tempmariomode.cutscenetimer = nil
			p.realtime = 0
			return
		end		
		if mo.state ~= S_PLAY_FALL
			mo.state = S_PLAY_FALL
		end
		mo.momx = 8*cos(mo.angle)
		mo.momy = 8*sin(mo.angle)
		p.realtime = 0
	end,
	[2] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1
		if timer < TICRATE-10 then
			mo.momx = 20*cos(mo.angle)
			mo.momy = 20*sin(mo.angle)
			mo.momz = 20 << FRACBITS
			mo.state = S_PLAY_PAIN
			p.drawangle = mo.angle+ANG20*timer
		end
		if timer == 1 then
			hud.mariomode.title_ticker[#p] = 200
			p.tempmariomode.cutscenetimer = nil
			return			
		end
	end,
	[3] = function(p, mo)
		local timer = p.tempmariomode.cutscenetimer+1		
		if timer == cutscene_time[1] then
			P_SetOrigin(mo, mo.x-900*cos(mo.angle), mo.y-900*sin(mo.angle), mo.z+400 << FRACBITS)
			mo.momx = 30*cos(mo.angle)
			mo.momy = 30*sin(mo.angle)			
		end
		if mo.state ~= S_PLAY_ROLL
			mo.state = S_PLAY_ROLL
		end		
		if P_IsObjectOnGround(mo) then
			mo.state = S_PLAY_SKID
			hud.mariomode.title_ticker[#p] = 0
			p.tempmariomode.cutscenetimer = nil
			return
		end
	end,
}

addHook("PlayerSpawn", function(p)
	if p.starpostnum > 0 then return end
	local num = mapheaderinfo[gamemap].startingcutscenenum or 0 
	--print(num, mapheaderinfo[gamemap].startingcutscenenum)
	p.tempmariomode.cutscenetimer = cutscene_time[tonumber(num)] or 0
	current_start_cutscene = tonumber(num)
end)

addHook("PlayerThink", function(p)
	if p.tempmariomode.cutscenetimer then
		p.tempmariomode.cutscenetimer = $-1	
	
		if p.mo and p.mo.valid and start_cutscenes[current_start_cutscene] then
			start_cutscenes[current_start_cutscene](p, p.mo)
		end	
	else
		return
	end
end)

local creditstime = 0

local CRE_IMAGE = 1
local CRE_HEADER = 2
local CRE_ANIMATE = 4
local CRE_PAUSE = 8
local CRE_BGFADETOBLACK = 16
local CRE_FINISHLEVEL = 32

local creditsgpx = {
      {str = "- PIPE KINDOM ZONE -", z = 0, flags = CRE_HEADER},
      {str = "pipe towers zone v2", z = 16, flags = 0},	  
      {str = "- Blue Spring Team -", z = 35, flags = CRE_HEADER, color = SKINCOLOR_BLUE},
      {str = "- Art -", z = 63, flags = CRE_HEADER},
      {str = "Ace Lite\nMotorRoach\nKamiJojo\nBendedede\nClone Fighter\nOthius\nOrdomandalore", z = 81, flags = 0},  
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

local SideBySideArt = {
  [2] = "MarioSonc",
  
  
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
	
			TBSlib.breakfontdrawer(v, font, 160 << FRACBITS, z << FRACBITS, FRACUNIT, string.upper(cred.str), 0, v.getColormap(TC_DEFAULT, color), "center", 10)
		end
		
	end

	local contspd = (leveltime << 1) % 200
	v.draw(0, 0+contspd, v.cachePatch("WONDSIDEBAR1"), V_SNAPTOLEFT|V_SNAPTOTOP)
	v.draw(320, 0+contspd, v.cachePatch("WONDSIDEBAR2"), V_SNAPTORIGHT|V_SNAPTOTOP)

end, "game")

