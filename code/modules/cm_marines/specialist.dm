/datum/action/item_action/specialist
    var/ability_primacy = SPEC_NOT_PRIMARY_ACTION

/datum/action/item_action/specialist/proc/action_cooldown_check()
	return FALSE

/datum/action/item_action/specialist/proc/handle_spec_macro()
    if (can_use_action())
        action_activate()

/datum/action/item_action/specialist/update_button_icon()
	if(action_cooldown_check())
		button.color = rgb(120,120,120,200)
	else
		button.color = rgb(255,255,255,255)

// Spec verb macros
/mob/living/carbon/human/verb/spec_activation_one()
	set category = "Specialist"
	set name = "Specialist Activation One"
	set hidden = TRUE

	var/mob/living/carbon/human/H = src
	if (!istype(H))
		return
	for (var/datum/action/item_action/specialist/SA in H.actions)
		if (SA.ability_primacy == SPEC_PRIMARY_ACTION_1)
			SA.handle_spec_macro()

/mob/living/carbon/human/verb/spec_activation_two()
	set category = "Specialist"
	set name = "Specialist Activation Two"
	set hidden = TRUE

	var/mob/living/carbon/human/H = src
	if (!istype(H))
		return
	for (var/datum/action/item_action/specialist/SA in H.actions)
		if (SA.ability_primacy == SPEC_PRIMARY_ACTION_2)
			SA.handle_spec_macro()