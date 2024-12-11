
-- Kills Enemy Types without MF_ENEMY 
---* Written by Skydusk
---@param actor mobj_t
---@param collider mobj_t
local function P_FlaglessEnemyKillEvent(actor, collider)
	if collider and collider.valid and collider.type == MT_PLAYER and (collider.z) >= (actor.z) and (collider.z) < (actor.z+actor.height+1*FRACUNIT) and (actor.state ~= actor.info.deathstate) then
		if collider.player.powers[pw_invulnerability] or (actor.type == MT_SHYGUY and collider.state == S_PLAY_ROLL) then
			
			local pop = P_SpawnMobj(actor.x, actor.y, actor.z, MT_POPPARTICLEMAR)
			pop.state = S_MARIOSTARS
			pop.sprite = actor.sprite
			pop.frame = actor.frame|FF_VERTICALFLIP
			pop.color = actor.color
			pop.flags = $|MF_NOCLIPHEIGHT &~ MF_NOGRAVITY
			pop.momz = 8*FRACUNIT
			pop.momx = 3*FRACUNIT
			pop.momy = 3*FRACUNIT
			pop.fuse = 60
			pop.angle = actor.angle
			
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

-- Wings Spawner for Enemies
---* Written by Skydusk
---@param actor mobj_t
local function P_SpawnEnemyWings(actor)
	if not (actor.type == MT_PARAKOOPA or actor.type == MT_BPARAKOOPA) then return end

	local wings = P_SpawnMobj(actor.x, actor.y, actor.z, MT_WIDEWINGS)
	wings.angle = actor.angle
	wings.scale = actor.scale
	wings.target = actor
	wings.flags2 = $|MF2_LINKDRAW
	wings.capeset = 3

end

-- Goomba Action Thinkers
---* Written by Skydusk
---@param actor mobj_t
---@param th fixed_t
function A_MarRushChase(actor, th)
	A_FaceTarget(actor)
	A_Thrust(actor, th, 1)
end

-- Goomba/Bomb-Ohm running around
---* Written by Skydusk
---@param actor mobj_t
function A_MarGoinAround(actor)
	local speed = FixedHypot(actor.momx, actor.momy)
	local snspeed = actor.scale<<2/5

	actor.goombatimer = (actor.bombohmtimer ~= nil and (actor.bombohmtimer > 0 and $+1 or $) or 1)

	if actor.goombatimer == 150 then
		actor.angle = $ + ANGLE_45
		actor.goombatimer = 1
	end

	if speed > 0 and not P_TryMove(actor, actor.x + P_ReturnThrustX(actor, actor.angle, snspeed), actor.y + P_ReturnThrustY(actor, actor.angle, snspeed), true) then
		actor.angle = $+ ANGLE_180
    end

	P_InstaThrust(actor, actor.angle, snspeed)
end


-- Spawns "Pop" Particle
---* Written by Skydusk
---@param actor mobj_t
---@param toucher mobj_t
local function KoopaPop(actor, toucher)
	local pop = P_SpawnMobjFromMobj(actor, TBSlib.lerp(FRACUNIT >> 1, actor.x, toucher.x)-actor.x, TBSlib.lerp(FRACUNIT >> 1, actor.y, toucher.y)-actor.y, TBSlib.lerp(FRACUNIT >> 1, actor.z, toucher.z)-actor.z, MT_POPPARTICLEMAR)
	pop.momx = 0
	pop.momy = 0
	pop.momz = 0
	pop.fuse = TICRATE
	pop.scale = (actor.scale << 2)/3

	A_SpawnMarioStars(actor, toucher)
	S_StartSound(nil, sfx_mario2)
end

return {InvinciMobjKiller = P_FlaglessEnemyKillEvent, Spawnenemywings = P_SpawnEnemyWings, A_MarRushChase = A_MarRushChase, A_MarGoinAround = A_MarGoinAround, KoopaPop = KoopaPop}