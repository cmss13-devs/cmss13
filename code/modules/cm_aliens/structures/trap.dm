/*
 * Traps
 */

/obj/effect/alien/resin/trap
	desc = "It looks like a hiding hole."
	name = "resin hole"
	icon_state = "trap0"
	density = 0
	opacity = 0
	anchored = 1
	health = 5
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber //Hivenumber of the xeno that planted it OR the last Facehugger that was placed (essentially taking over the hole)
	var/trap_type = RESIN_TRAP_EMPTY
	var/armed = 0
	var/created_by // ckey
	var/list/notify_list = list() // list of xeno mobs to notify on trigger
	var/datum/effect_system/smoke_spread/smoke_system
	var/source_name
	var/source_mob

/obj/effect/alien/resin/trap/New(loc, mob/living/carbon/Xenomorph/X)
	if(X)
		created_by = X.ckey
		hivenumber = X.hivenumber
		source_name = X.caste_name
		source_mob = X
	..()

/obj/effect/alien/resin/trap/examine(mob/user)
	if(!isXeno(user))
		return ..()
	to_chat(user, "A hole for setting a trap.")
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			to_chat(user, "It's empty.")
		if(RESIN_TRAP_HUGGER)
			to_chat(user, "There's a little one inside.")
		if(RESIN_TRAP_GAS)
			to_chat(user, "It's filled with pressurised gas.")
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			to_chat(user, "It's filled with pressurised acid.")		

/obj/effect/alien/resin/trap/proc/facehugger_die()
	var/obj/item/clothing/mask/facehugger/FH = new (loc)
	FH.Die()
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

/obj/effect/alien/resin/trap/bullet_act(obj/item/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	. = ..()

/obj/effect/alien/resin/trap/HasProximity(atom/movable/AM)
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			if(CanHug(AM) && !isYautja(AM) && !isSynth(AM))
				var/mob/living/L = AM
				L.visible_message(SPAN_WARNING("[L] trips on [src]!"),\
								SPAN_DANGER("You trip on [src]!"))
				L.KnockDown(1)
				trigger_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			if(ishuman(AM))
				var/mob/living/carbon/human/H = AM
				if(isSynth(H) || isYautja(H))
					return
				if(H.stat == DEAD || H.lying)
					return
				trigger_trap()

/obj/effect/alien/resin/trap/proc/set_state(var/state = RESIN_TRAP_EMPTY)
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
	var/area/A = get_area(src)
	facehugger_die()
	clear_tripwires()
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hivenumber)
			to_chat(X, SPAN_XENOMINORWARNING("You sense one of your Hive's hugger traps at [A.name] has been burnt!"))

/obj/effect/alien/resin/trap/proc/trigger_trap(var/destroyed = FALSE)
	set waitfor = 0
	var/area/A = get_area(src)
	var/trap_type_name = ""
	switch(trap_type)
		if(RESIN_TRAP_EMPTY)
			trap_type_name = "empty"
		if(RESIN_TRAP_HUGGER)
			trap_type_name = "hugger"
			var/obj/item/clothing/mask/facehugger/FH = new (loc)
			FH.hivenumber = hivenumber
			set_state()
			visible_message(SPAN_WARNING("[FH] gets out of [src]!"))
			sleep(15)
			if(FH.stat == CONSCIOUS && FH.loc) //Make sure we're conscious and not idle or dead.
				FH.leap_at_nearest_target()
		if(RESIN_TRAP_GAS)
			trap_type_name = "gas"
			smoke_system.set_up(2, 0, src.loc)
			smoke_system.start()
			set_state()
			clear_tripwires()
		if(RESIN_TRAP_ACID1, RESIN_TRAP_ACID2, RESIN_TRAP_ACID3)
			trap_type_name = "acid"
			new /obj/effect/xenomorph/spray(loc, , source_name, source_mob)
			for(var/turf/T in range(1,loc))
				var/obj/effect/xenomorph/spray/SP = new (T, trap_type-RESIN_TRAP_ACID1+1, source_name, source_mob) //adding extra acid damage for better acid types
				for(var/mob/living/carbon/human/H in T)
					SP.apply_spray(H)
			set_state()
			clear_tripwires()
	if(!A)
		return
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hivenumber)
			if(destroyed)
				to_chat(X, SPAN_XENOMINORWARNING("You sense one of your Hive's [trap_type_name] traps at [A.name] has been destroyed!"))
			else
				to_chat(X, SPAN_XENOMINORWARNING("You sense one of your Hive's [trap_type_name] traps at [A.name] has been triggered!"))

/obj/effect/alien/resin/trap/proc/clear_tripwires()
	for(var/obj/effect/hole_tripwire/HT in tripwires)
		qdel(HT)

/obj/effect/alien/resin/trap/attack_alien(mob/living/carbon/Xenomorph/X)
	var/trap_acid_level = 0
	if(trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + trap_type - RESIN_TRAP_ACID1
	if(X.a_intent != "hurt")
		if(trap_type == RESIN_TRAP_HUGGER)
			if(X.caste.can_hold_facehuggers)
				set_state()
				var/obj/item/clothing/mask/facehugger/F = new ()
				F.hivenumber = hivenumber
				X.put_in_active_hand(F)
				to_chat(X, SPAN_XENONOTICE("You remove the facehugger from [src]."))
			else
				to_chat(X, SPAN_XENONOTICE("This one is occupied with a child."))
			return

		if((!X.acid_level || trap_type == RESIN_TRAP_GAS) && trap_type != RESIN_TRAP_EMPTY)
			to_chat(X, SPAN_XENONOTICE("Better not risk setting this off."))
			return
		if(trap_acid_level >= X.acid_level)
			to_chat(X, SPAN_XENONOTICE("It already has good acid in."))
			return

		if(isXenoBoiler(X))
			var/mob/living/carbon/Xenomorph/Boiler/B = X

			if(B.bomb_cooldown)
				to_chat(B, SPAN_XENOWARNING("You must wait to produce enough acid to pressurise this trap."))
				return

			if(!B.check_plasma(200))
				to_chat(B, SPAN_XENOWARNING("You must produce more plasma before doing this."))
				return

			to_chat(X, SPAN_XENONOTICE("You begin charging the resin hole with acid gas."))
			if(!do_after(B, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				return

			if(trap_type != RESIN_TRAP_EMPTY)
				return

			if(B.used_acid_spray)
				return

			if(!B.check_plasma(200))
				return

			if(B.ammo.type == /datum/ammo/xeno/boiler_gas)
				smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()
			else
				smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()

			setup_tripwires()
			B.use_plasma(200)
			playsound(loc, 'sound/effects/refill.ogg', 25, 1)
			set_state(RESIN_TRAP_GAS)
			B.visible_message(SPAN_XENOWARNING("\The [B] pressurises the resin hole with acid gas!"), \
			SPAN_XENOWARNING("You pressurise the resin hole with acid gas!"), null, 5)
			hivenumber = X.hivenumber //Taking over the hole
			return
		else
			//Non-boiler acid types
			var/acid_cost = 70
			if(X.acid_level == 2)
				acid_cost = 100
			else if(X.acid_level == 3)
				acid_cost = 200

			if (!X.check_plasma(acid_cost))
				to_chat(X, SPAN_XENOWARNING("You must produce more plasma before doing this."))
				return

			to_chat(X, SPAN_XENONOTICE("You begin charging the resin hole with acid."))
			if(!do_after(X, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				return

			if (!X.check_plasma(acid_cost))
				return

			X.use_plasma(acid_cost)
			setup_tripwires()
			playsound(loc, 'sound/effects/refill.ogg', 25, 1)
			set_state(RESIN_TRAP_ACID1 + X.acid_level - 1)
			X.visible_message(SPAN_XENOWARNING("\The [X] pressurises the resin hole with acid!"), \
			SPAN_XENOWARNING("You pressurise the resin hole with acid!"), null, 5)
			hivenumber = X.hivenumber //Taking over the hole
			return
	else if(trap_type == RESIN_TRAP_EMPTY)
		..()

/obj/effect/alien/resin/trap/proc/setup_tripwires()
	clear_tripwires()
	for(var/turf/T in orange(1,loc))
		if(T.density)
			continue
		var/obj/effect/hole_tripwire/HT = new /obj/effect/hole_tripwire(T)
		HT.linked_trap = src
		tripwires += HT

/obj/effect/alien/resin/trap/attackby(obj/item/W, mob/user)
	if(!(istype(W, /obj/item/clothing/mask/facehugger) && isXeno(user)))
		return ..()
	if(trap_type != RESIN_TRAP_EMPTY)
		to_chat(user, SPAN_XENOWARNING("You can't put a hugger in this hole!"))
		return
	var/obj/item/clothing/mask/facehugger/FH = W
	if(FH.stat == DEAD)
		to_chat(user, SPAN_XENOWARNING("You can't put a dead facehugger in [src]."))
	else
		hivenumber = FH.hivenumber //Taking over the hole
		set_state(RESIN_TRAP_HUGGER)
		to_chat(user, SPAN_XENONOTICE("You place a facehugger in [src]."))
		qdel(FH)

/obj/effect/alien/resin/trap/Crossed(atom/A)
	if(ismob(A))
		HasProximity(A)

/obj/effect/alien/resin/trap/Dispose()
	if(trap_type != RESIN_TRAP_EMPTY && loc)
		trigger_trap()
	for(var/obj/effect/hole_tripwire/HT in tripwires)
		qdel(HT)
	. = ..()

/obj/effect/hole_tripwire
	name = "hole tripwire"
	anchored = 1
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/trap/linked_trap

/obj/effect/hole_tripwire/Dispose()
	if(linked_trap)
		linked_trap.tripwires -= src
		linked_trap = null
	. = ..()

/obj/effect/hole_tripwire/Crossed(atom/A)
	if(!linked_trap)
		qdel(src)
		return

	if(linked_trap.trap_type == RESIN_TRAP_EMPTY)
		qdel(src)
		return

	if(ishuman(A))
		linked_trap.HasProximity(A)
