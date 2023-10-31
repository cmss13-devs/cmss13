/datum/action/human_action/synth_bracer/anchor_form
	name = "Anchor Form"
	action_icon_state = "anchor"
	cooldown = 15 SECONDS
	charge_cost = SIMI_IMMOBILE_COST

	handles_charge_cost = TRUE
	handles_cooldown = TRUE
	category = SIMI_PRIMARY_ACTION


/datum/action/human_action/synth_bracer/anchor_form/can_use_action()
	if(!issynth(synth))
		to_chat(synth, SPAN_WARNING("You have no idea how to use this!"))
	if(synth.is_mob_incapacitated() || synth.dazed)
		to_chat(synth, SPAN_WARNING("You cannot use this action while incapacitated!"))
		return FALSE
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[charge_cost]</b>."))
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	if((synth_bracer.active_ability != SIMI_ABILITY_ANCHOR) && (synth_bracer.active_ability != SIMI_ACTIVE_NONE))
		to_chat(synth, SPAN_WARNING("You cannot use this action while another primary ability is active."))
		return FALSE
	return TRUE

/datum/action/human_action/synth_bracer/anchor_form/action_activate()
	..()

	if((synth_bracer.battery_charge < SIMI_IMMOBILE_COST) && (synth_bracer.active_ability != SIMI_ABILITY_ANCHOR))
		to_chat(synth, SPAN_DANGER("There is a lack of charge for that action. Charge: [synth_bracer.battery_charge]/[SIMI_IMMOBILE_COST]"))
		return FALSE

	switch(synth_bracer.active_ability)
		if(SIMI_ACTIVE_NONE)
			synth_bracer.active_ability = SIMI_ABILITY_ANCHOR
			synth_bracer.drain_charge(synth, charge_cost)
			synth.status_flags &= ~CANPUSH
			synth.anchored = TRUE
			synth.freeze()
			to_chat(synth, SPAN_DANGER("[name] beeps, \"You are anchored in place and cannot be moved.\""))
			synth.add_filter("synth_immobile_form", priority = 1, params = list("type" = "outline", "color" = IMMOBILE_FORM_COLOR, "size" = 1))
			playsound(synth_bracer, 'sound/mecha/mechmove04.ogg', 25, TRUE)
			synth_bracer.update_icon(synth)
			return TRUE
		if(SIMI_ABILITY_ANCHOR)
			synth.status_flags |= CANPUSH
			synth.anchored = FALSE
			synth.unfreeze()
			to_chat(synth, SPAN_DANGER("[name] beeps, \"You can now move again.\""))
			synth_bracer.active_ability = SIMI_ACTIVE_NONE
			synth.remove_filter("synth_immobile_form")
			playsound(synth_bracer, 'sound/mecha/mechmove04.ogg', 25, TRUE)
			synth_bracer.update_icon(synth)
			return TRUE
		else
			to_chat(synth, SPAN_WARNING("You cannot use this action while another primary ability is active."))
			return FALSE


