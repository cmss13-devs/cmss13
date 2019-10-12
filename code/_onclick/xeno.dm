/*
	Xenomorph
*/

/mob/living/carbon/Xenomorph //Makes larger aliens layer 5, so they don't overlap with Trijent's water
	layer = 5
/mob/living/carbon/Xenomorph/Burrower //These three are small enough not to overlap
	layer = 4
/mob/living/carbon/Xenomorph/Runner
	layer = 4
/mob/living/carbon/Xenomorph/Larva
	layer = 4

/mob/living/carbon/Xenomorph/UnarmedAttack(var/atom/A)
	if(lying || burrow) //No attacks while laying down
		return 0
	var/atom/S = A.handle_barriers(src)
	var/mobfound = FALSE
	if(isturf(A))
		var/turf/T = A
		for(var/mob/M in T)
			M.attack_alien(src)
			mobfound = TRUE
			track_slashes(caste_name)
			break
	if(!mobfound)
		S.attack_alien(src)
		track_slashes(caste_name)
	next_move = world.time + (10 + caste.attack_delay) //Adds some lag to the 'attack'
	return 1

/mob/living/carbon/Xenomorph/RangedAttack(var/atom/A)
	..()
	if(directional_attack_toggle)
		for(var/mob/M in get_turf(get_step(src, get_dir(src, A))))
			if (M.Adjacent(src))
				UnarmedAttack(M)
				return
	next_move = world.time + (10 + caste.attack_delay) //Adds some lag to the 'attack'
	return 1

//The parent proc, will default to UnarmedAttack behaviour unless overriden
/atom/proc/attack_alien(mob/user as mob)
	return

/mob/living/carbon/Xenomorph/click(var/atom/A, var/list/mods)

	if (queued_action)
		handle_queued_action(A)
		return 1

	if(mods["middle"] && !mods["shift"])
		if(selected_ability && middle_mouse_toggle)
			selected_ability.use_ability(A)
		return 1

	if (mods["alt"] && mods["shift"])
		if (istype(A, /mob/living/carbon/Xenomorph))
			var/mob/living/carbon/Xenomorph/X = A

			if (X && !X.disposed && X != observed_xeno && X.stat != DEAD && X.z != ADMIN_Z_LEVEL && X.check_state(1))
				if (caste && istype(caste, /datum/caste_datum/queen))
					var/mob/living/carbon/Xenomorph/oldXeno = observed_xeno
					overwatch(X, FALSE, /datum/event_handler/xeno_overwatch_onmovement/queen)
					
					if (oldXeno)
						oldXeno.hud_set_queen_overwatch()
					if (X && !X.disposed)
						X.hud_set_queen_overwatch()

				else
					overwatch(X)
				
				next_move = world.time + 3 // Some minimal delay so this isn't crazy spammy
				return 1

	if(mods["shift"] && !mods["middle"])
		if(selected_ability && !middle_mouse_toggle)
			selected_ability.use_ability(A)
		return 1

	if(next_move >= world.time)
		return 1
	
	return ..()

/mob/living/carbon/Xenomorph/Boiler/click(var/atom/A, var/list/mods)
	if(!istype(A,/obj/screen))
		if(is_zoomed && !is_bombarding)
			zoom_out()
			return 1

		if(is_bombarding)
			if(isturf(A))
				bomb_turf(A)
			else if(isturf(get_turf(A)))
				bomb_turf(get_turf(A))
			if(client)
				client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
			return 1

	if (queued_action)
		handle_queued_action()
		return 1

	if(mods["middle"] && !mods["shift"])
		if (selected_ability && middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	if(mods["shift"])
		if (selected_ability && !middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	return ..()

/mob/living/carbon/Xenomorph/Crusher/click(var/atom/A, var/list/mods)
	if(!istype(A, /obj/screen))
		if(is_charging)
			stop_momentum(charge_dir)

	if (queued_action)
		handle_queued_action()
		return 1

	if(mods["middle"] && !mods["shift"])
		if(selected_ability && middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	if(mods["shift"])
		if(selected_ability && !middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	return ..()

/mob/living/carbon/Xenomorph/Larva/UnarmedAttack(var/atom/A, var/list/mods)

	if(lying) //No attacks while laying down
		return 0

	A.attack_larva(src)
	next_move = world.time + (10 + caste.attack_delay) //Adds some lag to the 'attack'

//Larva attack, will default to attack_alien behaviour unless overriden
/atom/proc/attack_larva(mob/living/carbon/Xenomorph/Larva/user)
	return attack_alien(user)
