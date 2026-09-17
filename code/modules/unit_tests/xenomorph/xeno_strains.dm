/datum/unit_test/xeno_strains

/datum/unit_test/xeno_strains/Run()
	for(var/mob/living/carbon/xenomorph/caste_mob as anything in subtypesof(/mob/living/carbon/xenomorph))
		var/datum/caste_datum/caste_datum = GLOB.xeno_datum_list[initial(caste_mob.caste_type)]
		if(!caste_datum)
			// not really strain related but may as well have this in here
			TEST_FAIL("[caste_mob] has no `/datum/caste_datum`! (Possible mismatch of `caste_type`)")
			continue

		for(var/datum/xeno_strain/strain_path as anything in caste_datum.available_strains)
			// Check for these, but test the strain either way.
			if(!initial(strain_path.name))
				TEST_FAIL("[strain_path] has no name!")
			if(!initial(strain_path.description))
				TEST_FAIL("[strain_path] has no description!")

			test_strain(caste_mob, strain_path)

/datum/unit_test/xeno_strains/proc/test_strain(mob_path, strain_path)
	var/mob/living/carbon/xenomorph/fred = allocate(mob_path)
	var/datum/xeno_strain/strain = new strain_path()

	strain._add_to_xeno(fred)

	// Actions which should have been removed.
	var/list/removed_actions = strain.actions_to_remove
	// Exclude any actions which are in both strain lists (re-added afterwards).
	removed_actions -= (removed_actions & strain.actions_to_add)

	// Actions which should have been added.
	var/list/added_actions = strain.actions_to_add.Copy()

	for(var/datum/action/action as anything in fred.actions)
		if(action.type in removed_actions)
			TEST_FAIL("[strain.type] failed to remove [action.type] when added to a Xenomorph!")
		if(action.type in added_actions)
			// Remove this action from `added_actions`.
			added_actions -= action.type
	// If there's anything left in `added_actions`, then something wasn't given to the xeno.
	if(length(added_actions))
		TEST_FAIL("[strain.type] failed to give the following actions when added to a Xenomorph: [json_encode(added_actions)]")

	// If the strain has a `/datum/behavior_delegate`, but it wasn't applied to the xeno.
	if(strain.behavior_delegate_type && !istype(fred.behavior_delegate, strain.behavior_delegate_type))
		TEST_FAIL("[strain.type]'s behavior_delegate was not applied when added to a Xenomorph!")

	// If the strain doesn't have a custom icon state set.
	if(!strain.icon_state_prefix)
		// Check if any of the sprites in the xeno's .dmi file belong to this strain.
		// If there are any, it probably means that someone just forgot to add an `icon_state_prefix` to the strain.
		for(var/icon_state in icon_states(fred.icon))
			if(string_starts_with(icon_state, strain.name)) // (This won't catch everything, but it should get the easy ones.)
				TEST_FAIL("[fred.icon] contains sprites for [strain.type] that aren't being used!")
				break

	// If the strain *does* have a custom icon state set, but the xeno's sprite wasn't changed to it.
	else if(!string_starts_with(fred.icon_state, strain.icon_state_prefix))
		TEST_FAIL("[strain.type]'s icon_state_prefix was not applied when added to a Xenomorph!")
