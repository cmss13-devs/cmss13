var/datum/subsystem/more_init/SSmore_init

/datum/subsystem/more_init
	name       = "More Init"
	init_order = SS_INIT_MORE_INIT
	flags      = SS_NO_FIRE

/datum/subsystem/more_init/New()
	NEW_SS_GLOBAL(SSmore_init)

/datum/subsystem/more_init/Initialize()
	initialize_marine_armor()
	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()
	if(!EvacuationAuthority)		EvacuationAuthority = new
	..()

