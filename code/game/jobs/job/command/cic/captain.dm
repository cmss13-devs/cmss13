//Commander
/datum/job/command/commander
	title = JOB_CO
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = "USCM Captain (CO)"

/datum/job/command/commander/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = "USCM Captain (CO)",
		"[JOB_CO][WHITELIST_COUNCIL]" = "USCM Commodore (CO+)",
		"[JOB_CO][WHITELIST_LEADER]" = "USCM Commodore (CO++)"
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

/datum/job/command/commander/generate_entry_message()
	entry_message_body = "Your job is HEAVY ROLE PLAY and requires you to stay IN CHARACTER at all times. While you support Weston-Yamada, you report to the USCM High Command, not the corporate office. Your primary task is the safety of the ship and her crew, and ensuring the survival and success of the marines. Your first order of business should be briefing the marines on the mission they are about to undertake. If you require any help, use adminhelp to talk to game staff about what you're supposed to do. Godspeed, captain!"
	return ..()

/datum/job/command/commander/announce_entry_message(mob/living/carbon/human/H)
	if(flags_startup_parameters & ROLE_ADD_TO_MODE && map_tag != MAP_WHISKEY_OUTPOST)
		addtimer(CALLBACK(src, .proc/do_announce_entry_message, H), 1.5 SECONDS)
	..()

/datum/job/command/commander/proc/do_announce_entry_message(mob/living/carbon/human/H)
	ai_announcement("Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!")
	for(var/i in GLOB.co_secure_boxes)
		var/obj/structure/closet/secure_closet/securecom/S = i
		var/loc_to_spawn = S.opened ? get_turf(S) : S
		var/obj/item/weapon/gun/rifle/m46c/I = new(loc_to_spawn)
		new /obj/item/clothing/suit/storage/marine/MP/CO(loc_to_spawn)
		new /obj/item/clothing/head/helmet/marine/CO(loc_to_spawn)
		I.name_after_co(H, I)

/datum/job/command/commander/nightmare
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED

/datum/job/command/commander/nightmare/generate_entry_message()
	entry_message_body = "What the hell did you do to get assigned on this mission? Maybe someone is looking to bump you off for a promotion. Regardless... The marines need a leader to inspire them and lead them to victory. You'll settle for telling them which side of the gun the bullets come from. You are a vet, a real badass in your day, but now you're in the thick of it with the grunts. You're plenty sure they are going to die in droves. Come hell or high water, you are going to be there for them."
	return ..()