/obj/item/weapon/sword
	name = "combat sword"
	desc = "A dusty sword commonly seen in historical museums. Where you got this is a mystery, for sure. Only a mercenary would be nuts enough to carry one of these. Sharpened to deal massive damage."
	icon_state = "mercsword"
	item_state = "mercsword"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/swords_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/swords_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/misc.dmi'
	)
	icon = 'icons/obj/items/weapons/melee/swords.dmi'
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9

/obj/item/weapon/sword/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"

/obj/item/weapon/sword/ceremonial
	name = "Ceremonial Sword"
	desc = "A fancy ceremonial sword passed down from generation to generation. Despite this, it has been very well cared for, and is in top condition."
	icon_state = "ceremonial"
	item_state = "ceremonial"

/obj/item/weapon/sword/machete
	name = "\improper M2132 machete"
	desc = "Latest issue of the USCM Machete. Great for clearing out jungle or brush on outlying colonies. Found commonly in the hands of scouts and trackers, but difficult to carry with the usual kit."
	icon_state = "machete"
	item_state = "machete"

/obj/item/weapon/sword/machete/attack_self(mob/user)
	if(user.action_busy)
		return

	var/turf/root = get_turf(user)
	var/facing = user.dir
	var/turf/in_front = get_step(root, facing)

	// We check the tile in front of us, if it has flora that can be cut we will attempt to cut it
	for(var/obj/structure/flora/target in in_front)
		if(target.cut_level > 1)
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return
			target.attackby(src, user)

	return ..()

/obj/item/weapon/sword/machete/arnold
	name = "\improper M2100 \"Ngájhe\" machete"
	desc = "An older issue USCM machete, never left testing. Designed in the Central African Republic. The notching made it hard to clean, and as such the USCM refused to adopt it - despite the superior bludgeoning power offered. Difficult to carry with the usual kit."
	icon_state = "arnold-machete"
	item_state = "arnold-machete"
	force = MELEE_FORCE_TIER_11

/obj/item/weapon/sword/hefa
	name = "HEFA sword"
	icon_state = "hefasword"
	item_state = "hefasword"
	desc = "A blade known to be used by the Order of the HEFA, this highly dangerous blade blows up in a shower of shrapnel on impact."
	attack_verb = list("bapped", "smacked", "clubbed")

	var/primed = FALSE

/obj/item/weapon/sword/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)
	return

/obj/item/weapon/sword/hefa/attack_self(mob/user)
	..()

	primed = !primed
	var/msg = "You prime \the [src]! It will now explode when you strike someone."
	if(!primed)
		msg = "You de-activate \the [src]!"
	to_chat(user, SPAN_NOTICE(msg))

/obj/item/weapon/sword/hefa/attack(mob/target, mob/user)
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

/obj/item/weapon/sword/katana
	name = "katana"
	desc = "A finely made Japanese sword, with a well sharpened blade. The blade has been filed to a molecular edge, and is extremely deadly. Commonly found in the hands of mercenaries and yakuza."
	icon_state = "katana"
	item_state = "katana"
	force = MELEE_FORCE_VERY_STRONG

//To do: replace the toys.
/obj/item/weapon/sword/katana/replica
	name = "replica katana"
	desc = "A cheap knock-off commonly found in regular knife stores. Can still do some damage."
	force = MELEE_FORCE_WEAK
	throwforce = 7

/obj/item/weapon/sword/dragon_katana
	name = "dragon katana"
	desc = "A finely made Japanese sword, with a cherry colored handle. The blade has been filed to a molecular edge, and is extremely deadly. This one seems to have been handcrafted."
	icon_state = "dragon_katana"
	item_state = "dragon_katana"
	force = MELEE_FORCE_VERY_STRONG

/obj/item/weapon/throwing_knife
	name ="\improper M11 throwing knife"
	icon = 'icons/obj/items/weapons/melee/knives.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/objects.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/knives_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/knives_righthand.dmi'
	)
	icon_state = "throwing_knife"
	item_state = "throwing_knife"
	desc = "A military knife designed to be thrown at the enemy. Much quieter than a firearm, but requires a steady hand to be used optimally, although you should probably just use a gun instead."
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
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
	flags_item = CAN_DIG_SHRAPNEL

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
		user.visible_message(SPAN_NOTICE("[user] starts checking \his body for shrapnel."),
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

		SEND_SIGNAL(embedded_human, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	else
		to_chat(user, SPAN_NOTICE("You couldn't find any shrapnel."))

// Demo and example of a 64x64 weapon.
/obj/item/weapon/ritual
	name = "cool knife"
	desc = "It shines with awesome coding power"
	icon_state = "dark_blade"
	item_state = "dark_blade"
	icon = 'icons/obj/items/weapons/melee/misc.dmi'
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
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/items_righthand_64.dmi'
	)

/obj/item/weapon/straight_razor
	name = "straight razor"
	desc = "The commandant's favorite weapon against marines who dare break the grooming standards."
	icon_state = "razor"
	icon = 'icons/obj/items/weapons/melee/knives.dmi'
	hitsound = 'sound/weapons/genhit3.ogg'
	force = MELEE_FORCE_TIER_1
	throwforce = MELEE_FORCE_TIER_1
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	///Icon state for opened razor
	var/enabled_icon = "razor"
	///Icon state for closed razor
	var/disabled_icon = "razor_off"
	///If the razor is able to be used
	var/razor_opened = FALSE
	///Time taken to open/close the razor
	var/interaction_time = 3 SECONDS

/obj/item/weapon/straight_razor/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_ATTEMPTING_EQUIP, PROC_REF(can_fit_in_shoe))
	change_razor_state(razor_opened)
	if(prob(1))
		desc += " There is phrase etched into it, \"<i>It can guarantee the closest shave you'll ever know.</i>\"..."

/obj/item/weapon/straight_razor/update_icon()
	. = ..()
	if(razor_opened)
		icon_state = enabled_icon
		return
	icon_state = disabled_icon

/obj/item/weapon/straight_razor/attack_hand(mob/user)
	if(loc != user) //Only do unique stuff if you are holding it
		return ..()

	if(!do_after(user, interaction_time, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE))
		return
	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	change_razor_state(!razor_opened)
	to_chat(user, SPAN_NOTICE("You [razor_opened ? "reveal" : "hide"] [src]'s blade."))

///Check if the item can fit as a boot knife, var/source for signals
/obj/item/weapon/straight_razor/proc/can_fit_in_shoe(source = src, mob/user, slot)
	if(slot != WEAR_IN_SHOES) //Only check if you try putting it in a shoe
		return
	if(razor_opened)
		to_chat(user, SPAN_NOTICE("You cannot store [src] in your shoes until the blade is hidden."))
		return COMPONENT_CANCEL_EQUIP

///Changes all the vars for the straight razor
/obj/item/weapon/straight_razor/proc/change_razor_state(opening = FALSE)
	razor_opened = opening
	update_icon()
	if(opening)
		force = MELEE_FORCE_NORMAL
		throwforce = MELEE_FORCE_NORMAL
		sharp = IS_SHARP_ITEM_ACCURATE
		edge = TRUE
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'sound/weapons/slash.ogg'
		if(!(flags_item & CAN_DIG_SHRAPNEL))
			flags_item |= CAN_DIG_SHRAPNEL
		return
	force = MELEE_FORCE_TIER_1
	throwforce = MELEE_FORCE_TIER_1
	sharp = FALSE
	edge = FALSE
	attack_verb = list("smashed", "beaten", "slammed", "struck", "smashed", "battered", "cracked")
	hitsound = 'sound/weapons/genhit3.ogg'
	if(flags_item & CAN_DIG_SHRAPNEL)
		flags_item &= ~CAN_DIG_SHRAPNEL

/obj/item/weapon/straight_razor/verb/change_hair_style()
	set name = "Change Hair Style"
	set desc = "Change your hair style"
	set category = "Object"
	set src in usr

	var/mob/living/carbon/human/human_user = usr
	if(!istype(human_user))
		return

	if(!razor_opened)
		to_chat(human_user, SPAN_NOTICE("You need to reveal [src]'s blade to change your hairstyle."))
		return

	var/list/species_facial_hair = GLOB.facial_hair_styles_list
	var/list/species_hair = GLOB.hair_styles_list

	if(human_user.species) //Facial hair
		species_facial_hair = list()
		for(var/current_style in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/facial_hair/temp_beard_style = GLOB.facial_hair_styles_list[current_style]
			if(!(human_user.species.name in temp_beard_style.species_allowed))
				continue
			if(!temp_beard_style.selectable)
				continue
			species_facial_hair += current_style

	if(human_user.species) //Hair
		species_hair = list()
		for(var/current_style in GLOB.hair_styles_list)
			var/datum/sprite_accessory/hair/temp_hair_style = GLOB.hair_styles_list[current_style]
			if(!(human_user.species.name in temp_hair_style.species_allowed))
				continue
			if(!temp_hair_style.selectable)
				continue
			species_hair += current_style

	var/new_beard_style
	var/new_hair_style
	if(human_user.gender == MALE)
		new_beard_style = tgui_input_list(human_user, "Select a facial hair style", "Grooming", species_facial_hair)
	new_hair_style = tgui_input_list(human_user, "Select a hair style", "Grooming", species_hair)

	if(loc != human_user)
		to_chat(human_user, SPAN_NOTICE("You are too far from [src] to change your hair styles."))
		return

	if(!new_beard_style && !new_hair_style)
		return

	if(!do_after(human_user, interaction_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	if(!razor_opened)
		to_chat(human_user, SPAN_NOTICE("You need to reveal [src]'s blade to change your hairstyle."))
		return

	if(new_beard_style)
		human_user.f_style = new_beard_style
	if(new_hair_style)
		human_user.h_style = new_hair_style

	human_user.apply_damage(rand(1,5), BRUTE, "head", src)
	human_user.update_hair()

