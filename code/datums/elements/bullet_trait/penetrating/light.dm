/datum/element/bullet_trait_penetrating/light
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 3

	/// For every mob this pierces, how much damage should this lose?
	var/damage_lost_per_hit = 15


/datum/element/bullet_trait_penetrating/light/Attach(datum/target, distance_loss_per_hit = 2, damage_lost_per_hit = 15)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return

	src.damage_lost_per_hit = damage_lost_per_hit

/datum/element/bullet_trait_penetrating/light/handle_passthrough_movables(obj/projectile/bullet, atom/movable/hit_movable, did_hit)
    if(did_hit)
        bullet.distance_travelled += distance_loss_per_hit
        if(ismob(hit_movable))
            bullet.damage -= damage_lost_per_hit

    return COMPONENT_BULLET_PASS_THROUGH
