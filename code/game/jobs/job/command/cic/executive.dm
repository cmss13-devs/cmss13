//Executive Officer
/datum/job/command/executive
	title = JOB_XO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY
	gear_preset = /datum/equipment_preset/uscm_ship/xo

/datum/job/command/executive/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "<a href='[generate_wiki_link()]'>Вы второй по должности на борту [MAIN_SHIP_NAME]</a> и находитесь следующие в цепочке командования после Командующего Офицера. Где это применимо, вы должны соблюдать <a href='[CONFIG_GET(string/wikiarticleurl)][URL_WIKI_CO_RULES]'>Кодекс поведения Командующего Офицера</a>. Вам может потребоваться замещать других сотрудников, если в некоторых областях не хватает персонала, у вас имеются для этого доступы. Пусть ККМП гордится вами!" // SS220 EDIT TRANSLATE
	return ..()

/datum/job/command/executive/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_XO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/executive/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_XO

AddTimelock(/datum/job/command/executive, list(
	JOB_COMMAND_ROLES = 20 HOURS,
	JOB_SQUAD_LEADER = 10 HOURS,
))

/datum/job/command/executive/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "Всем внимание, [H.get_paygrade(0)] [H.real_name] на борту!"), 1.5 SECONDS)	// SS220 EDIT TRANSLATE
	return ..()

/obj/effect/landmark/start/executive
	name = JOB_XO
	icon_state = "xo_spawn"
	job = /datum/job/command/executive
