
//A big-game hunter, willing to hunt anything that moves.
/datum/emergency_call/van_bandolier
	name = "Fun - Big Game Hunter (solo)"
	mob_max = 1
	mob_min = 1
	probability = 0
	objectives = "Get some good trophies. The more dangerous, the better!"
	hostility = TRUE

/datum/emergency_call/van_bandolier/New()
	. = ..()
	arrival_message = "Incoming Transmission: 'Heard your distress call, [MAIN_SHIP_NAME]. It had best be something which will look good on my wall, eh? Tally ho!'"

/datum/emergency_call/van_bandolier/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/fun/van_bandolier, FALSE, TRUE)

	to_chat(H, SPAN_ROLE_HEADER("You are a big game hunter!"))
	to_chat(H, SPAN_ROLE_BODY("You've taken a shot at every beast of the earth, every fowl of the air, and everything that creepeth upon the earth. Mundane beasts \
	now bore you (and there may be some minor poaching charges after the Misunderstanding) and so you have traveled to this backwater sector to hunt the most dangerous \
	game wherever you can find it. You've heard grisly tales of murderous xenomorphs, triggerhappy soldiers, and bloodthirsty alien hunters (who sound like they have \
	the right idea, not like those ghastly Arcturians at all!) but so far all you've potted has been penny-ante stuff. \n\n Whether you recruit the natives for \
	porters, beaters, and guides, or hunt them for sport, is entirely up to you. They'll point you at something excellent if they know what's good for them.\n\n "))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
