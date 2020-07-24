/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05

	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.01

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9



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
		if(isliving(A) && M.a_intent == HARM_INTENT)
			if(isYautja(A))
				return 0
			if (isXeno(A))
				var/mob/living/carbon/Xenomorph/X = A
				if (X.mutation_type == WARRIOR_BOXER)
					M.visible_message(SPAN_DANGER("[M] boxes with [A]!"))
					var/fisticuff_phrase = pick("Have at ye!", "En guard fuckboy!", "Huttah!", "Take this uncultured cur!", "Have at you little man!")
					M.say(fisticuff_phrase)//this is probably going to trigger spam filter, but I don't care?
					return 0
				else
					return 0
			if (ishuman(A))
				var/mob/living/carbon/human/L = A
				var/boxing_icon = pick("boxing_up","boxing_down","boxing_left","boxing_right")
				if (!istype(L.gloves, /obj/item/clothing/gloves/boxing))
					to_chat(M, SPAN_WARNING("You can't box with [A], they're not wearing boxing gloves!"))
					return 1
				if (L.halloss > 100)
					playsound(loc, knockout_sound, 50, FALSE)
					M.show_message(FONT_SIZE_LARGE(SPAN_WARNING("KNOCKOUT!")))
					return 1
				if (L.lying == 1 || L.stat == UNCONSCIOUS)//Can't beat 'em while they're down.
					to_chat(M, SPAN_WARNING("You can't box with [A], they're already down!"))
					return 1
				M.visible_message(SPAN_DANGER("[M] [boxing_verb] [A]!"))
				L.apply_effect(painforce, AGONY)
				M.animation_attack_on(L)
				M.flick_attack_overlay(L, boxing_icon)
				playsound(loc, pick(box_sound), 25, 1)
				return 1

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/wirecutters) || istype(W, /obj/item/tool/surgery/scalpel))
		to_chat(user, SPAN_NOTICE("It would be a great dishonor to cut open these fine boxing gloves."))	//Nope
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
	icon_state = "latex"
	item_state = "lgloves"
