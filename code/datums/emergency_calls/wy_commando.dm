
//Weyland-Yutani commandos. Friendly to USCM, hostile to xenos.
/datum/emergency_call/wy_commando
	name = "Weyland-Yutani Commando (Squad)"
	mob_max = 6
	probability = 5
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 1


/datum/emergency_call/wy_commando/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Nisshoku responding to your distress call. We are boarding. Any hostile actions will be met with lethal force."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME]'s Commanding Officer, and eliminate any hostile threats. Do not damage Wey-Yu property."


/datum/emergency_call/wy_commando/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando Squad Leader!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/leader/low_threat, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando Heavy Gunner!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/gunner/low_threat, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/standard/low_threat, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/wy_commando/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani has proven to be very profitable for you."))
	to_chat(M, SPAN_BOLD("While you are officially an employee, much of your work is off the books. You work as a skilled mercenary."))
	to_chat(M, SPAN_BOLD("You are well-informed of the xenomorph threat"))
	to_chat(M, SPAN_BOLD("You are part of  Weyland-Yutani Task Force Oberon that arrived in 2182 following the UA withdrawl of the Neroid Sector."))
	to_chat(M, SPAN_BOLD("Task-force Titan is stationed aboard the USCSS Nisshoku, a weaponized science Weyland-Yutani vessel that is stationed at the edge of the Neroid Sector. "))
	to_chat(M, SPAN_BOLD("Under the directive of Weyland-Yutani board member Johan Almric, you act as private security for Weyland-Yutani science teams."))
	to_chat(M, SPAN_BOLD("The USCSS Nisshoku contains a crew of roughly fifty commandos, and thirty scientists and support personnel."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))
	to_chat(M, SPAN_BOLD("Deny Weyland-Yutani's involvement and do not trust the UA/USCM forces."))

/datum/emergency_call/wy_commando/platoon
	name = "Weyland-Yutani Commando (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
	max_smartgunners = 4

/datum/emergency_call/wy_commando/deathsquad
	name = "Weyland-Yutani Commando (Squad) (!DEATHSQUAD!)"
	mob_max = 8
	probability = 0
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 2

/datum/emergency_call/wy_commando/deathsquad/New()
	..()
	objectives = "Eliminate everyone, then detonate the ship. Damage to Wey-Yu property is tolerable."

/datum/emergency_call/wy_commando/deathsquad/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando Squad Leader!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/leader, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando Heavy Gunner!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/gunner, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Commando!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/commando/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)
