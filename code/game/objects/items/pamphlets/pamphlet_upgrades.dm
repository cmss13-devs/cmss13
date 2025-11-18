//-------//
//upgradeable skill pamphlets
//------//

/obj/item/pamphlet/upgradeable
	bypass_pamphlet_limit = TRUE
	/// What skill should be upgraded?
	var/skill_upgrade
	/// The secondary skill to upgrade
	var/second_upgrade
	/// How much the skill level is increased, ideally only 1 and only at 1
	var/skill_increment = 1
	/// The maximum level this can get the skill to
	var/skill_cap = 1
	flavour_text = "You review the pamphlet, further reinforcing your knowledge of the skill."

/obj/item/pamphlet/upgradeable/can_use(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!user.skills)
		return FALSE
	if(user.skills.get_skill_level(skill_upgrade) >= skill_cap)
		to_chat(user, SPAN_WARNING("You won't learn anything new from this."))
		return FALSE
	return TRUE

/obj/item/pamphlet/upgradeable/on_use(mob/living/carbon/human/user)
	if(user.skills.get_skill_level(skill_upgrade) == 0)
		to_chat(user, SPAN_NOTICE("You read over the pamphlet a few times, learning a new skill."))
		user.skills.increment_skill(skill_upgrade, skill_increment, skill_cap)
		if(second_upgrade)
			user.skills.increment_skill(second_upgrade, skill_increment, skill_cap)
	else
		to_chat(user, SPAN_NOTICE(flavour_text))
		user.skills.increment_skill(skill_upgrade, skill_increment, skill_cap)
		if(second_upgrade)
			user.skills.increment_skill(second_upgrade, skill_increment, skill_cap)

//-------//
//the actual ugprade pamphlets
//------//
/obj/item/pamphlet/upgradeable/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	skill_upgrade = SKILL_MEDICAL

/obj/item/pamphlet/upgradeable/science
	name = "scientific instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a scientific insignia."
	icon_state = "pamphlet_science"
	skill_upgrade = SKILL_RESEARCH

/obj/item/pamphlet/upgradeable/engineer
	name = "engineer instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia."
	icon_state = "pamphlet_construction"
	skill_upgrade = SKILL_CONSTRUCTION
	second_upgrade = SKILL_ENGINEER

/obj/item/pamphlet/upgradeable/jtac
	name = "JTAC instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a radio on it."
	icon_state = "pamphlet_jtac"
	skill_upgrade = SKILL_JTAC

/obj/item/pamphlet/upgradeable/powerloader
	name = "powerloader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a powerloader insignia. The title reads 'Moving freight and squishing heads - a practical guide to Caterpillar P-5000 Work Loader'."
	icon_state = "pamphlet_powerloader"
	skill_upgrade = SKILL_POWERLOADER

/obj/item/pamphlet/upgradeable/police
	name = "Policing instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a radio on it."
	icon_state = "pamphlet_jtac"
	skill_upgrade = SKILL_POLICE

/obj/item/pamphlet/upgradeable/intel
	name = "field intelligence instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an intelligence insignia."
	icon_state = "pamphlet_reading"
	skill_upgrade = SKILL_INTEL

/obj/item/pamphlet/upgradeable/machinegunner
	name = "heavy machinegunner instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering and a machinegun insignia."
	icon_state = "pamphlet_machinegunner"
	skill_upgrade = SKILL_ENGINEER
