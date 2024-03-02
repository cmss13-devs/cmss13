/datum/character_trait_group/skills
	trait_group_name = "Skills"
	group_visible = TRUE


/datum/character_trait/skills
	var/skill //The skill that will be upgraded
	var/secondary_skill //Put a second skill here if two are needed
	var/skill_increment = 1 //How much the skill level is increased
	var/skill_cap = 1 //The maximum level this can get the skill to
	var/secondary_skill_cap
	applyable = TRUE
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


/datum/character_trait/skills/medical
	trait_name = "First Aid Training"
	trait_desc = "Boosts the medical skill to 1. Crewmember has attended several first aid training sessions and learned basic medical care."
	skill = SKILL_MEDICAL
	cost = 2

/datum/character_trait/skills/engineering
	trait_name = "Basic Engineering Training"
	trait_desc = "Boosts the engineering skill to 1. Crewmember received basic training in repairing simple machinery and fortifications."
	skill = SKILL_ENGINEER
	applyable = FALSE

/datum/character_trait/skills/construction
	trait_name = "Basic Construction Training"
	trait_desc = "Boosts the construction skill to 1. Crewmember received training in constructing simple fortifications."
	skill = SKILL_CONSTRUCTION
	applyable = FALSE

/datum/character_trait/skills/miniengie
	trait_name = "Field Technician Training"
	trait_desc = "Boosts the construction and engineering skills to 1. Crewmember received basic training in creating fortifications and maintaining simple machinery."
	skill = SKILL_CONSTRUCTION
	secondary_skill = SKILL_ENGINEER
	cost = 2

/datum/character_trait/skills/miniengie/antag
	trait_name = "Field Technician Training"
	trait_desc = "Boosts the construction and engineering skills to 2. Crewmember received full training in creating fortifications and maintaining various machinery."
	skill_cap = 2
	skill_increment = 2
	applyable = FALSE

/datum/character_trait/skills/vc
	trait_name = "Vehicle Crewman Training"
	trait_desc = "Boosts the engineering and vehicle operation skills to 2. Crewmember received full vehicle crewman training."
	skill = SKILL_VEHICLE
	secondary_skill = SKILL_ENGINEER
	skill_cap = 3
	secondary_skill_cap = 2
	skill_increment = 3
	applyable = FALSE

/datum/character_trait/skills/jtac
	trait_name = "JTAC Training"
	trait_desc = "Boosts the JTAC skill by 1. Crewmember received additional training in using JTAC equipment."
	skill = SKILL_JTAC
	cost = 2

/datum/character_trait/skills/spotter
	trait_name = "Spotter Training"
	trait_desc = "Boosts the JTAC skill by 1. Crewmember received additional training in using JTAC equipment and Ghillie outfits."
	skill = SKILL_JTAC
	applyable = FALSE

/datum/character_trait/skills/powerloader
	trait_name = "Powerloader Usage Training"
	trait_desc = "Boosts the powerloader skill to 1. Crewmember received training in operating powerloaders."
	skill = SKILL_POWERLOADER
	cost = 2

/datum/character_trait/skills/cqc
	trait_name = "Close Quarters Training"
	trait_desc = "Boosts the cqc skill to 1. Crewmember passed trough basic cqc course, and deals more damage in close combat (+1 brute per level), and have more chances to disarm the opponent (+10% per level)."
	skill = SKILL_CQC
	skill_cap = 3
	skill_increment = 1
	cost = 2

/datum/character_trait/skills/fireman
	trait_name = "Heavy Lifting Training"
	trait_desc = "Boosts the Fireman Carry skill to 1. Crewmember working out at the gym too much, and have a big muscles, physical strength allowed him to carry people on his back."
	skill = SKILL_FIREMAN
	skill_cap = 3
	skill_increment = 1
	cost = 2

/datum/character_trait/skills/endurance
	trait_name = "Advance Physical Training"
	trait_desc = "Boosts the Endurance skill to 1. Crewmember passed trough advance physical training course, and now can better withstand agaisnt physical traumas and hazard conditions."
	skill = SKILL_ENDURANCE
	skill_cap = 3
	skill_increment = 1
	cost = 2

/datum/character_trait/skills/intel
	trait_name = "Intelligence training"
	trait_desc = "Boosts the Intel skill to 1. Crewmember received training in quickly processing intelligence documents."
	skill = SKILL_INTEL
	cost = 2

/datum/character_trait/skills/police
	trait_name = "Police Training"
	trait_desc = "Boosts the policing skill by 1. Crewmember received training in use of security equipment."
	skill = SKILL_POLICE
	cost = 2

/datum/character_trait/skills/surgery
	trait_name = "Surgery Training"
	trait_desc = "Boosts the surgery and research skills. Crewmember received training in surgery and advanced R&D."
	skill = SKILL_SURGERY
	secondary_skill = SKILL_RESEARCH
	secondary_skill_cap = 3
	skill_increment = 3
	applyable = FALSE
