// Toggle Bumpattacks
/datum/action/xeno_action/bump_attack_toggle
	name = "Toggle Bump Attacks"
	icon_file = 'modular/bump_attacks/icons/general.dmi'
	action_type = XENO_ACTION_TOGGLE
	/// If we are toggled to attack whoever we bump onto, set by the bumping attack component when its toggled
	var/attacking = FALSE

/datum/action/xeno_action/bump_attack_toggle/update_button_icon()
	action_icon_state = attacking ? "bumpattack_off" : "bumpattack_on"
	button.overlays.Cut()
	button.overlays += image(icon_file, button, action_icon_state)
	return ..()
