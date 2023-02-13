///Checks if spritesheet assets contain icon states with invalid names
/datum/unit_test/spritesheets

/datum/unit_test/spritesheets/Run()
	for(var/datum/asset/spritesheet/sheet as anything in subtypesof(/datum/asset/spritesheet))
		if(!initial(sheet.name)) //Ignore abstract types
			continue
		sheet = get_asset_datum(sheet)
		for(var/sprite_name in sheet.sprites)
			if(!sprite_name)
				TEST_FAIL("Spritesheet [sheet.type] has a nameless icon state.")
