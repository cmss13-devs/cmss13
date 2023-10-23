/datum/action/human_action/synth_bracer/protective_form
	name = "Protective Form"
	action_icon_state = "smartpack_protect"
	cooldown = 15 SECONDS
	charge_cost = SIMI_PROTECTIVE_COST

	handles_charge_cost = TRUE
	handles_cooldown = TRUE

/datum/action/human_action/synth_bracer/protective_form/action_activate()
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || synth_bracer.active_ability != SIMI_ACTIVE_NONE)
		return

	if(synth_bracer.battery_charge < SIMI_PROTECTIVE_COST)
		to_chat(user, SPAN_DANGER("There is a lack of charge for that action. Charge: [synth_bracer.battery_charge]/[SIMI_PROTECTIVE_COST]"))
		return

	synth_bracer.active_ability = SIMI_ABILITY_PROTECT
	synth_bracer.flags_item |= NODROP
	synth_bracer.flags_inventory |= CANTSTRIP
	LAZYSET(user.brute_mod_override, src, 0.2)
	LAZYSET(user.burn_mod_override, src, 0.2)
	synth_bracer.saved_melee_allowed = user.melee_allowed
	synth_bracer.saved_gun_allowed = user.allow_gun_usage
	synth_bracer.saved_throw_allowed = user.throw_allowed
	user.melee_allowed = FALSE
	user.allow_gun_usage = FALSE
	user.throw_allowed = FALSE
	to_chat(user, SPAN_DANGER("[name] beeps, \"You are now protected, but unable to attack.\""))
	synth_bracer.battery_charge -= SIMI_PROTECTIVE_COST
	playsound(synth_bracer.loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	to_chat(user, SPAN_INFO("The current charge reads [synth_bracer.battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	synth_bracer.update_icon(user)

	user.add_filter("synth_protective_form", priority = 1, params = list("type" = "outline", "color" = PROTECTIVE_FORM_COLOR, "size" = 1))

	addtimer(CALLBACK(src, PROC_REF(protective_form_cooldown), user), 120)

/datum/action/human_action/synth_bracer/protective_form/proc/protective_form_cooldown(mob/living/carbon/human/user)
	synth_bracer.active_ability = SIMI_ACTIVE_NONE
	synth_bracer.flags_item &= ~NODROP
	synth_bracer.flags_inventory &= ~CANTSTRIP
	user.melee_allowed = synth_bracer.saved_melee_allowed
	user.throw_allowed = synth_bracer.saved_throw_allowed
	user.allow_gun_usage = synth_bracer.saved_gun_allowed
	LAZYREMOVE(user.brute_mod_override, src)
	LAZYREMOVE(user.burn_mod_override, src)
	to_chat(user, SPAN_DANGER("[name] beeps, \"The protection wears off.\""))
	playsound(synth_bracer.loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	synth_bracer.update_icon(user)
	user.remove_filter("synth_protective_form")
