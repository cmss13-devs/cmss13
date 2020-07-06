
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
			S.do_climb(src)
		else
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



/*
	Hell Hound
*/

/mob/living/carbon/hellhound/click(atom/A)
	..()

	if(stat > 0)
		return 1 //Can't click on shit buster!

	if(attack_timer)
		return 1

	if(get_dist(src,A) > 1)
		return 1

	if(istype(A,/mob/living/carbon/human))
		bite_human(A)
	else if(istype(A,/mob/living/carbon/Xenomorph))
		bite_xeno(A)
	else if(istype(A,/mob/living))
		bite_animal(A)
	else
		A.attack_animal(src)

	attack_timer = 1
	spawn(12)
		attack_timer = 0

	return 1