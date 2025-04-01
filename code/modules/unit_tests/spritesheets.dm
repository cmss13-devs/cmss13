///Checks if spritesheet assets contain icon states with invalid names
/datum/unit_test/spritesheets

/datum/unit_test/spritesheets/Run()
	var/regex/valid_css_class = new(@"^([\l_][\w\-]|[\l_\-][\l_])")
	for(var/datum/asset/spritesheet/sheet as anything in subtypesof(/datum/asset/spritesheet))
		if(!initial(sheet.name)) //Ignore abstract types
			continue
		sheet = get_asset_datum(sheet)
		for(var/sprite_name in sheet.sprites)
			if(!sprite_name)
				TEST_FAIL("Spritesheet [sheet.type] has a nameless icon state.")
			if(!valid_css_class.Find(sprite_name))
				// https://www.w3.org/TR/CSS2/syndata.html#value-def-identifier
				TEST_FAIL("Spritesheet [sheet.type] has a icon state that doesn't comply with css standards: '[sprite_name]'.")
