--[[
		Pipe Kingdom Zone's Mobjs - state_general.lua

Description:
Mobjinfo of objects and their states. Either Lua-fied or custom from very beginning

Contributors: Skydusk, Zipper(Bowser)
@Team Blue Spring 2024
--]]


states[S_MARIODOOR] = {
	sprite = SPR_0MDR,
	frame = B|FF_PAPERSPRITE,
}

states[S_SMALLOILLFLARE] = {
	sprite = SPR_OILF,
	frame = B|FF_TRANS90|FF_FULLBRIGHT,
	tics = -1,
}

states[S_MARIOSTARDOOR] = {
	sprite = SPR_0MDR,
	frame = A|FF_PAPERSPRITE,
}

states[S_POPPARTICLEMAR] = {
	sprite = SPR_BEEM,
	frame = A|FF_ANIMATE,
	tics = 15,
	var1 = 4,
	var2 = 3,
	nextstate = S_NULL
}

states[S_MARIOPUFFPART] = {
	sprite = SPR_PFUF,
	frame = A|FF_ANIMATE,
	tics = 18,
	var1 = 5,
	var2 = 3,
	nextstate = S_NULL
}

states[S_MARIOPUFFPARTFASTER] = {
	sprite = SPR_PFUF,
	frame = A|FF_ANIMATE,
	tics = 6,
	var1 = 5,
	var2 = 1,
	nextstate = S_NULL
}

states[S_INVINCSTAR] = {
	sprite = SPR_MINP,
	frame = A|FF_ANIMATE|FF_FULLBRIGHT|TR_TRANS20,
	tics = 14,
	var1 = 6,
	var2 = 2,
	nextstate = S_NULL
}

states[S_MARIOSTARS] = {
	sprite = SPR_MSTA,
	frame = A,
}

states[S_FIREBALLDEAD] = {
	sprite = SPR_MFBD,
	frame = A|FF_ANIMATE,
	tics = 20,
	var1 = 9,
	var2 = 2,
	nextstate = S_NULL
}

states[S_MMFIREBALLBLAST] = {
	sprite = SPR_MMFIREBALLBLAST,
	frame = A|FF_ANIMATE,
	tics = 14,
	var1 = 13,
	var2 = 1,
	nextstate = S_NULL
}

states[S_MARSMOKEPARTICLE] = {
	sprite = SPR_MSMD,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	tics = 18,
	var1 = 5,
	var2 = 3,
	nextstate = S_NULL
}

states[S_EATINGPARTICLE] = {
	sprite = SPR_EATP,
	frame = A|FF_ANIMATE,
	tics = 12,
	var1 = 3,
	var2 = 3,
	nextstate = S_NULL
}

states[S_PICKUPPARTICLE] = {
	sprite = SPR_PUP1,
	frame = A|FF_ANIMATE|FF_TRANS10,
	tics = 15,
	var1 = 5,
	var2 = 3,
	nextstate = S_NULL
}

states[S_MMPICKUPLAYER1] = {
	sprite = SPR_MMPICKINGUP,
	frame = 0|FF_ANIMATE|FF_ADD|FF_TRANS10,
	tics = 34,
	var1 = 16,
	var2 = 2,
	nextstate = S_NULL
}

states[S_MMPICKUPLAYER2] = {
	sprite = SPR_MMPICKINGUP,
	frame = 18|FF_ANIMATE|FF_ADD|FF_TRANS30,
	tics = 36,
	var1 = 17,
	var2 = 2,
	nextstate = S_NULL
}

states[S_MMDEBRIESNEWBRICK1] = {
	sprite = SPR_MMBRICK1,
	frame = 0|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK1
}

states[S_MMDEBRIESNEWBRICK2] = {
	sprite = SPR_MMBRICK2,
	frame = 0|FF_ANIMATE,
	tics = 15,
	var1 = 13,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK2
}

states[S_MMDEBRIESNEWBRICK3] = {
	sprite = SPR_MMBRICK3,
	frame = 0|FF_ANIMATE,
	tics = 15,
	var1 = 13,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK3
}

states[S_MMDEBRIESNEWBRICK4] = {
	sprite = SPR_MMBRICK4,
	frame = 0|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK4
}

states[S_MMDEBRIESNEWBRICK5] = {
	sprite = SPR_MMBRICK5,
	frame = 0|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK5
}

states[S_MMDEBRIESNEWBRICK6] = {
	sprite = SPR_MMBRICK6,
	frame = 0|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMDEBRIESNEWBRICK6
}

states[S_MMICEDEBRIES1] = {
	sprite = SPR_MMICEDEBRIES1,
	frame = 0|FF_TRANS30|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMICEDEBRIES1
}

states[S_MMICEDEBRIES2] = {
	sprite = SPR_MMICEDEBRIES2,
	frame = 0|FF_TRANS30|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMICEDEBRIES2
}

states[S_MMICEDEBRIES3] = {
	sprite = SPR_MMICEDEBRIES3,
	frame = 0|FF_TRANS30|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMICEDEBRIES3
}

states[S_MMICEDEBRIES4] = {
	sprite = SPR_MMICEDEBRIES4,
	frame = 0|FF_TRANS30|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMICEDEBRIES4
}

states[S_MMICEDEBRIES5] = {
	sprite = SPR_MMICEDEBRIES5,
	frame = 0|FF_TRANS30|FF_ANIMATE,
	tics = 30,
	var1 = 28,
	var2 = 1,
	nextstate = S_MMICEDEBRIES5
}

states[S_MMSHELLPARTICLE] = {
	sprite = SPR_MMSHELLPARTICLE,
	frame = 0|FF_TRANS20|FF_ADD|FF_ANIMATE,
	tics = 24,
	var1 = 22,
	var2 = 1,
	nextstate = S_MMSHELLPARTICLE
}

states[S_SM64SPARKLES] = {
	sprite = SPR_MMPARTICLES,
	frame = A|FF_ANIMATE|FF_TRANS20|FF_ADD,
	tics = 15,
	var1 = 4,
	var2 = 3,
	nextstate = S_NULL
}

states[S_WIILIKEINVFOG] = {
	sprite = SPR_MMPARTICLES,
	frame = 11|FF_TRANS70|FF_ADD,
	tics = 32,
	nextstate = S_NULL
}

states[S_SM64SPARKLESSINGLE] = {
	sprite = SPR_MMPARTICLES,
	frame = 5|FF_ANIMATE|FF_TRANS20|FF_ADD,
	tics = 15,
	var1 = 4,
	var2 = 3,
	nextstate = S_NULL
}

states[S_SM64BGSTAR] = {
	sprite = SPR_MMPARTICLES,
	frame = 14|FF_ANIMATE|FF_TRANS70|FF_ADD,
	tics = 9,
	var1 = 2,
	var2 = 3,
	nextstate = S_NULL
}

states[S_YOSHIBIRDAMB] = {
	sprite = SPR_0AMB,
	frame = B|FF_ANIMATE,
	tics = 20,
	var1 = 4,
	var2 = 4,
	nextstate = S_YOSHIBIRDAMB
}

states[S_MARWISPAMB] = {
	sprite = SPR_0AMB,
	frame = A|FF_ADD|FF_FULLBRIGHT,
}

states[S_NEWPICARTICLE] = {
	sprite = SPR_PUP2,
	frame = A|FF_TRANS30,
}

states[S_PRESSUREPARTICLEMAR] = {
	sprite = SPR_PARB,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	tics = 15,
	var1 = 4,
	var2 = 3,
	nextstate = S_NULL
}

states[S_HAMMERX] = {
	sprite = SPR_HAMM,
	frame = A,
	tics = -1,
	nextstate = S_HAMMERX
}

states[S_GOOMBA1] = {
	sprite = SPR_GOOM,
	frame = FF_ANIMATE|A,
	tics = 24,
	var1 = 3,
	var2 = 6,
	nextstate = S_GOOMBA1
}

states[S_BLUEGOOMBA1] = {
	sprite = SPR_BGOM,
	frame = FF_ANIMATE|A,
	tics = 24,
	var1 = 3,
	var2 = 6,
	nextstate = S_BLUEGOOMBA1
}

states[S_GOOMBA_KNOCK] = {
	sprite = SPR_GOOM,
	frame = G,
	tics = 32,
	nextstate = S_POPPARTICLEMAR
}

states[S_BLUEGOOMBA_KNOCK] = {
	sprite = SPR_BGOM,
	frame = G,
	tics = 32,
	nextstate = S_POPPARTICLEMAR
}

states[S_BOMBOHM1] = {
	sprite = SPR_64BH,
	frame = FF_ANIMATE|A,
	tics = 24,
	var1 = 3,
	var2 = 6,
	nextstate = S_BOMBOHM1
}

states[S_BOMBOHMEXP] = {
	sprite = SPR_64BH,
	frame = D,
	tics = 50,
	nextstate = S_BOMBOHMEXP
}

states[S_MARIOOCTODADSPAWN] = {
	sprite = SPR_BLOP,
	frame = A,
	tics = 4,
	action = A_look,
	var1 = (5024*65535)+1,
	nextstate = S_MARIOOCTODADSPAWN
}

states[S_WELLEXCUSEMEPRINCESS] = {
	sprite = SPR_BLOP,
	frame = A,
	tics = 100,
	nextstate = S_NULL
}

states[S_MARIOOCTODAD] = {
	sprite = SPR_BLOP,
	frame = A,
	tics = 10,
	nextstate = S_MARIOOCTODAD
}

states[S_BULLETBILL] = {
	sprite = SPR_BILL,
	frame = A,
	tics = 4,
	nextstate = S_BULLETBILL
}

states[S_HOMINGBULLETBILL] = {
	sprite = SPR_BILL,
	frame = A,
	tics = 4,
	nextstate = S_HOMINGBULLETBILL
}

states[S_EXPBULLETBILL] = {
	sprite = SPR_BILL,
	frame = A,
	tics = 1,
	nextstate = S_NULL
}

states[S_MARIOMINE1] = {
	sprite = SPR_MAMI,
	frame = A
}

states[S_BOWSER_FIRE] = {
	sprite = SPR_BFBR,
	frame = A|FF_FULLBRIGHT|FF_ANIMATE,
	tics = -1,
	nextstate = S_BOWSER_FIRE,
	var1 = 15,
	var2 = 1
}

states[S_BOWSER_FIRE_DIE] = {
	sprite = SPR_BFBR,
	frame = A|FF_FULLBRIGHT|FF_ANIMATE,
	tics = 1,
	nextstate = S_XPLD1,
	action = A_NapalmScatter,
	var1 = MT_CYBRAKDEMON_NAPALM_FLAMES+(8<<16),
	var2 = 128+32<<16
}

states[S_BOWSER_GOOMBALL] = {
	sprite = SPR_GBAL,
	frame = A,
	tics = -1,
	nextstate = S_BOWSER_GOOMBALL
}

states[S_BOWSER_GOOMBALL_DIE] = {
	sprite = SPR_GBALL,
	frame = A,
	tics = 1,
	nextstate = S_XPLD1
}

states[S_BOWSER_STAND] = {
	sprite = SPR_BOWS,
	frame = A,
	tics = 35,
	nextstate = S_BOWSER_THINK1,
	action = A_FaceTarget
}

states[S_BOWSER_THINK1] = {
	sprite = SPR_BOWS,
	frame = A,
	tics = 4,
	nextstate = S_BOWSER_THINK2,
}

states[S_BOWSER_THINK2] = {
	sprite = SPR_BOWS,
	frame = A,
	tics = 10,
	nextstate = S_BOWSER_THINK3,
	action = A_ResetBowser
}

states[S_BOWSER_THINK3] = {
	sprite = SPR_BOWS,
	frame = A,
	tics = 20,
	nextstate = S_BOWSER_THINK3,
	action = function(actor, var1, var2)
		if not actor.target then actor.state = S_BOWSER_THINK2 end
		local dist = R_PointToDist2(actor.x, actor.y, actor.target.x, actor.target.y)
		local attacks = {S_BOWSER_BOUNCE1, S_BOWSER_BALL1}
		if dist < 256*FRACUNIT then
			attacks = {S_BOWSER_FIRE1}
		elseif actor.enraged then
			attacks = {S_BOWSER_PUNCH0, S_BOWSER_BOUNCE1}
		end
		actor.state = attacks[P_RandomRange(1, #attacks)]
	end
}

states[S_BOWSER_FIRE1] = {
	sprite = SPR_BOWS,
	frame = B,
	tics = 2,
	nextstate = S_BOWSER_FIRE2,
	action = A_PlaySound,
	var1 = sfx_bwatk4
}

states[S_BOWSER_FIRE2] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 2,
	nextstate = S_BOWSER_FIRE2EX,
	action = A_FlameCharge,
	var1 = 60,
	var2 = 60
}

states[S_BOWSER_FIRE2EX] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 0,
	nextstate = S_BOWSER_FIRE3PRE,
	action = A_Repeat,
	var1 = 17,
	var2 = S_BOWSER_FIRE2

}

states[S_BOWSER_FIRE3PRE] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 0,
	nextstate = S_BOWSER_FIRE3,
	action = A_PrepareRepeat,
}

states[S_BOWSER_FIRE3] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 2,
	nextstate = S_BOWSER_FIRE3EX,
	action = A_UltraFireShot,
	var1 = 30 + MT_CYBRAKDEMON_FLAMESHOT<<FRACBITS,
	var2 = -30
}

states[S_BOWSER_FIRE3EX] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 0,
	nextstate = S_BOWSER_GLOAT,
	action = A_Repeat,
	var1 = TICRATE,
	var2 = S_BOWSER_FIRE3
}

states[S_BOWSER_PUNCH0] = {
	sprite = SPR_BOWS,
	frame = P,
	tics = TICRATE/2,
	nextstate = S_BOWSER_PUNCH1,
	action = A_ResetBowser
}

states[S_BOWSER_PUNCH1] = {
	sprite = SPR_BOWS,
	frame = P,
	tics = TICRATE/2,
	nextstate = S_BOWSER_PUNCH2,
	action = A_PlaySound,
	var1 = sfx_bwchrg
}

states[S_BOWSER_PUNCH2] = {
	sprite = SPR_BOWS,
	frame = Q,
	tics = TICRATE,
	nextstate = S_BOWSER_PUNCH3,
}

states[S_BOWSER_PUNCH3] = {
	sprite = SPR_BOWS,
	frame = R,
	tics = 11,
	nextstate = S_BOWSER_PUNCH4,
	action = function(actor, var1, var2)
		A_FaceTarget(actor,nil, nil)
		S_StartSound(actor, sfx_brakrl)
	end
}

states[S_BOWSER_PUNCH4] = {
	sprite = SPR_BOWS,
	frame = R,
	tics = 1,
	nextstate = S_BOWSER_PUNCH4,
}

states[S_BOWSER_PUNCH4EX] = {
	sprite = SPR_BOWS,
	frame = O,
	tics = 1,
	nextstate = S_BOWSER_PUNCH4EX,
	action = A_CheckGround,
	var1 = S_BOWSER_PUNCH5

}

states[S_BOWSER_PUNCH5] = {
	sprite = SPR_BOWS,
	frame = R,
	tics = TICRATE,
	nextstate = S_BOWSER_PUNCH6,
	action = A_FaceTarget
}

states[S_BOWSER_PUNCH6] = {
	sprite = SPR_BOWS,
	frame = A,
	tics = 5,
	nextstate = S_BOWSER_GLOAT,
}

states[S_BOWSER_BOUNCE1] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = 2*TICRATE/3,
	nextstate = S_BOWSER_BOUNCE2,
	action = A_FaceTarget,
	var1 = 2,
	var2 = 7
}

states[S_BOWSER_BOUNCE2] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = 2*TICRATE/3,
	nextstate = S_BOWSER_BOUNCE3,
	action = A_FaceTarget,
	var1 = 2,
	var2 = 4
}

states[S_BOWSER_BOUNCE3] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = 2*TICRATE/3,
	nextstate = S_BOWSER_BOUNCE4,
	action = A_FaceTarget,
	var1 = 2,
	var2 = 2
}

states[S_BOWSER_BOUNCE4] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = 10,
	nextstate = S_BOWSER_BOUNCE5,
	action = function (actor, var1, var2)
		A_FaceTarget(actor)
		actor.dashcount = $ + 1
		actor.momz = 25 * FRACUNIT + (4 * FRACUNIT * actor.dashcount)
		P_InstaThrust(actor, actor.angle, 9*FRACUNIT)
	end,
	var1 = 2,
	var2 = 2
}

states[S_BOWSER_BOUNCE5] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = -1,
	nextstate = S_BOWSER_BOUNCE5,
	var1 = 2,
	var2 = 2
}

local CONST_FLOOR_FALL_TICS = 5 * TICRATE

states[S_BOWSER_BOUNCE6] = {
	sprite = SPR_BOWS,
	frame = I|FF_ANIMATE,
	tics = TICRATE/8,
	nextstate = S_BOWSER_GLOAT,
	action = function(actor, var1, var2)
		S_StartSound(actor, sfx_s3k5f)
		P_StartQuake(24*FRACUNIT, TICRATE/2)
		A_NapalmScatter(actor, MT_TNTDUST+16<<FRACBITS, 128+16*FRACUNIT)
		A_Boss3Shot(actor, 32, S_SHOCKWAVEBOWSER, FRACUNIT+FRACUNIT/4)
		A_FaceTarget(actor)

		if actor.breakfloor == nil or actor.breakfloor == false and not actor.floor_tics then
			if actor.from_val then
				if not actor.floor_i then
					actor.floor_i = actor.from_val
					actor.floor_tics = CONST_FLOOR_FALL_TICS
					actor.breakfloor = false
				else
					actor.floor_i = $+1
					actor.floor_tics = CONST_FLOOR_FALL_TICS
					actor.breakfloor = false
				end
			else
				actor.breakfloor = true
			end
		end

		if actor.dashcount < (3 + (actor.info.spawnhealth - actor.health) / 4) then
			actor.state = S_BOWSER_BOUNCE4
		end
	end,
	var1 = 2,
	var2 = 2
}


states[S_BOWSER_BALL1] = {
	sprite = SPR_BOWS,
	frame = S,
	tics = TICRATE/2,
	nextstate = S_BOWSER_BALL2,
	action = A_PlaySound,
	var1 = sfx_bwglt2
}

states[S_BOWSER_BALL2] = {
	sprite = SPR_BOWS,
	frame = S|FF_ANIMATE,
	tics = TICRATE+TICRATE/4,
	nextstate = S_BOWSER_BALL3,
	action = function(actor, var1, var2)
		local bball = P_SpawnMobj(actor.x, actor.y, actor.z + FixedMul(actor.scale, actor.height) + 4*FRACUNIT, MT_BOWSER_GOOMBALL)
		bball.scale = FRACUNIT/8
		bball.destscale = FRACUNIT
		bball.flags = $ | MF_NOGRAVITY
		actor.tracer = bball
		bball.target = actor
		bball.tracer = actor.target
	end,
	var1 = 3,
	var2 = 4
}

states[S_BOWSER_BALL3] = {
	sprite = SPR_BOWS,
	frame = B,
	tics = 3*TICRATE/4,
	nextstate = S_BOWSER_GLOAT,
	action = function(actor, var1, var2)
		S_StartSound(actor, sfx_bwatk2)
		A_FaceTarget(actor)
		local bb = actor.tracer
		bb.flags = $ & ~MF_NOGRAVITY
		bb.momx = 6*cos(actor.angle)
		bb.momy = 6*sin(actor.angle)
		bb.momz = 14*FRACUNIT
		actor.tracer = nil
	end,
	var1 = 3,
	var2 = 4
}

states[S_BOWSER_FIRE2EX] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 0,
	nextstate = S_BOWSER_FIRE3PRE,
	action = A_Repeat,
	var1 = 17,
	var2 = S_BOWSER_FIRE2

}

states[S_BOWSER_FIRE3PRE] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 0,
	nextstate = S_BOWSER_FIRE3,
	action = A_PrepareRepeat,
}

states[S_BOWSER_FIRE3] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 2,
	nextstate = S_BOWSER_FIRE3EX,
	action = A_UltraFireShot,
	var1 = 30 + MT_CYBRAKDEMON_FLAMESHOT<<FRACBITS,
	var2 = -30
}

states[S_BOWSER_RAGE1] = {
	sprite = SPR_BOWS,
	frame = S|FF_ANIMATE,
	tics = 1,
	nextstate = S_BOWSER_RAGE2,
	action = A_PlaySound,
	var1 = sfx_bwchrg
}

states[S_BOWSER_RAGE2] = {
	sprite = SPR_BOWS,
	frame = S|FF_ANIMATE,
	tics = 2*TICRATE,
	nextstate = S_BOWSER_RAGE3,
	action = A_ResetBowser,
	var1 = 3,
	var2 = 4
}

states[S_BOWSER_RAGE3] = {
	sprite = SPR_BOWS,
	frame = S|FF_ANIMATE,
	tics = 1,
	nextstate = S_BOWSER_RAGE4,
	action = A_PlaySound,
	var1 = sfx_bwschg
}

states[S_BOWSER_RAGE4] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 2,
	nextstate = S_BOWSER_RAGE5,
	action = A_FlameCharge,
	var1 = 60,
	var2 = 60
}

states[S_BOWSER_RAGE5] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 0,
	nextstate = S_BOWSER_RAGE6,
	action = A_Repeat,
	var1 = 17,
	var2 = S_BOWSER_RAGE4

}

states[S_BOWSER_RAGE6PRE] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 0,
	nextstate = S_BOWSER_RAGE6,
	action = A_PrepareRepeat,
}

states[S_BOWSER_RAGE6] = {
	sprite = SPR_BOWS,
	frame = D,
	tics = 4,
	nextstate = S_BOWSER_RAGE6EX,
	action = function(actor, var1, var2)
		A_FaceTarget(actor)
		S_StartSound(actor, sfx_koopfr)
		local off = 30*FRACUNIT
		local fire = P_SpawnMobjFromMobj(actor, FixedMul(cos(actor.angle), off), FixedMul(sin(actor.angle), off), 2*actor.height/3, MT_BOWSER_FIRE)
		fire.scale = FRACUNIT/4
		fire.destscale = FRACUNIT
		fire.momz = 16*FRACUNIT
		S_StartSound(actor, fire.info.seesound)

		local angoff = actor.angle + P_RandomRange(-15,15) * ANG1
		fire.momx = 20*cos(angoff)
		fire.momy = 20*sin(angoff)
	end
}

states[S_BOWSER_RAGE6EX] = {
	sprite = SPR_BOWS,
	frame = C,
	tics = 0,
	nextstate = S_BOWSER_STAND,
	action = A_Repeat,
	var1 = 3*TICRATE/4,
	var2 = S_BOWSER_RAGE6
}



states[S_BOWSER_GLOAT] = { --it's more of a grunt, but the sprites are placeholders
	sprite = SPR_BOWS,
	frame = S|FF_ANIMATE,
	tics = 3*TICRATE,
	nextstate = S_BOWSER_STAND,
	var1 = 3,
	var2 = 4
}

states[S_BOWSER_FLINCH1] = {
	sprite = SPR_BOWS,
	frame = P,
	tics = 55,
	nextstate = S_BOWSER_STAND
}

states[S_BOWSER_FLINCH2] = {
	sprite = SPR_BOWS,
	frame = H,
	tics = 90,
	nextstate = S_BOWSER_STAND
}

states[S_BOWSER_LAUNCH] = {
	sprite = SPR_BOWS,
	frame = L,
	tics = 2*TICRATE,
	nextstate = S_BOWSER_STAND
}

states[S_BOWSER_FALL1] = {
	sprite = SPR_BOWS,
	frame = M,
	tics = 10,
	nextstate = S_BOWSER_FALL1EX,
}

states[S_BOWSER_FALL1EX] = {
	sprite = SPR_BOWS,
	frame = M,
	tics = 1,
	nextstate = S_BOWSER_FALL1,
	action = A_CheckGround,
	var1 = S_BOWSER_FALL2,
	var2 = 1
}

states[S_BOWSER_FALL2] = {
	sprite = SPR_BOWS,
	frame = N,
	tics = TICRATE,
	nextstate = S_BOWSER_STAND,
	action = function(actor,var1,var2)
		if (actor.health <= 0) then
			actor.state = S_BOWSER_DEFEAT1
		else
			A_Boss3Shot(actor, 32, S_SHOCKWAVEBOWSER, FRACUNIT+FRACUNIT/4)
		end
	end
}

states[S_BOWSER_JUMP1] = {
	sprite = SPR_BOWS,
	frame = O,
	tics = 5,
	nextstate = S_BOWSER_JUMP2,
}

--he instantly goes to stand states if I use only one state
states[S_BOWSER_JUMP2] = {
	sprite = SPR_BOWS,
	frame = O,
	tics = 1,
	nextstate = S_BOWSER_JUMP2,
	action = A_CheckGround,
	var1 = S_BOWSER_STAND,
	var2 = 1
}

states[S_BOWSER_DEFEAT1] = {
	sprite = SPR_BOWS,
	frame = N,
	tics = TICRATE/2,
	nextstate = S_BOWSER_DEFEAT2,
}

states[S_BOWSER_DEFEAT2] = {
	sprite = SPR_BOWS,
	frame = N,
	tics = 2*TICRATE,
	nextstate = S_BOWSER_DEFEAT3,
	action = A_PlaySound,
	var1 = sfx_bwdfet
}

states[S_BOWSER_DEFEAT3] = {
	sprite = SPR_BOWS,
	frame = N,
	tics = -1,
	nextstate = S_BOWSER_DEFEAT3,
	action = function(a, var1, var2)
		if a.type == MT_BOWSER then
			local cutscene = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_CUTSCENEJUNKMARIO)
			cutscene.state = S_BOWSER_DEFEAT3
			cutscene.ticScene = 0
			P_RemoveMobj(a)
		end
	end,
}

-- Bomb Mace used for exploading Browser's URL locator

states[S_BOMBMACE1] = {
	sprite = SPR_BMCE,
	frame = A,
	tics = -1,
	nextstate = S_BOMBMACE1,
}

states[S_BOMBMACE2] = {
	sprite = SPR_BARX,
	frame = A|FF_ANIMATE,
	tics = 8,
	nextstate = S_BOMBMACE3,
	var1 = 4,
	var2 = 2
}

states[S_BOMBMACE3] = {
	sprite = SPR_NULL,
	frame = A,
	tics = 8*TICRATE,
	action = A_SetObjectFlags,
	var1 = MF_NOGRAVITY,
	nextstate = S_BOMBMACE4,
}

states[S_BOMBMACE4] = {
	sprite = SPR_NULL,
	frame = A,
	tics = 1,
	action = A_SpawnFreshCopy,
	nextstate = S_NULL,
}

states[S_REDCOINCIRCLE] = {
	sprite = SPR_RCIR,
	frame = FF_PAPERSPRITE|A,
	tics = 1,
	nextstate = S_REDCOINCIRCLE
}

states[S_REDCOINCIRCLED] = {
	sprite = SPR_RCIR,
	frame = FF_PAPERSPRITE|A,
	tics = 1,
	nextstate = S_NULL
}

states[S_BLOCKQUE] = {
	sprite = SPR_M1BL,
	frame = FF_PAPERSPRITE|FF_ANIMATE|A,
	tics = 28,
	var1 = 27,
	var2 = 1,
	nextstate = S_BLOCKQUE
}

states[S_BLOCKEXC] = {
	sprite = SPR_M7BL,
	frame = FF_PAPERSPRITE|FF_ANIMATE|A,
	tics = 28,
	var1 = 27,
	var2 = 1,
	nextstate = S_BLOCKEXC
}

states[S_BLOCKRAND] = {
	sprite = SPR_C1BL,
	frame = A|FF_PAPERSPRITE|FF_TRANS30,
}

states[S_BLOCKNOTE] = {
	sprite = SPR_NO1B,
	frame = FF_PAPERSPRITE|FF_ANIMATE|A,
	tics = 28,
	var1 = 6,
	var2 = 4,
	nextstate = S_BLOCKNOTE
}

states[S_BLOCKVIS] = {
	sprite = SPR_NULL,
	frame = FF_PAPERSPRITE|A,
}
states[S_BLOCKEMP] = {
	sprite = SPR_M4BL,
	frame = FF_PAPERSPRITE|A,
	nextstate = S_BLOCKEMP
}

states[S_BLOCKTOPBUT] = {
	sprite = SPR_M2BL,
	frame = FF_PAPERSPRITE|A,
	nextstate = S_BLOCKTOPBUT
}

states[S_WIDEWINGS] = {
	sprite = SPR_MAP1,
	frame = FF_ANIMATE|A,
	tics = 20,
	var1 = 4,
	var2 = 4,
	nextstate = S_WIDEWINGS
}

states[S_SMALLWINGS] = {
	sprite = SPR_MAP2,
	frame = FF_ANIMATE|A,
	tics = 20,
	var1 = 4,
	var2 = 4,
	nextstate = S_SMALLWINGS
}

states[S_BOWSERAIRSHIP] = {
	sprite = SPR_3SIP,
	frame = FF_ANIMATE|A,
	tics = 4,
	var1 = 0,
	var2 = 4,
	nextstate = S_BOWSERAIRSHIP
}


states[S_NEWPUMAMAR] = {
	sprite = SPR_PUMA,
	frame = M|FF_FULLBRIGHT,
	tics = -1,
}

states[S_SHOCKWAVEBOWSER] = {
	sprite = SPR_HSMW,
	frame = FF_FULLBRIGHT|FF_ADD|FF_PAPERSPRITE|FF_ANIMATE|A,
	tics = 6,
	var1 = 2,
	var2 = 2,
	nextstate = S_SHOCKWAVEBOWSER
}

-- GALOOMBA
states[S_GALOOMBASTILL] = {
	sprite = SPR_91GA,
	frame = A,
	tics = 1,
	action = A_Look,
	nextstate = S_GALOOMBASTILL,
}

states[S_GALOOMBAWALK] = {
	sprite = SPR_91GA,
	frame = A|FF_ANIMATE,
	tics = 128,
	var1 = 3,
	var2 = 4,
	nextstate = S_GALOOMBAWALK,
}

states[S_GALOOMBATURNUPSIDEDOWN] = {
	sprite = SPR_91GA,
	frame = A|FF_ANIMATE|FF_VERTICALFLIP,
	tics = 128,
	var1 = 3,
	var2 = 4,
	nextstate = S_GALOOMBASTILL,
}

states[S_GALOOMBAFALLING] = {
	sprite = SPR_91GA,
	frame = E,
	tics = 1,
	action = function(a, var1, var2)
		if P_IsObjectOnGround(a) then a.state = S_GALOOMBASTILL end
	end,
	nextstate = S_GALOOMBAFALLING,
}

states[S_PARAGALOOMBAPARA] = {
	sprite = SPR_91GA,
	frame = E,
	tics = 1,
	nextstate = S_PARAGALOOMBAPARA,
}

states[S_PARAGALOOMBAWINGS] = {
	sprite = SPR_91GA,
	frame = A|FF_ANIMATE,
	tics = 128,
	var1 = 3,
	var2 = 4,
	nextstate = S_GALOOMBAWALK,
}

-- LAKITU


states[S_LAKITUSSTILL] = {
	sprite = SPR_0LAK,
	frame = A,
	tics = 1,
	action = A_Look,
	nextstate = S_LAKITUSSTILL,
}

states[S_LAKITUSFLY] = {
	sprite = SPR_0LAK,
	frame = A,
	tics = 50,
	nextstate = S_LAKITUSSTILL,
}

states[S_LAKITUSAIM] = {
	sprite = SPR_0LAK,
	frame = B,
	tics = 10,
	nextstate = S_LAKITUSSHOOT,
}

states[S_LAKITUSSHOOT] = {
	sprite = SPR_0LAK,
	frame = C,
	tics = 15,
	nextstate = S_LAKITUSSTILL,
}

local function P_MarioEnemyDeathThinker(a, var1, var2)
	if a.target then
		a.momx = 12*cos(a.target.angle)
		a.momy = 12*sin(a.target.angle)
	else
		a.momx = 12*cos(a.angle)
		a.momy = 12*sin(a.angle)
	end
	a.momz = 10*FRACUNIT
	a.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING &~ MF_NOGRAVITY
end

states[S_LAKITUSDEAD] = {
	sprite = SPR_0LAK,
	frame = A|FF_VERTICALFLIP,
	tics = 50,
	action = P_MarioEnemyDeathThinker,
	nextstate = S_NULL,
}

-- BOO

states[S_BOOSTILL] = {
	sprite = SPR_64BO,
	frame = A|FF_TRANS40|FF_ADD,
	tics = 1,
	action = function(a, var1, var2)
		A_Look(a)
		a.frame = (a.extravalue1*2)|FF_TRANS50|FF_ADD
	end,
	nextstate = S_BOOSTILL,
}

states[S_BOOCHARGE1] = {
	sprite = SPR_64BO,
	frame = A|FF_TRANS40|FF_ADD|FF_ANIMATE,
	tics = 8,
	var1 = 1,
	var2 = 4,
	nextstate = S_BOOCHARGE1,
}

states[S_BOOCHARGE2] = {
	sprite = SPR_64BO,
	frame = C|FF_TRANS40|FF_ADD|FF_ANIMATE,
	tics = 8,
	var1 = 1,
	var2 = 4,
	nextstate = S_BOOCHARGE2,
}

states[S_BOOCHARGE3] = {
	sprite = SPR_64BO,
	frame = E|FF_TRANS40|FF_ADD|FF_ANIMATE,
	tics = 8,
	var1 = 1,
	var2 = 4,
	nextstate = S_BOOCHARGE3,
}


states[S_BOOBLOCK] = {
	sprite = SPR_64BO,
	frame = G|FF_TRANS40|FF_ADD,
	tics = 1,
	nextstate = S_BOOBLOCK,
}

states[S_BOOBLOCKLOOKING] = {
	sprite = SPR_64BO,
	frame = H|FF_TRANS40|FF_ADD,
	tics = 1,
	nextstate = S_BOOBLOCKLOOKING,
}

states[S_BOODEAD] = {
	sprite = SPR_64BO,
	frame = A|FF_TRANS40|FF_ADD|FF_VERTICALFLIP,
	tics = 128,
	action = P_MarioEnemyDeathThinker,
}

states[S_DEEPCHEEPROAM] = {
	sprite = SPR_1EEP,
	frame = A|FF_ANIMATE,
	tics = 16,
	var1 = 3,
	var2 = 4,
	nextstate = S_DEEPCHEEPROAM,
}

states[S_DEEPCHEEPATTACK] = {
	sprite = SPR_1EEP,
	frame = A|FF_ANIMATE,
	tics = 16,
	var1 = 3,
	var2 = 4,
	nextstate = S_DEEPCHEEPATTACK,
}

states[S_DEEPCHEEPDEAD] = {
	sprite = SPR_1EEP,
	frame = A|FF_VERTICALFLIP,
	tics = 128,
	action = P_MarioEnemyDeathThinker,
}

-- Moncher

states[S_MONCHER1] = {
	sprite = SPR_3NOM,
	frame = A,
	tics = 4,
	nextstate = S_MONCHER2,
}

states[S_MONCHER2] = {
	sprite = SPR_3NOM,
	frame = B,
	tics = 2,
	nextstate = S_MONCHER3,
}

states[S_MONCHER3] = {
	sprite = SPR_3NOM,
	frame = C,
	tics = 4,
	nextstate = S_MONCHER4,
}

states[S_MONCHER4] = {
	sprite = SPR_3NOM,
	frame = D,
	tics = 2,
	nextstate = S_MONCHER1,
}

-- Mario Bone Train Head

states[S_MARIOBONETRAINHEAD] = {
	sprite = SPR_0MGI,
	frame = A,
}

states[S_MARIOBONETRAISEG] = {
	sprite = SPR_0MGI,
	frame = B,
}

-- Item Holder Balloon

states[S_ITEMHOLDERBALLOON] = {
	sprite = SPR_BAM5,
	frame = A,
}

-- Upward Swing Coin

states[S_COIN_JAWROT] = {
	sprite = SPR_COIN,
	frame = 31|FF_ANIMATE,
	tics = 18,
	var1 = 5,
	var2 = 1,
	nextstate = S_DROPCOINDEATH,
}