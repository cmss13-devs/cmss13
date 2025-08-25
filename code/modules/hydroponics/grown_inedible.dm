// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown things that are not edible
	name = "grown_weapon"
	icon = 'icons/obj/items/harvest.dmi'
	var/plantname
	var/potency = 1

/obj/item/grown/Initialize()
	. = ..()

	create_reagents(50)

	// Fill the object up with the appropriate reagents.
	if(!isnull(plantname))
		var/datum/seed/S = GLOB.seed_types[plantname]
		if(!S || !S.chems)
			return

		potency = S.potency

		for(var/rid in S.chems)
			var/list/reagent_data = S.chems[rid]
			var/rtotal = reagent_data[1]
			if(length(reagent_data) > 1 && potency > 0)
				rtotal += floor(potency/reagent_data[2])
			reagents.add_reagent(rid,max(1,rtotal))

/obj/item/grown/log
	name = "towercap"
	name = "tower-cap log"
	desc = "It's better than bad, it's good!"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "logs"
	force = 5
	flags_atom = NO_FLAGS
	throwforce = 5
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 3

	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/grown/log/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_BIG)
		user.show_message(SPAN_NOTICE("You make planks out of \the [src]!"), SHOW_MESSAGE_VISIBLE)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/sheet/wood/NG = new (user.loc)
			for (var/obj/item/stack/sheet/wood/G in user.loc)
				if(G==NG)
					continue
				if(G.amount>=G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(usr, "You add the newly-formed wood to the stack. It now contains [NG.amount] planks.")
		qdel(src)
		return

/obj/item/grown/sunflower // FLOWER POWER!
	plantname = "sunflowers"
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	damtype = "fire"
	force = 0
	flags_atom = NO_FLAGS
	throwforce = 1
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 3

/obj/item/grown/sunflower/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='green'><b> [user] smacks you with a sunflower!</font><font color='yellow'><b>FLOWER POWER<b></font>")
	to_chat(user, "<font color='green'> Your sunflower's </font><font color='yellow'><b>FLOWER POWER</b></font><font color='green'> strikes [M]</font>")

/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = SIZE_SMALL
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/corncob/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_ACCURATE)
		to_chat(user, SPAN_NOTICE("You use [W] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()
