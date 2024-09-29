/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.throw_hugger(A)
	return ..()

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.retrieve_egg(A)
	return ..()

/datum/action/xeno_action/onclick/set_hugger_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/carrier/carrier = owner
	carrier.huggers_reserved = tgui_input_number(usr,
		"How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?",
		"How many to reserve?",
		carrier.huggers_reserved, carrier.huggers_max, 0
	)
	to_chat(carrier, SPAN_XENONOTICE("We reserve [carrier.huggers_reserved] facehuggers for ourself."))
	return ..()
