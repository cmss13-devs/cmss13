/*
/datum/element/bullet_trait_del_range_del_range
	// General bullet trait vars
	// ALWAYS INCLUDE THESE TWO LINES IN THE BULLET TRAIT DEF
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	var/del_range = 0
/datum/element/bullet_trait_del_range/Attach(datum/target, range_to_delete)
	. = ..()
	del_range = range_to_delete
	// All bullet traits can only be applied to projectiles
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, .proc/check_distance)
	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, .proc/check_distance)
	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, .proc/check_distance)
	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, .proc/check_distance)
	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, .proc/check_distance)

/datum/element/bullet_trait_del_range/Detach(datum/target)
	UnregisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING)

	return ..()

/datum/element/bullet_trait_del_rangee/proc/check_distance(obj/item/projectile/P, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(P.distance_travelled <= ignored_range)
		return COMPONENT_CANCEL_BULLET_ACT

*/
