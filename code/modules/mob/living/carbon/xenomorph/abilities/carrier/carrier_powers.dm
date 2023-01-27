/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.throw_hugger(A)
	..()

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.retrieve_egg(A)
	..()

/datum/action/xeno_action/onclick/set_hugger_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/carrier/carrier = owner

	carrier.huggers_reserved = tgui_input_number(usr, "How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?", "How many to reserve?", 0, carrier.huggers_max, carrier.huggers_reserved)

	to_chat(carrier, SPAN_XENONOTICE("You reserved [carrier.huggers_reserved] facehuggers for yourself."))
