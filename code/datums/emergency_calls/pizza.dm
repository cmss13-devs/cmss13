
//Terrified pizza delivery
/datum/emergency_call/pizza
	name = "Pizza Delivery"
	mob_max = 1
	mob_min = 1
	arrival_message = "'That'll be... sixteen orders of cheesy fries, eight large double topping pizzas, nine bottles of Four Loko... hello? Is anyone on this ship? Your pizzas are getting cold.'"
	objectives = "Make sure you get a tip!"
	shuttle_id = "Distress_Small"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pizza
	probability = 0

/datum/emergency_call/pizza/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/pizza, TRUE, TRUE)

	var/pizzatxt = pick("Discount Pizza","Pizza Kingdom","Papa Pizza", "Pizza Galaxy")
	to_chat(H, role_header("You are a pizza deliverer! Your employer is the [pizzatxt] Corporation."))
	to_chat(H, role_body("Your job is to deliver your pizzas. You're PRETTY sure this is the right place..."))

	sleep(1 SECONDS)
	to_chat(H, role_header("Your objectives are:"))
	to_chat(H, role_body("[objectives]"))

/datum/emergency_call/pizza/cryo
	name = "Pizza Delivery (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/obj/effect/landmark/ert_spawns/distress_pizza
	name = "Distress_Pizza"
