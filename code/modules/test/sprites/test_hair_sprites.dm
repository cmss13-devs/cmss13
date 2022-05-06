/datum/test_case/sprite/hair_sprites_exist
	name = "All hair and facial hair styles should have sprites"

/datum/test_case/sprite/hair_sprites_exist/test()
	var/list/failed_styles = list()
	var/list/icon_state_per_file_cache = list()
	for(var/datum/sprite_accessory/testing_style as anything in subtypesof(/datum/sprite_accessory/hair) + subtypesof(/datum/sprite_accessory/facial_hair))
		var/icon_file = initial(testing_style.icon)
		if(!icon_state_per_file_cache["[icon_file]"])
			icon_state_per_file_cache["[icon_file]"] = icon_states(icon_file)
		if(!("[initial(testing_style.icon_state)]_s" in icon_state_per_file_cache["[icon_file]"]))
			failed_styles += initial(testing_style.name)

	// Check that no space turfs were found
	if(length(failed_styles))
		fail("These hairstyles lack sprites: [english_list(failed_styles)]")
