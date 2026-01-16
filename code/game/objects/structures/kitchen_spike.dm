//////Kitchen Spike

/obj/structure/kitchenspike
	name = "a meat spike"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals"
	density = TRUE
	anchored = TRUE
	var/meat = 0
	var/occupied = 0
	var/meattype = 0 // 0 - Nothing, 1 - Monkey, 2 - Xeno

/obj/structure/kitchenspike/attackby(obj/item/grab/G, mob/user)
	if(!istype(G, /obj/item/grab))
		return
	to_chat(user, SPAN_DANGER("They are too big for the spike, try something smaller!"))

// MouseDrop_T(atom/movable/C, mob/user)
// if(istype(C, /obj/mob/carbon/monkey)
// else if(istype(C, /obj/mob/carbon/alien))
// else if(istype(C, /obj/livestock/spesscarp

/obj/structure/kitchenspike/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.occupied)
		if(src.meattype == 1)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/monkey( src.loc )
				to_chat(usr, "You remove some meat from the monkey.")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/monkey(src.loc)
				to_chat(usr, "You remove the last piece of meat from the monkey!")
				src.icon_state = "spike"
				src.occupied = 0
		else if(src.meattype == 2)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/xenomeat( src.loc )
				to_chat(usr, "You remove some meat from the alien.")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/xenomeat(src.loc)
				to_chat(usr, "You remove the last piece of meat from the alien!")
				src.icon_state = "spike"
				src.occupied = 0
