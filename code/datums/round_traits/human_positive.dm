/datum/round_trait/book_balancing
	name = "A.S.R.S. Book Balancing"
	trait_type = ROUND_TRAIT_POSITIVE
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "I'm not sure what happened."
	force = TRUE

/datum/round_trait/book_balancing/setup_report_messages()
	var/who = pick("Requistions Officer", "Commanding Officer", "Executive Officer", "Rifleman")
	var/what = pick("made a deal", "had a negotation", "made a trade", "had an exchange", "had an interesting conversation")
	var/where = pick("on a recent stop to a leisure planet", "on shore leave at a station", "on a back water colony")
	human_report_message = "The [who] [what] [where] and managed to secure some additional funding for the operation. Unfortunately, the upfront funding results in less resources available over time."

/datum/round_trait/book_balancing/on_round_start()
	supply_controller.points += 800
	supply_controller.points_per_process = 0.6



