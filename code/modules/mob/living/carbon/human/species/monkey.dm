/datum/species/monkey
	name = "Monkey"
	name_plural = "Monkeys"
	icobase = 'icons/mob/humans/species/monkeys/r_monkey.dmi'
	deform = 'icons/mob/humans/species/monkeys/r_monkey.dmi'
	brute_mod = 1.5
	burn_mod = 1.5
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
		/mob/living/proc/hide
		)

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

/datum/species/monkey/handle_post_spawn(var/mob/living/carbon/human/H)
	H.set_languages(list("Primitive"))
	if(H.real_name == "unknown")
		var/random_name = "[lowertext(name)] ([rand(1, 999)])"
		H.change_real_name(H, random_name)
	return ..()

/datum/species/monkey/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_MONKEY

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && isturf(H.loc) && !H.pulledby && !H.lying && !H.is_mob_restrained()) //won't move if being pulled
		step(H, pick(cardinal))

	var/obj/held = H.get_active_hand()
	if(held && prob(1))
		var/turf/T = get_random_turf_in_range(H, 7, 2)
		if(T)
			if(istype(held, /obj/item/weapon/gun) && prob(80))
				var/obj/item/weapon/gun/G = held
				G.Fire(T, H)
			else if(prob(80) && H.equip_to_appropriate_slot(held, 0))
				if(H.hand)
					H.update_inv_l_hand(0)
				else
					H.update_inv_r_hand(0)
			else
				H.throw_item(T)
		else
			H.drop_held_item()
	if(!held && !H.buckled && prob(5))
		var/list/touchables = list()
		for(var/obj/O in range(1,get_turf(H)))
			if(O.Adjacent(H))
				touchables += O
		if(touchables.len)
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(H)

	if(prob(1))
		H.emote(pick("chimper","scratch","jump","roll","tail"))

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
	blood_color = "#1d2cbf"
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