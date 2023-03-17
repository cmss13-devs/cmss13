/datum/emergency_call/goon
	name = "Weyland-Yutani Corporate Security (Squad)"
	mob_max = 6
	probability = 0
	shuttle_id = "Distress_PMC"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

/datum/emergency_call/goon/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is a Weyland-Yutani Corporate Security shuttle inbound to your distress beacon. We are coming to help."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME]'s Commanding Officer, and eliminate any hostile threats. Do not damage Wey-Yu property."

/datum/emergency_call/goon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their outposts and colonies."))
	to_chat(M, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/goon/platoon
	name = "Weyland-Yutani Corporate Security (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
