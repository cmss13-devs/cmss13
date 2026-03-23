/*
Contains all your recreational stuff,
like, matches
i guess
*/

/obj/item/storage/box/pride
	name = "box of prideful crayons"
	desc = "A box of every flavor of pride."
	storage_slots = 8
	w_class = SIZE_TINY // who wouldnt wanna have a box of gayons on their person??

/obj/item/storage/box/pride/fill_preset_inventory()
	new /obj/item/toy/crayon/pride/gay(src)
	new /obj/item/toy/crayon/pride/lesbian(src)
	new /obj/item/toy/crayon/pride/bi(src)
	new /obj/item/toy/crayon/pride/ace(src)
	new /obj/item/toy/crayon/pride/pan(src)
	new /obj/item/toy/crayon/pride/trans(src)
	new /obj/item/toy/crayon/pride/enby(src)
	new /obj/item/toy/crayon/pride/fluid(src)

/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "spbox"
	max_storage_space = 8

/obj/item/storage/box/snappops/fill_preset_inventory()
	for(var/i in 1 to max_storage_space)
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/items/smoking/matches.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/smoking_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/smoking_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/smoking.dmi'
		)
	icon_state = "matchbox"
	item_state = "matchbox"
	item_state_slots = list(WEAR_AS_GARB = "matches")
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_WAIST
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB

/obj/item/storage/box/matches/fill_preset_inventory()
	for(var/i in 1 to max_storage_space)
		new /obj/item/tool/match(src)

/obj/item/storage/box/matches/attackby(obj/item/tool/match/stick, mob/user)
	if(istype(stick) && !stick.heat_source && !stick.burnt)
		stick.light_match(user)
		return
	return ..() // ok

/obj/item/storage/box/stompers
	name = "\improper Reebok shoe box"
	desc = "A fancy shoe box with reflective surface and Weyland-Yutani logo on top, says 'Reebok Stompers' on the back."
	icon_state = "stomper_box"
	item_state = "stomper_box"
	bypass_w_limit = /obj/item/clothing/shoes
	max_storage_space = 3 // i guess??

/obj/item/storage/box/stompers/fill_preset_inventory()
	new /obj/item/clothing/shoes/stompers(src)

/obj/item/storage/box/stompers/update_icon()
	if(!length(contents))
		icon_state = "stomper_box_e"
	else
		icon_state = "stomper_box"
