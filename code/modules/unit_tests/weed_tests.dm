// Unit tests for the Plant Weeds xeno ability.

// Shared setup for the weed tests. Subtypes get a drone, its plant weeds
// action and the turf it is standing on.
/datum/unit_test/weed_test
	var/mob/living/carbon/xenomorph/drone/xeno_weeder
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability
	var/turf/weeder_turf

/datum/unit_test/weed_test/Run()
	SHOULD_CALL_PARENT(FALSE)

/datum/unit_test/weed_test/proc/prepare_weed_unit_test()
	xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	weeder_turf = get_turf(xeno_weeder)

	if(isnull(weeds_ability))
		TEST_FAIL("Test xenomorph [xeno_weeder] did not receive action datum to plant weeds")
		return FALSE

	if(isnull(weeder_turf))
		TEST_FAIL("Test xenomorph [xeno_weeder] was not standing on a turf")
		return FALSE

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	return TRUE

/datum/unit_test/weed_test/plant_weeds_creates_node/Run()
	if(!prepare_weed_unit_test()) // i guess it needs to
		return

	weeds_ability.use_ability()

	TEST_ASSERT_NOTNULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] failed to plant a weed node on its turf")

/datum/unit_test/weed_test/plant_weeds_uses_plasma/Run()
	if(!prepare_weed_unit_test())
		return

	var/plasma_before = xeno_weeder.plasma_stored
	weeds_ability.use_ability()

	TEST_ASSERT_EQUAL(plasma_before - xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "Test xenomorph [xeno_weeder] did not have its plasma properly deducted after planting weeds")

/datum/unit_test/weed_test/plant_weeds_sends_signal
	var/signal_received = FALSE

/datum/unit_test/weed_test/plant_weeds_sends_signal/proc/on_node_planted(datum/source)
	SIGNAL_HANDLER
	signal_received = TRUE

/datum/unit_test/weed_test/plant_weeds_sends_signal/Run()
	if(!prepare_weed_unit_test())
		return

	RegisterSignal(xeno_weeder, COMSIG_XENO_PLANT_RESIN_NODE, PROC_REF(on_node_planted))

	weeds_ability.use_ability()

	TEST_ASSERT(signal_received, "Test xenomorph [xeno_weeder] did not properly receive COMSIG_XENO_PLANT_RESIN_NODE signal after planting weeds")

/datum/unit_test/weed_test/plant_weeds_blocked_off_turf/Run()
	if(!prepare_weed_unit_test())
		return

	var/obj/item/storage/backpack/holder = allocate(/obj/item/storage/backpack)
	xeno_weeder.forceMove(holder)

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] placed a weed node on a turf while inside of a container")

/datum/unit_test/weed_test/plant_weeds_blocked_by_dense_turf/Run()
	if(!prepare_weed_unit_test())
		return

	var/original_density = weeder_turf.density
	weeder_turf.density = TRUE

	weeds_ability.use_ability()

	weeder_turf.density = original_density

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node on a dense turf")

/datum/unit_test/weed_test/plant_weeds_blocked_by_unweedable_turf/Run()
	if(!prepare_weed_unit_test())
		return

	var/original_setting = weeds_ability.plant_on_semiweedable
	weeds_ability.plant_on_semiweedable = TRUE

	var/original_weedable = weeder_turf.is_weedable
	weeder_turf.is_weedable = NOT_WEEDABLE

	weeds_ability.use_ability()

	weeder_turf.is_weedable = original_weedable
	weeds_ability.plant_on_semiweedable = original_setting

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node on an unweedable turf")

/datum/unit_test/weed_test/plant_weeds_blocked_by_semiweedable_turf/Run()
	if(!prepare_weed_unit_test())
		return
	TEST_ASSERT(!weeds_ability.plant_on_semiweedable, "Test failed during initialization: spawned [xeno_weeder] expected to not be able to weed semiweedable turfs, but was initialized with the ability to do so")

	var/original_weedable = weeder_turf.is_weedable
	weeder_turf.is_weedable = SEMI_WEEDABLE

	weeds_ability.use_ability()

	weeder_turf.is_weedable = original_weedable

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node on a semiweedable turf")

/datum/unit_test/weed_test/plant_weeds_blocked_by_stronger_node/Run()
	if(!prepare_weed_unit_test())
		return

	var/obj/effect/alien/weeds/node/existing_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
	existing_node.weed_strength = xeno_weeder.weed_level + 1
	existing_node.hivenumber = xeno_weeder.hivenumber

	weeds_ability.use_ability()

	TEST_ASSERT(!QDELETED(existing_node), "Test xenomorph [xeno_weeder] uprooted a weed node stronger than its own weed level")

// A xeno should never be able to uproot a node belonging to a hive that is not its own.
/datum/unit_test/weed_test/plant_weeds_blocked_by_enemy_node/Run()
	for(var/foreign_hivenumber in GLOB.hive_datum)
		if(!prepare_weed_unit_test())
			return

		if(foreign_hivenumber == xeno_weeder.hivenumber)
			continue

		var/obj/effect/alien/weeds/node/enemy_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
		enemy_node.weed_strength = WEED_LEVEL_WEAK
		enemy_node.hivenumber = foreign_hivenumber

		weeds_ability.use_ability()

		TEST_ASSERT(!QDELETED(enemy_node), "Test xenomorph [xeno_weeder] uprooted a weed node belonging to [foreign_hivenumber]")

		qdel(enemy_node)

/datum/unit_test/weed_test/plant_weeds_blocked_by_resin_trap/Run()
	if(!prepare_weed_unit_test())
		return

	allocate(/obj/effect/alien/resin/trap, weeder_turf)

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node on top of a resin trap")

/datum/unit_test/weed_test/plant_weeds_blocked_by_hive_weeds/Run()
	if(!prepare_weed_unit_test())
		return

	var/obj/effect/alien/weeds/hive_weeds = allocate(/obj/effect/alien/weeds, weeder_turf)
	hive_weeds.weed_strength = WEED_LEVEL_HIVE

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node on top of hive weeds")

/datum/unit_test/weed_test/plant_weeds_blocked_by_dense_structure/Run()
	if(!prepare_weed_unit_test())
		return

	var/obj/structure/blocker = allocate(/obj/structure/girder, weeder_turf)
	TEST_ASSERT(blocker.density, "Test failed during initialization: [blocker] was expected to be dense, but was not")

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node underneath a dense structure")

/datum/unit_test/weed_test/plant_weeds_blocked_while_resting/Run()
	if(!prepare_weed_unit_test())
		return

	xeno_weeder.set_body_position(LYING_DOWN)

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node while resting")

/datum/unit_test/weed_test/plant_weeds_blocked_while_burrowed/Run()
	if(!prepare_weed_unit_test())
		return

	ADD_TRAIT(xeno_weeder, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_UNIT_TESTS)

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node while burrowed")

/datum/unit_test/weed_test/plant_weeds_blocked_by_plasma/Run()
	if(!prepare_weed_unit_test())
		return

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost - 1

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node without enough plasma")

/datum/unit_test/weed_test/plant_weeds_blocked_by_cooldown/Run()
	if(!prepare_weed_unit_test())
		return

	weeder_turf = run_loc_floor_top_right
	xeno_weeder.forceMove(weeder_turf)

	weeds_ability.use_ability()

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	var/plasma_before = xeno_weeder.plasma_stored
	weeds_ability.use_ability()

	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, plasma_before, "Test xenomorph [xeno_weeder] spent plasma planting weeds while the ability was on cooldown")

// Cant root allied hive nodesw
/datum/unit_test/weed_test/plant_weeds_blocked_by_allied_node/Run()
	if(!prepare_weed_unit_test())
		return

	var/datum/hive_status/weeder_hive = GLOB.hive_datum[xeno_weeder.hivenumber]
	TEST_ASSERT_NOTNULL(weeder_hive, "Test failed during initialization: could not resolve the hive of [xeno_weeder]")

	// As per lothers request im reseting the banned allies testing then reapplying the bans because toherweise this would be impossible to test
	var/list/original_banned_allies = weeder_hive.banned_allies
	weeder_hive.banned_allies = list()

	for(var/allied_hivenumber in GLOB.hive_datum)
		var/datum/hive_status/allied_hive = GLOB.hive_datum[allied_hivenumber]
		if(allied_hivenumber == xeno_weeder.hivenumber)
			continue

		var/original_stance = weeder_hive.allies[allied_hive.name]
		weeder_hive.change_stance(allied_hive.name, TRUE)

		var/obj/effect/alien/weeds/node/allied_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
		allied_node.weed_strength = WEED_LEVEL_WEAK
		allied_node.hivenumber = allied_hivenumber

		weeds_ability.use_ability()

		var/node_survived = !QDELETED(allied_node)

		weeder_hive.change_stance(allied_hive.name, original_stance)
		qdel(allied_node)

		if(!node_survived)
			weeder_hive.banned_allies = original_banned_allies
			TEST_FAIL("Test xenomorph [xeno_weeder] uprooted a weed node belonging to allied hive [allied_hivenumber]")
			return

	weeder_hive.banned_allies = original_banned_allies

// semi weedable check
/datum/unit_test/weed_test/plant_weeds_allowed_on_semiweedable_turf/Run()
	if(!prepare_weed_unit_test())
		return

	var/original_setting = weeds_ability.plant_on_semiweedable
	weeds_ability.plant_on_semiweedable = TRUE

	var/original_weedable = weeder_turf.is_weedable
	weeder_turf.is_weedable = SEMI_WEEDABLE

	weeds_ability.use_ability()

	weeder_turf.is_weedable = original_weedable
	weeds_ability.plant_on_semiweedable = original_setting

	TEST_ASSERT_NOTNULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] failed to plant a weed node on a semiweedable turf while allowed to do so")

// Weaker weeds.
/datum/unit_test/weed_test/plant_weeds_replaces_weaker_node/Run()
	if(!prepare_weed_unit_test())
		return

	var/obj/effect/alien/weeds/node/old_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
	old_node.weed_strength = WEED_LEVEL_WEAK
	old_node.hivenumber = xeno_weeder.hivenumber

	var/turf/child_turf = get_step(weeder_turf, NORTH)
	TEST_ASSERT_NOTNULL(child_turf, "Test failed during initialization: there was no turf north of [weeder_turf]")
	TEST_ASSERT(!child_turf.density, "Test failed during initialization: the turf north of [weeder_turf] was dense")

	var/obj/effect/alien/weeds/old_child = new(child_turf, old_node)
	TEST_ASSERT(old_child in old_node.children, "Test failed during initialization weeds did not become child of the old node")

	weeds_ability.use_ability()

	TEST_ASSERT(QDELETED(old_node), "Test xenomorph [xeno_weeder] did not uproot the weaker node of its own hive")

	var/obj/effect/alien/weeds/node/new_node = locate(/obj/effect/alien/weeds/node) in weeder_turf
	TEST_ASSERT_NOTNULL(new_node, "Test xenomorph [xeno_weeder] uprooted the old node but did not plant a replacement")

	var/obj/effect/alien/weeds/converted_child
	for(var/obj/effect/alien/weeds/candidate in child_turf)
		if(candidate.parent == new_node)
			converted_child = candidate
			break

	TEST_ASSERT_NOTNULL(converted_child, "Test xenomorph [xeno_weeder] did not replace the old nodes weeds with weeds belonging to the new node")

// Unweedable flag
/datum/unit_test/weed_test/plant_weeds_blocked_by_unweedable_area/Run()
	if(!prepare_weed_unit_test())
		return

	var/area/weeder_area = get_area(weeder_turf)
	TEST_ASSERT_NOTNULL(weeder_area, "Test failed during initialization: [weeder_turf] had no area")

	var/original_flags = weeder_area.flags_area
	var/original_resin_allowed = weeder_area.is_resin_allowed
	weeder_area.flags_area |= AREA_UNWEEDABLE
	weeder_area.is_resin_allowed = FALSE

	weeds_ability.use_ability()

	weeder_area.flags_area = original_flags
	weeder_area.is_resin_allowed = original_resin_allowed

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node inside an unweedable area")

// Cant resin on early check
/datum/unit_test/weed_test/plant_weeds_blocked_when_too_early/Run()
	if(!prepare_weed_unit_test())
		return

	var/area/weeder_area = get_area(weeder_turf)
	TEST_ASSERT_NOTNULL(weeder_area, "Test failed during initialization: [weeder_turf] had no area")

	var/original_flags = weeder_area.flags_area
	var/original_resin_allowed = weeder_area.is_resin_allowed
	weeder_area.flags_area &= ~AREA_UNWEEDABLE
	weeder_area.is_resin_allowed = FALSE

	weeds_ability.use_ability()

	weeder_area.flags_area = original_flags
	weeder_area.is_resin_allowed = original_resin_allowed

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "Test xenomorph [xeno_weeder] planted a weed node while resin was not yet allowed in the area")
