/datum/xeno_strain
	/// The name of the strain. Should be short but informative.
	var/name
	/// Description to be displayed on purchase.
	var/description
	/// (OPTIONAL) Flavor text to be shown on purchase. Semi-OOC
	var/flavor_description
	/// (OPTIONAL) A custom icon state prefix for xenos who have taken the strain.
	var/icon_state_prefix

	/// A list of action typepaths which should be removed when a xeno takes the strain.
	var/list/actions_to_remove
	/// A list of action typepaths which should be added when a xeno takes the strain.
	var/list/actions_to_add

	/// Typepath of the [/datum/behavior_delegate] to add.
	var/behavior_delegate_type

/**
 * Add this strain to `xeno`, replacing their actions and behavior holder.
 *
 * Returns a bool indicating if the strain was successfully applied.
 * **Override [/datum/xeno_strain/proc/apply_strain], not this! (Unless you know what you're doing.)**
 */
/datum/xeno_strain/proc/_add_to_xeno(mob/living/carbon/xenomorph/xeno)
	SHOULD_NOT_OVERRIDE(TRUE)

	xeno.strain = src

	// Update the xeno's actions.
	for(var/action_path in actions_to_remove)
		remove_action(xeno, action_path)
	for(var/action_path in actions_to_add)
		give_action(xeno, action_path)

	// Update the xeno's behavior delegate.
	if(behavior_delegate_type)
		if(xeno.behavior_delegate)
			qdel(xeno.behavior_delegate)
		xeno.behavior_delegate = new behavior_delegate_type()
		xeno.behavior_delegate.bound_xeno = xeno
		xeno.behavior_delegate.add_to_xeno()

	apply_strain(xeno)

	xeno.update_icons()
	xeno.hive.hive_ui.update_xeno_info()

	// Give them all of the info about the strain.
	to_chat(xeno, SPAN_XENOANNOUNCE(description))
	if(flavor_description)
		to_chat(xeno, SPAN_XENOLEADER(flavor_description))
	return TRUE

/**
 * Adds any special modifiers/changes from this strain to `xeno`.
 *
 * Called when the strain is first added to the player.
 */
/datum/xeno_strain/proc/apply_strain(mob/living/carbon/xenomorph/xeno)
	// Override with custom behaviour.
	return

/mob/living/carbon/xenomorph/verb/purchase_strain()
	set name = "Purchase Strain"
	set desc = "Purchase a strain for yourself"
	set category = "Alien"

	// Firstly, make sure the xeno is actually able to take a strain.
	if(!can_take_strain())
		return

	// Make an assoc list of {name: typepath} from the strains available to the xeno's caste.
	var/list/strain_list = list()
	for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
		strain_list[initial(strain_type.name)] = strain_type

	// Ask the user which strain they want.
	var/strain_choice = tgui_input_list(usr, "Which strain would you like to take?", "Choose Strain", strain_list, theme = "hive_status")
	if(!strain_choice)
		return
	var/datum/xeno_strain/chosen_strain = strain_list[strain_choice]

	// Check again after the user picks one, in case anything changed.
	if(!can_take_strain())
		return
	// Show the user the strain's description, and double check that they want it.
	if(tgui_alert(usr, "[initial(chosen_strain.description)]", "Choose Strain", list("Mutate", "Cancel")) != "Mutate")
		return
	// One more time after they confirm.
	if(!can_take_strain())
		return

	// Create the strain datum and apply it to the xeno.
	var/datum/xeno_strain/strain_instance = new chosen_strain()
	if(strain_instance._add_to_xeno(src))
		xeno_jitter(1.5 SECONDS)
		// If it applied successfully, add it to the logs.
		log_strain("[name] purchased strain '[strain_instance.type]'")

/mob/living/carbon/xenomorph/verb/reset_strain()
	set name = "Reset Strain"
	set desc = "Reset your strain"
	set category = "Alien"

	// Firstly, make sure the xeno is actually able to take a strain.
	if(!can_take_strain(reset = TRUE))
		return

	if(!COOLDOWN_FINISHED(src, next_strain_reset))
		to_chat(src, SPAN_WARNING("We lack the strength to reset our strain. We will be able to reset it in [round((next_strain_reset - world.time) / 600, 1)] minutes"))
		return

	// Show the user the strain's description, and double check that they want it.
	if(tgui_alert(src, "Are you sure?", "Reset Strain", list("Yes", "No")) != "Yes")
		return

	// One more time after they confirm.
	if(!can_take_strain(reset = TRUE))
		return

	var/mob/living/carbon/xenomorph/new_xeno = transmute(caste_type)
	if(!new_xeno)
		return

	new_xeno.xeno_jitter(1.5 SECONDS)
	if(evolution_stored == evolution_threshold)
		if(new_xeno.caste_type == XENO_CASTE_FACEHUGGER)
			return
		give_action(new_xeno, /datum/action/xeno_action/onclick/evolve)

	// If it applied successfully, add it to the logs.
	log_strain("[new_xeno.name] reset their strain.")
	COOLDOWN_START(new_xeno, next_strain_reset, 40 MINUTES)

/// Is this xeno currently able to take a strain?
/mob/living/carbon/xenomorph/proc/can_take_strain(reset=FALSE)
	if(!length(caste.available_strains) || !check_state(TRUE))
		return FALSE

	if(strain && !reset)
		to_chat(src, SPAN_WARNING("We have already chosen a strain."))
		return FALSE

	if(!strain && reset)
		to_chat(src, SPAN_WARNING("You must first pick a strain before resetting it."))
		return FALSE

	if(is_zoomed)
		to_chat(src, SPAN_WARNING("We can't do that while looking far away."))
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
