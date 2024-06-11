/datum/element/bullet_trait_penetrating/weak
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 4

	/// For each thing this hits, how much damage it loses normally. This can be modified by what it penetrates later.
	var/damage_percent_lost_per_hit = 20
	// XM43E1 AMR: First target takes full damage, each subsequent target takes at least 20% less damage (increased for large mobs and dense turfs), 25 from base 125 damage.

	/// For each thing this hits, how much distance it loses normally.
	distance_loss_per_hit = 4
	// XM43E1 AMR: Hits 7 things at most, at point blank, with no additional modifiers. This greatly increases at actual sniping ranges.

	/// How many times more effective turfs are at slowing down the projectile normally, reducing both range and damage.
	var/turf_hit_slow_mult = 3
	// XM43E1 AMR: Unable to hit anything through more than 2 walls, less at maximum ranges. Pens 2 walls at 8 tiles or less, 1 at 20 tiles or less, and can't wallbang through normal walls at maximum range.
	// Also loses 75 damage with each normal wall pen.

/datum/element/bullet_trait_penetrating/weak/Attach(datum/target, distance_loss_per_hit = 4, damage_percent_lost_per_hit = 20, turf_hit_slow_mult = 3)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return

	src.damage_percent_lost_per_hit = damage_percent_lost_per_hit
	src.turf_hit_slow_mult = turf_hit_slow_mult

/datum/element/bullet_trait_penetrating/weak/handle_passthrough_movables(obj/projectile/bullet, atom/movable/hit_movable, did_hit)
	if(did_hit)
		var/slow_mult = 1
		if(ismob(hit_movable))
			var/mob/mob = hit_movable
			if(mob.mob_size >= MOB_SIZE_BIG) // Big Xenos (including fortified Defender) can soak hits and greatly reduce penetration.
				slow_mult = 2 // 8 tiles of range lost per Big hit. At point blank, this comes out to only 3 targets. At sniping ranges, even a single one can stop the bullet dead.

		bullet.distance_travelled += (distance_loss_per_hit * slow_mult)

		bullet.damage -= (damage_percent_lost_per_hit * slow_mult)

	return COMPONENT_BULLET_PASS_THROUGH


/datum/element/bullet_trait_penetrating/weak/handle_passthrough_turf(obj/projectile/bullet, turf/closed/wall/hit_wall)
	var/slow_mult = turf_hit_slow_mult

	// Better penetration against Membranes to still be able to counter Boilers at most ranges. Still loses 4 tiles of range and 25 damage per.
	if(istype(hit_wall, /turf/closed/wall/resin/membrane))
		if(istype(hit_wall, /turf/closed/wall/resin/membrane/thick))
			slow_mult = 1.5
		else
			slow_mult = 1

	bullet.distance_travelled += (distance_loss_per_hit * slow_mult)

	bullet.damage *= (1 - (damage_percent_lost_per_hit * slow_mult * 0.01))

	if(!istype(hit_wall))
		return COMPONENT_BULLET_PASS_THROUGH

	if(!hit_wall.hull)
		return COMPONENT_BULLET_PASS_THROUGH
