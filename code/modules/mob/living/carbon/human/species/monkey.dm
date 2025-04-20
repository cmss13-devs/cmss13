/datum/species/monkey
	group = SPECIES_MONKEY
	name = "Monkey"
	name_plural = "Monkeys"
	icobase = 'icons/mob/humans/species/monkeys/r_monkey.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_monkey.dmi'
	eyes = "monkey_eyes_s"
	blood_mask = 'icons/effects/monkey_blood.dmi'
	brute_mod = 1.5
	burn_mod = 1.5
	pain_type = /datum/pain/monkey
	unarmed_type = /datum/unarmed_attack/bite
	secondary_unarmed_type = /datum/unarmed_attack
	death_message = "lets out a faint chimper as it collapses and stops moving..."
	knock_down_reduction = 0.5
	stun_reduction = 0.5
	tail = "chimptail"
	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/proc/hide,
	)
	fire_sprite_prefix = "monkey"
	fire_sprite_sheet = 'icons/mob/humans/onmob/OnFire.dmi'

/datum/species/monkey/New()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 3), "[EAST]" = list("x" = 0, "y" = 3), "[SOUTH]" = list("x" = 0, "y" = 3), "[WEST]" = list("x" = 0, "y" = 3)),
		WEAR_FEET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -2, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 2, "y" = 0)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -1, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 1, "y" = 0))
	)
	..()

/datum/species/monkey/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list(LANGUAGE_MONKEY))
	if(!H.real_name || !H.name)
		var/random_name = "[lowertext(name)] ([rand(1, 999)])"
		H.change_real_name(H, random_name)
	return ..()

/datum/species/monkey/get_bodytype(mob/living/carbon/human/H)
	return SPECIES_MONKEY

/datum/species/monkey/handle_npc(mob/living/carbon/human/monkey)
	if(monkey.stat != CONSCIOUS)
		return

	var/is_on_turf = isturf(monkey.loc)
	var/monkey_turf = get_turf(monkey)

	if(prob(33) && is_on_turf && !monkey.pulledby && (monkey.mobility_flags & MOBILITY_MOVE) && !monkey.is_mob_restrained()) //won't move if being pulled
		step(monkey, pick(GLOB.cardinals))

	var/obj/held = monkey.get_active_hand()
	if(held && prob(1))
		var/turf/turf = get_random_turf_in_range(monkey, 7, 2)
		if(turf)
			if(isgun(held) && prob(80))
				var/obj/item/weapon/gun/firearm = held
				firearm.Fire(turf, monkey)
			else if(prob(80) && monkey.equip_to_appropriate_slot(held, 0))
				if(monkey.hand)
					monkey.update_inv_l_hand(0)
				else
					monkey.update_inv_r_hand(0)
			else
				monkey.throw_item(turf)
		else
			monkey.drop_held_item()
	if(!held && !monkey.buckled && prob(5))
		var/list/touchables = list()
		for(var/obj/thing in range(1, monkey_turf))
			if(thing.Adjacent(monkey))
				touchables += thing
		if(length(touchables))
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(monkey)

	var/prob_cry = is_on_turf ? 1 : 5
	if(prob(prob_cry))
		monkey.emote(pick("chimper","scratch","jump","roll","tail"))
		if(!is_on_turf && isobj(monkey.loc))
			var/obj/container = monkey.loc
			if(prob(50))
				var/list/heard = get_mobs_in_view(GLOB.world_view_size, container)
				var/message = pick("rocks about.", "creaks.", "chimpers.")
				container.langchat_speech(message, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
				container.visible_message("<b>[container]</b> [message]")
			else
				container.attack_hand(monkey)
		if(prob(50))
			playsound(monkey_turf, pick('sound/voice/monkey_chimper1.ogg', 'sound/voice/monkey_chimper2.ogg'), 25)

/datum/species/monkey/handle_on_fire(humanoidmob)
	. = ..()
	INVOKE_ASYNC(humanoidmob, TYPE_PROC_REF(/mob, emote), pick("pain", "scream"))

/datum/species/monkey/yiren
	name = "Yiren"
	name_plural = "Yiren"

	icobase = 'icons/mob/humans/species/monkeys/r_yiren.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_yiren.dmi'

	flesh_color = "#afa59e"
	base_color = "#333333"

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	tail = null
	eyes = "blank_s"

/datum/species/monkey/yiren/New()
	..()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 3), "[EAST]" = list("x" = 0, "y" = 3), "[SOUTH]" = list("x" = 0, "y" = 3), "[WEST]" = list("x" = 0, "y" = 3)),
		WEAR_FEET = list("[NORTH]" = list("x" = 0, "y" = 6), "[EAST]" = list("x" = -1, "y" = 6), "[SOUTH]" = list("x" = 0, "y" = 6), "[WEST]" = list("x" = 1, "y" = 6)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -2, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 2, "y" = 0)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -1, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 1, "y" = 0))
	)

/datum/species/monkey/farwa
	name = "Farwa"
	name_plural = "Farwa"

	icobase = 'icons/mob/humans/species/monkeys/r_farwa.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_farwa.dmi'

	flesh_color = "#afa59e"
	base_color = "#333333"
	tail = "farwatail"
	eyes = "blank_s"

/datum/species/monkey/farwa/New()
	..()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 3), "[EAST]" = list("x" = 0, "y" = 3), "[SOUTH]" = list("x" = 0, "y" = 3), "[WEST]" = list("x" = 0, "y" = 3)),
		WEAR_EYES = list("[NORTH]" = list("x" = 0, "y" = -2), "[EAST]" = list("x" = -3, "y" = -2), "[SOUTH]" = list("x" = 0, "y" = -2), "[WEST]" = list("x" = 3, "y" = -2)),
		WEAR_FEET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = -2), "[EAST]" = list("x" = -2, "y" = -2), "[SOUTH]" = list("x" = 0, "y" = -2), "[WEST]" = list("x" = 2, "y" = -2)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = -1, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = 1, "y" = -3))
	)

/datum/species/monkey/neaera
	name = "Neaera"
	name_plural = "Neaera"

	icobase = 'icons/mob/humans/species/monkeys/r_neaera.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_neaera.dmi'

	flesh_color = "#8cd7a3"
	blood_color = BLOOD_COLOR_NEAERA
	tail = null

/datum/species/monkey/neaera/New()
	..()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 3), "[EAST]" = list("x" = 0, "y" = 3), "[SOUTH]" = list("x" = 0, "y" = 3), "[WEST]" = list("x" = 0, "y" = 3)),
		WEAR_EYES = list("[NORTH]" = list("x" = 0, "y" = -2), "[EAST]" = list("x" = -3, "y" = -2), "[SOUTH]" = list("x" = 0, "y" = -2), "[WEST]" = list("x" = 3, "y" = -2)),
		WEAR_FEET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = -2), "[EAST]" = list("x" = -2, "y" = -2), "[SOUTH]" = list("x" = 0, "y" = -2), "[WEST]" = list("x" = 2, "y" = -2)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = -1, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = 1, "y" = -3))
	)

/datum/species/monkey/stok
	name = "Stok"
	name_plural = "Stok"

	icobase = 'icons/mob/humans/species/monkeys/r_stok.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_stok.dmi'

	tail = "stoktail"
	eyes = "blank_s"
	flesh_color = "#34af10"
	base_color = "#066000"

/datum/species/monkey/stok/New()
	..()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 3), "[EAST]" = list("x" = 0, "y" = 3), "[SOUTH]" = list("x" = 0, "y" = 3), "[WEST]" = list("x" = 0, "y" = 3)),
		WEAR_EYES = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = -3, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = 3, "y" = -3)),
		WEAR_FEET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = -2, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = 2, "y" = -3)),
		WEAR_BACK = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -5, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 5, "y" = 0)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = -1, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = 1, "y" = -3))
	)
