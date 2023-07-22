// This trait makes projectile ignore mobs within set range.
// Uses ammo_datum's ignored_range and projectile's distance_travelled to determine whether mob should be hit or skipped

/datum/element/bullet_trait_ignored_range
	// General bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	//amount of tiles that projectile should be skiping mobs.
	var/ignored_range = 0

/datum/element/bullet_trait_ignored_range/Attach(datum/target, range_to_ignore)
	. = ..()
	ignored_range = range_to_ignore
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, PROC_REF(check_distance))

/datum/element/bullet_trait_ignored_range/Detach(datum/target)
	UnregisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING)

	return ..()

/datum/element/bullet_trait_ignored_range/proc/check_distance(obj/item/projectile/P, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(P.distance_travelled <= ignored_range)
		return COMPONENT_CANCEL_BULLET_ACT
