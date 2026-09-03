/datum/unit_test/lower_crest/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff

	toggle_crest_ability.use_ability()

	TEST_ASSERT(xeno_defender.crest_defense, "crest_defence was not set when lowering crest")
	TEST_ASSERT_EQUAL(xeno_defender.ability_speed_modifier, base_ability_speed_modifier + toggle_crest_ability.speed_debuff, "speed debuff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_armor_deflection_buff + toggle_crest_ability.armor_buff, "armor buff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, MOB_SIZE_BIG, "mob size was not changed to big")
	TEST_ASSERT_EQUAL(toggle_crest_ability.button.icon_state, "template_active", "ability button was not set to template_active")

/datum/unit_test/raise_crest/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff
	var/base_mob_size = xeno_defender.mob_size

	toggle_crest_ability.use_ability()
	toggle_crest_ability.end_cooldown()
	toggle_crest_ability.use_ability()

	TEST_ASSERT(!xeno_defender.crest_defense, "crest_defence was not unset when raising crest")
	TEST_ASSERT_EQUAL(xeno_defender.ability_speed_modifier, base_ability_speed_modifier, "speed debuff was not removed")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_armor_deflection_buff, "armor buff was not removed")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, base_mob_size, "mob size was not restored")
	TEST_ASSERT_EQUAL(toggle_crest_ability.button.icon_state, "template_xeno", "ability button was not set to template_xeno")

/datum/unit_test/crest_blocked_by_fortify/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	xeno_defender.fortify = TRUE
	toggle_crest_ability.use_ability()

	TEST_ASSERT(!xeno_defender.crest_defense, "crest was lowered while fortified")

/datum/unit_test/crest_blocked_by_state/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	xeno_defender.evolving = TRUE
	toggle_crest_ability.use_ability()

	TEST_ASSERT(!xeno_defender.crest_defense, "crest was lowered despite check_state()")

/datum/unit_test/crest_blocked_by_cooldown/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	toggle_crest_ability.use_ability()
	toggle_crest_ability.use_ability()

	TEST_ASSERT(xeno_defender.crest_defense, "crest was raised despite being on cooldown")
