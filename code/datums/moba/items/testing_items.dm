/datum/moba_item/foo
	name = "Foo"
	icon_state = "blue"
	gold_cost = 200

	health = 500
	health_regen = 20
	speed = -0.4
	tier = 1

/datum/moba_item/bar
	name = "Bar"
	icon_state = "red"
	gold_cost = 50
	unique = TRUE

	plasma = 1000
	plasma_regen = 50
	armor = 20
	attack_speed = -6
	tier = 1

/datum/moba_item/baz
	name = "Baz"
	icon_state = "green"
	gold_cost = 250
	component_items = list(
		/datum/moba_item/bar,
	)

	plasma = 666
	tier = 2
