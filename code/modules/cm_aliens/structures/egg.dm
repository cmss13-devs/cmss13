/*
 * Egg
 */

/obj/effect/alien/egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "Egg Growing"
	density = 0
	anchored = 1
	layer = LYING_BETWEEN_MOB_LAYER	//to stop hiding eggs under corpses
	health = 80
	var/list/egg_triggers = list()
	var/status = EGG_GROWING //can be EGG_GROWING, EGG_GROWN, EGG_BURST, EGG_BURSTING, or EGG_DESTROYED; all mutually exclusive
	var/on_fire = FALSE
	var/hivenumber = XENO_HIVE_NORMAL
	var/flags_embryo = NO_FLAGS

/obj/effect/alien/egg/Initialize(mapload, var/hive)
	..()
	create_egg_triggers()
	if (hive)
		hivenumber = hive
	
	set_hive_data(src, hivenumber)
	update_icon()
	Grow()

/obj/effect/alien/egg/Destroy()
	. = ..()
	delete_egg_triggers()

/obj/effect/alien/egg/ex_act(severity)
	Burst(TRUE)//any explosion destroys the egg.

/obj/effect/alien/egg/examine(mob/user)
	. = ..()
	if(isXeno(user) && status == EGG_GROWN)
		to_chat(user, "Ctrl + Click egg to retrieve child into your empty hand if you can carry it.")

/obj/effect/alien/egg/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.hivenumber != hivenumber)
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENOWARNING("[M] crushes \the [src]"),
			SPAN_XENOWARNING("You crush \the [src]"))
		Burst(TRUE)
		return

	if(!istype(M))
		return attack_hand(M)

	switch(status)
		if(EGG_BURST, EGG_DESTROYED)
			if(M.caste.can_hold_eggs)
				M.visible_message(SPAN_XENONOTICE("\The [M] clears the hatched egg."), \
				SPAN_XENONOTICE("You clear the hatched egg."))
				playsound(src.loc, "alien_resin_break", 25)
				M.plasma_stored++
				qdel(src)
		if(EGG_GROWING)
			to_chat(M, SPAN_XENOWARNING("The child is not developed yet."))
		if(EGG_GROWN)
			if(isXenoLarva(M))
				to_chat(M, SPAN_XENOWARNING("You nudge the egg, but nothing happens."))
				return
			to_chat(M, SPAN_XENONOTICE("You retrieve the child."))
			Burst(FALSE)

/obj/effect/alien/egg/clicked(var/mob/user, var/list/mods)
	if(isobserver(user) || get_dist(src, user) > 1)
		return
	var/mob/living/carbon/Xenomorph/X = user
	if(istype(X) && status == EGG_GROWN && mods["ctrl"] && X.caste.can_hold_facehuggers)
		Burst(FALSE, FALSE, X)

	return ..()

/obj/effect/alien/egg/proc/Grow()
	set waitfor = 0
	update_icon()
	sleep(rand(EGG_MIN_GROWTH_TIME, EGG_MAX_GROWTH_TIME))
	if(status == EGG_GROWING)
		icon_state = "Egg"
		status = EGG_GROWN
		update_icon()
		deploy_egg_triggers()

/obj/effect/alien/egg/proc/create_egg_triggers()
	for(var/i in 1 to 8)
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
	QDEL_NULL_LIST(egg_triggers)
	egg_triggers = list()

/obj/effect/alien/egg/proc/Burst(var/kill = TRUE, var/instant_trigger = FALSE, var/mob/living/carbon/Xenomorph/X = null) //drops and kills the hugger if any is remaining
	set waitfor = 0
	if(kill && status != EGG_DESTROYED)
		delete_egg_triggers()
		status = EGG_DESTROYED
		icon_state = "Egg Exploded"
		flick("Egg Exploding", src)
		playsound(src.loc, "sound/effects/alien_egg_burst.ogg", 25)
	else if(status == EGG_GROWN || status == EGG_GROWING)
		status = EGG_BURSTING
		delete_egg_triggers()
		icon_state = "Egg Opened"
		flick("Egg Opening", src)
		playsound(src.loc, "sound/effects/alien_egg_move.ogg", 25)
		sleep(10)
		if(loc && status != EGG_DESTROYED)
			status = EGG_BURST
			var/obj/item/clothing/mask/facehugger/child = new(loc, hivenumber)
			
			child.flags_embryo = flags_embryo
			flags_embryo = NO_FLAGS // Lose the embryo flags when passed on
			
			if(X && X.caste.can_hold_facehuggers && (!X.l_hand || !X.r_hand))	//sanity checks
				X.put_in_hands(child)
				return
			if(instant_trigger)
				child.leap_at_nearest_target()
			else
				child.GoIdle()

/obj/effect/alien/egg/proc/replace_triggers()
	if(isnull(loc) || status == EGG_DESTROYED)
		return
	
	create_egg_triggers()
	deploy_egg_triggers()

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/P)
	..()
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	health -= P.damage
	healthcheck()
	P.ammo.on_hit_obj(src,P)
	return TRUE

/obj/effect/alien/egg/update_icon()
	overlays.Cut()

	if(on_fire)
		overlays += "alienegg_fire"

/obj/effect/alien/egg/fire_act()
	on_fire = TRUE
	if(on_fire)
		update_icon()
		QDEL_IN(src, rand(125, 200))

/obj/effect/alien/egg/attackby(obj/item/W, mob/living/user)
	if(health <= 0)
		return

	if(istype(W,/obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = W
		if(F.stat == DEAD)
			to_chat(user, SPAN_XENOWARNING("This child is dead."))
			return
		switch(status)
			if(EGG_BURST)
				if(user)
					visible_message(SPAN_XENOWARNING("[user] slides [F] back into [src]."), \
						SPAN_XENONOTICE("You place the child back in to [src]."))
					user.temp_drop_inv_item(F)
				else
					visible_message(SPAN_XENOWARNING("[F] crawls back into [src]!")) //Not sure how, but let's roll with it for now.
				status = EGG_GROWN
				icon_state = "Egg"

				flags_embryo = F.flags_embryo

				qdel(F)

				addtimer(CALLBACK(src, .proc/replace_triggers), SECONDS_30)
			if(EGG_DESTROYED)
				to_chat(user, SPAN_XENOWARNING("This egg is no longer usable."))
			if(EGG_GROWING, EGG_GROWN)
				to_chat(user, SPAN_XENOWARNING("This one is occupied with a child."))
		return

	if(W.flags_item & NOBLUDGEON)
		return

	user.animation_attack_on(src)
	if(W.attack_verb.len)
		visible_message(SPAN_DANGER("\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_DANGER("\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]"))
	var/damage = W.force
	if(W.w_class < SIZE_LARGE || !W.sharp || W.force < 20) //only big strong sharp weapon are adequate
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
		Burst(TRUE)

/obj/effect/alien/egg/HasProximity(atom/movable/AM as mob|obj)
	if(status == EGG_GROWN)
		if(!CanHug(AM, hivenumber) || isYautja(AM) || isSynth(AM)) //Predators are too stealthy to trigger eggs to burst. Maybe the huggers are afraid of them.
			return
		Burst(FALSE, TRUE, null)

/obj/effect/alien/egg/flamer_fire_act() // gotta kill the egg + hugger
	Burst(TRUE)


//The invisible traps around the egg to tell it there's a mob right next to it.
/obj/effect/egg_trigger
	name = "egg trigger"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	mouse_opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	var/obj/effect/alien/egg/linked_egg
	var/obj/effect/alien/resin/special/eggmorph/linked_eggmorph

/obj/effect/egg_trigger/New(loc, obj/effect/alien/egg/source_egg, obj/effect/alien/resin/special/eggmorph/source_eggmorph)
	..()
	linked_egg = source_egg
	linked_eggmorph = source_eggmorph


/obj/effect/egg_trigger/Crossed(atom/A)
	if(!linked_egg && !linked_eggmorph) //something went very wrong.
		qdel(src)
	else if(linked_egg && (get_dist(src, linked_egg) != 1 || !isturf(linked_egg.loc))) //something went wrong
		loc = linked_egg

	else if(linked_eggmorph && (get_dist(src, linked_eggmorph) != 1 || !isturf(linked_eggmorph.loc))) //something went wrong
		loc = linked_eggmorph
	else if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(linked_egg)
			linked_egg.HasProximity(C)
		if(linked_eggmorph)
			linked_eggmorph.HasProximity(C)
