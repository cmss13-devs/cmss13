//this file left in for legacy support

/proc/carp_migration() // -- Darem
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		marine_announcement("Неизвестные формы жизни зафиксированы рядом с [station_name], пожалуйста, оставайтесь на связи.", "Уведомление о признаках жизни", 'sound/AI/commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		marine_announcement("В вашей зоне зафиксирован электрический шторм, пожалуйста, устраните потенциальные электронные перегрузки.", "Уведомление об Электрическом Шторме")

	if(lightsoutAmount)
		return

	else
		for(var/obj/structure/machinery/power/apc/apc in machines)
			apc.overload_lighting()

	return
