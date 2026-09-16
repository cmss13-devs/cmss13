/datum/xeno_ability_helpers_constants
	VAR_FINAL/plasma_cost = 100

/datum/action/xeno_action/test__use_plasma
	plasma_cost = /datum/xeno_ability_helpers_constants::plasma_cost

/datum/action/xeno_action/test__use_plasma/use_ability(atom/target)
	. = ..()
	check_and_use_plasma_owner()

/datum/action/xeno_action/test__check_plasma
	plasma_cost = /datum/xeno_ability_helpers_constants::plasma_cost

/datum/action/xeno_action/test__check_plasma/use_ability(atom/target)
	. = ..()
	check_plasma_owner()

/datum/unit_test/using_xeno_action_SHOULD_use_expected_plasma_cost_if_ability_uses_plasma/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize()
	var/datum/action/xeno_action/test__use_plasma/ability = give_action(test_xeno, /datum/action/xeno_action/test__use_plasma)
	TEST_ASSERT_NOTNULL(ability,"Test xeno should have received test ability that consumes plasma")

/datum/unit_test/using_xeno_action_SHOULD
