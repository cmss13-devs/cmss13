/obj/item/stack/sheet
	name = "sheet"
	icon = 'icons/obj/items/stacks.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_righthand.dmi',
	)
	layer = UPPER_ITEM_LAYER
	w_class = SIZE_MEDIUM
	force = 0
	throwforce = 5
	max_amount = 50
	throw_speed = SPEED_VERY_FAST
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	var/perunit = 3750
	var/sheettype = null //this is used for girders in the creation of walls/false walls
