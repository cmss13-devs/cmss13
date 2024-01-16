/datum/tier
	var/name = "Placeholder Name"
	var/tier = 0

	var/flags = NO_FLAGS

	var/disabled_color = COLOR_WHITE
	var/color = COLOR_WHITE
	var/max_techs = INFINITE_TECHS // Infinite

	var/list/turf/tier_turfs

	var/datum/techtree/holder

/datum/tier/New(datum/techtree/tree)
	. = ..()
	holder = tree

/datum/tier/free
	name = "Initial Tier"
	tier = 0
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY

/datum/tier/one
	name = "Tier 1"
	tier = 1
	color = COLOR_GREEN
	disabled_color = "#007d00"

/datum/tier/one_transition_two
	name = "Tier 1 to Tier 2 transition"
	tier = 1
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/two
	name = "Tier 2"
	tier = 2
	color = "#FFAA00"
	disabled_color = "#7d5300"


/datum/tier/two_transition_three
	name = "Tier 2 to Tier 3 transition"
	tier = 2
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/three
	name = "Tier 3"
	tier = 3
	color = COLOR_RED
	disabled_color = "#7d0000"

/datum/tier/three_transition_four
	name = "Tier 3 to Tier 4 transition"
	tier = 3
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/four
	name = "Tier 4"
	tier = 4
	color = COLOR_MAGENTA
	disabled_color = "#7d007d"

	max_techs = 1
