/datum/action/human_action/synth_bracer/anchor_form
	name = "Anchor Form"
	action_icon_state = "anchor"
	cooldown = 15 SECONDS
	charge_cost = SIMI_IMMOBILE_COST

	handles_charge_cost = TRUE
	handles_cooldown = TRUE
	category = SIMI_PRIMARY_ACTION
	ability_tag = SIMI_ABILITY_ANCHOR


/datum/action/human_action/synth_bracer/anchor_form/can_use_action()
	if(!issynth(synth))
		to_chat(synth, SPAN_WARNING("You have no idea how to use this!"))
	if(synth.is_mob_incapacitated() || synth.dazed)
		to_chat(synth, SPAN_WARNING("You cannot use this action while incapacitated!"))
		return FALSE
	if((synth_bracer.battery_charge < charge_cost) && (synth_bracer.active_ability != ability_tag))
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[synth_bracer.battery_charge_max]</b> you need [SPAN_RED(charge_cost)]."))
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	if((synth_bracer.active_ability != ability_tag) && (synth_bracer.active_ability != SIMI_ACTIVE_NONE))
		to_chat(synth, SPAN_WARNING("You cannot use this action while another primary ability is active."))
		return FALSE
	return TRUE

/datum/action/human_action/synth_bracer/anchor_form/form_call()
	switch(synth_bracer.active_ability)
		if(SIMI_ACTIVE_NONE)
			synth_bracer.enable_anchor(charge_cost)
		if(SIMI_ABILITY_ANCHOR)
			synth_bracer.disable_anchor()
		else
			to_chat(synth, SPAN_WARNING("You cannot use this action while another primary ability is active."))
			return FALSE

	if(COOLDOWN_FINISHED(synth_bracer, sound_cooldown))
		playsound(synth_bracer, 'sound/mecha/mechmove04.ogg', 25, TRUE)
		COOLDOWN_START(synth_bracer, sound_cooldown, 5 SECONDS)
	return TRUE

/obj/item/clothing/gloves/synth/proc/enable_anchor(charge_cost)
	set_active(SIMI_PRIMARY_ACTION, SIMI_ABILITY_ANCHOR)
	drain_charge(wearer, charge_cost)
	wearer.status_flags &= ~CANPUSH
	wearer.anchored = TRUE
	ADD_TRAIT(wearer, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
	to_chat(wearer, SPAN_DANGER("[name] beeps, \"You are anchored in place and cannot be moved.\""))
	wearer.add_filter("synth_immobile_form", priority = 1, params = list("type" = "outline", "color" = "#2B719E", "size" = 1))

/obj/item/clothing/gloves/synth/proc/disable_anchor()
	wearer.status_flags |= CANPUSH
	wearer.anchored = FALSE
	REMOVE_TRAIT(wearer, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
	to_chat(wearer, SPAN_DANGER("[name] beeps, \"You can now move again.\""))
	set_inactive(SIMI_PRIMARY_ACTION)
	wearer.remove_filter("synth_immobile_form")
