/obj/effect/landmark/costume
	icon_state = "costume"

//Costume spawner landmarks
/obj/effect/landmark/costume/random/Initialize() //costume spawner, selects a random subclass and disappears
	. = ..()
	var/list/options = subtypesof(/obj/effect/landmark/costume) - /obj/effect/landmark/costume/random
	var/CHOICE = pick(options)
	new CHOICE(src.loc)
	return INITIALIZE_HINT_QDEL

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/Initialize()
	. = ..()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/reagent_container/food/snacks/egg(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/gladiator/Initialize()
	. = ..()
	new /obj/item/clothing/under/chainshirt/hunter(src.loc)
	new /obj/item/clothing/suit/armor/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/butler/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/prig/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE = pick(/obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/weapon/pole/fancy_cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/pirate/Initialize()
	. = ..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick(/obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana)
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	return INITIALIZE_HINT_QDEL

