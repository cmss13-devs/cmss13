/datum/action/surgery_toggle
	name = "Toggle Surgery Mode"
	action_icon_state = "surgery_toggle"
	var/original_help_safety

/datum/action/surgery_toggle/give_to(var/mob/living/L)
	..()
	update_surgery_skill()

/datum/action/surgery_toggle/remove_from(mob/living/carbon/human/H)
	..()
	owner.mob_flags &= ~SURGERY_MODE_ON
	if(owner.client && owner.client.prefs && owner.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY && !original_help_safety)
		owner.client.prefs.toggle_prefs &= ~TOGGLE_HELP_INTENT_SAFETY

/datum/action/surgery_toggle/proc/update_surgery_skill()
	if(skillcheck(owner, SKILL_SURGERY, SKILL_SURGERY_TRAINED) && !(owner.mob_flags & SURGERY_MODE_ON))
		button.icon_state = "template_on"
		owner.mob_flags |= SURGERY_MODE_ON
		if(owner.client && owner.client.prefs)
			if(owner.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY)
				original_help_safety = TRUE
			else
				owner.client.prefs.toggle_prefs |= TOGGLE_HELP_INTENT_SAFETY
				original_help_safety = FALSE

// Called when the action is clicked on.
/datum/action/surgery_toggle/action_activate()
	if(owner.mob_flags & SURGERY_MODE_ON)
		button.icon_state = "template"
		owner.mob_flags &= ~SURGERY_MODE_ON
		if(owner.client && owner.client.prefs && owner.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY && !original_help_safety)
			owner.client.prefs.toggle_prefs &= ~TOGGLE_HELP_INTENT_SAFETY
		original_help_safety = FALSE
	else
		button.icon_state = "template_on"
		owner.mob_flags |= SURGERY_MODE_ON
		to_chat(owner, "You prepare to perform surgery.")
		if(owner.client && owner.client.prefs && owner.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY)
			original_help_safety = TRUE
		else
			owner.client.prefs.toggle_prefs |= TOGGLE_HELP_INTENT_SAFETY
