/datum/action/human_action/synth_bracer/protective_form
	name = "Protective Form"
	action_icon_state = "protect"
	cooldown = 15 SECONDS
	charge_cost = SIMI_PROTECTIVE_COST

	handles_charge_cost = TRUE
	handles_cooldown = TRUE
	category = SIMI_PRIMARY_ACTION
	ability_tag = SIMI_ABILITY_PROTECT

/datum/action/human_action/synth_bracer/protective_form/form_call()
	if((!issynth(synth) && !human_adaptable) || synth_bracer.active_ability != SIMI_ACTIVE_NONE)
		return

	if(synth_bracer.battery_charge < SIMI_PROTECTIVE_COST)
		to_chat(synth, SPAN_DANGER("There is a lack of charge for that action. Charge: [synth_bracer.battery_charge]/[SIMI_PROTECTIVE_COST]"))
		return
	synth_bracer.enable_shield(charge_cost)


/obj/item/clothing/gloves/synth/proc/enable_shield(charge_cost)
	flags_item |= NODROP
	flags_inventory |= CANTSTRIP
	LAZYSET(wearer.brute_mod_override, src, 0.2)
	LAZYSET(wearer.burn_mod_override, src, 0.2)
	saved_melee_allowed = wearer.melee_allowed
	saved_gun_allowed = wearer.allow_gun_usage
	saved_throw_allowed = wearer.throw_allowed
	wearer.melee_allowed = FALSE
	wearer.allow_gun_usage = FALSE
	wearer.throw_allowed = FALSE
	to_chat(wearer, SPAN_DANGER("[name] beeps, \"You are now protected, but unable to attack.\""))
	drain_charge(wearer, charge_cost)
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	to_chat(wearer, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	set_active(SIMI_PRIMARY_ACTION, SIMI_ABILITY_PROTECT)

	wearer.add_filter("synth_protective_form", priority = 1, params = list("type" = "outline", "color" = "#369E2B", "size" = 1))

	addtimer(CALLBACK(src, PROC_REF(disable_shield), wearer), 120)

/obj/item/clothing/gloves/synth/proc/disable_shield(charge_cost)
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	wearer.melee_allowed = saved_melee_allowed
	wearer.throw_allowed = saved_throw_allowed
	wearer.allow_gun_usage = saved_gun_allowed
	LAZYREMOVE(wearer.brute_mod_override, src)
	LAZYREMOVE(wearer.burn_mod_override, src)
	to_chat(wearer, SPAN_DANGER("[name] beeps, \"The protection wears off.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	set_inactive(SIMI_PRIMARY_ACTION)
	wearer.remove_filter("synth_protective_form")
