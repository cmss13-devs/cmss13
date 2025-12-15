/obj/item/organ/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs.
	desc = "A piece of juicy meat found in a person's head."
	icon_state = "brain2"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/organs_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/organs_righthand.dmi',
	)
	item_state = "brain2"
	flags_atom = NO_FLAGS
	force = 1
	w_class = SIZE_SMALL
	throwforce = 1
	throw_speed = SPEED_VERY_FAST
	throw_range = 5

	attack_verb = list("attacked", "slapped", "whacked")
	organ_type = /datum/internal_organ/brain
	organ_tag = "brain"

	var/mob/living/brain/brainmob = null

/obj/item/organ/brain/xeno
	name = "alien brain"
	desc = "For a brain, it looks kind of like an enormous wad of purple bubblegum."
	icon_state = "xenobrain"

/obj/item/organ/brain/New()
	..()
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/brain/proc/transfer_identity(mob/living/carbon/H)
	name = "[H]'s brain"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.blood_type = H.blood_type
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, SPAN_NOTICE(" You feel slightly disoriented. That's normal when you're just a brain."))

/obj/item/organ/brain/get_examine_text(mob/user)
	. = ..()
	if(brainmob?.client)//if thar be a brain inside... the brain.
		. += "You can feel the small spark of life still left in this one."
	else
		. += "This one seems particularly lifeless. Perhaps it will regain some of its luster later."

/obj/item/organ/brain/removed(mob/living/target, mob/living/user)

	..()



	var/mob/living/carbon/human/H = target
	var/obj/item/organ/brain/B = src
	if(istype(B) && istype(H))
		B.transfer_identity(target)

/obj/item/organ/brain/replaced(mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
			if(target.client)
				target.client.change_view(GLOB.world_view_size)
