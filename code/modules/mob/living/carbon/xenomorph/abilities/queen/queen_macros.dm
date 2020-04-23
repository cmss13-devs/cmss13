
/datum/action/xeno_action/verb/verb_show_minimap()
	set category = "Alien"
	set name = "Show Minimap"
	set hidden = 1
	var/action_name = "Show Minimap"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_gut()
	set category = "Alien"
	set name = "Gut"
	set hidden = 1
	var/action_name = "Gut (200)"
	handle_xeno_macro(src, action_name) 