

//global vars
var/obj/structure/orbital_cannon/almayer_orbital_cannon
var/list/ob_type_fuel_requirements

/obj/structure/orbital_cannon
	name = "\improper Orbital Cannon"
	desc = "The USCM Orbital Cannon System. Used for shooting large targets on the planet that is orbited. It accelerates its payload with solid fuel for devastating results upon impact."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "OBC_unloaded"
	density = 1
	anchored = 1
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unacidable = TRUE
	var/obj/structure/orbital_tray/tray
	var/chambered_tray = FALSE
	var/loaded_tray = FALSE
	var/ob_cannon_busy = FALSE
	var/last_orbital_firing = 0 //stores the last time it was fired to check when we can fire again
	var/is_disabled = FALSE

/obj/structure/orbital_cannon/New()
	..()
	if(!almayer_orbital_cannon)
		almayer_orbital_cannon = src

	if(!ob_type_fuel_requirements)
		ob_type_fuel_requirements = list()
		var/list/L = list(4,5,6)
		var/amt
		for(var/i=1 to 3)
			amt = pick_n_take(L)
			ob_type_fuel_requirements += amt

	var/turf/T = locate(x+1,y+2,z)
	var/obj/structure/orbital_tray/O = new(T)
	tray = O
	tray.linked_ob = src



/obj/structure/orbital_cannon/ex_act()
	return

/obj/structure/orbital_cannon/bullet_act()
	return



/obj/structure/orbital_cannon/update_icon()
	if(chambered_tray)
		icon_state = "OBC_chambered"
	else
		if(loaded_tray)
			icon_state = "OBC_loaded"
		else
			icon_state = "OBC_unloaded"

/obj/structure/orbital_cannon/proc/enable()
	is_disabled = FALSE

/obj/structure/orbital_cannon/proc/load_tray(mob/user)
	set waitfor = 0

	if(!tray)
		return

	if(ob_cannon_busy)
		return

	if(!tray.warhead)
		if(user)
			to_chat(user, "no warhead in the tray, loading operation cancelled.")
		return

	if(tray.fuel_amt < 1)
		to_chat(user, "no solid fuel in the tray, loading operation cancelled.")
		return

	if(loaded_tray)
		to_chat(user, "Tray is already loaded.")
		return

	tray.forceMove(src)

	flick("OBC_loading",src)

	playsound(loc, 'sound/mecha/powerloader_buckle.ogg', 40)

	ob_cannon_busy = TRUE

	sleep(10)

	ob_cannon_busy = FALSE

	loaded_tray = TRUE

	update_icon()




/obj/structure/orbital_cannon/proc/unload_tray(mob/user)
	set waitfor = 0

	if(ob_cannon_busy)
		return

	if(chambered_tray)
		to_chat(user, "Tray cannot be unloaded after its chambered, fire the gun first.")
		return

	if(!loaded_tray)
		to_chat(user, "No loaded tray to unload.")
		return

	flick("OBC_unloading",src)

	playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 40)

	ob_cannon_busy = TRUE

	sleep(10)

	ob_cannon_busy = FALSE

	var/turf/T = locate(x+1,y+2,z)

	tray.forceMove(T)
	loaded_tray = FALSE

	update_icon()





/obj/structure/orbital_cannon/proc/chamber_payload(mob/user)
	set waitfor = 0

	if(ob_cannon_busy)
		return

	if(chambered_tray)
		return
	if(!tray)
		return
	if(!loaded_tray)
		if(user)
			to_chat(user, SPAN_WARNING("You need to load the tray before firing the payload."))
		return
	if(!tray.warhead)
		if(user)
			to_chat(user, SPAN_WARNING("no warhead in the tray, cancelling chambering operation."))
		return

	if(tray.fuel_amt < 1)
		if(user)
			to_chat(user, SPAN_WARNING("no solid fuel in the tray, cancelling chambering operation."))
		return

	if(last_orbital_firing) //fired at least once
		var/cooldown_left = (last_orbital_firing + 2500) - world.time
		if(cooldown_left > 0)
			if(user)
				to_chat(user, SPAN_WARNING("[src]'s barrel is still too hot, let it cool down for [round(cooldown_left/10)] more seconds."))
			return

	flick("OBC_chambering",src)

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)

	ob_cannon_busy = TRUE

	sleep(6)

	ob_cannon_busy = FALSE

	chambered_tray = TRUE

	update_icon()


/var/global/list/orbital_cannon_cancellation = new

/obj/structure/orbital_cannon/proc/fire_ob_cannon(turf/T, mob/user)
	set waitfor = 0

	if(!chambered_tray || !loaded_tray || !tray || !tray.warhead || ob_cannon_busy)
		return

	flick("OBC_firing", src)

	ob_cannon_busy = TRUE

	last_orbital_firing = world.time

	playsound(loc, 'sound/weapons/vehicles/smokelauncher_fire.ogg', 70, 1)
	playsound(loc, 'sound/weapons/pred_plasma_shot.ogg', 70, 1)

	var/inaccurate_fuel = 0

	switch(tray.warhead.warhead_kind)
		if("explosive")
			inaccurate_fuel = abs(ob_type_fuel_requirements[1] - tray.fuel_amt)
		if("incendiary")
			inaccurate_fuel = abs(ob_type_fuel_requirements[2] - tray.fuel_amt)
		if("cluster")
			inaccurate_fuel = abs(ob_type_fuel_requirements[3] - tray.fuel_amt)

	var/turf/target = locate(T.x + inaccurate_fuel * round(rand(-3,3), 1), T.y + inaccurate_fuel * round(rand(-3,3), 1), T.z)
	if(user)
		tray.warhead.source_mob = user

	tray.warhead.warhead_impact(target)

	sleep(OB_CRASHING_DOWN)

	ob_cannon_busy = FALSE

	chambered_tray = FALSE
	tray.fuel_amt = 0
	QDEL_NULL(tray.warhead)
	tray.update_icon()

	update_icon()




/obj/structure/orbital_tray
	name = "loading tray"
	desc = "The orbital cannon's loading tray."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "cannon_tray"
	density = 1
	anchored = 1
	throwpass = TRUE
	climbable = TRUE
	layer = LADDER_LAYER + 0.01
	bound_width = 64
	bound_height = 32
	unacidable = TRUE
	pixel_y = -9
	pixel_x = -6
	var/obj/structure/ob_ammo/warhead/warhead
	var/obj/structure/orbital_cannon/linked_ob
	var/fuel_amt = 0


/obj/structure/orbital_tray/Destroy()
	QDEL_NULL(warhead)
	if(linked_ob)
		linked_ob.tray = null
		linked_ob = null
	. = ..()


/obj/structure/orbital_tray/ex_act()
	return

/obj/structure/orbital_tray/bullet_act()
	return


/obj/structure/orbital_tray/update_icon()
	overlays.Cut()
	icon_state = "cannon_tray"
	if(warhead)
		overlays += image("cannon_tray_[warhead.warhead_kind]")
	if(fuel_amt)
		overlays += image("cannon_tray_[fuel_amt]")


/obj/structure/orbital_tray/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(PC.linked_powerloader)
			if(PC.loaded)
				if(istype(PC.loaded, /obj/structure/ob_ammo))
					var/obj/structure/ob_ammo/OA = PC.loaded
					if(OA.is_solid_fuel)
						if(fuel_amt >= 6)
							to_chat(user, SPAN_WARNING("[src] can't accept more solid fuel."))
						else if(!warhead)
							to_chat(user, SPAN_WARNING("A warhead must be placed in [src] first."))
						else
							to_chat(user, SPAN_NOTICE("You load [OA] into [src]."))
							playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
							fuel_amt++
							PC.loaded = null
							PC.update_icon()
							qdel(OA)
							update_icon()
					else
						if(warhead)
							to_chat(user, SPAN_WARNING("[src] already has a warhead."))
						else
							to_chat(user, SPAN_NOTICE("You load [OA] into [src]."))
							playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
							warhead = OA
							OA.forceMove(src)
							PC.loaded = null
							PC.update_icon()
							update_icon()

			else

				if(fuel_amt)
					var/obj/structure/ob_ammo/ob_fuel/OF = new (PC.linked_powerloader)
					PC.loaded = OF
					fuel_amt--
				else if(warhead)
					warhead.forceMove(PC.linked_powerloader)
					PC.loaded = warhead
					warhead = null
				else
					return TRUE
				PC.update_icon()
				playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
				to_chat(user, SPAN_NOTICE("You grab [PC.loaded] with [PC]."))
				update_icon()
		return TRUE
	else
		. = ..()




/obj/structure/ob_ammo
	name = "theoretical ob ammo"
	density = 1
	anchored = 1
	throwpass = TRUE
	climbable = TRUE
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	var/is_solid_fuel = 0
	var/source_mob

/obj/structure/ob_ammo/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(PC.linked_powerloader)
			if(!PC.loaded)
				forceMove(PC.linked_powerloader)
				PC.loaded = src
				playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
				PC.update_icon()
				to_chat(user, SPAN_NOTICE("You grab [PC.loaded] with [PC]."))
				update_icon()
		return TRUE
	else
		. = ..()

/obj/structure/ob_ammo/examine(mob/user)
	..()
	to_chat(user, "Moving this will require some sort of lifter.")


/obj/structure/ob_ammo/warhead
	name = "theoretical orbital ammo"
	var/warhead_kind


/obj/structure/ob_ammo/warhead/proc/warhead_impact(var/turf/target)
	// make damn sure everyone hears it
	playsound(target, 'sound/weapons/gun_orbital_travel.ogg', 100, 1, 75)

	var/cancellation_token = rand(0,32000)
	orbital_cannon_cancellation["[cancellation_token]"] = src
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;admincancelob=1;cancellation=[cancellation_token]'>CLICK TO CANCEL THIS OB</a>"))

	var/relative_dir
	for(var/mob/M in range(30, target))
		relative_dir = get_dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky erupts into flames to the [SPAN_UNDERLINE(dir2text(relative_dir))]!"), 1, \
			SPAN_HIGHDANGER("You hear a very loud sound coming from above to the [SPAN_UNDERLINE(dir2text(relative_dir))]!"), 2 \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in range(25, target))
		relative_dir = get_dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky roars louder to the [SPAN_UNDERLINE(dir2text(relative_dir))]!"), 1, \
			SPAN_HIGHDANGER("The sound becomes louder to the [SPAN_UNDERLINE(dir2text(relative_dir))]!"), 2 \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in range(15, target))
		relative_dir = get_dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("OH GOD THE SKY WILL EXPLODE!!!"), 1, \
			SPAN_HIGHDANGER("YOU SHOULDN'T BE HERE!"), 2 \
		)
	sleep(OB_TRAVEL_TIMING/3)

	if(orbital_cannon_cancellation["[cancellation_token]"]) // the cancelling notification is in the topic
		target.ceiling_debris_check(5)
		orbital_cannon_cancellation["[cancellation_token]"] = null
		return TRUE
	return FALSE


/obj/structure/ob_ammo/warhead/explosive
	name = "\improper HE orbital warhead"
	warhead_kind = "explosive"
	icon_state = "ob_warhead_1"
	var/clear_power = 1200
	var/clear_falloff = 400
	var/standard_power = 600
	var/standard_falloff = 30
	var/clear_delay = 3
	var/double_explosion_delay = 6

/obj/structure/ob_ammo/warhead/explosive/warhead_impact(turf/target)
	. = ..()
	if (!.)
		return

	new /obj/effect/overlay/temp/blinking_laser (target)
	sleep(10)
	cell_explosion(target, clear_power, clear_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob) //break shit around
	sleep(clear_delay)
	//ACTUALLY BLOW SHIT UP
	if(!target.density)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob)
		sleep(double_explosion_delay)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob)
		return

	for(var/turf/T in range(2, target))
		if(!T.density)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob)
			sleep(double_explosion_delay)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob)
			return

/obj/structure/ob_ammo/warhead/incendiary
	name = "\improper Incendiary orbital warhead"
	warhead_kind = "incendiary"
	icon_state = "ob_warhead_2"
	var/clear_power = 1200
	var/clear_falloff = 400
	var/clear_delay = 3
	var/distance = 18
	var/fire_level = 70
	var/burn_level = 80
	var/fire_color = "white"

/obj/structure/ob_ammo/warhead/incendiary/warhead_impact(turf/target)
	. = ..()
	if (!.)
		return

	new /obj/effect/overlay/temp/blinking_laser (target)
	sleep(10)
	cell_explosion(target, clear_power, clear_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob) //break shit around
	sleep(clear_delay)
	fire_spread(target, initial(name), source_mob, distance, fire_level, burn_level, fire_color)


/obj/structure/ob_ammo/warhead/cluster
	name = "\improper Cluster orbital warhead"
	warhead_kind = "cluster"
	icon_state = "ob_warhead_3"
	var/total_amount = 60
	var/instant_amount = 3
	var/explosion_power = 300
	var/explosion_falloff = 150

/obj/structure/ob_ammo/warhead/cluster/warhead_impact(turf/target)
	. = ..()
	if (!.)
		return

	start_cluster(target)

/obj/structure/ob_ammo/warhead/cluster/proc/start_cluster(turf/target)
	set waitfor = 0

	var/range_num = 12
	var/list/turf_list = list()

	for(var/turf/T in range(range_num, target))
		if(protected_by_pylon(TURF_PROTECTION_OB, T))
			continue

		turf_list += T

	for(var/i = 1 to total_amount)
		for(var/k = 1 to instant_amount)
			var/turf/U = pick(turf_list)
			fire_in_a_hole(U)
		sleep(5)

/obj/structure/ob_ammo/warhead/cluster/proc/fire_in_a_hole(var/turf/loc)
	new /obj/effect/overlay/temp/blinking_laser (loc)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/cell_explosion, loc, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob), 1 SECONDS)


/obj/structure/ob_ammo/ob_fuel
	name = "solid fuel"
	icon_state = "ob_fuel"
	is_solid_fuel = 1

/obj/structure/ob_ammo/ob_fuel/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)





/obj/structure/machinery/computer/orbital_cannon_console
	name = "\improper Orbital Cannon Console"
	desc = "The console controlling the orbital cannon loading systems."
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT
	var/orbital_window_page = 0

/obj/structure/machinery/computer/orbital_cannon_console/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_ALL

/obj/structure/machinery/computer/orbital_cannon_console/ex_act()
	return

/obj/structure/machinery/computer/orbital_cannon_console/bullet_act()
	return


/obj/structure/machinery/computer/orbital_cannon_console/attack_hand(mob/user)
	if(..())
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You have no idea how to use that console."))
		return 1

	user.set_interaction(src)

	var/dat
	if(!almayer_orbital_cannon)
		dat += "No Orbital Cannon System Detected!<BR>"
	else if(!almayer_orbital_cannon.tray)
		dat += "Orbital Cannon System Tray is missing!<BR>"
	else
		if(orbital_window_page == 1)
			dat += "<font size=3>Warhead Fuel Requirements:</font><BR>"
			dat += "- HE Orbital Warhead: <b>[ob_type_fuel_requirements[1]] Solid Fuel blocks.</b><BR>"
			dat += "- Incendiary Orbital Warhead: <b>[ob_type_fuel_requirements[2]] Solid Fuel blocks.</b><BR>"
			dat += "- Cluster Orbital Warhead: <b>[ob_type_fuel_requirements[3]] Solid Fuel blocks.</b><BR>"

			dat += "<BR><BR><A href='?src=\ref[src];back=1'><font size=3>Back</font></A><BR>"
		else
			var/tray_status = "unloaded"
			if(almayer_orbital_cannon.chambered_tray)
				tray_status = "chambered"
			else if(almayer_orbital_cannon.loaded_tray)
				tray_status = "loaded"
			dat += "Orbital Cannon Tray is <b>[tray_status]</b><BR>"
			if(almayer_orbital_cannon.tray.warhead)
				dat += "[almayer_orbital_cannon.tray.warhead.name] Detected<BR>"
			else
				dat += "No Warhead Detected<BR>"
			dat += "[almayer_orbital_cannon.tray.fuel_amt] Solid Fuel Block\s Detected<BR><HR>"

			dat += "<A href='?src=\ref[src];load_tray=1'><font size=3>Load Tray</font></A><BR>"
			dat += "<A href='?src=\ref[src];unload_tray=1'><font size=3>Unload Tray</font></A><BR>"
			dat += "<A href='?src=\ref[src];chamber_tray=1'><font size=3>Chamber Tray Payload</font></A><BR>"
			dat += "<BR><A href='?src=\ref[src];check_req=1'><font size=3>Check Fuel Requirements</font></A><BR>"

		dat += "<HR><BR><A href='?src=\ref[src];close=1'><font size=3>Close</font></A><BR>"

	show_browser(user, dat, "Orbital Cannon System Control Console", "orbital_console", "size=500x350")


/obj/structure/machinery/computer/orbital_cannon_console/Topic(href, href_list)
	if(..())
		return

	if(href_list["load_tray"])
		almayer_orbital_cannon.load_tray(usr)

	else if(href_list["unload_tray"])
		almayer_orbital_cannon.unload_tray(usr)

	else if(href_list["chamber_tray"])
		almayer_orbital_cannon.chamber_payload(usr)

	else if(href_list["check_req"])
		orbital_window_page = 1

	else if(href_list["back"])
		orbital_window_page = 0

	else if(href_list["close"])
		close_browser(usr, "orbital_console")
		usr.unset_interaction()

	add_fingerprint(usr)
//	updateUsrDialog()
	attack_hand(usr)
