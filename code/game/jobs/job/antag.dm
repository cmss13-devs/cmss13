/datum/job/antag
	department_flag = ROLEGROUP_ANTAG
	selection_class = "job_antag"
	supervisors =   "antagonists"

/datum/job/antag/predator
	title = JOB_PREDATOR
	flag = ROLE_YAUTJA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_NO_ACCOUNT
	flags_whitelist = WHITELIST_YAUTJA
	minimum_playtimes = list()
	supervisors = "Ancients"
	gear_preset = "Yautja Blooded"

/datum/job/antag/predator/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_PREDATOR][WHITELIST_NORMAL]" = "Yautja Blooded",
		"[JOB_PREDATOR][WHITELIST_COUNCIL]" = "Yautja Councillor",
		"[JOB_PREDATOR][WHITELIST_LEADER]" = "Yautja Elder",
		"[JOB_PREDATOR]Elder" = "Yautja Elder"
	)

/datum/job/antag/predator/get_whitelist_status(var/list/roles_whitelist, var/client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_YAUTJA_ELDER)
		if(player.prefs.yautja_status == "Elder")
			return "Elder"

	if(roles_whitelist[player.ckey] & WHITELIST_YAUTJA_LEADER)
		return get_desired_status(player.prefs.yautja_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & WHITELIST_YAUTJA_COUNCIL)
		return get_desired_status(player.prefs.yautja_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_YAUTJA)
		return get_desired_status(player.prefs.yautja_status, WHITELIST_NORMAL)

/datum/job/antag/predator/announce_entry_message(var/mob/new_predator, var/account, var/whitelist_status)
	if(whitelist_status == "Elder" || whitelist_status == WHITELIST_LEADER)
		to_chat(new_predator, SPAN_NOTICE("<B> Welcome Elder!</B>"))
		to_chat(new_predator, SPAN_NOTICE("You are responsible for the well-being of your pupils. Hunting is secondary in priority."))
		to_chat(new_predator, SPAN_NOTICE("That does not mean you can't go out and show the youngsters how it's done."))
		to_chat(new_predator, SPAN_NOTICE("You come equipped as an Elder should, with a bonus glaive and heavy armor."))
	else if(whitelist_status == WHITELIST_COUNCIL)
		to_chat(new_predator, SPAN_NOTICE("<B> Welcome Councillor!</B>"))
		to_chat(new_predator, SPAN_NOTICE("You are responsible for the well-being of your pupils. Hunting is secondary in priority."))
		to_chat(new_predator, SPAN_NOTICE("That does not mean you can't go out and show the youngsters how it's done."))
	else
		to_chat(new_predator, SPAN_NOTICE("You are <B>Yautja</b>, a great and noble predator!"))
		to_chat(new_predator, SPAN_NOTICE("Your job is to first study your opponents. A hunt cannot commence unless intelligence is gathered."))
		to_chat(new_predator, SPAN_NOTICE("Hunt at your discretion, yet be observant rather than violent."))
		to_chat(new_predator, SPAN_NOTICE("And above all, listen to your Elders!"))

/datum/job/antag/predator/generate_entry_conditions(mob/living/M, var/whitelist_status)
	. = ..()

	if(ticker && ticker.mode && whitelist_status == WHITELIST_NORMAL)
		ticker.mode.initialize_predator(M)

