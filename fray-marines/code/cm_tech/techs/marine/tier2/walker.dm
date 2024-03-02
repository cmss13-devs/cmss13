/datum/tech/repeatable/walker_points
	name = "Walker Budget Increase"
	icon_state = "budget_ds"
	desc = "Distributes resources to the walker fabricator."

	announce_name = "ALMAYER SPECIAL ASSETS AUTHORIZED"
	announce_message = "Additional walker part fabricator points have been authorised for this operation."

	required_points = 10
	increase_per_purchase = 1

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/two/additional

	var/points_to_give = 5

/datum/tech/repeatable/walker_points/on_unlock()
	. = ..()
	GLOB.supply_controller.mech_points += points_to_give
