/obj/item/changestone
	name = "An uncut ruby"
	desc = "The ruby shines and catches the light, despite being uncut."
	icon = 'icons/obj/items/misc.dmi'
	icon_state = "changerock"

/obj/item/changestone/proc/change(mob/target)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/humantarget = target
	if(humantarget.gender == FEMALE)
		humantarget.gender = MALE
	else
		humantarget.gender = FEMALE
	humantarget.visible_message(SPAN_NOTICE("[humantarget] changes in a way you can't quite pinpoint."), SPAN_NOTICE("You feel different."))
	return TRUE

/obj/item/changestone/attack_hand(mob/user as mob)
	change(user)
	. = ..()

/obj/item/changestone/attack(mob/living/M, mob/living/user)
	if(change(user))
		return
	. = ..()

/obj/item/changestone/mob_launch_collision(mob/living/L)
	. = ..()
	change(L)


