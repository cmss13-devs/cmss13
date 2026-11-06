/obj/structure/machinery/fuelpump
	name = "\improper Fuel Pump"
	layer = ABOVE_MOB_LAYER
	desc = "It is a machine that pumps fuel around the ship."
	icon = 'icons/obj/structures/machinery/fuelpump.dmi'
	icon_state = "fuelpump_off"
	bound_width = 128
	pixel_x = -64
	bound_x = -64
	health = 2500
	density = TRUE
	anchored = TRUE
	wrenchable = FALSE
	explo_proof = TRUE
	unslashable = FALSE
	unacidable = FALSE

/obj/structure/machinery/fuelpump/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_FUEL_PUMP_UPDATE, PROC_REF(on_pump_update))
	var/area/my_area = get_area(src)
	if(my_area)
		SShijack.area_machinery_lookup[my_area] = src

/obj/structure/machinery/fuelpump/Destroy(force)
	for(var/key,machine in SShijack.area_machinery_lookup)
		if(machine == src)
			SShijack.area_machinery_lookup -= key
	return ..()

/obj/structure/machinery/fuelpump/ex_act(severity)
	return

/obj/structure/machinery/fuelpump/deconstruct(disassembled)
	return

/obj/structure/machinery/fuelpump/inoperable(additional_flags = 0)
	// Ignore power
	return (stat & (BROKEN|additional_flags))

/obj/structure/machinery/fuelpump/acid_spray_act()
	if(unacidable || health <= 0 || !SSticker?.mode?.is_in_endgame)
		return

	visible_message(SPAN_WARNING("[src] is hit by the acid spray!"))
	// Spray is/was 4 ticks * 1 mult * (20,40,80 tier) = (80,160,320) after 4s
	var/datum/effects/acid/spray_glob = locate() in src
	if(spray_glob)
		spray_glob.duration = initial(spray_glob.duration)
	else
		spray_glob = new /datum/effects/acid(src, null, null)

/obj/structure/machinery/fuelpump/get_applying_acid_time()
	if(unacidable || health <= 0 || !SSticker?.mode?.is_in_endgame)
		return -1
	return ..()
	// Corrosive is/was 3 ticks * (20,40,100 level) = (60,120,300) after 15s

/obj/structure/machinery/fuelpump/bullet_act(obj/projectile/bullet)
	bullet_ping(bullet, pixel_x_offset=48)
	if(CHECK_MULTIPLE_BITFIELDS(bullet.ammo.flags_ammo_behavior, AMMO_ACIDIC|AMMO_XENO))
		// Is/was 20-30 dmg
		update_health(bullet.damage)
	return TRUE

// Charger is/was (1-8 momentum) * 22 = (22-176)
// Crusher is/was melee_damage_upper (40)

/obj/structure/machinery/fuelpump/handle_tail_stab(mob/living/carbon/xenomorph/xeno, blunt_stab)
	if(unslashable || health <= 0 || !SSticker?.mode?.is_in_endgame)
		to_chat(xeno, SPAN_WARNING("We stare at [src] cluelessly."))
		return TAILSTAB_COOLDOWN_NONE
	// Stab is/was a range of 20-45 (excluding king at 55)
	update_health(xeno.melee_damage_upper)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno.tail_stab_animation(src, blunt_stab)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/machinery/fuelpump/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0 || !SSticker?.mode?.is_in_endgame)
		to_chat(xeno, SPAN_WARNING("We stare at [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	xeno.animation_attack_on(src)
	// Melee is/was a range of 20-45 (excluding king at 45-55)
	update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/fuelpump/update_health(damage)
	if(health <= 0)
		return
	if(damage <= 0)
		return
	if(!SSticker?.mode?.is_in_endgame)
		return
	health -= damage
	if(health <= 0)
		playsound(src, 'sound/effects/metalscrape.ogg', 25, 1)
		stat |= BROKEN
	update_icon()

/// Signal handler for COMSIG_GLOB_FUEL_PUMP_UPDATE
/obj/structure/machinery/fuelpump/proc/on_pump_update()
	SIGNAL_HANDLER
	playsound(src, 'sound/machines/resource_node/node_idle.ogg', 75, TRUE)
	update_icon()

/obj/structure/machinery/fuelpump/update_icon()
	overlays.Cut()

	..()

	var/health_percent = ceil(health / initial(health) * 100)
	switch(health_percent)
		if(-INFINITY to 0)
			icon_state = "fuelpump_destroyed"
			return
		if(1 to 30)
			overlays += image(icon, icon_state = "+fuelpump_health_30")
		if(31 to 60)
			overlays += image(icon, icon_state = "+fuelpump_health_60")
		if(61 to 80)
			overlays += image(icon, icon_state = "+fuelpump_health_80")
		if(81 to 90)
			overlays += image(icon, icon_state = "+fuelpump_health_90")

	if(SShijack.hijack_status < HIJACK_OBJECTIVES_STARTED)
		if(stat & NOPOWER)
			icon_state = "fuelpump_off"
		else
			icon_state = "fuelpump_on"
		return

	switch(SShijack.current_progress)
		if(-INFINITY to 24)
			icon_state = "fuelpump_0"
		if(25 to 49)
			icon_state = "fuelpump_25"
		if(50 to 74)
			icon_state = "fuelpump_50"
		if(75 to 99)
			icon_state = "fuelpump_75"
		if(100 to INFINITY)
			icon_state = "fuelpump_100"
		else
			icon_state = "fuelpump_on" // Never should happen

/obj/structure/machinery/fuelpump/get_examine_text(mob/user)
	var/not_powered = stat & NOPOWER
	stat &= ~NOPOWER // Avoid caring about NOPOWER stat in parent implementation
	. = ..()
	stat |= not_powered

	if(inoperable())
		return
	if(SShijack.hijack_status < HIJACK_OBJECTIVES_STARTED)
		return
	if(get_dist(user, src) > 2 && user != loc)
		return

	switch(SShijack.current_progress)
		if(-INFINITY to 24)
			. += SPAN_NOTICE("It looks like it barely has any fuel yet.")
		if(25 to 49)
			. += SPAN_NOTICE("It looks like it has accumulated some fuel.")
		if(50 to 74)
			. += SPAN_NOTICE("It looks like the fuel tank is a little over half full.")
		if(75 to 99)
			. += SPAN_NOTICE("It looks like the fuel tank is almost full.")
		if(100 to INFINITY)
			. += SPAN_NOTICE("It looks like the fuel tank is full.")
		else
			. += SPAN_NOTICE("It looks like something is wrong!") // Never should happen

	var/health_percent = ceil(health / initial(health) * 100)
	switch(health_percent)
		if(1 to 30)
			. += SPAN_WARNING("It's crumbling apart, just a few more blows will tear it apart.")
		if(31 to 60)
			. += SPAN_WARNING("It's quite beat up, but it's holding together.")
		if(61 to 90)
			. += SPAN_WARNING("It's slightly damaged, but still very functional.")
		if(91 to INFINITY)
			. += SPAN_INFO("It appears to be in good shape.")
