/// Makes sure objects actually have icons that exist!
/datum/unit_test/missing_icons
	var/static/list/possible_icon_states = list()
	/// additional_icon_location is for downstream modularity support.
	/// Make sure this location is also present in tools/deploy.sh
	/// If you need additional paths ontop of this second one, you can add another generate_possible_icon_states_list("your/folder/path/") below the if(additional_icon_location) block in Run(), and make sure to add that path to tools/deploy.sh as well.
	var/additional_icon_location = null
	var/list/bad_list = list()
	var/list/states_to_ignore = list("", "blank", "door_closed", "door_open", "door_opening")

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

	for(var/obj/obj_path as anything in subtypesof(/obj) - GLOB.create_and_destroy_ignore_paths)
		if(ispath(obj_path, /obj/item))
			var/obj/item/item_path = obj_path
			if(initial(item_path.flags_item) & ITEM_ABSTRACT)
				continue

		var/obj/spawned = new obj_path(spawn_at)
		check_atom(obj_path, spawned)
		qdel(spawned)

	for(var/turf/turf_path as anything in subtypesof(/turf) - GLOB.create_and_destroy_ignore_paths)
		var/turf/spawned = spawn_at.ChangeTurf(turf_path)
		check_atom(turf_path, spawned)

		if(istype(spawned, /turf/open/floor))
			var/turf/open/floor/floor = spawned
			if(floor.breakable_tile && !floor.hull_floor)
				floor.break_tile()
				check_atom(turf_path, spawned, "This icon_state is needed for break_tile().")
				floor.broken = FALSE
			if(floor.burnable_tile && !floor.hull_floor)
				floor.burn_tile()
				check_atom(turf_path, spawned, "This icon_state is needed for burn_tile().")
				floor.burnt = FALSE

		spawn_at.ChangeTurf(original_turf_type, original_baseturfs)

	for(var/mob/mob_path as anything in subtypesof(/mob) - GLOB.create_and_destroy_ignore_paths)
		var/mob/spawned = new mob_path(spawn_at)
		check_atom(mob_path, spawned)
		qdel(spawned)

/datum/unit_test/missing_icons/proc/check_atom(atom_path, atom/thing, note)
	if(isnull(initial(thing.icon)))
		return

	if(isnull(initial(thing.icon_state)))
		return

	check(atom_path, thing.icon, thing.icon_state, note)

/datum/unit_test/missing_icons/proc/check(thing_path, icon, icon_state, note)
	if(length(bad_list) && (icon_state in bad_list[icon]))
		return

	if(icon_exists(icon, icon_state))
		return

	bad_list[icon] += list(icon_state)

	var/match_message
	if(!(icon_state in states_to_ignore) && (icon_state in possible_icon_states))
		for(var/file_place in possible_icon_states[icon_state])
			match_message += (match_message ? " & '[file_place]'" : " - Matching sprite found in: '[file_place]'")

	if(note)
		note = "\n[note]"

	TEST_FAIL("Missing icon_state for [thing_path] in '[icon]'.[note]\n\ticon_state = \"[icon_state]\"[match_message]")
