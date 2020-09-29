//Costume spawner landmarks
/obj/effect/landmark/costume/random/Initialize() //costume spawner, selects a random subclass and disappears
	. = ..()
	var/list/options = typesof(/obj/effect/landmark/costume) - /obj/effect/landmark/costume/random
	var/PICK = options[rand(1, options.len)]
	new PICK(src.loc)
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
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/madscientist/Initialize()
	. = ..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/elpresidente/Initialize()
	. = ..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/jackboots(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/butler/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/scratch/Initialize()
	. = ..()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/highlander/Initialize()
	. = ..()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/prig/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/plaguedoctor/Initialize()
	. = ..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/pirate/Initialize()
	. = ..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/commie/Initialize()
	. = ..()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	return INITIALIZE_HINT_QDEL
