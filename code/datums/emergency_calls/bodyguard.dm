/datum/emergency_call/wy_bodyguard
	name = "Weyland-Yutani Bodyguard (Executive Bodyguard Detail)"
	mob_max = 1
	mob_min = 1
	var/equipment_preset = /datum/equipment_preset/wy/security
	var/equipment_preset_leader = /datum/equipment_preset/wy/security
	var/spawn_header = "You are a Weyland-Yutani Security Guard!"
	var/spawn_header_leader = "You are a Weyland-Yutani Security Guard!"

/datum/emergency_call/wy_bodyguard/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], this is a Weyland-Yutani Corporate Security Protection Detail shuttle inbound to the Liaison's Beacon."
	objectives = "Protect the Corporate Liaison and follow his commands, unless it goes against Company policy. Do not damage Wey-Yu property."

/datum/emergency_call/wy_bodyguard/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER(spawn_header_leader))
		arm_equipment(mob, equipment_preset_leader, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER(spawn_header))
		arm_equipment(mob, equipment_preset, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/wy_bodyguard/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their Executives from all Divisions alike."))
	to_chat(M, SPAN_BOLD("You were sent to act as the Executives bodyguard on the [MAIN_SHIP_NAME], you have gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/wy_bodyguard/goon
	equipment_preset = /datum/equipment_preset/goon/standard/bodyguard
	equipment_preset_leader = /datum/equipment_preset/goon/lead/bodyguard
	spawn_header = "You are a Weyland-Yutani Corporate Security Officer!"
	spawn_header_leader = "You are a Weyland-Yutani Corporate Security Lead!"

/datum/emergency_call/wy_bodyguard/pmc
	equipment_preset = /datum/equipment_preset/pmc/pmc_standard
	equipment_preset_leader = /datum/equipment_preset/pmc/pmc_leader
	spawn_header = "You are a Weyland-Yutani PMC Operator!"
	spawn_header_leader = "You are a Weyland-Yutani PMC Leader!"

/datum/emergency_call/wy_bodyguard/pmc/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
		to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani has proven to be very profitable for you."))
		to_chat(M, SPAN_BOLD("While you are officially an employee, much of your work is off the books. You work as a skilled mercenary."))
		to_chat(M, SPAN_BOLD("You are [pick(50;"unaware of the xenomorph threat", 15;"acutely aware of the xenomorph threat", 10;"well-informed of the xenomorph threat")]"))

/datum/emergency_call/wy_bodyguard/pmc/sec/
	equipment_preset = /datum/equipment_preset/pmc/pmc_detainer
	equipment_preset_leader = /datum/equipment_preset/pmc/pmc_lead_investigator
	spawn_header = "You are a Weyland-Yutani PMC Detainer!"
	spawn_header_leader = "You are a Weyland-Yutani PMC Lead Investigator!"

/datum/emergency_call/wy_bodyguard/commando
	equipment_preset = /datum/equipment_preset/pmc/commando/standard
	equipment_preset_leader = /datum/equipment_preset/pmc/commando/leader
	spawn_header = "You are a Weyland-Yutani Commando!"
	spawn_header_leader = "You are a Weyland-Yutani Commando Leader!"

/datum/emergency_call/wy_bodyguard/commando/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani has proven to be very profitable for you."))
	to_chat(M, SPAN_BOLD("While you are officially an employee, much of your work is off the books. You work as a skilled mercenary."))
	to_chat(M, SPAN_BOLD("You are well-informed of the xenomorph threat"))
	to_chat(M, SPAN_BOLD("You are part of  Weyland-Yutani Task Force Oberon that arrived in 2182 following the UA withdrawl of the Neroid Sector."))
	to_chat(M, SPAN_BOLD("Task-force Titan is stationed aboard the USCSS Nisshoku, a weaponized science Weyland-Yutani vessel that is stationed at the edge of the Neroid Sector. "))
	to_chat(M, SPAN_BOLD("Under the directive of Weyland-Yutani board member Johan Almric, you act as private security for Weyland-Yutani Corporate Liaison."))
	to_chat(M, SPAN_BOLD("The USCSS Nisshoku contains a crew of roughly fifty commandos, and thirty scientists and support personnel."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))
	to_chat(M, SPAN_BOLD("Deny Weyland-Yutani's involvement and do not trust the UA/USCM forces."))

/datum/emergency_call/wy_bodyguard/android
	equipment_preset = /datum/equipment_preset/pmc/w_y_whiteout/low_threat
	equipment_preset = /datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader
	spawn_header = "You are a Weyland-Yutani Combat Android!"
	spawn_header_leader = "You are a Weyland-Yutani Combat Android Leading Unit!"

/datum/emergency_call/wy_bodyguard/android/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were brought online in a Weyland-Yutani secret combat synthetic production facility."))
	to_chat(M, SPAN_BOLD("You were programmed with a fully unlocked combat software."))
	to_chat(M, SPAN_BOLD("You were given all available information about the xenomorph threat including classified data reserved for special employees."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))
	to_chat(M, SPAN_BOLD("Deny Weyland-Yutani's involvement and do not trust the UA/USCM forces."))
