/datum/test_case/sprite/plating_sprites_exist
	name = "All destructable open floor turfs should have plating sprites"

/datum/test_case/sprite/plating_sprites_exist/test()
	var/list/failed_icons = list()
	var/list/icon_state_per_file_cache = list()
	for(var/turf_type in typesof(/turf/open/floor))
		var/turf/open/floor/F = new turf_type(usr.loc)
		if(F.is_grass_floor())
			continue

		var/icon_file = F.icon
		if(!icon_state_per_file_cache["[icon_file]"])
			icon_state_per_file_cache["[icon_file]"] = icon_states(icon_file)
		if(!("plating" in icon_state_per_file_cache["[icon_file]"]))
			failed_icons += icon_file

	message_admins("These icons lack plating sprites: [english_list(failed_icons)]")

	if(length(failed_icons))
		fail("These icons lack plating sprites: [english_list(failed_icons)]")
