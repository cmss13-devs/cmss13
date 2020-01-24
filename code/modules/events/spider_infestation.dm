/var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 400
	oneShot			= 1

	var/spawncount = 1


/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(8, 12)	//spiderlings only have a 50% chance to grow big and strong
	sent_spiders_to_station = 0

/datum/event/spider_infestation/announce()
	marine_announcement("Unidentified lifesigns detected.", "Lifesign Alert", 'sound/AI/aliens.ogg')


/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/structure/pipes/vents/pump/temp_vent in machines)
		if((temp_vent.loc.z == 3 || temp_vent.loc.z == 4)  && !temp_vent.welded)
			vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--
