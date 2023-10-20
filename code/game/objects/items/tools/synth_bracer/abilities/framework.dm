/* -- ACTIVATABLE ACTIONS -- */

/datum/action/human_action/activable/synth_bracer
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/charge_cost = 0
	var/handles_cooldown = FALSE
	var/handles_charge_cost = FALSE

/datum/action/human_action/activable/synth_bracer/give_to(user)
	if(!isSynth(user))
		return FALSE
	synth = user
	synth_bracer = synth.gloves// never add a check to see if the synth has gloves on, because they shouldn't have these abilities while not wearing gloves. it should runtime to let us know
	return ..()

/datum/action/human_action/activable/synth_bracer/remove_from(mob/living/carbon/human/H)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/activable/synth_bracer/use_ability(var/mob/M)
	if(!can_use_action())
		return FALSE
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[charge_cost]</b>."))
		return FALSE
	if(!handles_cooldown && cooldown)
		enter_cooldown()
	if(!handles_charge_cost && charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)
	return TRUE

/* -- ON-CLICK ACTIONS -- */

/datum/action/human_action/synth_bracer
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/ability_used_time = 0
	var/charge_cost = 0
	var/handles_cooldown = FALSE // whether the cooldown gets handled by the child, or should be done automatically here
	var/handles_charge_cost = FALSE

/datum/action/human_action/synth_bracer/give_to(user)
	if(!isSynth(user))
		return FALSE
	synth = user
	synth_bracer = synth.gloves
	return ..()

/datum/action/human_action/synth_bracer/remove_from(mob/living/carbon/human/H)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/synth_bracer/action_cooldown_check()
	return ability_used_time <= world.time

/datum/action/human_action/synth_bracer/proc/enter_cooldown(var/amount = cooldown)
	ability_used_time = world.time + amount
	update_button_icon()
	addtimer(CALLBACK(src, .proc/update_button_icon), amount)

/datum/action/human_action/synth_bracer/update_button_icon()
	if(!button)
		return
	if(!action_cooldown_check())
		button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/synth_bracer/can_use_action()
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[charge_cost]</b>."))
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/action_activate()
	if(!handles_cooldown && cooldown)
		enter_cooldown()
	if(!handles_charge_cost && charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)
