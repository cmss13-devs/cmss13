/obj/item/reagent_container/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
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

/obj/item/reagent_container/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

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
	reagents.add_reagent("xenoblood", 3)
	src.bitesize = 6

//fishable atoms meat
// todo: rewrite this into a procgen'ed item when gutting fish? May be incompatible with recipe code if done that way and not hardcoded.
/obj/item/reagent_container/food/snacks/meat/fish
	name = "fish meat"
	desc = "Meat from a fish."
	icon_state = "fish_meat"
	icon = 'icons/obj/items/fishing_atoms.dmi'

/obj/item/reagent_container/food/snacks/meat/fish/crab
	name = "crab meat"
	desc = "Delicious crab meat."
	icon_state = "crab_meat"

/obj/item/reagent_container/food/snacks/meat/fish/crab/shelled
	name = "crab meat"
	desc = "Delicious crab meat still attached to bits of shell."
	icon_state = "crab_meat_2"

/obj/item/reagent_container/food/snack/meat/fish/squid
	name = "squid meat"
	desc = "Mmm, calimari."
	icon_state = "squid_meat"


/obj/item/reagent_container/food/snack/meat/fish/squid/alt
	name = "sock squid meat"
	desc = "Pink squishy meat from a squid or squid like creature. You're no marine biologist."
	icon_state = "squid_meat_2"

