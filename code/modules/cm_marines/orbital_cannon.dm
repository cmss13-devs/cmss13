

//global vars
GLOBAL_DATUM(almayer_orbital_cannon, /obj/structure/orbital_cannon)
GLOBAL_LIST(ob_type_fuel_requirements)

/obj/structure/orbital_cannon
	name = "\improper Orbital Cannon"
	desc = "The USCM Orbital Cannon System. Used for shooting large targets on the planet that is orbited. It accelerates its payload with solid fuel for devastating results upon impact."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "OBC_unloaded"
	density = TRUE
	anchored = TRUE
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
	if(!GLOB.almayer_orbital_cannon)
		GLOB.almayer_orbital_cannon = src

	if(!GLOB.ob_type_fuel_requirements)
		GLOB.ob_type_fuel_requirements = list()
		var/list/L = list(4,5,6)
		var/amt
		for(var/i=1 to 3)
			amt = pick_n_take(L)
			GLOB.ob_type_fuel_requirements += amt

	var/turf/T = locate(x+1,y+2,z)
	var/obj/structure/orbital_tray/O = new(T)
	tray = O
	tray.linked_ob = src

/obj/structure/orbital_cannon/Destroy()
	QDEL_NULL(tray)
	if(GLOB.almayer_orbital_cannon == src)
		GLOB.almayer_orbital_cannon = null
		message_admins("Reference to GLOB.almayer_orbital_cannon is lost!")
	return ..()

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
			to_chat(user, SPAN_WARNING("No warhead in the tray, loading operation cancelled."))
		return

	if(tray.fuel_amt < 1)
		to_chat(user, SPAN_WARNING("No solid fuel in the tray, loading operation cancelled."))
		return

	if(loaded_tray)
		to_chat(user, SPAN_WARNING("Tray is already loaded."))
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
	var/misfuel = get_misfuel_amount()
	var/message = "[key_name(user)] chambered the Orbital Bombardment cannon."
	var/ares_message = "Shell chambered."
	if(misfuel)
		message += " It is misfueled by [misfuel] units!"
		ares_message += " Fuel imbalance detected!"
	message_admins(message, x, y, z)
	log_ares_bombardment(user, lowertext(tray.warhead.name), ares_message)

	update_icon()

GLOBAL_LIST_EMPTY(orbital_cannon_cancellation)

/obj/structure/orbital_cannon/proc/get_misfuel_amount()
	switch(tray.warhead.warhead_kind)
		if("explosive")
			return abs(GLOB.ob_type_fuel_requirements[1] - tray.fuel_amt)
		if("incendiary")
			return abs(GLOB.ob_type_fuel_requirements[2] - tray.fuel_amt)
		if("cluster")
			return abs(GLOB.ob_type_fuel_requirements[3] - tray.fuel_amt)
	return 0

/obj/structure/orbital_cannon/proc/fire_ob_cannon(turf/T, mob/user, squad_behalf, warhead_mode)
	set waitfor = 0

	if(!chambered_tray || !loaded_tray || !tray || !tray.warhead || ob_cannon_busy)
		return

	flick("OBC_firing", src)

	ob_cannon_busy = TRUE

	fire_cooldown_time = (100 + 400 * GLOB.ship_alt) SECONDS

	COOLDOWN_START(src, ob_firing_cooldown, fire_cooldown_time)
	COOLDOWN_START(src, ob_chambering_cooldown, chamber_cooldown_time)

	playsound(loc, 'sound/weapons/vehicles/smokelauncher_fire.ogg', 70, 1)
	playsound(loc, 'sound/weapons/pred_plasma_shot.ogg', 70, 1)

	var/inaccurate_fuel = get_misfuel_amount()
	var/area/area = get_area(T)
	var/off_x = (inaccurate_fuel + 1) * round(rand(-3,3), 1)
	var/off_y = (inaccurate_fuel + 1) * round(rand(-3,3), 1)
	var/target_x = clamp(T.x + off_x, 1, world.maxx)
	var/target_y = clamp(T.y + off_y, 1, world.maxy)
	var/turf/target = locate(target_x, target_y, T.z)
	var/area/target_area = get_area(target)

	message_admins(FONT_SIZE_HUGE("ALERT: [key_name(user)] fired an orbital bombardment in '[target_area]' for squad '[squad_behalf]' landing at ([target.x],[target.y],[target.z])"), target.x, target.y, target.z)
	var/message = "Orbital bombardment original target was ([T.x],[T.y],[T.z]) - offset by [abs(off_x)+abs(off_y)]"
	if(inaccurate_fuel)
		message += " - It was misfueled by [inaccurate_fuel] units!"
	message_admins(message, T.x, T.y, T.z)
	log_attack("[key_name(user)] fired an orbital bombardment in [area.name] for squad '[squad_behalf]'")

	if(user)
		tray.warhead.source_mob = user

	var/obj/structure/ob_ammo/warhead/warhead = tray.warhead
	tray.warhead = null
	if(warhead)
		warhead.moveToNullspace()
		warhead.warhead_impact(target, warhead_mode)

	sleep(OB_CRASHING_DOWN)

	ob_cannon_busy = FALSE
	chambered_tray = FALSE
	tray.fuel_amt = 0
	tray.update_icon()

	update_icon()

/obj/structure/orbital_tray
	name = "loading tray"
	desc = "The orbital cannon's loading tray."
	icon = 'icons/obj/structures/props/almayer/almayer_props64.dmi'
	icon_state = "cannon_tray"
	density = TRUE
	anchored = TRUE
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
			if(!OA.can_be_used())
				to_chat(user, SPAN_WARNING("\The [src] can't be accepted."))
				return

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
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	climbable = TRUE
	unacidable = TRUE // issue: being used for defences, solution: abomb
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
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


/obj/structure/ob_ammo/proc/can_be_used()
	return TRUE

/obj/structure/ob_ammo/warhead
	name = "theoretical orbital ammo"
	var/warhead_kind
	var/shake_frequency
	var/max_shake_factor
	var/max_knockdown_time

	var/armed = FALSE
	var/armed_target_z = 0

	// Note that the warhead should be cleared of location by the firing proc,
	// then auto-delete at the end of the warhead_impact implementation

/obj/structure/ob_ammo/warhead/attackby(obj/item/held_object, mob/user)
	if(armed)
		if(HAS_TRAIT(held_object, TRAIT_TOOL_MULTITOOL))
			var/skill_factor = 60 - user.skills.get_skill_level(SKILL_ENGINEER) * 10
			if(do_after(user, skill_factor, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
				if(prob(skill_factor))
					to_chat(user, SPAN_NOTICE("You seems to done fatal mistake to \the [src]. There nowhere to run now."))
					spawn(15 SECONDS)
						armed = TRUE
						warhead_impact(get_turf(src))
				else
					armed = FALSE
					to_chat(user, SPAN_NOTICE("You have successfully disarmed \the [src]."))
			else if (prob(5))
				armed = TRUE
				warhead_impact(get_turf(src))

	. = ..()

	if(armed && prob(5))
		warhead_impact(get_turf(src))

/obj/structure/ob_ammo/warhead/Move()
	. = ..()
	if(!armed)
		return

	if(armed_target_z == z)
		warhead_impact(get_turf(src))

	if(prob(5))
		warhead_impact(get_turf(src))

/obj/structure/ob_ammo/warhead/can_be_used()
	return !armed

/obj/structure/ob_ammo/warhead/proc/warhead_impact(turf/target, warhead_mode)
	if(armed)
		return TRUE
	// make damn sure everyone hears it
	playsound(target, 'sound/weapons/gun_orbital_travel.ogg', 100, 1, 75)

	var/cancellation_token = rand(0,32000)
	GLOB.orbital_cannon_cancellation["[cancellation_token]"] = src
	message_admins(FONT_SIZE_XL("<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];admincancelob=1;cancellation=[cancellation_token]'>CLICK TO CANCEL THIS OB</a>"))

	var/relative_dir
	for(var/mob/M in urange(30, target))
		if(get_turf(M) == target)
			relative_dir = 0
		else
			relative_dir = Get_Compass_Dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky erupts into flames [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), SHOW_MESSAGE_VISIBLE, \
			SPAN_HIGHDANGER("You hear a very loud sound coming from above to the [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), SHOW_MESSAGE_AUDIBLE \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in urange(25, target))
		if(get_turf(M) == target)
			relative_dir = 0
		else
			relative_dir = Get_Compass_Dir(M, target)
		M.show_message( \
			SPAN_HIGHDANGER("The sky roars louder [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), SHOW_MESSAGE_VISIBLE, \
			SPAN_HIGHDANGER("The sound becomes louder [SPAN_UNDERLINE(relative_dir ? ("to the " + dir2text(relative_dir)) : "right above you")]!"), SHOW_MESSAGE_AUDIBLE \
		)
	sleep(OB_TRAVEL_TIMING/3)

	for(var/mob/M in urange(15, target))
		M.show_message( \
			SPAN_HIGHDANGER("OH GOD THE SKY WILL EXPLODE!!!"), SHOW_MESSAGE_VISIBLE, \
			SPAN_HIGHDANGER("YOU SHOULDN'T BE HERE!"), SHOW_MESSAGE_AUDIBLE \
		)
	sleep(OB_TRAVEL_TIMING/3)

	if(GLOB.orbital_cannon_cancellation["[cancellation_token]"]) // the cancelling notification is in the topic
		target.ceiling_debris_check(5)
		GLOB.orbital_cannon_cancellation["[cancellation_token]"] = null
		if(warhead_mode == "admin")
			return TRUE

		var/turf/roof = get_highest_turf(target)
		var/initial_target = target.z
		target = roof.air_strike(20, target, warhead_mode == "proximity" ? 2 : 1)
		if(warhead_mode == "safe" && target.z != initial_target && !istype(src, /obj/structure/ob_ammo/warhead/cluster))
			forceMove(target)
			armed = TRUE
			armed_target_z = initial_target
			return FALSE
		return TRUE
	return FALSE

/// proc designed for handling ob camera shakes, takes the target location as input and calculates camera shake based off user location.
/obj/structure/ob_ammo/warhead/proc/handle_ob_shake(turf/epicenter)

	var/radius_size = 30

	for(var/mob/living/user in urange(radius_size, epicenter))

		var/distance = get_accurate_dist(get_turf(user), epicenter)
		var/distance_percent = ((radius_size - distance) / radius_size)
		var/total_shake_factor = abs(max_shake_factor * distance_percent)

		// it's of type cluster.
		if(!max_knockdown_time)
			shake_camera(user, 0.5, total_shake_factor, shake_frequency)
			continue

		shake_camera(user, 3, total_shake_factor, shake_frequency)
		user.KnockDown(rand(max_knockdown_time * distance_percent, (max_knockdown_time * distance_percent + 1)))

		if(HAS_TRAIT(user, TRAIT_FLOORED))
			continue
		to_chat(user, SPAN_WARNING("You are thrown off balance and fall to the ground!"))

/obj/structure/ob_ammo/warhead/explosive
	name = "\improper HE orbital warhead"
	warhead_kind = "explosive"
	icon_state = "ob_warhead_1"
	shake_frequency = 3
	max_shake_factor = 15

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

	// Explosion if turf is not a wall.
	if(!target.density)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		handle_ob_shake(target)
		sleep(double_explosion_delay)
		cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		qdel(src)
		return

	// Checks turf around the target
	for(var/turf/T in range(2, target))
		if(!T.density)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
			handle_ob_shake(target)
			sleep(double_explosion_delay)
			cell_explosion(target, standard_power, standard_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
			qdel(src)
			return

	qdel(src)

/obj/structure/ob_ammo/warhead/incendiary
	name = "\improper Incendiary orbital warhead"
	warhead_kind = "incendiary"
	icon_state = "ob_warhead_2"
	shake_frequency = 1
	max_shake_factor = 8
	max_knockdown_time = 3
	var/clear_power = 1200
	var/clear_falloff = 400
	var/clear_delay = 3
	var/distance = 18
	var/fire_level = 70
	var/burn_level = 80
	var/fire_color = LIGHT_COLOR_CYAN
	var/fire_type = "white"

/obj/structure/ob_ammo/warhead/incendiary/warhead_impact(turf/target)
	. = ..()
	if (!.)
		return

	new /obj/effect/overlay/temp/blinking_laser (target)
	sleep(10)
	var/datum/cause_data/cause_data = create_cause_data(initial(name), source_mob)
	cell_explosion(target, clear_power, clear_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //break shit around
	handle_ob_shake(target)

	sleep(clear_delay)
	fire_spread(target, cause_data, distance, fire_level, burn_level, fire_color, fire_type, TURF_PROTECTION_OB)
	qdel(src)

/obj/structure/ob_ammo/warhead/cluster
	name = "\improper Cluster orbital warhead"
	warhead_kind = "cluster"
	icon_state = "ob_warhead_3"
	shake_frequency = 2
	max_shake_factor = 1

	var/total_amount = 75 // how many times will the shell fire?
	var/instant_amount = 3 // how many explosions per time it fires?
	var/explosion_power = 350
	var/explosion_falloff = 150
	var/delay_between_clusters = 0.4 SECONDS // how long between each firing?

/obj/structure/ob_ammo/warhead/cluster/warhead_impact(turf/target, warhead_mode)
	. = ..()
	if (!.)
		return

	start_cluster(target, warhead_mode)

/obj/structure/ob_ammo/warhead/cluster/proc/start_cluster(turf/target, warhead_mode)
	set waitfor = 0

	var/range_num = 12
	var/list/turf_list = RANGE_TURFS(range_num, target)
	var/datum/cause_data/cause_data = create_cause_data(initial(name), source_mob)

	for(var/i = 1 to total_amount)
		for(var/k = 1 to instant_amount)
			var/turf/selected_turf = pick(turf_list)
			var/turf/roof = get_highest_turf(selected_turf)
			selected_turf = roof.air_strike(20, selected_turf, warhead_mode == "proximity" ? 2 : 1)
			if(warhead_mode == "safe" && selected_turf.z != target.z)
				fire_in_a_hole(selected_turf, cause_data, 5)
				continue
			fire_in_a_hole(selected_turf, cause_data)

		sleep(delay_between_clusters)
	QDEL_IN(src, 5 SECONDS) // Leave time for last handle_ob_shake below

/obj/structure/ob_ammo/warhead/cluster/proc/fire_in_a_hole(turf/loc, datum/cause_data/cause_data, devide = 1)
	new /obj/effect/overlay/temp/blinking_laser (loc)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), loc, explosion_power/devide, explosion_falloff/devide, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(handle_ob_shake), loc), 1 SECONDS)

/obj/structure/ob_ammo/ob_fuel
	name = "solid fuel"
	icon_state = "ob_fuel"
	is_solid_fuel = 1

/obj/structure/ob_ammo/ob_fuel/Initialize()
	. = ..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)

/obj/structure/machinery/computer/orbital_cannon_console
	name = "\improper Orbital Cannon Console"
	desc = "The console controlling the orbital cannon loading systems."
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT

	unacidable = TRUE
	unslashable = TRUE

/obj/structure/machinery/computer/orbital_cannon_console/initialize_pass_flags(datum/pass_flags_container/PF)
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

/obj/structure/machinery/computer/orbital_cannon_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/orbital_cannon_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/orbital_cannon_console/ui_static_data(mob/user)
	var/list/data = list()

	data["hefuel"] = GLOB.ob_type_fuel_requirements[1]
	data["incfuel"] = GLOB.ob_type_fuel_requirements[2]
	data["clusterfuel"] = GLOB.ob_type_fuel_requirements[3]

	data["linkedcannon"] = GLOB.almayer_orbital_cannon
	data["linkedtray"] = GLOB.almayer_orbital_cannon.tray

	return data

/obj/structure/machinery/computer/orbital_cannon_console/ui_data(mob/user)
	var/list/data = list()

	data["loadedtray"] = GLOB.almayer_orbital_cannon.loaded_tray
	data["chamberedtray"] = GLOB.almayer_orbital_cannon.chambered_tray

	var/warhead_name = null
	if(GLOB.almayer_orbital_cannon.tray.warhead)
		warhead_name = GLOB.almayer_orbital_cannon.tray.warhead.name

	data["warhead"] = warhead_name
	data["fuel"] = GLOB.almayer_orbital_cannon.tray.fuel_amt

	data["worldtime"] = world.time
	data["nextchambertime"] = GLOB.almayer_orbital_cannon.ob_chambering_cooldown
	data["chamber_cooldown"] = GLOB.almayer_orbital_cannon.chamber_cooldown_time

	data["disabled"] = GLOB.almayer_orbital_cannon.is_disabled

	return data

/obj/structure/machinery/computer/orbital_cannon_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("load_tray")
			GLOB.almayer_orbital_cannon.load_tray(usr)
			. = TRUE

		if("unload_tray")
			GLOB.almayer_orbital_cannon.unload_tray(usr)
			. = TRUE

		if("chamber_tray")
			GLOB.almayer_orbital_cannon.chamber_payload(usr)
			. = TRUE

	add_fingerprint(usr)

/obj/structure/machinery/computer/orbital_cannon_console/attack_hand(mob/user)
	if(..())
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use that console."))
		return TRUE

	tgui_interact(user)
