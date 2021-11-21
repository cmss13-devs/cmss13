//Commander
/datum/job/command/commander
	title = JOB_CO
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = /datum/equipment_preset/uscm_ship/commander
	entry_message_body = "You are the Captain of the USS Almayer and the Commanding Officer of the operation. Your goal is to lead the Marines on their mission as well as protect and command the ship and her crew. Your job involves heavy roleplay and requires you to behave like a high-ranking officer and to stay in character at all times. As the Commanding Officer your only superior is High Command itself. You must abide by the <a href='"+URL_WIKI_CO_RULES+"'>Captain's Code of Conduct</a>. Failure to do so may result in punitive action against you. Godspeed, captain."

/datum/job/command/commander/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = /datum/equipment_preset/uscm_ship/commander,
		"[JOB_CO][WHITELIST_COUNCIL]" = /datum/equipment_preset/uscm_ship/commander/commodore,
		"[JOB_CO][WHITELIST_LEADER]" = /datum/equipment_preset/uscm_ship/commander/commodore/plus
	)

/datum/job/command/commander/get_whitelist_status(var/list/roles_whitelist, var/client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER_LEADER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER_COUNCIL)
		return get_desired_status(player.prefs.commander_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_COMMANDER)
		return get_desired_status(player.prefs.commander_status, WHITELIST_NORMAL)

/datum/job/command/commander/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(src, .proc/do_announce_entry_message, H), 1.5 SECONDS)
	return ..()

/datum/job/command/commander/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.roundstart_leaders += M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/cleanup_leader_candidate)

/datum/job/command/commander/proc/cleanup_leader_candidate(var/mob/M)
	SIGNAL_HANDLER
	GLOB.roundstart_leaders -= M

/datum/job/command/commander/proc/do_announce_entry_message(mob/living/carbon/human/H)
	shipwide_ai_announcement("Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!")
	//for(var/i in GLOB.co_secure_boxes)
		//var/obj/structure/closet/secure_closet/securecom/S = i
		//var/loc_to_spawn = S.opened ? get_turf(S) : S
		//var/obj/item/weapon/gun/rifle/m46c/I = new(loc_to_spawn)
		//new /obj/item/clothing/suit/storage/marine/MP/CO(loc_to_spawn)
		//new /obj/item/clothing/head/helmet/marine/CO(loc_to_spawn)
		//I.name_after_co(H, I)

/datum/job/command/commander/nightmare
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	entry_message_body = "What the hell did you do to get assigned on this mission? Maybe someone is looking to bump you off for a promotion. Regardless... The marines need a leader to inspire them and lead them to victory. You'll settle for telling them which side of the gun the bullets come from. You are a vet, a real badass in your day, but now you're in the thick of it with the grunts. You're plenty sure they are going to die in droves. Come hell or high water, you are going to be there for them."

/obj/effect/landmark/start/captain
	name = JOB_CO
	job = /datum/job/command/commander
