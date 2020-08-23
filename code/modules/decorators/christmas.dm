// define decorator type
/datum/decorator/christmas
	priority = DECORATOR_DAY_SPECIFIC


// define when you wanna decorate
/datum/decorator/christmas/is_active_decor()
	return is_month(12) && (is_day(24) || is_day(25) || is_day(26))

// define who is being decorated
/datum/decorator/christmas/queen/get_decor_types()
	return typesof(/mob/living/carbon/Xenomorph/Queen)

// maybe we want to have screech separate from this. Also good test
/datum/decorator/christmas/queen/screech
	priority = DECORATOR_DAY_SPECIFIC
	
/datum/decorator/christmas/queen/screech/decorate(var/mob/living/carbon/Xenomorph/Queen/queen)
	if(!istype(queen))
		return
	queen.screech_sound_effect = 'sound/voice/alien_queen_xmas.ogg'

/datum/decorator/christmas/queen/hat/decorate(var/mob/living/carbon/Xenomorph/Queen/queen)
	if(!istype(queen))
		return
	//queen.icon_body = 'icons/mob/xenos_old/xenomorph_64x64_christmas.dmi'

// barbed wire changes are added as a whole, so no need to split
/datum/decorator/christmas/barbed_wire/get_decor_types()
	return list(/obj/item/stack/barbed_wire)

/datum/decorator/christmas/barbed_wire/decorate(var/obj/item/stack/barbed_wire/wire)
	if(!istype(wire))
		return
	wire.desc = "A bulbed, festive, and dangerous length of wire."
	wire.attack_verb = list("hit", "whacked", "sliced", "festivized")
	wire.icon = 'icons/obj/items/marine-items_christmas.dmi'
	wire.update_icon()

// helmet definition. Also only a single definition
/datum/decorator/christmas/marine_helmet/get_decor_types()
	return list(/obj/item/clothing/head/helmet/marine)

/datum/decorator/christmas/marine_helmet/decorate(var/obj/item/clothing/head/helmet/marine/helmet)
	if(!istype(helmet))
		return
	helmet.name = "\improper USCM [helmet.specialty] santa hat"
	helmet.desc = "Ho ho ho, Merry Christmas!"
	helmet.icon = 'icons/obj/items/clothing/hats.dmi'
	helmet.icon_override = 'icons/mob/humans/onmob/head_0.dmi'
	helmet.icon_state = "santahat"
	helmet.flags_inventory = BLOCKSHARPOBJ
	helmet.flags_inv_hide = HIDEEARS|HIDEALLHAIR
	helmet.flags_marine_helmet = NO_FLAGS
	helmet.update_icon()

// barricade definition. Also only a single definition
// some types are not represented in that DMI, so we have to cherrypick
/datum/decorator/christmas/barricade/get_decor_types()
	return typesof(/obj/structure/barricade/metal) + typesof(/obj/structure/barricade/plasteel)

/datum/decorator/christmas/barricade/decorate(var/obj/structure/barricade/barricade)
	if(!istype(barricade))
		return
	barricade.icon = 'icons/obj/structures/barricades_christmas.dmi'
	barricade.update_icon()
