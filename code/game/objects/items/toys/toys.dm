/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *      Toy mechs
 *		Crayons
 *		Snap pops
 *		Water flower
 *      Therapy dolls
 *      Inflatable duck
 *		Other things
 */


//recreational items

/obj/item/toy
	icon = 'icons/obj/items/toy.dmi'
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0


/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"

/obj/item/toy/balloon/Initialize()
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE(" You fill the balloon with the contents of [A]."))
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.reaction(user)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, SPAN_NOTICE(" You fill the balloon with the contents of [O]."))
					O.reagents.trans_to(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/launch_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message(SPAN_DANGER("The [src] bursts!"),"You hear a pop and a splash.")
		src.reagents.reaction(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.reaction(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "syndicate balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = SIZE_LARGE

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "beacon"
	item_state = "signaller"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "Gravitational Singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/structures/props/singularity.dmi'
	icon_state = "singularity_s1"



/*
 * Crayons
 */

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = SIZE_TINY
	attack_verb = list("attacked", "coloured")
	var/colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon_state = "snappop"
	w_class = SIZE_TINY

	launch_impact(atom/hit_atom)
		..()
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message(SPAN_DANGER("The [src.name] explodes!"),SPAN_DANGER("You hear a snap!"))
		playsound(src, 'sound/effects/snap.ogg', 25, 1)
		qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		to_chat(M, SPAN_WARNING("You step on the snap pop!"))

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 0, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message(SPAN_DANGER("The [src.name] explodes!"),SPAN_DANGER("You hear a snap!"))
		playsound(src, 'sound/effects/snap.ogg', 25, 1)
		qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "Water Flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	var/empty = 0
	flags

/obj/item/toy/waterflower/Initialize()
	. = ..()
	create_reagents(10)
	reagents.add_reagent("water", 10)

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterflower/afterattack(atom/A as mob|obj, mob/user as mob)

	if (istype(A, /obj/item/storage/backpack ))
		return

	else if (locate (/obj/structure/surface/table, src.loc))
		return

	else if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE(" You refill your flower!"))
		return

	else if (src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_NOTICE(" Your flower has run dry!"))
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(get_turf(src))
		D.name = "water"
		D.icon = 'icons/obj/items/chemistry.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to(D, 1)
		playsound(src.loc, 'sound/effects/spray3.ogg', 15, 1, 3)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.reagents.reaction(get_turf(D))
				for(var/atom/T in get_turf(D))
					D.reagents.reaction(T)
					if(ismob(T) && T:client)
						to_chat(T:client, SPAN_WARNING("[user] has sprayed you with water!"))
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/examine(mob/user)
	..()
	to_chat(user, "[reagents.total_volume] units of water left!")



/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon_state = "ripleytoy"
	var/cooldown = 0

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user as mob)
	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with [src]."))
		playsound(user, 'sound/mecha/mechstep.ogg', 15, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user as mob)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with [src]."))
			playsound(user, 'sound/mecha/mechturn.ogg', 15, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"


/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/11."
	icon_state = "phazonprize"


/obj/item/toy/therapy_red
	name = "red therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is red."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapyred"
	item_state = "egg4" // It's the red egg in items_left/righthand
	w_class = SIZE_TINY

/obj/item/toy/therapy_purple
	name = "purple therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is purple."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapypurple"
	item_state = "egg1" // It's the magenta egg in items_left/righthand
	w_class = SIZE_TINY

/obj/item/toy/therapy_blue
	name = "blue therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is blue."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapyblue"
	item_state = "egg2" // It's the blue egg in items_left/righthand
	w_class = SIZE_TINY

/obj/item/toy/therapy_yellow
	name = "yellow therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is yellow."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapyyellow"
	item_state = "egg5" // It's the yellow egg in items_left/righthand
	w_class = SIZE_TINY

/obj/item/toy/therapy_orange
	name = "orange therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is orange."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapyorange"
	item_state = "egg4" // It's the red one again, lacking an orange item_state and making a new one is pointless
	w_class = SIZE_TINY

/obj/item/toy/therapy_green
	name = "green therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is green."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "therapygreen"
	item_state = "egg3" // It's the green egg in items_left/righthand
	w_class = SIZE_TINY


/obj/item/toy/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/items/clothing/belts.dmi'
	flags_equip_slot = SLOT_WAIST


/obj/item/toy/beach_ball
	name = "beach ball"
	icon_state = "beachball"
	item_state = "beachball"
	density = 0
	anchored = 0
	w_class = SIZE_SMALL
	force = 0.0
	throwforce = 0.0
	throw_speed = SPEED_SLOW
	throw_range = 20

/obj/item/toy/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	user.drop_held_item()
	throw_atom(target, throw_range, throw_speed, user)


/obj/item/toy/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/items/dice.dmi'
	icon_state = "d66"
	w_class = SIZE_TINY
	var/sides = 6
	attack_verb = list("diced")

/obj/item/toy/dice/Initialize()
	. = ..()
	icon_state = "[name][rand(sides)]"

/obj/item/toy/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/toy/dice/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	user.visible_message(SPAN_NOTICE("[user] has thrown [src]. It lands on [result]. [comment]"), \
						 SPAN_NOTICE("You throw [src]. It lands on a [result]. [comment]"), \
						 SPAN_NOTICE("You hear [src] landing on a [result]. [comment]"))





/obj/item/toy/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0
	var/sound_effect = 'sound/items/bikehorn.ogg'

/obj/item/toy/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, sound_effect, 25, 1)
		src.add_fingerprint(user)
		addtimer(VARSET_CALLBACK(src, spam_flag, FALSE), 2 SECONDS)



/obj/item/toy/farwadoll
	name = "Farwa plush doll"
	desc = "A Farwa plush doll. It's soft and comforting!"
	w_class = SIZE_TINY
	icon_state = "farwaplush"
	var/last_hug_time

/obj/item/toy/farwadoll/attack_self(mob/user)
	if(world.time > last_hug_time)
		user.visible_message(SPAN_NOTICE("[user] hugs [src]! How cute! "), \
							 SPAN_NOTICE("You hug [src]. Dawwww... "))
		last_hug_time = world.time + 50 //5 second cooldown

/obj/item/toy/farwadoll/pred
	name = "strange plush doll"
	desc = "A plush doll depicting some sort of tall humanoid biped..?"
	w_class = SIZE_TINY
	icon_state = "predplush"

/obj/item/computer3_part
	name = "computer part"
	desc = "Holy jesus you donnit now"
	gender = PLURAL
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "hdd1"
	w_class = SIZE_SMALL
	crit_fail = 0

/obj/item/computer3_part/toybox
	var/list/prizes = list(	/obj/item/storage/box/snappops			= 2,
							/obj/item/toy/blink								= 2,
							/obj/item/toy/sword								= 2,
							/obj/item/toy/gun								= 2,
							/obj/item/toy/crossbow							= 2,
							/obj/item/clothing/suit/syndicatefake			= 2,
							/obj/item/storage/fancy/crayons			= 2,
							/obj/item/toy/spinningtoy						= 2,
							/obj/item/toy/prize/ripley						= 1,
							/obj/item/toy/prize/fireripley					= 1,
							/obj/item/toy/prize/deathripley					= 1,
							/obj/item/toy/prize/gygax						= 1,
							/obj/item/toy/prize/durand						= 1,
							/obj/item/toy/prize/honk						= 1,
							/obj/item/toy/prize/marauder					= 1,
							/obj/item/toy/prize/seraph						= 1,
							/obj/item/toy/prize/mauler						= 1,
							/obj/item/toy/prize/odysseus					= 1,
							/obj/item/toy/prize/phazon						= 1
							)
