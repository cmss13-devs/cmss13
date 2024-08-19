/datum/action/human_action/synth_bracer/repair_form
	name = "Repair Form"
	action_icon_state = "repair"
	cooldown = 15 SECONDS
	charge_cost = SIMI_REPAIR_COST

	handles_charge_cost = TRUE
	handles_cooldown = TRUE
	category = SIMI_PRIMARY_ACTION
	ability_tag = SIMI_ABILITY_REPAIR

/datum/action/human_action/synth_bracer/repair_form/form_call()
	if(synth.getBruteLoss() <= 0 && synth.getFireLoss() <= 0)
		to_chat(synth, SPAN_WARNING("[synth_bracer.name] beeps, \"No noticeable damage. Procedure cancelled.\""))
		return

	set_active(category, SIMI_ABILITY_REPAIR)
	synth.visible_message(SPAN_WARNING("[synth_bracer.name] beeps, \"Engaging the repairing process.\""), SPAN_WARNING("[synth_bracer.name] beeps, \"Beginning to carefully examine your sustained damage.\""))
	playsound(synth.loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	if(!do_after(synth, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(synth, SPAN_DANGER("[synth_bracer.name] beeps, \"Repair process was cancelled.\""))
		set_inactive(category)
		return

	enter_cooldown()
	synth_bracer.drain_charge(synth, charge_cost)

	playsound(synth.loc, 'sound/items/Welder2.ogg', 25, TRUE)
	synth.heal_overall_damage(25, 25, TRUE)
	synth.pain.recalculate_pain()
	synth.visible_message(SPAN_NOTICE("[synth_bracer.name] beeps, \"Completed the repairing process.\""))
	set_inactive(category)
