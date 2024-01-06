// define decorator type
/datum/decorator/christmas
	priority = DECORATOR_DAY_SPECIFIC


// define when you wanna decorate
/datum/decorator/christmas/is_active_decor()
	return is_month(12) && (is_day(21) || is_day(22) || is_day(23) || is_day(24) || is_day(25) || is_day(26))

// define who is being decorated
/datum/decorator/christmas/queen/get_decor_types()
	return typesof(/mob/living/carbon/xenomorph/queen)

// maybe we want to have screech separate from this. Also good test
/datum/decorator/christmas/queen/screech
	priority = DECORATOR_DAY_SPECIFIC

/datum/decorator/christmas/queen/screech/decorate(mob/living/carbon/xenomorph/queen/queen)
	if(!istype(queen))
		return
	queen.screech_sound_effect_list = list('sound/voice/alien_queen_xmas.ogg','sound/voice/alien_queen_xmas_2.ogg')

/datum/decorator/christmas/queen/hat/decorate(mob/living/carbon/xenomorph/queen/queen)
	if(!istype(queen))
		return
	//queen.icon_body = 'icons/mob/xenos_old/xenomorph_64x64_christmas.dmi'

// barbed wire changes are added as a whole, so no need to split
/datum/decorator/christmas/barbed_wire/get_decor_types()
	return list(/obj/item/stack/barbed_wire)

/datum/decorator/christmas/barbed_wire/decorate(obj/item/stack/barbed_wire/wire)
	if(!istype(wire))
		return
	wire.name = "christmas wire"
	wire.desc = "A bulbed, festive, and dangerous length of wire."
	wire.attack_verb = list("hit", "whacked", "sliced", "festivized")
	wire.icon = 'icons/obj/items/marine-items_christmas.dmi'
	wire.update_icon()

// helmet definition. Also only a single definition
/datum/decorator/christmas/marine_helmet/get_decor_types()
	return list(/obj/item/clothing/head/helmet/marine)

/datum/decorator/christmas/marine_helmet/decorate(obj/item/clothing/head/helmet/marine/helmet)
	if(!istype(helmet))
		return
	helmet.name = "\improper USCM [helmet.specialty] santa hat"
	helmet.desc = "Ho ho ho, Merry Christmas!"
	helmet.icon = 'icons/obj/items/clothing/hats.dmi'
	helmet.icon_override = 'icons/mob/humans/onmob/head_0.dmi'
	helmet.flags_inv_hide = HIDEEARS|HIDEALLHAIR
	helmet.flags_marine_helmet = NO_FLAGS
	helmet.flags_atom |= NO_SNOW_TYPE|NO_NAME_OVERRIDE
	if(prob(50))
		helmet.icon_state = "santa_hat_red"
	else
		helmet.icon_state = "santa_hat_green"
	helmet.update_icon()

// barricade definition. Also only a single definition
// some types are not represented in that DMI, so we have to cherrypick
/datum/decorator/christmas/barricade/get_decor_types()
	return typesof(/obj/structure/barricade/metal) + typesof(/obj/structure/barricade/plasteel)

/datum/decorator/christmas/barricade/decorate(obj/structure/barricade/barricade)
	if(!istype(barricade))
		return
	barricade.wire_icon = 'icons/obj/structures/barricades_christmas.dmi'
	barricade.update_icon()


/// Replaces marine food dispensers contents with more festive MREs
/datum/decorator/christmas/food

/datum/decorator/christmas/food/get_decor_types()
	return list(/obj/structure/machinery/cm_vending/sorted/marine_food)

/datum/decorator/christmas/food/decorate(obj/structure/machinery/cm_vending/sorted/marine_food/dispenser)
	// This happens during atom init before vending init, so we can hotswap the list before it gets processed
	dispenser.listed_products = list(
		list("CHRISTMAS MEALS", -1, null, null), //Jummy Christmas Food
		list("Xmas Prepared Meal (Fruitcake)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas3, VENDOR_ITEM_REGULAR),
		list("Xmas Prepared Meal (Gingerbread Cookies)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas2, VENDOR_ITEM_REGULAR),
		list("Xmas Prepared Meal (Sugar Cookies)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas1, VENDOR_ITEM_REGULAR),

		list("FLASKS", -1, null, null),
		list("Canteen", 10, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("Metal Flask", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("USCM Flask", 5, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
		list("W-Y Flask", 5, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("C92 pattern 'Festivizer' decorator", 10, /obj/item/toy/festivizer, VENDOR_ITEM_REGULAR)
	)

/datum/decorator/christmas/builder_list/get_decor_types()
	return typesof(/mob/living/carbon/xenomorph)

/datum/decorator/christmas/builder_list/decorate(mob/living/carbon/xenomorph/Xeno)
	if(!istype(Xeno))
		return
	LAZYDISTINCTADD(Xeno.resin_build_order, /datum/resin_construction/resin_obj/festivizer)
