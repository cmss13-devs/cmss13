/obj/item/weapon/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	icon = 'icons/obj/items/weapons/melee/misc.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/misc_weapons_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/misc_weapons_righthand.dmi'
	)
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	w_class = SIZE_MEDIUM

	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/weapon/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/items/food/drinks.dmi'
	icon_state = "broken_bottle"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	item_state = "broken_beer"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/food_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/food_righthand.dmi'
	)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/food/drinks.dmi', "broken")

/obj/item/weapon/broken_bottle/bullet_act(obj/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)

/obj/item/weapon/broken_glass
	name = "broken glass"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/items/food/drinks.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	icon_state = "broken_glass"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	item_state = "shard-glass"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/food/drinks.dmi', "broken")

/obj/item/weapon/broken_glass/bullet_act(obj/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)

/obj/item/weapon/dart
	name = "red throwing dart"
	desc = "A dart. For throwing. This one's red."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "red_dart"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "poked", "attacked")

/obj/item/weapon/dart/green
	name = "green throwing dart"
	desc = "A dart. For throwing. This one's green."
	icon_state = "green_dart"
