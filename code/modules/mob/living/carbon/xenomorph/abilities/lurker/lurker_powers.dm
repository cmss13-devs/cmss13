/datum/action/xeno_action/onclick/lurker_invisibility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	is_invisible = TRUE
	X.update_icons() // callback to make the icon_state indicate invisibility is in lurker/update_icon

	var/min_dist_found = 100000
	for (var/mob/living/carbon/Xenomorph/targetX in living_xeno_list) // O(N) search because theres no faster way
																	  // possibly worstcase O(N^2) because sqrt could be expensive on floats (quirky byond), and ordinary sqrt is in O(N^(1/2))

		if (targetX == X)
			continue
	
		var/curr_dist = get_dist_euclidian(X, targetX)
		if (curr_dist < min_dist_found)
			min_dist_found = curr_dist

	var/nearest_xeno_speed_buff = (min_dist_found/10)*speed_buff_pct_per_ten_tiles*speed_buff_mod_max
	nearest_xeno_speed_buff = Clamp(nearest_xeno_speed_buff, 0, speed_buff_mod_max)

	if (nearest_xeno_speed_buff >= speed_buff_mod_max/2)
		to_chat(X, SPAN_XENODANGER("You can move much faster and remain stealthy at this distance from your allies!"))
	else
		to_chat(X, SPAN_XENODANGER("You can move slightly faster and remain stealthy at this distance from your allies!"))

	X.speed_modifier -= (speed_buff + nearest_xeno_speed_buff)
	curr_speed_buff = (speed_buff + nearest_xeno_speed_buff)
	X.recalculate_speed()

	if (X.mutation_type == LURKER_NORMAL)
		var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
		if (istype(BD))
			BD.on_invisibility()

	// if we go off early, this also works fine.
	invis_timer_id = add_timer(CALLBACK(src, .proc/invisibility_off), duration, TIMER_STOPPABLE)

	// Only resets when invisibility ends
	apply_cooldown_override(1000000000)
	..()
	return

/datum/action/xeno_action/onclick/lurker_invisibility/proc/invisibility_off()
	if (!is_invisible)
		return
	is_invisible = FALSE

	if (invis_timer_id != TIMER_ID_NULL)
		delete_timer(invis_timer_id)
		invis_timer_id = TIMER_ID_NULL
	
	var/mob/living/carbon/Xenomorph/X = owner
	if (istype(X))

		to_chat(X, SPAN_XENOHIGHDANGER("You feel your invisibility end!"))

		X.update_icons()

		X.speed_modifier += curr_speed_buff
		curr_speed_buff = 0
		X.recalculate_speed()

		if (X.mutation_type == LURKER_NORMAL)
			var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
			if (istype(BD))
				BD.on_invisibility_off()

/datum/action/xeno_action/onclick/lurker_invisibility/ability_cooldown_over()
	to_chat(owner, SPAN_XENOHIGHDANGER("You are ready to use your invisibility again!"))
	..()

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	if (X.mutation_type != LURKER_NORMAL)
		return

	var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
	if (istype(BD))
		BD.next_slash_buffed = TRUE

	to_chat(X, SPAN_XENOHIGHDANGER("Your next slash will deal increased damage!"))

	add_timer(CALLBACK(src, .proc/unbuff_slash), buff_duration)
	X.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return
	var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
	if (istype(BD))
		// In case slash has already landed
		if (!BD.next_slash_buffed)
			return
		BD.next_slash_buffed = FALSE

	to_chat(X, SPAN_XENODANGER("You have waited too long, your slash will no longer deal increased damage!"))


