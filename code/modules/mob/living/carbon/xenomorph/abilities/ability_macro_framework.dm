// Backend stuff for macros
/proc/handle_xeno_macro(mob/living/carbon/Xenomorph/X, var/action_name)
	for(var/datum/action/xeno_action/A in X.actions)
		if(A.name == action_name)
			handle_xeno_macro_datum(X, A)

/proc/handle_xeno_macro_datum(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/A)
	if (!istype(A))
		return

	// "Old" behavior: select the action.
	switch(A.action_type)
		if (XENO_ACTION_CLICK) // This should be used for all actions that require an atom handed in by click() to function
			handle_xeno_macro_click(X, A)

		if (XENO_ACTION_ACTIVATE) // Actions that don't require a click() atom to work
			handle_xeno_macro_activate(X, A)

		if (XENO_ACTION_QUEUE)
			handle_xeno_macro_actionqueue(X, A)

		else
			log_debug("Xeno action [A.ability_name] is misconfigured. Code: XENO_ACTION_MACRO_1")
			log_admin("Xeno action [A.ability_name] is misconfigured. Tell the devs. Code: XENO_ACTION_MACRO_1")


/proc/handle_xeno_macro_click(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/A)
	A.button.clicked(X)
	return

/proc/handle_xeno_macro_activate(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/A)

	var/datum/action/xeno_action/activable/activableA = A

	if (!istype(A))
		return

	if (activableA.can_use_action() && activableA.action_cooldown_check())
		activableA.use_ability_wrapper()

// Queue an action for the next click. This will always work but should only be used for actions that actually NEED an atom to work
// Other ones should just use the activate proc
/proc/handle_xeno_macro_actionqueue(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/activable/A)
	if (!istype(A))
		return

	X.queued_action = A
	to_chat(X, SPAN_WARNING("Your next click will use [A.name]!"))

	if(X.client)
		X.client.mouse_pointer_icon = file("icons/mob/hud/mecha_mouse.dmi")


/mob/living/carbon/Xenomorph/verb/xeno_primary_action_one()
	set category = "Alien"
	set name = "Xeno Primary Action One"
	set hidden = 1
	var/mob/living/carbon/Xenomorph/X = src
	if (!istype(X))
		return
	for (var/datum/action/xeno_action/XA in X.actions)
		if (!istype(XA))
			continue
		if(XA.hidden)
			continue
		if (XA.ability_primacy == XENO_PRIMARY_ACTION_1)
			handle_xeno_macro_datum(src, XA)
			break

/mob/living/carbon/Xenomorph/verb/xeno_primary_action_two()
	set category = "Alien"
	set name = "Xeno Primary Action Two"
	set hidden = 1
	var/mob/living/carbon/Xenomorph/X = src
	if (!istype(X))
		return
	for (var/datum/action/xeno_action/XA in X.actions)
		if (!istype(XA))
			continue
		if(XA.hidden)
			continue
		if (XA.ability_primacy == XENO_PRIMARY_ACTION_2)
			handle_xeno_macro_datum(src, XA)
			break

/mob/living/carbon/Xenomorph/verb/xeno_primary_action_three()
	set category = "Alien"
	set name = "Xeno Primary Action Three"
	set hidden = 1
	var/mob/living/carbon/Xenomorph/X = src
	if (!istype(X))
		return
	for (var/datum/action/xeno_action/XA in X.actions)
		if (!istype(XA))
			continue
		if(XA.hidden)
			continue
		if (XA.ability_primacy == XENO_PRIMARY_ACTION_3)
			handle_xeno_macro_datum(src, XA)
			break

/mob/living/carbon/Xenomorph/verb/xeno_primary_action_four()
	set category = "Alien"
	set name = "Xeno Primary Action Four"
	set hidden = 1
	var/mob/living/carbon/Xenomorph/X = src
	if (!istype(X))
		return
	for (var/datum/action/xeno_action/XA in X.actions)
		if (!istype(XA))
			continue
		if(XA.hidden)
			continue
		if (XA.ability_primacy == XENO_PRIMARY_ACTION_4)
			handle_xeno_macro_datum(src, XA)
			break

/mob/living/carbon/Xenomorph/verb/m_corrosive_acid()
	set category = "Alien"
	set name = "Corrosive Acid"
	set hidden = TRUE
	var/mob/living/carbon/Xenomorph/X = src
	if(X.mob_size < MOB_SIZE_XENO_SMALL)
		return
	for(var/datum/action/xeno_action/XA in X.actions)
		if(!istype(XA))
			continue
		if(XA.hidden)
			continue
		if(XA.ability_primacy == XENO_CORROSIVE_ACID)
			handle_xeno_macro_datum(src, XA)
			break

/mob/living/carbon/Xenomorph/verb/tech_secrete_resin()
	set category = "Alien"
	set name = "Secrete Resin (Tech)"
	set hidden = TRUE
	var/mob/living/carbon/Xenomorph/X = src
	if (!istype(X))
		return
	for (var/datum/action/xeno_action/XA in X.actions)
		if (!istype(XA))
			continue
		if(XA.hidden)
			continue
		if (XA.ability_primacy == XENO_TECH_SECRETE_RESIN)
			handle_xeno_macro_datum(src, XA)
			break
