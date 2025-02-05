//Commander
/datum/job/command/commander
	title = JOB_CO
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = /datum/equipment_preset/uscm_ship/commander

/datum/job/command/commander/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = /datum/equipment_preset/uscm_ship/commander,
		"[JOB_CO][WHITELIST_COUNCIL]" = /datum/equipment_preset/uscm_ship/commander/council,
		"[JOB_CO][WHITELIST_LEADER]" = /datum/equipment_preset/uscm_ship/commander/council/plus
	)

/datum/job/command/commander/generate_entry_message()
	entry_message_body = "<a href='[generate_wiki_link()]'>Вы являетесь Командующим Офицером [MAIN_SHIP_NAME] и операции.</a> Ваша цель — руководить Морпехами в их миссии, а также защищать и командовать кораблем и его командой. Ваша работа подразумевает интенсивную ролевую игру и требует от вас вести себя как высокопоставленный офицер и всегда оставаться в образе. Как Командующий Офицер, вашим единственным начальником является само Верховное Командование. Вы должны соблюдать <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_CO_RULES]'>Кодекс поведения Командующего Офицера</a>. Невыполнение этого требования может привести к карательным мерам против вас. Удачи."	// SS220 EDIT TRANSLATE
	return ..()

/datum/job/command/commander/get_whitelist_status(client/player)
	. = ..()
	if(!.)
		return

	if(player.check_whitelist_status(WHITELIST_COMMANDER_LEADER|WHITELIST_COMMANDER_COLONEL))
		return get_desired_status(player.prefs.commander_status, WHITELIST_LEADER)
	if(player.check_whitelist_status(WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.commander_status, WHITELIST_COUNCIL)
	if(player.check_whitelist_status(WHITELIST_COMMANDER))
		return get_desired_status(player.prefs.commander_status, WHITELIST_NORMAL)

/datum/job/command/commander/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "ВСЕМ внимание, [H.get_paygrade(0)] [H.real_name] на борту!"), 1.5 SECONDS)	// SS220 EDIT TRANSLATE
	return ..()

/datum/job/command/commander/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_CO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/commander/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_CO

/obj/effect/landmark/start/captain
	name = JOB_CO
	icon_state = "co_spawn"
	job = /datum/job/command/commander
