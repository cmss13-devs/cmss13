
//Terrified pizza delivery
/datum/emergency_call/pizza
	name = "Pizza Delivery"
	mob_max = 1
	mob_min = 1
	arrival_message = "Incoming Transmission: 'That'll be... sixteen orders of cheesy fries, eight large double topping pizzas, nine bottles of Four Loko... hello? Is anyone on this ship? Your pizzas are getting cold.'"
	objectives = "Make sure you get a tip!"
	shuttle_id = "Distress_Small"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pizza
	probability = 5

/datum/emergency_call/pizza/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/pizza, TRUE, TRUE)

	var/pizzatxt = pick("Discount Pizza","Pizza Kingdom","Papa Pizza", "Pizza Galaxy")
	to_chat(H, SPAN_ROLE_HEADER("You are a pizza deliverer! Your employer is the [pizzatxt] Corporation."))
	to_chat(H, SPAN_ROLE_BODY("Your job is to deliver your pizzas. You're PRETTY sure this is the right place..."))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/pizza/cryo
	name = "Pizza Delivery (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/obj/effect/landmark/ert_spawns/distress_pizza
	name = "Distress_Pizza"
