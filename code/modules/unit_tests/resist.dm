/// Test that stop, drop, and roll lowers fire stacks
/datum/unit_test/stop_drop_and_roll/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)

	TEST_ASSERT_EQUAL(human.fire_stacks, 0, "Human does not have 0 fire stacks pre-ignition")

	human.adjust_fire_stacks(5)
	human.IgniteMob()

	TEST_ASSERT_EQUAL(human.fire_stacks, 5, "Human does not have 5 fire stacks pre-resist")

	// Stop, drop, and roll has a sleep call. This would delay the test, and is not necessary.
	INVOKE_ASYNC(human, /mob/living/verb/resist)

	TEST_ASSERT(human.fire_stacks < 5, "Human did not lower fire stacks after resisting")
