/datum/caste_datum/custom
	caste_type = XENO_CASTE_CUSTOM

/**
 * A master delegate which decides how to handle behaviours depending on their given delegates
 * If something breaks down try to look at the delegate in question before snowflaking anything here
 */
/datum/behavior_delegate/Custom
	name = "Custom xeno behaviour delegate controller"
	/// The list of all delegates
	var/list/datum/behavior_delegate/delegates = list()

/datum/behavior_delegate/Custom/New(list/delegate_paths, bound_xeno)
	src.bound_xeno = bound_xeno
	for(var/path as anything in delegate_paths)
		var/datum/behavior_delegate/new_delegate = new path
		new_delegate.bound_xeno = bound_xeno
		delegates += new_delegate

/datum/behavior_delegate/Custom/Destroy(force, ...)
	for(var/delegate as anything in delegates)
		QDEL_NULL(delegate)
	. = ..()

/datum/behavior_delegate/Custom/on_life()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_life()

/datum/behavior_delegate/Custom/append_to_stat()
	. = list()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		. += delegate.append_to_stat()

/datum/behavior_delegate/Custom/add_to_xeno()
	for(var/datum/behavior_delegate/delegate in delegates)
		delegate.add_to_xeno()

/datum/behavior_delegate/Custom/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	var/list/original_damages = list()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		original_damages += delegate.melee_attack_modify_damage(original_damage, A)
	return original_damages.len ? max(original_damages) : original_damage

/datum/behavior_delegate/Custom/melee_attack_additional_effects_target(mob/living/carbon/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.melee_attack_additional_effects_target(A)

/datum/behavior_delegate/Custom/melee_attack_additional_effects_self()
	SEND_SIGNAL(bound_xeno, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.melee_attack_additional_effects_self()

/datum/behavior_delegate/Custom/ranged_attack_on_hit()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_on_hit()

/datum/behavior_delegate/Custom/ranged_attack_additional_effects_target(atom/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_additional_effects_target(A)

/datum/behavior_delegate/Custom/ranged_attack_additional_effects_self(atom/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_additional_effects_self(A)

/datum/behavior_delegate/Custom/on_hitby_projectile(ammo)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_hitby_projectile(ammo)

/datum/behavior_delegate/Custom/on_kill_mob(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_kill_mob(M)

/datum/behavior_delegate/Custom/handle_slash(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.handle_slash(M)

/datum/behavior_delegate/Custom/handle_death(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.handle_death(M)

/datum/behavior_delegate/Custom/on_update_icons()
	var/results = list(TRUE)
	for(var/datum/behavior_delegate/delegate in delegates)
		results += delegate.on_update_icons()
	return min(results)

/mob/living/carbon/Xenomorph/Custom
	caste_type = XENO_CASTE_CUSTOM
	///Custom xenos can have multiple delegates at once
	var/list/behavior_delegates = list()
	///Visual info to be restored after initials()
	var/list/stored_visuals = list()

/mob/living/carbon/Xenomorph/Custom/Initialize(mapload, datum/caste_datum/pre_made_caste, mob/living/carbon/Xenomorph/oldXeno, h_number)
	caste = pre_made_caste
	. = ..(mapload, oldXeno, h_number)

/mob/living/carbon/Xenomorph/Custom/Destroy()
	. = ..()
	//If our caste is not in the global, it means it isn't the singleton and should therefor be deleted with us
	if(!(caste in xeno_custom_datums))
		QDEL_NULL(caste)

///////////////////////////////////////
//		VISUAL UPDATE OVERRIDES		//
/////////////////////////////////////

/mob/living/carbon/Xenomorph/Custom/update_icons()
	//A bit of trickery, we pretend to be something else for the purposes of icons, saves a bunch of duplicate code
	caste.caste_type = stored_visuals["icon_source_caste"]
	pixel_x = stored_visuals["pixel_x"]
	pixel_y = stored_visuals["pixel_y"]
	old_x = stored_visuals["old_x"]
	old_y = stored_visuals["old_y"]
	base_pixel_x = stored_visuals["base_pixel_x"]
	base_pixel_y = stored_visuals["base_pixel_y"]
	. = ..()
	caste.caste_type = initial(caste.caste_type)
