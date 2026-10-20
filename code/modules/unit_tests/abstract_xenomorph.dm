/// Helper datum used for unit testing that defines a xenomorph solely based on a few abstract qualities.
/datum/abstract_xenomorph
	var/hive //! The hive that this xeno will be a part of.
	var/caste //! The caste that this xeno will be spawned as.

	/// A callback that can be used for modifying the xenomorph after full instantiation. Takes one argument, which is the living/carbon/xenomorph that was instantiated.
	///
	/// Used for things like banishment, movement, setting health, et cetera.
	var/datum/callback/initialization_callback

/datum/abstract_xenomorph/New(hive = XENO_HIVE_NORMAL, caste = XENO_CASTE_DRONE, datum/callback/initialization_callback)
	src.hive = hive
	src.caste = caste

	src.initialization_callback = initialization_callback

/// Initializes an abstract xenomorph into a living, breathing mob. Spawns on the lower leftmost testing turf.
/datum/abstract_xenomorph/proc/initialize(datum/unit_test/testing_environment)
	var/mob/living/carbon/xenomorph/xeno = testing_environment.allocate(GLOB.RoleAuthority.get_caste_by_text(caste))
	xeno.loc = testing_environment.run_loc_floor_bottom_left
	xeno.set_hive_and_update(hive)

	if (initialization_callback)
		initialization_callback.Invoke(xeno)

	return xeno
