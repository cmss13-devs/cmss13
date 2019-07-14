//this file left in for legacy support

/proc/appendicitis()
	for(var/mob/living/carbon/human/H in living_mob_list)
		var/foundAlready = 0 // don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == 2 || foundAlready)
			continue

		var/datum/disease/D = new /datum/disease/appendicitis
		D.holder = H
		D.affected_mob = H
		H.viruses += D
		break

/proc/viral_outbreak(var/virus = null)
//	command_alert("Confirmed outbreak of level 7 viral biohazard aboard [station_name]. All personnel must contain the outbreak.", "Biohazard Alert")
//	world << sound('sound/AI/outbreak7.ogg')
	var/virus_type
	if(!virus)
		virus_type = pick(/datum/disease/advance/flu,/datum/disease/advance/cold,/datum/disease/brainrot,/datum/disease/magnitis,/datum/disease/pierrot_throat)
	else
		switch(virus)
			if("fake gbs")
				virus_type = /datum/disease/fake_gbs
			if("gbs")
				virus_type = /datum/disease/gbs
			if("magnitis")
				virus_type = /datum/disease/magnitis
			if("rhumba beat")
				virus_type = /datum/disease/rhumba_beat
			if("brain rot")
				virus_type = /datum/disease/brainrot
			if("cold")
				virus_type = /datum/disease/advance/cold
			if("flu")
				virus_type = /datum/disease/advance/flu
//			if("t-virus")
//				virus_type = /datum/disease/t_virus
			if("pierrot's throat")
				virus_type = /datum/disease/pierrot_throat
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))

		var/foundAlready = 0 // don't infect someone that already has the virus
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == 2 || foundAlready)
			continue

		var/datum/disease/D = new virus_type
		D.carrier = 1
		H.AddDisease(D)
		break
	spawn(rand(SECONDS_150, MINUTES_5)) //Delayed announcements to keep the crew on their toes.
		command_announcement.Announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/proc/high_radiation_event()

/* // Haha, this is way too laggy. I'll keep the prison break though.
	for(var/obj/machinery/light/L in machines)
		if(L.z != 1) continue
		L.flicker(50)

	sleep(100)
*/
	for(var/mob/living/carbon/human/H in living_mob_list)
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		if(istype(H,/mob/living/carbon/human))
			H.apply_effect((rand(15,75)),IRRADIATE,0)
			if (prob(5))
				H.apply_effect((rand(90,150)),IRRADIATE,0)
	sleep(100)
	command_announcement.Announce("High levels of radiation have been detected. Report to the Medical Bay if you begin to feel symptoms such as disorientation, nausea, or halucinations.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')


/proc/carp_migration() // -- Darem
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			new /mob/living/simple_animal/hostile/carp(C.loc)
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		command_announcement.Announce("Unknown biological entities have been detected near [station_name], please stand-by.", "Lifesign Alert", new_sound = 'sound/AI/commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		command_announcement.Announce("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert")

	if(lightsoutAmount)
		var/list/epicentreList = list()

		for(var/i=1,i<=lightsoutAmount,i++)
			var/list/possibleEpicentres = list()
			for(var/obj/effect/landmark/newEpicentre in landmarks_list)
				if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
					possibleEpicentres += newEpicentre
			if(possibleEpicentres.len)
				epicentreList += pick(possibleEpicentres)
			else
				break

		if(!epicentreList.len)
			return

		for(var/obj/effect/landmark/epicentre in epicentreList)
			for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
				apc.overload_lighting()

	else
		for(var/obj/machinery/power/apc/apc in machines)
			apc.overload_lighting()

	return
