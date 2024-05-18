
#define SECURITY 1
#define GENERAL 0

/obj/structure/machinery/computer/secure_data//TODO:MIGRATE THIS SHIT TO TGUI.
	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/secure_data
	// if the user currently logged into the system
	var/authenticated = FALSE
	// ID of the user currently griefing the logs
	var/obj/item/card/id/user_id_card = null
	var/obj/item/device/clue_scanner/scanner = null
	// the names of all living human mobs.
	var/list/human_mob_names = list()
	// the name of the mob we select to view security logs from.
	var/target_mob
	// target's general record
	var/list/target_general_record = list()

	// target security related logs, it needs to be separate because otherwise it's a pain to parse in tgui.
	var/list/crime_stat = list()
	var/list/incident = list()
	var/list/notes = list()

/obj/structure/machinery/computer/secure_data/proc/authenticate(mob/user, obj/item/card/id/id_card)
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

/obj/structure/machinery/computer/secure_data/attackby(obj/card, mob/user)
	if(!operable())
		to_chat(user, SPAN_NOTICE("You tried to inject \the [card] but \the [src] remains silent."))
		return

	if(istype(card, /obj/item/card/id))
		if(user_id_card)
			to_chat(user, "Remove the card first.")
			return

		var/obj/item/card/id/idcard = card
		if(!authenticate(user, card) && !is_not_allowed(user))
			return
		user_id_card = idcard
		if(user.drop_held_item())
			idcard.forceMove(src)
		update_static_data(user)
	else
		..()

/obj/structure/machinery/computer/secure_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.is_mob_incapacitated())
		return

	if(user_id_card)
		user_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(user_id_card)
		if(operable())
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
		else
			to_chat(usr, "You remove \the [user_id_card] from \the [src].")
		authenticated = FALSE
		user_id_card = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

// dump the general records, get all of the names. Immutable data.
/obj/structure/machinery/computer/secure_data/proc/retrieve_human_mob_names()
	var/list/mob_names

	// No, we can't use GLOB.human_mob_list since a mob is removed from that list when it gets deleted.
	for(var/record as anything in GLOB.data_core.general)
		var/datum/data/record/new_record = GLOB.data_core.general[record]
		mob_names += new_record.fields[MOB_NAME]

	return mob_names

// to make accessing the records more performant we only retrieve the security logs when a new target is selected in tgui or the record itself is updated.
/obj/structure/machinery/computer/secure_data/proc/retrieve_target_record(username)
	if(!username)
		return

	// lowkey this use of associated lists for the record_id is unnecessary in the new implementation, whatever, in 10 years someone can refactor it again.
	var/datum/data/record/target_sec_record = retrieve_record(mob_name = username, record_type = RECORD_TYPE_SECURITY)
	var/datum/data/record/target_gen_record = retrieve_record(mob_name = username, record_type = RECORD_TYPE_GENERAL)
	target_general_record = list(
		list(value = target_gen_record?.fields[MOB_NAME],message = "Name: "),
		list(value = target_gen_record?.fields[MOB_AGE], message ="Age: "),
		list(value = target_gen_record?.fields[MOB_SEX], message ="Sex: "),
		)

	crime_stat = list(
		stat = MOB_CRIMINAL_STATUS,
		value = target_sec_record?.fields[MOB_CRIMINAL_STATUS],
		message = "Criminal Status: "
	)
	incident = list(
		stat = MOB_INCIDENTS,
		value = target_sec_record?.fields[MOB_INCIDENTS],
		message = "Incidents: "
	)
	notes = list(
		stat = MOB_SECURITY_NOTES,
		value = target_sec_record?.fields[MOB_SECURITY_NOTES],
		message ="Security Notes: "
	)

	if(!target_gen_record || !crime_stat)
		visible_message("[SPAN_BOLD("[src]")] states, \"DATACORE FAILURE: Unable to retrieve database logs.\"")
		return FALSE
	return TRUE


/obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..() || inoperable())
		return

	if(!retrieve_human_mob_names())
		visible_message("[SPAN_BOLD("[src]")] states, \"DATACORE FAILURE: Unable to retrieve database logs.\"")
		return
	user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/secure_data/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/secure_data/bullet_act()
	return FALSE

/obj/structure/machinery/computer/secure_data/proc/generate_fingerprint_menu()
	var/dat = ""

	for(var/obj/effect/decal/prints/prints in scanner.print_list)
		dat += "<table><tr><td>"
		dat += "Name: [prints.criminal_name]<BR>"
		if(prints.criminal_squad)
			dat += "Squad: [prints.criminal_squad]<BR>"
		if(prints.criminal_rank)
			dat += "Rank: [prints.criminal_rank]<BR>"
		dat += "Description: [prints.description]<BR><hr><BR>"
		dat += "</td></tr></table>"

	dat += "<a href='?src=\ref[src];choice=print_report'>Print Evidence</a><BR>"
	dat += "<a href='?src=\ref[src];choice=return_menu'>Return</a><BR>"
	dat += "<a href='?src=\ref[src];choice=return_clear'>Clear Print and Return</a>"

	return dat

/obj/structure/machinery/computer/secure_data/proc/is_not_allowed(mob/user)
	return user.stat || user.is_mob_restrained() || (!in_range(src, user) && (!isSilicon(user)))

/obj/structure/machinery/computer/secure_data/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

/obj/structure/machinery/computer/secure_data/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	for(var/datum/data/record/R in GLOB.data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields[MOB_NAME] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields[MOB_SEX] = pick(MOB_STAT_SEX_MALE, MOB_STAT_SEX_FEMALE)
				if(3)
					R.fields[MOB_AGE] = rand(5, 85)
				if(4)
					R.fields[MOB_CRIMINAL_STATUS] = pick(MOB_STAT_CRIME_STATUS_LIST)
				if(5)
					R.fields[MOB_HEALTH_STATUS] = pick(MOB_STAT_HEALTH_LIST)
				if(6)
					R.fields[MOB_MENTAL_STATUS] = pick(MOB_STAT_MENTAL_STATUS_LIST)
			continue

/obj/structure/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "messyfiles"

// TGUI SEC
// ------------------------------------------------------------------------------------------------------ //
/obj/structure/machinery/computer/secure_data/tgui_interact(mob/user, datum/tgui/ui)

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SecRec", name)
		ui.open()

/obj/structure/machinery/computer/secure_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	playsound(src, "keyboard_alt", 5, 1)
	switch(action)
		if("authenticate")
			var/obj/item/id_card = user.get_active_hand()
			if (istype(id_card, /obj/item/card/id))
				if(user.drop_held_item())
					id_card.forceMove(src)
					user_id_card = id_card
			if(authenticate(user, user_id_card))
				return TRUE
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
		if("logout")
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
			authenticated = FALSE
			if(ishuman(user))
				user_id_card.forceMove(user.loc)
				if(!user.get_active_hand())
					user.put_in_hands(user_id_card)
			else
				user_id_card.forceMove(loc)
			user_id_card = null
			target_mob = null
			return TRUE
		if("selectTarget")
			var/name = params["new_user"]
			if(name == target_mob)
				target_mob = null // deselected the mob in tgui.
				return
			target_mob = name
			if(!retrieve_target_record(name))
				target_mob = null
				return

			return TRUE
		if("updateStatRecord")
			if(!insert_record_stat(mob_name = target_mob, record_type = RECORD_TYPE_SECURITY, stat_type = params["stat"], new_stat = params["new_value"]))
				visible_message("[SPAN_BOLD("[src]")] states, \"DATACORE FAILURE: Unable to update relevant database logs.\"")
				return
			retrieve_target_record(target_mob)
			return TRUE

/obj/structure/machinery/computer/secure_data/ui_static_data(mob/user)
	var/list/data = list()
	data["mob_names"] = human_mob_names
	return data

/obj/structure/machinery/computer/secure_data/ui_data(mob/user)
	var/list/data = list()

	data["human_mob_list"] = GLOB.human_mob_list
	data["selected_target_name"] = target_mob ? target_mob : FALSE
	data["crime_stat"] = crime_stat
	data["incident"] = incident
	data["notes"] = notes
	data["general_record"] = target_general_record
	data["id_name"] = user_id_card ? user_id_card?.name : "-----"
	data["authenticated"] = authenticated

	return data

#undef SECURITY
#undef GENERAL
