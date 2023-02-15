/datum/round_trait/book_balancing
	name = "A.S.R.S. Book Balancing"
	trait_type = ROUND_TRAIT_HUMAN_POSITIVE
	weight = 5
	show_in_human_report = TRUE
	human_report_message = "Someone got us more money upfront for less over time. Hope the operation doesn't drag on."
	force = TRUE

/datum/round_trait/book_balancing/New()
	. = ..()

	var/who = pick("The Requistions Officer", "The Commanding Officer", "The Executive Officer", "A Rifleman")
	var/what = pick("made a deal", "had a negotation", "made a trade", "had an exchange", "had an interesting conversation")
	var/where = pick("on a recent stop to a leisure planet", "on shore leave at a station", "on a back water colony")
	human_report_message = "[who] [what] [where] and managed to secure some additional funding for the operation. Unfortunately, the upfront funding results in less resources available over time."

/datum/round_trait/book_balancing/on_round_start()
	supply_controller.points += 800
	supply_controller.points_per_process = 0.6

/datum/round_trait/
