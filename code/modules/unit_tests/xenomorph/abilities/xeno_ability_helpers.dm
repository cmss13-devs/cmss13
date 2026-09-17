/datum/xeno_ability_helpers_constants
	VAR_FINAL/plasma_cost = 100

/datum/action/xeno_action/test__with_plasma_cost
	plasma_cost = /datum/xeno_ability_helpers_constants::plasma_cost

/datum/unit_test/use_plasma_owner_SHOULD_use_plasma_from_owner/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize(src)
	var/datum/action/xeno_action/test__with_plasma_cost/ability = give_action(test_xeno, /datum/action/xeno_action/test__with_plasma_cost)
	TEST_ASSERT_NOTNULL(ability, "Test xeno should have received test ability")

	var/original_plasma = test_xeno.plasma_stored
	var/plasma_to_use = original_plasma
	ability.use_plasma_owner(plasma_to_use)
	TEST_ASSERT_EQUAL(test_xeno.plasma_stored, original_plasma - plasma_to_use, "use_plasma_owner did not consume the expected plasma cost from the owning xeno")

/datum/unit_test/use_plasma_owner_SHOULD_default_to_using_plasma_cost_WHEN_no_argument_is_provided/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize(src)
	var/datum/action/xeno_action/test__with_plasma_cost/ability = give_action(test_xeno, /datum/action/xeno_action/test__with_plasma_cost)
	TEST_ASSERT_NOTNULL(ability, "Test xeno should have received test ability")

	var/original_plasma = test_xeno.plasma_stored
	ability.use_plasma_owner()
	TEST_ASSERT_EQUAL(test_xeno.plasma_stored, original_plasma - ability.plasma_cost, "use_plasma_owner did not consume the expected plasma cost from the owning xeno")

/datum/unit_test/check_plasma_owner_SHOULD_return_TRUE_WHEN_owner_has_enough_plasma/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize(src)
	var/datum/action/xeno_action/test__with_plasma_cost/ability = give_action(test_xeno, /datum/action/xeno_action/test__with_plasma_cost)
	TEST_ASSERT_NOTNULL(ability, "Test xeno should have received test ability")

	var/original_plasma = test_xeno.plasma_stored
	var/plasma_to_use = original_plasma
	var/result = ability.check_plasma_owner(plasma_to_use)
	TEST_ASSERT_EQUAL(result, TRUE, "check_plasma_owner returned FALSE unexpectedly")

/datum/unit_test/check_plasma_owner_SHOULD_return_FALSE_WHEN_owner_does_not_have_enough_plasma/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize(src)
	var/datum/action/xeno_action/test__with_plasma_cost/ability = give_action(test_xeno, /datum/action/xeno_action/test__with_plasma_cost)
	TEST_ASSERT_NOTNULL(ability, "Test xeno should have received test ability")

	var/original_plasma = test_xeno.plasma_stored
	var/plasma_to_use = original_plasma + 1
	var/result = ability.check_plasma_owner(plasma_to_use)
	TEST_ASSERT_EQUAL(result, FALSE, "check_plasma_owner returned TRUE unexpectedly")

/datum/unit_test/check_plasma_owner_SHOULD_default_to_checking_plasma_cost_WHEN_no_argument_is_provided/Run()
	var/datum/abstract_xenomorph/xeno_template = new()
	var/mob/living/carbon/xenomorph/test_xeno = xeno_template.initialize(src)
	var/datum/action/xeno_action/test__with_plasma_cost/ability = give_action(test_xeno, /datum/action/xeno_action/test__with_plasma_cost)
	TEST_ASSERT_NOTNULL(ability, "Test xeno should have received test ability")

	var/original_plasma = test_xeno.plasma_stored
	var/result = ability.check_plasma_owner()
	TEST_ASSERT_EQUAL(result, TRUE, "check_plasma_owner returned FALSE unexpectedly")
