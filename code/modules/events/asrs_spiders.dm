/datum/round_event_control/asrs_spiders
	name = "ASRS infestation"
	typepath = /datum/round_event/asrs_spiders
	weight = 7
	earliest_start = 10 MINUTES // don't want it happening roundstart
	min_players = 75 // Probably not good for deadpop rounds where there might not even be dedicated req staff
	max_occurrences = 2 // any more and it'd get tiresome
	alert_observers = TRUE
	gamemode_blacklist = list("Whiskey Outpost", "Hive Wars")

/datum/round_event/asrs_spiders
	announce_when = 1
	startWhen = 10
	endWhen = 15
	/// the base amount of points to be multiplied by the system
	var/base_points = 80
	var/spider_points //How many points does the event have to purchase spiders
	var/size_factor  // How big do we want this to be
	var/stealth_lvl

/datum/round_event/asrs_spiders/setup()
	. = ..()
	var/msg
	size_factor = rand(0,100)
	switch(size_factor)
		if(0 to 32)
			msg = "A stealth ASRS spider infestation has been triggered"
		if(33 to 66)
			msg = "A medium ASRS spider infestation has been triggered"
		if(67 to 100)
			msg = "A <b>MASSIVE</b> ASRS spider infestation has been triggered"
	for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
		to_chat(observer, SPAN_DEADSAY(msg + " at [size_factor]% threat!"))
	log_admin(msg + " at [size_factor]% threat!")
	message_admins(msg + " at [size_factor]% threat!")
	supply_controller.init_infestation(base_points,size_factor) // Calling the supply controller to handle this

/datum/round_event/asrs_spiders/announce()
	var/input
	if(size_factor > 66) // Specific announcement that there are indeed spiders in the ASRS as it's quite big.
		var/title = "Insectoid Infestation Detected"
		input = "Major insectoid infestation detected in the Automated Supply Retrieval System Elevator. Reccomendation: Terminate insectoid lifesigns with extreme force."
		shipwide_ai_announcement(input, title, 'sound/AI/unidentified_lifesigns.ogg')
	if(size_factor > 32) // Unspecific announcement that something is wrong
		input = "Unidentified lifesigns detected inside Automated Supply Retrieval System. Recommendation: lockdown of exterior access ports, including ducting and ventilation."
		ai_announcement(input)
	else // No announcement lul
		return
	set_security_level(SEC_LEVEL_RED)

