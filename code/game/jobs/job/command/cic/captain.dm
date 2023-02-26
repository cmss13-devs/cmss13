//Commander
/datum/job/command/commander
	title = JOB_CO
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = /datum/equipment_preset/uscm_ship/commander
	entry_message_body = "<a href='"+URL_WIKI_CO_GUIDE+"'>You are the Commanding Officer of the USS Almayer as well as the operation.</a> Your goal is to lead the Marines on their mission as well as protect and command the ship and her crew. Your job involves heavy roleplay and requires you to behave like a high-ranking officer and to stay in character at all times. As the Commanding Officer your only superior is High Command itself. You must abide by the <a href='"+URL_WIKI_CO_RULES+"'>Captain's Code of Conduct</a>. Failure to do so may result in punitive action against you. Godspeed."

/datum/job/command/commander/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = /datum/equipment_preset/uscm_ship/commander,
		"[JOB_CO][WHITELIST_COUNCIL]" = /datum/equipment_preset/uscm_ship/commander/council,
		"[JOB_CO][WHITELIST_LEADER]" = /datum/equipment_preset/uscm_ship/commander/council/plus
	)

/datum/job/command/commander/get_whitelist_status(list/roles_whitelist, client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER_LEADER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.commander_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_NORMAL)

/datum/job/command/commander/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(src, PROC_REF(do_announce_entry_message), H), 1.5 SECONDS)
	return ..()

/datum/job/command/commander/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_CO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/commander/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_CO

/datum/job/command/commander/proc/do_announce_entry_message(mob/living/carbon/human/H)
		all_hands_on_deck("Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!")
	//for(var/i in GLOB.co_secure_boxes)
		//var/obj/structure/closet/secure_closet/securecom/S = i
		//var/loc_to_spawn = S.opened ? get_turf(S) : S
		//var/obj/item/weapon/gun/rifle/m46c/I = new(loc_to_spawn)
		//new /obj/item/clothing/suit/storage/marine/MP/CO(loc_to_spawn)
		//new /obj/item/clothing/head/helmet/marine/CO(loc_to_spawn)
		//I.name_after_co(H, I)

/obj/effect/landmark/start/captain
	name = JOB_CO
	job = /datum/job/command/commander
