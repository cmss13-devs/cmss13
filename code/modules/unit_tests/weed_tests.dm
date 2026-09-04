
// Weed unit tests covering burrowed cooldowns check states the

/datum/unit_test/plant_weeds_creates_node/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node already exists here")

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NOTNULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "no weed node was planted")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, 0, "plasma were not removed deducted")

/datum/unit_test/plant_weeds_sends_signal
	var/signal_received = FALSE

/datum/unit_test/plant_weeds_sends_signal/proc/on_node_planted(datum/source)
	SIGNAL_HANDLER
	signal_received = TRUE

/datum/unit_test/plant_weeds_sends_signal/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	RegisterSignal(xeno_weeder, COMSIG_XENO_PLANT_RESIN_NODE, PROC_REF(on_node_planted))

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT(signal_received, "COMSIG_XENO_PLANT_RESIN_NODE was not sent on plant")

/datum/unit_test/plant_weeds_blocked_off_turf/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	var/obj/item/storage/backpack/holder = allocate(/obj/item/storage/backpack)
	xeno_weeder.forceMove(holder)

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted while the xeno was not on a turf")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent while the xeno was not on a turf")

/datum/unit_test/plant_weeds_blocked_by_dense_turf/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	weeder_turf.density = TRUE

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted on a dense turf")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent on a dense turf")

/datum/unit_test/plant_weeds_blocked_by_unweedable_turf/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	weeder_turf.is_weedable = NOT_WEEDABLE

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted on an unweedable turf")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent on an unweedable turf")

/datum/unit_test/plant_weeds_blocked_by_semiweedable_turf/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")
	TEST_ASSERT(!weeds_ability.plant_on_semiweedable, "this test assumes the drone cannot plant on semiweedable turfs")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	weeder_turf.is_weedable = SEMI_WEEDABLE

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted on a semiweedable turf")

/datum/unit_test/plant_weeds_blocked_by_stronger_node/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	var/obj/effect/alien/weeds/node/existing_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
	existing_node.weed_strength = xeno_weeder.weed_level + 1
	existing_node.hivenumber = xeno_weeder.hivenumber

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NOTNULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "the stronger tier weeds were uprooted")
	TEST_ASSERT(!QDELETED(existing_node), "the stronger node was uprooted")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent against stronger weeds node")

/datum/unit_test/plant_weeds_blocked_by_enemy_node/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	var/obj/effect/alien/weeds/node/enemy_node = allocate(/obj/effect/alien/weeds/node, weeder_turf)
	enemy_node.weed_strength = WEED_LEVEL_WEAK
	enemy_node.hivenumber = XENO_HIVE_CORRUPTED

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT(!QDELETED(enemy_node), "another hive's node was uprooted")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasmas was spent against another hives node")

/datum/unit_test/plant_weeds_blocked_by_resin_trap/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	allocate(/obj/effect/alien/resin/trap, weeder_turf)

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted on top of a resin trap")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent on top of a resin trap")

/datum/unit_test/plant_weeds_blocked_by_hive_weeds/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	var/obj/effect/alien/weeds/hive_weeds = allocate(/obj/effect/alien/weeds, weeder_turf)
	hive_weeds.weed_strength = WEED_LEVEL_HIVE

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted on hive weeds")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent on hive weeds")

/datum/unit_test/plant_weeds_blocked_by_dense_structure/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	var/obj/structure/blocker = allocate(/obj/structure/girder, weeder_turf)
	TEST_ASSERT(blocker.density, "this tests if a weed node was dropped on a dense structure")

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted under a dense structure")
	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent under a dense structure")

/datum/unit_test/plant_weeds_while_rested/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	xeno_weeder.set_body_position(LYING_DOWN)

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "a node was planted despite the weeder resting")

/datum/unit_test/plant_weeds_blocked_while_burrowed/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	ADD_TRAIT(xeno_weeder, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_UNIT_TESTS)

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "node was planted while burrowed")

/datum/unit_test/plant_weeds_blocked_by_plasma/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = get_turf(xeno_weeder)
	xeno_weeder.plasma_stored = weeds_ability.plasma_cost - 1

	weeds_ability.use_ability()

	TEST_ASSERT_NULL(locate(/obj/effect/alien/weeds/node) in weeder_turf, "  node was planted without enough plasma")

/datum/unit_test/plant_weeds_blocked_by_cooldown/Run()
	var/mob/living/carbon/xenomorph/drone/xeno_weeder = allocate(/mob/living/carbon/xenomorph/drone)
	var/datum/action/xeno_action/onclick/plant_weeds/weeds_ability = get_action(xeno_weeder, /datum/action/xeno_action/onclick/plant_weeds)
	TEST_ASSERT_NOTNULL(weeds_ability, "drone did not receive the plant weeds action")

	var/turf/weeder_turf = run_loc_floor_top_right
	xeno_weeder.forceMove(weeder_turf)

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	var/obj/effect/alien/weeds/node/first_node = locate(/obj/effect/alien/weeds/node) in weeder_turf
	TEST_ASSERT_NOTNULL(first_node, "the first node was not planted during setup")

	xeno_weeder.plasma_stored = weeds_ability.plasma_cost
	weeds_ability.use_ability()

	TEST_ASSERT_EQUAL(xeno_weeder.plasma_stored, weeds_ability.plasma_cost, "plasma was spent while the ability was on cooldown")
	TEST_ASSERT(!QDELETED(first_node), "the original node was replaced while on cooldown")
