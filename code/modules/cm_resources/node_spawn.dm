//Helper landmarks for spawning

// This landmark is the "master" of all the other resource node spawns with the given node_group
// It's responsible for ACTIVATING them all and dividing the total amount of resources for the tag
/obj/effect/landmark/resource_node_activator
	name = "resource node activation trigger"
	icon_state = "landmark_node_trigger"
	// The trigger activates all resource nodes with the same tag as this
	var/node_group = "primary_resources"
	// The total amount of resources to divide among all resource nodes with the same node_group
	var/amount = 0

/obj/effect/landmark/resource_node_activator/proc/trigger()
	if(!node_group || !amount)
		CRASH("A resource node activator was triggered at ([x], [y], [z]) without a node group or resource amount!")

	//Find all resource nodes that should be activated by this trigger
	var/list/nodes_to_activate = list()
	for(var/obj/structure/resource_node/N in world)
		if(N.node_group == node_group)
			nodes_to_activate.Add(N)

	if(!nodes_to_activate.len)
		CRASH("A resource node activator was triggered at ([x], [y], [z]) without any nodes to spawn!")

	//Divide the resources equally among each node
	var/node_resources = round(amount / nodes_to_activate.len)
	var/max_variance = min(RESOURCE_MAX_VARIANCE, Floor(node_resources/2))

	var/list/resource_variances = get_random_zero_sum_variances(nodes_to_activate.len, max_variance)
	for(var/node_number in 1 to nodes_to_activate.len)
		var/obj/structure/resource_node/N = nodes_to_activate[node_number]
		// Activate the resource node
		N.activate(node_resources + resource_variances[node_number])

	qdel(src)

//Used for triggering Xenomorph hive starting nodes
//This trigger causes resources to be spawned when the first xenomorph hive core is built
/obj/effect/landmark/resource_node_activator/hive
	name = "xenomorph resource node trigger"
	icon_state = "landmark_node_trigger_xeno"
	node_group = "hive_core_built"

/obj/effect/landmark/resource_node_activator/hive/trigger(var/amount, var/hivenumber)
	var/area/A = get_area(loc)
	xeno_message(SPAN_XENOANNOUNCE("Resources have begun growing at \the [A]!"), 3, hivenumber)

	// Make sure we can't trigger the other xeno resource spots
	for(var/obj/effect/landmark/resource_node_activator/hive/H in world)
		if(H != src)
			qdel(H)

	..()

//Used for triggering Marine LZ starting nodes
//This trigger causes resources to be spawned when marines make first landfall
/obj/effect/landmark/resource_node_activator/landing
	name = "marine resource node trigger"
	icon_state = "landmark_node_trigger_landing"
	node_group = "marine_first_landfall"

/obj/effect/landmark/resource_node_activator/landing/trigger(var/amount)
	// Make sure we can't trigger the other LZ resource spots
	for(var/obj/effect/landmark/resource_node_activator/landing/H in world)
		if(H != src)
			qdel(H)

	..()

// LZ1 trigger
/obj/effect/landmark/resource_node_activator/landing/lz1
	name = "LZ1 resource node trigger"
	node_group = "marine_first_landfall_lz1"

// LZ2 trigger
/obj/effect/landmark/resource_node_activator/landing/lz2
	name = "LZ2 resource node trigger"
	node_group = "marine_first_landfall_lz2"

// Actual node spawn. Use these to place resource nodes
/obj/effect/landmark/resource_node
	name = "resource node spawner"
	icon_state = "landmark_node"
	// This resource node will be activated by the spawner with the same tag
	var/node_group
	var/node_type
	// Used to override the growth delay of the spawned crystal
	var/growth_override

/obj/effect/landmark/resource_node/proc/trigger(var/amount)
	if(node_type)
		var/obj/structure/resource_node/new_node = new node_type(loc)
		new_node.node_group = node_group

	qdel(src)

// Plasmagas node
/obj/effect/landmark/resource_node/plasma
	icon_state = "landmark_node"
	node_group = "primary_resources"
	node_type = /obj/structure/resource_node/plasma

/obj/effect/landmark/resource_node/plasma/trigger(var/amount)
	if(node_type)
		var/obj/structure/resource_node/plasma/new_node = new(loc)
		new_node.node_group = node_group
		if(growth_override)
			new_node.growth_delay = growth_override

	qdel(src)

// Grows rapidly when the xenos build their first hive core
/obj/effect/landmark/resource_node/plasma/hive
	name = "hive resource node spawner"
	icon_state = "landmark_node_xeno"
	node_group = "hive_core_built"
	growth_override = RESOURCE_GROWTH_RAPID

// Grows rapidly when the marines make first landfall
/obj/effect/landmark/resource_node/plasma/marine
	name = "marine landing resource node spawner"
	icon_state = "landmark_node_marine"
	node_group = "marine_first_landfall"
	growth_override = RESOURCE_GROWTH_RAPID

// LZ1 resource node
/obj/effect/landmark/resource_node/plasma/marine/lz1
	name = "LZ1 resource node spawner"
	node_group = "marine_first_landfall_lz1"

// LZ2 resource node
/obj/effect/landmark/resource_node/plasma/marine/lz2
	name = "LZ2 resource node spawner"
	node_group = "marine_first_landfall_lz2"

