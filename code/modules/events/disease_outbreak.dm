/datum/event/disease_outbreak
	announceWhen	= 15
	oneShot			= 1

/datum/event/disease_outbreak/setup()
	announceWhen = rand(15, 30)

/datum/event/disease_outbreak/start()
	var/virus_type = pick(/datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/brainrot, /datum/disease/magnitis)

	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/foundAlready = 0	// don't infect someone that already has the virus
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 3 || T.z != 4)
			continue
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == 2 || foundAlready)
			continue

		var/datum/disease/D = new virus_type
		D.carrier = 1
		H.AddDisease(D)
		break