/datum/unit_test/pheromones/transmit_castes/coverage/Run()
	// Put any new castes/strains that can emit pheromones in here after creating a transmit_castes test for said variation
	var/list/emitting_castes = list(XENO_CASTE_DRONE, XENO_CASTE_LESSER_DRONE, XENO_CASTE_HIVELORD, XENO_CASTE_CARRIER, XENO_CASTE_QUEEN, XENO_CASTE_KING) // Only count castes that can emit with their base strain
	var/list/emitting_strains = list(DRONE_HEALER, DRONE_GARDENER, CARRIER_EGGSAC, HIVELORD_DESIGNER, PRAETORIAN_VALKYRIE)

	for (var/caste_name in ALL_XENO_CASTES)
		var/datum/caste_datum/caste = GLOB.RoleAuthority.get_caste_by_text(caste_name)
		if (caste.aura_strength > XENO_PHERO_STRENGTH_NONE && !(caste_name in emitting_castes))
			TEST_FAIL("Found a xenomorph caste [caste_name] define that can emit pheromones but does not have an associated /datum/unit_test/pheromones/transmit_castes subtype unit test. If you are adding a new xenomorph caste, set one up!")

		for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
			var/datum/abstract_xenomorph/dummy_xeno_abstract = allocate(/datum/abstract_xenomorph/, caste_name)
			var/mob/living/dummy_xeno = dummy_xeno_abstract.initialize(src)

			var/datum/xeno_strain/strain_instance = new strain_type()
			strain_instance._add_to_xeno(dummy_xeno)

			if (caste.aura_strength > XENO_PHERO_STRENGTH_NONE && !(strain_type.name in emitting_strains))
				TEST_FAIL("Found a xenomorph strain [strain_type] of [caste_name] that can emit pheromones but does not have an associated /datum/unit_test/pheromones/transmit_castes subtype unit test. If you are adding a new xenomorph strain, set one up!")

/datum/unit_test/pheromones/transmit_castes/drone/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/drone/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/drone/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/drone/healer/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), DRONE_HEALER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/drone/healer/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/drone/healer/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/drone/gardener/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), DRONE_HEALER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/drone/gardener/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/drone/gardener/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/lesser/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_WEAK

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_LESSER_DRONE),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/lesser/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/lesser/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/hivelord/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_HIVELORD

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_HIVELORD),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/hivelord/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/hivelord/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/hivelord/designer/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_HIVELORD + XENO_PHERO_MOD_LARGE

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_HIVELORD,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), HIVELORD_DESIGNER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/hivelord/designer/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/hivelord/designer/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/carrier/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_CARRIER),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/carrier/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/carrier/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_CARRIER,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), CARRIER_EGGSAC)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/praetoreon/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_PRAETORIAN,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), PRAETORIAN_VALKYRIE)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/praetoreon/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/praetoreon/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/queen/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_VERY_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_QUEEN),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/queen/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/queen/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/transmit_castes/king/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_OVERWHELMING

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_KING),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/datum/unit_test/pheromones/transmit_castes/king/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/datum/unit_test/pheromones/transmit_castes/king/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/datum/unit_test/pheromones/proc/set_strain_on_init(strain_name, mob/living/carbon/xenomorph/xeno)
	var/list/datum/xeno_strain/strain_list = list()
	for(var/datum/xeno_strain/strain_type as anything in xeno.caste.available_strains)
		strain_list[initial(strain_type.name)] = strain_type

	var/datum/xeno_strain/chosen_strain = strain_list[strain_name]
	TEST_ASSERT_NOTNULL(chosen_strain, "Failed to find specified strain [strain_name] on [xeno] during test initializtion")

	var/datum/xeno_strain/strain_instance = new chosen_strain()
	strain_instance._add_to_xeno(xeno)
