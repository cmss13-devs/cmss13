
/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/Xeno/Effects.dmi'
	unacidable = 1
	var/health = 1

/obj/effect/alien/flamer_fire_act()
	health -= 50
	if(health < 0) cdel(src)

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "Resin1"
	anchored = 1
	health = 200
	unacidable = 1


/obj/effect/alien/resin/proc/healthcheck()
	if(health <= 0)
		density = 0
		cdel(src)

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage/2
	..()
	healthcheck()
	return 1

/obj/effect/alien/resin/ex_act(severity)
	health -= severity
	healthcheck()
	return

/obj/effect/alien/resin/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>", \
	"<span class='danger'>You hit \the [src].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	if(istype(src, /obj/effect/alien/resin/sticky))
		playsound(loc, "alien_resin_move", 25)
	else
		playsound(loc, "alien_resin_break", 25)
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/alien/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	M.visible_message("<span class='xenonotice'>\The [M] claws \the [src]!</span>", \
	"<span class='xenonotice'>You claw \the [src].</span>")
	if(istype(src, /obj/effect/alien/resin/sticky))
		playsound(loc, "alien_resin_move", 25)
	else
		playsound(loc, "alien_resin_break", 25)
	health -= (M.melee_damage_upper + 50) //Beef up the damage a bit
	healthcheck()

/obj/effect/alien/resin/attack_animal(mob/living/M as mob)
	M.visible_message("<span class='danger'>[M] tears \the [src]!</span>", \
	"<span class='danger'>You tear \the [name].</span>")
	if(istype(src, /obj/effect/alien/resin/sticky))
		playsound(loc, "alien_resin_move", 25)
	else
		playsound(loc, "alien_resin_break", 25)
	health -= 40
	healthcheck()

/obj/effect/alien/resin/attack_hand()
	usr << "<span class='warning'>You scrape ineffectively at \the [src].</span>"

/obj/effect/alien/resin/attack_paw()
	return attack_hand()

/obj/effect/alien/resin/attackby(obj/item/W, mob/user)
	if(!(W.flags_item & NOBLUDGEON))
		var/damage = W.force
		if(W.w_class < 4 || !W.sharp || W.force < 20) //only big strong sharp weapon are adequate
			damage /= 4
		health -= damage
		if(istype(src, /obj/effect/alien/resin/sticky))
			playsound(loc, "alien_resin_move", 25)
		else
			playsound(loc, "alien_resin_break", 25)
		healthcheck()
	return ..()




/obj/effect/alien/resin/sticky
	name = "sticky resin"
	desc = "A layer of disgusting sticky slime."
	icon_state = "sticky"
	density = 0
	opacity = 0
	health = 36
	layer = RESIN_STRUCTURE_LAYER
	var/slow_amt = 8

	Crossed(atom/movable/AM)
		. = ..()
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.next_move_slowdown += slow_amt

// Praetorian Sticky Resin spit uses this.
/obj/effect/alien/resin/sticky/thin
	name = "thin sticky resin"
	desc = "A thin layer of disgusting sticky slime."
	health = 7
	slow_amt = 4


#define RESIN_TRAP_EMPTY 0
#define RESIN_TRAP_HUGGER 1
#define RESIN_TRAP_ACID 2
#define RESIN_TRAP_GAS 3

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

/obj/effect/alien/resin/trap/New(loc, mob/living/carbon/Xenomorph/X)
	if(X)
		created_by = X.ckey
		hivenumber = X.hivenumber
	..()

/obj/effect/alien/resin/trap/examine(mob/user)
	if(isXeno(user))
		user << "A hole for setting a trap."
		switch(trap_type)
			if(RESIN_TRAP_EMPTY)
				user << "It's empty."
			if(RESIN_TRAP_HUGGER)
				user << "There's a little one inside."
			if(RESIN_TRAP_GAS)
				user << "It's filled with pressurised gas."
			if(RESIN_TRAP_ACID)
				user << "It's filled with pressurised acid."
	else
		..()

/obj/effect/alien/resin/trap/proc/facehugger_die()
	var/obj/item/clothing/mask/facehugger/FH = new (loc)
	FH.Die()
	trap_type = RESIN_TRAP_EMPTY
	icon_state = "trap0"

/obj/effect/alien/resin/trap/flamer_fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			facehugger_die()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID)
			trigger_trap()
	..()

/obj/effect/alien/resin/trap/fire_act()
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			facehugger_die()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID)
			trigger_trap()
	..()

/obj/effect/alien/resin/trap/bullet_act(obj/item/projectile/P)
	if(P.ammo.flags_ammo_behavior & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	. = ..()

/obj/effect/alien/resin/trap/HasProximity(atom/movable/AM)
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			if(CanHug(AM) && !isYautja(AM) && !isSynth(AM))
				var/mob/living/L = AM
				L.visible_message("<span class='warning'>[L] trips on [src]!</span>",\
								"<span class='danger'>You trip on [src]!</span>")
				L.KnockDown(1)
				trigger_trap()
		if(RESIN_TRAP_GAS, RESIN_TRAP_ACID)
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
		if(RESIN_TRAP_ACID)
			trap_type = RESIN_TRAP_ACID
			icon_state = "trapacid"
		if(RESIN_TRAP_GAS)
			trap_type = RESIN_TRAP_GAS
			icon_state = "trapgas"

/obj/effect/alien/resin/trap/proc/trigger_trap()
	set waitfor = 0
	var/area/A = get_area(src)
	if(A)
		for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
			if(X.hivenumber == hivenumber)
				X << "<span class='xenoannounce'>You sense one of your Hive's traps at [A.name] has been triggered!</span>"
	switch(trap_type)
		if(RESIN_TRAP_HUGGER)
			var/obj/item/clothing/mask/facehugger/FH = new (loc)
			FH.hivenumber = hivenumber
			set_state()
			visible_message("<span class='warning'>[FH] gets out of [src]!</span>")
			sleep(15)
			if(FH.stat == CONSCIOUS && FH.loc) //Make sure we're conscious and not idle or dead.
				FH.leap_at_nearest_target()
		if(RESIN_TRAP_GAS)
			smoke_system.set_up(2, 0, src.loc)
			smoke_system.start()
			set_state()
			clear_tripwires()
		if(RESIN_TRAP_ACID)
			new /obj/effect/xenomorph/spray(loc)
			for(var/turf/T in range(1,loc))
				new /obj/effect/xenomorph/spray(T)
			set_state()
			clear_tripwires()

/obj/effect/alien/resin/trap/proc/clear_tripwires()
	for(var/obj/effect/hole_tripwire/HT in tripwires)
		cdel(HT)

/obj/effect/alien/resin/trap/attack_alien(mob/living/carbon/Xenomorph/X)
	if(X.a_intent != "hurt")
		switch(trap_type)
			if(RESIN_TRAP_HUGGER)
				if(X.caste.can_hold_facehuggers)
					set_state()
					var/obj/item/clothing/mask/facehugger/F = new ()
					F.hivenumber = hivenumber
					X.put_in_active_hand(F)
					X << "<span class='xenonotice'>You remove the facehugger from [src].</span>"
				return
			if(RESIN_TRAP_GAS, RESIN_TRAP_ACID)
				X << "<span class='xenonotice'>Better not risk setting this off.</span>"
				return
			if(RESIN_TRAP_EMPTY)
				if(isXenoPraetorian(X))
					if (X.used_acid_spray)
						X << "<span class='xenowarning'>You must wait to produce enough acid to pressurise this trap.</span>"
						return

					if (!X.check_plasma(200))
						X << "<span class='xenowarning'>You must produce more plasma before doing this.</span>"
						return

					X << "<span class='xenonotice'>You begin charging the resin hole with acid.</span>"
					if(!do_after(X, 30, TRUE, 5, BUSY_ICON_HOSTILE))
						return

					if(trap_type != RESIN_TRAP_EMPTY)
						return

					if (X.used_acid_spray)
						return

					if (!X.check_plasma(200))
						return

					X.used_acid_spray = 1
					X.use_plasma(200)
					setup_tripwires()
					playsound(loc, 'sound/effects/refill.ogg', 25, 1)
					set_state(RESIN_TRAP_ACID)
					X.visible_message("<span class='xenowarning'>\The [X] pressurises the resin hole with acid!</span>", \
					"<span class='xenowarning'>You pressurise the resin hole with acid!</span>", null, 5)
					X.speed += 2
					spawn(rand(20,30))
						X.speed -= 2

					spawn(X.caste.acid_spray_cooldown)
						X.used_acid_spray = 0
						X << "<span class='notice'>You have produced enough acid to spray again.</span>"
					hivenumber = X.hivenumber //Taking over the hole
					return
				if(isXenoBoiler(X))
					var/mob/living/carbon/Xenomorph/Boiler/B = X

					if (B.bomb_cooldown)
						B << "<span class='xenowarning'>You must wait to produce enough acid to pressurise this trap.</span>"
						return

					if (!B.check_plasma(200))
						B << "<span class='xenowarning'>You must produce more plasma before doing this.</span>"
						return

					X << "<span class='xenonotice'>You begin charging the resin hole with acid gas.</span>"
					if(!do_after(B, 30, TRUE, 5, BUSY_ICON_HOSTILE))
						return

					if(trap_type != RESIN_TRAP_EMPTY)
						return

					if (B.used_acid_spray)
						return

					if (!B.check_plasma(200))
						return
					if(B.ammo.type == /datum/ammo/xeno/boiler_gas)
						smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()
					else
						smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()
					setup_tripwires()
					B.bomb_cooldown = 1
					B.use_plasma(200)
					playsound(loc, 'sound/effects/refill.ogg', 25, 1)
					set_state(RESIN_TRAP_GAS)
					B.visible_message("<span class='xenowarning'>\The [B] pressurises the resin hole with acid gas!</span>", \
					"<span class='xenowarning'>You pressurise the resin hole with acid gas!</span>", null, 5)

					spawn(B.caste.bomb_delay)
						B.bomb_cooldown = 0
						B << "<span class='notice'>You have produced enough acid to bombard again.</span>"
					hivenumber = X.hivenumber //Taking over the hole
					return
	else
		if(trap_type == RESIN_TRAP_EMPTY)
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
	if(istype(W, /obj/item/clothing/mask/facehugger) && isXeno(user))
		if(trap_type != RESIN_TRAP_EMPTY)
			user << "<span class='xenowarning'>You can't put a hugger in this hole!</span>"
			return
		var/obj/item/clothing/mask/facehugger/FH = W
		if(FH.stat == DEAD)
			user << "<span class='xenowarning'>You can't put a dead facehugger in [src].</span>"
		else
			hivenumber = FH.hivenumber //Taking over the hole
			set_state(RESIN_TRAP_HUGGER)
			user << "<span class='xenonotice'>You place a facehugger in [src].</span>"
			cdel(FH)
	else
		. = ..()

/obj/effect/alien/resin/trap/Crossed(atom/A)
	if(ismob(A))
		HasProximity(A)

/obj/effect/alien/resin/trap/Dispose()
	if(trap_type != RESIN_TRAP_EMPTY && loc)
		trigger_trap()
	for(var/obj/effect/hole_tripwire/HT in tripwires)
		cdel(HT)
	. = ..()

/obj/effect/hole_tripwire
	name = "hole tripwire"
	anchored = 1
	mouse_opacity = 0
	invisibility = 101
	unacidable = 1 //You never know
	var/obj/effect/alien/resin/trap/linked_trap

/obj/effect/hole_tripwire/Dispose()
	if(linked_trap)
		linked_trap.tripwires -= src
		linked_trap = null
	. = ..()

/obj/effect/hole_tripwire/Crossed(atom/A)
	if(!linked_trap)
		cdel(src)
		return

	if(linked_trap.trap_type == RESIN_TRAP_EMPTY)
		cdel(src)
		return

	if(ishuman(A))
		linked_trap.HasProximity(A)


//Resin Doors
/obj/structure/mineral_door/resin
	name = "resin door"
	mineralType = "resin"
	icon = 'icons/Xeno/Effects.dmi'
	hardness = 1.5
	var/health = 80
	var/close_delay = 100

	tiles_with = list(/turf/closed, /obj/structure/mineral_door/resin)

/obj/structure/mineral_door/resin/New()
	spawn(0)
		relativewall()
		relativewall_neighbours()
		if(!locate(/obj/effect/alien/weeds) in loc)
			new /obj/effect/alien/weeds(loc)
	..()

/obj/structure/mineral_door/resin/attack_paw(mob/user as mob)
	if(user.a_intent == "hurt")
		user.visible_message("<span class='xenowarning'>\The [user] claws at \the [src].</span>", \
		"<span class='xenowarning'>You claw at \the [src].</span>")
		playsound(loc, "alien_resin_break", 25)
		health -= rand(40, 60)
		if(health <= 0)
			user.visible_message("<span class='xenodanger'>\The [user] slices \the [src] apart.</span>", \
			"<span class='xenodanger'>You slice \the [src] apart.</span>")
		healthcheck()
		return
	else
		return TryToSwitchState(user)

/obj/structure/mineral_door/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage/2
	..()
	healthcheck()
	return 1

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(isXeno(user))
		return ..()

/obj/structure/mineral_door/resin/Open()
	if(state || !loc) return //already open
	isSwitchingStates = 1
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]opening",src)
	sleep(10)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0

	spawn(close_delay)
		if(!isSwitchingStates && state == 1)
			Close()

/obj/structure/mineral_door/resin/Close()
	if(!state || !loc) return //already closed
	//Can't close if someone is blocking it
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			spawn (close_delay)
				Close()
			return
	isSwitchingStates = 1
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]closing",src)
	sleep(10)
	density = 1
	opacity = 1
	state = 0
	update_icon()
	isSwitchingStates = 0
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			Open()
			return

/obj/structure/mineral_door/resin/Dismantle(devastated = 0)
	cdel(src)

/obj/structure/mineral_door/resin/CheckHardness()
	playsound(loc, "alien_resin_move", 25)
	..()

/obj/structure/mineral_door/resin/Dispose()
	relativewall_neighbours()
	var/turf/U = loc
	spawn(0)
		var/turf/T
		for(var/i in cardinal)
			T = get_step(U, i)
			if(!istype(T)) continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()
	. = ..()

/obj/structure/mineral_door/resin/proc/healthcheck()
	if(src.health <= 0)
		src.Dismantle(1)

/obj/structure/mineral_door/resin/ex_act(severity)

	if(!density)
		severity *= 0.5

	health -= severity
	healthcheck()

	if(src)
		check_resin_support()

	return


/obj/structure/mineral_door/resin/get_explosion_resistance()
	if(density)
		return health //this should exactly match the amount of damage needed to destroy the door
	else
		return 0

//do we still have something next to us to support us?
/obj/structure/mineral_door/resin/proc/check_resin_support()
	var/turf/T
	for(var/i in cardinal)
		T = get_step(src, i)
		if(!T)
			continue
		if(T.density)
			. = 1
			break
		if(locate(/obj/structure/mineral_door/resin) in T)
			. = 1
			break
	if(!.)
		visible_message("<span class = 'notice'>[src] collapses from the lack of support.</span>")
		cdel(src)



/obj/structure/mineral_door/resin/thick
	name = "thick resin door"
	health = 160
	hardness = 2.0


/*
 * Egg
 */
/var/const //for the status var
	BURST = 0
	BURSTING = 1
	GROWING = 2
	GROWN = 3
	DESTROYED = 4

	MIN_GROWTH_TIME = 100 //time it takes for the egg to mature once planted
	MAX_GROWTH_TIME = 150

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
	icon_state = "Egg Growing"
	density = 0
	anchored = 1

	health = 80
	var/list/egg_triggers = list()
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive
	var/on_fire = 0
	var/hivenumber = XENO_HIVE_NORMAL

/obj/effect/alien/egg/New()
	..()
	create_egg_triggers()
	Grow()

/obj/effect/alien/egg/Dispose()
	. = ..()
	delete_egg_triggers()

/obj/effect/alien/egg/ex_act(severity)
	Burst(1)//any explosion destroys the egg.

/obj/effect/alien/egg/attack_alien(mob/living/carbon/Xenomorph/M)

	if(M.hivenumber != hivenumber)
		M.animation_attack_on(src)
		M.visible_message("<span class='xenowarning'>[M] crushes \the [src]","<span class='xenowarning'>You crush \the [src]")
		Burst(1)
		return

	if(!istype(M))
		return attack_hand(M)

	switch(status)
		if(BURST, DESTROYED)
			if(M.caste.can_hold_eggs)
				M.visible_message("<span class='xenonotice'>\The [M] clears the hatched egg.</span>", \
				"<span class='xenonotice'>You clear the hatched egg.</span>")
				playsound(src.loc, "alien_resin_break", 25)
				M.plasma_stored++
				cdel(src)
		if(GROWING)
			M << "<span class='xenowarning'>The child is not developed yet.</span>"
		if(GROWN)
			if(isXenoLarva(M))
				M << "<span class='xenowarning'>You nudge the egg, but nothing happens.</span>"
				return
			M << "<span class='xenonotice'>You retrieve the child.</span>"
			Burst(0)

/obj/effect/alien/egg/proc/Grow()
	set waitfor = 0
	update_icon()
	sleep(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
	if(status == GROWING)
		icon_state = "Egg"
		status = GROWN
		update_icon()
		deploy_egg_triggers()

/obj/effect/alien/egg/proc/create_egg_triggers()
	for(var/i=1, i<=8, i++)
		egg_triggers += new /obj/effect/egg_trigger(src, src)

/obj/effect/alien/egg/proc/deploy_egg_triggers()
	var/i = 1
	var/x_coords = list(-1,-1,-1,0,0,1,1,1)
	var/y_coords = list(1,0,-1,1,-1,1,0,-1)
	var/turf/target_turf
	for(var/atom/trigger in egg_triggers)
		var/obj/effect/egg_trigger/ET = trigger
		target_turf = locate(x+x_coords[i],y+y_coords[i], z)
		if(target_turf)
			ET.loc = target_turf
			i++

/obj/effect/alien/egg/proc/delete_egg_triggers()
	for(var/atom/trigger in egg_triggers)
		egg_triggers -= trigger
		cdel(trigger)

/obj/effect/alien/egg/proc/Burst(kill = 1) //drops and kills the hugger if any is remaining
	set waitfor = 0
	if(kill)
		if(status != DESTROYED)
			delete_egg_triggers()
			status = DESTROYED
			icon_state = "Egg Exploded"
			flick("Egg Exploding", src)
			playsound(src.loc, "sound/effects/alien_egg_burst.ogg", 25)
	else
		if(status == GROWN || status == GROWING)
			status = BURSTING
			delete_egg_triggers()
			icon_state = "Egg Opened"
			flick("Egg Opening", src)
			playsound(src.loc, "sound/effects/alien_egg_move.ogg", 25)
			sleep(10)
			if(loc && status != DESTROYED)
				status = BURST
				var/obj/item/clothing/mask/facehugger/child = new(loc)
				child.hivenumber = hivenumber
				child.leap_at_nearest_target()

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/P)
	..()
	if(P.ammo.flags_ammo_behavior & (AMMO_XENO_ACID|AMMO_XENO_TOX)) return
	health -= P.ammo.damage_type == BURN ? P.damage * 1.3 : P.damage
	healthcheck()
	P.ammo.on_hit_obj(src,P)
	return 1

/obj/effect/alien/egg/update_icon()
	overlays.Cut()
	if(hivenumber && hivenumber <= hive_datum.len)
		var/datum/hive_status/hive = hive_datum[hivenumber]
		if(hive.color)
			color = hive.color
	if(on_fire)
		overlays += "alienegg_fire"

/obj/effect/alien/egg/fire_act()
	on_fire = 1
	if(on_fire)
		update_icon()
		spawn(rand(125, 200))
			cdel(src)

/obj/effect/alien/egg/attackby(obj/item/W, mob/living/user)
	if(health <= 0)
		return

	if(istype(W,/obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = W
		if(F.stat != DEAD)
			switch(status)
				if(BURST)
					if(user)
						visible_message("<span class='xenowarning'>[user] slides [F] back into [src].</span>","<span class='xenonotice'>You place the child back in to [src].</span>")
						user.temp_drop_inv_item(F)
					else
						visible_message("<span class='xenowarning'>[F] crawls back into [src]!</span>") //Not sure how, but let's roll with it for now.
					status = GROWN
					icon_state = "Egg"
					cdel(F)
				if(DESTROYED) user << "<span class='xenowarning'>This egg is no longer usable.</span>"
				if(GROWING,GROWN) user << "<span class='xenowarning'>This one is occupied with a child.</span>"
		else user << "<span class='xenowarning'>This child is dead.</span>"
		return

	if(W.flags_item & NOBLUDGEON)
		return

	user.animation_attack_on(src)
	if(W.attack_verb.len)
		visible_message("<span class='danger'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force
	if(W.w_class < 4 || !W.sharp || W.force < 20) //only big strong sharp weapon are adequate
		damage /= 4
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
	else
		playsound(src.loc, "alien_resin_break", 25)

	health -= damage
	healthcheck()


/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst(1)

/obj/effect/alien/egg/HasProximity(atom/movable/AM as mob|obj)
	if(status == GROWN)
		if(!CanHug(AM) || isYautja(AM) || isSynth(AM)) //Predators are too stealthy to trigger eggs to burst. Maybe the huggers are afraid of them.
			return
		Burst(0)

/obj/effect/alien/egg/flamer_fire_act() // gotta kill the egg + hugger
	Burst(1)


//The invisible traps around the egg to tell it there's a mob right next to it.
/obj/effect/egg_trigger
	name = "egg trigger"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	mouse_opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	var/obj/effect/alien/egg/linked_egg

	New(loc, obj/effect/alien/egg/source_egg)
		..()
		linked_egg = source_egg


/obj/effect/egg_trigger/Crossed(atom/A)
	if(!linked_egg) //something went very wrong
		cdel(src)
	else if(get_dist(src, linked_egg) != 1 || !isturf(linked_egg.loc)) //something went wrong
		loc = linked_egg
	else if(iscarbon(A))
		var/mob/living/carbon/C = A
		linked_egg.HasProximity(C)




/*

TUNNEL

*/


/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/Xeno/effects.dmi'
	icon_state = "hole"

	density = 0
	opacity = 0
	anchored = 1
	unacidable = 1
	layer = RESIN_STRUCTURE_LAYER

	var/tunnel_desc = "" //description added by the hivelord.

	var/health = 140
	var/obj/structure/tunnel/other = null
	var/id = null //For mapping

	New()
		..()
		spawn(5)
			if(id && !other)
				for(var/obj/structure/tunnel/T in structure_list)
					if(T.id == id && T != src && T.other == null) //Found a matching tunnel
						T.other = src
						other = T //Link them!
						break

/obj/structure/tunnel/Dispose()
	if(other)
		other.other = null
		other = null
	. = ..()

/obj/structure/tunnel/examine(mob/user)
	..()
	if(!isXeno(user) && !isobserver(user))
		return

	if(!other)
		user << "<span class='warning'>It does not seem to lead anywhere.</span>"
	else
		var/area/A = get_area(other)
		user << "<span class='info'>It seems to lead to <b>[A.name]</b>.</span>"
		if(tunnel_desc)
			user << "<span class='info'>The Hivelord scent reads: \'[tunnel_desc]\'</span>"

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message("<span class='danger'>[src] suddenly collapses!</span>")
		if(other && isturf(other.loc))
			visible_message("<span class='danger'>[other] suddenly collapses!</span>")
			cdel(other)
			other = null
		cdel(src)

/obj/structure/tunnel/bullet_act(var/obj/item/projectile/Proj)
	return 0

/obj/structure/tunnel/ex_act(severity)
	health -= severity/2
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isXeno(user))
		return ..()
	attack_alien(user)

/obj/structure/tunnel/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!istype(M) || M.stat || M.lying)
		return

	//Prevents using tunnels by the queen to bypass the fog.
	if(ticker && ticker.mode && ticker.mode.flags_round_type & MODE_FOG_ACTIVATED)
		var/datum/hive_status/hive = hive_datum[XENO_HIVE_NORMAL]
		if(!hive.living_xeno_queen)
			M << "<span class='xenowarning'>There is no Queen. You must choose a queen first.</span>"
			r_FAL
		else if(isXenoQueen(M))
			M << "<span class='xenowarning'>There is no reason to leave the safety of the caves yet.</span>"
			r_FAL

	if(M.anchored)
		M << "<span class='xenowarning'>You can't climb through a tunnel while immobile.</span>"
		r_FAL

	var/tunnel_time = 40

	if(M.mob_size == MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = 120

	if(isXenoLarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = 5

	if(!other || !isturf(other.loc))
		M << "<span class='warning'>\The [src] doesn't seem to lead anywhere.</span>"
		return

	var/area/A = get_area(other)

	if(tunnel_time <= 50)
		M.visible_message("<span class='xenonotice'>\The [M] begins crawling down into \the [src].</span>", \
		"<span class='xenonotice'>You begin crawling down into \the [src] to <b>[A.name]</b>.</span>")
	else
		M.visible_message("<span class='xenonotice'>[M] begins heaving their huge bulk down into \the [src].</span>", \
		"<span class='xenonotice'>You begin heaving your monstrous bulk into \the [src] to <b>[A.name]</b>.</span>")

	if(do_after(M, tunnel_time, FALSE, 5, BUSY_ICON_GENERIC))
		if(other && isturf(other.loc)) //Make sure the end tunnel is still there
			M.forceMove(other.loc)
			M.visible_message("<span class='xenonotice'>\The [M] pops out of \the [src].</span>", \
			"<span class='xenonotice'>You pop out through the other side!</span>")
		else
			M << "<span class='warning'>\The [src] ended unexpectedly, so you return back up.</span>"
	else
		M << "<span class='warning'>Your crawling was interrupted!</span>"
