/datum/unit_test/fortify_activate/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	var/base_deflection = xeno_defender.armor_deflection_buff
	var/base_explosive = xeno_defender.armor_explosive_buff

	fortify_ability.use_ability()

	TEST_ASSERT(xeno_defender.fortify, "fortify was not set when fortifying")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_deflection + 30, "armor deflection buff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.armor_explosive_buff, base_explosive + 60, "explosive armor buff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, MOB_SIZE_IMMOBILE, "xeno did not become knockback immune")
	TEST_ASSERT(HAS_TRAIT(xeno_defender, TRAIT_IMMOBILIZED), "xeno was not immobilized")
	TEST_ASSERT(xeno_defender.anchored, "xeno was not anchored")
	TEST_ASSERT(!xeno_defender.small_explosives_stun, "xeno did not gain the needed immunity")
	TEST_ASSERT(!(xeno_defender.mob_flags & SQUEEZE_UNDER_VEHICLES), "xeno can still squeeze under vehicles")

/datum/unit_test/fortify_round_trip/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

// get base stats
	var/base_deflection = xeno_defender.armor_deflection_buff
	var/base_explosive = xeno_defender.armor_explosive_buff
	var/base_size = xeno_defender.mob_size
	var/base_stun = xeno_defender.small_explosives_stun
	var/base_flags = xeno_defender.mob_flags

	fortify_ability.use_ability()
	fortify_ability.end_cooldown()
	fortify_ability.use_ability()

	TEST_ASSERT(!xeno_defender.fortify, "fortify was not unset")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_deflection, "armor deflection buff was not removed")
	TEST_ASSERT_EQUAL(xeno_defender.armor_explosive_buff, base_explosive, "explosive armor buff was not removed")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, base_size, "mob_size was not restored")
	TEST_ASSERT_EQUAL(xeno_defender.small_explosives_stun, base_stun, "small_explosives_stun was not restored")
	TEST_ASSERT_EQUAL(xeno_defender.mob_flags, base_flags, "mob_flags were not restored")
	TEST_ASSERT(!HAS_TRAIT(xeno_defender, TRAIT_IMMOBILIZED), "xeno was still immobilized")
	TEST_ASSERT(!xeno_defender.anchored, "xeno was still anchored")

/datum/unit_test/fortify_blocked_by_crest/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	xeno_defender.crest_defense = TRUE
	fortify_ability.use_ability()

	TEST_ASSERT(!xeno_defender.fortify, "xeno fortified while its crest was lowered")

/datum/unit_test/fortify_blocked_by_state/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	xeno_defender.evolving = TRUE
	fortify_ability.use_ability()

	TEST_ASSERT(!xeno_defender.fortify, "performed fortify despite check_state()")

/datum/unit_test/fortify_cooldown/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	fortify_ability.use_ability()
	fortify_ability.use_ability()

	TEST_ASSERT(xeno_defender.fortify, "xeno unfortified espite being on cooldown")

/datum/unit_test/fortify_dropped_on_unconscious/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	fortify_ability.use_ability()
	TEST_ASSERT(xeno_defender.fortify, "defender did not fortify during setup")

	xeno_defender.set_stat(UNCONSCIOUS)

	TEST_ASSERT(!xeno_defender.fortify, "defender was fortified while unconscious")
	TEST_ASSERT(!xeno_defender.anchored, "defender was still anchored while unconscious")

/datum/unit_test/fortify_directional_armor/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/activable/fortify/fortify_ability = get_action(xeno_defender, /datum/action/xeno_action/activable/fortify)
	TEST_ASSERT_NOTNULL(fortify_ability, "defender did not receive fortify action")

	xeno_defender.dir = NORTH
	fortify_ability.use_ability()

	var/list/from_front = list("armor" = 0, "direction" = SOUTH)
	SEND_SIGNAL(xeno_defender, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, from_front)
	TEST_ASSERT_EQUAL(from_front["armor"], fortify_ability.frontal_armor, "frontal armor was not applied to a head-on shot")

	var/list/from_behind = list("armor" = 0, "direction" = NORTH)
	SEND_SIGNAL(xeno_defender, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, from_behind)
	TEST_ASSERT_EQUAL(from_behind["armor"], 0, "frontal armor was applied to a shot from behind")
