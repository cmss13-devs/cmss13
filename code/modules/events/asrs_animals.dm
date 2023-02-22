/datum/round_event_control/asrs_animal
	name = "ASRS animal"
	typepath = /datum/round_event/asrs_animal
	weight = 7
	earliest_start = 10 MINUTES // don't want it happening roundstart
	min_players = 75 // Probably not good for deadpop rounds where there might not even be dedicated req staff
	max_occurrences = 2 // any more and it'd get tiresome
	alert_observers = TRUE
	gamemode_blacklist = list("Whiskey Outpost", "Hive Wars")

/datum/round_event/asrs_animal
	announce_when = 1
	startWhen = 10
	endWhen = 15

/datum/round_event/asrs_animal/setup()
	. = ..()
	var/msg = "An ASRS animal event has been triggered!"
	log_admin(msg)
	message_admins(msg)
	supply_controller.handle_animal_event = TRUE

/datum/round_event/asrs_animal/announce()
	ai_announcement("Unidentified lifesigns detected inside Automated Supply Retrieval System.")

