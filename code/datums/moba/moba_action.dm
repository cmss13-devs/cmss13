/datum/action/open_moba_scoreboard
	name = "Open Scoreboard"
	action_icon_state = "vote"
	var/map_id

/datum/action/open_moba_scoreboard/New(map_id)
	. = ..()
	src.map_id = map_id

/datum/action/open_moba_scoreboard/action_activate()
	. = ..()
	SSmoba.get_moba_controller(map_id).scoreboard.tgui_interact(owner)
