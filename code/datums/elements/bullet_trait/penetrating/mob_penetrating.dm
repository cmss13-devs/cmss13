/datum/element/bullet_trait_penetrating/weak/mob_penetrating
	distance_loss_per_hit = 0
	var/inital_portion_lost_per_hit = 0.55



/datum/element/bullet_trait_penetrating/weak/mob_penetrating/handle_passthrough_movables(obj/projectile/bullet, atom/movable/hit_movable, did_hit)
	if(ismob(hit_movable))
		var/damage = bullet.damage
		damage = damage - bullet.ammo.damage * inital_portion_lost_per_hit
		bullet.damage = damage
	if(bullet.damage > 0)
		return COMPONENT_BULLET_PASS_THROUGH
	return FALSE

/datum/element/bullet_trait_penetrating/weak/mob_penetrating/handle_passthrough_turf(obj/projectile/bullet, turf/closed/wall/hit_wall)
	. = ..()
	return FALSE //we do not pass thrue turfs
/datum/element/bullet_trait_penetrating/weak/mob_penetrating/two_penetrations
	inital_portion_lost_per_hit = 0.35

/datum/element/bullet_trait_penetrating/weak/mob_penetrating/three_penetrations
	inital_portion_lost_per_hit = 0.28
