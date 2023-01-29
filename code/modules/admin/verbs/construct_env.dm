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
	d=/mob/living/carbon/xenomorph/drone,/turf/open/floor/almayer

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
	set category = "Admin.Events"
	set name = "Construct Map from DMM"

	if(!admin_holder || !(admin_holder.rights & (R_ADMIN|R_DEBUG)))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/input = input(usr, "Enter a DMM script.", "Construct Map") as file|null
	if(!input)
		return

	var/x
	var/y
	var/z

	var/interpreted_coordinates = lowertext(LAZYACCESS(file2list(input), 2))
	var/third_option = null

	if(copytext(interpreted_coordinates, 1, length(DMM_COORDINATE_COMMAND)+1) == DMM_COORDINATE_COMMAND)
		third_option = "Use interpreted co-ordinates"

	switch(alert("Where would you like to construct the map?", "Choose Position", "Here", "Custom", third_option))
		if("Here")
			x = usr.x
			y = usr.y
			z = usr.z
		if("Custom")
			var/usr_x = tgui_input_number(usr, "Enter X position", "Map Position", 0, world.maxx, 0)
			if(!usr_x)
				return
			var/usr_y = tgui_input_number(usr, "Enter Y position", "Map Position", 0, world.maxy, 0)
			if(!usr_y)
				return
			var/usr_z = tgui_input_number(usr, "Enter Z position. Set to 0 to put on a new zlevel", "Map Position", 0, world.maxz, 0)

			x = usr_x
			y = usr_y
			z = usr_z
		if("Use interpreted co-ordinates")
			var/list/L = splittext(interpreted_coordinates, " ",  length(DMM_COORDINATE_COMMAND) + 2)

			x = text2num(LAZYACCESS(L, 1))
			y = text2num(LAZYACCESS(L, 2))
			z = text2num(LAZYACCESS(L, 3))

			if(!x || !y || (z != 0 && !z))
				to_chat(usr, SPAN_WARNING("Failed to construct map using interpreted co-ordinates. (X: [x], Y: [y], Z: [z])"))
				return

	if(alert(usr, "Are you sure you want to construct this DMM file at X: [x], Y: [y], Z: [z]?", "Construct Map", "Yes", "No") != "Yes")
		return

	to_chat(usr, SPAN_NOTICE("Constructing map..."))

	var/show_z = z
	if(show_z == 0)
		show_z = (world.maxz + 1)

	message_staff("[key_name_admin(usr)] is constructing an environment using a DMM file ([input]).", x, y, show_z)

	try
		var/datum/map_load_metadata/M = maploader.load_map(input, x, y, z, TRUE, FALSE, FALSE, TRUE)
		to_chat(src, SPAN_NOTICE("Map has been fully constructed!"))

		for(var/obj/O in M.atoms_to_initialise)
			O.update_icon()
			O.set_pixel_location()

		message_staff("[key_name_admin(usr)] has finished constructing an environment using a DMM file ([input]).", x, y, show_z)
	catch (var/ex)
		to_chat(src, SPAN_NOTICE("Encountered an error whilst constructing the map! [ex]"))
		message_staff("[key_name_admin(usr)] failed to construct the DMM file.")
