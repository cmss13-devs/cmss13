// Sentence states
#define BRIG_SENTENCE_ACTIVE (1<<0) // Is the timer currently running?
#define BRIG_SENTENCE_PAUSED (1<<1) // Is the timer currently paused?
#define BRIG_SENTENCE_SERVED (1<<2) // Has the sentence served it's time?
#define BRIG_SENTENCE_PARDONED (1<<3) // Has the sentence been pardoned?
#define BRIG_SENTENCE_PERMA (1<<4) // Is this sentence a permabrig sentence?

/obj/structure/machinery/brig_cell
	name = "\improper Cell Controller"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "security"
	desc = "A remote control for a door."
	req_access = list(ACCESS_MARINE_BRIG)
	anchored = TRUE    		// can't pick it up
	density = FALSE       		// can walk through it.
	unacidable = TRUE
	indestructible = TRUE

	var/id = null     		// id of door it controls.
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/structure/machinery/targets = list() // A list of World objects this machine controls.

	var/list/obj/item/paper/incident/incident_reports = list()
	var/obj/item/paper/incident/active_report = null // The report currently ticking down the clock.
	var/obj/item/paper/incident/viewed_report = null // The report currently being viewed.

	maptext_height = 26
	maptext_width = 32

/obj/structure/machinery/brig_cell/attack_hand(mob/user)
	if(..() || !allowed(usr) || inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/brig_cell/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "BrigCell", "Brig Cell")
		ui.open()

/obj/structure/machinery/brig_cell/ui_data(mob/user)
	var/list/data = list()

	data["viewing_incident"] = viewed_report ? TRUE : FALSE

	if (viewed_report)
		var/datum/crime_incident/incident = viewed_report.incident

		var/time_left = get_time_left(incident)

		data["suspect"] = incident.criminal_name
		data["progress"] = 1 - (time_left / 60) / incident.brig_sentence
		data["sentence"] = (incident.status & BRIG_SENTENCE_PERMA) ? "Permabrig" : "[incident.brig_sentence] Minutes"
		data["time_left"] = "[num2text((time_left / 60) % 60)]:[add_zero(num2text(time_left % 60), 2)]"

		// Flags.
		data["active"]	= (incident.status & BRIG_SENTENCE_ACTIVE) // Is this timer currently ticking?
		data["started"]	= (incident.time_served || data["active"]) // Has this timer been started at all?

		if (incident.status & BRIG_SENTENCE_PARDONED)
			data["status_text"] = "PARDONED"
			data["status_class"] = "info"
		else if (incident.status & BRIG_SENTENCE_PERMA)
			data["status_text"] = "PERMABRIG"
			data["status_class"] = "danger"
		else if (incident.status & BRIG_SENTENCE_SERVED)
			data["status_text"] = "SERVED"
			data["status_class"] = "success"
		else
			data["status_text"] = null
			data["status_class"] = null

	data["incidents"] = list()
	for (var/obj/item/paper/incident/paper as anything in incident_reports)
		var/datum/crime_incident/incident = paper.incident
		var/list/incident_data = list()

		incident_data["suspect"] = incident.criminal_name
		incident_data["ref"] = "\ref[paper]"

		data["incidents"] += list(incident_data)

	data["can_pardon"] = FALSE
	// Does this user have the ability to pardon?
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if((H.get_paygrade(1) in GLOB.co_paygrades) || (H.get_paygrade(1) in GLOB.highcom_paygrades) || (H.get_paygrade(1) == "PvI"))
			message_admins("Can pardon!")
			data["can_pardon"] = TRUE
		else
			message_admins("can't pardon")

	return data


/obj/structure/machinery/brig_cell/proc/get_time_left(datum/crime_incident/incident)
	var/time = (incident.time_to_release - REALTIMEOFDAY)/10

	if(!(incident.status & BRIG_SENTENCE_ACTIVE))
		time = ((incident.brig_sentence * 600) - incident.time_served)/10
	return max(0, time)


/obj/structure/machinery/brig_cell/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch (action)
		if ("set_viewed_incident")
			var/new_incident = params["incident"]
			if (new_incident)
				viewed_report = locate(new_incident)
			else
				viewed_report = null

		if ("toggle_doors")
			for (var/obj/structure/machinery/door/poddoor/almayer/locked/door in targets)
				if (door.density)
					door.open()
				else
					door.close()

		if ("flash")
			for (var/obj/structure/machinery/flasher/flasher in targets)
				flasher.flash()

		if ("start_timer")
			// Pause existing timer, if there is one.
			timer_pause(usr)
			timer_start(usr)

		if ("pause_timer")
			timer_pause(usr)

		if ("end_timer")
			timer_end(usr)

		if ("reset_timer")
			timer_reset(usr)

		if ("pardon")
			do_pardon(usr)

		if ("remove_report")
			remove_report(usr)

	return TRUE

/obj/structure/machinery/brig_cell/process()
	if(inoperable())
		return

	// Sentence complete.
	var/datum/crime_incident/incident = active_report.incident
	if(REALTIMEOFDAY > incident.time_to_release)
		ai_silent_announcement("BRIG REPORT: [incident.criminal_name] has served their time from [src]. Release them.", ":p")
		timer_end()

	update_icon()


// Eject this incident from the machine.
/obj/structure/machinery/brig_cell/proc/remove_report(mob/living/user)
	if(!viewed_report)
		return

	if(viewed_report.incident.status & BRIG_SENTENCE_ACTIVE)
		timer_pause(user)

	viewed_report.forceMove(get_turf(user))
	incident_reports -= viewed_report
	viewed_report = null


// Pardon this incident.
/obj/structure/machinery/brig_cell/proc/do_pardon(mob/user)
	viewed_report.incident.status |= BRIG_SENTENCE_PARDONED
	viewed_report.name += " (PARDONED)"

	log_admin("[key_name(user)] has pardoned [viewed_report.incident.criminal_name] for [viewed_report.incident.charges_to_string()].")
	ai_silent_announcement("BRIG REPORT: [viewed_report.incident.criminal_name] has been pardoned for [viewed_report.incident.charges_to_string()].")

	timer_end()


// Start the timer.
/obj/structure/machinery/brig_cell/proc/timer_start(mob/living/user)
	if(inoperable() || !viewed_report)
		return FALSE

	active_report = viewed_report
	var/datum/crime_incident/incident = active_report.incident

	// Calculate remaining time left.
	incident.time_to_release = REALTIMEOFDAY + incident.brig_sentence * 600 - incident.time_served
	if(!incident.time_served)
		ai_silent_announcement("BRIG REPORT: [incident.criminal_name] has been jailed for [incident.charges_to_string()].")

	// Close cell doors.
	for(var/obj/structure/machinery/door/window/brigdoor/door in targets)
		if(door.density)
			continue
		INVOKE_ASYNC(door, /obj/structure/machinery/door.proc/close)

	// Perma sentences don't need to process the timer.
	if (!(incident.status & BRIG_SENTENCE_PERMA))
		start_processing()

	log_admin("[key_name(user)] has jailed [incident.criminal_name] for [incident.charges_to_string()].")

	incident.status |= BRIG_SENTENCE_ACTIVE

	update_icon()


// Pause the timer.
/obj/structure/machinery/brig_cell/proc/timer_pause(mob/living/user)
	if(!active_report)
		return

	var/datum/crime_incident/incident = active_report.incident

	incident.status &= ~BRIG_SENTENCE_ACTIVE
	incident.time_served = (incident.brig_sentence * 600) - (incident.time_to_release - REALTIMEOFDAY)

	log_admin("[key_name(user)] has paused the jail timer of [incident.criminal_name], [incident.charges_to_string()].")

	active_report = null
	stop_processing()
	update_icon()


// End the timer.
/obj/structure/machinery/brig_cell/proc/timer_end(mob/living/user = null)
	if(inoperable() || !active_report)
		return FALSE

	var/datum/crime_incident/incident = active_report.incident

	incident.status &= ~BRIG_SENTENCE_ACTIVE
	incident.status |= BRIG_SENTENCE_SERVED

	if (user)
		log_admin("[key_name(user)] has ended the jail timer of [incident.criminal_name], [incident.charges_to_string()].")

	active_report = null
	stop_processing()
	update_icon()


// Reset the timer (and statuses).
/obj/structure/machinery/brig_cell/proc/timer_reset(mob/living/user)
	if(inoperable() || !viewed_report)
		return FALSE

	var/datum/crime_incident/incident = viewed_report.incident

	incident.time_to_release = REALTIMEOFDAY + incident.brig_sentence * 600
	incident.time_served = 0
	incident.status &= ~BRIG_SENTENCE_PARDONED
	incident.status &= ~BRIG_SENTENCE_SERVED

	log_admin("[key_name(user)] has reset the jail timer of [incident.criminal_name], [incident.charges_to_string()].")
	ai_silent_announcement("BRIG REPORT: [incident.criminal_name] had their jail time reset by [user].", ":p")

	update_icon()


/obj/structure/machinery/brig_cell/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/search_for_components), 20)

/obj/structure/machinery/brig_cell/proc/search_for_components()
	for(var/obj/structure/machinery/door/window/brigdoor/M in machines)
		if(M.id == id)
			targets += M

	for(var/obj/structure/machinery/flasher/F in machines)
		if(F.id == id)
			targets += F

	for(var/obj/structure/machinery/door/poddoor/almayer/locked/P in machines)
		if(P.id == id)
			targets += P

	if(!length(targets))
		stat |= BROKEN

	update_icon()

/obj/structure/machinery/brig_cell/update_icon()
	if (stat & (NOPOWER))
		icon_state = "frame"
		return

	if (stat & (BROKEN))
		set_picture("ai_bsod")
		return

	if (active_report && (active_report.incident.status & BRIG_SENTENCE_ACTIVE))
		var/disp1 = id
		var/time_left = get_time_left(active_report.incident)
		var/disp2

		// Perma sentence shows 'Perma. Regular sentence shows the timer.
		if (active_report.incident.status & BRIG_SENTENCE_PERMA)
			disp2 = "PERM"
		else
			disp2 = "[add_zero(num2text((time_left / 60) % 60),2)]~[add_zero(num2text(time_left % 60), 2)]"
			if (length(disp2) > 5)
				disp2 = "Error"

		update_display(disp1, disp2)
	else
		if (maptext)
			maptext = ""

/obj/structure/machinery/brig_cell/power_change()
	..()

	update_icon()

/obj/structure/machinery/brig_cell/attackby(obj/item/W, mob/living/user)
	if(!istype(W, /obj/item/paper/incident))
		return

	user.temp_drop_inv_item(W)
	W.moveToNullspace()
	incident_reports += W

	to_chat(user, SPAN_NOTICE("You insert [W] into [name]."))

/obj/structure/machinery/brig_cell/proc/set_picture(state)
	picture_state = state
	overlays.Cut()
	overlays += image('icons/obj/structures/machinery/status_display.dmi', icon_state=picture_state)

/obj/structure/machinery/brig_cell/proc/update_display(line1, line2)
	var/new_text = {"<div style="font-size:'5pt'; color:'#09f'; font:'Arial Black';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/structure/machinery/brig_cell/proc/texticon(tn, px = 0, py = 0)
	var/image/I = image('icons/obj/structures/machinery/status_display.dmi', "blank")
	var/len = length(tn)

	for(var/d = 1 to len)
		var/char = copytext(tn, len-d+1, len-d+2)
		if(char == " ")
			continue
		var/image/ID = image('icons/obj/structures/machinery/status_display.dmi', icon_state=char)
		ID.pixel_x = -(d-1)*5 + px
		ID.pixel_y = py
		I.overlays += ID
	return I


/obj/structure/machinery/brig_cell/cell_1
	name = "Cell 1"
	id = "Cell 1"

/obj/structure/machinery/brig_cell/cell_2
	name = "Cell 2"
	id = "Cell 2"

/obj/structure/machinery/brig_cell/cell_3
	name = "Cell 3"
	id = "Cell 3"

/obj/structure/machinery/brig_cell/cell_4
	name = "Cell 4"
	id = "Cell 4"

/obj/structure/machinery/brig_cell/perma_1
	name = "Perma 1"
	id = "Perma 1"

/obj/structure/machinery/brig_cell/perma_2
	name = "Perma 2"
	id = "Perma 2"
