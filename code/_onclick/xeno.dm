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
			break
	if(!mobfound)
		S.attack_alien(src)
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
	return user.UnarmedAttack(src)

/mob/living/carbon/Xenomorph/click(var/atom/A, var/list/mods)
	if(next_move >= world.time)
		return 1

	if(mods["middle"] && !mods["shift"])
		if(selected_ability && middle_mouse_toggle)
			selected_ability.use_ability(A)
		return 1

	if(mods["shift"] && !mods["middle"])
		if(selected_ability && !middle_mouse_toggle)
			selected_ability.use_ability(A)
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

/mob/living/carbon/Xenomorph/Queen/click(var/atom/A, var/list/mods)

	if(mods["ctrl"] && mods["middle"])
		if(ovipositor)
			if(isXeno(A) && A != src)
				var/mob/living/carbon/Xenomorph/X = A
				if(X.stat != DEAD)
					set_queen_overwatch(A)
					return 1

	if(mods["middle"] && !mods["shift"])
		if (selected_ability && middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	if(mods["shift"])
		if(selected_ability && !middle_mouse_toggle)
			selected_ability.use_ability(A)
			return 1

	return ..()
