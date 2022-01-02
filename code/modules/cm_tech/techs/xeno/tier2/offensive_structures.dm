/datum/tech/xeno/structures
	name = "Offensive Structures"
	desc = "Unlock offensive structures to use to attack people with."

	flags = TREE_FLAG_XENO

	required_points = 20
	tier = /datum/tier/two

	var/list/constructions_to_add = list(
		/datum/resin_construction/resin_obj/shield_dispenser,
		/datum/resin_construction/resin_obj/grenade
	)

	var/list/hivelord_constructions = list(
		/datum/resin_construction/resin_obj/movable/thick_membrane,
		/datum/resin_construction/resin_obj/movable/thick_wall,
	)

	var/list/drone_constructions = list(
		/datum/resin_construction/resin_obj/movable/wall,
		/datum/resin_construction/resin_obj/movable/membrane
	)

#define LIST_DATA(NAME) list(list(\
	"content" = "[NAME]: [initial(RC.name)]",\
	"color" = "green",\
	"tooltip" = initial(RC.desc),\
	"icon" = "plus"\
))

/datum/tech/xeno/structures/ui_static_data(mob/user)
	. = ..()
	var/list/structures = list()

	for(var/i in constructions_to_add)
		var/datum/resin_construction/RC = i
		structures += LIST_DATA("Construct")

	for(var/i in hivelord_constructions)
		var/datum/resin_construction/RC = i
		structures += LIST_DATA("Hivelord Construct")

	for(var/i in drone_constructions)
		var/datum/resin_construction/RC = i
		structures += LIST_DATA("Drone Construct")

	.["stats"] += structures

#undef LIST_DATA

/datum/tech/xeno/structures/on_unlock(datum/techtree/tree)
	. = ..()

	var/list/drone_abilities = drone_constructions + constructions_to_add
	for(var/i in drone_abilities)
		GLOB.resin_build_order_drone += i

	var/list/hivelord_abilities = hivelord_constructions + constructions_to_add
	for(var/i in hivelord_abilities)
		GLOB.resin_build_order_hivelord += i
