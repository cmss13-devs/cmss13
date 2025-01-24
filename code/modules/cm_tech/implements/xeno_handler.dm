//Xenomorphs, hostile to everyone.
/datum/emergency_call/xeno_handler
	name = "Xenomorph Handler"
	mob_max = 8
	probability = 0
	auto_shuttle_launch = TRUE //because xenos can't use the shuttle console.
	hostility = FALSE
	spawn_max_amount = TRUE

/datum/emergency_call/xeno_handler/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], corrupted xenos with a trainer have been sent your way."
	objectives = "Listen to the human that gives you directives, they are your master. If you are this human, give orders to the Xenomorphs. They are expected to listen to you."


/datum/emergency_call/xeno_handler/spawn_items()
	var/turf/drop_spawn = get_spawn_point(TRUE)
	if(istype(drop_spawn))
		new /obj/effect/alien/weeds/node(drop_spawn, null, null, GLOB.faction_datums[FACTION_XENOMORPH_TAMED]) //drop some weeds for xeno plasma regen.

/datum/emergency_call/xeno_handler/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/datum/faction/tamed_hive = GLOB.faction_datums[FACTION_XENOMORPH_TAMED]
	var/mob/living/carbon/new_mob
	if(!leader)
		new_mob = new/mob/living/carbon/human(spawn_loc)
		new_mob.create_hud()
		arm_equipment(new_mob, /datum/equipment_preset/pmc/xeno_handler, TRUE, TRUE)

		var/datum/faction_module/hive_mind/faction_module = tamed_hive.get_faction_module(FACTION_MODULE_HIVE_MIND)
		faction_module.make_leader(new_mob)
		leader = new_mob
	else
		var/picked = pick(/mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/spitter, /mob/living/carbon/xenomorph/lurker)
		new_mob = new picked(spawn_loc, null, tamed_hive)
		var/mob/living/carbon/xenomorph/X = new_mob
		X.faction_tag = new /obj/item/faction_tag/wy/pmc_handler(X, GLOB.faction_datums[FACTION_USCM])
	if(M)
		M.transfer_to(new_mob, TRUE)
	else
		new_mob.away_timer = XENO_LEAVE_TIMER
		new_mob.free_for_ghosts()

/datum/skills/pmc/xeno_handler
	name = "PMC Xeno Handler"
	skills = list(
		SKILL_FIREARMS = SKILL_FIREARMS_EXPERT,
		SKILL_POLICE = SKILL_POLICE_SKILLED,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
		SKILL_LEADERSHIP = SKILL_LEAD_MASTER,
		SKILL_OVERWATCH = SKILL_OVERWATCH_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_EXPERT,
	)
