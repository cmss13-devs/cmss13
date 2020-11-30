/obj/structure/machinery/brig_cell
	name = "\improper Cell Controller"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "security"
	desc = "A remote control for a door."
	req_access = list(ACCESS_MARINE_BRIG)
	anchored = TRUE    		// can't pick it up
	density = FALSE       		// can walk through it.
	var/id = null     		// id of door it controls.
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/structure/machinery/targets = list()
	var/list/obj/item/paper/incident/incident_reports = list()
	var/obj/item/paper/incident/current_report = null

	var/current_menu = "main_menu"

	maptext_height = 26
	maptext_width = 32

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

	for(var/i in GLOB.brig_locker_list)
		var/obj/structure/closet/secure_closet/brig/C = i
		if(C.id == id)
			targets += C

	for(var/obj/structure/machinery/door/poddoor/almayer/locked/P in machines)
		if(P.id == id)
			targets += P

	if(length(targets) == 0)
		stat |= BROKEN

	update_icon()

/obj/structure/machinery/brig_cell/process()
	if(inoperable())
		return

	if(!incident_reports)
		stop_processing()

	for(var/obj/item/paper/incident/I in incident_reports)
		var/datum/crime_incident/incident = I.incident

		if(!incident.active_timer)
			continue

		var/time_left = get_time_left(I)
		// Midnight rollover dont badly
		if(time_left > 1e5)
			incident.time_to_release = 0

		if(world.timeofday > incident.time_to_release)
			timer_end(I)

	updateUsrDialog()
	update_icon()

/obj/structure/machinery/brig_cell/update_icon()
	if(stat & (NOPOWER))
		icon_state = "frame"
		return

	if(stat & (BROKEN))
		set_picture("ai_bsod")
		return

	if(current_report && current_report.incident.active_timer)
		var/disp1 = id
		var/time_left = get_time_left(current_report)
		var/disp2 = "[add_zero(num2text((time_left / 60) % 60),2)]~[add_zero(num2text(time_left % 60), 2)]"
		if(length(disp2) > 5)
			disp2 = "Error"
		update_display(disp1, disp2)
	else
		if(maptext)
			maptext = ""

/obj/structure/machinery/brig_cell/power_change()
	..()

	update_icon()

/obj/structure/machinery/brig_cell/attackby(var/obj/item/W, var/mob/living/user)
	if(!istype(W, /obj/item/paper/incident))
		return

	var/obj/item/paper/incident/I = W
	if(!I.incident || !I.incident.brig_sentence || I.incident.pardoned)
		return

	user.temp_drop_inv_item(I)
	I.loc = null
	incident_reports += I

	to_chat(user, SPAN_NOTICE("You insert [I] into [name]."))

/obj/structure/machinery/brig_cell/proc/remove_report(var/mob/living/user)
	if(!current_report)
		return

	if(current_report.incident.active_timer)
		timer_end()
		if(user)
			log_admin("[key_name(user)] has released [current_report.incident.criminal_name] early for [current_report.incident.charges_to_string()].")

	if(user)
		current_report.forceMove(get_turf(user))
	else
		current_report.forceMove(get_turf(src))

	incident_reports -= current_report
	current_report.incident.time_to_release = 0
	current_report = null
	current_menu = "main_menu"

/obj/structure/machinery/brig_cell/proc/timer_start(var/mob/living/user)
	if(inoperable()  || !current_report)
		return FALSE

	var/datum/crime_incident/C = current_report.incident
	C.active_timer = TRUE

	var/resuming = TRUE
	if(!C.time_to_release)
		resuming = FALSE
		C.time_to_release = world.timeofday + C.brig_sentence * 600
	else
		C.time_to_release = world.timeofday + ((C.brig_sentence * 600) - C.time_served)

	for(var/obj/structure/machinery/door/window/brigdoor/door in targets)
		if(door.density)
			continue

		INVOKE_ASYNC(door, /obj/structure/machinery/door.proc/close)

	start_processing()
	log_admin("[key_name(user)] has jailed [C.criminal_name] for [C.charges_to_string()].")
	if(!resuming)
		ai_silent_announcement("BRIG REPORT: [C.criminal_name] has been jailed for [C.charges_to_string()].")

/obj/structure/machinery/brig_cell/proc/timer_end(var/obj/item/paper/incident/I)
	if(inoperable() || (!I && !current_report))
		return FALSE

	var/datum/crime_incident/C
	if(I)
		C = I.incident
		C.sentence_served = TRUE
		ai_silent_announcement("BRIG REPORT: [C.criminal_name] has served their time from [src]. Release them.", ":p")
	else
		C = current_report.incident

	C.active_timer = FALSE

	C.time_served = (C.brig_sentence * 600) - (C.time_to_release - world.timeofday)
	C.time_to_release = 0

/obj/structure/machinery/brig_cell/proc/timer_pause(var/mob/living/user)
	if(!current_report)
		return

	var/datum/crime_incident/C = current_report.incident

	C.active_timer = FALSE
	C.time_served = (C.brig_sentence * 600) - (C.time_to_release - world.timeofday)

	log_admin("[key_name(user)] has paused the jail timer of [C.criminal_name], [C.charges_to_string()].")

/obj/structure/machinery/brig_cell/proc/get_time_left(var/obj/item/paper/incident/I)
	if(!istype(I))
		return 0
	var/datum/crime_incident/C = I.incident

	var/time = (I.incident.time_to_release - world.timeofday)/10
	if(time < 0)
		time = 0

	if(!C.active_timer)
		time = ((C.brig_sentence * 600) - C.time_served)/10

	return time

/obj/structure/machinery/brig_cell/proc/do_pardon(var/mob/user)
	current_report.incident.pardoned = TRUE
	current_report.name += " (PARDONED)"

	log_admin("[key_name(user)] has pardoned [current_report.incident.criminal_name] for [current_report.incident.charges_to_string()].")
	ai_silent_announcement("BRIG REPORT: [current_report.incident.criminal_name] has been pardoned for [current_report.incident.charges_to_string()].")

	timer_end(current_report)

/obj/structure/machinery/brig_cell/attack_hand(var/mob/user)
	if(..() || !allowed(usr))
		return

	ui_interact(user)

/obj/structure/machinery/brig_cell/ui_interact(var/mob/user)
	var/dat = "<HTML><BODY><TT>"

	dat += create_controls()
	dat += "<hr>"

	switch(current_menu)
		if("incident_menu")
			dat += create_incident(user)
		else
			dat += create_incident_reports()

	dat += "</TT></BODY></HTML>"

	show_browser(user, dat, "brig_timer")
	onclose(user, "brig_timer")

/obj/structure/machinery/brig_cell/proc/create_incident_reports()
	var/dat = ""
	dat += "Incident Reports: <br/>"
	for(var/obj/item/paper/incident/I in incident_reports)
		var/datum/crime_incident/incident = I.incident
		if(incident.sentence_served)
			dat += "<a href='?src=\ref[src];brig=incident;incident_report=\ref[I]'>[incident.criminal_name] (SERVED)</a><br/>"
		else
			dat += "<a href='?src=\ref[src];brig=incident;incident_report=\ref[I]'>[incident.criminal_name]</a><br/>"

	dat += "<br/>"

	return dat

/obj/structure/machinery/brig_cell/proc/create_incident(var/mob/user)
	var/second = round(get_time_left(current_report) % 60)
	var/minute = round((get_time_left(current_report) - second) / 60)

	var/dat = ""
	if(current_report.incident.criminal_name)
		dat += "Criminal Name: [current_report.incident.criminal_name] <br/>"
	if(current_report.incident.brig_sentence)
		dat += "Sentence: "
		if(current_report.incident.sentence_served)
			dat += "SERVED"
		else if(current_report.incident.brig_sentence < PERMABRIG_SENTENCE)
			dat += "[current_report.incident.brig_sentence] MINUTES"
		else
			dat += "PERMABRIG"
		dat += "<br/>"
	dat += "<br/>"

	dat += "Time Left: [(minute ? text("[minute]:") : null)][second] <br/>"
	dat += "<br/>"

	if(!current_report.incident.sentence_served)
		if(current_report.incident.active_timer)
			dat += "<a href='?src=\ref[src];brig=timer_pause'>Pause</a><br/>"
			dat += "<a href='?src=\ref[src];brig=timer_stop'>Stop</a><br/>"
		else
			dat += "<a href='?src=\ref[src];brig=timer_activate'>Activate</a><br/>"

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.get_paygrade(0) == ("Captain" || "Commodore"))
				dat += "<br/>"
				dat += "<a href='?src=\ref[src];brig=pardon'>Pardon</a>"
				dat += "<br/>"

	dat += "<br/>"
	if(current_report.incident.sentence_served)
		dat += "<a href='?src=\ref[src];brig=remove_report'>Remove Incident Report</a><br/>"
	dat += "<a href='?src=\ref[src];brig=return'>Return</a><br/>"
	dat += "<br/>"

	return dat

/obj/structure/machinery/brig_cell/proc/create_controls()
	var/dat = ""
	dat += " <b>Door [id] controls</b><br/>"

	for(var/obj/structure/machinery/door/poddoor/almayer/locked/P in targets)
		if(P.density)
			dat += "<br/><A href='?src=\ref[src];brig=open_blast'>Unlock Back</A>"
		else
			dat += "<br/><A href='?src=\ref[src];brig=close_blast'>Lock Back</A>"

	for(var/obj/structure/machinery/flasher/F in targets)
		if(F.last_flash && (F.last_flash + 150) > world.time)
			dat += "<br/><A href='?src=\ref[src];'>Flash Charging</A>"
		else
			dat += "<br/><A href='?src=\ref[src];brig=flash_activate'>Activate Flash</A>"

	return dat

/obj/structure/machinery/brig_cell/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	switch(href_list["brig"])
		if("incident")
			current_report = locate(href_list["incident_report"])
			current_menu = "incident_menu"

		if("return")
			current_menu = "main_menu"

		if("timer_activate")
			timer_start(usr)

		if("timer_stop")
			timer_end()

		if("timer_pause")
			timer_pause(usr)

		if("pardon")
			if(alert(usr, "Are you sure you want to pardon?", "Confirmation", "Yes", "No") == "No")
				return

			do_pardon(usr)

		if("remove_report")
			remove_report(usr)

		if("flash_activate")
			for(var/obj/structure/machinery/flasher/F in targets)
				F.flash()

		if("open_blast")
			for(var/obj/structure/machinery/door/poddoor/almayer/locked/P in targets)
				P.open()

		if("close_blast")
			for(var/obj/structure/machinery/door/poddoor/almayer/locked/P in targets)
				P.close()

	updateUsrDialog()
	update_icon()


/obj/structure/machinery/brig_cell/proc/set_picture(var/state)
	picture_state = state
	overlays.Cut()
	overlays += image('icons/obj/structures/machinery/status_display.dmi', icon_state=picture_state)

/obj/structure/machinery/brig_cell/proc/update_display(var/line1, var/line2)
	var/new_text = {"<div style="font-size:'5pt'; color:'#09f'; font:'Arial Black';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/structure/machinery/brig_cell/proc/texticon(var/tn, var/px = 0, var/py = 0)
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
