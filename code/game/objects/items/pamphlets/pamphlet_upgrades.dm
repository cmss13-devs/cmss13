//-------//
//upgradeable skill pamphlets
//------//

/obj/item/pamphlet/upgradeable
	bypass_pamphlet_limit = TRUE
	/// What skill should be upgraded?
	var/skill_upgrade
	/// The secondary skill to upgrade
	var/second_upgrade
	/// How much the skill level is increased, ideally only 1 and only at 1 for most
	var/skill_increment = 1
	/// The maximum level this can get the skill to
	var/skill_cap = 1

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
		to_chat(user, SPAN_NOTICE("You read over \the [name] a few times, learning a new skill."))
		user.skills.increment_skill(skill_upgrade, skill_increment, skill_cap)
		if(second_upgrade && user.skills.get_skill_level(second_upgrade) == 0)
			to_chat(user, SPAN_NOTICE("...You also learn a new skill alongside it!"))
			user.skills.increment_skill(second_upgrade, skill_increment, skill_cap)
	else
		to_chat(user, SPAN_NOTICE("You review \the [name], further reinforcing your knowledge of the skill."))
		user.skills.increment_skill(skill_upgrade, skill_increment, skill_cap)

	if((second_upgrade) && user.skills.get_skill_level(second_upgrade) < skill_cap)
		to_chat(user, SPAN_NOTICE("...You also reinforce your understanding of another skill!"))
		user.skills.increment_skill(second_upgrade, skill_increment, skill_cap)

//-------//
//the actual ugprade pamphlets
//------//
/obj/item/pamphlet/upgradeable/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of proper medical practices and applications."
	icon_state = "pamphlet_medical"
	skill_upgrade = SKILL_MEDICAL

/obj/item/pamphlet/upgradeable/science
	name = "scientific instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of science, and how to operate its various egg-headed machineries and other research-qualitative practices."
	icon_state = "pamphlet_science"
	skill_upgrade = SKILL_RESEARCH

/obj/item/pamphlet/upgradeable/engineer
	name = "engineer instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of maintaining and repairing machinery, and among other forms of construction work as well. You suppose it could impart some knowledge regarding the use of heavier-duty equipment "
	icon_state = "pamphlet_construction"
	skill_upgrade = SKILL_CONSTRUCTION
	second_upgrade = SKILL_ENGINEER

/obj/item/pamphlet/upgradeable/jtac
	name = "JTAC instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of being a Joint Terminal Attack Controller, or JTAC for short. "
	icon_state = "pamphlet_jtac"
	skill_upgrade = SKILL_JTAC
	skill_cap = 2

/obj/item/pamphlet/upgradeable/powerloader
	name = "powerloader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a powerloader insignia. The title reads 'Moving freight and squishing heads - a practical guide to Caterpillar P-5000 Work Loader'."
	icon_state = "pamphlet_powerloader"
	skill_upgrade = SKILL_POWERLOADER
	skill_cap = 2 // amuse me

/obj/item/pamphlet/upgradeable/police
	name = "policing instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge and practices of policing criminals. It doesn't actually teach you the law, though."
	icon_state = "pamphlet_jtac"
	skill_upgrade = SKILL_POLICE

/obj/item/pamphlet/upgradeable/intel
	name = "field intelligence instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of reading between the fine print and sifting through databases."
	icon_state = "pamphlet_reading"
	skill_upgrade = SKILL_INTEL
	skill_cap = 2

/obj/item/pamphlet/upgradeable/machinegunner
	name = "heavy machinegunner instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge on heavier-duty equipments and firearms. You suppose you can utilize some of its teachings for some engineering practices."
	icon_state = "pamphlet_machinegunner"
	skill_upgrade = SKILL_ENGINEER
	skill_cap = 2

/obj/item/pamphlet/upgradeable/surgery
	name = "Surgery instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge on medical surgery... it doesn't seem to teach you how to use other medical applications or devices, strangely."
	icon_state = "pamphlet_medical"
	skill_upgrade = SKILL_SURGERY
	skill_cap = 2

/obj/item/pamphlet/upgradeable/vehicles
	name = "vehicle training manual"
	desc = "A manual used to quickly impart vital knowledge on driving vehicles."
	icon_state = "pamphlet_vehicle"
	skill_upgrade = SKILL_VEHICLE

/obj/item/pamphlet/upgradeable/overwatch
	name = "overwatch console manual"
	desc = "A manual used to quickly impart vital knowledge on operating overwatch consoles."
	skill_upgrade = SKILL_OVERWATCH
