/obj/item/weapon/twohanded/st_hammer
	name = "N45 battle hammer"
	desc = "RIP AND TEAR."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "d2_breacher"
	item_state = "d2_breacher"
	force = MELEE_FORCE_STRONG
	flags_item = TWOHANDED
	force_wielded = MELEE_FORCE_VERY_STRONG
	w_class = SIZE_LARGE
	sharp = IS_SHARP_ITEM_BIG
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	unacidable = TRUE
	indestructible = TRUE

	var/move_delay_addition = 1.36

/obj/item/weapon/twohanded/st_hammer/attack(mob/M, mob/user)
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ST)
		to_chat(user, SPAN_HIGHDANGER("[src] is too heavy for you..."))
		return
	..()
	if(flags_item ^ WIELDED && prob(70))
		return
	if(isxeno(M))
		var/mob/living/carbon/xenomorph/X = M
		if(X.tier < 1 && X.tier > 2)
			return
	M.KnockDown(3)
		
/obj/item/weapon/twohanded/st_hammer/pickup(mob/user)
	RegisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))
	..()

/obj/item/weapon/twohanded/st_hammer/proc/handle_movedelay(mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] += move_delay_addition

/obj/item/weapon/twohanded/st_hammer/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY)

/obj/item/weapon/shield/montage
	name = "N30 montage shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon_state = "metal_st"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/back.dmi'
	)
	flags_equip_slot = SLOT_BACK
	passive_block = 65
	readied_block = 100
	force = MELEE_FORCE_TIER_1
	throwforce = MELEE_FORCE_TIER_1
	throw_range = 4
	w_class = SIZE_LARGE
	attack_verb = list("shoved", "bashed", "slash")
	var/cooldown = 0	//shield bash cooldown. based on world.time	
	unacidable = TRUE
	indestructible = TRUE

/obj/item/weapon/shield/montage/IsShield()
	return TRUE

/obj/item/weapon/shield/montage/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/twohanded/st_hammer))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/bang-bang.ogg', 25, FALSE)
			cooldown = world.time
	else
		..()


/obj/item/weapon/shield/montage/marine
	name = "N30-2 standard defensive shield"
	desc = "A heavy shield adept at blocking blunt or sharp objects from connecting with the shield wielder."
	icon_state = "marine_shield"
	flags_equip_slot = SLOT_BACK
	passive_block = 45
	readied_block = 80
	force = MELEE_FORCE_TIER_3
	throwforce = MELEE_FORCE_TIER_1
	throw_range = 4
	w_class = SIZE_LARGE
	attack_verb = list("shoved", "bashed", "slash")
	cooldown = 4	//shield bash cooldown. based on world.time
	unacidable = TRUE
	indestructible = TRUE

/obj/item/weapon/shield/montage/marine/attack(mob/M, mob/user)
	. = ..()
	if(isyautja(M))
		return
	var/mob/living/carbon/xenomorph/X
	if(isxeno(M) && X.tier == 1)
		if(prob(40))
			M.KnockDown(2)
			return
	if(ishuman(M))
		if(prob(20))
			M.KnockOut(15)
