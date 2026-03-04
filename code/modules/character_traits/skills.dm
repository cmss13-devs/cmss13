/datum/character_trait_group/skills
	trait_group_name = "Skills"
	group_visible = FALSE


/datum/character_trait/skills
	var/skill //The skill that will be upgraded
	var/secondary_skill //Put a second skill here if two are needed
	var/skill_increment = 1 //How much the skill level is increased
	var/skill_cap = 1 //The maximum level this can get the skill to
	var/secondary_skill_cap
	applyable = FALSE
	trait_group = /datum/character_trait_group/skills

/datum/character_trait/skills/New()
	..()

	if(!secondary_skill_cap)
		secondary_skill_cap = skill_cap


/datum/character_trait/skills/apply_trait(mob/living/carbon/human/target)
	..()

	target.skills.increment_skill(skill,skill_increment,skill_cap)

	target.skills.increment_skill(secondary_skill,skill_increment,secondary_skill_cap)


/datum/character_trait/skills/unapply_trait(mob/living/carbon/human/target)
	..()

	target.skills.decrement_skill(skill,skill_increment)

	if (secondary_skill)
		target.skills.decrement_skill(secondary_skill,skill_increment)


	/*
/datum/character_trait/skills
	trait_name = ""
	trait_desc = ""
	skill =
	*/

/datum/character_trait/skills/miniengie/antag // deprecate this eventually
	trait_name = "Field Technician Training"
	trait_desc = "Boosts the construction and engineering skills to 2. Crewmember received full training in creating fortifications and maintaining various machinery."
	skill = SKILL_CONSTRUCTION
	secondary_skill = SKILL_ENGINEER
	skill_cap = 2
	skill_increment = 2

/datum/character_trait/skills/vc
	trait_name = "Vehicle Crewman Training"
	trait_desc = "Boosts the engineering and vehicle operation skills to 2. Crewmember received full vehicle crewman training."
	skill = SKILL_VEHICLE
	secondary_skill = SKILL_ENGINEER
	skill_cap = 3
	secondary_skill_cap = 2
	skill_increment = 3

/datum/character_trait/skills/cosmartgun
	trait_name = "Smartgun Training"
	trait_desc = "Gives the CO information on his smartgun."
	skill = SKILL_SPEC_WEAPONS
	skill_cap =  SKILL_SPEC_SMARTGUN
	skill_increment = 7

/datum/character_trait/skills/spotter
	trait_name = "Spotter Training"
	trait_desc = "Boosts the JTAC skill by 1. Crewmember received additional training in using JTAC equipment and Ghillie outfits."
	skill = SKILL_JTAC

/datum/character_trait/skills/loader
	trait_name = "Loader Training"
	trait_desc = "Boosts the engineering skill by 1."
	skill = SKILL_ENGINEER
	skill_cap = SKILL_ENGINEER_NOVICE
	skill_increment = 1

/datum/character_trait/skills/mortar
	trait_name = "Mortar Training"
	trait_desc = "Boosts the engineering skill by 1 and JTAC skill by 2."
	skill = SKILL_ENGINEER
	secondary_skill = SKILL_JTAC
	skill_cap = SKILL_ENGINEER_NOVICE
	secondary_skill_cap = SKILL_JTAC_TRAINED
	skill_increment = 2

/datum/character_trait/skills/k9_handler
	trait_name = "K9 Handler Training"
	trait_desc = "Allows the user to interface with Wey-Yu Synthetic K9 Units for rescue purposes."
	skill = SKILL_JTAC
	secondary_skill = SKILL_ENGINEER //enables the handler to use standard synth reset keys as well as easier repairs for the dog
	skill_cap = SKILL_ENGINEER_NOVICE
