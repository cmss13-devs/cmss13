// Creates a pair of regular emitter drones and a single receiver drone.
// Tests each permutation of pheromone emission against expected behavior.
/datum/unit_test/pheromones/transmit_permutation__identity_pair/Run()
	var/list/datum/abstract_xenomorph/emitters = list(
		new /datum/abstract_xenomorph(),
		new /datum/abstract_xenomorph()
	)

	var/list/list/expected_permutations = list(
		list(), // No emissions : PERMUTATION 0
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting recovery : PERMUTATION 1
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting frenzy : PERMUTATION 2
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting warding : PERMUTATION 3
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL), // Drone 2 emitting recovery : PERMUTATION 4
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 and Drone 2 emitting recovery : PERMUTATION 5
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting frenzy and Drone 2 emitting recovery : PERMUTATION 6
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting warding and Drone 2 emitting recovery : PERMUTATION 7
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Drone 2 emitting frenzy : PERMUTATION 8
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting recovery and Drone 2 emitting frenzy : PERMUTATION 9
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 and Drone 2 emitting frenzy : PERMUTATION A
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting warding and Drone 2 emitting frenzy : PERMUTATION B
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 2 emitting warding : PERMUTATION C
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting recovery and Drone 2 emitting warding : PERMUTATION D
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 emitting frenzy and Drone 2 emitting warding : PERMUTATION E
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Drone 1 and Drone 2 emitting warding : PERMUTATION F
	)

	reception_permutation_test(
		abstract_emitters = emitters,
		abstract_receiver = new /datum/abstract_xenomorph(),
		test_callback = CALLBACK(src, PROC_REF(permutable_pheromone_validation), expected_permutations)
	)

// Creates a lesser drone, drone, and queen as emitters and a single receiver drone.
// Tests each permutation of pheromone emission against expected behavior.
/datum/unit_test/pheromones/transmit_permutation__strength_triplet/Run()
	var/list/datum/abstract_xenomorph/emitters = list(
		new /datum/abstract_xenomorph(caste = XENO_CASTE_LESSER_DRONE),
		new /datum/abstract_xenomorph(),
		new /datum/abstract_xenomorph(caste = XENO_CASTE_QUEEN)
	)

	var/list/list/expected_permutations = list(
		// ===== Queen emits NOTHING =====
		list(), // Lesser emits nothing, Drone emits nothing : PERMUTATION 0
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK), // Lesser emits recovery, Drone emits nothing : PERMUTATION 01
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK), // Lesser emits frenzy, Drone emits nothing : PERMUTATION 02
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits nothing : PERMUTATION 03
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits recovery : PERMUTATION 04
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits recovery : PERMUTATION 05
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK), // Lesser emits frenzy, Drone emits recovery : PERMUTATION 06
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits recovery : PERMUTATION 07
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits frenzy : PERMUTATION 08
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits frenzy : PERMUTATION 09
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits frenzy, Drone emits frenzy : PERMUTATION 0A
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits frenzy : PERMUTATION 0B
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits warding : PERMUTATION 0C
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits warding : PERMUTATION 0D
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits frenzy, Drone emits warding : PERMUTATION 0E
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits warding, Drone emits warding : PERMUTATION 0F

		// ===== Queen emits RECOVERY =====
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits nothing : PERMUTATION 10
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits nothing : PERMUTATION 11
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK), // Lesser emits frenzy, Drone emits nothing : PERMUTATION 12
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits nothing : PERMUTATION 13
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits recovery : PERMUTATION 14
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits recovery : PERMUTATION 15
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK), // Lesser emits frenzy, Drone emits recovery : PERMUTATION 16
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits recovery : PERMUTATION 17
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits frenzy : PERMUTATION 18
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits frenzy : PERMUTATION 19
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits frenzy, Drone emits frenzy : PERMUTATION 1A
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits frenzy : PERMUTATION 1B
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits warding : PERMUTATION 1C
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits warding : PERMUTATION 1D
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits frenzy, Drone emits warding : PERMUTATION 1E
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits warding, Drone emits warding : PERMUTATION 1F

		// ===== Queen emits FRENZY =====
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits nothing : PERMUTATION 20
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits nothing : PERMUTATION 21
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits nothing : PERMUTATION 22
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits nothing : PERMUTATION 23
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits recovery : PERMUTATION 24
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits recovery : PERMUTATION 25
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits recovery : PERMUTATION 26
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits recovery : PERMUTATION 27
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits frenzy : PERMUTATION 28
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits frenzy : PERMUTATION 29
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits frenzy : PERMUTATION 2A
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_WEAK), // Lesser emits warding, Drone emits frenzy : PERMUTATION 2B
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits nothing, Drone emits warding : PERMUTATION 2C
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits recovery, Drone emits warding : PERMUTATION 2D
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits frenzy, Drone emits warding : PERMUTATION 2E
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_VERY_STRONG, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_NORMAL), // Lesser emits warding, Drone emits warding : PERMUTATION 2F

		// === Queen emits WARDING =====
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits nothing : PERMUTATION 30
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits nothing : PERMUTATION 31
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits nothing : PERMUTATION 32
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits warding, Drone emits nothing : PERMUTATION 33
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits recovery : PERMUTATION 34
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits recovery : PERMUTATION 35
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits recovery : PERMUTATION 36
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits warding, Drone emits recovery : PERMUTATION 37
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits frenzy : PERMUTATION 38
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits frenzy : PERMUTATION 39
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits frenzy : PERMUTATION 3A
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_NORMAL, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits warding, Drone emits frenzy : PERMUTATION 3B
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits nothing, Drone emits warding : PERMUTATION 3C
		list(XENO_PHERO_RECOVERY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits recovery, Drone emits warding : PERMUTATION 3D
		list(XENO_PHERO_FRENZY = XENO_PHERO_STRENGTH_WEAK, XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits frenzy, Drone emits warding : PERMUTATION 3E
		list(XENO_PHERO_WARDING = XENO_PHERO_STRENGTH_VERY_STRONG), // Lesser emits warding, Drone emits warding : PERMUTATION 3F
	)

	reception_permutation_test(
		abstract_emitters = emitters,
		abstract_receiver = new /datum/abstract_xenomorph(),
		test_callback = CALLBACK(src, PROC_REF(permutable_pheromone_validation), expected_permutations)
	)
