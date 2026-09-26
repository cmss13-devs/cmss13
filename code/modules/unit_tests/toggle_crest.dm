/datum/unit_test/proc/check_lower_crest_blocked(mob/living/carbon/xenomorph/defender/xeno_defender, datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff, base_mob_size)
	TEST_ASSERT_EQUAL(xeno_defender.ability_speed_modifier, base_ability_speed_modifier, "speed debuff was applied when lowering crest was blocked")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_armor_deflection_buff, "armor buff was applied when lowering crest was blocked")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, base_mob_size, "mob size was changed when lowering crest was blocked")
	TEST_ASSERT_EQUAL(toggle_crest_ability.button.icon_state, "template_xeno", "ability button was changed when lowering crest was blocked")

/datum/unit_test/proc/check_lower_crest_changes_applied(mob/living/carbon/xenomorph/defender/xeno_defender, datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff)
	TEST_ASSERT_EQUAL(xeno_defender.ability_speed_modifier, base_ability_speed_modifier + toggle_crest_ability.speed_debuff, "speed debuff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.armor_deflection_buff, base_armor_deflection_buff + toggle_crest_ability.armor_buff, "armor buff was not applied")
	TEST_ASSERT_EQUAL(xeno_defender.mob_size, MOB_SIZE_BIG, "mob size was not changed to big")
	TEST_ASSERT_EQUAL(toggle_crest_ability.button.icon_state, "template_active", "ability button was not set to template_active")

/datum/unit_test/lower_crest/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff

	toggle_crest_ability.use_ability()

	TEST_ASSERT(xeno_defender.crest_defense, "crest_defence was not set when lowering crest")
	check_lower_crest_changes_applied(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff)

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

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff
	var/base_mob_size = xeno_defender.mob_size

	xeno_defender.fortify = TRUE
	toggle_crest_ability.use_ability()

	TEST_ASSERT(!xeno_defender.crest_defense, "crest was lowered while fortified")
	check_lower_crest_blocked(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff, base_mob_size)

/datum/unit_test/crest_blocked_by_state/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff
	var/base_mob_size = xeno_defender.mob_size

	xeno_defender.evolving = TRUE
	toggle_crest_ability.use_ability()

	TEST_ASSERT(!xeno_defender.crest_defense, "crest was lowered despite check_state()")
	check_lower_crest_blocked(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff, base_mob_size)

/datum/unit_test/crest_blocked_by_cooldown/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff

	toggle_crest_ability.use_ability()
	toggle_crest_ability.use_ability()

	TEST_ASSERT(xeno_defender.crest_defense, "crest was raised despite being on cooldown")
	check_lower_crest_changes_applied(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff)

/datum/unit_test/crest_ended_by_unconcious/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff
	var/base_mob_size = xeno_defender.mob_size

	toggle_crest_ability.use_ability()
	TEST_ASSERT(xeno_defender.crest_defense, "crest was not lowered during setup")

	xeno_defender.set_stat(UNCONSCIOUS)

	TEST_ASSERT(!xeno_defender.crest_defense, "crest stayed lowered when unconscious")
	check_lower_crest_blocked(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff, base_mob_size)

/datum/unit_test/crest_not_raised_by_non_unconscious_state/Run()
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff

	toggle_crest_ability.use_ability()
	xeno_defender.set_stat(CONSCIOUS)

	TEST_ASSERT(xeno_defender.crest_defense, "crest raised when stat was changed to something that wasn't unconscious")
	check_lower_crest_changes_applied(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff)

/datum/unit_test/crest_changes_not_applied_when_lowering_and_raising_crest_then_going_unconscious/Run() //maybe theres a shorter way to say this
	var/mob/living/carbon/xenomorph/defender/xeno_defender = allocate(/mob/living/carbon/xenomorph/defender)
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_ability = get_action(xeno_defender, /datum/action/xeno_action/onclick/toggle_crest)
	TEST_ASSERT_NOTNULL(toggle_crest_ability, "defender did not receive toggle crest action")

	var/base_ability_speed_modifier = xeno_defender.ability_speed_modifier
	var/base_armor_deflection_buff = xeno_defender.armor_deflection_buff
	var/base_mob_size = xeno_defender.mob_size

	toggle_crest_ability.use_ability()
	TEST_ASSERT(xeno_defender.crest_defense, "crest was not lowered during setup")
	toggle_crest_ability.end_cooldown()
	toggle_crest_ability.use_ability()

	xeno_defender.set_stat(UNCONSCIOUS)

	TEST_ASSERT(!xeno_defender.crest_defense, "crest stat changes were applied")
	check_lower_crest_blocked(xeno_defender, toggle_crest_ability, base_ability_speed_modifier, base_armor_deflection_buff, base_mob_size)
