
/obj/structure/machinery/computer/station_alert
	name = "Station Alert Computer"
	desc = "Used to access the station's automated alert system."
	icon_state = "atmos"
	circuit = /obj/item/circuitboard/computer/stationalert
	var/alarms = list("Fire"=list(), "Atmosphere"=list(), "Power"=list())
	processing = TRUE

/obj/structure/machinery/computer/station_alert/attack_remote(mob/user)
	attack_hand(user)

/obj/structure/machinery/computer/station_alert/attack_hand(mob/user)
	add_fingerprint(user)
	if(inoperable())
		return
	tgui_interact(user)

/obj/structure/machinery/computer/station_alert/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StationAlertConsole", name)
		ui.open()

/obj/structure/machinery/computer/station_alert/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/station_alert/ui_data(mob/user)
	var/list/data = list()

	data["alarms"] = list()
	for(var/class in alarms)
		data["alarms"][class] = list()
		for(var/area in alarms[class])
			data["alarms"][class] += area
	return data

/obj/structure/machinery/computer/station_alert/proc/triggerAlarm(class, area/A, O, obj/source)
	if(source.z != z)
		return
	if(stat & (BROKEN))
		return

	var/list/L = alarms[class]
	for(var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(source in sources))
				sources += source
			return 1
	var/obj/structure/machinery/camera/C = null
	var/list/CL = null
	if(O && islist(O))
		CL = O
		if (length(CL) == 1)
			C = CL[1]
	else if(O && istype(O, /obj/structure/machinery/camera))
		C = O
	L[A.name] = list(A, (C ? C : O), list(source))
	return 1

/obj/structure/machinery/computer/station_alert/proc/cancelAlarm(class, area/A, obj/origin)
	if(stat & (BROKEN))
		return
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (length(srcs) == 0)
				cleared = 1
				L -= I
	return !cleared

/obj/structure/machinery/computer/station_alert/process()
	if(inoperable())
		icon_state = "atmos0"
		return
	var/active_alarms = 0
	for (var/cat in src.alarms)
		var/list/L = src.alarms[cat]
		if(length(L)) active_alarms = 1
	if(active_alarms)
		icon_state = "alert:2"
	else
		icon_state = "alert:0"
	..()
	return
