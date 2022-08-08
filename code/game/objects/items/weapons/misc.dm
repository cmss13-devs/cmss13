/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	w_class = SIZE_MEDIUM

	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/weapon/melee/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "broken_bottle"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	item_state = "broken_beer"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/drinks.dmi', "broken")

/obj/item/weapon/melee/broken_bottle/bullet_act(obj/item/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)

/obj/item/weapon/melee/broken_glass
	name = "broken glass"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/items/drinks.dmi'
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
	var/icon/broken_outline = icon('icons/obj/items/drinks.dmi', "broken")

/obj/item/weapon/melee/broken_glass/bullet_act(obj/item/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)
