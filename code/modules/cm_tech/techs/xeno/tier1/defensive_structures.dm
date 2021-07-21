/datum/tech/xeno/structures
	name = "Defensive Structures"
	desc = "Unlock defensive structures to use to defend the hive with."

	flags = TREE_FLAG_XENO

	required_points = 15
	tier = /datum/tier/one
	var/list/constructions_to_add = list(
		/datum/resin_construction/resin_turf/wall/reflective,
		/datum/resin_construction/resin_obj/resin_spike,
		/datum/resin_construction/resin_obj/acid_pillar
	)

	var/list/hivelord_constructions
	var/list/drone_constructions

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
