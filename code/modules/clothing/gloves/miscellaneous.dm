/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0.6


	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0

	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "latex"
	siemens_coefficient = 0.30
	armor_bio = CLOTHING_ARMOR_LOW

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	siemens_coefficient = 0.9

/obj/item/clothing/gloves/black_leather
	name = "stylish leather gloves"
	desc = "Supple, black leather gloves crafted from the finest leather. Stylish, durable, and ready for work or play."
	icon_state = "black_leather"
	item_state = "black"

/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"
	force = 0//don't actually deal damage
	attack_verb = list("boxes","punches","jabs","strikes","uppercuts", "fisticuffs", "bashes")
	var/pain_dam = 20
	var/box_sound = list('sound/weapons/punch1.ogg')//placeholder
	var/knockout_sound = 'sound/effects/knockout.ogg'


/obj/item/clothing/gloves/boxing/Touch(atom/A, proximity)
	var/mob/living/M = loc
	var/painforce = pain_dam
	var/boxing_verb = pick(attack_verb)
	if (A in range(1, M))
		if(isliving(A) && M.a_intent == INTENT_HARM)
			if(isyautja(A) || isxeno(A))
				return 0
			if (ishuman(A))
				var/mob/living/carbon/human/L = A
				var/boxing_icon = pick("boxing_up","boxing_down","boxing_left","boxing_right")
				if (!istype(L.gloves, /obj/item/clothing/gloves/boxing))
					to_chat(M, SPAN_WARNING("You can't box with [A], they're not wearing boxing gloves!"))
					return 1
				if (L.halloss > 100)
					playsound(loc, knockout_sound, 50, FALSE)
					M.show_message(FONT_SIZE_LARGE(SPAN_WARNING("KNOCKOUT!")), SHOW_MESSAGE_VISIBLE)
					return 1
				if (L.body_position == LYING_DOWN || L.stat == UNCONSCIOUS)//Can't beat 'em while they're down.
					to_chat(M, SPAN_WARNING("You can't box with [A], they're already down!"))
					return 1
				M.visible_message(SPAN_DANGER("[M] [boxing_verb] [A]!"))
				L.apply_effect(painforce, AGONY)
				M.animation_attack_on(L)
				M.flick_attack_overlay(L, boxing_icon)
				playsound(loc, pick(box_sound), 25, 1)
				return 1

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) || W.sharp == IS_SHARP_ITEM_ACCURATE || W.sharp == IS_SHARP_ITEM_BIG)
		to_chat(user, SPAN_NOTICE("It would be a great dishonor to cut open these fine boxing gloves.")) //Nope
		return
	..()

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state = "boxinggreen"

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state = "boxingblue"

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state = "boxingyellow"

/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "white"
	item_state = "white"
