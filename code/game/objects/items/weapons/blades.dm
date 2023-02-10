/obj/item/weapon/melee/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9

/obj/item/weapon/melee/claymore/mercsword
	name = "combat sword"
	desc = "A dusty sword commonly seen in historical museums. Where you got this is a mystery, for sure. Only a mercenary would be nuts enough to carry one of these. Sharpened to deal massive damage."
	icon_state = "mercsword"
	item_state = "machete"

/obj/item/weapon/melee/claymore/mercsword/ceremonial
	name = "Ceremonial Sword"
	desc = "A fancy ceremonial sword passed down from generation to generation. Despite this, it has been very well cared for, and is in top condition."
	icon_state = "ceremonial"
	item_state = "machete"

/obj/item/weapon/melee/claymore/mercsword/machete
	name = "\improper M2132 machete"
	desc = "Latest issue of the USCM Machete. Great for clearing out jungle or brush on outlying colonies. Found commonly in the hands of scouts and trackers, but difficult to carry with the usual kit."
	icon_state = "machete"
	w_class = SIZE_LARGE

/obj/item/weapon/melee/claymore/mercsword/machete/arnold
	name = "\improper M2100 \"Ngájhe\" machete"
	desc = "An older issue USCM machete, never left testing. Designed in the Central African Republic. The notching made it hard to clean, and as such the USCM refused to adopt it - despite the superior bludgeoning power offered. Difficult to carry with the usual kit."
	icon_state = "arnold-machete"
	w_class = SIZE_LARGE
	force = MELEE_FORCE_TIER_11

/obj/item/weapon/melee/claymore/hefa
	name = "HEFA sword"
	icon_state = "hefasword"
	item_state = "hefasword"
	desc = "A blade known to be used by the Order of the HEFA, this highly dangerous blade blows up in a shower of shrapnel on impact."
	attack_verb = list("bapped", "smacked", "clubbed")

	var/primed = FALSE

/obj/item/weapon/melee/claymore/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)
	return

/obj/item/weapon/melee/claymore/hefa/attack_self(mob/user)
	..()

	primed = !primed
	var/msg = "You prime \the [src]! It will now explode when you strike someone."
	if(!primed)
		msg = "You de-activate \the [src]!"
	to_chat(user, SPAN_NOTICE(msg))

/obj/item/weapon/melee/claymore/hefa/attack(mob/target, mob/user)
	. = ..()
	if(!primed)
		return

	var/turf/epicenter = get_turf(user)
	epicenter = get_step(epicenter, user.dir)

	var/datum/cause_data/cause_data = create_cause_data(initial(name), user)
	create_shrapnel(epicenter, 48, dir, , /datum/ammo/bullet/shrapnel, cause_data)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(epicenter, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, user.dir, cause_data)
	qdel(src)

/obj/item/weapon/melee/katana
	name = "katana"
	desc = "A finely made Japanese sword, with a well sharpened blade. The blade has been filed to a molecular edge, and is extremely deadly. Commonly found in the hands of mercenaries and yakuza."
	icon_state = "katana"
	flags_atom = FPRINT|CONDUCT
	force = MELEE_FORCE_VERY_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9

//To do: replace the toys.
/obj/item/weapon/melee/katana/replica
	name = "replica katana"
	desc = "A cheap knock-off commonly found in regular knife stores. Can still do some damage."
	force = MELEE_FORCE_WEAK
	throwforce = 7

/obj/item/weapon/melee/throwing_knife
	name ="\improper M11 throwing knife"
	icon='icons/obj/items/weapons/weapons.dmi'
	icon_state = "throwing_knife"
	item_state = "combat_knife"
	desc = "A military knife designed to be thrown at the enemy. Much quieter than a firearm, but requires a steady hand to be used optimally, although you should probably just use a gun instead."
	flags_atom = FPRINT|CONDUCT
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_TIER_1
	w_class = SIZE_SMALL
	throwforce = MELEE_FORCE_TIER_10 //increased by throwspeed to roughly 80
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	flags_equip_slot = SLOT_STORE|SLOT_FACE
	flags_armor_protection = SLOT_FACE

/obj/item/weapon/melee/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "unathiknife"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("ripped", "torn", "cut")
	force = MELEE_FORCE_STRONG
	throwforce = MELEE_FORCE_STRONG
	edge = 1


/obj/item/weapon/melee/pizza_cutter
	name = "\improper PIZZA TIME"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "pizza_cutter"
	item_state = "pizza_cutter"
	desc = "Before you is a holy relic of a bygone era when the great Pizza Lords reigned supreme. You know either that or it's just a big damn pizza cutter."
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_VERY_STRONG
	edge = 1

///For digging shrapnel out of OTHER people, not yourself. Triggered by human/attackby() so target is definitely human. User might not be.
/obj/item/proc/dig_out_shrapnel_check(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(user.a_intent == INTENT_HELP && (target == user || skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))) //Squad medics and above, or yourself
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item, dig_out_shrapnel), target, user)
		return TRUE
	return FALSE

// If no user, it means that the embedded_human is removing it themselves
/obj/item/proc/dig_out_shrapnel(mob/living/carbon/human/embedded_human, mob/living/carbon/human/user = null)
	if(!user)
		user = embedded_human

	if(user.action_busy)
		return

	var/address_mode

	if(user != embedded_human)
		user.affected_message(embedded_human,
			SPAN_NOTICE("You begin examining [embedded_human]'s body for shrapnel."),
			SPAN_NOTICE("[user] begins to examine your body for shrapnel to dig out. Hold still, this will probably hurt..."),
			SPAN_NOTICE("[user] begins to examine [embedded_human]'s body for shrapnel."))
		address_mode = "out of [embedded_human]'s" //includes "out of " to prevent capital-T 'The unknown'.
		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, embedded_human, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			to_chat(user, SPAN_NOTICE("You were interrupted!"))
			return
	else
		user.visible_message(SPAN_NOTICE("[user] starts checking \his body for shrapnel."), \
			SPAN_NOTICE("You begin searching your body for shrapnel."))
		address_mode = "out of your"
		if(!do_after(embedded_human, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			to_chat(user, SPAN_NOTICE("You were interrupted!"))
			return

	var/list/removed_limbs = list()
	for(var/obj/item/shard/S in embedded_human.embedded_items)
		var/obj/limb/organ = S.embedded_organ

		if(!(organ.display_name in removed_limbs))
			removed_limbs += organ.display_name

		S.forceMove(embedded_human.loc)
		organ.implants -= S
		embedded_human.embedded_items -= S
		organ = null
		for(var/i in 1 to S.count-1)
			user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
			var/shrapnel = new S.type(S.loc)
			QDEL_IN(shrapnel, 300)
		user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
		QDEL_IN(S, 300)

	if(length(removed_limbs))
		var/duglimbs = english_list(removed_limbs, final_comma_text = ",")
		user.affected_message(embedded_human,
			SPAN_NOTICE("You dig the shrapnel [address_mode] [duglimbs] with your [src.name]."),
			SPAN_NOTICE("[user] digs the shrapnel out of your [duglimbs] with \his [src.name]."),
			SPAN_NOTICE(user != embedded_human ? "[user] uses \his [src.name] to dig the shrapnel out of [embedded_human]'s [duglimbs]." : "[user] digs the shrapnel out of \his [duglimbs] with \his [src.name]."))

		if(!embedded_human.stat && embedded_human.pain.feels_pain && embedded_human.pain.reduction_pain < PAIN_REDUCTION_HEAVY)
			if(prob(25))
				INVOKE_ASYNC(embedded_human, TYPE_PROC_REF(/mob, emote), "pain")
			else
				INVOKE_ASYNC(embedded_human, TYPE_PROC_REF(/mob, emote), "me", 1, pick("winces.", "grimaces.", "flinches."))

	else
		to_chat(user, SPAN_NOTICE("You couldn't find any shrapnel."))

// Demo and example of a 64x64 weapon.
/obj/item/weapon/melee/ritual
	name = "cool knife"
	desc = "It shines with awesome coding power"
	icon_state = "dark_blade"
	item_state = "dark_blade"
	force = MELEE_FORCE_VERY_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = TRUE
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 7
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_64.dmi'
		)
