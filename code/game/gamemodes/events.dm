//this file left in for legacy support

/proc/carp_migration() // -- Darem
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		marine_announcement("Unknown biological entities have been detected near [MAIN_SHIP_NAME], please stand-by.", "Lifesign Alert", 'sound/AI/commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		marine_announcement("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

	if(lightsoutAmount)
		return

	else
		for(var/obj/structure/machinery/power/apc/apc in GLOB.machines)
			apc.overload_lighting()

	return
