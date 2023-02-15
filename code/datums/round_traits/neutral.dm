/datum/round_trait/black_market
	name = "Illicit Dealings"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "The software managing the A.S.R.S. has been playing up lately, with some unusual transmissions appearing on the terminals. Seems strange."
	force = TRUE

/datum/round_trait/black_market/on_round_start()
	supply_controller.black_market_enabled = TRUE

/datum/round_trait/bad_wakeup
	name = "Faulty Cryogenics"
	trait_type = ROUND_TRAIT_NEUTRAL
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "A.R.E.S. was flagging up some errors for a minor subsystem in the cryogenics pods. Should all be fine."
	trait_to_give = TRAIT_STATION_CRYOSLEEP_SICKNESS
	force = TRUE
