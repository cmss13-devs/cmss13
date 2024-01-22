/datum/xeno_strain
	/// The name of the strain. Should be short but informative.
	var/name
	/// Description to be displayed on purchase.
	var/description
	/// (OPTIONAL) Flavor text to be shown on purchase. Semi-OOC
	var/flavor_description
	/// (OPTIONAL) A custom icon state prefix for xenos who have taken the strain.
	var/xeno_icon_state

	/// A list of action typepaths which should be removed when a xeno takes the strain.
	var/list/actions_to_remove
	/// A list of action typepaths which should be added when a xeno takes the strain.
	var/list/actions_to_add

	/// Typepath of the [/datum/behavior_delegate] to add.
	var/behavior_delegate_type

/// TODO: documentation
/// Returns a bool indicating if the strain was successfully applied.
/datum/xeno_strain/proc/apply_strain(mob/living/carbon/xenomorph/xeno)
	SHOULD_CALL_PARENT(TRUE)

	xeno.chosen_strain = src
	update_actions(xeno)
	register_signals(xeno)
	apply_behavior_holder(xeno)
	update_mob(xeno)

	xeno.hive.hive_ui.update_xeno_info()

	to_chat(xeno, SPAN_XENOANNOUNCE(description))
	if(flavor_description)
		to_chat(xeno, SPAN_XENOLEADER(flavor_description))
	return TRUE

/// Update the `xeno`'s action buttons based on [/datum/xeno_strain/var/actions_to_remove] and [/datum/xeno_strain/var/actions_to_add].
/datum/xeno_strain/proc/update_actions(mob/living/carbon/xenomorph/xeno)
	for(var/action_path in actions_to_remove)
		remove_action(xeno, action_path)
	for(var/action_path in actions_to_add)
		give_action(xeno, action_path)

/// TODO: documentation
/datum/xeno_strain/proc/register_signals(mob/living/carbon/xenomorph/xeno)
	return

/// TODO: documentation
/datum/xeno_strain/proc/apply_behavior_holder(mob/living/carbon/xenomorph/xeno)
	if(!behavior_delegate_type)
		// don't need to do anything
		return

	if(xeno.behavior_delegate)
		qdel(xeno.behavior_delegate)
	xeno.behavior_delegate = new behavior_delegate_type()
	xeno.behavior_delegate.bound_xeno = xeno
	xeno.behavior_delegate.add_to_xeno()

/// TODO: documentation
/datum/xeno_strain/proc/update_mob(mob/living/carbon/xenomorph/xeno)
	xeno.xeno_jitter(1.5 SECONDS)
	xeno.update_icons()


/mob/living/carbon/xenomorph/verb/purchase_strain()
	set name = "Purchase Strain"
	set desc = "Purchase a strain for yourself"
	set category = "Alien"

	if(!can_take_strain())
		return

	var/strain_choice = tgui_input_list(usr, "Which strain would you like to take?", "Choose Strain", GLOB.xeno_strain_list, theme = "hive_status")
	var/datum/xeno_strain/strain_path = GLOB.xeno_strain_list[strain_choice]
	// Check again after the user has picked one.
	if(!can_take_strain())
		return
	// Show the user the strain's description, and double check that they want it.
	if(alert(usr, "[initial(strain_path.description)]\n\nConfirm mutation?", "Choose Strain", "Yes", "No") != "Yes")
		return
	// One more time after they confirm.
	if(!can_take_strain())
		return

	var/datum/xeno_strain/strain_instance = new strain_path()
	// Apply the strain to the xeno.
	if(strain_instance.apply_strain(src))
		// And log it if it was successful.
		log_strain("[name] purchased strain '[strain_instance.type]'")

/mob/living/carbon/xenomorph/proc/can_take_strain()
	if(!length(available_strains) || !check_state(TRUE))
		return FALSE

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("This place is too constraining to take a strain."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("We can't take a strain here."))
		return FALSE

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow us to take a strain."))
		return FALSE

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("We must be at full health to take a strain."))
		return FALSE

	if(agility || fortify || crest_defense || stealth)
		to_chat(src, SPAN_WARNING("We cannot take a strain while in this stance."))
		return FALSE

	return TRUE
