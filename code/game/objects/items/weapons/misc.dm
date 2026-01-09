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
	shield_flags = CAN_SHIELD_BASH

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

/obj/item/weapon/aquilastaff
	name = "Aquila Staff"
	desc = "A large prestigious staff used by Aquilifiers to rally the Roman troops. Can act as a blunt weapon in a pinch but is hard to carry around."
	icon = 'icons/obj/items/weapons/melee/misc_64.dmi'
	icon_state = "aquilastaff"
	item_state = "aquilastaff"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_icons = list(
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/64_weapons_righthand.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/64_weapons_lefthand.dmi'
	)
	flags_equip_slot = NO_FLAGS
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_FAST
	throw_range = 4
	shield_flags = CAN_BLOCK_POUNCE
	w_class = SIZE_MASSIVE
	embeddable = FALSE
	flags_item = ADJACENT_CLICK_DELAY
	attack_verb = list("thwacked", "smacked")
	attack_speed = 1 SECONDS
	shield_type = SHIELD_ABSOLUTE
	shield_chance = SHIELD_CHANCE_MED

/obj/item/weapon/javelin
	name = "Javelin"
	desc = "A large spear used by Roman infantry units. Extremely deadly in the right hands but hard to carry around."
	icon = 'icons/obj/items/weapons/melee/spears.dmi'
	icon_state = "javelin"
	item_state = "javelin"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/64_weapons_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/64_weapons_righthand.dmi'
	)
	flags_equip_slot = NO_FLAGS
	force = MELEE_FORCE_TIER_4
	throwforce = 100 //Does high damage but can't be spammed
	flags_item = ADJACENT_CLICK_DELAY
	sharp = IS_SHARP_ITEM_SIMPLE
	embeddable = FALSE
	w_class = SIZE_MASSIVE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("speared", "stabbed", "impaled")
	attack_speed = 1 SECONDS
	throw_speed = SPEED_VERY_FAST
	throw_range = 0
	shield_type = SHIELD_NONE
	shield_flags = CAN_SHIELD_BASH
	var/javelin_readied = FALSE

/obj/item/weapon/javelin/proc/raise_javelin(mob/user as mob)
	user.visible_message(SPAN_RED("\The [user] raises the [src]."))
	javelin_readied = TRUE
	item_state = "javelin_w"
	force = MELEE_FORCE_TIER_6
	throw_range = 6

/obj/item/weapon/javelin/proc/lower_javelin(mob/user as mob)
	user.visible_message(SPAN_BLUE("\The [user] lowers the [src]."))
	javelin_readied = FALSE
	item_state = "javelin"
	force = MELEE_FORCE_TIER_4
	throw_range = 0

/obj/item/weapon/javelin/proc/toggle_javelin(mob/user as mob)
	if(javelin_readied)
		lower_javelin(user)
	else
		raise_javelin(user)

/obj/item/weapon/javelin/equipped(mob/user, slot)
	if(javelin_readied)
		lower_javelin(user)
	..()

/obj/item/weapon/javelin/attack_self(mob/user)
	if(do_after(user, 3.5 SECONDS, (INTERRUPT_ALL & (~INTERRUPT_MOVED)) , BUSY_ICON_HOSTILE))
		toggle_javelin(user)
	..()
