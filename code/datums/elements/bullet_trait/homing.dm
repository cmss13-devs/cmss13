/datum/element/bullet_trait_homing
	// General bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

/datum/element/bullet_trait_homing/Attach(datum/target)
	. = ..()
	// All bullet traits can only be applied to projectiles
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE
	var/obj/item/projectile/proj = target

	proj.projectile_override_flags |= AMMO_HOMING

/datum/element/bullet_trait_homing/Detach(datum/target)
	var/obj/item/projectile/proj = target

	proj.projectile_override_flags &= ~AMMO_HOMING
	return ..()
