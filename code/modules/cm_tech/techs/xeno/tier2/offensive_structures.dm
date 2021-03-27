/datum/tech/xeno/structures/offensive
	name = "Offensive Structures"
	desc = "Unlock offensive structures to use to attack people with. Upgrades the acid pillar to a stronger variation."

	flags = TREE_FLAG_XENO

	required_points = 25
	tier = /datum/tier/two
	constructions_to_add = list(
		/datum/resin_construction/resin_obj/shield_dispenser,
		/datum/resin_construction/resin_obj/grenade
	)

	hivelord_constructions = list(
		/datum/resin_construction/resin_obj/movable/thick_membrane,
		/datum/resin_construction/resin_obj/movable/thick_wall,
	)

	drone_constructions = list(
		/datum/resin_construction/resin_obj/movable/wall,
		/datum/resin_construction/resin_obj/movable/membrane
	)

