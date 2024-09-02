/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

	recalculate_move_delay = TRUE



/mob/living/Initialize()
	. = ..()

	fire_reagent = new /datum/reagent/napalm/ut()

	attack_icon = image("icon" = 'icons/effects/attacks.dmi',"icon_state" = "", "layer" = 0)

	register_init_signals()
	initialize_incision_depths()
	initialize_pain()
	initialize_stamina()
	GLOB.living_mob_list += src

/mob/living/Destroy()
	GLOB.living_mob_list -= src
	cleanup_status_effects()
	pipes_shown = null

	. = ..()

	attack_icon = null
	QDEL_NULL(fire_reagent)
	QDEL_NULL(pain)
	QDEL_NULL(stamina)
	QDEL_NULL(hallucinations)
	status_effects = null

/// Clear all running status effects assuming deletion
/mob/living/proc/cleanup_status_effects()
	PROTECTED_PROC(TRUE)
	if(length(status_effects))
		for(var/datum/status_effect/S as anything in status_effects)
			if(S?.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S?.be_replaced()

/mob/living/proc/initialize_pain()
	pain = new /datum/pain(src)

/mob/living/proc/initialize_stamina()
	stamina = new /datum/stamina(src)

/mob/living/proc/initialize_incision_depths()
	for(var/location in incision_depths)
		incision_depths[location] = SURGERY_DEPTH_SURFACE

/mob/living/proc/apply_stamina_damage(damage, def_zone, armor_type)
	if(!stamina)
		return

	stamina.apply_damage(damage)

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src //make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(length(H.limbs))
		var/extradam = 0 //added to when organ is at max dam
		for(var/obj/limb/affecting in H.limbs)
			if(!affecting) continue
			if(affecting.take_damage(0, divided_damage+extradam)) //TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired) //get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost // Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
// if(istype(src, /mob/living/carbon/human))
	return temperature



/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(obj/passed_object, recursion = 0)
	var/list/total_contents = list()

	if(passed_object)
		if(recursion > 8)
			debug_log("Recursion went long for get_contents() for [src] ending at the object [passed_object]. Likely object_one is holding object_two which is holding object_one ad naseum.")
			return total_contents

		total_contents += passed_object.contents

		for(var/obj/checked_object in total_contents)
			total_contents += get_contents(checked_object, recursion + 1)

		return total_contents

	total_contents += contents
	for(var/obj/checked_object in total_contents)
		total_contents += get_contents(checked_object, recursion + 1)

	return total_contents

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/get_limbzone_target()
	return rand_zone(zone_selected)



/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(CONFIG_GET(flag/allow_Metadata))
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return

/mob/living/Move(NewLoc, direct)
	if(lying_angle != 0)
		lying_angle_on_movement(direct)
	if (buckled && buckled.loc != NewLoc) //not updating position
		if (!buckled.anchored)
			return buckled.Move(NewLoc, direct)
		else
			return FALSE

	var/atom/movable/pullee = pulling
	if(pullee && get_dist(src, pullee) > 1) //Is the pullee adjacent?
		if(!pullee.clone || (pullee.clone && get_dist(src, pullee.clone) > 2)) //Be lenient with the close
			stop_pulling()
	var/turf/T = loc
	. = ..()
	if(. && pulling && pulling == pullee) //we were pulling a thing and didn't lose it during our move.
		var/data = SEND_SIGNAL(pulling, COMSIG_MOVABLE_PULLED, src)
		if(!(data & COMPONENT_IGNORE_ANCHORED) && pulling.anchored)
			stop_pulling()
			return

		var/pull_dir = get_dir(src, pulling)

		if(grab_level >= GRAB_CARRY)
			switch(grab_level)
				if(GRAB_CARRY)
					var/direction_to_face = EAST

					if(direct & WEST)
						direction_to_face = WEST

					pulling.Move(NewLoc, direction_to_face)
					var/mob/living/pmob = pulling
					if(istype(pmob))
						SEND_SIGNAL(pmob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, direction_to_face, direction_to_face)
				else
					pulling.Move(NewLoc, direct)
		else if(get_dist(src, pulling) > 1 || ((pull_dir - 1) & pull_dir)) //puller and pullee more than one tile away or in diagonal position
			var/pulling_dir = get_dir(pulling, T)
			pulling.Move(T, pulling_dir) //the pullee tries to reach our previous position
			if(pulling && get_dist(src, pulling) > 1) //the pullee couldn't keep up
				stop_pulling()
			else
				var/mob/living/pmob = pulling
				if(istype(pmob))
					SEND_SIGNAL(pmob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, pulling_dir, pulling_dir)
				if(!(flags_atom & DIRLOCK))
					setDir(turn(direct, 180)) //face the pullee

	if(pulledby && get_dist(src, pulledby) > 1)//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src)) //check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.storage_close(src)

	// Check if we're still pulling something
	if(pulling)
		SEND_SIGNAL(pulling, COMSIG_MOB_DRAGGED, src)

	if(back && (back.flags_item & ITEM_OVERRIDE_NORTHFACE))
		update_inv_back()



/mob/proc/resist_grab(moving_resist)
	return //returning 1 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	if(!pulledby)
		return
	// vars for checks of strengh
	var/pulledby_is_strong = HAS_TRAIT(pulledby, TRAIT_SUPER_STRONG)
	var/src_is_strong = HAS_TRAIT(src, TRAIT_SUPER_STRONG)

	if(!pulledby.grab_level && (!pulledby_is_strong || src_is_strong)) // if passive grab, check if puller is stronger than src, and if not, break free
		pulledby.stop_pulling()
		return TRUE

	// Chance for person to break free of grip, defaults to 50.
	var/chance = 50
	if(src_is_strong && !isxeno(pulledby)) // no extra chance to resist warrior grabs
		chance += 30 // you are strong, you can overpower them easier
	if(pulledby_is_strong)
		chance -= 30 // stronger grip
	// above code means that if you are super strong, 80% chance to resist, otherwise, 20 percent. if both are super strong, standard 50.

	if(prob(chance))
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
		visible_message(SPAN_DANGER("[src] has broken free of [pulledby]'s grip!"), max_distance = 5)
		pulledby.stop_pulling()
		return TRUE
	if(moving_resist && client) //we resisted by trying to move
		visible_message(SPAN_DANGER("[src] struggles to break free of [pulledby]'s grip!"), max_distance = 5)
		// +1 delay if super strong, also done as passive grabs would have a modifier of 0 otherwise, causing spam
		if(pulledby_is_strong && !src_is_strong)
			client.next_movement = world.time + (10*(pulledby.grab_level + 1)) + client.move_delay
		else
			client.next_movement = world.time + (10*pulledby.grab_level) + client.move_delay

/mob/living/movement_delay()
	. = ..()

	if (do_bump_delay)
		. += 10
		do_bump_delay = 0

	if (drowsyness > 0)
		. += 6

	if(pulling && pulling.drag_delay && get_pull_miltiplier()) //Dragging stuff can slow you down a bit.
		var/pull_delay = pulling.get_pull_drag_delay() * get_pull_miltiplier()

		var/grab_level_delay = 0
		switch(grab_level)
			if(GRAB_AGGRESSIVE)
				grab_level_delay = 6
			if(GRAB_CHOKE)
				grab_level_delay = 9

		. += max(pull_speed + (pull_delay + reagent_move_delay_modifier) + grab_level_delay, 0) //harder grab makes you slower
	move_delay = .


//the inherent slowdown of the object when pulled
/atom/movable/proc/get_pull_drag_delay()
	. = drag_delay

/obj/structure/closet/bodybag/get_pull_drag_delay()
	if(roller_buckled) //if the pulled bodybag is buckled to a roller bed, we use its drag_delay instead.
		. = roller_buckled.drag_delay
	else
		. = drag_delay

/mob/living/get_pull_drag_delay()
	if(buckled) //if the pulled mob is buckled to an object, we use that object's drag_delay.
		. = buckled.drag_delay
	else
		. = drag_delay

//whether we are slowed when dragging things
/mob/living/proc/get_pull_miltiplier()
	if(!HAS_TRAIT(src, TRAIT_DEXTROUS))
		if(grab_level == GRAB_CARRY)
			return 0.1
		else
			return 1
	else
		return 0

/mob/living/forceMove(atom/destination)
	if(pulling)
		var/pull_dist = get_dist(pulling, destination)
		if(pulling.z != destination?.z || pull_dist < 0 || pull_dist > 1)
			stop_pulling()
	if(pulledby)
		var/pull_dist = get_dist(pulledby, destination)
		if(pulledby.z != destination?.z || pull_dist < 0 || pull_dist > 1)
			pulledby.stop_pulling()
	if(buckled && destination != buckled.loc)
		buckled.unbuckle()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOB_MOVE_OR_LOOK, TRUE, dir, dir)

	if(.)
		reset_view(destination)

/mob/living/Collide(atom/movable/AM)
	if(buckled || now_pushing)
		return

	if(throwing)
		launch_impact(AM)
		return

	if(SEND_SIGNAL(src, COMSIG_LIVING_PRE_COLLIDE, AM) & COMPONENT_LIVING_COLLIDE_HANDLED)
		return

	if(!isliving(AM))
		..()
		return

	now_pushing = TRUE
	var/mob/living/L = AM

	if(L.status_flags & IMMOBILE_ACTION && src.faction == L.faction && src.mob_size <= L.mob_size)
		now_pushing = FALSE
		return

	//Leaping mobs just land on the tile, no pushing, no anything.
	if(status_flags & LEAPING)
		forceMove(L.loc)
		status_flags &= ~LEAPING
		now_pushing = FALSE
		return

	if(L.pulledby && L.pulledby != src && L.is_mob_restrained())
		if(!(world.time % 5))
			to_chat(src, SPAN_WARNING("[L] is restrained, you cannot push past."))
		now_pushing = FALSE
		return

	if(isxeno(L) && !islarva(L))
		var/mob/living/carbon/xenomorph/X = L
		if(X.mob_size >= MOB_SIZE_BIG || (ishuman(src) && !isyautja(src))) // Small xenos can be pushed by other xenos or preds
			now_pushing = FALSE
			return

	if(L.pulling)
		if(ismob(L.pulling))
			var/mob/P = L.pulling
			if(P.is_mob_restrained())
				if(!(world.time % 5))
					to_chat(src, SPAN_WARNING("[L] is restraining [P], you cannot push past."))
				now_pushing = FALSE
				return

	if(ishuman(L))
		if(!(L.status_flags & CANPUSH))
			now_pushing = FALSE
			return

	if(!L.buckled && !L.anchored)
		var/mob_swap
		//the puller can always swap with its victim if on grab intent
		if(L.pulledby == src && a_intent == INTENT_GRAB)
			mob_swap = 1
		//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
		else if((L.is_mob_restrained() || L.a_intent == INTENT_HELP) && (is_mob_restrained() || a_intent == INTENT_HELP))
			mob_swap = 1
		if(mob_swap)
			//switch our position with L
			if(loc && !loc.Adjacent(L.loc))
				now_pushing = FALSE
				return
			var/oldloc = loc
			var/oldLloc = L.loc

			L.add_temp_pass_flags(PASS_MOB_THRU)
			add_temp_pass_flags(PASS_MOB_THRU)

			L.Move(oldloc)
			Move(oldLloc)

			remove_temp_pass_flags(PASS_MOB_THRU)
			L.remove_temp_pass_flags(PASS_MOB_THRU)

			now_pushing = FALSE
			return

	now_pushing = FALSE

	if(!(L.status_flags & CANPUSH))
		return

	..()

/mob/living/launch_towards(datum/launch_metadata/LM)
	if(src)
		SEND_SIGNAL(src, COMSIG_MOB_MOVE_OR_LOOK, TRUE, dir, dir)
	if(!istype(LM) || !LM.target || !src)
		return
	if(buckled)
		LM.invoke_end_throw_callbacks(src)
		return
	if(pulling)
		stop_pulling() //being thrown breaks pulls.
	if(pulledby)
		pulledby.stop_pulling()
	. = ..()

//to make an attack sprite appear on top of the target atom.
/mob/living/proc/flick_attack_overlay(atom/target, attack_icon_state, duration = 4)
	set waitfor = 0

	if(!attack_icon)
		return FALSE

	attack_icon.icon_state = attack_icon_state
	attack_icon.pixel_x = -target.pixel_x
	attack_icon.pixel_y = -target.pixel_y
	target.overlays += attack_icon
	var/old_icon = attack_icon.icon_state
	var/old_pix_x = attack_icon.pixel_x
	var/old_pix_y = attack_icon.pixel_y
	addtimer(CALLBACK(istype(target, /mob/living) ? target : src, /mob/living/proc/finish_attack_overlay, target, old_icon, old_pix_x, old_pix_y), duration)

/mob/living/proc/finish_attack_overlay(atom/target, old_icon, old_pix_x, old_pix_y)
	if(!attack_icon || !target)
		return FALSE

	var/new_icon = attack_icon.icon_state
	var/new_pix_x = attack_icon.pixel_x
	var/new_pix_y = attack_icon.pixel_y
	attack_icon.icon_state = old_icon //necessary b/c the attack_icon can change sprite during the sleep.
	attack_icon.pixel_x = old_pix_x
	attack_icon.pixel_y = old_pix_y

	target.overlays -= attack_icon

	attack_icon.icon_state = new_icon
	attack_icon.pixel_x = new_pix_x
	attack_icon.pixel_y = new_pix_y

/mob/proc/flash_eyes()
	return

/mob/living/flash_eyes(intensity = EYE_PROTECTION_FLASH, bypass_checks, flash_timer = 40, type = /atom/movable/screen/fullscreen/flash, dark_type = /atom/movable/screen/fullscreen/flash/dark)
	if(bypass_checks || (get_eye_protection() < intensity && !(sdisabilities & DISABILITY_BLIND)))
		if(client?.prefs?.flash_overlay_pref == FLASH_OVERLAY_DARK)
			overlay_fullscreen("flash", dark_type)
		else
			overlay_fullscreen("flash", type)
		spawn(flash_timer)
			clear_fullscreen("flash", 20)
		return TRUE

/mob/living/create_clone_movable(shift_x, shift_y)
	..()
	src.clone.hud_list = new /list(length(src.hud_list))
	for(var/h in src.hud_possible) //Clone HUD
		src.clone.hud_list[h] = new /image("loc" = src.clone, "icon" = src.hud_list[h].icon)

/mob/living/update_clone()
	..()
	for(var/h in src.hud_possible)
		src.clone.hud_list[h].icon_state = src.hud_list[h].icon_state

// Note that this might CLASH with handle_regular_status_updates until it is ELIMINATED
// and everything is switched from updates to signaling - due to not accounting for all cases.
// If this proc causes issues you can probably disable it until then.
/mob/living/carbon/update_stat()
	if(stat != DEAD)
		if(health <= HEALTH_THRESHOLD_DEAD)
			death()
			return
		else if(HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)

/mob/living/set_stat(new_stat)
	. = ..()
	if(isnull(.))
		return

	switch(.) //Previous stat.
		if(CONSCIOUS)
			if(stat >= UNCONSCIOUS)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
			add_traits(list(/*TRAIT_HANDS_BLOCKED, */ TRAIT_INCAPACITATED, TRAIT_FLOORED), STAT_TRAIT)
		if(UNCONSCIOUS)
			if(stat >= UNCONSCIOUS)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT) //adding trait sources should come before removing to avoid unnecessary updates
		if(DEAD)
			SEND_SIGNAL(src, COMSIG_MOB_STAT_SET_ALIVE)
//			remove_from_dead_mob_list()
//			add_to_alive_mob_list()

	switch(stat) //Current stat.
		if(CONSCIOUS)
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
			remove_traits(list(/*TRAIT_HANDS_BLOCKED, */ TRAIT_INCAPACITATED, TRAIT_FLOORED, /*TRAIT_CRITICAL_CONDITION*/), STAT_TRAIT)
		if(UNCONSCIOUS)
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
		if(DEAD)
			SEND_SIGNAL(src, COMSIG_MOB_STAT_SET_DEAD)
//			REMOVE_TRAIT(src, TRAIT_CRITICAL_CONDITION, STAT_TRAIT)
//			remove_from_alive_mob_list()
//			add_to_dead_mob_list()
	update_layer() // Force update layers so that lying down works as intended upon death. This is redundant otherwise. Replace this by trait signals

/**
 * Changes the inclination angle of a mob, used by humans and others to differentiate between standing up and prone positions.
 *
 * In BYOND-angles 0 is NORTH, 90 is EAST, 180 is SOUTH and 270 is WEST.
 * This usually means that 0 is standing up, 90 and 270 are horizontal positions to right and left respectively, and 180 is upside-down.
 * Mobs that do now follow these conventions due to unusual sprites should require a special handling or redefinition of this proc, due to the density and layer changes.
 * The return of this proc is the previous value of the modified lying_angle if a change was successful (might include zero), or null if no change was made.
 */
/mob/living/proc/set_lying_angle(new_lying, on_movement = FALSE)
	if(new_lying == lying_angle)
		return
	. = lying_angle
	lying_angle = new_lying
	if(lying_angle != lying_prev)
		update_transform(instant_update = on_movement) // Don't use transition for eg. crawling movement, because we already have the movement glide
		lying_prev = lying_angle

///Called by mob Move() when the lying_angle is different than zero, to better visually simulate crawling.
/mob/living/proc/lying_angle_on_movement(direct)
	if(direct & EAST)
		set_lying_angle(90, on_movement = TRUE)
	else if(direct & WEST)
		set_lying_angle(270, on_movement = TRUE)

///Reports the event of the change in value of the buckled variable.
/mob/living/proc/set_buckled(new_buckled)
	if(new_buckled == buckled)
		return
	SEND_SIGNAL(src, COMSIG_LIVING_SET_BUCKLED, new_buckled)
	. = buckled
	buckled = new_buckled
	if(buckled)
//		if(!HAS_TRAIT(buckled, TRAIT_NO_IMMOBILIZE))
//			ADD_TRAIT(src, TRAIT_IMMOBILIZED, BUCKLED_TRAIT)
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, BUCKLED_TRAIT)
		switch(buckled.buckle_lying)
			if(NO_BUCKLE_LYING) // The buckle doesn't force a lying angle.
				REMOVE_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
			if(0) // Forcing to a standing position.
				REMOVE_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
				set_body_position(STANDING_UP)
				set_lying_angle(0)
			else // Forcing to a lying position.
				ADD_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
				set_body_position(LYING_DOWN)
				set_lying_angle(buckled.buckle_lying)
	else
		remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_FLOORED), BUCKLED_TRAIT)
		if(.) // We unbuckled from something.
			//var/atom/movable/old_buckled = .
			var/obj/old_buckled = . // /tg/ code has buckling defined on /atom/movable - consider refactoring this sometime
			if(old_buckled.buckle_lying == 0 && (resting || HAS_TRAIT(src, TRAIT_FLOORED))) // The buckle forced us to stay up (like a chair)
				set_lying_down() // We want to rest or are otherwise floored, so let's drop on the ground.

/mob/living/proc/get_up(instant = FALSE) // arg ignored
//	set waitfor = FALSE
//	if(!instant && !do_after(src, 1 SECONDS, src, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM), extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob/living, rest_checks_callback)), interaction_key = DOAFTER_SOURCE_GETTING_UP))
//		return
	if(resting || body_position == STANDING_UP || HAS_TRAIT(src, TRAIT_FLOORED))
		return
	set_body_position(STANDING_UP)
	set_lying_angle(0)

/// Change the [body_position] to [LYING_DOWN] and update associated behavior.
/mob/living/proc/set_lying_down(new_lying_angle)
	set_body_position(LYING_DOWN)

/// Proc to append behavior related to lying down.
/mob/living/proc/on_lying_down(new_lying_angle)
//	if(layer == initial(layer)) //to avoid things like hiding larvas.
//		layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	add_traits(list(/*TRAIT_UI_BLOCKED, TRAIT_PULL_BLOCKED,*/ TRAIT_UNDENSE), LYING_DOWN_TRAIT)
	if(HAS_TRAIT(src, TRAIT_FLOORED) && !(dir & (NORTH|SOUTH)))
		setDir(pick(NORTH, SOUTH)) // We are and look helpless.
//	if(rotate_on_lying)
//		body_position_pixel_y_offset = PIXEL_Y_OFFSET_LYING

	// CM legacy canmove procs, replace this with signal procs probably
	drop_l_hand()
	drop_r_hand()
	add_temp_pass_flags(PASS_MOB_THRU)
	update_layer()

/// Updates the layer the mob is on based on its current status. This can result in redundant updates. Replace by trait signals eventually
/mob/living/proc/update_layer()
	//so mob lying always appear behind standing mobs, but dead ones appear behind living ones
	if(pulledby && pulledby.grab_level == GRAB_CARRY)
		layer = ABOVE_MOB_LAYER
	else if (body_position == LYING_DOWN && stat == DEAD)
		layer = LYING_DEAD_MOB_LAYER // Dead mobs should layer under living ones
	else if(body_position == LYING_DOWN && layer == initial(layer)) //to avoid things like hiding larvas. //i have no idea what this means
		layer = LYING_LIVING_MOB_LAYER

/// Called when mob changes from a standing position into a prone while lacking the ability to stand up at the moment.
/mob/living/proc/on_fall()
	return

/// Changes the value of the [living/body_position] variable. Call this before set_lying_angle()
/mob/living/proc/set_body_position(new_value)
	if(body_position == new_value)
		return
	if((new_value == LYING_DOWN) && !(mobility_flags & MOBILITY_LIEDOWN))
		return
	. = body_position
	body_position = new_value
	SEND_SIGNAL(src, COMSIG_LIVING_SET_BODY_POSITION, new_value, .)
	if(new_value == LYING_DOWN) // From standing to lying down.
		on_lying_down()
	else // From lying down to standing up.
		on_standing_up()

/// Proc to append behavior related to lying down.
/mob/living/proc/on_standing_up()
	//if(layer == LYING_MOB_LAYER)
	//	layer = initial(layer)
	remove_traits(list(/*TRAIT_UI_BLOCKED, TRAIT_PULL_BLOCKED,*/ TRAIT_UNDENSE), LYING_DOWN_TRAIT)
	// Make sure it doesn't go out of the southern bounds of the tile when standing.
	//body_position_pixel_y_offset = get_pixel_y_offset_standing(current_size)
	// CM stuff below
	remove_temp_pass_flags(PASS_MOB_THRU)
	if(layer == LYING_DEAD_MOB_LAYER || layer == LYING_LIVING_MOB_LAYER)
		layer = initial(layer)


/// Uses presence of [TRAIT_UNDENSE] to figure out what is the correct density state for the mob. Triggered by trait signal.
/mob/living/proc/update_density()
	if(HAS_TRAIT(src, TRAIT_UNDENSE))
		set_density(FALSE)
	else
		set_density(TRUE)

/// Proc to append behavior to the condition of being floored. Called when the condition starts.
/mob/living/proc/on_floored_start()
	if(body_position == STANDING_UP) //force them on the ground
		set_body_position(LYING_DOWN)
		set_lying_angle(pick(90, 270), on_movement = TRUE)
//		on_fall()


/// Proc to append behavior to the condition of being floored. Called when the condition ends.
/mob/living/proc/on_floored_end()
	if(!resting)
		get_up()


/mob/living/update_transform(instant_update = FALSE)
	var/visual_angle = lying_angle
	if(!rotate_on_lying)
		return
	var/matrix/base = matrix()
	if(pulledby && pulledby.grab_level >= GRAB_CARRY)
		visual_angle = 90 // CM code - for fireman carry
	if(instant_update)
		apply_transform(base.Turn(visual_angle))
	else
		apply_transform(base.Turn(visual_angle), UPDATE_TRANSFORM_ANIMATION_TIME)


// legacy procs
/mob/living/put_in_l_hand(obj/item/W)
	if(body_position == LYING_DOWN)
		return
	return ..()
/mob/living/put_in_r_hand(obj/item/W)
	if(body_position == LYING_DOWN)
		return
	return ..()
