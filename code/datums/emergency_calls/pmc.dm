
//Weston-Yamada commandos. Friendly to USCM, hostile to xenos.
/datum/emergency_call/pmc
	name = "Weston-Yamada PMC (Squad)"
	mob_max = 6
	probability = 25
	shuttle_id = "Distress_PMC"
	name_of_spawn = "Distress_PMC"
	max_medics = 1
	max_heavies = 2


/datum/emergency_call/pmc/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Royce responding to your distress call. We are boarding. Any hostile actions will be met with lethal force."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME] Captain, and eliminate any hostile threats. Do not damage W-Y property."


/datum/emergency_call/pmc/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	mob.key = M.key
	if(mob.client) mob.client.change_view(world.view)

	ticker.mode.traitors += mob.mind

	if(!leader)       //First one spawned is always the leader.
		leader = mob
		to_chat(mob, SPAN_WARNING(FONT_SIZE_BIG("You are a Weston-Yamada squad leader!")))
		arm_equipment(mob, "Weston-Yamada PMC (Leader)", TRUE, TRUE)
	else if(medics < max_medics)
		to_chat(mob, SPAN_WARNING(FONT_SIZE_BIG("You are a Weston-Yamada medic!")))
		arm_equipment(mob, "Weston-Yamada PMC (Medic)", TRUE, TRUE)
		medics++
	else if(heavies < max_heavies*ERT_PMC_GUNNER_FRACTION)
		to_chat(mob, SPAN_WARNING(FONT_SIZE_BIG("You are a Weston-Yamada heavy gunner!")))
		arm_equipment(mob, "Weston-Yamada PMC (Gunner)", TRUE, TRUE)
		heavies++
	else if(heavies < max_heavies)
		to_chat(mob, SPAN_WARNING(FONT_SIZE_BIG("You are a Weston-Yamada sniper!")))
		arm_equipment(mob, "Weston-Yamada PMC (Sniper)", TRUE, TRUE)
		heavies++
	else
		to_chat(mob, SPAN_WARNING(FONT_SIZE_BIG("You are a Weston-Yamada mercenary!")))
		arm_equipment(mob, "Weston-Yamada PMC (Standard)", TRUE, TRUE)

	print_backstory(mob)

	sleep(10)
	to_chat(M, "<B>Objectives:</b> [objectives]")


/datum/emergency_call/pmc/print_backstory(mob/living/carbon/human/M)
	to_chat(M, "<B>You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family.</b>")
	to_chat(M, "<B>Joining the ranks of Weston-Yamada has proven to be very profitable for you.</b>")
	to_chat(M, "<B>While you are officially an employee, much of your work is off the books. You work as a skilled mercenary.</b>")
	to_chat(M, "<B>You are [pick(50;"unaware of the xenomorph threat", 15;"acutely aware of the xenomorph threat", 10;"well-informed of the xenomorph threat")]</b>")
	to_chat(M, "")
	to_chat(M, "")
	to_chat(M, "<B>You are part of  Weston-Yamada Task Force Oberon that arrived in 2182 following the UA withdrawl of the Tychon's Rift sector.</b>")
	to_chat(M, "<B>Task-force Oberon is stationed aboard the USCSS Royce, a powerful Weston-Yamada cruiser that patrols the outer edges of Tychon's Rift. </b>")
	to_chat(M, "<B>Under the directive of Weston-Yamada board member Johan Almric, you act as private security for Weston-Yamada science teams.</b>")
	to_chat(M, "<B>The USCSS Royce contains a crew of roughly two hundred PMCs, and one hundred scientists and support personnel.</b>")
	to_chat(M, "")
	to_chat(M, "")
	to_chat(M, "<B>Ensure no damage is incurred against Weston-Yamada. Make sure the CL is safe.</b>")
	to_chat(M, "<B>Deny Weston-Yamada's involvement and do not trust the UA/USCM forces.</b>")


/datum/emergency_call/pmc/platoon
	name = "Weston-Yamada PMC (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 4
