//// Powers used by multiple Xenomorphs. 
// In general, powers files hold actual implementations of abilities,
// and abilities files hold the object declarations for the abilities

// Plant weeds
/datum/action/xeno_action/onclick/plant_weeds/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!action_cooldown_check())
		return
	if(!X.check_state()) 
		return
	if(X.burrow) 
		return

	var/turf/T = X.loc

	if(!istype(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	if(!T.is_weedable())
		to_chat(X, SPAN_WARNING("Bad place for a garden!"))
		return

	if(locate(/obj/effect/alien/weeds/node) in T)
		to_chat(X, SPAN_WARNING("There's a pod here already!"))
		return

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T
	if (W && W.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(X, SPAN_WARNING("These weeds are too strong to plant a node on!"))
		return

	var/area/AR = get_area(T)

	if(!(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if (check_and_use_plasma_owner())
		X.visible_message(SPAN_XENONOTICE("\The [X] regurgitates a pulsating node and plants it on the ground!"), \
		SPAN_XENONOTICE("You regurgitate a pulsating node and plant it on the ground!"), null, 5)
		new /obj/effect/alien/weeds/node(X.loc, src, X)

		playsound(X.loc, "alien_resin_build", 25)

	apply_cooldown()
		
	..()
	return

/datum/action/xeno_action/onclick/xeno_resting/use_ability(atom/A)

	var/mob/living/carbon/Xenomorph/X = owner
	if(X.is_mob_incapacitated(TRUE))
		return

	if(X.hardcore)
		to_chat(X, SPAN_WARNING("No time to rest, must KILL!"))
		return

	if(isXenoDefender(X) && X.fortify)
		to_chat(X, SPAN_WARNING("You cannot rest while fortified!"))
		return

	if(isXenoBurrower(X) && X.burrow)
		to_chat(X, SPAN_WARNING("You cannot rest while burrowed!"))
		return

	if(!X.resting)
		X.KnockDown(1) //so that the mob immediately falls over

	X.resting = !X.resting
	to_chat(X, SPAN_NOTICE(" You are now [X.resting ? "resting" : "getting up"]. "))

// Shift spits
/datum/action/xeno_action/onclick/shift_spits/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	for(var/i in 1 to X.caste.spit_types.len)
		if(X.ammo == ammo_list[X.caste.spit_types[i]])
			if(i == X.caste.spit_types.len)
				X.ammo = ammo_list[X.caste.spit_types[1]]
			else
				X.ammo = ammo_list[X.caste.spit_types[i+1]]
			break
	to_chat(X, SPAN_NOTICE("You will now spit [X.ammo.name] ([X.ammo.spit_cost] plasma)."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, "shift_spit_[X.ammo.icon_state]")
	..()
	return


/datum/action/xeno_action/onclick/regurgitate/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_WARNING("You cannot regurgitate here."))
		return

	if(X.stomach_contents.len)
		for(var/mob/living/M in X.stomach_contents)
			// Also has good reason to be a proc on all Xenos
			X.regurgitate(M)
	
	..()
	return

/datum/action/xeno_action/onclick/choose_resin/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return
	switch(X.selected_resin)
		if(RESIN_DOOR)
			X.selected_resin = RESIN_WALL
		if(RESIN_WALL)
			X.selected_resin = RESIN_MEMBRANE
		if(RESIN_MEMBRANE)
			X.selected_resin = RESIN_NEST
		if(RESIN_NEST)
			X.selected_resin = RESIN_STICKY
		if(RESIN_STICKY)
			X.selected_resin = RESIN_FAST
		if(RESIN_FAST)
			X.selected_resin = RESIN_DOOR
		else
			return //something went wrong

	to_chat(X, SPAN_NOTICE("You will now build <b>[X.resin2text(X.selected_resin)]\s</b> when secreting resin."))
	//update the button's overlay with new choice
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, X.resin2text(X.selected_resin))

	..()
	return

// Resin
/datum/action/xeno_action/activable/secrete_resin/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	. = X.build_resin(A, thick, make_message)
	..()
	return

// Destructive Acid
/datum/action/xeno_action/activable/corrosive_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.corrosive_acid(A, acid_type, acid_plasma_cost)
	for(var/obj/item/explosive/plastic/E in A.contents)
		X.corrosive_acid(E,acid_type,acid_plasma_cost)
	..()


/datum/action/xeno_action/onclick/emit_pheromones/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return

	if(X.current_aura)
		X.current_aura = null
		X.visible_message(SPAN_XENOWARNING("\The [X] stops emitting pheromones."), \
		SPAN_XENOWARNING("You stop emitting pheromones."), null, 5)
	else
		
		var/choice = input(X, "Choose a pheromone") in X.caste.aura_allowed + "help" + "cancel"
		if(choice == "help")
			to_chat(X, SPAN_NOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and tackle chance.<br><B>Warding</B> - Increased armor, reduced incoming damage and critical bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br>"))
			return
		if(choice == "cancel" || X.current_aura || !X.check_state(1)) //If they are stacking windows, disable all input
			return
		if (!check_and_use_plasma_owner())
			return
		X.current_aura = choice
		X.visible_message(SPAN_XENOWARNING("\The [X] begins to emit strange-smelling pheromones."), \
		SPAN_XENOWARNING("You begin to emit '[choice]' pheromones."), null, 5)
		playsound(X.loc, "alien_drool", 25)

	if(isXenoQueen(X) && X.hive && X.hive.xeno_leader_list.len && X.anchored)
		for(var/mob/living/carbon/Xenomorph/L in X.hive.xeno_leader_list)
			L.handle_xeno_leader_pheromones()



/datum/action/xeno_action/activable/pounce/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	
	if(!action_cooldown_check())
		return

	if(!A) return

	if(A.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!X.check_state())
		return

	if(X.legcuffed)
		to_chat(X, SPAN_XENODANGER("You can't [ability_name] with that thing on your leg!"))
		return

	if(!check_and_use_plasma_owner())
		return

	if(X.layer == XENO_HIDING_LAYER) //Xeno is currently hiding, unhide him
		X.layer = MOB_LAYER

	if(isXenoRavager(X))
		X.emote("roar")

	if (!tracks_target)
		A = get_turf(A)

	apply_cooldown()

	if (windup)
		if (!windup_interruptable)
			X.frozen = TRUE
			X.anchored = TRUE
			X.update_canmove()

		if (!do_after(X, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENODANGER("You cancel your [ability_name]!"))
			if (!windup_interruptable)
				X.frozen = 0
				X.anchored = 0
				X.update_canmove()
			return

		if (!windup_interruptable)
			X.frozen = 0
			X.anchored = 0
			X.update_canmove()

	X.visible_message(SPAN_XENOWARNING("\The [X] [ability_name]s at [A]!"), SPAN_XENOWARNING("You [ability_name] at [A]!"))

	// ok so basically the way this code works is godawful
	// what happens next is if we hit anything
	// a callback occurs to either the mob_launch_collision or obj_launch_collision procs.
	// those procs poll our action to see if we are 'pouncing'
	var/datum/launch_metadata/LM = new()
	LM.target = A
	LM.range = distance
	LM.speed = throw_speed
	LM.thrower = X
	LM.spin = FALSE
	LM.pass_flags = pounce_pass_flags
	LM.collision_callbacks = pounce_callbacks
	
	X.launch_towards(LM) //Victim, distance, speed

	additional_effects_always()
	..()
	
	return

// Massive, customizable spray_acid
/datum/action/xeno_action/activable/spray_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	
	if(!action_cooldown_check())
		return

	if(!A) return

	if(A.layer >= FLY_LAYER)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!X.check_state() || X.action_busy)
		return

	if (activation_delay)
		if(!do_after(X, activation_delay_length, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENOWARNING("You decide to cancel your acid spray."))
			end_cooldown()
			return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	if(!check_and_use_plasma_owner())
		return

	playsound(get_turf(X), 'sound/effects/refill.ogg', 25, 1)
	X.visible_message(SPAN_XENOWARNING("[X] vomits a flood of acid!"), SPAN_XENOWARNING("You vomit a flood of acid!"), null, 5)

	apply_cooldown()

	// Build our list of target turfs based on 
	if (spray_type == ACID_SPRAY_LINE)
		X.do_acid_spray_line(getline2(X, A, include_from_atom = FALSE), spray_effect_type, spray_distance)

	else if (spray_type == ACID_SPRAY_CONE)
		X.do_acid_spray_cone(get_turf(A), spray_effect_type, spray_distance)
	
	..()
	return

/datum/action/xeno_action/onclick/xenohide/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	if(X.layer != XENO_HIDING_LAYER)
		X.layer = XENO_HIDING_LAYER
		to_chat(X, SPAN_NOTICE("You are now hiding."))
	else
		X.layer = MOB_LAYER
		to_chat(X, SPAN_NOTICE("You have stopped hiding."))


/datum/action/xeno_action/onclick/place_trap/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if (istype(X, /mob/living/carbon/Xenomorph/Burrower))
		var/mob/living/carbon/Xenomorph/Burrower/B = X
		if (B.burrow)
			return 

	if(!X.check_plasma(plasma_cost))
		return
	var/turf/T = get_turf(X)

	if(!istype(T) || !T.is_weedable() || !can_xeno_build(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	var/area/AR = get_area(T)

	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2))
		to_chat(X, SPAN_WARNING("You sense this is not a suitable area for creating a resin hole."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in T

	if(!alien_weeds)
		to_chat(X, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return

	if(alien_weeds.linked_hive.hivenumber != X.hivenumber)
		to_chat(X, SPAN_WARNING("These weeds don't belong to your hive!"))
		return

	if(!X.check_alien_construction(T))
		return

	if(locate(/obj/effect/alien/resin/trap) in orange(1, T))
		to_chat(X, SPAN_XENOWARNING("This is too close to another resin hole!"))
		return

	X.use_plasma(plasma_cost)
	playsound(X.loc, "alien_resin_build", 25)
	new /obj/effect/alien/resin/trap(X.loc, X)
	to_chat(X, SPAN_XENONOTICE("You place a resin hole on the weeds, it still needs a sister to fill it with acid."))