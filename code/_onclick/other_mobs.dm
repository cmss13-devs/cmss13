
/*
	Carbon
*/

/mob/living/carbon/click(atom/A, list/mods)
	if (mods["shift"] && mods["middle"])
		point_to(A)
		return TRUE

	if (mods["middle"])
		if (isStructure(A) && get_dist(src, A) <= 1)
			var/obj/structure/S = A
			if(S.climbable)
				S.do_climb(src, mods)
			else if(S.can_buckle)
				S.buckle_mob(src, src)
			return TRUE
		else if(!(isitem(A) && get_dist(src, A) <= 1) && (client && (client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS)))
			swap_hand()
			return TRUE

	return ..()


/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	A.attack_animal(src)

/atom/proc/attack_animal(mob/user as mob)
	return

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/click()
	return
