/datum/job/command
	department_flag = ROLEGROUP_MARINE_COMMAND
	selection_class = "job_command"
	supervisors = "the acting commanding officer"
	total_positions = 1
	spawn_positions = 1

//Commander
/datum/job/command/commander
	title = JOB_CO
	flag = ROLE_COMMANDING_OFFICER
	supervisors = "USCM high command"
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER
	gear_preset = "USCM Captain (CO)"
	minimum_playtimes = list()

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
	sleep(15)
	if(H && H.loc && flags_startup_parameters & ROLE_ADD_TO_MODE && map_tag != MAP_WHISKEY_OUTPOST)
		ai_announcement("Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!")
		for(var/obj/structure/closet/secure_closet/securecom/S in world)
			var/obj/item/weapon/gun/rifle/m46c/I = new/obj/item/weapon/gun/rifle/m46c/
			var/obj/item/clothing/suit/storage/marine/MP/CO/suit = new/obj/item/clothing/suit/storage/marine/MP/CO/
			var/obj/item/clothing/head/helmet/marine/CO/head = new/obj/item/clothing/head/helmet/marine/CO/
			if(S.opened == 0)
				I.loc = S
				suit.loc = S
				head.loc = S
			if(S.opened == 1)
				I.loc = S.loc
				suit.loc = S.loc
				head.loc = S.loc
			if(istype(I))
				call(/obj/item/weapon/gun/rifle/m46c/proc/name_after_co)(H, I)
	..()

/datum/job/command/commander/nightmare
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED

/datum/job/command/commander/nightmare/generate_entry_message()
	entry_message_body = "What the hell did you do to get assigned on this mission? Maybe someone is looking to bump you off for a promotion. Regardless... The marines need a leader to inspire them and lead them to victory. You'll settle for telling them which side of the gun the bullets come from. You are a vet, a real badass in your day, but now you're in the thick of it with the grunts. You're plenty sure they are going to die in droves. Come hell or high water, you are going to be there for them."
	return ..()

//Executive Officer
/datum/job/command/executive
	title = JOB_XO
	flag = ROLE_EXECUTIVE_OFFICER
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY
	gear_preset = "USCM Executive Officer (XO)"
	minimum_playtimes = list(
		JOB_COMMAND_ROLES = HOURS_3
	)

/datum/job/command/executive/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are second in command aboard the ship, and are in next in the chain of command after the commanding officer. You may need to fill in for other duties if areas are understaffed, and you are given access to do so. Make the USCM proud!"
	return ..()

//Staff Officer
/datum/job/command/bridge
	title = JOB_SO
	flag = ROLE_BRIDGE_OFFICER
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Staff Officer (SO)"
	minimum_playtimes = list(
		JOB_SQUAD_LEADER = HOURS_3,
		JOB_REQUISITION = HOURS_3
	)

/datum/job/command/bridge/set_spawn_positions(var/count)
	spawn_positions = so_slot_formula(count)

/datum/job/command/bridge/get_total_positions(var/latejoin = 0)
	return (latejoin ? so_slot_formula(get_total_marines()) : spawn_positions)

/datum/job/command/bridge/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to monitor the marines, man the CIC, and listen to your superior officers. You are in charge of logistics and the overwatch system. You are also in line to take command after the executive officer."
	return ..()

//Pilot Officer
/datum/job/command/pilot
	title = JOB_PILOT
	flag = ROLE_PILOT_OFFICER
	total_positions = 3
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Pilot Officer (PO) (Cryo)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_6
	)

/datum/job/command/pilot/set_spawn_positions(var/count)
	spawn_positions = po_slot_formula(count)

/datum/job/command/pilot/get_total_positions(var/latejoin = 0)
	return (latejoin ? po_slot_formula(get_total_marines()) : spawn_positions)

/datum/job/command/pilot/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to fly, protect, and maintain the ship's dropship. While you are an officer, your authority is limited to the dropship, where you have authority over the enlisted personnel. If you are not piloting, there is an autopilot fallback for command, but don't leave the dropship without reason."
	return ..()

//Tank Crewmen //For now, straight up copied from the pilot officers until their role is more solidified
/datum/job/command/tank_crew
	title = JOB_CREWMAN
	flag = ROLE_CREWMAN
	total_positions = 2
	spawn_positions = 0
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Vehicle Crewman (CRMN) (Cryo)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_6,
		JOB_SQUAD_ENGI = HOURS_3
	)

/datum/job/command/tank_crew/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to operate and maintain the ship's armored vehicles. You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own tank."
	return ..()

/datum/job/command/tank_crew/set_spawn_positions(var/count)
	spawn_positions = tank_slot_formula(count)

/datum/job/command/tank_crew/get_total_positions(var/latejoin = 0)
	return (latejoin ? tank_slot_formula(get_total_marines()) : spawn_positions)

//Intelligence Officer
/datum/job/command/intel
	title = JOB_INTEL
	flag = ROLE_INTEL_OFFICER
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Intelligence Officer (IO) (Cryo)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_6
	)

/datum/job/command/intel/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to assist the marines in collecting intelligence related to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds in order to decrypt any data in order to further the DEFCON status."
	return ..()

/datum/job/command/intel/set_spawn_positions(var/count)
	spawn_positions = int_slot_formula(count)

/datum/job/command/intel/get_total_positions(var/latejoin = 0)
	return (latejoin ? int_slot_formula(get_total_marines()) : spawn_positions)

//Military Police
/datum/job/command/police
	title = JOB_POLICE
	flag = ROLE_MILITARY_POLICE
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Military Police (MP)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_9
	)

/datum/job/command/police/set_spawn_positions(var/count)
	spawn_positions = mp_slot_formula(count)

/datum/job/command/police/get_total_positions(var/latejoin = 0)
	return (latejoin ? mp_slot_formula(get_total_marines()) : spawn_positions)


/datum/job/command/police/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='[URL_WIKI_LAW]'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"
	return ..()

// Warden
/datum/job/command/warden
	title = JOB_WARDEN
	flag = ROLE_WARDEN
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Military Warden (MW)"
	minimum_playtimes = list(
		JOB_POLICE = HOURS_9
	)

/datum/job/command/warden/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='[URL_WIKI_LAW]'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the mainting security records and overwatching any prisoners in Brig."
	return ..()

//Chief MP
/datum/job/command/warrant
	title = JOB_CHIEF_POLICE
	flag = ROLE_CHIEF_MP
	selection_class = "job_cmp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief MP (CMP)"
	minimum_playtimes = list(
		JOB_COMMAND_ROLES = HOURS_3,
		JOB_POLICE = HOURS_9
	)

/datum/job/command/warrant/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='[URL_WIKI_LAW]'>Marine Law</a>. Failure to do so may result in a job ban or server ban. You lead the Military Police, ensure your officers maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"
	return ..()

/datum/job/command/senior
	title = JOB_SEA
	flag = ROLE_SEA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_MENTOR
	gear_preset = "USCM Senior Enlisted Advisor (SEA)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_9,
		JOB_SQUAD_LEADER = HOURS_3,
		JOB_ORDNANCE_TECH = HOURS_3,
		JOB_REQUISITION = HOURS_3,
		JOB_DOCTOR = HOURS_3,
		JOB_PILOT = HOURS_3,
		JOB_COMMAND_ROLES = HOURS_3,
		JOB_POLICE = HOURS_6
	)

/datum/job/command/senior/generate_entry_message()
	entry_message_body = "You are held to a higher standard and are required to obey not only the Server Rules but <a href='[URL_WIKI_LAW]'>Marine Law</a> and <a href='[URL_WIKI_SOP]'>Standard Operating Procedure</a>. Failure to do so may result in your Mentorship Removal. Your primary job is to teach others the game and its mechanics, and offer advice to all USCM Departments and Personnel on-board."
	return ..()

/datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)
	sleep(15)
	if(H && H.loc && flags_startup_parameters & ROLE_ADD_TO_MODE && map_tag != MAP_WHISKEY_OUTPOST)
		ai_announcement("Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!")
	..()
