/datum/element/bullet_trait_penetrating/heavy
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 3

	/// For every turf this pierces, how much damage should this lose?
	var/damage_lost_per_pen = 100
	/// Typecache of things to annihilate if the bullet is on a tile with it
	var/static/list/bullet_destroy_structures = typecacheof(list(
		/obj/structure/surface,
		/obj/structure/barricade,
	))

/datum/element/bullet_trait_penetrating/heavy/Attach(datum/target, distance_loss_per_hit = 3, damage_lost_per_pen = 75)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return

	src.damage_lost_per_pen = damage_lost_per_pen

/datum/element/bullet_trait_penetrating/heavy/handle_passthrough_movables(obj/projectile/bullet, atom/movable/hit_movable, did_hit)
	if(did_hit)
		var/slow_mult = 1
		if(ismob(hit_movable))
			var/mob/mob = hit_movable
			if(mob.mob_size >= MOB_SIZE_BIG)
				slow_mult = 2

		bullet.distance_travelled += (distance_loss_per_hit * slow_mult)

	if(is_type_in_typecache(hit_movable, bullet_destroy_structures))
		var/obj/structure/cade = hit_movable
		cade.deconstruct() // This bullet just tears through whatever cades you put it up against from either side
		bullet.damage -= damage_lost_per_pen

	return COMPONENT_BULLET_PASS_THROUGH

/datum/element/bullet_trait_penetrating/heavy/handle_passthrough_turf(obj/projectile/bullet, turf/closed/wall/hit_wall)
	bullet.distance_travelled += distance_loss_per_hit
	bullet.damage -= damage_lost_per_pen

	if(!istype(hit_wall))
		return COMPONENT_BULLET_PASS_THROUGH

	if(!(hit_wall.turf_flags & TURF_HULL))
		return COMPONENT_BULLET_PASS_THROUGH

