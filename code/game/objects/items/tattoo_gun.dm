// This file contains code for the tattoo gun item as well as tattoo_info datum. Most relevant to expand is the datum and its function.
//
// The datum is used to simplify having multi-tattoo tattoo guns, be they individual ones in a bundle or a larger multi-limb tattoo.
// They have the following information:
// - var/tattoo - The icon name of the tattoo.
// - var/tattoo_location - What limb does the tattoo go on.
// - var/tattoo_specific_location - Where specifically on the limb does the tattoo go on. This is relevant for the torso, because there are chest tattoos and back tattoos.

/datum/tattoo_info
	/// What tattoo does this apply?
	var/tattoo = null
	/// Which limb does this tattoo get applied to?
	var/tattoo_location = null
	/// If the desired limb has multiple tattoo locations, where is the specific location? Should be in quotation marks.
	var/tattoo_specific_location = null

// Chest - chest
/datum/tattoo_info/uscm_chest
	tattoo = "uscm_chest"
	tattoo_location = "chest"
	tattoo_specific_location = "chest"

/datum/tattoo_info/uscm_retro_chest
	tattoo = "uscm_retro_chest"
	tattoo_location = "chest"
	tattoo_specific_location = "chest"

// Chest - back
/datum/tattoo_info/anchor_back
	tattoo = "anchor_back"
	tattoo_location = "chest"
	tattoo_specific_location = "back"

/datum/tattoo_info/black_star_back
	tattoo = "black_star_back"
	tattoo_location = "chest"
	tattoo_specific_location = "back"

/datum/tattoo_info/skull_back
	tattoo = "skull_back"
	tattoo_location = "chest"
	tattoo_specific_location = "back"

// Arms
/datum/tattoo_info/sleeve_right_arm
	tattoo = "sleeve_right_arm"
	tattoo_location = "r_arm"

/datum/tattoo_info/sleeve_left_arm
	tattoo = "sleeve_left_arm"
	tattoo_location = "l_arm"

/datum/tattoo_info/blood_pauldron_right_arm
	tattoo = "blood_pauldron_right"
	tattoo_location = "r_arm"

/datum/tattoo_info/blood_pauldron_left_arm
	tattoo = "blood_pauldron_left"
	tattoo_location = "l_arm"

// Multi-limb
// Black Tribal
/datum/tattoo_info/black_tribal_chest
	tattoo = "black_tribal_chest"
	tattoo_location = "chest"
	tattoo_specific_location = "chest"

/datum/tattoo_info/black_tribal_back
	tattoo = "black_tribal_back"
	tattoo_location = "chest"
	tattoo_specific_location = "back"

/datum/tattoo_info/black_tribal_right_arm
	tattoo = "black_tribal_right_arm"
	tattoo_location = "r_arm"

/datum/tattoo_info/black_tribal_left_arm
	tattoo = "black_tribal_left_arm"
	tattoo_location = "l_arm"

// Blue Tribal
/datum/tattoo_info/blue_tribal_chest
	tattoo = "blue_tribal_chest"
	tattoo_location = "chest"
	tattoo_specific_location = "chest"

/datum/tattoo_info/blue_tribal_back
	tattoo = "blue_tribal_back"
	tattoo_location = "chest"
	tattoo_specific_location = "back"

/datum/tattoo_info/blue_tribal_right_arm
	tattoo = "blue_tribal_right_arm"
	tattoo_location = "r_arm"

////////////////
// Tattoo gun //
////////////////

/obj/item/tattoo_gun
	gender = PLURAL
	name = "tattoo gun"
	desc = "A tattoo gun. You should not be seeing this, please file an issue!"
	icon = 'icons/obj/items/paint.dmi'
	icon_state = "tattoo_gun"
	w_class = SIZE_TINY
	/// Contains tattoo_info datums that this tattoo gun should apply.
	var/list/tattoos_to_apply = list()

/obj/item/tattoo_gun/proc/tattoo_location_check(mob/living/carbon/human/desired_target, datum/tattoo_info/desired_tattoo)
	var/not_tattooed = TRUE
	switch(desired_tattoo.tattoo_location)
		if("chest")
			if(desired_tattoo.tattoo_specific_location == "chest")
				if(desired_target.chest_tattoo)
					not_tattooed = FALSE
			if(desired_tattoo.tattoo_specific_location == "back")
				if(desired_target.back_tattoo)
					not_tattooed = FALSE
		if("l_arm")
			if(desired_target.left_arm_tattoo)
				not_tattooed = FALSE
		if("l_leg")
			if(desired_target.left_leg_tattoo)
				not_tattooed = FALSE
		if("r_arm")
			if(desired_target.right_arm_tattoo)
				not_tattooed = FALSE
		if("r_leg")
			if(desired_target.right_leg_tattoo)
				not_tattooed = FALSE
		if("head")
			if(desired_target.head_tattoo)
				not_tattooed = FALSE

	return not_tattooed

/obj/item/tattoo_gun/proc/apply_tattoo(mob/living/carbon/human/desired_target, datum/tattoo_info/desired_tattoo)
	var/obj/limb/target_part = desired_target.get_limb(desired_tattoo.tattoo_location)
	if(target_part.status & LIMB_DESTROYED) // No limb? No tattoo
		to_chat(desired_target, SPAN_NOTICE("You have no [target_part.display_name] to tattoo!"))
		return

	if((target_part.status & LIMB_ROBOT) && !(target_part.status & LIMB_SYNTHSKIN)) // Prosthetics don't get tats, Synths can
		to_chat(desired_target, SPAN_NOTICE("Your [target_part.display_name] is a prosthetic with too little synthetic skin to tattoo!"))
		return

	switch(desired_tattoo.tattoo_location)
		if("chest")
			if(desired_tattoo.tattoo_specific_location == "chest")
				desired_target.chest_tattoo = desired_tattoo.tattoo
			if(desired_tattoo.tattoo_specific_location == "back")
				desired_target.back_tattoo = desired_tattoo.tattoo
		if("l_arm")
			desired_target.left_arm_tattoo = desired_tattoo.tattoo
		if("l_leg")
			desired_target.left_leg_tattoo = desired_tattoo.tattoo
		if("r_arm")
			desired_target.right_arm_tattoo = desired_tattoo.tattoo
		if("r_leg")
			desired_target.right_leg_tattoo = desired_tattoo.tattoo
		if("head")
			desired_target.head_tattoo = desired_tattoo.tattoo

	desired_target.update_body()

/obj/item/tattoo_gun/attack(mob/living/carbon/human/target, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(!ishuman(target))
		return

	// We check to see if the locations where the desired tats go are already occupied and halt the process
	for(var/datum/tattoo_info/valid_tats as anything in tattoos_to_apply)
		if(!tattoo_location_check(target, valid_tats))
			to_chat(user, SPAN_WARNING("There are already tattoos where this tattoo will go!"))
			return
		// Once we have verified everyone is happy, we can start applying all the relevant tattoos
		apply_tattoo(target, valid_tats)

	to_chat(target, SPAN_NOTICE("You finish tattooing yourself."))

/obj/item/tattoo_gun/uscm
	name = "USCM chest tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is the good ol' USCM logo!"
	tattoos_to_apply = list(
		/datum/tattoo_info/uscm_chest,
	)

/obj/item/tattoo_gun/uscm_retro
	name = "retro USCM chest tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is an older variant of the USCM logo!"
	tattoos_to_apply = list(
		/datum/tattoo_info/uscm_retro_chest,
	)

/obj/item/tattoo_gun/anchor
	name = "anchor back tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a navy classic for your back; an anchor!"
	tattoos_to_apply = list(
		/datum/tattoo_info/anchor_back,
	)

/obj/item/tattoo_gun/black_star
	name = "star back tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a simple, black star for your back!"
	tattoos_to_apply = list(
		/datum/tattoo_info/black_star_back,
	)

/obj/item/tattoo_gun/skull
	name = "skull back tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a large skull!"
	tattoos_to_apply = list(
		/datum/tattoo_info/skull_back,
	)

/obj/item/tattoo_gun/right_arm_sleeve
	name = "right arm sleeve tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a tattoo sleeve for your right arm!"
	tattoos_to_apply = list(
		/datum/tattoo_info/sleeve_right_arm,
	)

/obj/item/tattoo_gun/left_arm_sleeve
	name = "left arm sleeve tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a tattoo sleeve for your left arm!"
	tattoos_to_apply = list(
		/datum/tattoo_info/sleeve_left_arm,
	)

/obj/item/tattoo_gun/both_arm_sleeve
	name = "left & right arm sleeve tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is tattoo sleeves for both your arms!"
	tattoos_to_apply = list(
		/datum/tattoo_info/sleeve_left_arm,
		/datum/tattoo_info/sleeve_right_arm,
	)

/obj/item/tattoo_gun/right_blood_pauldron
	name = "right blood pauldron tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a blood-red pauldron for your right arm!"
	tattoos_to_apply = list(
		/datum/tattoo_info/blood_pauldron_right_arm,
	)

/obj/item/tattoo_gun/left_blood_pauldron
	name = "left blood pauldron tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a blood-red pauldron for your left arm!"
	tattoos_to_apply = list(
		/datum/tattoo_info/blood_pauldron_left_arm,
	)

/obj/item/tattoo_gun/black_tribal
	name = "black tribal tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a large black tribal tattoo!"
	tattoos_to_apply = list(
		/datum/tattoo_info/black_tribal_chest,
		/datum/tattoo_info/black_tribal_back,
		/datum/tattoo_info/black_tribal_left_arm,
		/datum/tattoo_info/black_tribal_right_arm,
	)

/obj/item/tattoo_gun/blue_tribal
	name = "blue tribal tattoo"
	desc = "A device with attached multi-ink canister used for tattooing, with the capacity for doing it oneself. This one is a large blue tribal tattoo!"
	tattoos_to_apply = list(
		/datum/tattoo_info/blue_tribal_chest,
		/datum/tattoo_info/blue_tribal_back,
		/datum/tattoo_info/blue_tribal_right_arm,
	)
