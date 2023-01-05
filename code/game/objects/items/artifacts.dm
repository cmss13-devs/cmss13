/obj/item/changestone
	name = "An uncut ruby"
	desc = "The ruby shines and catches the light, despite being uncut"
	icon = 'icons/obj/items/misc.dmi'
	icon_state = "changerock"

/obj/item/changestone/proc/change(/mob/target)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/humantarget = target
	if(H.gender == FEMALE)
		H.gender = MALE
	else
		H.gender = FEMALE
	return TRUE

/obj/item/changestone/attack_hand(var/mob/user as mob)
	change(user)
	..()

/obj/item/changestone/attack(mob/living/M, mob/living/user)
	if(change(user))
		return
	. = ..()

/obj/item/changestone/mob_launch_collision(mob/living/L)
	. = ..()
	change(L)


