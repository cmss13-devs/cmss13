/mob/living/simple_animal/hostile/alien/rotdrone
	name = "Drone"
	desc = "A rotting... thing vaguely reminiscent of a drone. Smells absolutely awful."
	icon = 'icons/mob/xenos/drone.dmi'
	icon_gib = null
	speed = XENO_SPEED_TIER_2
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	// TUpper and lower damage are set to 10 instead of using xeno damage tiers since attack_animal uses apply_damage and for some fucking reason refuses to accept apply_armoured_damage
	move_to_delay = 5
	meat_type = null
	unsuitable_atoms_damage = 5
	faction = FACTION_XENOMORPH
	heat_damage_per_tick = 30
	stop_automated_movement_when_pulled = 1
	break_stuff_probability = 20
	wall_smash = 0
	wander = 0
	stop_automated_movement = 1
	break_stuff_probability = 0
	hud_possible = list(XENO_BANISHED_HUD)
	var/mob/living/carbon/xenomorph/xeno_master // The xeno that spawned the rotdrone
	var/mob/living/carbon/xenomorph/escort // A xeno that they've been ordered to follow
	var/escorting = FALSE // Posterity var to make sure they know they have someone else to follow
	var/got_orders = FALSE // Has the rotdrone recieved an order from their master?
	var/is_fighting = FALSE // Is the rotdrone currently fighting or trying to fight something?
	var/fighting_override = FALSE // Used to keep rotdrones in is_fighting

/mob/living/simple_animal/hostile/alien/rotdrone/prepare_huds()
	. = ..()
	hud_update_projected()
	add_to_all_mob_huds()

/mob/living/simple_animal/hostile/alien/rotdrone/Initialize(mapload, mob/living/carbon/xenomorph/X)
	. = ..()
	if(!istype(X))
		hivenumber = null
	if(hivenumber == null)
		death()
		return
	escort = null
	xeno_master = X
	hivenumber = X.hivenumber
	set_hive_data(src, hivenumber)
	change_real_name(src, "Rotting Drone ([rand(1, 999)])")
	RegisterSignal(X, COMSIG_PARENT_QDELETING, PROC_REF(handle_master_qdel))
	RegisterSignal(escort, COMSIG_PARENT_QDELETING, PROC_REF(handle_escort_qdel))

/mob/living/simple_animal/hostile/alien/rotdrone/proc/handle_master_qdel()
	SIGNAL_HANDLER
	xeno_master = null

/mob/living/simple_animal/hostile/alien/rotdrone/proc/handle_escort_qdel()
	SIGNAL_HANDLER
	escort = null
	escorting = FALSE

/mob/living/simple_animal/hostile/alien/rotdrone/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO
		PF.flags_can_pass_all = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO

/mob/living/simple_animal/hostile/alien/rotdrone/Life()
	. = ..()
	if(get_dist(src, xeno_master) > 3)
		adjustBruteLoss(5)
		if(is_fighting == FALSE)
			if(escort == TRUE && escorting == TRUE && get_dist(src, escort) > 3)
				walk_to(src, escort, rand(1, 2), 4)
			if(got_orders == FALSE && get_dist(src, xeno_master) > 3)
				walk_to(src, xeno_master, rand(1, 2), 4)

	if(escorting == FALSE)
		escort = null
	if(got_orders == FALSE)
		fighting_override = FALSE
	if(fighting_override == TRUE || stance == HOSTILE_STANCE_ATTACKING)
		is_fighting = TRUE
	else if(fighting_override == FALSE)
		is_fighting = FALSE

/mob/living/simple_animal/hostile/alien/rotdrone/death(cause, gibbed, deathmessage = "screeches and collapses as it's body melts back into an inert, rotting ooze...")
	. = ..()
	if(!xeno_master == null)
		to_chat(xeno_master, SPAN_XENOWARNING("We feel that one of our servants has perished!"))

/mob/living/simple_animal/hostile/alien/rotdrone/Destroy()
	remove_from_all_mob_huds()
	. = ..()

/mob/living/simple_animal/hostile/alien/rotdrone/proc/hud_update_projected()
	var/image/holder = hud_list[XENO_BANISHED_HUD]
	holder.icon_state = "xeno_projection"
	hud_list[XENO_BANISHED_HUD] = holder

/mob/living/simple_animal/hostile/alien/rotdrone/Move(atom/new_loc)
	var/d = get_dir(src, new_loc)
	var/is_diagonal = d & (d - 1)
	if(is_diagonal)
		// d1 and d2 are the component directions
		var/d1 = d & (NORTH | SOUTH)
		var/d2 = d & (EAST | WEST)
		// swap d1 and d2 50% of the time so we don't favor any direction
		if(prob(50))
			var/t = d1
			d1 = d2
			d2 = t

		// try moving in the d1 direction
		dir = d1
		if(step(src, d1))
			return 1

		// if that fails, try moving in the d2 direction
		dir = d2
		if(step(src, d2))
			return 1

		return 0

	// if the move wasn't diagonal
	else
		return ..()
