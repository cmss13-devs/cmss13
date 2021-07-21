#define CARDCON_DEPARTMENT_MISC "Miscellaneous"
#define CARDCON_DEPARTMENT_MARINE "Marines"
#define CARDCON_DEPARTMENT_SECURITY "Security"
#define CARDCON_DEPARTMENT_MEDICAL "Medical and Science"
#define CARDCON_DEPARTMENT_MEDICALWO "Medical"
#define CARDCON_DEPARTMENT_SUPPLY "Supply"
#define CARDCON_DEPARTMENT_AUXCOM "Auxiliary Command"
#define CARDCON_DEPARTMENT_ENGINEERING "Engineering"
#define CARDCON_DEPARTMENT_COMMAND "Command"

/obj/structure/machinery/computer/card
	name = "Identification Computer"
	desc = "Terminal for programming USCM employee ID card access."
	icon_state = "id"
	req_access = list(ACCESS_MARINE_LOGISTICS)
	circuit = /obj/item/circuitboard/computer/card
	var/obj/item/card/id/user_id_card
	var/obj/item/card/id/target_id_card
	// What factions we are able to modify
	var/list/factions = list(FACTION_MARINE)
	var/printing

	var/is_centcom = FALSE
	var/authenticated = FALSE

/obj/structure/machinery/computer/card/proc/authenticate(mob/user, obj/item/card/id/id_card)
	if(!id_card)
		visible_message("<span class='bold'>[src]</span> states, \"AUTH ERROR: Authority confirmation card is missing!\"")
		return FALSE

	if(check_access(id_card))
		authenticated = TRUE
		visible_message("<span class='bold'>[src]</span> states, \"AUTH LOGIN: Welcome, [id_card.registered_name]. Access granted.\"")
		update_static_data(user)
		return TRUE

	visible_message("<span class='bold'>[src]</span> states, \"AUTH ERROR: You have not enough authority! Access denied.\"")
	return FALSE

/obj/structure/machinery/computer/card/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CardMod", name)
		ui.open()

/obj/structure/machinery/computer/card/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/user = usr

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
			visible_message("<span class='bold'>[src]</span> states, \"AUTH LOGOUT: Session end confirmed.\"")
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
					if(!authenticated)
						return
					printing = TRUE
					playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
					sleep(40)
					var/faction = "N/A"
					if(target_id_card.faction_group && islist(target_id_card.faction_group))
						faction = jointext(target_id_card.faction_group, ", ")
					if(isnull(target_id_card.faction_group))
						target_id_card.faction_group = list()
					else
						faction = target_id_card.faction_group
					var/contents = {"<center><h4>Access Report</h4></center>
								<u>Prepared By:</u> [user_id_card?.registered_name ? user_id_card.registered_name : "Unknown"]<br>
								<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<hr>
								<u>Faction:</u> [faction]<br>
								<u>Assignment:</u> [target_id_card.assignment]<br>
								<u>Account Number:</u> #[target_id_card.associated_account_number]<br>
								<u>Blood Type:</u> [target_id_card.blood_type]<br><br>
								<u>Access:</u><br>
								"}

					var/known_access_rights = get_all_accesses()
					for(var/A in target_id_card.access)
						if(A in known_access_rights)
							contents += "  [get_access_desc(A)]"

					var/obj/item/paper/P = new /obj/item/paper(src.loc)
					P.name = "Access Report"
					P.info += contents
				else
					printing = TRUE
					playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
					sleep(40)
					var/obj/item/paper/P = new /obj/item/paper(src.loc)
					P.name = text("Crew Manifest ([])", worldtime2text())
					P.info = {"<center><h4>Crew Manifest</h4></center>
						<br>
						[GLOB.data_core.get_manifest(TRUE)]
					"}
				visible_message(SPAN_NOTICE("\The [src] prints out a paper."))
				printing = FALSE
				return TRUE
			return
		if("PRG_eject")
			var/origin_assignment
			var/origin_name
			if(target_id_card)
				if(target_id_card.registered_name != origin_name || target_id_card.assignment != origin_assignment)
					GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.assignment, target_id_card.rank)
					target_id_card.name = text("[target_id_card.registered_name]'s ID Card ([target_id_card.assignment])")
					if(target_id_card.registered_name != origin_name)
						log_idmod(target_id_card, "<font color='orange'> [key_name_admin(usr)] changed the registered name of the ID to '[target_id_card.registered_name]'. </font>")
					if(target_id_card.assignment != origin_assignment)
						log_idmod(target_id_card, "<font color='orange'> [key_name_admin(usr)] changed the assignment of the ID to the custom position '[target_id_card.assignment]'. </font>")
				if(ishuman(user))
					target_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(target_id_card)
					target_id_card = null
				else
					target_id_card.forceMove(loc)
					target_id_card = null
				visible_message("<span class='bold'>[src]</span> states, \"CARD EJECT: Data imprinted. Updating database... Success.\"")
				return TRUE
			else
				var/obj/item/I = user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					if(user.drop_held_item())
						I.forceMove(src)
						target_id_card = I
						visible_message("<span class='bold'>[src]</span> states, \"CARD FOUND: Preparing ID modification protocol.\"")
						update_static_data(user)
						origin_assignment = target_id_card.assignment
						origin_name = target_id_card.registered_name
						return TRUE
			return FALSE
		if("PRG_terminate")
			if(!authenticated)
				return

			target_id_card.assignment = "Terminated"
			target_id_card.access = list()
			log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] terminated the ID. </font>")
			message_staff("[key_name_admin(usr)] terminated the ID of [target_id_card.registered_name].")
			return TRUE
		if("PRG_edit")
			if(!authenticated || !target_id_card)
				return
			var/new_name = params["name"]	// reject_bad_name() can be added here
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
				var/custom_name = params["custom_name"]
				if(custom_name)
					target_id_card.assignment = custom_name
			else
				var/list/new_access = list()
				if(is_centcom)
					new_access = get_centcom_access(target)
				else
					var/datum/job/job = RoleAuthority.roles_for_mode[target]

					if(!job)
						visible_message("<span class='bold'>[src]</span> states, \"DATA ERROR: Can not find next entry in database: [target]\"")
						return
					new_access = job.get_access()
				target_id_card.access -= get_all_centcom_access() + get_all_accesses()
				target_id_card.access |= new_access
				target_id_card.assignment = target
				target_id_card.rank = target
			message_staff("[key_name_admin(usr)] gave the ID of [target_id_card.registered_name] the assignment '[target_id_card.assignment]'.")
			return TRUE
		if("PRG_access")
			if(!authenticated)
				return
			var/access_type = params["access_target"]
			if(params["access_target"] in factions)
				if(!target_id_card.faction_group)
					target_id_card.faction_group = list()
				if(params["access_target"] in target_id_card.faction_group)
					target_id_card.faction_group -= params["access_target"]
					log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] revoked [access_type] IFF. </font>")
				else
					target_id_card.faction_group |= params["access_target"]
					log_idmod(target_id_card, "<font color='green'> [key_name_admin(usr)] granted [access_type] IFF. </font>")
				return TRUE
			access_type = text2num(params["access_target"])
			if(access_type in (is_centcom ? get_all_centcom_access() : get_all_accesses()))
				if(access_type in target_id_card.access)
					target_id_card.access -= access_type
					log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] revoked access '[access_type]'. </font>")
				else
					target_id_card.access |= access_type
					log_idmod(target_id_card, "<font color='green'> [key_name_admin(usr)] granted access '[access_type]'. </font>")
				return TRUE
		if("PRG_grantall")
			if(!authenticated)
				return
			target_id_card.access |= (is_centcom ? get_all_centcom_access() : get_all_accesses())
			target_id_card.faction_group |= factions
			log_idmod(target_id_card, "<font color='green'> [key_name_admin(usr)] granted the ID all access and USCM IFF. </font>")
			return TRUE
		if("PRG_denyall")
			if(!authenticated)
				return
			var/list/access = target_id_card.access
			access.Cut()
			target_id_card.faction_group -= factions
			log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] removed all accesses and USCM IFF. </font>")
			return TRUE
		if("PRG_grantregion")
			if(!authenticated)
				return
			if(params["region"] == "Faction (IFF system)")
				target_id_card.faction_group |= factions
				log_idmod(target_id_card, "<font color='green'> [key_name_admin(usr)] granted USCM IFF. </font>")
				return TRUE
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access |= get_region_accesses(region)
			var/additions = get_region_accesses_name(region)
			log_idmod(target_id_card, "<font color='green'> [key_name_admin(usr)] granted all [additions] accesses. </font>")
			return TRUE
		if("PRG_denyregion")
			if(!authenticated)
				return
			if(params["region"] == "Faction (IFF system)")
				target_id_card.faction_group -= factions
				log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] revoked USCM IFF. </font>")
				return TRUE
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access -= get_region_accesses(region)
			var/additions = get_region_accesses_name(region)
			log_idmod(target_id_card, "<font color='red'> [key_name_admin(usr)] revoked all [additions] accesses. </font>")
			return TRUE
		if("PRG_account")
			if(!authenticated)
				return
			var/account = text2num(params["account"])
			target_id_card.associated_account_number = account
			log_idmod(target_id_card, "<font color='orange'> [key_name_admin(usr)] changed the account number to '[account]'. </font>")
			return TRUE

/obj/structure/machinery/computer/card/ui_static_data(mob/user)
	var/list/data = list()
	data["station_name"] = station_name
	data["centcom_access"] = is_centcom
	data["manifest"] = GLOB.data_core.get_manifest(FALSE, FALSE, TRUE)

	var/list/departments
	if(is_centcom)
		departments = list("CentCom" = get_all_centcom_jobs())
	else if(Check_WO())
		// I am not sure about WOs departments so it may need adjustment
		departments = list(
			CARDCON_DEPARTMENT_COMMAND = ROLES_CIC & ROLES_WO,
			CARDCON_DEPARTMENT_AUXCOM = ROLES_AUXIL_SUPPORT & ROLES_WO,
			CARDCON_DEPARTMENT_MISC = ROLES_MISC & ROLES_WO,
			CARDCON_DEPARTMENT_SECURITY = ROLES_POLICE & ROLES_WO,
			CARDCON_DEPARTMENT_ENGINEERING = ROLES_ENGINEERING & ROLES_WO,
			CARDCON_DEPARTMENT_SUPPLY = ROLES_REQUISITION & ROLES_WO,
			CARDCON_DEPARTMENT_MEDICAL = ROLES_MEDICAL & ROLES_WO,
			CARDCON_DEPARTMENT_MARINE = ROLES_MARINES
		)
	else
		departments = list(
			CARDCON_DEPARTMENT_COMMAND = ROLES_CIC - ROLES_WO,
			CARDCON_DEPARTMENT_AUXCOM = ROLES_AUXIL_SUPPORT - ROLES_WO,
			CARDCON_DEPARTMENT_MISC = ROLES_MISC - ROLES_WO,
			CARDCON_DEPARTMENT_SECURITY = ROLES_POLICE - ROLES_WO,
			CARDCON_DEPARTMENT_ENGINEERING = ROLES_ENGINEERING - ROLES_WO,
			CARDCON_DEPARTMENT_SUPPLY = ROLES_REQUISITION - ROLES_WO,
			CARDCON_DEPARTMENT_MEDICAL = ROLES_MEDICAL - ROLES_WO,
			CARDCON_DEPARTMENT_MARINE = ROLES_MARINES
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
	for(var/i in 1 to 7)

		var/list/accesses = list()
		for(var/access in get_region_accesses(i))
			if (get_access_desc(access))
				accesses += list(list(
					"desc" = replacetext(get_access_desc(access), "&nbsp", " "),
					"ref" = access,
				))

		regions += list(list(
			"name" = get_region_accesses_name(i),
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

	data["station_name"] = station_name
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
					visible_message("<span class='bold'>[src]</span> states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
		else
			if(!target_id_card)
				if(user.drop_held_item())
					O.forceMove(src)
					target_id_card = O
					update_static_data(user)
					visible_message("<span class='bold'>[src]</span> states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
	else
		..()


/obj/structure/machinery/computer/card/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/card/bullet_act()
	return 0

/obj/structure/machinery/computer/card/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(user_id_card)
		user_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(user_id_card)
		if(operable())	// Powered. Console can response.
			visible_message("<span class='bold'>[src]</span> states, \"AUTH LOGOUT: Session end confirmed.\"")
		else
			to_chat(usr, "You remove \the [user_id_card] from \the [src].")
		authenticated = FALSE	// No card - no access
		user_id_card = null

	else if(target_id_card)
		target_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(target_id_card)
		if(operable())	// Powered. Make comp proceed ejection
			GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.assignment, target_id_card.rank)
			target_id_card.name = text("[target_id_card.registered_name]'s ID Card ([target_id_card.assignment])")
			visible_message("<span class='bold'>[src]</span> states, \"CARD EJECT: Data imprinted. Updating database... Success.\"")
		else
			to_chat(usr, "You remove \the [target_id_card] from \the [src].")
		target_id_card = null

	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/structure/machinery/computer/card/attack_hand(var/mob/user as mob)
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

//This console changes a marine's squad. It's very simple.
//It also does not: change or increment the squad count (used in the login randomizer), nor does it check for jobs.
//Which means you could get sillyiness like "Alpha Sulaco Chief Medical Officer" or "Delta Logistics Officer".
//But in the long run it's not really a big deal.

/obj/structure/machinery/computer/squad_changer
	name = "Squad Distribution Computer"
	desc = "You can use this to change someone's squad."
	icon_state = "guest"
	req_access = list(ACCESS_MARINE_LOGISTICS)
	var/obj/item/card/id/ID_to_modify = null
	var/mob/living/carbon/human/person_to_modify = null

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
				visible_message("<span class='bold'>[src]</span> states, \"CARD EJECT: ID modification protocol disabled.\"")
				return TRUE
			else
				var/obj/item/I = user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					if(user.drop_held_item())
						I.forceMove(src)
						ID_to_modify = I
						visible_message("<span class='bold'>[src]</span> states, \"CARD FOUND: Preparing ID modification protocol.\"")
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
				//First, remove any existing squad access and clear the card.
				for(var/datum/squad/Q in RoleAuthority.squads)
					if(findtext(ID_to_modify.assignment, Q.name)) //Found one!
						ID_to_modify.access -= Q.access //Remove any access found.
						person_to_modify.assigned_squad = null
				if(selected.put_marine_in_squad(person_to_modify, ID_to_modify))
					visible_message("<span class='bold'>[src]</span> states, \"DATABASE LOG: [person_to_modify] was assigned to [selected] Squad.\"")
					return TRUE
				else
					visible_message("<span class='bold'>[src]</span> states, \"DATABASE ERROR: There was an error assigning [person_to_modify] to [selected] Squad.\"")
			else if(!istype(ID_to_modify))
				to_chat(usr, SPAN_WARNING("You need to insert a card to modify."))
			else if(!istype(person_to_modify) || !person_to_modify.Adjacent(src))
				visible_message("<span class='bold'>[src]</span> states, \"SCANNER ERROR: You need to keep the hand of the person to be assigned to Squad!\"")
			else if(!person_to_modify.skills.get_skill_level(SKILL_FIREARMS))
				visible_message("<span class='bold'>[src]</span> states, \"QUALIFICATION ERROR: You cannot assign untrained civilians to squads!\"")
			else
				visible_message("<span class='bold'>[src]</span> states, \"ID ERROR: The ID in the machine is not owned by the person whose hand is scanned!\"")
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
	for(var/datum/squad/S in RoleAuthority.squads)
		if(S.usable)
			var/list/squad = list(list(
				"name" = S.name,
				"color" = S.color-1
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
				visible_message("<span class='bold'>[src]</span> states, \"CARD FOUND: Preparing ID modification protocol.\"")
			else
				to_chat(H, SPAN_NOTICE("Remove the inserted card first."))
		else if(istype(O, /obj/item/grab))
			var/obj/item/grab/G = O
			if(ismob(G.grabbed_thing))
				if(!operable())
					to_chat(usr, SPAN_NOTICE("You place [G.grabbed_thing]'s hand on scanner but \the [src] remains silent."))
					return
				var/isXenos = isXeno(G.grabbed_thing)
				H.visible_message(SPAN_NOTICE("You hear a beep as [G.grabbed_thing]'s [isXenos ? "limb" : "hand"] is scanned to \the [name]."))
				visible_message("<span class='bold'>[src]</span> states, \"SCAN ENTRY: [isXenos ? "Unknown lifeform detected! Forbidden operation!" : "Scaned, please stay close until operation's end."]\"")
				playsound(H.loc, 'sound/machines/screen_output1.ogg', 25, 1)
				// No Xeno Squads, please!
				if(!isXenos)
					person_to_modify = G.grabbed_thing
	else
		..()


/obj/structure/machinery/computer/squad_changer/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/squad_changer/bullet_act()
	return 0

/obj/structure/machinery/computer/squad_changer/attack_hand(var/mob/user as mob)
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
		var/isXenos = isXeno(user)
		user.visible_message(SPAN_NOTICE("You hear a beep as [user]'s [isXenos ? "limb" : "hand"] is scanned to \the [name]."))
		visible_message("<span class='bold'>[src]</span> states, \"SCAN ENTRY: [isXenos ? "Unknown lifeform detected! Forbidden operation!" : "Scaned, please stay close until operation's end."]\"")
		playsound(user.loc, 'sound/machines/screen_output1.ogg', 25, 1)
		// No Xeno Squads, please!
		if(!isXenos)
			person_to_modify = user

/// How often the sensor data is updated
#define SENSORS_UPDATE_PERIOD	10 SECONDS //How often the sensor data updates.
/// The job sorting ID associated with otherwise unknown jobs
#define UNKNOWN_JOB_ID			998

/obj/structure/machinery/computer/crew
	name = "Crew monitoring computer"
	desc = "Used to monitor active health sensors built into marine jumpsuits.  You can see that the console highlights ship areas with BLUE and remote locations with RED."
	icon_state = "crew"
	density = TRUE
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
//	circuit = "/obj/item/circuitboard/computer/crew"

GLOBAL_DATUM_INIT(crewmonitor, /datum/crewmonitor, new)

#define SENSOR_LIVING 1
#define SENSOR_VITALS 2
#define SENSOR_COORDS 3

/datum/crewmonitor
	/// List of user -> UI source
	var/list/ui_sources = list()
	/// Cache of data generated, used for serving the data within SENSOR_UPDATE_PERIOD of the last update
	var/list/data = list()
	/// Cache of last update time
	var/last_update
	/// Map of job to ID for sorting purposes
	var/list/jobs

/datum/crewmonitor/New()
	// Cause "[SQUAD_NAME_1] [JOB_SQUAD_LEADER]" calls "expected a constant expression" error
	jobs = list(
		// Note that jobs divisible by 10 are considered heads of staff, and bolded
		// 00-10: Command
		JOB_CO = 00,
		JOB_XO = 01,
		JOB_SO = 02,
		JOB_SEA = 03,
		// 10-19: Aux Command (Synth isn't Aux head, but important - make him bold)
		JOB_SYNTH = 10,
		JOB_PILOT = 11,
		JOB_CREWMAN	 = 12,
		JOB_INTEL = 13,
		// 20-29: Security
		JOB_CHIEF_POLICE = 20,
		JOB_WARDEN = 21,
		JOB_POLICE = 22,
		// 30-39: MedSci
		JOB_CMO = 30,
		JOB_DOCTOR = 31,
		JOB_NURSE = 32,
		JOB_RESEARCHER = 33,
		// 40-49: Engineering
		JOB_CHIEF_ENGINEER = 40,
		JOB_ORDNANCE_TECH = 41,
		JOB_MAINT_TECH = 42,
		// 50-59: Cargo
		JOB_CHIEF_REQUISITION = 50,
		JOB_CARGO_TECH = 51,
		// SQUADS
		// 60-79: Alpha
		"[SQUAD_NAME_1] [JOB_SQUAD_LEADER]" = 60,
		"[SQUAD_NAME_1] [JOB_SQUAD_SPECIALIST]" = 61,
		"[SQUAD_NAME_1] [JOB_SQUAD_SMARTGUN]" = 62,
		"[SQUAD_NAME_1] [JOB_SQUAD_ENGI]" = 63,
		"[SQUAD_NAME_1] [JOB_SQUAD_MEDIC]" = 64,
		"[SQUAD_NAME_1] [JOB_SQUAD_MARINE]" = 65,
		// 70-79: Bravo
		"[SQUAD_NAME_2] [JOB_SQUAD_LEADER]" = 70,
		"[SQUAD_NAME_2] [JOB_SQUAD_SPECIALIST]" = 71,
		"[SQUAD_NAME_2] [JOB_SQUAD_SMARTGUN]" = 72,
		"[SQUAD_NAME_2] [JOB_SQUAD_ENGI]" = 73,
		"[SQUAD_NAME_2] [JOB_SQUAD_MEDIC]" = 74,
		"[SQUAD_NAME_2] [JOB_SQUAD_MARINE]" = 75,
		// 80-89: Charlie
		"[SQUAD_NAME_3] [JOB_SQUAD_LEADER]" = 80,
		"[SQUAD_NAME_3] [JOB_SQUAD_SPECIALIST]" = 81,
		"[SQUAD_NAME_3] [JOB_SQUAD_SMARTGUN]" = 82,
		"[SQUAD_NAME_3] [JOB_SQUAD_ENGI]" = 83,
		"[SQUAD_NAME_3] [JOB_SQUAD_MEDIC]" = 84,
		"[SQUAD_NAME_3] [JOB_SQUAD_MARINE]" = 85,
		// 90-99: Delta
		"[SQUAD_NAME_4] [JOB_SQUAD_LEADER]" = 90,
		"[SQUAD_NAME_4] [JOB_SQUAD_SPECIALIST]" = 91,
		"[SQUAD_NAME_4] [JOB_SQUAD_SMARTGUN]" = 92,
		"[SQUAD_NAME_4] [JOB_SQUAD_ENGI]" = 93,
		"[SQUAD_NAME_4] [JOB_SQUAD_MEDIC]" = 94,
		"[SQUAD_NAME_4] [JOB_SQUAD_MARINE]" = 95,
		// 100-109: Echo
		"[SQUAD_NAME_5] [JOB_SQUAD_LEADER]" = 100,
		"[SQUAD_NAME_5] [JOB_SQUAD_SPECIALIST]" = 101,
		"[SQUAD_NAME_5] [JOB_SQUAD_SMARTGUN]" = 102,
		"[SQUAD_NAME_5] [JOB_SQUAD_ENGI]" = 103,
		"[SQUAD_NAME_5] [JOB_SQUAD_MEDIC]" = 104,
		"[SQUAD_NAME_5] [JOB_SQUAD_MARINE]" = 105,
		// 110+: Civilian/other
		JOB_CORPORATE_LIAISON = 110,
		JOB_MESS_SERGEANT = 111,
		JOB_PASSENGER = 112,
		// Unknown squad IDs
		JOB_SQUAD_LEADER = 120,
		JOB_SQUAD_SPECIALIST = 121,
		JOB_SQUAD_SMARTGUN = 122,
		JOB_SQUAD_ENGI = 123,
		JOB_SQUAD_MEDIC = 124,
		JOB_SQUAD_MARINE = 125,
		// Non Almayer jobs lower then registered
		JOB_SYNTH_SURVIVOR = 130,
		JOB_SURVIVOR = 131,
		JOB_COLONIST = 132,

		// WO jobs
		// 00-10: Command
		JOB_WO_CO = 00,
		JOB_WO_XO = 01,
		// 10-19: Aux Command
		JOB_WO_CHIEF_POLICE = 10,
		JOB_WO_SO = 11,
		// 20-29: Security
		JOB_WO_CREWMAN = 20,
		JOB_WO_POLICE = 21,
		JOB_WO_PILOT = 22,
		// 30-39: MedSci
		JOB_WO_CMO = 30,
		JOB_WO_DOCTOR = 31,
		JOB_WO_RESEARCHER = 32,
		// 40-49: Engineering
		JOB_WO_CHIEF_ENGINEER = 40,
		JOB_WO_ORDNANCE_TECH = 41,
		// 50-59: Cargo
		JOB_WO_CHIEF_REQUISITION = 50,
		JOB_WO_REQUISITION = 51,
		// 60-109: SQUADS (look above)
		// 110+: Civilian/other
		JOB_WO_CORPORATE_LIAISON = 110,
		JOB_WO_SYNTH = 120,

		// ANYTHING ELSE = UNKNOWN_JOB_ID, Unknowns/custom jobs will appear after civilians, and before stowaways
		JOB_STOWAWAY = 999,

		// 200-229: Centcom
		"Admiral" = 200,
		"USCM Admiral" = 210,
		"Custodian" = 211,
		"Medical Officer" = 212,
		"Research Officer" = 213,
		"Emergency Response Team Commander" = 220,
		"Security Response Officer" = 221,
		"Engineer Response Officer" = 222,
		"Medical Response Officer" = 223
	)
	. = ..()

/datum/crewmonitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewConsole")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/crewmonitor/proc/show(mob/M, source)
	if(!ui_sources.len)
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
		if(!ui)	// What are you doing in list?
			ui_sources -= H

/datum/crewmonitor/ui_close(mob/M)
	. = ..()
	ui_sources -= M
	if(!ui_sources.len)
		STOP_PROCESSING(SSprocessing, src)

/datum/crewmonitor/ui_host(mob/user)
	return ui_sources[user]

/datum/crewmonitor/ui_data(mob/user)
	. = list(
		"sensors" = update_data(),
		"link_allowed" = isAI(user)
	)

/datum/crewmonitor/proc/update_data()
	var/list/results = list()
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		// Predators
		if(isYautja(H))
			continue
		// Survivors can't be found at ground (until we code remote access to local systems for Almayer)
		if(H.faction == FACTION_SURVIVOR && is_ground_level(H.loc.z))
			continue
		// Check for a uniform
		var/obj/item/clothing/under/C = H.w_uniform
		if(!C || !istype(C))
			continue
		// Check that sensors are present and active
		if(!C.has_sensor || !C.sensor_mode || !H.mind)
			continue

		// Check if z-level is correct
		var/turf/pos = get_turf(H)

		// The entry for this human
		var/list/entry = list(
			"ref" = REF(H),
			"name" = "Unknown",
			"ijob" = UNKNOWN_JOB_ID
		)

		// ID and id-related data
		var/obj/item/card/id/id_card = H.get_idcard()
		if (id_card)
			entry["name"] = id_card.registered_name
			entry["assignment"] = id_card.assignment
			entry["ijob"] = jobs[id_card.assignment]

		// Binary living/dead status
		if (C.sensor_mode >= SENSOR_LIVING)
			entry["life_status"] = !H.stat

		// Damage
		if (C.sensor_mode >= SENSOR_VITALS)
			entry += list(
				"oxydam" = round(H.getOxyLoss(), 1),
				"toxdam" = round(H.getToxLoss(), 1),
				"burndam" = round(H.getFireLoss(), 1),
				"brutedam" = round(H.getBruteLoss(), 1)
			)

		// Location
		if (pos && (C.sensor_mode >= SENSOR_COORDS))
			if(is_mainship_level(pos.z))
				entry["side"] = "Almayer"
			var/area/A = get_area(H)
			entry["area"] = sanitize(A.name)

		// Trackability
		entry["can_track"] = H.detectable_by_ai()

		results[++results.len] = entry

	// Cache result
	data = results
	last_update = world.time

	return results

/datum/crewmonitor/ui_act(action,params)
	. = ..()
	if(.)
		return
	switch (action)
		if ("select_person")
			// May work badly cause currently there is no player-controlled AI
			var/mob/living/silicon/ai/AI = usr
			if(!istype(AI))
				return
			var/mob/living/carbon/human/H
			for(var/entry in data)
				if(entry["name"] == params["name"])
					H = locate(entry["ref"])
					break
			if(!H)	// Sanity check
				to_chat(AI, SPAN_NOTICE("ERROR: unable to track subject with ID '[params["name"]]'"))
			else
				// We do not care is there camera or no - we just know his location
				AI.ai_actual_track(H)

/obj/structure/machinery/computer/crew/attack_remote(mob/living/user)
	attack_hand(user)

/obj/structure/machinery/computer/crew/attack_hand(mob/living/user)
	if(!isRemoteControlling(user))
		add_fingerprint(user)
	if(inoperable())
		return
	user.set_interaction(src)
	GLOB.crewmonitor.show(user, src)

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
	GLOB.crewmonitor.show(user, src)

#undef SENSOR_LIVING
#undef SENSOR_VITALS
#undef SENSOR_COORDS
#undef SENSORS_UPDATE_PERIOD
#undef UNKNOWN_JOB_ID
