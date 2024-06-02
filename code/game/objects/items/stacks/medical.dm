/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items/items.dmi'
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	attack_speed = 3
	var/heal_brute = 0
	var/heal_burn = 0
	var/alien = FALSE

/obj/item/stack/medical/attack_self(mob/user)
	..()
	attack(user, user)

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!istype(M))
		to_chat(user, SPAN_DANGER("\The [src] cannot be applied to [M]!"))
		return 1

	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	var/mob/living/carbon/human/H = M
	var/obj/limb/affecting = H.get_limb(user.zone_selected)

	if(HAS_TRAIT(H, TRAIT_FOREIGN_BIO) && !alien)
		to_chat(user, SPAN_WARNING("\The [src] is incompatible with the biology of [H]!"))
		return TRUE

	if(!affecting)
		to_chat(user, SPAN_WARNING("[H] has no [parse_zone(user.zone_selected)]!"))
		return 1

	if(affecting.display_name == "head")
		if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
			to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
			return 1
	else
		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
			to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
			return 1

	if(affecting.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb."))
		return 1

	H.UpdateDamageIcon()

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "medical gauze"
	desc = "Some sterile gauze to wrap around bloody stumps and lacerations."
	icon_state = "brutepack"

	stack_id = "bruise pack"

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1


		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]'s [affecting.display_name] is cut open, you'll need more than a bandage!"))
			return TRUE

		var/possessive = "[user == M ? "your" : "\the [M]'s"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "his" : "her" : "\the [M]'s"]"
		switch(affecting.bandage())
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("You <b>bandage</b> [possessive] <b>[affecting.display_name]</b>."),
					SPAN_HELPFUL("[user] <b>bandages</b> your <b>[affecting.display_name]</b>."),
					SPAN_NOTICE("[user] bandages [possessive_their] [affecting.display_name]."))
				use(1)
				playsound(user, 'sound/handling/bandage.ogg', 25, 1, 2)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("The wounds on [possessive] [affecting.display_name] have already been treated."))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("There are no wounds on [possessive] [affecting.display_name]."))
				return TRUE

/obj/item/stack/medical/bruise_pack/two
	amount = 2

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat burns, infected wounds, and relieve itching in unusual places."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 5

	stack_id = "ointment"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]'s [affecting.display_name] is cut open, you'll need more than an ointment!"))
			return TRUE

		var/possessive = "[user == M ? "your" : "\the [M]'s"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "his" : "her" : "\the [M]'s"]"
		switch(affecting.salve())
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("You <b>salve the burns</b> on [possessive] <b>[affecting.display_name]</b>."),
					SPAN_HELPFUL("[user] <b>salves the burns</b> on your <b>[affecting.display_name]</b>."),
					SPAN_NOTICE("[user] salves the burns on [possessive_their] [affecting.display_name]."))
				affecting.heal_damage(burn = heal_burn)
				use(1)
				playsound(user, 'sound/handling/ointment_spreading.ogg', 25, 1, 2)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("The burns on [possessive] [affecting.display_name] have already been treated."))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("There are no burns on [possessive] [affecting.display_name]."))
				return TRUE

/obj/item/stack/medical/advanced/bruise_pack
	name = "trauma kit"
	singular_name = "trauma kit"
	desc = "A trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12

	stack_id = "advanced bruise pack"

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M, mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		var/heal_amt = heal_brute
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("You start fumbling with [src]."))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]'s [affecting.display_name] is cut open, you'll need more than a trauma kit!"))
			return TRUE

		var/possessive = "[user == M ? "your" : "\the [M]'s"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "his" : "her" : "\the [M]'s"]"
		switch(affecting.bandage(TRUE))
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("You <b>clean and seal</b> the wounds on [possessive] <b>[affecting.display_name]</b> with bioglue."),
					SPAN_HELPFUL("[user] <b>cleans and seals</b> the wounds on your <b>[affecting.display_name]</b> with bioglue."),
					SPAN_NOTICE("[user] cleans and seals the wounds on [possessive_their] [affecting.display_name] with bioglue."))
				//If a suture datum exists, apply half the damage as sutures. This ensures consistency in healing amounts.
				if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, TRUE, FALSE, heal_amt * 0.5))
					heal_amt *= 0.5
				affecting.heal_damage(brute = heal_amt)
				use(1)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("The wounds on [possessive] [affecting.display_name] have already been treated."))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("There are no wounds on [possessive] [affecting.display_name]."))
				return TRUE

/obj/item/stack/medical/advanced/bruise_pack/predator
	name = "mending herbs"
	singular_name = "mending herb"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "brute_herbs"
	heal_brute = 15
	stack_id = "mending herbs"
	alien = TRUE
/obj/item/stack/medical/advanced/ointment/predator
	name = "soothing herbs"
	singular_name = "soothing herb"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "burn_herbs"
	heal_burn = 15
	stack_id = "soothing herbs"
	alien = TRUE
/obj/item/stack/medical/advanced/ointment
	name = "burn kit"
	singular_name = "burn kit"
	desc = "A treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12

	stack_id = "burn kit"

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/heal_amt = heal_burn
		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("You start fumbling with [src]."))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]'s [affecting.display_name] is cut open, you'll need more than a burn kit!"))
			return TRUE

		var/possessive = "[user == M ? "your" : "\the [M]'s"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "his" : "her" : "\the [M]'s"]"
		switch(affecting.salve(TRUE))
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("You <b>cover the burns</b> on [possessive] <b>[affecting.display_name]</b> with regenerative membrane."),
					SPAN_HELPFUL("[user] <b>covers the burns</b> on your <b>[affecting.display_name]</b> with regenerative membrane."),
					SPAN_NOTICE("[user] covers the burns on [possessive_their] [affecting.display_name] with regenerative membrane."))
				//If a suture datum exists, apply half the damage as grafts. This ensures consistency in healing amounts.
				if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, FALSE, TRUE, heal_amt * 0.5))
					heal_amt *= 0.5
				affecting.heal_damage(burn = heal_amt)
				use(1)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("The burns on [possessive] [affecting.display_name] have already been treated."))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("There are no burns on [possessive] [affecting.display_name]."))
				return TRUE

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "A collection of different splints and securing gauze. What, did you think we only broke legs out here?"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	stack_id = "splint"

	var/indestructible_splints = FALSE

/obj/item/stack/medical/splint/attack(mob/living/carbon/M, mob/user)
	if(..()) return 1

	if(user.action_busy)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		var/limb = affecting.display_name

		if(!(affecting.name in list("l_arm", "r_arm", "l_leg", "r_leg", "r_hand", "l_hand", "r_foot", "l_foot", "chest", "groin", "head")))
			to_chat(user, SPAN_WARNING("You can't apply a splint there!"))
			return

		if(affecting.status & LIMB_DESTROYED)
			var/message = SPAN_WARNING("[user == M ? "You don't" : "[M] doesn't"] have \a [limb]!")
			to_chat(user, message)
			return

		if(affecting.status & LIMB_SPLINTED)
			var/message = "[user == M ? "Your" : "[M]'s"]"
			to_chat(user, SPAN_WARNING("[message] [limb] is already splinted!"))
			return

		if(M != user)
			var/possessive = "[user == M ? "your" : "\the [M]'s"]"
			var/possessive_their = "[user == M ? user.gender == MALE ? "his" : "her" : "\the [M]'s"]"
			user.affected_message(M,
				SPAN_HELPFUL("You <b>start splinting</b> [possessive] <b>[affecting.display_name]</b>."),
				SPAN_HELPFUL("[user] <b>starts splinting</b> your <b>[affecting.display_name]</b>."),
				SPAN_NOTICE("[user] starts splinting [possessive_their] [affecting.display_name]."))
		else
			if((!user.hand && (affecting.name in list("r_arm", "r_hand"))) || (user.hand && (affecting.name in list("l_arm", "l_hand"))))
				to_chat(user, SPAN_WARNING("You can't apply a splint to the \
					[affecting.name == "r_hand"||affecting.name == "l_hand" ? "hand":"arm"] you're using!"))
				return
			// Self-splinting
			user.affected_message(M,
				SPAN_HELPFUL("You <b>start splinting</b> your <b>[affecting.display_name]</b>."),
				,
				SPAN_NOTICE("[user] starts splinting \his [affecting.display_name]."))

		if(affecting.apply_splints(src, user, M, indestructible_splints)) // Referenced in external organ helpers.
			use(1)
			playsound(user, 'sound/handling/splint1.ogg', 25, 1, 2)
