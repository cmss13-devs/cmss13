// Individual skill
/datum/skill
	/// Name of the skill
	var/skill_name = null
	/// used for the view UI
	var/readable_skill_name = null
	/// Level of skill in this... skill
	var/skill_level = 0
	/// the max level this skill can be, used for tgui
	var/max_skill_level = 0

/datum/skill/proc/get_skill_level()
	return skill_level

/datum/skill/proc/set_skill(new_level, mob/owner)
	skill_level = new_level

/datum/skill/proc/is_skilled(req_level, is_explicit = FALSE)
	if(is_explicit)
		return (skill_level == req_level)
	return (skill_level >= req_level)

// Lots of defines here. See #define/skills.dm

/datum/skill/cqc
	skill_name = SKILL_CQC
	readable_skill_name = "CQC"
	skill_level = SKILL_CQC_DEFAULT
	max_skill_level = SKILL_CQC_MAX

/datum/skill/melee_weapons
	skill_name = SKILL_MELEE_WEAPONS
	readable_skill_name = "melee weapons"
	skill_level = SKILL_MELEE_DEFAULT
	max_skill_level = SKILL_MELEE_MAX

/datum/skill/firearms
	skill_name = SKILL_FIREARMS
	skill_level = SKILL_FIREARMS_TRAINED
	max_skill_level = SKILL_FIREARMS_MAX

/datum/skill/spec_weapons
	skill_name = SKILL_SPEC_WEAPONS
	readable_skill_name = "specialist weapons"
	skill_level = SKILL_SPEC_DEFAULT
	max_skill_level = SKILL_SPEC_ALL

/datum/skill/endurance
	skill_name = SKILL_ENDURANCE
	skill_level = SKILL_ENDURANCE_WEAK
	max_skill_level = SKILL_ENDURANCE_MAX

/datum/skill/engineer
	skill_name = SKILL_ENGINEER
	skill_level = SKILL_ENGINEER_DEFAULT
	max_skill_level = SKILL_ENGINEER_MAX

/datum/skill/construction
	skill_name = SKILL_CONSTRUCTION
	skill_level = SKILL_CONSTRUCTION_DEFAULT
	max_skill_level = SKILL_CONSTRUCTION_MAX

/datum/skill/leadership
	skill_name = SKILL_LEADERSHIP
	skill_level = SKILL_LEAD_NOVICE
	max_skill_level = SKILL_LEAD_MAX

/datum/skill/leadership/set_skill(new_level, mob/living/owner)
	..()
	if(!owner)
		return

	if(!ishuman(owner))
		return

	// Give/remove issue order actions
	if(is_skilled(SKILL_LEAD_TRAINED))
		ADD_TRAIT(owner, TRAIT_LEADERSHIP, TRAIT_SOURCE_SKILL(skill_name))
	else
		REMOVE_TRAIT(owner, TRAIT_LEADERSHIP, TRAIT_SOURCE_SKILL(skill_name))

/datum/skill/overwatch
	skill_name = SKILL_OVERWATCH
	skill_level = SKILL_OVERWATCH_DEFAULT
	max_skill_level = SKILL_OVERWATCH_MAX

/datum/skill/medical
	skill_name = SKILL_MEDICAL
	skill_level = SKILL_MEDICAL_DEFAULT
	max_skill_level = SKILL_MEDICAL_MAX

/datum/skill/surgery
	skill_name = SKILL_SURGERY
	skill_level = SKILL_SURGERY_DEFAULT
	max_skill_level = SKILL_SURGERY_MAX

/datum/skill/surgery/set_skill(new_level, mob/living/owner)
	..()
	if(!owner)
		return

	if(!ishuman(owner))
		return

	// Give/remove surgery toggle action
	var/datum/action/surgery_toggle/surgery_action = locate() in owner.actions
	if(is_skilled(SKILL_SURGERY_NOVICE))
		if(!surgery_action)
			give_action(owner, /datum/action/surgery_toggle)
		else
			surgery_action.update_surgery_skill()
	else
		if(surgery_action)
			surgery_action.remove_from(owner)

/datum/skill/research
	skill_name = SKILL_RESEARCH
	skill_level = SKILL_RESEARCH_DEFAULT
	max_skill_level = SKILL_RESEARCH_MAX

/datum/skill/antag
	skill_name = SKILL_ANTAG
	readable_skill_name = "illegal technology"
	skill_level = SKILL_ANTAG_DEFAULT
	max_skill_level = SKILL_ANTAG_MAX

/datum/skill/pilot
	skill_name = SKILL_PILOT
	skill_level = SKILL_PILOT_DEFAULT
	max_skill_level = SKILL_PILOT_MAX

/datum/skill/navigations
	skill_name = SKILL_NAVIGATIONS
	skill_level = SKILL_NAVIGATIONS_DEFAULT
	max_skill_level = SKILL_NAVIGATIONS_MAX

/datum/skill/police
	skill_name = SKILL_POLICE
	skill_level = SKILL_POLICE_DEFAULT
	max_skill_level = SKILL_POLICE_MAX

/datum/skill/powerloader
	skill_name = SKILL_POWERLOADER
	skill_level = SKILL_POWERLOADER_DEFAULT
	max_skill_level = SKILL_POWERLOADER_MAX

/datum/skill/vehicles
	skill_name = SKILL_VEHICLE
	skill_level = SKILL_VEHICLE_DEFAULT
	max_skill_level = SKILL_VEHICLE_MAX

/datum/skill/jtac
	skill_name = SKILL_JTAC
	readable_skill_name = "JTAC"
	skill_level = SKILL_JTAC_NOVICE
	max_skill_level = SKILL_JTAC_MAX

/datum/skill/execution
	skill_name = SKILL_EXECUTION
	skill_level = SKILL_EXECUTION_DEFAULT
	max_skill_level = SKILL_EXECUTION_MAX

/datum/skill/intel
	skill_name = SKILL_INTEL
	skill_level = SKILL_INTEL_NOVICE
	max_skill_level = SKILL_INTEL_MAX

/datum/skill/domestic
	skill_name = SKILL_DOMESTIC
	skill_level = SKILL_DOMESTIC_NONE
	max_skill_level = SKILL_DOMESTIC_MAX

/datum/skill/fireman
	skill_name = SKILL_FIREMAN
	readable_skill_name = "fireman carrying"
	skill_level = SKILL_FIREMAN_DEFAULT
	max_skill_level = SKILL_FIREMAN_MAX

/// Skill with an extra S at the end is a collection of multiple skills. Basically a skillSET
/// This is to organize and provide a common interface to the huge heap of skills there are
/datum/skills
	/// The name of the skillset
	var/name
	/// The mob that has this skillset
	var/mob/owner

	/// List of skill datums.
	/// Also, if this is populated when the datum is created, it will set the skill levels automagically
	var/list/skills = list()
	/// Same as above, but for children of parents that just add a lil something else
	var/list/additional_skills = list()

/datum/skills/New(mob/skillset_owner)
	owner = skillset_owner

	// Setup every single skill
	for(var/skill_type in subtypesof(/datum/skill))
		var/datum/skill/S = new skill_type()

		// Fancy hack to convert a list of desired skill levels in each named skill into a skill level in the actual skill datum
		// Lets the skills list be used multipurposely for both storing skill datums and choosing skill levels for different skillsets
		var/predetermined_skill_level = additional_skills[S.skill_name] ? additional_skills[S.skill_name] : skills[S.skill_name]
		skills[S.skill_name] = S

		if(!isnull(predetermined_skill_level))
			S.set_skill(predetermined_skill_level, owner)

/datum/skills/Destroy()
	owner = null
	skills = null // Don't need to delete, /datum/skill should softdel
	SStgui.close_uis(src)
	return ..()

// Checks if the given skill is contained in this skillset at all
/datum/skills/proc/has_skill(skill)
	return isnull(skills[skill])

// Returns the skill DATUM for the given skill
/datum/skills/proc/get_skill(skill)
	if(!skills)
		return null
	return skills[skill]

// Returns the skill level for the given skill
/datum/skills/proc/get_skill_level(skill)
	var/datum/skill/S = get_skill(skill)
	if(!S)
		return -1
	if(QDELETED(S))
		return -1
	return S.get_skill_level()

// Sets the skill LEVEL for a given skill
/datum/skills/proc/set_skill(skill, new_level)
	var/datum/skill/S = skills[skill]
	if(!S)
		return
	return S.set_skill(new_level, owner)

/datum/skills/proc/increment_skill(skill, increment, cap)
	var/datum/skill/S = skills[skill]
	if(!S || skillcheck(owner, skill, cap))
		return
	return S.set_skill(min(cap,S.skill_level+increment), owner)

/datum/skills/proc/decrement_skill(skill, increment)
	var/datum/skill/S = skills[skill]
	if(!S)
		return
	return S.set_skill(max(0,S.skill_level-increment), owner)

// Checks if the skillset is AT LEAST skilled enough to pass a skillcheck for the given skill level
/datum/skills/proc/is_skilled(skill, req_level, is_explicit = FALSE)
	var/datum/skill/S = get_skill(skill)
	if(QDELETED(S))
		return FALSE
	return S.is_skilled(req_level, is_explicit)

// Adjusts the full skillset to a new type of skillset. Pass the datum type path for the desired skillset
/datum/skills/proc/set_skillset(skillset_type)
	var/datum/skills/skillset = new skillset_type()
	var/list/skill_levels = initial(skillset.skills)

	name = skillset.name
	for(var/skill in skill_levels)
		set_skill(skill, skill_levels[skill])
	qdel(skillset)
