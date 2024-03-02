/datum/tech/repeatable/tank_points
	name = "Tank Budget Increase"
	icon_state = "budget_ds"
	desc = "Distributes resources to the tank fabricator."

	announce_name = "ALMAYER SPECIAL ASSETS AUTHORIZED"
	announce_message = "Additional tank part fabricator points have been authorised for this operation."

	required_points = 15
	increase_per_purchase = 1

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/two/additional

	var/points_to_give = 1000

/datum/tech/repeatable/tank_points/on_unlock()
	. = ..()
	GLOB.supply_controller.tank_points += points_to_give
