/// Test that map items are set up correctly.
/datum/unit_test/map_sanity

/datum/unit_test/map_sanity/Run()
	var/map_name = SSmapping.configs[GROUND_MAP].map_name
	// this map doesn't need a map (unit testing for almayer, runtime, etc)
	if(!map_should_have_map_item(map_name))
		return
	var/obj/item/map/expected_map = GLOB.map_type_list[map_name]
	if(!expected_map)
		TEST_FAIL("Map [map_name] has no map defined in /proc/setup_all_maps().")
		return
	var/actual_type = SSmapping.configs[GROUND_MAP].map_item_type
	if(expected_map.type != actual_type)
		TEST_FAIL("Map [map_name] is set to use map items [expected_map.type] and [actual_type], which conflict!")
