/datum/round_trait/galactic_grant
	name = "Galactic grant"
	trait_type = ROUND_TRAIT_POSITIVE
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "Your station has been selected for a special grant. Some extra funds has been made available to your cargo department."
	force = TRUE

/datum/round_trait/galactic_grant/on_round_start()
	supply_controller.points += 500
