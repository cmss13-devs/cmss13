
//Terrified pizza delivery
/datum/emergency_call/pizza
	name = "Pizza Delivery"
	mob_max = 1
	mob_min = 1
	arrival_message = "Incoming Transmission: 'That'll be.. sixteen orders of cheesy fries, eight large double topping pizzas, nine bottles of Four Loko.. hello? Is anyone on this ship? Your pizzas are getting cold.'"
	objectives = "Make sure you get a tip!"
	probability = 5

/datum/emergency_call/pizza/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	mob.dna.ready_dna(mob)
	mob.key = M.key
	if(mob.client) mob.client.change_view(world.view)
	ticker.mode.traitors += mob.mind

	arm_equipment(mob, "Pizza", TRUE)

	var/pizzatxt = pick("Discount Pizza","Pizza Kingdom","Papa Pizza")
	mob << "<font size='3'>\red You are a pizza deliverer! Your employer is the [pizzatxt] Corporation.</font>"
	mob << "Your job is to deliver your pizzas. You're PRETTY sure this is the right place.."

	sleep(10)
	M << "<B>Objectives:</b> [objectives]"


/datum/emergency_call/pizza/cryo
	name = "Pizza Delivery (Cryo)"
	probability = 0
	name_of_spawn = "Distress_Cryo"
	shuttle_id = ""