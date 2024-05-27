
// Shelmet Power-Up
// Written by SMS Alfredo

addHook("MobjThinker", function(mobj)
	if mobj.reactiontime == 0 then
		mobj.reactiontime = $+1
		mobj.scale = $*5>>2
		mobj.scalespeed = $*2
		mobj.threshold = 1
	end
	mobj.sprite = SPR_SHMT
	if mobj.flags2 & MF2_AMBUSH then
		mobj.frame = 1
	else
		mobj.frame = 0
	end
	if not mobj.health then
		mobj.rollangle = $+ANGLE_11hh
		mobj.momz = $-(P_GetMobjGravity(mobj) >> 1)
		return
	end
	if mobj.tracer and mobj.tracer.valid and mobj.tracer.player then
		local mo = mobj.tracer
		local player = mobj.tracer.player

		if not mo.health then
			P_KillMobj(mobj)
			mobj.tracer = nil
			return
		end

		if player.speed and P_IsObjectOnGround(mo) then
			mobj.rollangle = $+(max(min(player.speed,32 << FRACBITS),6 << FRACBITS)*mobj.threshold<<5)
			if mobj.rollangle > ANGLE_11hh then
				mobj.threshold = -1
			elseif mobj.rollangle < -1*ANGLE_11hh then
				mobj.threshold = 1
			end
		else
			mobj.rollangle = $*99/100
		end
		mobj.destscale = mo.scale*5>>2
		mobj.angle = player.drawangle

		local multiplier = 16
		if ((mo.skin == "tails" and player.panim != PA_ABILITY) or mo.skin == "amy"
		or mo.skin == "fang") and not (player.pflags&PF_SPINNING)
		and not (player.pflags&PF_JUMPED and not (player.pflags&PF_NOJUMPDAMAGE)) then
			multiplier = 24
		end

		if (mo.eflags & MFE_VERTICALFLIP) then
			mobj.eflags = $|MFE_VERTICALFLIP
			mobj.flags2 = $|MF2_OBJECTFLIP
			mobj.z = mo.z + (mo.scale*multiplier)
		else
			mobj.eflags = $ & ~MFE_VERTICALFLIP
			mobj.flags2 = $ & ~MF2_OBJECTFLIP
			mobj.z = mo.z + mo.height - (mo.scale*multiplier)
		end

		if displayplayer.valid then
			P_MoveOrigin(mobj,mo.x-P_ReturnThrustX(nil,displayplayer.cmd.angleturn<<16,1),
			mo.y-P_ReturnThrustY(nil,displayplayer.cmd.angleturn<<16,1),mobj.z)
		else
			P_MoveOrigin(mobj,mo.x-P_ReturnThrustX(nil,mobj.player.cmd.angleturn<<16,1),
			mo.y-P_ReturnThrustY(nil,mobj.player.cmd.angleturn<<16,1),mobj.z)
		end
	end
end, MT_SHELMET)

addHook("MobjDeath", function(mobj)
	if mobj.tracer and mobj.tracer.valid and mobj.tracer.shelmet
	and mobj.tracer.shelmet == mobj then
		mobj.tracer.shelmet = nil
	end
	mobj.tracer = nil
	mobj.flags = $&~MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT&~MF_SPECIAL
	mobj.fuse = TICRATE*3
	P_SetObjectMomZ(mobj,4 << FRACBITS,false)
	S_StartSound(mobj, sfx_shlmls)
end, MT_SHELMET)

addHook("MobjDamage", function(target,inflictor,source,damage,damagetype)
	if target and target.valid and target.shelmet and target.shelmet.valid
	and target.player and not (target.player.powers[pw_shield] & SH_NOSTACK)
	and not (damagetype&DMG_DEATHMASK) then
		target.player.powers[pw_flashing] = TICRATE << 1
		target.shelmet.tracer = nil
		P_KillMobj(target.shelmet)
		target.shelmet = nil
		return true
	end
end, MT_PLAYER)

addHook("TouchSpecial", function(special, toucher)
	if not (toucher and toucher.valid and toucher.player
	and not toucher.player.bot) return end
	if toucher.shelmet and toucher.shelmet.valid then
		P_KillMobj(toucher.shelmet)
	end
	special.tracer = toucher
	toucher.shelmet = special
	special.flags = $|MF_NOGRAVITY|MF_NOCLIPHEIGHT&~MF_SPECIAL
	P_SetScale(special, special.scale*3>>1)
	if special.flags2&MF2_AMBUSH then
		S_StartSound(special, sfx_spnget)
	else
		S_StartSound(special, sfx_btlget)
	end
	return true
end, MT_SHELMET)

local shelmentbounce = function(toucher, special)
	if toucher and toucher.valid and toucher.player
	and toucher.shelmet and toucher.shelmet.valid
	and special and special.valid
	and special.z - special.scale <= toucher.z + toucher.height + toucher.scale*8
	and special.z + special.height + special.scale >= toucher.z + toucher.scale*-8
	and ((toucher.player.pflags&PF_SPINNING and P_IsObjectOnGround(toucher))
	or (special.z > toucher.z+(toucher.height/2) and not (toucher.eflags & MFE_VERTICALFLIP))
	or (special.z < toucher.z+(toucher.height/2) and toucher.eflags & MFE_VERTICALFLIP)) then
		if not special.health return false end

		local spike = false

		local i=0 while i<8 and special and special.valid
			local ghost = P_SpawnGhostMobj(special)
			P_SetObjectMomZ(ghost, FRACUNIT<<1, false)
			P_InstaThrust(ghost,ANGLE_45*i,4*ghost.scale)
			ghost.sprite = SPR_NSTR
			ghost.frame = 7
			ghost.scale = $/4
			ghost.fuse = TICRATE>>1
			i=$+1
		end

		if special.flags&MF_SHOOTABLE or special.flags & MF_MISSILE then
			P_DoSpring(toucher.shelmet, special)
			local flags = toucher.flags
			local momz = toucher.momz
			toucher.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING&~MF_SPECIAL
			P_SetObjectMomZ(toucher, 12*FRACUNIT, false)
			special.momz = toucher.momz
			toucher.momz = momz
			if toucher.eflags & MFE_VERTICALFLIP then
				special.z = toucher.z-special.height-toucher.scale
			else
				special.z = toucher.z+toucher.height+toucher.scale
			end
			toucher.flags = flags

			if special.flags & MF_MISSILE then
				special.target = toucher
				special.flags = $&~MF_NOGRAVITY
			end

			if toucher.shelmet.flags2 & MF2_AMBUSH and (special.flags & MF_SHOOTABLE or special.flags & MF_MISSILE) then
				if special.flags & MF_MISSILE then
					P_KillMobj(special)
				else
					P_DamageMobj(special)
				end
				S_StartSound(toucher, sfx_spnhit)
				spike = true
			end
		elseif not P_IsObjectOnGround(toucher) then
			P_DoSpring(toucher.shelmet, toucher)
		end

		S_StopSoundByID(toucher, sfx_btlht1)
		S_StopSoundByID(toucher, sfx_btlht2)
		S_StopSoundByID(toucher, sfx_btlht3)
		if not spike then
			if P_RandomChance(FRACUNIT/2) then
				S_StartSound(toucher, sfx_btlht1)
			elseif P_RandomChance(FRACUNIT/2) then
				S_StartSound(toucher, sfx_btlht2)
			else
				S_StartSound(toucher, sfx_btlht3)
			end
		end

		P_SetScale(toucher.shelmet, toucher.scale*5/4*3/2)
		return false
	end
end

addHook("ShouldDamage", shelmentbounce, MT_PLAYER)

addHook("PlayerCanDamage", function(player,mobj)
	return shelmentbounce(player.mo,mobj)
end)
