/* -- ACTIVATABLE ACTIONS -- */

/datum/action/human_action/activable/synth_bracer
	icon_file = 'icons/obj/items/synth/bracer.dmi'
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/charge_cost = 0
	var/handles_cooldown = FALSE
	var/handles_charge_cost = FALSE
	/// What cateogry of action it is. Can only have one active action from each type.
	var/category = SIMI_SECONDARY_ACTION
	var/human_adaptable = FALSE
	/// The tag to tell what ability is active.
	var/ability_tag = SIMI_ACTIVE_NONE

/datum/action/human_action/activable/synth_bracer/give_to(user)
	/// never add a check to see if the synth has gloves on, because they shouldn't have these abilities while not wearing gloves. it should runtime to let us know
	synth = user
	synth_bracer = synth.gloves
	if(!issynth(user) && !is_human_usable())
		synth = null
		synth_bracer = null
		return FALSE
	return ..()

/datum/action/human_action/activable/synth_bracer/remove_from(mob/living/carbon/human/H)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/activable/synth_bracer/Destroy()
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/activable/synth_bracer/action_activate()
	if(is_active())
		set_inactive(category)
		return
	..()

/datum/action/human_action/activable/synth_bracer/use_ability(mob/M)
	if(!can_use_action())
		return FALSE
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[synth_bracer.battery_charge_max]</b> you need [SPAN_RED(charge_cost)]."))
		return FALSE
	if(!handles_cooldown && cooldown)
		enter_cooldown()
	if(!handles_charge_cost && charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)
	return TRUE

/datum/action/human_action/activable/synth_bracer/can_use_action()
	if(is_active())
		set_inactive(category)
		return FALSE
	if(!issynth(owner) && !is_human_usable())
		to_chat(owner, SPAN_WARNING("You have no idea how to use this!"))
	if(owner.is_mob_incapacitated())
		to_chat(owner, SPAN_WARNING("You cannot use this action while incapacitated!"))
		return FALSE

	switch(category)
		if(SIMI_PRIMARY_ACTION)
			if(synth_bracer.active_ability != SIMI_ACTIVE_NONE)
				to_chat(owner, SPAN_WARNING("You cannot use this action while another primary ability is active."))
				return FALSE
		if(SIMI_SECONDARY_ACTION)
			if(synth_bracer.active_utility != SIMI_ACTIVE_NONE)
				to_chat(owner, SPAN_WARNING("You cannot use this action while another secondary ability is active."))
				return FALSE

	if(synth_bracer.battery_charge <= 0)
		to_chat(synth, SPAN_WARNING("You cannot do this without power!"))
		return FALSE
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[synth_bracer.battery_charge_max]</b> you need [SPAN_RED(charge_cost)]."))
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	return ..()

/datum/action/human_action/activable/synth_bracer/proc/is_human_usable()
	if(human_adaptable && synth_bracer.human_adapted)
		return TRUE
	return FALSE

/datum/action/human_action/activable/synth_bracer/proc/set_active(category = SIMI_SECONDARY_ACTION, set_ability = SIMI_ACTIVE_NONE)
	switch(category)
		if(SIMI_PRIMARY_ACTION)
			synth_bracer.active_ability = set_ability
		if(SIMI_SECONDARY_ACTION)
			synth_bracer.active_utility = set_ability
	if((synth_bracer.active_ability == SIMI_ACTIVE_NONE) && (synth_bracer.active_utility == SIMI_ACTIVE_NONE))
		synth_bracer.flags_item &= ~NODROP
	else
		synth_bracer.flags_item |= NODROP
	synth_bracer.update_icon(synth)

/datum/action/human_action/activable/synth_bracer/proc/set_inactive(category = SIMI_SECONDARY_ACTION)
	set_active(category, SIMI_ACTIVE_NONE)

/datum/action/human_action/activable/synth_bracer/proc/is_active()
	switch(category)
		if(SIMI_PRIMARY_ACTION)
			if(synth_bracer.active_ability == ability_tag)
				return TRUE
		if(SIMI_SECONDARY_ACTION)
			if(synth_bracer.active_utility == ability_tag)
				return TRUE
	return FALSE
/* -- ON-CLICK ACTIONS -- */

/datum/action/human_action/synth_bracer
	icon_file = 'icons/obj/items/synth/bracer.dmi'
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/ability_used_time = 0
	var/charge_cost = 0
	var/handles_cooldown = FALSE // whether the cooldown gets handled by the child, or should be done automatically here
	var/handles_charge_cost = FALSE
	/// What cateogry of action it is. Can only have one active action from each type.
	var/category = SIMI_SECONDARY_ACTION
	var/human_adaptable = FALSE
	/// The tag to tell what ability is active.
	var/ability_tag = SIMI_ACTIVE_NONE

/datum/action/human_action/synth_bracer/give_to(user)
	synth = user
	synth_bracer = synth.gloves
	if(!issynth(user) && !is_human_usable())
		synth = null
		synth_bracer = null
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/remove_from(user)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/synth_bracer/Destroy()
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/synth_bracer/proc/form_call()
	return

/datum/action/human_action/synth_bracer/action_cooldown_check()
	return ability_used_time <= world.time

/datum/action/human_action/synth_bracer/proc/enter_cooldown(amount = cooldown)
	ability_used_time = world.time + amount
	update_button_icon()
	addtimer(CALLBACK(src, PROC_REF(update_button_icon)), amount)

/datum/action/human_action/synth_bracer/update_button_icon()
	if(!button)
		return
	if(!action_cooldown_check())
		button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/synth_bracer/can_use_action()
	if(!issynth(owner) && !is_human_usable())
		to_chat(owner, SPAN_WARNING("You have no idea how to use this!"))
	if(owner.is_mob_incapacitated())
		to_chat(owner, SPAN_WARNING("You cannot use this action while incapacitated!"))
		return FALSE

	switch(category)
		if(SIMI_PRIMARY_ACTION)
			if(synth_bracer.active_ability != SIMI_ACTIVE_NONE)
				to_chat(owner, SPAN_WARNING("You cannot use this action while another primary ability is active."))
				return FALSE
		if(SIMI_SECONDARY_ACTION)
			if(synth_bracer.active_utility != SIMI_ACTIVE_NONE)
				to_chat(owner, SPAN_WARNING("You cannot use this action while another secondary ability is active."))
				return FALSE

	if(synth_bracer.battery_charge <= 0)
		to_chat(synth, SPAN_WARNING("You cannot do this without power!"))
		return FALSE
	if(synth_bracer.battery_charge < charge_cost)
		to_chat(synth, SPAN_WARNING("You don't have enough charge to to do this! Charge: <b>[synth_bracer.battery_charge]/[synth_bracer.battery_charge_max]</b> you need [SPAN_RED(charge_cost)]."))
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/action_activate()
	. = ..()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.gloves == synth_bracer)
		form_call(synth_bracer, human_owner)
	if(!handles_cooldown && cooldown)
		enter_cooldown()
	if(!handles_charge_cost && charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)

/datum/action/human_action/synth_bracer/proc/is_human_usable()
	if(human_adaptable && synth_bracer.human_adapted)
		return TRUE
	return FALSE

/datum/action/human_action/synth_bracer/proc/set_active(category = SIMI_SECONDARY_ACTION, set_ability = SIMI_ACTIVE_NONE)
	synth_bracer.set_active(category, set_ability)

/datum/action/human_action/synth_bracer/proc/set_inactive(category = SIMI_SECONDARY_ACTION)
	set_active(category, SIMI_ACTIVE_NONE)

/datum/action/human_action/synth_bracer/proc/is_active()
	switch(category)
		if(SIMI_PRIMARY_ACTION)
			if(synth_bracer.active_ability == ability_tag)
				return TRUE
		if(SIMI_SECONDARY_ACTION)
			if(synth_bracer.active_utility == ability_tag)
				return TRUE
	return FALSE
