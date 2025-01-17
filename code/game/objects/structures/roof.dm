/obj/structure/roof
	name = "roof"
	desc = null
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"
	density = FALSE
	layer = ABOVE_XENO_LAYER
	health = 6000
	var/image/under_image //immage that is used when there is mob on connected node, displayed only to mobs under it not others
	var/image/normal_image
	var/datum/roof_master_node/linked_master
	var/lazy_nodes = TRUE //if roof should create nodes that watch around it on spawn


/obj/structure/roof/Initialize()
	. = ..()
	under_image = image(icon, src, icon_state, layer = layer)
	under_image.alpha = 127

	normal_image = image(icon, src, icon_state, layer = layer)

	icon_state = null

	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(add_default_image))

	for(var/icon in GLOB.player_list)
		add_default_image(SSdcs, icon)
	if(lazy_nodes) //creates new node on each surounding tile if there is not one already
		var/obj/effect/roof_node/neighbor = locate() in loc
		if(!neighbor)
			neighbor = new(loc)
		for(var/direction in CARDINAL_ALL_DIRS)
			var/adjacent_loc = get_step(src, direction)
			neighbor = locate() in adjacent_loc
			if(!neighbor)
				neighbor = new(adjacent_loc)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/roof/LateInitialize() //we use late init to allow for lazy nodes to spawn first on mapload
	. = ..()
	if(linked_master)
		return
	for(var/direction in CARDINAL_ALL_DIRS) //this searches if there is lattice with master already, to work with runtime creation
		for(var/obj/structure/roof/roof in get_step(src,direction))
			if(roof.linked_master)
				roof.linked_master.connect(loc)
				return
	var/datum/roof_master_node/roof_master_node = new(loc) //no master and no lattice to connect to, create new master
	roof_master_node.connect(loc)

/obj/structure/roof/Destroy(force, ...)
	if(linked_master)
		linked_master.remove_roof(src)
	for(var/icon in GLOB.player_list)
		var/mob/mob = icon
		mob.client.images -= normal_image
	return ..()

/obj/structure/roof/proc/add_default_image(subsystem, mob/mob)
	SIGNAL_HANDLER
	mob.client.images += normal_image

/obj/structure/roof/proc/link_master(datum/roof_master_node/master) //performs bfs and connects to master
	if(linked_master != null)
		return
	master.connected_roof += src
	linked_master = master
	for(var/direction in CARDINAL_ALL_DIRS)
		for(var/obj/structure/roof/roof in get_step(src,direction))
			roof.link_master(master)


/obj/effect/roof_node //used for observing if mob is near the roof
	name = "roof_node"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE
	var/datum/roof_master_node/linked_master

/obj/effect/roof_node/Crossed(atom/movable/mover, target_dir)
	if(!linked_master)
		return
	if(isliving(mover))
		var/mob/living/mob = mover
		linked_master.add_under_roof(mob)

/obj/effect/roof_node/Destroy(force, ...)
	if(linked_master)
		if(linked_master.connected_nodes)
			linked_master.connected_nodes -= src
	return ..()

/obj/effect/roof_node/proc/link_master(datum/roof_master_node/master) //performs bfs and connects to master
	if(linked_master)
		return
	master.connected_nodes += src
	linked_master = master
	for(var/direction in CARDINAL_ALL_DIRS)
		for(var/obj/effect/roof_node/node in get_step(src,direction))
			node.link_master(master)


/datum/roof_master_node //maintains one block of roof
	var/list/connected_nodes = list()
	var/list/connected_roof = list()
	var/list/mobs_under = list()
	var/location

/datum/roof_master_node/Destroy(force, ...)
	if(connected_nodes)
		for(var/obj/effect/roof_node/roof_node in connected_nodes)
			qdel(roof_node)
	if(connected_nodes)
		for(var/obj/structure/roof/roof in connected_roof)
			qdel(roof)
	return ..()

/datum/roof_master_node/proc/add_under_roof(mob/living/living) //mob crossed connected node
	if(living in mobs_under)
		return
	mobs_under += living
	RegisterSignal(living, COMSIG_PARENT_QDELETING, PROC_REF(remove_under_roof))
	RegisterSignal(living, COMSIG_MOB_LOGGED_IN, PROC_REF(add_client))
	RegisterSignal(living, COMSIG_MOVABLE_MOVED, PROC_REF(check_under_roof))

	if(living.client)
		add_client(living)

/datum/roof_master_node/proc/add_client(mob/living/mob)
	SIGNAL_HANDLER
	for(var/obj/structure/roof/roof in connected_roof)
		mob.client.images -= roof.normal_image
		mob.client.images += roof.under_image

/datum/roof_master_node/proc/remove_under_roof(mob/living/living) //mob is no longer under roof
	SIGNAL_HANDLER
	if(living.client)
		for(var/obj/structure/roof/roof in connected_roof)
			living.client.images -= roof.under_image
			roof.add_default_image(SSdcs, living)
	mobs_under -= living
	UnregisterSignal(living, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOB_LOGGED_IN,
		COMSIG_MOVABLE_MOVED,
	))

/datum/roof_master_node/proc/check_under_roof(mob/living/living) //check if the mob is under connected roof
	SIGNAL_HANDLER
	for(var/obj/effect/roof_node/roof in connected_nodes)
		if(living.loc == roof.loc)
			return
	remove_under_roof(living)

/datum/roof_master_node/proc/connect(location)
	for(var/obj/effect/roof_node/node in location)
		node.link_master(src)
	for(var/obj/structure/roof/roof in location)
		roof.link_master(src)

/datum/roof_master_node/proc/remove_roof(obj/structure/roof/roof) //roof tile got removed
	connected_roof -= roof
	if(!length(connected_roof))
		qdel(src)
