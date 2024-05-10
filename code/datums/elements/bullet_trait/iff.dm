/// This is the iff_group
/obj/projectile/var/runtime_iff_group

/datum/element/bullet_trait_iff
	// General bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	/// The iff group for this bullet
	var/iff_group
	/// A cache of IFF groups for specific mobs
	var/list/iff_group_cache

/datum/element/bullet_trait_iff/Attach(datum/target, iff_group)
	. = ..()
	if(!istype(target, /obj/projectile))
		return ELEMENT_INCOMPATIBLE

	if(!iff_group)
		RegisterSignal(target, COMSIG_BULLET_USER_EFFECTS, PROC_REF(set_iff))
	else
		src.iff_group = iff_group
		RegisterSignal(target, COMSIG_BULLET_CHECK_MOB_SKIPPING, PROC_REF(check_iff))

/datum/element/bullet_trait_iff/Detach(datum/target)
	UnregisterSignal(target, list(
		COMSIG_BULLET_USER_EFFECTS,
		COMSIG_BULLET_CHECK_MOB_SKIPPING,
	))

	..()

/datum/element/bullet_trait_iff/proc/check_iff(datum/target, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(projectile_target.get_target_lock(iff_group))
		return COMPONENT_SKIP_MOB

/datum/element/bullet_trait_iff/proc/set_iff(datum/target, mob/living/carbon/human/firer)
	SIGNAL_HANDLER

	var/obj/projectile/P = target
	P.runtime_iff_group = get_user_iff_group(firer)

// We have a "cache" to avoid getting ID card iff every shot,
// The cache is reset when the user drops their ID
/datum/element/bullet_trait_iff/proc/get_user_iff_group(mob/living/carbon/human/user)
	if(!ishuman(user))
		return user?.faction_group

	var/iff_group = LAZYACCESS(iff_group_cache, user)
	if(isnull(iff_group))
		iff_group = user.get_id_faction_group()
		LAZYSET(iff_group_cache, user, iff_group)
		// Remove them from the cache if they are deleted
		RegisterSignal(user, COMSIG_HUMAN_EQUIPPED_ITEM, PROC_REF(handle_id_equip))
		RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(reset_iff_group_cache))

	return iff_group

/datum/element/bullet_trait_iff/proc/handle_id_equip(equipper, item, slot)
	SIGNAL_HANDLER
	if(slot == WEAR_ID)
		reset_iff_group_cache(equipper)
		UnregisterSignal(equipper, COMSIG_HUMAN_EQUIPPED_ITEM)
		UnregisterSignal(equipper, COMSIG_PARENT_QDELETING)

/datum/element/bullet_trait_iff/proc/reset_iff_group_cache(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if(!user)
		iff_group_cache = null
	else
		LAZYREMOVE(iff_group_cache, user)

