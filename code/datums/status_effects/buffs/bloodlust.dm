/datum/status_effect/stacking/bloodlust
	id = "bloodlust"
	stack_decay = 0
	consumed_on_threshold = FALSE
	tick_interval = -1
	alert_type = null
	should_delete_at_no_stacks = FALSE
	max_stacks = INFINITY // (:
	var/given_player_lifesteal = 0

/datum/status_effect/stacking/bloodlust/add_stacks(stacks_added)
	. = ..()
	if(!owner)
		return

	var/list/lifesteal_holder = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_LIFESTEAL, lifesteal_holder)
	if(!length(lifesteal_holder))
		return
	var/lifesteal_value = lifesteal_holder[1]
	lifesteal_value -= given_player_lifesteal
	given_player_lifesteal = floor(stacks * 0.002 * 100) * 0.01 // 1 stack = .2% lifesteal, floored
	SEND_SIGNAL(owner, COMSIG_MOBA_SET_LIFESTEAL, (lifesteal_value + given_player_lifesteal))
	if(owner.hud_used?.locate_leader)
		owner.hud_used.locate_leader.maptext = "<span class='maptext' style='color: red'>Bloodlust: <b>[stacks]</b></span>"
		owner.hud_used.locate_leader.maptext_width = 128
		owner.hud_used.locate_leader.maptext_x = -48
		owner.hud_used.locate_leader.maptext_y = 192

/datum/status_effect/stacking/bloodlust/on_remove()
	. = ..()
	var/list/lifesteal_holder = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_LIFESTEAL, lifesteal_holder)
	if(!length(lifesteal_holder))
		return
	var/lifesteal_value = lifesteal_holder[1]
	lifesteal_value -= given_player_lifesteal
	SEND_SIGNAL(owner, COMSIG_MOBA_SET_LIFESTEAL, lifesteal_value)
