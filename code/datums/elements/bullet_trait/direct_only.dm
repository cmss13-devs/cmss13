// This trait makes the projectile only hit targets directly clicked 

/datum/element/bullet_trait_direct_only
	// General bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

/datum/element/bullet_trait_direct_only/Attach(datum/target)
	. = ..()
	if(!istype(target, /obj/projectile))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, PROC_REF(check_distance))

/datum/element/bullet_trait_direct_only/Detach(datum/target)
	UnregisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING)

	return ..()

/datum/element/bullet_trait_direct_only/proc/check_distance(obj/projectile/P, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(P.original != projectile_target)
		return COMPONENT_SKIP_MOB
