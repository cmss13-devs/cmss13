/*
 * Egg
 */

/obj/effect/alien/egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "Egg Growing"
	density = FALSE
	anchored = TRUE
	layer = LYING_BETWEEN_MOB_LAYER
	health = 80
	plane = GAME_PLANE
	var/list/egg_triggers = list()
	var/status = EGG_GROWING //can be EGG_GROWING, EGG_GROWN, EGG_BURST, EGG_BURSTING, or EGG_DESTROYED; all mutually exclusive
	var/on_fire = FALSE
	var/hivenumber = XENO_HIVE_NORMAL
	var/flags_embryo = NO_FLAGS
	/// The weed strength that needs to be maintained in order for this egg to not decay; null disables check
	var/weed_strength_required = WEED_LEVEL_HIVE
	/// Whether to convert/orphan once EGG_BURSTING is complete
	var/convert_on_release = FALSE
	var/huggers_can_spawn = TRUE

/obj/effect/alien/egg/Initialize(mapload, hive)
	. = ..()
	create_egg_triggers()
	if(hive)
		hivenumber = hive

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	set_hive_data(src, hivenumber)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(Grow)), rand(EGG_MIN_GROWTH_TIME, EGG_MAX_GROWTH_TIME))

	var/turf/my_turf = get_turf(src)
	if(my_turf?.weeds && !isnull(weed_strength_required))
		RegisterSignal(my_turf.weeds, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_deletion))

	var/area/area = get_area(src)
	if(area && area.linked_lz)
		AddComponent(/datum/component/resin_cleanup)

/obj/effect/alien/egg/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/// SIGNAL_HANDLER for COMSIG_PARENT_QDELETING of weeds to potentially orphan this egg
/obj/effect/alien/egg/proc/on_weed_deletion()
	SIGNAL_HANDLER

	if(!can_convert())
		return

	// Orphan later?
	if(status == EGG_BURSTING)
		convert_on_release = TRUE
		return

	convert()

/// Whether this egg meets the requirements to convert/orphan
/obj/effect/alien/egg/proc/can_convert()
	if(on_fire)
		return FALSE
	if(status == EGG_DESTROYED)
		return FALSE

	return TRUE

/// Actually converts/orphan this egg
/obj/effect/alien/egg/proc/convert()
	if(!can_convert())
		return

	var/turf/my_turf = get_turf(src)
	var/obj/effect/alien/egg/carrier_egg/orphan/newegg = new(my_turf, hivenumber, weed_strength_required)
	newegg.flags_embryo = flags_embryo
	newegg.fingerprintshidden = fingerprintshidden
	newegg.fingerprintslast = fingerprintslast
	switch(status)
		if(EGG_GROWN)
			newegg.Grow()
		if(EGG_BURSTING, EGG_BURST)
			newegg.status = EGG_BURST
			newegg.hide_egg_triggers()
			newegg.icon_state = "Egg Opened"

	qdel(src)

/obj/effect/alien/egg/Destroy()
	. = ..()
	for(var/obj/effect/egg_trigger/trigger as anything in egg_triggers)
		trigger.linked_egg = null
		trigger.linked_eggmorph = null
		qdel(trigger)
	if(egg_triggers)
		egg_triggers.Cut()
	egg_triggers = null

/obj/effect/alien/egg/ex_act(severity)
	Burst(TRUE)//any explosion destroys the egg.

/obj/effect/alien/egg/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) && status == EGG_GROWN)
		. += "Ctrl + Click egg to retrieve child into your empty hand if you can carry it."
	if(isobserver(user) || isxeno(user) && status == EGG_GROWN)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		var/current_hugger_count = hive.get_current_playable_facehugger_count();
		. += "There are currently [SPAN_NOTICE("[current_hugger_count]")] facehuggers in the hive. The hive can support a total of [SPAN_NOTICE("[hive.playable_hugger_limit]")] facehuggers at present."

/obj/effect/alien/egg/attack_alien(mob/living/carbon/xenomorph/M)
	if(status == EGG_BURST || status == EGG_DESTROYED)
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("[M] clears the hatched egg."),
		SPAN_XENONOTICE("We clear the hatched egg."))
		playsound(src.loc, "alien_resin_break", 25)
		qdel(src)
		return XENO_NONCOMBAT_ACTION

	if(M.hivenumber != hivenumber)
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENOWARNING("[M] crushes \the [src]"),
			SPAN_XENOWARNING("We crush \the [src]"))
		Burst(TRUE)
		return XENO_ATTACK_ACTION

	if(!istype(M))
		return attack_hand(M)

	switch(status)
		if(EGG_GROWING)
			to_chat(M, SPAN_XENOWARNING("The child is not developed yet."))
			return XENO_NO_DELAY_ACTION
		if(EGG_GROWN)
			if(islarva(M))
				to_chat(M, SPAN_XENOWARNING("We nudge the egg, but nothing happens."))
				return
			to_chat(M, SPAN_XENONOTICE("We retrieve the child."))
			Burst(FALSE)
	return XENO_NONCOMBAT_ACTION

/obj/effect/alien/egg/clicked(mob/user, list/mods)
	if(..())
		return TRUE

	if(isobserver(user) || get_dist(src, user) > 1)
		return

	var/mob/living/carbon/xenomorph/X = user
	if(istype(X) && status == EGG_GROWN && mods["ctrl"] && X.caste.can_hold_facehuggers)
		Burst(FALSE, FALSE, X)
		return TRUE

/obj/effect/alien/egg/proc/Grow()
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
	for(var/trigger in egg_triggers)
		var/obj/effect/egg_trigger/ET = trigger
		target_turf = locate(x+x_coords[i],y+y_coords[i], z)
		if(target_turf)
			ET.forceMove(target_turf)
			i++

/obj/effect/alien/egg/proc/hide_egg_triggers()
	for(var/trigger in egg_triggers)
		var/obj/effect/egg_trigger/ET = trigger
		ET.moveToNullspace()

/obj/effect/alien/egg/proc/Burst(kill = TRUE, instant_trigger = FALSE, mob/living/carbon/xenomorph/X = null, is_hugger_player_controlled = FALSE) //drops and kills the facehugger if any is remaining
	if(kill && status != EGG_DESTROYED)
		hide_egg_triggers()
		status = EGG_DESTROYED
		icon_state = "Egg Exploded"
		flick("Egg Exploding", src)
		playsound(loc, "sound/effects/alien_egg_burst.ogg", 25)
	else if(status == EGG_GROWN || status == EGG_GROWING)
		status = EGG_BURSTING
		hide_egg_triggers()
		icon_state = "Egg Opened"
		flick("Egg Opening", src)
		playsound(loc, "sound/effects/alien_egg_move.ogg", 25)
		addtimer(CALLBACK(src, PROC_REF(release_hugger), instant_trigger, X, is_hugger_player_controlled), 1 SECONDS)

/obj/effect/alien/egg/proc/release_hugger(instant_trigger, mob/living/carbon/xenomorph/X, is_hugger_player_controlled = FALSE)
	if(!loc || status == EGG_DESTROYED)
		return

	status = EGG_BURST
	if(is_hugger_player_controlled)
		if(convert_on_release)
			convert()
		return //Don't need to spawn a hugger, a player controls it already!
	var/obj/item/clothing/mask/facehugger/child = new(loc, hivenumber)

	child.flags_embryo = flags_embryo
	flags_embryo = NO_FLAGS // Lose the embryo flags when passed on

	if(X && X.caste.can_hold_facehuggers && (!X.l_hand || !X.r_hand)) //sanity checks
		X.put_in_hands(child)
		if(convert_on_release)
			convert()
		return

	if(instant_trigger)
		if(!child.leap_at_nearest_target())
			child.return_to_egg(src)
	else
		child.go_idle()

	if(convert_on_release)
		convert()

/obj/effect/alien/egg/bullet_act(obj/projectile/P)
	..()
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO))
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
					visible_message(SPAN_XENOWARNING("[user] slides [F] back into [src]."),
						SPAN_XENONOTICE("We place the child back in to [src]."))
					user.temp_drop_inv_item(F)
				else
					visible_message(SPAN_XENOWARNING("[F] crawls back into [src]!")) //Not sure how, but let's roll with it for now.
				status = EGG_GROWN
				icon_state = "Egg"

				flags_embryo = F.flags_embryo

				qdel(F)

				addtimer(CALLBACK(src, PROC_REF(deploy_egg_triggers)), 30 SECONDS)
			if(EGG_DESTROYED)
				to_chat(user, SPAN_XENOWARNING("This egg is no longer usable."))
			if(EGG_GROWING, EGG_GROWN)
				to_chat(user, SPAN_XENOWARNING("This one is occupied with a child."))
		return

	if(W.flags_item & NOBLUDGEON)
		return

	user.animation_attack_on(src)
	if(length(W.attack_verb))
		visible_message(SPAN_DANGER("\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_DANGER("\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]"))
	var/damage = W.force
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
	else
		playsound(src.loc, "alien_resin_break", 25)

	health -= damage
	healthcheck()

	return ATTACKBY_HINT_UPDATE_NEXT_MOVE

/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst(TRUE)

/obj/effect/alien/egg/Crossed(atom/movable/AM)
	HasProximity(AM)

/obj/effect/alien/egg/HasProximity(atom/movable/AM)
	if(status == EGG_GROWN)
		if(!can_hug(AM, hivenumber) || isyautja(AM) || issynth(AM)) //Predators are too stealthy to trigger eggs to burst. Maybe the huggers are afraid of them.
			return
		Burst(FALSE, TRUE, null)

/obj/effect/alien/egg/flamer_fire_act() // gotta kill the egg + hugger
	Burst(TRUE)

/obj/effect/alien/egg/alpha
	hivenumber = XENO_HIVE_ALPHA

/obj/effect/alien/egg/forsaken
	hivenumber = XENO_HIVE_FORSAKEN

/obj/effect/alien/egg/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	if(is_mainship_level(src) && !SSticker.mode.is_in_endgame) // if we're not in hijack don't allow this
		to_chat(user, SPAN_WARNING("The hive's influence doesn't reach that far!"))
		return
	if(status == EGG_GROWING)
		to_chat(user, SPAN_WARNING("\The [src] is still growing, give it some time!"))
		return
	if(status != EGG_GROWN)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	if(!huggers_can_spawn)
		to_chat(user, SPAN_WARNING("This egg cannot support active facehuggers!"))
		return

	if(!GLOB.hive_datum[hivenumber].can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(status != EGG_GROWN)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	GLOB.hive_datum[hivenumber].spawn_as_hugger(user, src)
	Burst(FALSE, FALSE, null, TRUE)

//The invisible traps around the egg to tell it there's a mob right next to it.
/obj/effect/egg_trigger
	name = "egg trigger"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_MAXIMUM
	var/obj/effect/alien/egg/linked_egg
	var/obj/effect/alien/resin/special/eggmorph/linked_eggmorph

/obj/effect/egg_trigger/New(loc, obj/effect/alien/egg/source_egg, obj/effect/alien/resin/special/eggmorph/source_eggmorph)
	..()
	linked_egg = source_egg
	linked_eggmorph = source_eggmorph


/obj/effect/egg_trigger/Crossed(atom/movable/AM)
	if(!linked_egg && !linked_eggmorph) //something went very wrong.
		qdel(src)
	else if(linked_egg && (get_dist(src, linked_egg) != 1 || !isturf(linked_egg.loc))) //something went wrong
		forceMove(linked_egg)
	else if(linked_eggmorph && (get_dist(src, linked_eggmorph) != 1 || !isturf(linked_eggmorph.loc))) //something went wrong
		forceMove(linked_eggmorph)
	else if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(linked_egg)
			linked_egg.HasProximity(C)
		if(linked_eggmorph)
			linked_eggmorph.HasProximity(C)

/*
SPECIAL EGG USED BY EGG CARRIER
*/

#define CARRIER_EGG_UNSUSTAINED_LIFE 1 MINUTES
#define CARRIER_EGG_MAXIMUM_LIFE 5 MINUTES

/obj/effect/alien/egg/carrier_egg
	name = "fragile egg"
	desc = "It looks like a weird, fragile egg."
	weed_strength_required = null
	///Owner of the fragile egg, must be a mob/living/carbon/xenomorph/carrier
	var/mob/living/carbon/xenomorph/carrier/owner = null
	///Time that the carrier was last within refresh range of the egg (14 tiles)
	var/last_refreshed = null
	/// Timer holder for the maximum lifetime of the egg as defined CARRIER_EGG_MAXIMUM_LIFE
	var/life_timer = null
	huggers_can_spawn = FALSE

/obj/effect/alien/egg/carrier_egg/Initialize(mapload, hivenumber, planter = null)
	. = ..()
	last_refreshed = world.time
	if(iscarrier(planter))
		//Die after maximum lifetime
		life_timer = addtimer(CALLBACK(src, PROC_REF(start_unstoppable_decay)), CARRIER_EGG_MAXIMUM_LIFE, TIMER_STOPPABLE)
		set_owner(planter)
	else if(isnull(planter))
		//If we have no owner when created... this really shouldn't happen but start decaying the egg immediately.
		start_unstoppable_decay()

/obj/effect/alien/egg/carrier_egg/Destroy()
	if(life_timer)
		deltimer(life_timer)
	//Remove reference to src in owner's behavior_delegate and set owner to null
	if(owner)
		var/mob/living/carbon/xenomorph/carrier/my_owner = owner
		var/datum/behavior_delegate/carrier_eggsac/behavior = my_owner.behavior_delegate
		behavior.eggs_sustained -= src
		my_owner = null
	return ..()

/// Set the owner of the egg to the planter.
/obj/effect/alien/egg/carrier_egg/proc/set_owner(mob/living/carbon/xenomorph/carrier/planter)
	var/datum/behavior_delegate/carrier_eggsac/my_delegate = planter.behavior_delegate
	my_delegate.eggs_sustained += src
	owner = planter

///Check the last refreshed time and burst the egg if we're over the lifetime of the egg
/obj/effect/alien/egg/carrier_egg/proc/check_decay()
	if(last_refreshed + CARRIER_EGG_UNSUSTAINED_LIFE < world.time)
		start_unstoppable_decay()

///Burst the egg without hugger release after a 10 second timer & remove the life timer.
/obj/effect/alien/egg/carrier_egg/proc/start_unstoppable_decay()
	addtimer(CALLBACK(src, PROC_REF(Burst), TRUE), 10 SECONDS)
	if(life_timer)
		deltimer(life_timer)

/obj/effect/alien/egg/carrier_egg/Burst(kill, instant_trigger, mob/living/carbon/xenomorph/X, is_hugger_player_controlled)
	. = ..()
	if(owner)
		var/datum/behavior_delegate/carrier_eggsac/behavior = owner.behavior_delegate
		behavior.remove_egg_owner(src)
	if(kill && life_timer)
		deltimer(life_timer)

/obj/effect/alien/egg/carrier_egg/on_weed_deletion()
	return

/*
SPECIAL EGG USED WHEN WEEDS LOST
*/

#define ORPHAN_EGG_MAXIMUM_LIFE 6 MINUTES // Should be longer than HIVECORE_COOLDOWN

/obj/effect/alien/egg/carrier_egg/orphan
	huggers_can_spawn = TRUE



/obj/effect/alien/egg/carrier_egg/orphan/Initialize(mapload, hivenumber, weed_strength_required)
	src.weed_strength_required = weed_strength_required

	. = ..()

	if(isnull(weed_strength_required))
		return .

	if(hivenumber != XENO_HIVE_FORSAKEN)
		life_timer = addtimer(CALLBACK(src, PROC_REF(start_unstoppable_decay)), ORPHAN_EGG_MAXIMUM_LIFE, TIMER_STOPPABLE)

	var/my_turf = get_turf(src)
	if(my_turf)
		RegisterSignal(my_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(on_weed_growth))

/// SIGNAL_HANDLER for COMSIG_WEEDNODE_GROWTH to potentially restore this orphan
/obj/effect/alien/egg/carrier_egg/orphan/proc/on_weed_growth()
	SIGNAL_HANDLER

	if(!can_convert())
		return

	// Convert later?
	if(status == EGG_BURSTING)
		convert_on_release = TRUE
		return

	convert()

/obj/effect/alien/egg/carrier_egg/orphan/forsaken_handling()
	. = ..()
	if(life_timer)
		deltimer(life_timer)

/obj/effect/alien/egg/carrier_egg/orphan/can_convert()
	if(!..())
		return FALSE

	// Check weed strength
	if(isnull(weed_strength_required))
		return FALSE
	var/turf/my_turf = get_turf(src)
	var/obj/effect/alien/weeds/weed = my_turf?.weeds
	if(!weed)
		return FALSE
	if(weed.weed_strength < weed_strength_required)
		return FALSE

	return TRUE

/obj/effect/alien/egg/carrier_egg/orphan/convert()
	if(!can_convert())
		return

	var/turf/my_turf = get_turf(src)
	var/obj/effect/alien/egg/newegg = new(my_turf, hivenumber)
	newegg.flags_embryo = flags_embryo
	newegg.fingerprintshidden = fingerprintshidden
	newegg.fingerprintslast = fingerprintslast
	switch(status)
		if(EGG_GROWN)
			newegg.Grow()
		if(EGG_BURSTING, EGG_BURST)
			newegg.status = EGG_BURST
			newegg.hide_egg_triggers()
			newegg.icon_state = "Egg Opened"

	qdel(src)
