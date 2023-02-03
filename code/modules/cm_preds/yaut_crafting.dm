/// This .dm will contain all yautja craftable items and materials


//=================//\\=================//
/*
				MATERIALS
*/
//=================\\//=================//
/obj/item/xeno_tail
	name = "xenomorph tail" //end user will not see this name anyways
	desc = "The tail of a terrible creature."
	icon_state = "xeno_tail"
//=================//\\=================//
/*
				Crafting
*/
//=================\\//=================//
/obj/item/xeno_tail/attackby(obj/item/stack/rods/object, mob/living/user)
	..()
	var/obj/item/stack/rods/stick = object
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG)) // Humans aint crafting these
		to_chat(user,  SPAN_WARNING("You burn your hand while trying to manipulate the [src],breaking it in the process!"))
		user.emote("scream")
		qdel(src)
		return

	to_chat(user,  SPAN_NOTICE("You try to couple the rod with the [src]."))
	if(do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD, user))
		to_chat(user,  SPAN_NOTICE("You succeed , creating a woobly spear with the [src]."))
		if(stick.use(1))
			var/obj/item/weapon/melee/twohanded/yautja/spear/makeshift/spear = new
			user.put_in_hands(spear)
			qdel(src)
		return
	return

/obj/item/weapon/melee/twohanded/yautja/spear/makeshift/attackby(obj/item/stack/yautja_rope/item, mob/user as mob)
	..()
	var/obj/item/stack/yautja_rope/rope = item
	if(do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD, user))
		to_chat(user, SPAN_NOTICE("You secure the [src] tightly with your rope."))
		if(rope.use(1))
			src.name = "tail spear"
			src.desc = "A makeshift spear made with an alien tail attached to a rod with a durable rope"
			src.icon_state = "spearxeno"
			src.force = MELEE_FORCE_TIER_4
			src.force_wielded = MELEE_FORCE_TIER_7
		return
	return
//=================//\\=================//
/*
				Craftables
*/
//=================\\//=================//
/obj/item/weapon/melee/twohanded/yautja/spear/makeshift
	name = "incomplete tail spear"
	desc = "A makeshift spear made with an alien tail attached to a rod.Requires a durable rope to finish."
	icon_state = "spearxeno_inc"
	item_state = "spearxeno"
	force = MELEE_FORCE_TIER_1
	force_wielded = MELEE_FORCE_TIER_3
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("attacked", "stabbed", "jabbed", "torn", "gored")
