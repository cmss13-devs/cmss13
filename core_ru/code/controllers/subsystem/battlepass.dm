GLOBAL_LIST_INIT_TYPED(challenge_modules_types, /datum/battlepass_challenge_module, load_battlepass_challenges())

/proc/load_battlepass_challenges()
	var/list/challenges = list()
	for(var/datum/battlepass_challenge_module/challenge_path as anything in subtypesof(/datum/battlepass_challenge_module))
		challenges[initial(challenge_path.code_name)] = challenge_path
	return challenges

SUBSYSTEM_DEF(battlepass)
	name = "Battlepass"
	flags = SS_NO_FIRE
	init_order = SS_INIT_BATTLEPASS

	var/list/marine_battlepass_earners = list()
	var/list/xeno_battlepass_earners = list()

/datum/controller/subsystem/battlepass/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/battlepass/proc/create_challenge(list/available_modules, repeats)
	if(repeats > 5)
		stack_trace("Fatal error in challenge generation")
		return
	var/datum/battlepass_challenge/new_challenge = new
	if(!new_challenge.generate_challenge(available_modules))
		return create_challenge(available_modules, ++repeats)
	return new_challenge

/datum/controller/subsystem/battlepass/proc/give_sides_points(marine_points = 0, xeno_points = 0)
	if(marine_points)
		for(var/datum/entity/battlepass_player/battlepass in marine_battlepass_earners)
			battlepass.add_xp(marine_points)

	if(xeno_points)
		for(var/datum/entity/battlepass_player/battlepass in xeno_battlepass_earners)
			battlepass.add_xp(xeno_points)

/datum/controller/subsystem/battlepass/Shutdown()
	for(var/datum/entity/battlepass_player/battlepass in marine_battlepass_earners + xeno_battlepass_earners)
		battlepass.save()
