PROCESSING_SUBSYSTEM_DEF(round)
	name = "Round"
	init_order = SS_INIT_ROUND
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 5 SECONDS

	///A list of currently active round traits
	var/list/round_traits = list()
	///Assoc list of trait type || assoc list of traits with weighted value. Used for picking traits from a specific category.
	var/list/selectable_traits_by_types = list(ROUND_TRAIT_POSITIVE = list(), ROUND_TRAIT_NEUTRAL = list(), ROUND_TRAIT_NEGATIVE = list())

/datum/controller/subsystem/processing/round/Initialize()

	//If doing unit tests we don't do none of that trait shit ya know?
	// Autowiki also wants consistent outputs, for example making sure the vending machine page always reports the normal products
	#if !defined(UNIT_TESTS) && !defined(AUTOWIKI)
	SetupTraits()
	#endif

	return SS_INIT_SUCCESS

///Rolls for the amount of traits and adds them to the traits list
/datum/controller/subsystem/processing/round/proc/SetupTraits()
	if (CONFIG_GET(flag/forbid_round_traits))
		return

	if (fexists(FUTURE_ROUND_TRAITS_FILE))
		var/forced_traits_contents = file2text(FUTURE_ROUND_TRAITS_FILE)
		fdel(FUTURE_ROUND_TRAITS_FILE)

		var/list/forced_traits_text_paths = json_decode(forced_traits_contents)
		forced_traits_text_paths = SANITIZE_LIST(forced_traits_text_paths)

		for (var/trait_text_path in forced_traits_text_paths)
			var/round_trait_path = text2path(trait_text_path)
			if (!ispath(round_trait_path, /datum/round_trait) || round_trait_path == /datum/round_trait)
				var/message = "Invalid round trait path [round_trait_path] was requested in the future round traits!"
				log_game(message)
				message_admins(message)
				continue

			setup_trait(round_trait_path)

		return

	for(var/datum/round_trait/trait_typepath as anything in subtypesof(/datum/round_trait))

		// If forced, (probably debugging), just set it up now, keep it out of the pool.
		if(initial(trait_typepath.force))
			setup_trait(trait_typepath)
			continue

		if(initial(trait_typepath.trait_flags) & ROUND_TRAIT_ABSTRACT)
			continue //Dont add abstract ones to it
		selectable_traits_by_types[initial(trait_typepath.trait_type)][trait_typepath] = initial(trait_typepath.weight)

	var/human_positive_trait_count = pick(20;0, 5;1, 1;2)
	var/human_negative_trait_count = pick(20;0, 5;1, 1;2)

	var/xeno_positive_trait_count = pick(20;0, 5;1, 1;2)
	var/xeno_negative_trait_count = pick(20;0, 5;1, 1;2)

	var/neutral_trait_count = pick(10;0, 10;1, 3;2)

	pick_traits(ROUND_TRAIT_HUMAN_POSITIVE, human_positive_trait_count)
	pick_traits(ROUND_TRAIT_HUMAN_NEGATIVE, human_negative_trait_count)

	pick_traits(ROUND_TRAIT_XENO_POSITIVE, xeno_positive_trait_count)
	pick_traits(ROUND_TRAIT_XENO_NEGATIVE, xeno_negative_trait_count)

	pick_traits(ROUND_TRAIT_NEUTRAL, neutral_trait_count)

///Picks traits of a specific category (e.g. bad or good) and a specified amount, then initializes them, adds them to the list of traits,
///then removes them from possible traits as to not roll twice.
/datum/controller/subsystem/processing/round/proc/pick_traits(trait_sign, amount)
	if(!amount)
		return
	for(var/iterator in 1 to amount)
		var/datum/round_trait/trait_type = pick_weight(selectable_traits_by_types[trait_sign]) //Rolls from the table for the specific trait type
		selectable_traits_by_types[trait_sign] -= trait_type
		setup_trait(trait_type)

///Creates a given trait of a specific type, while also removing any blacklisted ones from the future pool.
/datum/controller/subsystem/processing/round/proc/setup_trait(datum/round_trait/trait_type)
	if(!trait_type)
		return

	var/datum/round_trait/trait_instance = new trait_type()
	round_traits += trait_instance
	log_game("round trait: [trait_instance.name] chosen for this round.")
	if(!trait_instance.blacklist)
		return
	for(var/i in trait_instance.blacklist)
		var/datum/round_trait/trait_to_remove = i
		selectable_traits_by_types[initial(trait_to_remove.trait_type)] -= trait_to_remove
