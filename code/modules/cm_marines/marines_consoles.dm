#define CARDCON_DEPARTMENT_MISC "Miscellaneous"
#define CARDCON_DEPARTMENT_MARINE "Marines"
#define CARDCON_DEPARTMENT_SECURITY "Security"
#define CARDCON_DEPARTMENT_MEDICAL "Medical and Science"
#define CARDCON_DEPARTMENT_MEDICALWO "Medical"
#define CARDCON_DEPARTMENT_SUPPLY "Supply"
#define CARDCON_DEPARTMENT_AUXCOM "Auxiliary Command"
#define CARDCON_DEPARTMENT_ENGINEERING "Engineering"
#define CARDCON_DEPARTMENT_COMMAND "Command"

// Weyland Yutani Categories
#define CARDCON_DEPARTMENT_CORP_LEAD "Corporate Leadership"
#define CARDCON_DEPARTMENT_COMMANDOS "Corporate Commandos"
#define CARDCON_DEPARTMENT_CORP_SECURITY "Corporate Security"
#define CARDCON_DEPARTMENT_CORPORATE "Corporate Employees"
#define CARDCON_DEPARTMENT_PMC "PMC Combat Ops"
#define CARDCON_DEPARTMENT_INSPECTION "PMC Investigations"
#define CARDCON_DEPARTMENT_SPECIALTY "PMC Specialists"

/obj/structure/machinery/computer/card
	name = "Identification Computer"
	desc = "Terminal for programming USCM employee ID card access."
	icon_state = "id"
	req_access = list(ACCESS_MARINE_DATABASE)
	circuit = /obj/item/circuitboard/computer/card
	var/obj/item/card/id/user_id_card
	var/obj/item/card/id/target_id_card
	// What factions we are able to modify
	var/list/factions = list(FACTION_MARINE)
	var/printing

	var/is_weyland = FALSE
	var/authenticated = FALSE

/obj/structure/machinery/computer/card/wey_yu
	is_weyland = TRUE
	req_access = list(ACCESS_WY_DATABASE)
	factions = list(FACTION_WY, FACTION_PMC)

/obj/structure/machinery/computer/card/proc/authenticate(mob/user, obj/item/card/id/id_card)
	if(!id_card)
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: Authority confirmation card is missing!\"")
		return FALSE

	if(check_access(id_card))
		authenticated = TRUE
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGIN: Welcome, [id_card.registered_name]. Access granted.\"")
		update_static_data(user)
		return TRUE

	visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: You have not enough authority! Access denied.\"")
	return FALSE

/obj/structure/machinery/computer/card/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CardMod", name)
		ui.open()

/obj/structure/machinery/computer/card/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("PRG_authenticate")
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/card/id))
				if(user.drop_held_item())
					I.forceMove(src)
					user_id_card = I
			if(authenticate(user, user_id_card))
				return TRUE
			// Well actualy we have no button for auth card ejection, so just spit it back in user's face
			else
				if(!user_id_card)
					return
				if(ishuman(user))
					user_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(user_id_card)
				else
					user_id_card.forceMove(loc)
				user_id_card = null
		if("PRG_logout")
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
			authenticated = FALSE
			if(ishuman(user))
				user_id_card.forceMove(user.loc)
				if(!user.get_active_hand())
					user.put_in_hands(user_id_card)
			else
				user_id_card.forceMove(loc)
			user_id_card = null
			return TRUE
		if("PRG_print")
			if(!printing)
				if(params["mode"])
					if(!authenticated || !target_id_card)
						return

					printing = TRUE
					playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
					sleep(40)
					var/contents = {"<center><h4>Access Report</h4></center>
								<u>Prepared By:</u> [user_id_card?.registered_name ? user_id_card.registered_name : "Unknown"]<br>
								<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<hr>
								<u>Faction:</u> [target_id_card.faction ? target_id_card.faction : "N/A"]<br>
								<u>Assignment:</u> [target_id_card.assignment]<br>
								<u>Account Number:</u> #[target_id_card.associated_account_number]<br>
								<u>Blood Type:</u> [target_id_card.blood_type]<br><br>
								<u>Access:</u><br>
								"}

					var/known_access_rights = get_access(ACCESS_LIST_MARINE_ALL)
					for(var/A in target_id_card.access)
						if(A in known_access_rights)
							contents += "  [get_access_desc(A)]<br>"
					contents += "<br><u>Modification Log:</u><br>"
					for(var/change in target_id_card.modification_log)
						contents += "  [change]<br>"

					var/obj/item/paper/P = new /obj/item/paper(src.loc)
					P.name = "Access Report"
					P.info += contents

				visible_message(SPAN_NOTICE("\The [src] prints out a paper."))
				printing = FALSE
				return TRUE
			return
		if("PRG_eject")
			var/origin_assignment
			var/origin_name
			if(target_id_card)
				if(target_id_card.registered_name != origin_name || target_id_card.assignment != origin_assignment)
					GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.registered_ref, target_id_card.assignment, target_id_card.rank)
					target_id_card.name = text("[target_id_card.registered_name]'s [target_id_card.id_type] ([target_id_card.assignment])")
					if(target_id_card.registered_name != origin_name)
						log_idmod(target_id_card, "<font color='orange'> [user.real_name] changed the registered name of the ID to '[target_id_card.registered_name]'. </font>", key_name_admin(user))
					if(target_id_card.assignment != origin_assignment)
						log_idmod(target_id_card, "<font color='orange'> [user.real_name] changed the assignment of the ID to the custom position '[target_id_card.assignment]'. </font>", key_name_admin(user))
				if(ishuman(user))
					target_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(target_id_card)
					target_id_card = null
				else
					target_id_card.forceMove(loc)
					target_id_card = null
				visible_message("[SPAN_BOLD("[src]")] states, \"CARD EJECT: Data imprinted. Updating database... Success.\"")
				return TRUE
			else
				var/obj/item/I = user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					if(user.drop_held_item())
						I.forceMove(src)
						target_id_card = I
						visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
						update_static_data(user)
						origin_assignment = target_id_card.assignment
						origin_name = target_id_card.registered_name
						return TRUE
			return FALSE
		if("PRG_terminate")
			if(!authenticated || !target_id_card)
				return

			target_id_card.assignment = "Terminated"
			target_id_card.access = list()
			log_idmod(target_id_card, "<font color='red'> [user.real_name] terminated the ID. </font>", key_name_admin(user))
			message_admins("[user.real_name] terminated the ID of [target_id_card.registered_name].", key_name_admin(user))
			return TRUE
		if("PRG_edit")
			if(!authenticated || !target_id_card)
				return

			var/new_name = strip_html(params["name"])
			if(!new_name)
				visible_message(SPAN_NOTICE("[src] buzzes rudely."))
				return
			target_id_card.registered_name = new_name
			return TRUE
		if("PRG_assign")
			if(!authenticated || !target_id_card)
				return
			var/target = params["assign_target"]
			if(!target)
				return

			if(target == "Custom")
				var/custom_name = strip_html(params["custom_name"])
				if(custom_name)
					target_id_card.assignment = custom_name
			else
				var/list/new_access = list()
				if(is_weyland)
					new_access = get_access(ACCESS_LIST_WY_ALL)
				else
					var/datum/job/job = GLOB.RoleAuthority.roles_for_mode[target]

					if(!job)
						visible_message("[SPAN_BOLD("[src]")] states, \"DATA ERROR: Can not find next entry in database: [target]\"")
						return
					new_access = job.get_access()
				target_id_card.access -= get_access(ACCESS_LIST_WY_ALL) + get_access(ACCESS_LIST_MARINE_MAIN)
				target_id_card.access |= new_access
				target_id_card.assignment = target
				target_id_card.rank = target
			message_admins("[key_name_admin(usr)] gave the ID of [target_id_card.registered_name] the assignment '[target_id_card.assignment]'.")
			return TRUE
		if("PRG_access")
			if(!authenticated || !target_id_card)
				return

			var/access_type = params["access_target"]
			if(params["access_target"] in factions)
				if(!target_id_card.faction_group)
					target_id_card.faction_group = list()
				if(params["access_target"] in target_id_card.faction_group)
					target_id_card.faction_group -= params["access_target"]
					log_idmod(target_id_card, "<font color='red'> [user.real_name] revoked [access_type] IFF. </font>", key_name_admin(user))
				else
					target_id_card.faction_group |= params["access_target"]
					log_idmod(target_id_card, "<font color='green'> [user.real_name] granted [access_type] IFF. </font>", key_name_admin(user))
				return TRUE
			access_type = text2num(params["access_target"])
			if(access_type in (is_weyland ? get_access(ACCESS_LIST_WY_ALL) : get_access(ACCESS_LIST_MARINE_MAIN)))
				if(access_type in target_id_card.access)
					target_id_card.access -= access_type
					log_idmod(target_id_card, "<font color='red'> [user.real_name] revoked access '[get_access_desc(access_type)]'. </font>", key_name_admin(user))
				else
					target_id_card.access |= access_type
					log_idmod(target_id_card, "<font color='green'> [user.real_name] granted access '[get_access_desc(access_type)]'. </font>", key_name_admin(user))
				return TRUE
		if("PRG_grantall")
			if(!authenticated || !target_id_card)
				return

			target_id_card.access |= (is_weyland ? get_access(ACCESS_LIST_WY_ALL) : get_access(ACCESS_LIST_MARINE_MAIN))
			target_id_card.faction_group |= factions
			log_idmod(target_id_card, "<font color='green'> [user.real_name] granted the ID all access and USCM IFF. </font>", key_name_admin(user))
			return TRUE
		if("PRG_denyall")
			if(!authenticated || !target_id_card)
				return

			var/list/access = target_id_card.access
			access.Cut()
			target_id_card.faction_group -= factions
			log_idmod(target_id_card, "<font color='red'> [user.real_name] removed all accesses and USCM IFF. </font>", key_name_admin(user))
			return TRUE
		if("PRG_grantregion")
			if(!authenticated || !target_id_card)
				return

			if(params["region"] == "Faction (IFF system)")
				target_id_card.faction_group |= factions
				log_idmod(target_id_card, "<font color='green'> [user.real_name] granted USCM IFF. </font>", key_name_admin(user))
				return TRUE
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access |= get_region_accesses(region)
			var/additions = get_region_accesses_name(region)
			log_idmod(target_id_card, "<font color='green'> [user.real_name] granted all [additions] accesses. </font>", key_name_admin(user))
			return TRUE
		if("PRG_denyregion")
			if(!authenticated || !target_id_card)
				return

			if(params["region"] == "Faction (IFF system)")
				target_id_card.faction_group -= factions
				log_idmod(target_id_card, "<font color='red'> [user.real_name] revoked USCM IFF. </font>", key_name_admin(user))
				return TRUE
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access -= get_region_accesses(region)
			var/additions = get_region_accesses_name(region)
			log_idmod(target_id_card, "<font color='red'> [user.real_name] revoked all [additions] accesses. </font>", key_name_admin(user))
			return TRUE
		if("PRG_account")
			if(!authenticated || !target_id_card)
				return

			var/account = text2num(params["account"])
			target_id_card.associated_account_number = account
			log_idmod(target_id_card, "<font color='orange'> [user.real_name] changed the account number to '[account]'. </font>", key_name_admin(user))
			return TRUE

/obj/structure/machinery/computer/card/ui_static_data(mob/user)
	var/list/data = list()
	data["station_name"] = MAIN_SHIP_NAME
	data["weyland_access"] = is_weyland

	var/list/departments
	if(is_weyland)
		departments = list(
			CARDCON_DEPARTMENT_CORP_LEAD = ROLES_WY_LEADERSHIP,
			CARDCON_DEPARTMENT_COMMANDOS = ROLES_WY_COMMANDOS,
			CARDCON_DEPARTMENT_CORP_SECURITY = ROLES_WY_GOONS,
			CARDCON_DEPARTMENT_CORPORATE = ROLES_WY_CORPORATE,
			CARDCON_DEPARTMENT_PMC = ROLES_WY_PMC,
			CARDCON_DEPARTMENT_SPECIALTY = ROLES_WY_PMC_AUX,
			CARDCON_DEPARTMENT_INSPECTION = ROLES_WY_PMC_INSPEC,
		)
	else if(Check_WO())
		// I am not sure about WOs departments so it may need adjustment
		departments = list(
			CARDCON_DEPARTMENT_COMMAND = GLOB.ROLES_CIC & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_AUXCOM = GLOB.ROLES_AUXIL_SUPPORT & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MISC = GLOB.ROLES_MISC & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_SECURITY = GLOB.ROLES_POLICE & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_ENGINEERING = GLOB.ROLES_ENGINEERING & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_SUPPLY = GLOB.ROLES_REQUISITION & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MEDICAL = GLOB.ROLES_MEDICAL & GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MARINE = GLOB.ROLES_MARINES
		)
	else
		departments = list(
			CARDCON_DEPARTMENT_COMMAND = GLOB.ROLES_CIC - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_AUXCOM = GLOB.ROLES_AUXIL_SUPPORT - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MISC = GLOB.ROLES_MISC - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_SECURITY = GLOB.ROLES_POLICE - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_ENGINEERING = GLOB.ROLES_ENGINEERING - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_SUPPLY = GLOB.ROLES_REQUISITION - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MEDICAL = GLOB.ROLES_MEDICAL - GLOB.ROLES_WO,
			CARDCON_DEPARTMENT_MARINE = GLOB.ROLES_MARINES
		)
	data["jobs"] = list()
	for(var/department in departments)
		var/list/job_list = departments[department]
		var/list/department_jobs = list()
		for(var/job in job_list)
			department_jobs += list(list(
				"display_name" = replacetext(job, "&nbsp", " "),
				"job" = job
			))
		if(length(department_jobs))
			data["jobs"][department] = department_jobs

	var/list/regions = list()
	for(var/i in 1 to is_weyland ? 6 : 7)

		var/list/accesses = list()
		if(!is_weyland)
			for(var/access in get_region_accesses(i))
				if(get_access_desc(access))
					accesses += list(list(
						"desc" = replacetext(get_access_desc(access), "&nbsp", " "),
						"ref" = access,
					))
		else
			for(var/access in get_region_accesses_wy(i))
				if(get_weyland_access_desc(access))
					accesses += list(list(
						"desc" = replacetext(get_weyland_access_desc(access), "&nbsp", " "),
						"ref" = access,
					))

		regions += list(list(
			"name" = is_weyland ? get_region_accesses_name_wy(i) : get_region_accesses_name(i),
			"regid" = i,
			"accesses" = accesses
		))

	// Factions goes here
	if(target_id_card && target_id_card.faction_group && isnull(target_id_card.faction_group))
		target_id_card.faction_group = list()
	var/list/localfactions = list()
	// We can see only those factions which have our console tuned on
	for(var/faction in factions)
		localfactions += list(list(
			"desc" = faction,
			"ref" = faction,
	))

	regions += list(list(
		"name" = "Faction (IFF system)",
		"regid" = "Faction (IFF system)",
		"accesses" = localfactions
	))

	data["regions"] = regions

	return data

/obj/structure/machinery/computer/card/ui_data(mob/user)
	var/list/data = list()

	data["station_name"] = MAIN_SHIP_NAME
	data["authenticated"] = authenticated

	data["has_id"] = !!target_id_card
	data["id_name"] = target_id_card ? target_id_card.name : "-----"
	if(target_id_card)
		data["id_rank"] = target_id_card.assignment ? target_id_card.assignment : "Unassigned"
		data["id_owner"] = target_id_card.registered_name ? target_id_card.registered_name : "-----"
		data["access_on_card"] = target_id_card.access + target_id_card.faction_group
		data["id_account"] = target_id_card.associated_account_number

	return data

/obj/structure/machinery/computer/card/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/card/id))
		if(!operable())
			to_chat(user, SPAN_NOTICE("You tried to inject \the [O] but \the [src] remains silent."))
			return
		var/obj/item/card/id/idcard = O
		if(check_access(idcard))
			if(!user_id_card)
				if(user.drop_held_item())
					O.forceMove(src)
					user_id_card = O
				authenticate(user, user_id_card)
			else if(!target_id_card)
				if(user.drop_held_item())
					O.forceMove(src)
					target_id_card = O
					update_static_data(user)
					visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
		else
			if(!target_id_card)
				if(user.drop_held_item())
					O.forceMove(src)
					target_id_card = O
					update_static_data(user)
					visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
	else
		. = ..()

/obj/structure/machinery/computer/card/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/card/bullet_act()
	return 0

/obj/structure/machinery/computer/card/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.is_mob_incapacitated())
		return

	if(user_id_card)
		user_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(user_id_card)
		if(operable()) // Powered. Console can response.
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
		else
			to_chat(usr, "You remove \the [user_id_card] from \the [src].")
		authenticated = FALSE // No card - no access
		user_id_card = null

	else if(target_id_card)
		target_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(target_id_card)
		if(operable()) // Powered. Make comp proceed ejection
			GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.registered_ref, target_id_card.assignment, target_id_card.rank)
			target_id_card.name = text("[target_id_card.registered_name]'s [target_id_card.id_type] ([target_id_card.assignment])")
			visible_message("[SPAN_BOLD("[src]")] states, \"CARD EJECT: Data imprinted. Updating database... Success.\"")
		else
			to_chat(usr, "You remove \the [target_id_card] from \the [src].")
		target_id_card = null

	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/structure/machinery/computer/card/attack_hand(mob/user as mob)
	if(..())
		return
	if(inoperable())
		return
	user.set_interaction(src)
	tgui_interact(user)

#undef CARDCON_DEPARTMENT_MISC
#undef CARDCON_DEPARTMENT_MARINE
#undef CARDCON_DEPARTMENT_SECURITY
#undef CARDCON_DEPARTMENT_MEDICAL
#undef CARDCON_DEPARTMENT_MEDICALWO
#undef CARDCON_DEPARTMENT_SUPPLY
#undef CARDCON_DEPARTMENT_AUXCOM
#undef CARDCON_DEPARTMENT_ENGINEERING
#undef CARDCON_DEPARTMENT_COMMAND

#undef CARDCON_DEPARTMENT_CORP_LEAD
#undef CARDCON_DEPARTMENT_CORP_SECURITY
#undef CARDCON_DEPARTMENT_CORPORATE
#undef CARDCON_DEPARTMENT_PMC
#undef CARDCON_DEPARTMENT_INSPECTION
#undef CARDCON_DEPARTMENT_SPECIALTY

//This console changes a marine's squad. It's very simple.
//It also does not: change or increment the squad count (used in the login randomizer), nor does it check for jobs.
//Which means you could get sillyiness like "Alpha Sulaco Chief Medical Officer" or "Delta Logistics Officer".
//But in the long run it's not really a big deal.

/obj/structure/machinery/computer/squad_changer
	name = "Squad Distribution Computer"
	desc = "You can use this to change someone's squad."
	icon_state = "guest"
	req_access = list(ACCESS_MARINE_DATABASE)
	var/obj/item/card/id/ID_to_modify = null
	var/mob/living/carbon/human/person_to_modify = null
	var/faction = FACTION_MARINE

/obj/structure/machinery/computer/squad_changer/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)

	if(!usr || usr.is_mob_incapacitated())
		return

	if(ishuman(usr) && ID_to_modify)
		to_chat(usr, "You remove \the [ID_to_modify] from \the [src].")
		ID_to_modify.forceMove(get_turf(src))
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(ID_to_modify)
		ID_to_modify = null
		person_to_modify = null
	else
		to_chat(usr, "There is nothing to remove from \the [src].")
	return

/obj/structure/machinery/computer/squad_changer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SquadMod", name)
		ui.open()

/obj/structure/machinery/computer/squad_changer/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	// Please stay close, marine
	if(person_to_modify && !(person_to_modify.Adjacent(src)))
		person_to_modify = null

	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("PRG_eject")
			if(ID_to_modify)
				if(ishuman(user))
					ID_to_modify.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(ID_to_modify)
					ID_to_modify = null
				else
					ID_to_modify.forceMove(loc)
					ID_to_modify = null
				visible_message("[SPAN_BOLD("[src]")] states, \"CARD EJECT: ID modification protocol disabled.\"")
				return TRUE
			else
				var/obj/item/I = user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					if(user.drop_held_item())
						I.forceMove(src)
						ID_to_modify = I
						visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
						return TRUE
		if("PRG_squad")
			if(
				istype(ID_to_modify) && istype(person_to_modify) && \
				person_to_modify.skills.get_skill_level(SKILL_FIREARMS) && \
				person_to_modify.real_name == ID_to_modify.registered_name && \
				person_to_modify.Adjacent(src)
			)
				var/datum/squad/selected = get_squad_by_name(params["name"])
				if(!selected)
					return
				if(GLOB.RoleAuthority.check_squad_capacity(person_to_modify, selected))
					visible_message("[SPAN_BOLD("[src]")] states, \"CAPACITY ERROR: [selected] can't have another [person_to_modify.job].\"")
					return TRUE
				if(transfer_marine_to_squad(person_to_modify, selected, person_to_modify.assigned_squad, ID_to_modify))
					visible_message("[SPAN_BOLD("[src]")] states, \"DATABASE LOG: [person_to_modify] was assigned to [selected] Squad.\"")
					return TRUE
				else
					visible_message("[SPAN_BOLD("[src]")] states, \"DATABASE ERROR: There was an error assigning [person_to_modify] to [selected] Squad.\"")
			else if(!istype(ID_to_modify))
				to_chat(usr, SPAN_WARNING("You need to insert a card to modify."))
			else if(!istype(person_to_modify) || !person_to_modify.Adjacent(src))
				visible_message("[SPAN_BOLD("[src]")] states, \"SCANNER ERROR: You need to keep the hand of the person to be assigned to Squad!\"")
			else if(!person_to_modify.skills.get_skill_level(SKILL_FIREARMS))
				visible_message("[SPAN_BOLD("[src]")] states, \"QUALIFICATION ERROR: You cannot assign untrained civilians to squads!\"")
			else
				visible_message("[SPAN_BOLD("[src]")] states, \"ID ERROR: The ID in the machine is not owned by the person whose hand is scanned!\"")
			return TRUE

/obj/structure/machinery/computer/squad_changer/ui_data(mob/user)
	// Please stay close, marine
	if(person_to_modify && !(person_to_modify.Adjacent(src)))
		person_to_modify = null
	var/list/data = list()
	if(person_to_modify)
		data["human"] = person_to_modify.name
	else
		data["human"] = null
	data["id_name"] = ID_to_modify ? ID_to_modify.name : "-----"
	data["has_id"] = !!ID_to_modify
	return data

/obj/structure/machinery/computer/squad_changer/ui_static_data(mob/user)
	var/list/data = list()
	var/list/squads = list()
	for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
		if(current_squad.name != "Root" && !current_squad.locked && current_squad.active && current_squad.faction == faction)
			var/list/squad = list(list(
				"name" = current_squad.name,
				"color" = current_squad.equipment_color
			))
			squads += squad
	data["squads"] = squads
	return data

/obj/structure/machinery/computer/squad_changer/attackby(obj/O as obj, mob/user as mob)
	if(user)
		add_fingerprint(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(O, /obj/item/card/id))
			if(!operable())
				to_chat(usr, SPAN_NOTICE("You tried to insert [O] but \the [src] remains silent."))
				return
			var/obj/item/card/id/idcard = O
			if(!ID_to_modify)
				H.drop_held_item()
				idcard.forceMove(src)
				ID_to_modify = idcard
				visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(H, SPAN_NOTICE("Remove the inserted card first."))
		else if(istype(O, /obj/item/grab))
			var/obj/item/grab/G = O
			if(ismob(G.grabbed_thing))
				if(!operable())
					to_chat(usr, SPAN_NOTICE("You place [G.grabbed_thing]'s hand on scanner but \the [src] remains silent."))
					return
				var/isxenos = isxeno(G.grabbed_thing)
				H.visible_message(SPAN_NOTICE("You hear a beep as [G.grabbed_thing]'s [isxenos ? "limb" : "hand"] is scanned to \the [name]."))
				visible_message("[SPAN_BOLD("[src]")] states, \"SCAN ENTRY: [isxenos ? "Unknown lifeform detected! Forbidden operation!" : "Scanned, please stay close until operation's end."]\"")
				playsound(H.loc, 'sound/machines/screen_output1.ogg', 25, 1)
				// No Xeno Squads, please!
				if(!isxenos)
					person_to_modify = G.grabbed_thing
	else
		. = ..()


/obj/structure/machinery/computer/squad_changer/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/squad_changer/bullet_act()
	return 0

/obj/structure/machinery/computer/squad_changer/attack_hand(mob/user as mob)
	if(..())
		return
	if(user)
		add_fingerprint(user)

	usr.set_interaction(src)
	if(!operable())
		return
	if(allowed(user))
		tgui_interact(user)
	else
		var/isxenos = isxeno(user)
		user.visible_message(SPAN_NOTICE("You hear a beep as [user]'s [isxenos ? "limb" : "hand"] is scanned to \the [name]."))
		visible_message("[SPAN_BOLD("[src]")] states, \"SCAN ENTRY: [isxenos ? "Unknown lifeform detected! Forbidden operation!" : "Scanned, please stay close until operation's end."]\"")
		playsound(user.loc, 'sound/machines/screen_output1.ogg', 25, 1)
		// No Xeno Squads, please!
		if(!isxenos)
			person_to_modify = user

/// How often the sensor data is updated
#define SENSORS_UPDATE_PERIOD 10 SECONDS //How often the sensor data updates.
/// The job sorting ID associated with otherwise unknown jobs
#define UNKNOWN_JOB_ID 998

/obj/structure/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into the wearer's uniform.  You can see that the console highlights ship areas with BLUE and remote locations with RED."
	icon_state = "crew"
	circuit = /obj/item/circuitboard/computer/crew
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	active_power_usage = 500
	var/faction = FACTION_MARINE
	/// Any extra factions this console should be tracking to.
	var/list/extra_factions = list()
	/// What type of /datum/crewmonitor this will create
	var/crew_monitor_type = /datum/crewmonitor

	/// The identifier for the crew monitor that we use
	VAR_PRIVATE/lookup_string

/obj/structure/machinery/computer/crew/Initialize()
	. = ..()
	lookup_string = "[faction]-[json_encode(sort_list(extra_factions))]"
	if(!GLOB.crew_monitor[lookup_string])
		GLOB.crew_monitor[lookup_string] = new crew_monitor_type(faction, extra_factions)

/obj/structure/machinery/computer/crew/attack_remote(mob/living/user)
	attack_hand(user)

/obj/structure/machinery/computer/crew/attack_hand(mob/living/user)
	if(!isRemoteControlling(user))
		add_fingerprint(user)
	if(inoperable())
		return
	user.set_interaction(src)
	GLOB.crew_monitor[lookup_string].show(user, src)

/obj/structure/machinery/computer/crew/update_icon()
	if(stat & BROKEN)
		icon_state = "crewb"
	else
		if(stat & NOPOWER)
			icon_state = "crew0"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/structure/machinery/computer/crew/interact(mob/living/user)
	GLOB.crew_monitor[lookup_string].show(user, src)

/obj/structure/machinery/computer/crew/alt
	icon_state = "cmonitor"
	density = FALSE

/obj/structure/machinery/computer/crew/alt/yautja
	name = "\improper Yautja health monitor"
	desc = "Used to monitor active health sensors of all Yautja in the system. You can see that the console highlights the human's ship areas with BLUE and the hunting locations with RED."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "crew"
	faction = FACTION_YAUTJA
	crew_monitor_type = /datum/crewmonitor/yautja

/obj/structure/machinery/computer/crew/upp
	faction = FACTION_UPP

/obj/structure/machinery/computer/crew/clf
	faction = FACTION_CLF

/obj/structure/machinery/computer/crew/wey_yu
	faction = FACTION_WY

/obj/structure/machinery/computer/crew/wey_yu/pmc
	faction = FACTION_PMC
	extra_factions = list(FACTION_WY)

/obj/structure/machinery/computer/crew/colony
	faction = FACTION_COLONIST

/obj/structure/machinery/computer/crew/yautja
	faction = FACTION_YAUTJA

GLOBAL_LIST_EMPTY_TYPED(crew_monitor, /datum/crewmonitor)

#define SENSOR_LIVING 1
#define SENSOR_VITALS 2
#define SENSOR_COORDS 3
/// This is a really hacky way to make SOF work, but the nice and easy alternative would screw with round spawning
#define RAIDER_OFFICER_SQUAD "SOF [JOB_MARINE_RAIDER_CMD]"
#define RAIDER_SL_SQUAD "SOF [JOB_MARINE_RAIDER_SL]"
#define RAIDER_SQUAD "SOF [JOB_MARINE_RAIDER]"

/datum/crewmonitor
	/// List of user -> UI source
	var/list/ui_sources = list()
	/// Cache of data generated, used for serving the data within SENSOR_UPDATE_PERIOD of the last update
	var/list/data = list()
	/// Cache of last update time
	var/last_update
	/// Map of job to ID for sorting purposes
	var/list/jobs
	var/faction = FACTION_MARINE
	var/list/extra_factions = list()

/datum/crewmonitor/New(set_faction = FACTION_MARINE, extras = list())
	..()
	faction = set_faction
	extra_factions = extras
	setup_for_faction(faction)

/datum/crewmonitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewConsole")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/crewmonitor/proc/show(mob/M, source)
	if(!length(ui_sources))
		START_PROCESSING(SSprocessing, src)
	ui_sources[M] = source
	tgui_interact(M)

/datum/crewmonitor/process()
	if(data && last_update && world.time <= last_update + SENSORS_UPDATE_PERIOD)
		return
	update_data()
	// Update active users UI
	for(var/H in ui_sources)
		var/datum/tgui/ui = SStgui.try_update_ui(H, src)
		if(!ui) // What are you doing in list?
			ui_sources -= H

/datum/crewmonitor/ui_close(mob/M)
	. = ..()
	ui_sources -= M
	if(!length(ui_sources))
		STOP_PROCESSING(SSprocessing, src)

/datum/crewmonitor/ui_host(mob/user)
	return ui_sources[user]

/datum/crewmonitor/ui_data(mob/user)
	. = list(
		"sensors" = update_data(),
		"link_allowed" = isSilicon(user),
	)

/datum/crewmonitor/proc/update_data()
	var/list/results = list()
	for(var/mob/living/carbon/human/tracked_mob in GLOB.human_mob_list)
		// Predators
		if(isyautja(tracked_mob))
			continue
		// Check for a uniform
		var/obj/item/clothing/under/C = tracked_mob.w_uniform
		if(!C || !istype(C))
			continue
		// Check that sensors are present and active
		if(!C.has_sensor || !C.sensor_mode || !check_faction(tracked_mob))
			continue
		if(tracked_mob.job in FAX_RESPONDER_JOB_LIST)
			continue

		// Check if z-level is correct
		var/turf/pos = get_turf(tracked_mob)
		if(!pos)
			continue
		if(should_block_game_interaction(tracked_mob, TRUE))
			continue

		// The entry for this human
		var/list/entry = list(
			"ref" = REF(tracked_mob),
			"name" = "Unknown",
			"ijob" = UNKNOWN_JOB_ID
		)

		// ID and id-related data
		var/obj/item/card/id/id_card = tracked_mob.get_idcard()
		if (id_card)
			entry["name"] = id_card.registered_name
			entry["assignment"] = id_card.assignment
			if(id_card.assignment in jobs)
				entry["ijob"] = jobs[id_card.assignment]

		// Binary living/dead status
		if (C.sensor_mode >= SENSOR_LIVING)
			entry["life_status"] = !tracked_mob.stat

		// Damage
		if (C.sensor_mode >= SENSOR_VITALS)
			entry += list(
				"oxydam" = round(tracked_mob.getOxyLoss(), 1),
				"toxdam" = round(tracked_mob.getToxLoss(), 1),
				"burndam" = round(tracked_mob.getFireLoss(), 1),
				"brutedam" = round(tracked_mob.getBruteLoss(), 1)
			)

		// Location
		if (C.sensor_mode >= SENSOR_COORDS)
			if(is_mainship_level(pos.z))
				entry["side"] = "Almayer"
			var/area/A = get_area(tracked_mob)
			entry["area"] = sanitize_area(A.name)

		// Trackability
		entry["can_track"] = tracked_mob.detectable_by_ai()

		results[++results.len] = entry

	// Cache result
	data = results
	last_update = world.time

	return results

/*
 * Unimplemented. Was for AIs tracking but we never had them working.
 *
/datum/crewmonitor/ui_act(action,params)
	. = ..()
	if(.)
		return
	switch (action)
		if ("select_person")

*/

/datum/crewmonitor/proc/check_faction(mob/living/carbon/human/target)
	if((target.faction == faction) || (target.faction in extra_factions))
		return TRUE
	for(var/pos_faction in target.faction_group)
		if((pos_faction == faction) || (pos_faction in extra_factions))
			return TRUE

	var/obj/item/card/id/id_card = target.wear_id
	if(!id_card)
		return FALSE

	if((id_card.faction == faction) || (id_card.faction in extra_factions))
		return TRUE
	for(var/pos_faction in id_card.faction_group)
		if((pos_faction == faction) || (pos_faction in extra_factions))
			return TRUE

	return FALSE

/datum/crewmonitor/proc/setup_for_faction(set_faction = FACTION_MARINE)
	switch(set_faction)
		if(FACTION_MARINE)
			jobs = list(
				// Note that jobs divisible by 10 are considered heads of staff, and bolded
				// 00-09: High Command, defined at bottom
				JOB_CMC = 00,//Grade O10
				JOB_ACMC = 00,
				JOB_PROVOST_CMARSHAL = 00,
				JOB_GENERAL = 00,
				JOB_PROVOST_SMARSHAL = 01,//Grade O9
				JOB_PROVOST_MARSHAL = 02,//Grade O7
				JOB_PROVOST_DMARSHAL = 03,//Grade O6
				JOB_COLONEL = 04,//Grade O6
				JOB_PROVOST_CINSPECTOR = 05,
				JOB_PROVOST_INSPECTOR = 06,
				// 10-19: Command
				JOB_CO = 10,
				JOB_XO = 11,
				JOB_MARINE_RAIDER_CMD = 11,
				RAIDER_OFFICER_SQUAD = 11,
				JOB_SO = 12,
				JOB_SEA = 13,
				// 20-29: Aux Command
				JOB_AUXILIARY_OFFICER = 20,
				JOB_SYNTH = 21,
				JOB_CAS_PILOT = 22,
				JOB_DROPSHIP_PILOT = 23,
				JOB_DROPSHIP_CREW_CHIEF = 24,
				JOB_INTEL = 25,
				JOB_TANK_CREW = 26,
				// 30-39: Security
				JOB_CHIEF_POLICE = 30,
				JOB_PROVOST_TML = 30,
				JOB_WARDEN = 31,
				JOB_PROVOST_ENFORCER = 31,
				JOB_RIOT_CHIEF = 32,
				JOB_RIOT = 33,
				JOB_POLICE = 34,
				JOB_PROVOST_ADVISOR = 35,
				// 40-49: MedSci
				JOB_CMO = 40,
				JOB_RESEARCHER = 41,
				JOB_DOCTOR = 42,
				JOB_SURGEON = 42,
				JOB_FIELD_DOCTOR = 43,
				JOB_NURSE = 44,
				// 50-59: Engineering
				JOB_CHIEF_ENGINEER = 50,
				JOB_ORDNANCE_TECH = 51,
				JOB_MAINT_TECH = 52,
				// 60-69: Cargo
				JOB_CHIEF_REQUISITION = 60,
				JOB_CARGO_TECH = 61,
				JOB_MESS_SERGEANT = 62,
				// 70-139: SQUADS (look below)
				JOB_SYNTH_K9 = 71,
				// 140+: Civilian/other
				JOB_CORPORATE_LIAISON = 140,
				JOB_PASSENGER = 141,
				// Non Almayer jobs lower then registered
				JOB_SYNTH_SURVIVOR = 150,
				JOB_SURVIVOR = 151,
				JOB_COLONIST = 152,
				JOB_WORKING_JOE = 153,

				// WO jobs
				// 10-19: Command
				JOB_WO_CO = 10,
				JOB_WO_XO = 11,
				// 20-29: Aux Command
				JOB_WO_CHIEF_POLICE = 20,
				JOB_WO_SO = 21,
				// 30-39: Security
				JOB_WO_CREWMAN = 30,
				JOB_WO_POLICE = 31,
				JOB_WO_PILOT = 32,
				// 40-49: MedSci
				JOB_WO_CMO = 40,
				JOB_WO_RESEARCHER = 41,
				JOB_WO_DOCTOR = 42,
				// 50-59: Engineering
				JOB_WO_CHIEF_ENGINEER = 50,
				JOB_WO_ORDNANCE_TECH = 51,
				// 60-69: Cargo
				JOB_WO_CHIEF_REQUISITION = 60,
				JOB_WO_REQUISITION = 61,
				// 70-139: SQUADS (look below)
				// 140+: Civilian/other
				JOB_WO_CORPORATE_LIAISON = 140,
				JOB_WO_SYNTH = 150,

				// ANYTHING ELSE = UNKNOWN_JOB_ID, Unknowns/custom jobs will appear after civilians, and before stowaways
				JOB_STOWAWAY = 999,

				// 200-231: Visitors
				JOB_UPP_REPRESENTATIVE = 201,
				JOB_TWE_REPRESENTATIVE = 201,
				JOB_TIS_SA = 210,
				JOB_TIS_IO = 211,
				JOB_PMC_DIRECTOR = 220,
				JOB_PMC_LEADER = 220,
				JOB_PMC_LEAD_INVEST = 220,
				JOB_PMC_SYNTH = 221,
				JOB_PMC_SNIPER = 222,
				JOB_PMC_GUNNER = 223,
				JOB_PMC_MEDIC = 224,
				JOB_PMC_INVESTIGATOR = 224,
				JOB_PMC_ENGINEER = 225,
				JOB_PMC_STANDARD = 226,
				JOB_PMC_DETAINER = 227,
				JOB_PMC_CROWD_CONTROL = 228,
				JOB_PMC_DOCTOR = 229,
				JOB_WY_GOON_LEAD = 230,
				JOB_WY_GOON = 231,

				// Appear at bottom of squad list
				JOB_MARINE_RAIDER_SL = 130,
				RAIDER_SL_SQUAD = 130,
				JOB_MARINE_RAIDER = 131,
				RAIDER_SQUAD = 131,
			)
			var/squad_number = 70
			for(var/squad_name in GLOB.ROLES_SQUAD_ALL + "")
				if(!squad_name)
					squad_number = 120
				else
					squad_name += " "
				jobs += list(
					"[squad_name][JOB_SQUAD_LEADER]" = (squad_number),
					"[squad_name][JOB_SQUAD_TEAM_LEADER]" = (squad_number + 1),
					"[squad_name][JOB_SQUAD_SPECIALIST]" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SPECIALIST] (Scout)" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SPECIALIST] (Sniper)" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SPECIALIST] (Demo)" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SPECIALIST] (Grenadier)" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SPECIALIST] (Pyro)" = (squad_number + 2),
					"[squad_name][JOB_SQUAD_SMARTGUN]" = (squad_number + 3),
					"[squad_name][JOB_SQUAD_ENGI]" = (squad_number + 4),
					"[squad_name][JOB_SQUAD_MEDIC]" = (squad_number + 5),
					"[squad_name][JOB_SQUAD_MARINE]" = (squad_number + 6),
				)
				squad_number += 10
		if(FACTION_WY, FACTION_PMC)
			jobs = list(
				// Note that jobs divisible by 10 are considered heads of staff, and bolded
				// 00-09: High Command
				JOB_DIRECTOR = 00,
				JOB_DEPUTY_DIRECTOR = 01,
				JOB_CHIEF_EXECUTIVE = 02,
				// 10-19: Command Level Staff
				JOB_PMC_DIRECTOR = 10,
				JOB_DIVISION_MANAGER = 10,
				JOB_ASSISTANT_MANAGER = 11,
				// 20-29: Corporate Staff
				JOB_EXECUTIVE_SUPERVISOR = 20,
				JOB_LEGAL_SUPERVISOR = 20,
				JOB_EXECUTIVE_SPECIALIST = 21,
				JOB_LEGAL_SPECIALIST = 21,
				JOB_SENIOR_EXECUTIVE = 22,
				JOB_EXECUTIVE = 23,
				JOB_JUNIOR_EXECUTIVE = 24,
				// 30-38: Security
				JOB_WY_GOON_LEAD = 30,
				JOB_WY_GOON_MEDIC = 31,
				JOB_WY_GOON_TECH = 32,
				JOB_WY_GOON = 33,
				// 39-49: MedSci
				JOB_PMC_SYNTH = 39,
				JOB_WY_RESEARCH_LEAD = 40,
				JOB_PMC_DOCTOR = 41,
				JOB_WY_RESEARCHER = 42,
				// 50-59: Engineering & Vehicle Crew
				JOB_PMC_CREWMAN = 51,
				JOB_PMC_ENGINEER = 52,
				// 60-69: Investigation Team
				JOB_PMC_LEAD_INVEST = 60,
				JOB_PMC_INVESTIGATOR = 61,
				JOB_PMC_DETAINER = 62,
				JOB_PMC_CROWD_CONTROL = 63,

				// 70-79 PMCs Combat Team
				JOB_PMC_LEADER = 70,
				JOB_PMC_SNIPER = 71,
				JOB_PMC_GUNNER = 72,
				JOB_PMC_MEDIC = 73,
				JOB_PMC_STANDARD = 75,

				// 70-79 W-Y Commando Combat Team
				JOB_WY_COMMANDO_STANDARD = 70,
				JOB_WY_COMMANDO_LEADER= 71,
				JOB_WY_COMMANDO_GUNNER = 72,
				JOB_WY_COMMANDO_DOGCATHER = 73,

				// ANYTHING ELSE = UNKNOWN_JOB_ID, Unknowns/custom jobs will appear after civilians, and before stowaways
				JOB_STOWAWAY = 999,

				// 200-229: Visitors
				JOB_UPP_REPRESENTATIVE = 201,
				JOB_TWE_REPRESENTATIVE = 201,
				JOB_COLONEL = 201,
				JOB_TRAINEE = 202, //Trainees aren't really cared about
			)
		if(FACTION_UPP)
			jobs = list(
				// Note that jobs divisible by 10 are considered heads of staff, and bolded
				// 00-09: High Command
				JOB_UPP_GENERAL = 00,
				JOB_UPP_LT_GENERAL = 00,
				JOB_UPP_MAY_GENERAL = 00,
				JOB_UPP_BRIG_GENERAL = 00,
				JOB_UPP_KOL_OFFICER = 00,
				// 10-19: Command Team
				JOB_UPP_KOL_OFFICER = 10,
				JOB_UPP_LTKOL_OFFICER = 10,
				JOB_UPP_CO_OFFICER = 10, //The actual CO role.
				JOB_UPP_MAY_OFFICER = 10,
				JOB_UPP_KPT_OFFICER = 11,
				JOB_UPP_SRLT_OFFICER = 13,
				JOB_UPP_LT_OFFICER = 14,
				JOB_UPP_PILOT = 15,
				// 20-29: Commandos
				JOB_UPP_COMMANDO_LEADER = 20,
				JOB_UPP_COMMANDO_MEDIC = 21,
				JOB_UPP_COMMANDO = 22,
				// 30-39: Security
				JOB_UPP_POLICE = 31,
				JOB_UPP_COMMISSAR = 41,
				// 40-49: MedSci
				JOB_UPP_LT_DOKTOR = 41,
				// 50-59: Engineering
				JOB_UPP_COMBAT_SYNTH = 50,
				JOB_UPP_CREWMAN = 51,
				JOB_UPP_SUPPORT_SYNTH = 52,
				JOB_UPP_SUPPLY = 53,
				// 60-69: Soldiers
				JOB_UPP_LEADER = 60,
				JOB_UPP_SPECIALIST = 61,
				JOB_UPP_MEDIC = 62,
				JOB_UPP_ENGI = 63,
				JOB_UPP = 64,
				JOB_UPP_CONSCRIPT = 65,

				// ANYTHING ELSE = UNKNOWN_JOB_ID, Unknowns/custom jobs will appear after civilians, and before stowaways
				JOB_STOWAWAY = 999,

				// 200-229: Visitors
				JOB_UPP_REPRESENTATIVE = 201,
				JOB_TWE_REPRESENTATIVE = 201,
				JOB_COLONEL = 201
			)
		else
			jobs = list()

/datum/crewmonitor/yautja
	faction = FACTION_YAUTJA

/datum/crewmonitor/yautja/update_data()
	var/list/results = list()
	for(var/mob/living/carbon/human/human_mob as anything in GLOB.human_mob_list)

		if(!isyautja(human_mob))
			continue

		if(faction != human_mob.faction)
			continue

		// Check if z-level is correct
		var/turf/pos = get_turf(human_mob)
		if(!pos)
			continue

		// The entry for this human
		var/list/entry = list(
			"ref" = REF(human_mob),
			"name" = human_mob.real_name,
			"ijob" = UNKNOWN_JOB_ID,
			"assignment" = "Hunter",
			"oxydam" = round(human_mob.getOxyLoss(), 1),
			"toxdam" = round(human_mob.getToxLoss(), 1),
			"burndam" = round(human_mob.getFireLoss(), 1),
			"brutedam" = round(human_mob.getBruteLoss(), 1),
			"can_track" = TRUE,
		)

		if(is_mainship_level(pos.z))
			entry["side"] = "Almayer"

		var/area/mob_area = get_area(human_mob)
		entry["area"] = sanitize_area(mob_area.name)

		results[++results.len] = entry

	// Cache result
	data = results
	last_update = world.time

	return results

#undef SENSOR_LIVING
#undef SENSOR_VITALS
#undef SENSOR_COORDS
#undef SENSORS_UPDATE_PERIOD
#undef UNKNOWN_JOB_ID
#undef RAIDER_SQUAD
#undef RAIDER_SL_SQUAD
#undef RAIDER_OFFICER_SQUAD
