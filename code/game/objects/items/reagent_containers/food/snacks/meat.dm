/obj/item/reagent_container/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	icon = 'icons/obj/items/food/meat.dmi'
	health = 180
	filling_color = "#FF1C1C"
	bitesize = 3
	var/cutlet_type = /obj/item/reagent_container/food/snacks/rawcutlet

/obj/item/reagent_container/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 3)
	name = made_from_player + name

/obj/item/reagent_container/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_ACCURATE || W.sharp == IS_SHARP_ITEM_BIG)
		var/turf/T = get_turf(src)
		var/cutlet_amt = roll(1,4)
		for(var/i in 1 to cutlet_amt)
			new cutlet_type(T)
		to_chat(user, "You slice up the meat.")
		playsound(loc, 'sound/effects/blobattack.ogg', 25, 1)
		qdel(src)
	else
		..()

/obj/item/reagent_container/food/snacks/meat/synthmeat
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/// Meat made from synthetics. Slightly toxic
/obj/item/reagent_container/food/snacks/meat/synthmeat/synthflesh
	name = "synthetic flesh"
	desc = "A slab of artificial, inorganic 'flesh' that resembles human meat. Probably came from a synth."
	icon_state = "synthmeat"
	filling_color = "#ffffff"

/obj/item/reagent_container/food/snacks/meat/synthmeat/synthetic/Initialize()
	. = ..()
	reagents.add_reagent("pacid", 1.5)

/obj/item/reagent_container/food/snacks/meat/human
	name = "human meat"
	desc = "A slab of flesh for cannibals."

/obj/item/reagent_container/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_container/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/obj/item/reagent_container/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A slab of acrid smelling meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/meat/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("xenoblood", 6)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/meat/xenomeat/processed
	desc = "A slab of acrid smelling meat. This one has been processed to remove acid."

/obj/item/reagent_container/food/snacks/meat/xenomeat/processed/Initialize()
	. = ..()
	reagents.remove_reagent("xenoblood", 6)

/obj/item/reagent_container/food/snacks/meat/patty
	name = "patty"
	desc = "A juicy cooked patty, ready to be slapped between two buns."
	icon = 'icons/obj/items/food/food_ingredients.dmi'
	icon_state = "patty"

/obj/item/reagent_container/food/snacks/meat/patty_raw
	name = "raw patty"
	desc = "A raw patty ready to be grilled into a juicy and delicious burger."
	icon = 'icons/obj/items/food/food_ingredients.dmi'
	icon_state = "patty_raw"

/obj/item/reagent_container/food/snacks/meat/patty_raw/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use unique action to shape it into a raw meatball.")

/obj/item/reagent_container/food/snacks/meat/patty_raw/unique_action(mob/user)
	if(..())
		return

	user.visible_message(
		SPAN_NOTICE("[user] shapes [src] into a raw meatball."),
		SPAN_NOTICE("You shape [src] into a raw meatball.")
	)
	playsound(user, 'sound/effects/blobattack.ogg', 50, 1)
	var/obj/item/reagent_container/food/snacks/rawmeatball/M = new(get_turf(user))
	user.drop_held_item(src)
	qdel(src)
	user.put_in_hands(M)

/obj/item/reagent_container/food/snacks/meat/ground_meat
	name = "ground meat"
	desc = "Some meat that has been minced with a processor."
	icon = 'icons/obj/items/food/food_ingredients.dmi'
	icon_state = "groundbeef"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/meat/ground_meat/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use unique action to shape it into a raw meatball.")

/obj/item/reagent_container/food/snacks/meat/ground_meat/unique_action(mob/living/user)
	user.visible_message(
		SPAN_NOTICE("[user] shapes [src] into a ball."),
		SPAN_NOTICE("You shape [src] into a ball of raw ground meat.")
	)
	playsound(user, 'sound/effects/blobattack.ogg', 50, TRUE)
	var/obj/item/reagent_container/food/snacks/rawmeatball/M = new(get_turf(user))
	user.drop_held_item(src)
	qdel(src)
	user.put_in_hands(M)
	return TRUE

//fishable atoms meat
// todo: rewrite this into a procgen'ed item when gutting fish? May be incompatible with recipe code if done that way and not hardcoded.
/obj/item/reagent_container/food/snacks/meat/fish
	name = "fish meat"
	desc = "Meat from a fish."
	icon_state = "fishfillet"
	icon = 'icons/obj/items/food/fish.dmi'

/obj/item/reagent_container/food/snacks/meat/fish/crab
	name = "crab meat"
	desc = "Delicious crab meat."
	icon_state = "crab_meat"

/obj/item/reagent_container/food/snacks/meat/fish/crab/shelled
	name = "crab meat"
	desc = "Delicious crab meat still attached to bits of shell."
	icon_state = "crab_meat_2"

/obj/item/reagent_container/food/snacks/meat/fish/squid
	name = "squid meat"
	desc = "Mmm, calimari."
	icon_state = "squid_meat"


/obj/item/reagent_container/food/snacks/meat/fish/squid/alt
	name = "sock squid meat"
	desc = "Pink squishy meat from a squid or squid like creature. You're no marine biologist."
	icon_state = "squid_meat_2"

/obj/item/reagent_container/food/snacks/meat/fish/bass
	name = "Bass meat"
	desc = "Sizeable hunks of cooking fish!"
	icon_state = "bass_meat"

/obj/item/reagent_container/food/snacks/meat/fish/bluegill
	name = "bluegill meat"
	desc = "Small strips of pan frying meat!"
	icon_state = "bluegill_meat"

/obj/item/reagent_container/food/snacks/meat/fish/salmon

	name = "salmon meat"
	desc = "Considered a 'fancy' cut of fish!"
	icon_state = "salmon_meat"

/obj/item/reagent_container/food/snacks/meat/fish/white_perch

	name = "white perch meat"
	desc = "Meat of an invasive fish, its oily.."
	icon_state = "white_perch_meat"
