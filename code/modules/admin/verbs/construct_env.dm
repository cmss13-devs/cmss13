/*
	Example scripts:

	HHHHHHHHHHH
	HFFFFFFFFFH
	HFFgFFFFFFH
	HFFFFmFFdFH
	HFFFFFFFFFH
	HHHHHHHHHHH
	===
	g=/obj/item/weapon/gun/rifle/m41a,/turf/open/floor/almayer
	m=/mob/living/carbon/human,/turf/open/floor/almayer
	d=/mob/living/carbon/Xenomorph/Drone,/turf/open/floor/almayer

	SSSSSWwwwWSSSSS
	SSSSSWFFFWSSSSS
	SSSSSWFFFWSSSSS
	WWWWWWWnWWWWWWW
	WbfffWFFFWffffW
	wtfffdFFFdffffw
	WffffWFFFWtffbW
	WWWWWWFFFWWWWWW
	WbfffWFFFWffffW
	wtfffdFFFdffffw
	WffffWFFFWtffbW
	WWWWWWwwwWWWWWW
	===
	w=/obj/structure/window/framed/almayer,/turf/open/floor/almayer
	d=/obj/structure/machinery/door/airlock/almayer,/turf/open/floor/almayer
	n=/obj/structure/machinery/door/airlock/almayer{N},/turf/open/floor/almayer
	b=/obj/structure/bed,/obj/item/bedsheet/blue,/turf/open/floor/wood
	t=/obj/structure/surface/table/woodentable,/obj/item/device/flashlight/lamp/green,/turf/open/floor/wood
	f=/turf/open/floor/wood
*/
/client/proc/construct_env_dmm()
	set category = "Event"
	set name = "C: Construct Map from DMM"

	if(!admin_holder || !(admin_holder.rights & (R_ADMIN|R_DEBUG)))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/input = input(usr, "Enter a DMM script.", "Construct Map") as file|null
	if(!input)
		return

	var/x
	var/y
	var/z

	switch(alert("Where would you like to construct the map?", "Choose Position", "Here", "Custom"))
		if("Here")
			x = usr.x
			y = usr.y
			z = usr.z
		if("Custom")
			var/usr_x = input(usr, "Enter X position", "Map Position") as num|null
			if(!usr_x)
				return
			var/usr_y = input(usr, "Enter Y position", "Map Position") as num|null
			if(!usr_y)
				return
			var/usr_z = input(usr, "Enter Z position. Set to 0 to put on a new zlevel", "Map Position") as num|null

			x = usr_x
			y = usr_y
			z = usr_z

	if(alert(usr, "Are you sure you want to construct this DMM file at X: [x], Y: [y], Z: [z]?", "Construct Map", "Yes", "No") == "No")
		return

	to_chat(usr, SPAN_NOTICE("Constructing map..."))

	var/show_z = z
	if(show_z == 0)
		show_z = (world.maxz + 1)

	message_staff("[key_name_admin(usr)] is constructing an environment using a DMM file.", x, y, show_z)

	try
		var/datum/map_load_metadata/M = maploader.load_map(input, x, y, z, TRUE, FALSE, FALSE, TRUE)
		to_chat(src, SPAN_NOTICE("Map has been fully constructed!"))
		
		for(var/obj/O in M.atoms_to_initialise)
			O.update_icon()
			O.set_pixel_location()
		message_staff("[key_name_admin(usr)] has finished constructing an environment using a DMM file.", x, y, show_z)
	catch (var/ex)
		to_chat(src, SPAN_NOTICE("Encountered an error whilst constructing the map! [ex]"))
		message_staff("[key_name_admin(usr)] failed to construct the DMM file.")



/client/proc/construct_env()
	set category = "Event"
	set name = "C: Construct Environment"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/input = input(usr, "Enter an environment script.", "Construct Environment") as message|null
	if(!input)
		return

	var/list/env_script = splittext(input, "===")
	if(length(env_script) != 2)
		to_chat(usr, SPAN_WARNING("Invalid environment script! The script should contain an environment string and assignments, split by ==="))
		return

	// A list of errors that were encountered during script parsing
	var/list/errors = null

	var/env_string = trim(env_script[1])
	var/list/assignment_lines = splittext(env_script[2], "\n")
	var/list/env_assignments = null

	var/regex/dir_regex = new("\\{(N|S|W|E)\\}$")

	for(var/line in assignment_lines)
		// Ignore empty lines
		if(!length(line))
			continue

		// Check that the line contains exactly two parts, split by a =
		var/list/assignment = splittext(line, "=")
		if(length(assignment) != 2)
			LAZYADD(errors, "[line]: invalid assignment")
			continue

		// Check that the key/character is just 1 character long
		var/assignment_key = assignment[1]
		if(length(assignment_key) != 1)
			LAZYADD(errors, "[line]: assignment key must be one character")
			continue

		// Check that the key isn't a prefab/reserved
		if(assignment_key in test_env_prefab_types)
			LAZYADD(errors, "[line]: assignment key '[assignment_key]' is reserved")
			continue

		// Check that the assignment value(s) can be converted to a typepath (and dir)
		var/assignments = null
		var/list/types_to_spawn = splittext(assignment[2], ",")
		if(!types_to_spawn)
			LAZYADD(errors, "[line]: found no types to assign key to")
			continue

		for(var/path in types_to_spawn)
			var/text = trim(path)

			var/dir_to_use = null
			if(dir_regex.Find(text))
				switch(dir_regex.group[1])
					if("N")
						dir_to_use = NORTH
					if("S")
						dir_to_use = SOUTH
					if("W")
						dir_to_use = WEST
					if("E")
						dir_to_use = EAST

			if(dir_to_use)
				text = copytext(text, 1, length(text)-2)

			var/type = text2path(text)
			if(!type)
				LAZYADD(errors, "[line]: couldn't convert all assignment values to typepaths")
				continue

			LAZYSET(assignments, type, dir_to_use)

		// Check that the key hasn't been assigned a value already
		var/key_assignment = LAZYACCESS(env_assignments, assignment_key)
		if(key_assignment)
			LAZYADD(errors, "[line]: assignment key '[assignment_key]' has already been assigned to [key_assignment]")
			continue

		// Assign the key/character to a typepath
		LAZYSET(env_assignments, assignment_key, assignments)

	// Check that all custom characters in the env string were assigned to a type
	for(var/line in splittext(env_string, "\n"))
		for(var/char in splittext(line, regex("."), 1, 0, TRUE))
			if(!char)
				continue

			// Prefab characters don't count
			if(char in test_env_prefab_types || char == "\n")
				continue

			// If the key was assigned to a 
			if(LAZYACCESS(env_assignments, char))
				continue
			
			LAZYADD(errors, "custom symbol '[char]' was not assigned a typepath")

	// Give up if there were any errors
	if(errors)
		to_chat(usr, SPAN_WARNING("The environment script could not be executed due to the following errors:"))
		for(var/message in errors)
			to_chat(usr, message)
		return

	var/datum/test_environment/env = new()

	switch(alert("Where would you like to construct the environment?", "Choose Position", "Here", "Custom"))
		if("Here")
			env.x = usr.x
			env.y = usr.y
			env.z = usr.z
		if("Custom")
			var/x = input(usr, "Enter X position", "Environment Position") as num|null
			if(!x)
				return
			var/y = input(usr, "Enter Y position", "Environment Position") as num|null
			if(!y)
				return
			var/z = input(usr, "Enter Z position", "Environment Position") as num|null
			if(!z)
				return

			env.x = x
			env.y = y
			env.z = z

	env.environment_string = env_string
	env.environment_assignments = env_assignments

	to_chat(src, SPAN_NOTICE("Constructing environment..."))
	env.initialize()
