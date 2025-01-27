/// Makes sure objects actually have icons that exist!
/datum/unit_test/missing_icons
	var/static/list/possible_icon_states = list()
	/// additional_icon_location is for downstream modularity support.
	/// Make sure this location is also present in tools/deploy.sh
	/// If you need additional paths ontop of this second one, you can add another generate_possible_icon_states_list("your/folder/path/") below the if(additional_icon_location) block in Run(), and make sure to add that path to tools/deploy.sh as well.
	var/additional_icon_location = null
	/// A cache of known bads to skip calling icon_exists unnecessarily
	var/list/bad_list = list()
	/// A cache of known bads to skip calling icon_exists unnecessarily during warnings
	var/list/bad_list_warnings = list()
	/// States to not search for matches in other files (too common)
	var/list/states_to_ignore = list("", "blank", "door_closed", "door_open", "door_opening")
	/// Additional item slots to test (in addition to defined item_state_slots and item_icons lists).
	/// Use this to specify when all of a slot should have sprites if applicable. Only creates warnings.
	var/list/additional_slots_to_test = list()
	//var/list/additional_slots_to_test = list(WEAR_L_HAND, WEAR_R_HAND, WEAR_FACE, WEAR_BACK, WEAR_JACKET, WEAR_HANDS, WEAR_FEET, WEAR_WAIST, WEAR_EYES, WEAR_HEAD, WEAR_L_EAR, WEAR_R_EAR, WEAR_BODY, WEAR_ID, WEAR_L_STORE, WEAR_R_STORE)

/datum/unit_test/missing_icons/proc/generate_possible_icon_states_list(directory_path)
	if(!directory_path)
		directory_path = "icons/obj/"
	for(var/file_path in flist(directory_path))
		if(findtext(file_path, ".dmi"))
			for(var/sprite_icon in icon_states("[directory_path][file_path]", 1)) //2nd arg = 1 enables 64x64+ icon support, otherwise you'll end up with "sword0_1" instead of "sword"
				possible_icon_states[sprite_icon] += list("[directory_path][file_path]")
		else
			possible_icon_states += generate_possible_icon_states_list("[directory_path][file_path]")

/datum/unit_test/missing_icons/Run()
	generate_possible_icon_states_list()
	generate_possible_icon_states_list("icons/effects/")
	generate_possible_icon_states_list("icons/mob/")
	generate_possible_icon_states_list("icons/turf/")
	if(additional_icon_location)
		generate_possible_icon_states_list(additional_icon_location)

	//Add EVEN MORE paths if needed here!
	//generate_possible_icon_states_list("your/folder/path/")

	var/turf/spawn_at = run_loc_floor_top_right
	var/original_turf_type = spawn_at.type
	var/original_baseturfs = islist(spawn_at.baseturfs) ? spawn_at.baseturfs.Copy() : spawn_at.baseturfs
	var/original_baseturf_count = length(original_baseturfs)

	// Check objects:
	for(var/obj/obj_path as anything in subtypesof(/obj))
		if(ispath(obj_path, /obj/item))
			var/obj/item/item_path = obj_path
			if(initial(item_path.flags_item) & ITEM_ABSTRACT)
				continue // Ignore abstract

		// Ensure that its not invisible/honk in mapping
		var/initial_icon = initial(obj_path.icon)
		var/initial_icon_state = initial(obj_path.icon_state)
		if(!isnull(initial_icon) && !isnull(initial_icon_state))
			check(obj_path, initial_icon, initial_icon_state, check_null=FALSE)

		if(obj_path in GLOB.create_and_destroy_ignore_paths)
			continue

		// Defence specific checks:
		if(ispath(obj_path, /obj/structure/machinery/defenses))
			var/obj/structure/machinery/defenses/defense_path = obj_path
			if(ispath(obj_path, /obj/structure/machinery/defenses/sentry))
				var/obj/structure/machinery/defenses/sentry/sentry_path = obj_path
				var/sentry_icon = initial(defense_path.icon)
				var/base_state = "[initial(sentry_path.defense_type)] [initial(sentry_path.sentry_type)]"
				check(sentry_path, sentry_icon, base_state, "This icon_state is needed for overlays", check_null=FALSE)
				check(sentry_path, sentry_icon, "[base_state]_on", "This icon_state is needed for overlays", check_null=FALSE)
				check(sentry_path, sentry_icon, "[base_state]_noammo", "This icon_state is needed for overlays", check_null=FALSE)
				check(sentry_path, sentry_icon, "[base_state]_destroyed", "This icon_state is needed for overlays", check_null=FALSE)
			if(!initial(defense_path.composite_icon))
				continue // Will just have a null icon_state after update_icon

		var/obj/spawned = new obj_path(spawn_at)
		check_atom(obj_path, spawned)

		// Item specific checks:
		if(ispath(obj_path, /obj/item))
			var/obj/item/item = spawned

			// Explicitly test anything that is garb as an error
			if(item.type in GLOB.allowed_helmet_items)
				var/image/result = item.get_garb_overlay(GLOB.allowed_helmet_items[item.type])
				check(obj_path, result.icon, result.icon_state, "This icon_state is needed as a helmet garb", variable_name="mob_state", check_null=FALSE)
			if(item.type in GLOB.allowed_hat_items)
				var/image/result = item.get_garb_overlay(GLOB.allowed_hat_items[item.type])
				check(obj_path, result.icon, result.icon_state, "This icon_state is needed as a hat garb", variable_name="mob_state", check_null=FALSE)

			// Can ignore a slot in the item as null e.g. item_state_slots = list(WEAR_R_HAND = null, WEAR_L_HAND = null)
			var/list/ignored_slots = list()
			var/list/defined_slots = list()
			for(var/slot in item.item_state_slots)
				if(isnull(item.item_state_slots[slot]))
					ignored_slots |= slot
					continue
				defined_slots |= slot
			for(var/slot in item.item_icons)
				if(isnull(item.item_icons[slot]))
					ignored_slots |= slot
					continue
				defined_slots |= slot
			defined_slots -= WEAR_AS_GARB // Already checked
			for(var/slot in defined_slots)
				var/image/result = item.get_mob_overlay(slot=slot, default_bodytype="Human")
				// States specified in item_state_slots and item_icons (warning only currently)
				check(obj_path, result.icon, result.icon_state, "This icon_state is needed in slot [slot]", variable_name="mob_state", warning_only=TRUE)
			for(var/slot in additional_slots_to_test)
				if(!item.is_valid_slot(slot))
					continue
				if(slot in defined_slots)
					continue
				if(slot in ignored_slots)
					continue
				var/image/result = item.get_mob_overlay(slot=slot, default_bodytype="Human")
				// States specified in additional_slots_to_test not already tested above (warning only currently)
				check(obj_path, result.icon, result.icon_state, "This icon_state is needed in slot [slot]", variable_name="mob_state", warning_only=TRUE)

			// Attachable specific checks:
			if(ispath(obj_path, /obj/item/attachable))
				var/obj/item/attachable/attachable = spawned
				check(obj_path, attachable.icon, attachable.attach_icon, variable_name="attach_icon")
			// Clothing under specific checks:
			else if(ispath(obj_path, /obj/item/clothing/under))
				var/obj/item/clothing/under/under = spawned
				check(obj_path, under.icon, under.worn_state, variable_name="worn_state")
			// Belt specific checks:
			else if(ispath(obj_path, /obj/item/storage/belt))
				var/obj/item/storage/belt/belt = spawned
				// Check _half and _full states if used
				if(!belt.skip_fullness_overlays)
					var/base_state = belt.icon_state
					if(ispath(obj_path, /obj/item/storage/belt/gun))
						var/obj/item/storage/belt/gun/belt_gun = spawned
						base_state = belt_gun.base_icon
					check(obj_path, belt.icon, "+[base_state]_half", "This icon_state is needed for fullness overlays", check_null=FALSE)
					check(obj_path, belt.icon, "+[base_state]_full", "This icon_state is needed for fullness overlays", check_null=FALSE)
				// Check holstered underlays for gun belts
				if(ispath(obj_path, /obj/item/storage/belt/gun))
					var/obj/item/storage/belt/gun/belt_gun = spawned
					var/list/guntypes = list()
					for(var/path in belt_gun.can_hold)
						if(ispath(path, /obj/item/weapon/gun))
							guntypes |= typesof(path)
					for(var/path in belt_gun.cant_hold)
						if(ispath(path, /obj/item/weapon/gun))
							guntypes -= typesof(path)
					var/prefix = ""
					if(belt_gun.gun_has_gamemode_skin)
						switch(SSmapping.configs[GROUND_MAP].camouflage_type)
							if("snow")
								prefix = "s_"
							if("desert")
								prefix = "d_"
							if("classic")
								prefix = "c_"
							if("urban")
								prefix = "u_"
					for(var/obj/item/weapon/gun/guntype as anything in guntypes)
						if(isnull(initial(guntype.icon_state)))
							continue
						if(!guntype.map_specific_decoration)
							check(obj_path, 'icons/obj/items/clothing/belts/holstered_guns.dmi', initial(guntype.icon_state), guntype, "gun_underlay")
						else
							check(obj_path, 'icons/obj/items/clothing/belts/holstered_guns.dmi', prefix + initial(guntype.icon_state), guntype, "gun_underlay")
		qdel(spawned)


	// Check turfs:
	for(var/turf/turf_path as anything in subtypesof(/turf) - GLOB.create_and_destroy_ignore_paths)
		var/turf/spawned = spawn_at.ChangeTurf(turf_path)
		check_atom(turf_path, spawned)

		// Open floor specific checks:
		if(istype(spawned, /turf/open/floor))
			var/turf/open/floor/floor = spawned
			if(floor.turf_flags & TURF_BURNABLE && !(floor.turf_flags & TURF_HULL))
				floor.break_tile()
				check_atom(turf_path, spawned, "This icon_state is needed for break_tile()")
				floor.turf_flags &= ~TURF_BROKEN
			if(floor.turf_flags & TURF_BURNABLE && !(floor.turf_flags & TURF_HULL))
				floor.burn_tile()
				check_atom(turf_path, spawned, "This icon_state is needed for burn_tile()")
				floor.turf_flags &= ~TURF_BURNT

		spawn_at.ChangeTurf(original_turf_type, original_baseturfs)
		if(original_baseturf_count != length(spawn_at.baseturfs))
			TEST_FAIL("[turf_path] changed the amount of baseturfs from [original_baseturf_count] to [length(spawn_at.baseturfs)]; [english_list(original_baseturfs)] to [islist(spawn_at.baseturfs) ? english_list(spawn_at.baseturfs) : spawn_at.baseturfs]")
			//Warn if it changes again
			original_baseturfs = islist(spawn_at.baseturfs) ? spawn_at.baseturfs.Copy() : spawn_at.baseturfs
			original_baseturf_count = length(original_baseturfs)


	// Check mobs:
	for(var/mob/mob_path as anything in subtypesof(/mob) - GLOB.create_and_destroy_ignore_paths)
		var/mob/spawned = new mob_path(spawn_at)
		check_atom(mob_path, spawned)
		qdel(spawned)

/datum/unit_test/missing_icons/proc/check_atom(atom_path, atom/thing, note, skip_overlays_underlays=FALSE)
	check(atom_path, thing.icon, thing.icon_state, note)

	if(!skip_overlays_underlays)
		var/overlay_note = note ? note + " - Overlay" : "Overlay"
		var/underlay_note = note ? note + " - Underlay" : "Underlay"
		for(var/mutable_appearance/layer as anything in thing.overlays)
			if(!layer.icon_state)
				continue // overlay icon_state is never null it seems
			check(atom_path, layer.icon || thing.icon, layer.icon_state, overlay_note)
		for(var/mutable_appearance/layer as anything in thing.underlays)
			if(!layer.icon_state)
				continue // underlay icon_state is never null it seems
			check(atom_path, layer.icon || thing.icon, layer.icon_state, underlay_note)

/datum/unit_test/missing_icons/proc/check(thing_path, icon, icon_state, note, variable_name="icon_state", check_null=TRUE, warning_only=FALSE)
	if(check_null)
		if(isnull(icon))
			return
		if(isnull(icon_state))
			return

	if(icon_state in bad_list[icon])
		return // Already errored, no need to repeat
	if(warning_only && (icon_state in bad_list_warnings[icon]))
		return // Already warned, no need to repeat

	if(icon_exists(icon, icon_state))
		return // Test passed

	if(!warning_only)
		bad_list[icon] += list(icon_state)
	else
		bad_list_warnings[icon] += list(icon_state)

	var/match_message
	if(!(icon_state in states_to_ignore) && (icon_state in possible_icon_states))
		for(var/file_place in possible_icon_states[icon_state])
			match_message += (match_message ? " & '[file_place]'" : "\n\tMatching sprite found in: '[file_place]'")

	if(note)
		note = " ([note])"
	var/variable_value = isnull(icon_state) ? "null" : "\"[icon_state]\""
	var/icon_value = isnull(icon) ? "null" : "'[icon]'"

	var/msg = "Missing sprite for [thing_path]\n\t[variable_name]=[variable_value] icon=[icon_value][note][match_message]"
	if(!warning_only)
		TEST_FAIL(msg)
	else
		TEST_WARN(msg)

/datum/unit_test/missing_icons/log_for_test(text, priority, file, line)
	if(priority == "warning")
		return // TODO: For now 847 warning annotations is just too much noise to be fixed
	return ..()
