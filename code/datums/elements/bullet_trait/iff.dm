/// This is the iff_group
/obj/item/projectile/var/runtime_iff_group

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
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	if(!iff_group)
		RegisterSignal(target, COMSIG_BULLET_USER_EFFECTS, .proc/set_iff)
	else
		src.iff_group = iff_group
		RegisterSignal(target, COMSIG_BULLET_CHECK_IFF, .proc/check_iff)

/datum/element/bullet_trait_iff/Detach(datum/target)
	UnregisterSignal(target, list(
		COMSIG_BULLET_USER_EFFECTS,
		COMSIG_BULLET_CHECK_IFF,
	))

	..()

/datum/element/bullet_trait_iff/proc/check_iff(datum/target, mob/living/carbon/human/projectile_target)
	SIGNAL_HANDLER

	if(projectile_target.get_target_lock(iff_group))
		return COMPONENT_BULLET_NO_HIT

/datum/element/bullet_trait_iff/proc/set_iff(datum/target, mob/living/carbon/human/firer)
	SIGNAL_HANDLER

	var/obj/item/projectile/P = target
	P.runtime_iff_group = get_user_iff_group(firer)

// We have a "cache" to avoid getting ID card iff every shot,
// The cache is reset when the user drops their ID
/datum/element/bullet_trait_iff/proc/get_user_iff_group(var/mob/living/carbon/human/user)
	if(!ishuman(user))
		return user.faction_group

	var/iff_group = LAZYACCESS(iff_group_cache, user)
	if(isnull(iff_group))
		iff_group = user.get_id_faction_group()
		LAZYSET(iff_group_cache, user, iff_group)
		// Remove them from the cache if they are deleted
		RegisterSignal(user, COMSIG_PARENT_QDELETING, .proc/reset_iff_group_cache)

	return iff_group

/datum/element/bullet_trait_iff/proc/reset_iff_group_cache(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if(!user)
		iff_group_cache = null
	else
		LAZYREMOVE(iff_group_cache, user)

