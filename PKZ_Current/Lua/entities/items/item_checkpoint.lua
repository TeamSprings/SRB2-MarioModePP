
// New checkpoint system
// script by Krabs

addHook("TouchSpecial", function(post, toucher)
	local player = toucher.player

	if player.bot
	or player.starpostnum >= post.health then
		return true
	end

	if CV_FindVar("pkz_debug").value == 1
		print(player.starpostnum.." "..post.health)
		print("\x82".."hit starpost omg cool")
	end

	local coopstarposts = CV_FindVar("coopstarposts")
	if (coopstarposts.value >= 1 and gametype == GT_COOP and netgame) or splitscreen then //In splitscreen, we'll just have the checkpoint help both players.
		//print("coop starposts")
		for player2 in players.iterate do
			if player2 == player or player2.bot then continue end
			player2.starposttime = leveltime
			player2.starpostx = toucher.x >> FRACBITS
			player2.starposty = toucher.y >> FRACBITS
			player2.starpostz = post.z >> FRACBITS
			player2.starpostangle = post.angle + ANGLE_270
			player2.starpostscale = toucher.destscale

			if (post.flags2 & MF2_OBJECTFLIP) then
				player2.starpostscale = $ * -1
				player2.starpostz = $ + post.height >> FRACBITS
			end

			player2.starpostnum = post.health

			if coopstarposts == 2
			and (player2.playerstate == PST_DEAD or player2.spectator)
			and player2.lives then
				P_SpectatorJoinGame(player2)
			end
		end
	end

	if player.powers[pw_shield] == SH_NONE and PKZ_Table.disabledSkins[toucher.skin] == nil and player.mo and player.mo.valid then
		A_MarioPain(player.mo, SH_NONE, SH_BIGSHFORM, 5)
	end

	for i = 0,4 do
		local offset_x = (i<<4)-32
		local star_x = offset_x*cos(post.angle)
		local star_y = offset_x*sin(post.angle)

		local star_list_1 = P_SpawnMobjFromMobj(post, star_x, star_y, 37 << FRACBITS, MT_POPPARTICLEMAR)
		star_list_1.state = S_INVINCSTAR
		star_list_1.color = toucher.color
		star_list_1.fuse = TICRATE

		local star_list_2 = P_SpawnMobjFromMobj(post, star_x, star_y, 49 << FRACBITS, MT_POPPARTICLEMAR)
		star_list_2.state = S_INVINCSTAR
		star_list_2.color = toucher.color
		star_list_2.fuse = TICRATE
	end

	player.starposttime = leveltime
	player.starpostx = toucher.x >> FRACBITS
	player.starposty = toucher.y >> FRACBITS
	player.starpostz = post.z >> FRACBITS
	player.starpostangle = post.angle + ANGLE_270
	player.starpostscale = toucher.destscale


	if (post.flags2 & MF2_OBJECTFLIP) then
		player.starpostscale = $ * -1
		player.starpostz = $ + post.height >> FRACBITS
	end

	player.starpostnum = post.health
	S_StartSound(toucher, sfx_marioe)

	return true
end, MT_CHECKPOINTBAR)

addHook("MapThingSpawn", function(mo, mapthing)
	//Tag checking for UDMF/Binary -- added by Ace
	mo.health = mapthing.args[0] or mapthing.extrainfo
	if CV_FindVar("pkz_debug").value == 1
		print("\x82".."new post:".."\x80"..mo.health)
	end
end, MT_CHECKPOINTBAR)

addHook("MobjThinker", function(mo)
	if consoleplayer and consoleplayer.valid and consoleplayer.starpostnum >= mo.health and not (mo.flags2 & MF2_DONTDRAW) then
		if CV_FindVar("pkz_debug").value == 1
			print("\x82".."post gone:".."\x80"..mo.health)
		end
		mo.flags2 = $ | MF2_DONTDRAW
	end
end, MT_CHECKPOINTBAR)