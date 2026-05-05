/*
 * Traps
 */

/obj/effect/alien/resin/trap
	desc = "It looks like a hiding hole."
	name = "resin trap"
	icon_state = "trap0"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	health = 5
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber = XENO_HIVE_NORMAL //Hivenumber of the xeno that planted it OR the last Facehugger that was placed (essentially taking over the trap)
	var/trap_type = RESIN_TRAP_EMPTY
	var/armed = 0
	var/created_by //ckey
	var/list/notify_list = list() // list of xeno mobs to notify on trigger
	var/datum/effect_system/smoke_spread/smoke_system
	var/datum/cause_data/cause_data
	plane = FLOOR_PLANE

/obj/effect/alien/resin/trap/Initialize(mapload, mob/living/carbon/xenomorph/xeno)
	. = ..()
	if(xeno)
		created_by = xeno.ckey
		hivenumber = xeno.hivenumber

	cause_data = create_cause_data("resin trap", xeno)
	set_hive_data(src, hivenumber)
	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	var/obj/effect/alien/weeds/node/weed = locate() in loc
	if(weed)
		weed.RegisterSignal(src, COMSIG_PARENT_PREQDELETED, /obj/effect/alien/weeds/node/proc/trap_destroyed)
		weed.overlay_node = FALSE
		weed.overlays.Cut()

/obj/effect/alien/resin/trap/get_examine_text(mob/user)
	if(!isxeno(user))
		return ..()
	. = ..()
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			. += "It's empty."
		if(RESIN_TRAP_HUGGER)
			. += "There's a little one inside."
		if(RESIN_TRAP_GAS)
			. += "It's filled with pressurised gas."
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			. += "It's filled with pressurised acid."

/obj/effect/alien/resin/trap/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/effect/alien/resin/trap/proc/facehugger_die()
	var/obj/item/clothing/mask/facehugger/target_hugger = new (loc)
	target_hugger.die()
	trap_type = RESIN_TRAP_EMPTY
	icon_state = "trap0"

/obj/effect/alien/resin/trap/flamer_fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			burn_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trigger_trap(TRUE)
	..()

/obj/effect/alien/resin/trap/fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			burn_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trigger_trap(TRUE)
	..()

/obj/effect/alien/resin/trap/bullet_act(obj/projectile/target_proj)
	var/mob/living/carbon/xenomorph/xeno = target_proj.firer
	if(istype(xeno) && HIVE_ALLIED_TO_HIVE(xeno.hivenumber, hivenumber))
		return

	. = ..()

/obj/effect/alien/resin/trap/HasProximity(atom/movable/victim)
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			if(can_hug(victim, hivenumber) && !isyautja(victim) && !issynth(victim) && !isthrall(victim))
				var/mob/living/victim_mob = victim
				victim_mob.visible_message(SPAN_WARNING("[victim_mob] trips on [src]!"))
				to_chat(victim_mob, SPAN_DANGER("You trip on [src]!"))
				victim_mob.apply_effect(1, WEAKEN)
				trigger_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			if(ishuman_strict(victim))
				var/mob/living/carbon/human/victim_human = victim
				if(victim_human.stat == DEAD || victim_human.body_position == LYING_DOWN)
					return
				if(victim_human.ally_of_hivenumber(hivenumber))
					return
				trigger_trap()
			if(isxeno(victim))
				var/mob/living/carbon/xenomorph/victim_xeno = victim
				if(victim_xeno.hivenumber != hivenumber)
					trigger_trap()
			if(isVehicleMultitile(victim) && trap_type != RESIN_TRAP_GAS)
				trigger_trap()

/obj/effect/alien/resin/trap/proc/set_state(state = RESIN_TRAP_EMPTY)
	switch(state)
		if(RESIN_TRAP_EMPTY)
			trap_type = RESIN_TRAP_EMPTY
			icon_state = "trap0"
		if(RESIN_TRAP_HUGGER)
			trap_type = RESIN_TRAP_HUGGER
			icon_state = "trap1"
		if(RESIN_TRAP_ACID1)
			trap_type = RESIN_TRAP_ACID1
			icon_state = "trapacid1"
		if(RESIN_TRAP_ACID2)
			trap_type = RESIN_TRAP_ACID2
			icon_state = "trapacid2"
		if(RESIN_TRAP_ACID3)
			trap_type = RESIN_TRAP_ACID3
			icon_state = "trapacid3"
		if(RESIN_TRAP_GAS)
			trap_type = RESIN_TRAP_GAS
			icon_state = "trapgas"

/obj/effect/alien/resin/trap/proc/burn_trap()
	var/area/target_area = get_area(src)
	facehugger_die()
	clear_tripwires()
	for(var/mob/living/carbon/xenomorph/xeno in GLOB.living_xeno_list)
		if(xeno.hivenumber == hivenumber)
			to_chat(xeno, SPAN_XENOMINORWARNING("We sense one of our Hive's facehugger traps at [target_area.name] has been burnt!"))

/obj/effect/alien/resin/trap/proc/get_spray_type(level)
	switch(level)
		if(RESIN_TRAP_ACID1)
			return /obj/effect/xenomorph/spray/weak

		if(RESIN_TRAP_ACID2)
			return /obj/effect/xenomorph/spray

		if(RESIN_TRAP_ACID3)
			return /obj/effect/xenomorph/spray/strong

/obj/effect/alien/resin/trap/proc/trigger_trap(destroyed = FALSE)
	set waitfor = 0
	var/area/target_area = get_area(src)
	var/trap_type_name = ""
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			trap_type_name = "empty"
		if(RESIN_TRAP_HUGGER)
			trap_type_name = "hugger"
			var/obj/item/clothing/mask/facehugger/target_hugger = new (loc)
			target_hugger.hivenumber = hivenumber
			set_hive_data(target_hugger, hivenumber)
			set_state()
			visible_message(SPAN_WARNING("[target_hugger] gets out of [src]!"))
			sleep(15)
			if(target_hugger.stat == CONSCIOUS && target_hugger.loc) //Make sure we're conscious and not idle or dead.
				target_hugger.leap_at_nearest_target()
		if(RESIN_TRAP_GAS)
			trap_type_name = "gas"
			smoke_system.set_up(2, 0, src.loc)
			smoke_system.start()
			set_state()
			clear_tripwires()
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trap_type_name = "acid"
			var/spray_type = get_spray_type(trap_type)

			new spray_type(loc, cause_data, hivenumber)
			for(var/turf/target_turf in range(1,loc))
				var/obj/effect/xenomorph/spray/acid_splash = new spray_type(target_turf, cause_data, hivenumber)
				for(var/mob/living/carbon/target_carbon in target_turf)
					if(target_carbon.ally_of_hivenumber(hivenumber))
						continue
					acid_splash.apply_spray(target_carbon)
			set_state()
			clear_tripwires()
	if(!target_area)
		return
	for(var/mob/living/carbon/xenomorph/xeno in GLOB.living_xeno_list)
		if(xeno.hivenumber == hivenumber)
			if(destroyed)
				to_chat(xeno, SPAN_XENOMINORWARNING("We sense one of our Hive's [trap_type_name] traps at [target_area.name] has been destroyed!"))
			else
				to_chat(xeno, SPAN_XENOMINORWARNING("We sense one of our Hive's [trap_type_name] traps at [target_area.name] has been triggered!"))

/obj/effect/alien/resin/trap/proc/clear_tripwires()
	QDEL_NULL_LIST(tripwires)
	tripwires = list()

/obj/effect/alien/resin/trap/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.hivenumber != hivenumber)
		return ..()

	if(xeno.a_intent == INTENT_HARM && trap_type == RESIN_TRAP_EMPTY)
		return ..()

	if(trap_type == RESIN_TRAP_HUGGER)
		if(xeno.caste.can_hold_facehuggers)
			set_state()
			var/obj/item/clothing/mask/facehugger/hugger = new (loc, hivenumber)
			xeno.put_in_active_hand(hugger)
			to_chat(xeno, SPAN_XENONOTICE("You remove the facehugger from [src]."))
			return XENO_NONCOMBAT_ACTION
		else
			to_chat(xeno, SPAN_XENONOTICE("[src] is occupied by a child."))
			return XENO_NO_DELAY_ACTION

	if((!xeno.acid_level || trap_type == RESIN_TRAP_GAS) && trap_type != RESIN_TRAP_EMPTY)
		to_chat(xeno, SPAN_XENONOTICE("Better not risk setting this off."))
		return XENO_NO_DELAY_ACTION

	if(xeno.try_fill_trap(src))
		return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/trap/proc/setup_tripwires()
	clear_tripwires()
	for(var/turf/target_turf in orange(1,loc))
		if(target_turf.density)
			continue
		var/obj/effect/trap_tripwire/new_tripwire = new /obj/effect/trap_tripwire(target_turf)
		new_tripwire.linked_trap = src
		tripwires += new_tripwire

/obj/effect/alien/resin/trap/attackby(obj/item/weapon, mob/user)
	if(!(istype(weapon, /obj/item/clothing/mask/facehugger) && isxeno(user)))
		return ..()
	if(trap_type != RESIN_TRAP_EMPTY)
		to_chat(user, SPAN_XENOWARNING("You can't put a hugger in this trap!"))
		return
	var/obj/item/clothing/mask/facehugger/target_hugger = weapon
	if(target_hugger.stat == DEAD)
		to_chat(user, SPAN_XENOWARNING("You can't put a dead facehugger in [src]."))
	else
		var/mob/living/carbon/xenomorph/xeno = user
		if(!istype(xeno))
			return

		if(xeno.hivenumber != hivenumber)
			to_chat(user, SPAN_XENOWARNING("This resin trap doesn't belong to your hive!"))
			return

		if(target_hugger.hivenumber != hivenumber)
			to_chat(user, SPAN_XENOWARNING("This facehugger is tainted."))
			return

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|INTERRUPT_DAZED, BUSY_ICON_HOSTILE))
			return

		set_state(RESIN_TRAP_HUGGER)
		to_chat(user, SPAN_XENONOTICE("You place a facehugger in [src]."))
		qdel(target_hugger)

/obj/effect/alien/resin/trap/healthcheck()
	if(trap_type != RESIN_TRAP_EMPTY && loc)
		trigger_trap()
	..()

/obj/effect/alien/resin/trap/Crossed(atom/target_atom)
	if(ismob(target_atom) || isVehicleMultitile(target_atom))
		HasProximity(target_atom)

/obj/effect/alien/resin/trap/Destroy()
	QDEL_NULL_LIST(tripwires)
	. = ..()

/obj/effect/trap_tripwire
	name = "trap tripwire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/trap/linked_trap

/obj/effect/trap_tripwire/Destroy()
	if(linked_trap)
		linked_trap.tripwires -= src
		linked_trap = null
	. = ..()

/obj/effect/trap_tripwire/Crossed(atom/target_atom)
	if(!linked_trap)
		qdel(src)
		return

	if(linked_trap.trap_type == RESIN_TRAP_EMPTY)
		qdel(src)
		return

	if(ishuman(target_atom) || isxeno(target_atom) || isVehicleMultitile(target_atom))
		linked_trap.HasProximity(target_atom)
