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

/obj/item/weapon/melee/claymore/hefa/attack_self(var/mob/user)
	..()

	primed = !primed
	var/msg = "You prime \the [src]! It will now explode when you strike someone."
	if(!primed)
		msg = "You de-activate \the [src]!"
	to_chat(user, SPAN_NOTICE(msg))

/obj/item/weapon/melee/claymore/hefa/attack(var/mob/target, var/mob/user)
	. = ..()
	if(!primed)
		return

	var/turf/epicenter = get_turf(user)
	epicenter = get_step(epicenter, user.dir)

	create_shrapnel(epicenter, 48, dir, , /datum/ammo/bullet/shrapnel, initial(name), user)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(epicenter, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, user.dir, initial(name), user)
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
	throwforce = MELEE_FORCE_TIER_11 //increased by throwspeed to roughly 80
	throw_speed = SPEED_REALLY_FAST
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
	desc = "Before you is holy relic of a bygone era when the great Pizza Lords reigned supreme. You know either that or it's just a big damn pizza cutter."
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_VERY_STRONG
	edge = 1


/obj/item/weapon/melee/yautja_knife
	name = "ceremonial dagger"
	desc = "A viciously sharp dagger enscribed with ancient Yautja markings. Smells thickly of blood. Carried by some hunters."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "predknife"
	item_state = "knife"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_STORE
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_TIER_5
	w_class = SIZE_TINY
	throwforce = MELEE_FORCE_TIER_4
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	actions_types = list(/datum/action/item_action)
	unacidable = TRUE

/obj/item/weapon/melee/yautja_knife/attack_self(mob/living/carbon/human/user)
	if(!isYautja(user))
		return
	if(!hasorgans(user))
		return

	dig_out_shrapnel(user)

/obj/item/weapon/melee/yautja_knife/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()


/obj/item/proc/dig_out_shrapnel_check(var/mob/living/target, var/mob/living/carbon/human/user) //for digging shrapnel out of OTHER people, not yourself
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC) && ishuman(user) && ishuman(target) && user.a_intent == INTENT_HELP) //Squad medics and above
		INVOKE_ASYNC(src, /obj/item.proc/dig_out_shrapnel, target, user)
		return TRUE
	return FALSE


// If no user, it means that the embedded_human is removing it themselves
/obj/item/proc/dig_out_shrapnel(var/mob/living/carbon/human/embedded_human, var/mob/living/carbon/human/user = null)
	if(!istype(embedded_human))
		return

	var/mob/living/carbon/human/H = embedded_human
	var/mob/living/carbon/human/H_user = embedded_human

	if(user)
		H_user = user

	if(H_user.action_busy)
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You begin using [src] to rip shrapnel out of [embedded_human]."))
		if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, H, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			to_chat(H_user, SPAN_NOTICE("You were interrupted!"))
			return
	else
		to_chat(H, SPAN_NOTICE("You begin using [src] to rip shrapnel out. Hold still. This will probably hurt..."))
		if(!do_after(H, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			to_chat(H_user, SPAN_NOTICE("You were interrupted!"))
			return

	var/no_shards = TRUE
	for (var/obj/item/shard/S in embedded_human.embedded_items)
		var/obj/limb/organ = S.embedded_organ
		if(S.count > 1)
			to_chat(embedded_human, SPAN_NOTICE("You remove all the [S] stuck in the [organ.display_name]."))
		else
			to_chat(embedded_human, SPAN_NOTICE("You remove [S] from the [organ.display_name]."))
		S.forceMove(embedded_human.loc)
		organ.implants -= S
		embedded_human.embedded_items -= S
		no_shards = FALSE
		organ = null
		for(var/i in 1 to S.count-1)
			H_user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
			var/shrapnel = new S.type(S.loc)
			QDEL_IN(shrapnel, 300)
		H_user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
		QDEL_IN(S, 300)

	if(no_shards)
		to_chat(H_user, SPAN_NOTICE("You couldn't find any shrapnel."))
		return

	to_chat(H_user, SPAN_NOTICE("You dig out all the shrapnel you can find."))
