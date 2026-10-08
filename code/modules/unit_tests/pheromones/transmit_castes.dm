/// Spawns xenos in prime hive that are phero emitters including strains and tests it against a prime hive receiver of every possible xenomorph cast for each phero type.
/// Expected behavior is that every receiver properly receives the xeno's pheromones at the appropriate pheromone strength.
/datum/unit_test/pheromones/transmit_castes/Run()
	for(var/caste_name in ALL_XENO_CASTES)
		var/datum/abstract_xenomorph/dummy_xeno_abstract = new (caste = caste_name)
		var/mob/living/carbon/xenomorph/dummy_xeno = dummy_xeno_abstract.initialize(src)
		var/datum/caste_datum/caste = dummy_xeno.caste // We could also just do GLOB.xeno_datum_list[caste_name]

		if(is_path_in_list(/datum/action/xeno_action/onclick/emit_pheromones, dummy_xeno.base_actions))
			QDEL_NULL(dummy_xeno) // We only needed their base_actions

			// Test all pheros on the caste
			for(var/phero_type in ALL_XENO_PHEROMONES)
				var/list/expected_pheromones = list()
				expected_pheromones[phero_type] = caste.aura_strength
				all_caste_reception_test(
					abstract_emitter = dummy_xeno_abstract,
					pheromone_type = phero_type,
					test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
				)

			for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
				var/datum/xeno_strain/strain_instance = new strain_type()
				if(is_path_in_list(/datum/action/xeno_action/onclick/emit_pheromones, strain_instance.actions_to_remove) \
					&& !is_path_in_list(/datum/action/xeno_action/onclick/emit_pheromones, strain_instance.actions_to_add))
					QDEL_NULL(strain_instance) // We only needed its actions_to_remove and actions_to_add
					continue // Strain removes base pheros and doesn't just simply rearrange it
				QDEL_NULL(strain_instance) // We only needed its actions_to_remove and actions_to_add

				// Test all pheros on this strain
				for(var/phero_type in ALL_XENO_PHEROMONES)
					var/list/expected_pheromones = list()
					expected_pheromones[phero_type] = caste.aura_strength + strain_type::phero_mod
					all_caste_reception_test(
						abstract_emitter = new /datum/abstract_xenomorph(
							caste = caste_name,
							initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), strain_type::name)
						),
						pheromone_type = phero_type,
						test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
					)

		else // No pheros in base_actions
			QDEL_NULL(dummy_xeno) // We only needed their base_actions

			for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
				var/datum/xeno_strain/strain_instance = new strain_type()
				if(!is_path_in_list(/datum/action/xeno_action/onclick/emit_pheromones, strain_instance.actions_to_add))
					QDEL_NULL(strain_instance) // We only needed its actions_to_add
					continue // No base pheros and strain doesn't add pheros either
				QDEL_NULL(strain_instance) // We only needed its actions_to_add

				// Test all pheros on this strain
				for(var/phero_type in ALL_XENO_PHEROMONES)
					var/list/expected_pheromones = list()
					expected_pheromones[phero_type] = caste.aura_strength + strain_type::phero_mod
					all_caste_reception_test(
						abstract_emitter = new /datum/abstract_xenomorph(
							caste = caste_name,
							initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), strain_type::name)
						),
						pheromone_type = phero_type,
						test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
					)
