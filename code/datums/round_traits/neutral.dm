/datum/round_trait/black_market
	name = "Illicit Dealings"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "The software managing the A.S.R.S. has been playing up lately, with some unusual transmissions appearing on the terminals. Seems strange."

/datum/round_trait/black_market/on_round_start()
	supply_controller.black_market_enabled = TRUE

/datum/round_trait/bad_wakeup
	name = "Faulty Cryogenics"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "ARES was flagging up some errors for a minor subsystem in the cryogenics pods. Should all be fine."
	trait_to_give = TRAIT_ROUND_CRYOSLEEP_SICKNESS

/datum/round_trait/economic_boom
	name = "Economic Boom"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "A small bonus has been deposited in the accounts of our personnel by The Company. Seemingly, they want everyone to co-operate with them on this operation."
	trait_to_give = TRAIT_ROUND_ECONOMIC_BOOM
	blacklist = list(/datum/round_trait/economic_boom)

/datum/round_trait/economic_boom/on_round_start()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(marine_announcement), "As an act of generosity from Weyland-Yutani, we have deposited a bonus in each and every account located on the [MAIN_SHIP_NAME]. We hope it is spent effectively, and we hope to see increased co-operation in the future.", "Weyland-Yutani Account Manager"), 2 MINUTES)

/datum/round_trait/economic_slump
	name = "Economic Slump"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "Command's been cutting costs again. While we were in hypersleep, we were fired and rehired on worse contracts, with much worse pay agreements."
	trait_to_give = TRAIT_ROUND_ECONOMIC_SLUMP
	blacklist = list(/datum/round_trait/economic_boom)

/datum/round_trait/economic_slump/on_round_start()
	marine_announcement("Due to budgetary constraints, we have been forced to alter the contracts of USCM employees on board the [MAIN_SHIP_NAME]. This is non-negotiable.", "USCM Office of Fiscal Affairs")

/datum/round_trait/temperature_change
	name = "Temperature Change"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "Location we're orbiting seems to have different conditions than we were anticipating. Very unusual."
	show_in_xeno_report = TRUE
	xeno_report_message = "The feel of this world has changed since we emerged. The metal contraptions of the tall's are no longer rattling."

/datum/round_trait/temperature_change/New()
	. = ..()

	GLOB.temperature_change = rand(-10, 10)

/datum/round_trait/wrong_tubes
	name = "Mismatched Squads"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 1
	show_in_human_report = TRUE
	human_report_message = "Cryogenics system's woken everyone up in the wrong pods for their squad. No biggie, looks like they've been given the right access."
	trait_to_give = TRAIT_ROUND_WRONG_TUBES
	force = TRUE

/datum/round_trait/wrong_tubes/New()
	. = ..()

	var/list/squads = list()

	for(var/obj/effect/landmark/late_join/landmark as anything in subtypesof(/obj/effect/landmark/late_join))
		var/squad_to_add = initial(landmark.squad)
		squads |= squad_to_add

	var/list/shuffled_squads = shuffle(squads.Copy())

	var/list/squad_mappings = list()

	for(var/i = 1 to length(squads))
		squad_mappings[squads[i]] = shuffled_squads[i]

	GLOB.squad_mappings = squad_mappings
