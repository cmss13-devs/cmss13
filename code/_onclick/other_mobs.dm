
/*
	Carbon
*/

/mob/living/carbon/click(var/atom/A, var/list/mods)
	if (mods["shift"] && mods["middle"])
		point_to(A)
		return TRUE

	if (mods["middle"])
		if (isStructure(A) && get_dist(src, A) <= 1)
			var/obj/structure/S = A
			S.do_climb(src, mods)
		else if(!(isitem(A) && get_dist(src, A) <= 1) && client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS)
			swap_hand()
		return TRUE

	return ..()


/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(var/atom/A)
	A.attack_animal(src)

/atom/proc/attack_animal(mob/user as mob)
	return

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/click()
	return 1
