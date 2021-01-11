//This is a holder for things like the Vox and Nuke shuttle.
/datum/shuttle/multi_shuttle

	var/cloaked = 1
	var/at_origin = 1
	var/returned_home = 0
	var/move_time = MINUTES_4
	var/cooldown = 20
	var/last_move = 0	//the time at which we last moved

	var/announcer
	var/arrival_message
	var/departure_message

	var/area/interim
	var/area/last_departed
	var/list/destinations
	var/area/origin
	var/return_warning = 0

/datum/shuttle/multi_shuttle/New()
	..()
	if(origin) last_departed = origin

/datum/shuttle/multi_shuttle/move(var/area/origin, var/area/destination)
	..()
	last_move = world.time
	if (destination == src.origin)
		returned_home = 1

/datum/shuttle/multi_shuttle/proc/announce_departure()

	if(cloaked || isnull(departure_message))
		return

	marine_announcement(departure_message,(announcer ? announcer : "Central Command"))

/datum/shuttle/multi_shuttle/proc/announce_arrival()

	if(cloaked || isnull(arrival_message))
		return

	marine_announcement(arrival_message,(announcer ? announcer : "Central Command"))


/obj/structure/machinery/computer/shuttle_control/multi
	icon_state = "syndishuttle"

/obj/structure/machinery/computer/shuttle_control/multi/attack_hand(mob/user)

	if(..())
		return
	add_fingerprint(user)

	var/datum/shuttle/multi_shuttle/MS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(MS)) return

	var/dat
	dat = "<center>"


	if(MS.moving_status != SHUTTLE_IDLE)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		var/area/areacheck = get_area(src)
		dat += "Location: [areacheck.name]<br>"

	if((MS.last_move + MS.cooldown*10) > world.time)
		dat += "<font color='red'>Engines charging.</font><br>"
	else
		dat += "<font color='green'>Engines ready.</font><br>"

	dat += "<br><b><A href='?src=\ref[src];toggle_cloak=[1]'>Toggle cloaking field</A></b><br>"
	dat += "<b><A href='?src=\ref[src];move_multi=[1]'>Move ship</A></b><br>"
	dat += "<b><A href='?src=\ref[src];start=[1]'>Return to base</A></b></center>"

	show_browser(user, dat, "[shuttle_tag] Ship Control", "[shuttle_tag]shuttlecontrol", "size=300x600")

/obj/structure/machinery/computer/shuttle_control/multi/Topic(href, href_list)
	if(..())
		return

	usr.set_interaction(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/multi_shuttle/MS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(MS))
		to_chat(usr, SPAN_NOTICE(" [shuttle_tag] vessel is moving."))
		return

	if(href_list["start"])

		if(MS.at_origin)
			to_chat(usr, SPAN_DANGER("You are already at your home base."))
			return

		if(!MS.return_warning)
			to_chat(usr, SPAN_DANGER("Returning to your home base will end your mission. If you are sure, press the button again."))
			//TODO: Actually end the mission.
			MS.return_warning = 1
			return

		MS.long_jump(MS.last_departed,MS.origin,MS.interim,MS.move_time)
		MS.last_departed = MS.origin
		MS.at_origin = 1

	if(href_list["toggle_cloak"])

		MS.cloaked = !MS.cloaked
		to_chat(usr, SPAN_DANGER("Ship stealth systems have been [(MS.cloaked ? "activated. The station will not" : "deactivated. The station will")] be warned of our arrival."))

	if(href_list["move_multi"])
		if((MS.last_move + MS.cooldown*10) > world.time)
			to_chat(usr, SPAN_DANGER("The ship's drive is inoperable while the engines are charging."))
			return

		var/choice = tgui_input_list(usr, "Select a destination.", MS.destinations)
		if(!choice) return

		to_chat(usr, SPAN_NOTICE(" [shuttle_tag] main computer recieved message."))

		if(MS.at_origin)
			MS.announce_arrival()
			MS.last_departed = MS.origin
			MS.at_origin = 0


			MS.long_jump(MS.last_departed, MS.destinations[choice], MS.interim, MS.move_time)
			MS.last_departed = MS.destinations[choice]
			return

		else if(choice == MS.origin)

			MS.announce_departure()

		MS.short_jump(MS.last_departed, MS.destinations[choice])
		MS.last_departed = MS.destinations[choice]

	updateUsrDialog()
