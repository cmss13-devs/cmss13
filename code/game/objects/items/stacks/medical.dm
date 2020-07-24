/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items/items.dmi'
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!istype(M))
		to_chat(user, SPAN_DANGER("\The [src] cannot be applied to [M]!"))
		return 1

	if(!ishuman(user) && !isrobot(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	var/mob/living/carbon/human/H = M
	var/obj/limb/affecting = H.get_limb(user.zone_selected)

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

	if(affecting.status & LIMB_ROBOT)
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

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.surgery_open_stage == 0)
			if(!affecting.bandage())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been bandaged."))
				return 1
			else
				var/possessive = "[user == M ? "your" : "[M]'s"]"
				var/possessive_their = "[user == M ? "their" : "[M]'s"]"
				user.affected_message(M,
					SPAN_HELPFUL("You <b>bandage</b> [possessive] <b>[affecting.display_name]</b>."),
					SPAN_HELPFUL("[user] <b>bandages</b> your <b>[affecting.display_name]</b>."),
					SPAN_NOTICE("[user] bandages [possessive_their] [affecting.display_name]."))
				use(1)
				playsound(user, 'sound/handling/bandage.ogg', 25, 1, 2)
		else
			if(H.can_be_operated_on()) //Checks if mob is lying down on table for surgery
				if(do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat burns, infected wounds, and relieve itching in unusual places."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	
	stack_id = "ointment"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.surgery_open_stage == 0)
			if(!affecting.salve())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been salved."))
				return 1
			else
				var/possessive = "[user == M ? "your" : "[M]'s"]"
				var/possessive_their = "[user == M ? "their" : "[M]'s"]"
				user.affected_message(M,
					SPAN_HELPFUL("You <b>salve the wounds</b> on [possessive] <b>[affecting.display_name]</b>."),
					SPAN_HELPFUL("[user] <b>salves the wounds</b> on your <b>[affecting.display_name]</b>."),
					SPAN_NOTICE("[user] salves the wounds [possessive_their] [affecting.display_name]."))
				use(1)
				playsound(user, 'sound/handling/ointment_spreading.ogg', 25, 1, 2)				
		else
			if (H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))


/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	
	stack_id = "advanced bruise pack"



/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M, mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/heal_amt = heal_brute
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("You start fumbling with [src]."))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.surgery_open_stage == 0)
			var/bandaged = affecting.bandage()

			if(!bandaged)
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been treated."))
				return 1
			else
				var/possessive = "[user == M ? "your" : "[M]'s"]"
				var/possessive_their = "[user == M ? "their" : "[M]'s"]"
				user.affected_message(M,
					SPAN_HELPFUL("You <b>clean and seal</b> the wounds on [possessive] <b>[affecting.display_name]</b> with bioglue."),
					SPAN_HELPFUL("[user] <b>cleans and seals</b> the wounds on your <b>[affecting.display_name]</b> with bioglue."),
					SPAN_NOTICE("[user] cleans and seals the wounds on [possessive_their] [affecting.display_name] with bioglue."))
			if(bandaged)
				H.apply_damage(-heal_amt, BRUTE, affecting)
				use(1)
		else
			if(H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/advanced/bruise_pack/tajaran
	name = "\improper S'rendarr's Hand leaf"
	singular_name = "S'rendarr's Hand leaf"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "shandp"
	heal_brute = 15
	stack_id = "Hand leaf"

/obj/item/stack/medical/advanced/ointment/tajaran
	name = "\improper Messa's Tear petals"
	singular_name = "Messa's Tear petal"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "mtearp"
	heal_burn = 15
	stack_id = "Tear petals"

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12
	
	stack_id = "advanced burn kit"

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/heal_amt = heal_burn
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("You start fumbling with [src]."))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.surgery_open_stage == 0)
			if(!affecting.salve())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been salved."))
				return 1
			else
				var/possessive = "[user == M ? "your" : "[M]'s"]"
				var/possessive_their = "[user == M ? "their" : "[M]'s"]"
				user.affected_message(M,
					SPAN_HELPFUL("You <b>cover the wounds</b> on [possessive] <b>[affecting.display_name]</b> with regenerative membrane."),
					SPAN_HELPFUL("[user] <b>covers the wounds</b> on your <b>[affecting.display_name]</b> with regenerative membrane."),
					SPAN_NOTICE("[user] covers the wounds on [possessive_their] [affecting.display_name] with regenerative membrane."))

				H.apply_damage(-heal_amt, BURN, affecting)
				use(1)
		else
			if(H.can_be_operated_on()) //Checks if mob is lying down on table for surgery
				if(do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "A collection of different splints and securing gauze. What, did you think we only broke legs out here?"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	stack_id = "splint"

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
			var/possessive = "[user == M ? "your" : "[M]'s"]"
			var/possessive_their = "[user == M ? "their" : "[M]'s"]"
			user.affected_message(M,
				SPAN_HELPFUL("You <b>start splinting</b> [possessive] <b>[affecting.display_name]</b>."),
				SPAN_HELPFUL("[user] <b>starts splinting</b> your <b>[affecting.display_name]</b>."),
				SPAN_NOTICE("[user] starts splinting [possessive_their] [affecting.display_name]."))
		else
			if((!user.hand && affecting.name in list("r_arm", "r_hand")) || (user.hand && affecting.name in list("l_arm", "l_hand")))
				to_chat(user, SPAN_WARNING("You can't apply a splint to the \
					[affecting.name == "r_hand"||affecting.name == "l_hand" ? "hand":"arm"] you're using!"))
				return
			// Self-splinting
			user.affected_message(M,
				SPAN_HELPFUL("You <b>start splinting</b> your <b>[affecting.display_name]</b>."),
				,
				SPAN_NOTICE("[user] starts splinting their [affecting.display_name]."))

		if(affecting.apply_splints(src, user, M)) // Referenced in external organ helpers.
			use(1)
			playsound(user, 'sound/handling/splint1.ogg', 25, 1, 2)	