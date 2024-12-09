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

/datum/element/bullet_trait_direct_only/proc/check_distance(obj/projectile/projectile, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(projectile.original != projectile_target)
		return COMPONENT_SKIP_MOB

/datum/element/bullet_trait_direct_only/watchtower/check_distance(obj/projectile/projectile, mob/living/carbon/human/projectile_target)
	if(!HAS_TRAIT(projectile.firer, TRAIT_ON_WATCHTOWER))
		if(!istype(projectile.firer, /mob))
			return
		var/mob/firer = projectile.firer
		var/obj/item/weapon/gun/gun = firer.get_inactive_hand()
		if(istype(gun))
			gun.remove_bullet_traits(list("watchtower_arc"))

		gun = firer.get_active_hand()
		if(istype(gun))
			gun.remove_bullet_traits(list("watchtower_arc"))
		return

	return ..()
