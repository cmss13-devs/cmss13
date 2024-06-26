/datum/character_trait_group/robo_limb
	trait_group_name = "Robotic Limb"
	mutually_exclusive = TRUE
	base_type = /datum/character_trait_group/robo_limb

/datum/character_trait/robo_limb
	var/robo_limb_name
	var/code_limb
	applyable = FALSE
	trait_group = /datum/character_trait_group/robo_limb
	cost = 1

/datum/character_trait/robo_limb/New()
	..()
	trait_name = "Prosthetic [robo_limb_name]"
	trait_desc = "Has their [robo_limb_name] replaced with a prosthetic."

/datum/character_trait/robo_limb/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	var/obj/limb/limb = target.get_limb(code_limb)
	limb.robotize()
	target.update_body()
	return ..()

/datum/character_trait/robo_limb/left_leg
	robo_limb_name = "Left Leg"
	code_limb = "l_leg"
	applyable = TRUE

/datum/character_trait/robo_limb/right_leg
	robo_limb_name = "Right Leg"
	code_limb = "r_leg"
	applyable = TRUE

/datum/character_trait/robo_limb/left_arm
	robo_limb_name = "Left Arm"
	code_limb = "l_arm"
	applyable = TRUE

/datum/character_trait/robo_limb/right_arm
	robo_limb_name = "Right Arm"
	code_limb = "r_arm"
	applyable = TRUE
