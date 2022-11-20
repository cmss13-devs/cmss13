

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
	var/is_disabled = FALSE

	COOLDOWN_DECLARE(ob_firing_cooldown) //cooldown for shooting the gun
	var/fire_cooldown_time = 500 SECONDS

	COOLDOWN_DECLARE(ob_chambering_cooldown) //cooldown for chambering the gun
	var/chamber_cooldown_time = 250 SECONDS

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
		to_chat(user, "The tray cannot be unloaded after it has been chambered, fire the gun first.")
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
			to_chat(user, SPAN_WARNING("No warhead in the tray, cancelling chambering operation."))
		return

	if(tray.fuel_amt < 1)
		if(user)
			to_chat(user, SPAN_WARNING("No solid fuel in the tray, cancelling chambering operation."))
		return

	if(!COOLDOWN_FINISHED(src, ob_chambering_cooldown)) //fired at least once
		if(user)
			to_chat(user, SPAN_WARNING("[src]'s barrel is still too hot, let it cool down for [COOLDOWN_TIMELEFT(src, ob_chambering_cooldown)/10] more seconds."))
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

	COOLDOWN_START(src, ob_firing_cooldown, fire_cooldown_time)
	COOLDOWN_START(src, ob_chambering_cooldown, chamber_cooldown_time)

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
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE

		if(PC.loaded)
			if(!istype(PC.loaded, /obj/structure/ob_ammo))
				to_chat(user, SPAN_WARNING("There is no way you can put \the [PC.loaded] into \the [src]!"))
				return TRUE

			var/obj/structure/ob_ammo/OA = PC.loaded
			if(OA.is_solid_fuel)
				if(fuel_amt >= 6)
					to_chat(user, SPAN_WARNING("\The [src] can't accept more solid fuel."))
					return TRUE
				if(!warhead)
					to_chat(user, SPAN_WARNING("A warhead must be placed in \the [src] first."))
					return TRUE
				to_chat(user, SPAN_NOTICE("You load \the [OA] into \the [src]."))
				fuel_amt++
				qdel(OA)
			else
				if(warhead)
					to_chat(user, SPAN_WARNING("\The [src] already has \the [warhead] loaded."))
					return TRUE
				else
					to_chat(user, SPAN_NOTICE("You load \the [OA] into \the [src]."))
					warhead = OA
					OA.forceMove(src)

			playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
			PC.loaded = null
			update_icon()
			PC.update_icon()

		else
			if(fuel_amt)
				var/obj/structure/ob_ammo/ob_fuel/OF = new (src)
				fuel_amt--
				PC.grab_object(user, OF, "ob_fuel", 'sound/machines/hydraulics_2.ogg')
			else if(warhead)
				PC.grab_object(user, warhead, "ob_warhead", 'sound/machines/hydraulics_2.ogg')
				warhead = null
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
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE
		if(is_solid_fuel)
			PC.grab_object(user, src, "ob_fuel", 'sound/machines/hydraulics_2.ogg')
		else
			PC.grab_object(user, src, "ob_warhead", 'sound/machines/hydraulics_2.ogg')
		update_icon()
		return TRUE
	else
		. = ..()

/obj/structure/ob_ammo/get_examine_text(mob/user)
	. = ..()
	. += "Moving this will require some sort of lifter."

/obj/structure/ob_ammo/warhead
	name = "theoretical orbital ammo"
	var/warhead_kind

/obj/structure/ob_ammo/warhead/proc/warhead_impact(var/turf/target)
	// make damn sure everyone hears it
	playsound(target, 'sound/weapons/gun_orbital_travel.ogg', 100, 1, 75)

	var/cancellation_token = rand(0,32000)
	orbital_cannon_cancellation["[cancellation_token]"] = src
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];admincancelob=1;cancellation=[cancellation_token]'>CLICK TO CANCEL THIS OB</a>"))

	var/relative_dir
	for(var/mob/M in range(30, target))
		if(get_turf(M) == target)
			relative_dir = 0
		else
			relative_dir = get_dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky erupts into flames [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), 1, \
			SPAN_HIGHDANGER("You hear a very loud sound coming from above to the [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), 2 \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in range(25, target))
		if(get_turf(M) == target)
			relative_dir = 0
		else
			relative_dir = get_dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky roars louder [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), 1, \
			SPAN_HIGHDANGER("The sound becomes louder [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), 2 \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in range(15, target))
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
	var/datum/cause_data/cause_data = create_cause_data(initial(name), source_mob)
	cell_explosion(target, clear_power, clear_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //break shit around
	sleep(clear_delay)
	//ACTUALLY BLOW SHIT UP
	if(!target.density)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		sleep(double_explosion_delay)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		return

	for(var/turf/T in range(2, target))
		if(!T.density)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
			sleep(double_explosion_delay)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
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
	var/fire_color = null
	var/fire_type = "white"

/obj/structure/ob_ammo/warhead/incendiary/warhead_impact(turf/target)
	. = ..()
	if (!.)
		return
	if(fire_color)
		fire_type = "dynamic"

	new /obj/effect/overlay/temp/blinking_laser (target)
	sleep(10)
	var/datum/cause_data/cause_data = create_cause_data(initial(name), source_mob)
	cell_explosion(target, clear_power, clear_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //break shit around
	sleep(clear_delay)
	fire_spread(target, cause_data, distance, fire_level, burn_level, fire_color, fire_type, TURF_PROTECTION_OB)

/obj/structure/ob_ammo/warhead/cluster
	name = "\improper Cluster orbital warhead"
	warhead_kind = "cluster"
	icon_state = "ob_warhead_3"
	var/total_amount = 75 // how many times will the shell fire?
	var/instant_amount = 3 // how many explosions per time it fires?
	var/explosion_power = 350
	var/explosion_falloff = 150
	var/delay_between_clusters = 0.4 SECONDS // how long between each firing?

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
		sleep(delay_between_clusters)

/obj/structure/ob_ammo/warhead/cluster/proc/fire_in_a_hole(var/turf/loc)
	new /obj/effect/overlay/temp/blinking_laser (loc)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/cell_explosion, loc, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 1 SECONDS)

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

/obj/structure/machinery/computer/orbital_cannon_console/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_ALL

/obj/structure/machinery/computer/orbital_cannon_console/ex_act()
	return

/obj/structure/machinery/computer/orbital_cannon_console/bullet_act()
	return

// TGUI SHIT \\

/obj/structure/machinery/computer/orbital_cannon_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrbitalCannonConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/aa_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/orbital_cannon_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/orbital_cannon_console/ui_static_data(mob/user)
	var/list/data = list()

	data["hefuel"] = ob_type_fuel_requirements[1]
	data["incfuel"] = ob_type_fuel_requirements[2]
	data["clusterfuel"] = ob_type_fuel_requirements[3]

	data["linkedcannon"] = almayer_orbital_cannon
	data["linkedtray"] = almayer_orbital_cannon.tray

	return data

/obj/structure/machinery/computer/orbital_cannon_console/ui_data(mob/user)
	var/list/data = list()

	data["loadedtray"] = almayer_orbital_cannon.loaded_tray
	data["chamberedtray"] = almayer_orbital_cannon.chambered_tray

	var/warhead_name = null
	if(almayer_orbital_cannon.tray.warhead)
		warhead_name = almayer_orbital_cannon.tray.warhead.name

	data["warhead"] = warhead_name
	data["fuel"] = almayer_orbital_cannon.tray.fuel_amt

	data["worldtime"] = world.time
	data["nextchambertime"] = almayer_orbital_cannon.ob_chambering_cooldown
	data["chamber_cooldown"] = almayer_orbital_cannon.chamber_cooldown_time

	data["disabled"] = almayer_orbital_cannon.is_disabled

	return data

/obj/structure/machinery/computer/orbital_cannon_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("load_tray")
			almayer_orbital_cannon.load_tray(usr)
			. = TRUE

		if("unload_tray")
			almayer_orbital_cannon.unload_tray(usr)
			. = TRUE

		if("chamber_tray")
			almayer_orbital_cannon.chamber_payload(usr)
			. = TRUE

	add_fingerprint(usr)

/obj/structure/machinery/computer/orbital_cannon_console/attack_hand(mob/user)
	if(..())
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You have no idea how to use that console."))
		return TRUE

	tgui_interact(user)
