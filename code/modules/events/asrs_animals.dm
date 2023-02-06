/datum/round_event_control/asrs_spiders
	name = "ASRS animal"
	typepath = /datum/round_event/asrs_spiders
	weight = 10
	earliest_start = 10 MINUTES // don't want it happening roundstart
	min_players = 75 // Probably not good for deadpop rounds where there might not even be dedicated req staff
	max_occurrences = 3 // any more and it'd get tiresome
	alert_observers = TRUE
	gamemode_blacklist = list("Whiskey Outpost", "Hive Wars")

/datum/round_event/asrs_spiders
	announce_when = 1
	startWhen = 10
	endWhen = 15

/datum/round_event/asrs_spiders/setup()
	. = ..()
	var/msg
	msg = "An ASRS animal event has been triggered!"
	log_admin(msg)
	message_admins(msg)
	supply_controller.init_animal_event()
	to_chat(world,"ebent start")

/datum/round_event/asrs_spiders/announce()
	var/input
	input = "Unidentified lifesigns detected inside Automated Supply Retrieval System."
	ai_announcement(input)

