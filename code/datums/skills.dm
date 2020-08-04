// Individual skill
/datum/skill
	var/skill_name = "Skill" // Name of the skill
	var/skill_level = 0 // Level of skill in this... skill

/datum/skill/proc/get_skill_level()
	return skill_level

/datum/skill/proc/set_skill(var/new_level, var/mob/owner)
	skill_level = new_level

/datum/skill/proc/is_skilled(var/req_level, var/is_explicit = FALSE)
	if(is_explicit)
		return (skill_level == req_level)
	return (skill_level >= req_level)

// Lots of defines here. See #define/skills.dm

/datum/skill/cqc
	skill_name = SKILL_CQC
	skill_level = SKILL_CQC_DEFAULT

/datum/skill/melee_weapons
	skill_name = SKILL_MELEE_WEAPONS
	skill_level = SKILL_MELEE_DEFAULT

/datum/skill/firearms
	skill_name = SKILL_FIREARMS
	skill_level = SKILL_FIREARMS_DEFAULT

/datum/skill/spec_weapons
	skill_name = SKILL_SPEC_WEAPONS
	skill_level = SKILL_SPEC_DEFAULT

/datum/skill/endurance
	skill_name = SKILL_ENDURANCE
	skill_level = SKILL_ENDURANCE_WEAK

/datum/skill/engineer
	skill_name = SKILL_ENGINEER
	skill_level = SKILL_ENGINEER_DEFAULT

/datum/skill/construction
	skill_name = SKILL_CONSTRUCTION
	skill_level = SKILL_CONSTRUCTION_DEFAULT

/datum/skill/leadership
	skill_name = SKILL_LEADERSHIP
	skill_level = SKILL_LEAD_NOVICE

/datum/skill/leadership/set_skill(var/new_level, var/mob/owner)
	..()
	if(!owner)
		return

	var/mob/living/M = owner
	if(!ishuman(M))
		return

	// Give/remove issue order actions
	if(is_skilled(SKILL_LEAD_TRAINED))
		for(var/action_type in subtypesof(/datum/action/human_action/issue_order))
			if(locate(action_type) in M.actions)
				continue

			var/datum/action/human_action/issue_order/O = new action_type()
			O.give_action(M)
	else
		for(var/datum/action/human_action/issue_order/O in M.actions)
			O.remove_action(M)

/datum/skill/medical
	skill_name = SKILL_MEDICAL
	skill_level = SKILL_MEDICAL_DEFAULT

/datum/skill/surgery
	skill_name = SKILL_SURGERY
	skill_level = SKILL_SURGERY_DEFAULT

/datum/skill/research
	skill_name = SKILL_RESEARCH
	skill_level = SKILL_RESEARCH_DEFAULT

/datum/skill/pilot
	skill_name = SKILL_PILOT
	skill_level = SKILL_PILOT_DEFAULT

/datum/skill/police
	skill_name = SKILL_POLICE
	skill_level = SKILL_POLICE_DEFAULT

/datum/skill/powerloader
	skill_name = SKILL_POWERLOADER
	skill_level = SKILL_POWERLOADER_DEFAULT

/datum/skill/vehicles
	skill_name = SKILL_VEHICLE
	skill_level = SKILL_VEHICLE_DEFAULT

// Skill with an extra S at the end is a collection of multiple skills. Basically a skillSET
// This is to organize and provide a common interface to the huge heap of skills there are
/datum/skills
	var/name //the name of the skillset
	var/mob/owner = null // the mind that has this skillset

	// List of skill datums.
	// Also, if this is populated when the datum is created, it will set the skill levels automagically
	var/list/skills = list()

/datum/skills/New(var/mob/skillset_owner)
	owner = skillset_owner

	// Setup every single skill
	for(var/skill_type in subtypesof(/datum/skill))
		var/datum/skill/S = new skill_type()

		// Fancy hack to convert a list of desired skill levels in each named skill into a skill level in the actual skill datum
		// Lets the skills list be used multipurposely for both storing skill datums and choosing skill levels for different skillsets
		var/predetermined_skill_level = skills[S.skill_name]
		skills[S.skill_name] = S

		if(!isnull(predetermined_skill_level))
			S.set_skill(predetermined_skill_level, owner)

/datum/skills/Dispose()
	owner = null

	for(var/datum/skill/S in skills)
		qdel(S)
		skills -= S

// Checks if the given skill is contained in this skillset at all
/datum/skills/proc/has_skill(var/skill)
	return isnull(skills[skill])

// Returns the skill DATUM for the given skill
/datum/skills/proc/get_skill(var/skill)
	return skills[skill]

// Returns the skill level for the given skill
/datum/skills/proc/get_skill_level(var/skill)
	var/datum/skill/S = get_skill(skill)
	if(QDELETED(S))
		return -1
	return S.get_skill_level()

// Sets the skill LEVEL for a given skill
/datum/skills/proc/set_skill(var/skill, var/new_level)
	var/datum/skill/S = skills[skill]
	if(!S)
		return
	return S.set_skill(new_level, owner)

// Checks if the skillset is AT LEAST skilled enough to pass a skillcheck for the given skill level
/datum/skills/proc/is_skilled(var/skill, var/req_level, var/is_explicit = FALSE)
	var/datum/skill/S = get_skill(skill)
	if(QDELETED(S))
		return FALSE
	return S.is_skilled(req_level, is_explicit)

// Adjusts the full skillset to a new type of skillset. Pass the datum type path for the desired skillset
/datum/skills/proc/set_skillset(var/skillset_type)
	var/datum/skills/skillset = new skillset_type()
	var/list/skill_levels = initial(skillset.skills)

	name = skillset.name
	for(var/skill in skill_levels)
		set_skill(skill, skill_levels[skill])
	qdel(skillset)

/*
---------------------
CIVILIAN
---------------------
*/

/datum/skills/civilian
	name = "Civilian"
	skills = list(
		SKILL_CQC = SKILL_CQC_DEFAULT,
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_NONE,
	)

/datum/skills/civilian/manager
	name = "Weston-Yamada Manager" // Semi-competent leader with basic knowledge in most things.
	skills = list(
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
	)


/datum/skills/civilian/survivor
	name = "Survivor"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
	)

/datum/skills/civilian/survivor/doctor
	name = "Survivor Doctor"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
	)

/datum/skills/civilian/survivor/scientist
	name = "Survivor Scientist"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
	)

/datum/skills/civilian/survivor/chef
	name = "Survivor Chef"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
	)

/datum/skills/civilian/survivor/miner
	name = "Survivor Miner"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/datum/skills/civilian/survivor/trucker
	name = "Survivor Trucker"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_VEHICLE = SKILL_VEHICLE_CREWMAN,
	)

/datum/skills/civilian/survivor/engineer
	name = "Survivor Engineer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/datum/skills/civilian/survivor/chaplain
	name = "Survivor Chaplain"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
	)

/datum/skills/civilian/survivor/marshall
	name = "Survivor Marshall"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_FIREARMS = SKILL_FIREARMS_DEFAULT,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
	)

/datum/skills/civilian/survivor/prisoner
	name = "Survivor Prisoner"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_FIREARMS = SKILL_FIREARMS_DEFAULT,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
	)

/datum/skills/civilian/survivor/gangleader
	name = "Survivor Gang Leader"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_FIREARMS = SKILL_FIREARMS_DEFAULT,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
	)
/*
---------------------
COMMAND STAFF
---------------------
*/

/datum/skills/admiral
	name = "Admiral"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_POLICE = SKILL_POLICE_FLASH,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
	)

/datum/skills/commander
	name = "Commanding Officer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_SMARTGUN,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_POLICE = SKILL_POLICE_FLASH,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER,
	)

/datum/skills/XO
	name = "Executive Officer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI, //to fix CIC apc.
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_POLICE = SKILL_POLICE_FLASH,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
	)

/datum/skills/SO
	name = "Staff Officer"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_POLICE = SKILL_POLICE_FLASH,
		SKILL_VEHICLE = SKILL_VEHICLE_SMALL,
	)

/datum/skills/SEA
	name = "Senior Enlisted Advisor"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
		SKILL_PILOT = SKILL_PILOT_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_VEHICLE = SKILL_VEHICLE_LARGE,
	)

/datum/skills/CMO
	name = "CMO"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
		SKILL_POLICE = SKILL_POLICE_FLASH,
	)

/datum/skills/CMP
	name = "Chief MP"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
	)

/datum/skills/CE
	name = "Chief Engineer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_MASTER,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_MASTER,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_POLICE = SKILL_POLICE_FLASH,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/datum/skills/RO
	name = "Requisition Officer"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_POLICE = SKILL_POLICE_FLASH,
	)

/*
---------------------
MILITARY NONCOMBATANT
---------------------
*/

/datum/skills/doctor
	name = "Doctor"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
	)

/datum/skills/researcher
	name = "Researcher"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
	)

/datum/skills/pilot
	name = "Pilot Officer"
	skills = list(
		SKILL_PILOT = SKILL_PILOT_TRAINED,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
	)

/datum/skills/MP
	name = "Military Police"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
	)

/datum/skills/OT
	name = "Ordnance Technician"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_MASTER,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_MASTER,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/datum/skills/CT
	name = "Cargo Technician"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/*
---------------------
SYNTHETIC
---------------------
*/

/datum/skills/synthetic
	name = "Synthetic"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_MASTER,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_MASTER,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MASTER,
		SKILL_SURGERY = SKILL_SURGERY_EXPERT,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_PILOT = SKILL_PILOT_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_VEHICLE = SKILL_VEHICLE_LARGE,
	)

/datum/skills/early_synthetic
	name = "Early Synthetic"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_PILOT = SKILL_PILOT_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_VEHICLE = SKILL_VEHICLE_LARGE,
	)

/*
------------------------------
United States Colonial Marines
------------------------------
*/

/datum/skills/pfc
	name = "Private"
	//same as default

/datum/skills/pfc/crafty
	name = "Crafty Private"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED
	)

/datum/skills/combat_medic
	name = "Combat Medic"
	skills = list(
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC
	)

/datum/skills/combat_medic/crafty
	name = "Crafty Combat Medic"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED
	)

/datum/skills/combat_engineer
	name = "Combat Engineer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER
	)

/datum/skills/smartgunner
	name = "Squad Smartgunner"
	skills = list(
		SKILL_SPEC_WEAPONS = SKILL_SPEC_SMARTGUN,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER
	)

/datum/skills/specialist
	name = "Squad Specialist"
	skills = list(
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED, //to use c4 in scout set.
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED
	)

/datum/skills/SL
	name = "Squad Leader"
	skills = list(
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
		SKILL_VEHICLE = SKILL_VEHICLE_SMALL
	)

/datum/skills/intel
	name = "Intelligence Officer"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_RESEARCH = SKILL_RESEARCH_TRAINED,
	)


/*
-------------------------
COLONIAL LIBERATION FRONT
-------------------------
*/

//NOTE: The CLF have less firearms skill, but compensate with additional civilian skills and resourcefulness

/datum/skills/clf
	name = "CLF Soldier"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_MELEE = SKILL_MELEE_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_POWERLOADER = SKILL_POWERLOADER_TRAINED,
		SKILL_VEHICLE = SKILL_VEHICLE_SMALL,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)

/datum/skills/clf/combat_engineer
	name = "CLF Engineer"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
	)

/datum/skills/clf/combat_medic
	name = "CLF Medic"
	skills = list(
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED
	)

/datum/skills/clf/specialist
	name = "CLF Specialist"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_FIREARMS = SKILL_FIREARMS_DEFAULT,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
	)

/datum/skills/clf/leader
	name = "CLF Leader"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_DEFAULT,
		SKILL_CQC = SKILL_CQC_EXPERT,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT
	)

/*
-----------
FREELANCERS
-----------
*/

//NOTE: Freelancer training is similar to the USCM's, but with additional construction skills

/datum/skills/freelancer
	name = "Freelancer Private"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
	)

/datum/skills/freelancer/combat_medic
	name = "Freelancer Medic"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC
	)

/datum/skills/freelancer/SL
	name = "Freelancer Leader"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT
	)

/*
--------------------------
UNITED PROGRESSIVE PEOPLES
--------------------------
*/

//NOTE: UPP training is similar to the USCM's, but with additional construction skills

/datum/skills/upp
	name = "UPP Private"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED
	)

/datum/skills/upp/combat_engineer
	name = "UPP Engineer"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI
	)

/datum/skills/upp/combat_medic
	name = "UPP Medic"
	skills = list(
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC
	)

/datum/skills/upp/specialist
	name = "UPP Specialist"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_UPP,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED
	)

/datum/skills/upp/SL
	name = "UPP Leader"
	skills = list(
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC
	)

/*
----------------------------
Private Military Contractors
----------------------------
*/

//NOTE: Compared to the USCM, PMCs have additional firearms training, construction skills and policing skills

/datum/skills/pmc
	name = "PMC Private"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER
	)

/datum/skills/pmc/medic
	name = "PMC Medic"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER
	)

/datum/skills/pmc/smartgunner
	name = "PMC Smartgunner"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_SMARTGUN,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER
	)

/datum/skills/pmc/specialist
	name = "PMC Specialist"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER
	)

/datum/skills/pmc/SL
	name = "PMC Leader"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_POLICE = SKILL_POLICE_MP,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER
	)

/*
---------------------
SPEC-OPS
---------------------
*/

/datum/skills/commando
	name = "Commando"
	skills = list(
		SKILL_CQC = SKILL_CQC_EXPERT,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
	)

/datum/skills/commando/medic
	name = "Commando Medic"
	skills = list(
		SKILL_CQC = SKILL_CQC_EXPERT,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
	)

/datum/skills/commando/leader
	name = "Commando Leader"
	skills = list(
		SKILL_CQC = SKILL_CQC_EXPERT,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
	)

/datum/skills/commando/deathsquad
	name = "Deathsquad"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
	)

/datum/skills/spy
	name = "Spy"
	skills = list(
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
	)

/datum/skills/ninja
	name = "Ninja"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER
	)

/*
---------------------
MISCELLANEOUS
---------------------
*/

/datum/skills/mercenary
	name = "Mercenary"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_BEGINNER,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED
	)

/datum/skills/tank_crew
	name = "Vehicle Crewman"
	skills = list(
		SKILL_VEHICLE = SKILL_VEHICLE_CREWMAN,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED
	)

/datum/skills/gladiator
	name = "Gladiator"
	skills = list(
		SKILL_CQC = SKILL_CQC_MP,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_TRAINED,
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_NOVICE,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)

/datum/skills/gladiator/champion
	name = "Gladiator Champion"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)

/datum/skills/gladiator/champion/leader
	name = "Gladiator Leader"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER, //Spartacus!
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)

/datum/skills/yautja/warrior
	name = "Yautja Warrior"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_EXPERT,
		SKILL_POLICE = SKILL_POLICE_MP
	)

/datum/skills/dutch
	name = "Dutch"
	skills = list(
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_FIREARMS = SKILL_FIREARMS_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_EXPERT,
		SKILL_MEDICAL = SKILL_MEDICAL_TRAINED,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)

/datum/skills/cultist_leader
	name = "Cultist Leader"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_UNTRAINED,
		SKILL_CQC = SKILL_CQC_MASTER,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_MASTER,
		SKILL_ENGINEER = SKILL_ENGINEER_MASTER,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_ENDURANCE = SKILL_ENDURANCE_SURVIVOR
	)