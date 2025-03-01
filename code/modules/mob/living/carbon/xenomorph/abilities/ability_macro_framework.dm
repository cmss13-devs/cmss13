// Backend stuff for macros
/proc/handle_xeno_macro(mob/living/carbon/xenomorph/xeno, action_name)
	for(var/datum/action/xeno_action/action in xeno.actions)
		if(action.name == action_name)
			handle_xeno_macro_datum(xeno, action)

/proc/handle_xeno_macro_datum(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/action)
	if (!istype(action))
		return

	// "Old" behavior: select the action.
	switch(action.action_type)
		if (XENO_ACTION_CLICK) // This should be used for all actions that require an atom handed in by click() to function
			handle_xeno_macro_click(xeno, action)

		if (XENO_ACTION_ACTIVATE) // Actions that don't require a click() atom to work
			handle_xeno_macro_activate(xeno, action)

		if (XENO_ACTION_QUEUE)
			handle_xeno_macro_actionqueue(xeno, action)

		else
			log_debug("Xeno action [action.name] is misconfigured. Code: XENO_ACTION_MACRO_1")
			log_admin("Xeno action [action.name] is misconfigured. Tell the devs. Code: XENO_ACTION_MACRO_1")


/proc/handle_xeno_macro_click(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/action)
	action.button.clicked(xeno)
	return

/proc/handle_xeno_macro_activate(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/action)

	var/datum/action/xeno_action/activable/activable_ability = action

	if (!istype(action))
		return

	if (activable_ability.can_use_action() && activable_ability.action_cooldown_check())
		activable_ability.use_ability_wrapper()

// Queue an action for the next click. This will always work but should only be used for actions that actually NEED an atom to work
// Other ones should just use the activate proc
/proc/handle_xeno_macro_actionqueue(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/activable/action)
	if (!istype(action))
		return

	xeno.queued_action = action
	to_chat(xeno, SPAN_WARNING("Your next click will use [action.name]!"))

	if(xeno.client?.prefs?.custom_cursors)
		xeno.client.mouse_pointer_icon = 'icons/mob/hud/mecha_mouse.dmi'


/mob/living/carbon/xenomorph/verb/xeno_primary_action_one()
	set category = "Alien"
	set name = "Xeno Primary Action One"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_PRIMARY_ACTION_1)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/xeno_primary_action_two()
	set category = "Alien"
	set name = "Xeno Primary Action Two"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_PRIMARY_ACTION_2)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/xeno_primary_action_three()
	set category = "Alien"
	set name = "Xeno Primary Action Three"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_PRIMARY_ACTION_3)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/xeno_primary_action_four()
	set category = "Alien"
	set name = "Xeno Primary Action Four"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_PRIMARY_ACTION_4)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/xeno_primary_action_five()
	set category = "Alien"
	set name = "Xeno Primary Action Five"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_PRIMARY_ACTION_5)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/m_corrosive_acid()
	set category = "Alien"
	set name = "Corrosive Acid"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if(xeno.mob_size < MOB_SIZE_XENO_SMALL)
		return
	for(var/datum/action/xeno_action/xeno_action in xeno.actions)
		if(!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if(xeno_action.ability_primacy == XENO_CORROSIVE_ACID)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/tech_secrete_resin()
	set category = "Alien"
	set name = "Secrete Resin (Tech)"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for (var/datum/action/xeno_action/xeno_action in xeno.actions)
		if (!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if (xeno_action.ability_primacy == XENO_TECH_SECRETE_RESIN)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/verb/xeno_screech_action()
	set category = "Alien"
	set name = "Screech"
	set hidden = TRUE
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for(var/datum/action/xeno_action/xeno_action in xeno.actions)
		if(!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if(xeno_action.ability_primacy == XENO_SCREECH)
			handle_xeno_macro_datum(src, xeno_action)
			break

/mob/living/carbon/xenomorph/proc/xeno_tail_stab_action()
	var/mob/living/carbon/xenomorph/xeno = src
	if (!istype(xeno))
		return
	for(var/datum/action/xeno_action/xeno_action in xeno.actions)
		if(!istype(xeno_action))
			continue
		if(xeno_action.hidden)
			continue
		if(xeno_action.ability_primacy == XENO_TAIL_STAB)
			handle_xeno_macro_datum(src, xeno_action)
			break
