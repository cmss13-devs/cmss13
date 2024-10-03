GLOBAL_LIST_INIT(challenge_modules_weighted, load_modules_weighted())

GLOBAL_LIST_INIT(challenge_sub_modules_weighted, load_sub_modules_weighted())

GLOBAL_LIST_INIT(challenge_condition_modules_weighted, load_condition_modules_weighted())

#define BATTLEPASS_HUMAN_CHALLENGE (1<<0)
#define BATTLEPASS_XENO_CHALLENGE (1<<1)
#define BATTLEPASS_CHALLENGE_WEAPON (1<<2)

/proc/load_modules_weighted()
	. = list()
	var/list/modules = subtypesof(/datum/battlepass_challenge_module/main_requirement)
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		.[module] = initial(module.pick_weight)
	return .

/proc/load_sub_modules_weighted()
	. = list()
	var/list/modules = subtypesof(/datum/battlepass_challenge_module/requirement) - list(
		/datum/battlepass_challenge_module/requirement/weapon,
		/datum/battlepass_challenge_module/requirement/good_buffs,
		/datum/battlepass_challenge_module/requirement/bad_buffs
		)
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		.[module] = initial(module.pick_weight)
	return .

/proc/load_condition_modules_weighted()
	. = list()
	var/list/modules = subtypesof(/datum/battlepass_challenge_module/condition)
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		.[module] = initial(module.pick_weight)
	return .

//[ {"desc":"", "xp_completion":0, "mapped_modules":{["cn":"ex", "opt":{"req":{}, ...}], ...}}, ...]
// cn is code name, opt is vars to replace
/datum/battlepass_challenge
	var/name = "Example"
	var/desc = "Example"
	var/xp_completion = 0
	// Modules builder
	var/list/mapped_modules

	// Untracked
	var/completed = FALSE
	var/list/datum/battlepass_challenge_module/modules = list()

	var/client/client_reference

/datum/battlepass_challenge/New(list/opt)
	if(opt)
		for(var/param in opt)
			vars[param] = opt[param]

		for(var/list/list_module in mapped_modules)
			var/target_type = GLOB.challenge_modules_types[list_module["cn"]]
			var/datum/battlepass_challenge_module/module = new target_type(list_module["opt"])
			module.challenge_ref = src
			modules += module

		completed = check_challenge_completed()
		regenerate_desc()

/datum/battlepass_challenge/proc/generate_challenge(list/available_modules)
	var/challenge_type_flag = pick(BATTLEPASS_HUMAN_CHALLENGE, BATTLEPASS_XENO_CHALLENGE)

	var/total_xp_modificator = 1
	var/total_main_modules = rand(1, 3)
	var/list/currentrun_available = available_modules.Copy()
	var/list/modules_removal_pending = list()
	for(var/i = 1, i <= total_main_modules, i++)
		if(!length(currentrun_available))
			break

		var/datum/battlepass_challenge_module/main_requirement/new_module
		while(!new_module && length(currentrun_available))
			var/datum/battlepass_challenge_module/selected_type = pick_weight(currentrun_available)
			if(!(initial(selected_type.mob_challenge_flags) & challenge_type_flag))
				currentrun_available -= selected_type
				modules_removal_pending += selected_type
				continue
			new_module = new selected_type()

		new_module.challenge_ref = src
		if(!new_module.generate_module(challenge_type_flag))
			return FALSE
		modules += new_module

		for(var/datum/battlepass_challenge_module/sub_requirement in new_module.sub_requirements)
			xp_completion += rand(sub_requirement.module_exp[1], sub_requirement.module_exp[2])
			total_xp_modificator *= sub_requirement.module_exp_modificator
		xp_completion += rand(new_module.module_exp[1], new_module.module_exp[2])
		total_xp_modificator *= new_module.module_exp_modificator

		if(i < total_main_modules)
			var/datum/battlepass_challenge_module/condition/and/and_condition = new
			new_module.challenge_ref = src
			if(!new_module.generate_module())
				return FALSE
			modules += and_condition

	xp_completion *= total_xp_modificator
	regenerate_desc()
	available_modules -= modules_removal_pending
	return TRUE

/datum/battlepass_challenge/proc/regenerate_desc()
	name = ""
	var/new_desc = ""
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		name += module.name
		new_desc += module.get_description()
	desc = new_desc

/datum/battlepass_challenge/proc/get_completion_percent()
	return (get_completion_numerator() / get_completion_denominator())

/datum/battlepass_challenge/proc/get_completion_numerator()
	var/current_max = 0
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		if(!length(module.req))
			continue
		for(var/progress_name in module.req)
			current_max += module.req[progress_name][1]
	return current_max

/datum/battlepass_challenge/proc/get_completion_denominator()
	var/current_max = 0
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		if(!length(module.req))
			continue
		for(var/progress_name in module.req)
			current_max += module.req[progress_name][2]
	if(current_max)
		return current_max
	return 1

/datum/battlepass_challenge/proc/check_challenge_completed()
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		if(module.on_possible_challenge_completed())
			continue
		return FALSE
	if(get_completion_numerator() == get_completion_denominator())
		return TRUE
	return FALSE

/datum/battlepass_challenge/proc/on_possible_challenge_completed()
	if(!check_challenge_completed())
		return FALSE
	SEND_SIGNAL(src, COMSIG_BATTLEPASS_CHALLENGE_COMPLETED)
	return TRUE

//Signals
/datum/battlepass_challenge/proc/on_client(client/logged)
	if(logged && !completed)
		client_reference = logged
		if(logged.mob)
			hook_signals(src, logged.mob)
		else
			RegisterSignal(logged, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(hook_signals))

/datum/battlepass_challenge/proc/hook_signals(datum/source, mob/logged_mob)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)

	UnregisterSignal(logged_mob.client, COMSIG_CLIENT_MOB_LOGGED_IN)
	RegisterSignal(logged_mob, COMSIG_MOB_LOGOUT, PROC_REF(unhook_signals))

	if(logged_mob.statistic_exempt)
		return FALSE

	if(should_block_game_interaction(logged_mob))
		return FALSE

	for(var/datum/battlepass_challenge_module/module as anything in modules)
		module.hook_signals(logged_mob)

	return TRUE

/datum/battlepass_challenge/proc/unhook_signals(mob/source)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)

	UnregisterSignal(source, COMSIG_MOB_LOGOUT)
	if(source.logging_ckey in GLOB.directory)
		RegisterSignal(GLOB.directory[source.logging_ckey], COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(hook_signals))

	if(source.statistic_exempt)
		return FALSE

	for(var/datum/battlepass_challenge_module/module as anything in modules)
		module.unhook_signals(source)

	return TRUE

//[ {"desc":"", "xp_completion":0, "mapped_modules":{"killp1": {"cn":"ex","opt":{"req":{}, ...}}, ...}, "progress":{}}, ...]

/datum/battlepass_challenge/proc/serialize()
	SHOULD_CALL_PARENT(TRUE)
	var/list/re_mapped_modules = list()
	for(var/datum/battlepass_challenge_module/module as anything in modules)
		re_mapped_modules += module.serialize(list())
	return list(
		"xp_completion" = xp_completion,
		"mapped_modules" = re_mapped_modules
	)


// Handle moduled req actions to finish challenge
/datum/battlepass_challenge_module
	var/name = "Example"
	var/desc = "Example"
	var/code_name = "ex"
	var/datum/battlepass_challenge/challenge_ref
	var/mob_challenge_flags = BATTLEPASS_HUMAN_CHALLENGE|BATTLEPASS_XENO_CHALLENGE
	var/challenge_flags = NO_FLAGS

	var/pick_weight = 0
	var/module_exp = list(0, 0)
	var/module_exp_modificator = 1

	var/list/req_gen = list()
	var/list/compatibility = list("strict" = list(), "subtyped" = list()) // Проверяется пикая следующее условие, например есть 1 и в 2, теперь время выбрать 3, мы смотрим что в 2 за ограничения на пик

	// Tracked
	var/list/req = list()

/datum/battlepass_challenge_module/New(list/opt)
	if(opt)
		for(var/param in opt)
			vars[param] = opt[param]

/datum/battlepass_challenge_module/proc/generate_module()
	return TRUE

/datum/battlepass_challenge_module/proc/get_description()
	. = initial(desc)
	for(var/name in req)
		. = replacetext_char(., "###[name]###", req[name][2])
	desc = .

/datum/battlepass_challenge_module/proc/hook_signals(mob/logged_mob)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	if(logged_mob.statistic_exempt)
		return FALSE
	return TRUE

/datum/battlepass_challenge_module/proc/unhook_signals(mob/logged_mob)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	if(logged_mob.statistic_exempt)
		return FALSE
	return TRUE

/datum/battlepass_challenge_module/proc/serialize(list/options)
	options["req"] = req
	. = list(list("cn" = code_name, "opt" = options))

/datum/battlepass_challenge_module/proc/on_possible_challenge_completed()
	return TRUE

/datum/battlepass_challenge_module/proc/allow_completion()
	return TRUE

/datum/battlepass_challenge_module/Destroy()
	challenge_ref = null
	. = ..()


// Задача сделать модульные челенджи по типу "Убить 2 ксеноса" + ", с m41a" + " при передозе Oxycodone"
