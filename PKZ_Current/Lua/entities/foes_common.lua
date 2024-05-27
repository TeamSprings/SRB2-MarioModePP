
// Killer of invincible enemies
// Written by Ace
local function InvinciMobjKiller(actor, collider)
	if collider and collider.valid and collider.type == MT_PLAYER and (collider.z) >= (actor.z) and (collider.z) < (actor.z+actor.height+1*FRACUNIT) and (actor.state ~= actor.info.deathstate) then
		if collider.player.powers[pw_invulnerability] or (actor.type == MT_SHYGUY and collider.state == S_PLAY_ROLL) then
			local dummyobject = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
			dummyobject.state = S_MARIOSTARS
			dummyobject.sprite = actor.sprite
			dummyobject.frame = actor.frame|FF_VERTICALFLIP
			dummyobject.color = actor.color
			dummyobject.flags = $|MF_NOCLIPHEIGHT &~ MF_NOGRAVITY
			dummyobject.momz = 8*FRACUNIT
			dummyobject.momx = 3*FRACUNIT
			dummyobject.momy = 3*FRACUNIT
			dummyobject.fuse = 60
			dummyobject.angle = actor.angle
			S_StartSound(collider, (actor.type ~= MT_BIGMOLE and sfx_mario5 or sfx_marwoc))
			if actor.parts then
				for _,parts in pairs(actor.parts) do
					P_RemoveMobj(parts)
				end
			end
			P_RemoveMobj(actor)
		end
	end
end

// Wings Spawner for Enemies
// Written by Ace
local function Spawnenemywings(actor)
	if not (actor.type == MT_PARAKOOPA or actor.type == MT_BPARAKOOPA) then return end

	local wingsespawn = P_SpawnMobj(actor.x, actor.y, actor.z, MT_WIDEWINGS)
	wingsespawn.angle = actor.angle
	wingsespawn.scale = actor.scale
	wingsespawn.target = actor
	wingsespawn.flags2 = $|MF2_LINKDRAW
	wingsespawn.capeset = 3

end

// Goomba Action Thinkers
// Written by Ace
function A_MarRushChase(actor, th)
	A_FaceTarget(actor)
	A_Thrust(actor, th, 1)
end

// Goomba/Bomb-Ohm running around
// Written by Ace
function A_MarGoinAround(actor)
	local speed = FixedHypot(actor.momx, actor.momy)
	local snspeed = actor.scale<<2/5

	actor.goombatimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)

	if actor.goombatimer == 150 then
		actor.angle = $ + ANGLE_45
		actor.goombatimer = 1
	end

	if speed > 0 and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, snspeed), actor.y + P_ReturnThrustY(actor, actor.angle, snspeed), true)
		actor.angle = $+ ANGLE_180
    end

	P_InstaThrust(actor, actor.angle, snspeed)
end


// Koopa pop action... it literally just spawns particle...
// Do you really need this comment?
// Written by Ace
local function KoopaPop(actor, toucher)
	if actor.mariofrozenkilled then return end
	local spawndamageparticle = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
	spawndamageparticle.momx = 0
	spawndamageparticle.momy = 0
	spawndamageparticle.momz = 0
	spawndamageparticle.fuse = TICRATE
	spawndamageparticle.scale = (actor.scale << 2)/3
	A_SpawnMarioStars(actor, toucher)
	S_StartSound(nil, sfx_mario2)
end

return {InvinciMobjKiller = InvinciMobjKiller, Spawnenemywings = Spawnenemywings, A_MarRushChase = A_MarRushChase, A_MarGoinAround = A_MarGoinAround, KoopaPop = KoopaPop}