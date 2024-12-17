/datum/unit_test/duplicate_sprite_accessories/Run()
	var/list/unique_icons_and_states = list()

	for(var/datum/sprite_accessory/accessory as anything in subtypesof(/datum/sprite_accessory))
		if(!length(accessory::icon_state))
			continue

		var/icon_and_state = "[accessory::icon]_[accessory::icon_state]"

		if(icon_and_state in unique_icons_and_states)
			TEST_FAIL("Duplicate sprite accessory [accessory] - icon '[accessory::icon]' and icon_state '[accessory::icon_state]' already in use.")

		unique_icons_and_states += icon_and_state
