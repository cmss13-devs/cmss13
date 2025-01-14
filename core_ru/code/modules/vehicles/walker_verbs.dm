/obj/vehicle/walker/proc/exit_walker()
	set name = "Eject"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return FALSE

	if(!istype(src, /obj/vehicle/walker))
		src = user_mob.interactee

	if(zoom)
		unzoom()

	if(user_mob.client)
		user_mob.client.mouse_pointer_icon = initial(user_mob.client.mouse_pointer_icon)

	user_mob.unset_interaction()
	user_mob.loc = get_turf(src)
	user_mob.reset_view(null)
	remove_verb(user_mob.client, verb_list)
	UnregisterSignal(user_mob, COMSIG_MOB_RESISTED)

	if(module_map[WALKER_HARDPOIN_LEFT])
		module_map[WALKER_HARDPOIN_LEFT].unregister_signals(user_mob)
	if(module_map[WALKER_HARDPOIN_RIGHT])
		module_map[WALKER_HARDPOIN_RIGHT].unregister_signals(user_mob)

	seats[VEHICLE_DRIVER] = null
	update_icon()
	return TRUE


/obj/vehicle/walker/proc/toggle_lights()
	set name = "Lights on/off"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return FALSE

	if(!istype(src, /obj/vehicle/walker))
		src = user_mob.interactee

	if(lights)
		lights = FALSE
		set_light(-lights_power)
	else
		lights = TRUE
		set_light(lights_power)

	playsound(src, 'sound/machines/click.ogg', 50)
	return TRUE


/obj/vehicle/walker/proc/eject_magazine()
	set name = "Eject Magazine"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return FALSE

	if(!istype(src, /obj/vehicle/walker))
		src = user_mob.interactee

	var/list/acceptible_modules = list()
	if(module_map[WALKER_HARDPOIN_LEFT]?.ammo)
		acceptible_modules += module_map[WALKER_HARDPOIN_LEFT]
	if(module_map[WALKER_HARDPOIN_RIGHT]?.ammo)
		acceptible_modules += module_map[WALKER_HARDPOIN_RIGHT]

	if(!length(acceptible_modules))
		to_chat(user_mob, "Not found magazines to eject")
		return FALSE

	var/obj/item/walker_gun/hardpoint = tgui_input_list(usr, "Select a hardpoint to eject magazine.", "Eject Magazine", acceptible_modules)
	if(!hardpoint || !hardpoint.ammo)
		return FALSE

	hardpoint.ammo.forceMove(get_turf(src))
	hardpoint.ammo = null
	to_chat(user_mob, SPAN_WARNING("WARNING! [hardpoint.name] ammo magazine deployed."))
	visible_message("[name]'s systems ejected used magazine.","")
	return TRUE


/obj/vehicle/walker/proc/get_stats()
	set name = "Status Display"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return FALSE

	if(!istype(src, /obj/vehicle/walker))
		src = user_mob.interactee

	tgui_interact(user_mob)
	return TRUE

/obj/vehicle/walker/proc/toggle_zoom()
	set name = "Zoom on/off"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return FALSE

	if(!istype(src, /obj/vehicle/walker))
		src = user_mob.interactee

	if(zoom)
		unzoom()
	else
		do_zoom()
	return TRUE
