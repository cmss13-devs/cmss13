/datum/emergency_call/upp/beacon
	name = "UPP Naval Infantry (Squad) (Beacon)"
	mob_max = 6
	mob_min = 1
	spawn_max_amount = TRUE
	shuttle_id = MOBILE_SHUTTLE_ID_ERT3
	home_base = /datum/lazy_template/ert/upp_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_upp
	item_spawn = /obj/effect/landmark/ert_spawns/distress_upp/item
	max_medics = 1
	max_engineers = 1

/datum/emergency_call/upp/beacon/New()
	. = ..()
	arrival_message = "[MAIN_SHIP_NAME], this is the SVV Haldin of the Union of Progressive Peoples. We hear your call for reinforcements and are sending our forces to assist you."
	objectives = "Render assistance towards the UA Forces, do not engage UA forces. Listen to your superior officers."

/datum/emergency_call/upp/beacon/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You grew up in relatively simple family in [pick(75;"Eurasia", 25;"a famished UPP colony")] with few belongings or luxuries."))
		to_chat(M, SPAN_BOLD("The family you grew up with were [pick(50;"getting by", 25;"impoverished", 25;"starving")] and you were one of [pick(10;"two", 20;"three", 20;"four", 30;"five", 20;"six")] children."))
		to_chat(M, SPAN_BOLD("You come from a long line of [pick(40;"crop-harvesters", 20;"soldiers", 20;"factory workers", 5;"scientists", 15;"engineers")], and quickly enlisted to improve your living conditions."))
		to_chat(M, SPAN_BOLD("Following your enlistment to the UPP military at the age of 17, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a UPP engineering facility, knowing only your engineers for the first few weeks for your pseudo-life."))
		to_chat(M, SPAN_BOLD("You were programmed with all of the medical and combat experience a military fighting force support asset required."))
		to_chat(M, SPAN_BOLD("Throughout your career, your engineers, and later, your UPP compatriots, treated you like [pick(75;"a tool, and only that.", 25;"a person, despite your purpose.")]"))
		to_chat(M, SPAN_BOLD("Some weeks after your unit integration, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
		to_chat(M, SPAN_BOLD("You were shipped off with the battalion to one of the UPP's most remote territories, a gas giant designated MV-35 in the Anglo-Japanese Arm, in the Neroid Sector."))
		to_chat(M, SPAN_BOLD("For the past 14 months, you and the rest of the Smoldering Sons have been stationed at MV-35's only facility, the helium refinery, Altai Station."))
		to_chat(M, SPAN_BOLD("As MV-35 and Altai Station are the only UPP-held zones in the Neroid Sector for many lightyears, you have spent most of your military career holed up in crammed quarters in near darkness, waiting for supply shipments and transport escort deployments."))
		to_chat(M, SPAN_BOLD("With the recent arrival of the USCM battalion the 'Falling Falcons' and their flagship, the [MAIN_SHIP_NAME], the UPP has felt threatened in the sector."))
		to_chat(M, SPAN_BOLD("Despite this, the leadership of your battalion questions what may have prompted the distress signal from their rivals. Your squad is to find out why and to render aid to the beleaguered UA forces."))
		to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to Colonel Ganbaatar.")))
		to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the Smoldering Sons.")))
		to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the UPP.")))

///////////////////UPP///////////////////////////

/datum/emergency_call/upp/beacon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job&& (spawning_mind)))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/upp/leader/beacon, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are an Officer of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job&& (spawning_mind)))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(mob, /datum/equipment_preset/upp/medic/beacon, TRUE, TRUE)
	else if(engineers < engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job&& (spawning_mind)))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Sapper of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(mob, /datum/equipment_preset/upp/sapper/beacon, TRUE, TRUE)
	else if(spawning_mind)
		to_chat(mob, SPAN_ROLE_HEADER("You are a soldier of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(mob, /datum/equipment_preset/upp/soldier/beacon, TRUE, TRUE)

	print_backstory(mob)

	sleep(10)
	if(!spawning_mind)
		mob.free_for_ghosts()
	to_chat(mob, SPAN_BOLD("Objectives: [objectives]"))
