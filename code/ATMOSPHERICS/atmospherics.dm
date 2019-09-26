/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/structure/machinery/atmospherics
	anchored = 1
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	var/nodealert = 0

	layer = ATMOS_DEVICE_LAYER

	var/connect_types[] = list(1) //1=regular, 2=supply, 3=scrubber
	var/connected_to = 1 //same as above, currently not used for anything
	var/icon_connect_type = "" //"-supply" or "-scrubbers"

	var/initialize_directions = 0
	var/pipe_color

	var/image/pipe_vision_img = null

	var/global/datum/pipe_icon_manager/icon_manager

	var/ventcrawl_message_busy = 0 //Prevent spamming

	var/last_flow_rate = 0
	var/debug = 0
	use_power = 0
	processable = 0

/obj/structure/machinery/atmospherics/New()
	if(!icon_manager)
		icon_manager = new()

	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	if(pipe_vision_img)
		qdel(pipe_vision_img)
		pipe_vision_img = null

	start_processing()
	..()

/obj/structure/machinery/atmospherics/Dispose()
	for(var/mob/living/M in src) //ventcrawling is serious business
		M.remove_ventcrawl()
		M.forceMove(loc)
	stop_processing()
	. = ..()

/obj/structure/machinery/atmospherics/power_change()
	return // overriding this for pipes etc, powered stuff overrides this.

/obj/structure/machinery/atmospherics/attackby(atom/A, mob/user as mob)
	if(istype(A, /obj/item/device/pipe_painter))
		return
	..()

/obj/structure/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/structure/machinery/atmospherics/node, var/direction, var/icon_connect_type)
	if(node)
		if(T && T.intact_tile && node.level == 1 && istype(node, /obj/structure/machinery/atmospherics/pipe))
			//underlays += icon_manager.get_atmos_icon("underlay_down", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			//underlays += icon_manager.get_atmos_icon("underlay_intact", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		//underlays += icon_manager.get_atmos_icon("underlay_exposed", direction, pipe_color)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "exposed" + icon_connect_type)

/obj/structure/machinery/atmospherics/proc/update_underlays()
	if(check_icon_cache())
		return 1
	else
		return 0

obj/structure/machinery/atmospherics/proc/check_connect_types(obj/structure/machinery/atmospherics/atmos1, obj/structure/machinery/atmospherics/atmos2)
	var/i
	var/list1[] = atmos1.connect_types
	var/list2[] = atmos2.connect_types
	for(i=1,i<=list1.len,i++)
		var/j
		for(j=1,j<=list2.len,j++)
			if(list1[i] == list2[j])
				var/n = list1[i]
				return n
	return 0

obj/structure/machinery/atmospherics/proc/check_connect_types_construction(obj/structure/machinery/atmospherics/atmos1, obj/item/pipe/pipe2)
	var/i
	var/list1[] = atmos1.connect_types
	var/list2[] = pipe2.connect_types
	for(i=1,i<=list1.len,i++)
		var/j
		for(j=1,j<=list2.len,j++)
			if(list1[i] == list2[j])
				var/n = list1[i]
				return n
	return 0


/obj/structure/machinery/atmospherics/proc/check_icon_cache(var/safety = 0)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(1)
		return 0

	return 1

/obj/structure/machinery/atmospherics/proc/color_cache_name(var/obj/structure/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/structure/machinery/atmospherics/process()
	build_network()
	stop_processing()

/obj/structure/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/structure/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	return null

/obj/structure/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node

	return null

/obj/structure/machinery/atmospherics/proc/return_network(obj/structure/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null

	return null

/obj/structure/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

/obj/structure/machinery/atmospherics/proc/return_network_air(datum/network/reference)
	return

/obj/structure/machinery/atmospherics/proc/disconnect(obj/structure/machinery/atmospherics/reference)

/obj/structure/machinery/atmospherics/update_icon()
	return null

#define VENT_SOUND_DELAY 20

/obj/structure/machinery/atmospherics/relaymove(mob/living/user, direction)
	if(!(direction & initialize_directions)) //can't go in a way we aren't connecting to
		return

	var/obj/structure/machinery/atmospherics/target_move = findConnecting(direction)
	if(target_move)
		if(is_type_in_list(target_move, ventcrawl_machinery) && target_move.can_crawl_through())
			if(ventcrawl_message_busy > world.time)
				return
			ventcrawl_message_busy = world.time + 20
			target_move.visible_message(SPAN_WARNING("You hear something squeezing through the ducts."))
			to_chat(user, SPAN_NOTICE("You begin to climb out of [target_move]"))
			if(do_after(user, 20, INTERRUPT_NO_NEEDHAND))
				user.remove_ventcrawl()
				user.forceMove(target_move.loc) //handles entering and so on
				user.visible_message(SPAN_WARNING("[user] climbs out of [target_move]."), \
				SPAN_NOTICE("You climb out of [target_move]."))
				pick(playsound(user, 'sound/effects/alien_ventpass1.ogg', 35, 1), playsound(user, 'sound/effects/alien_ventpass2.ogg', 35, 1))
		else if(target_move.can_crawl_through())
			user.loc = target_move
			user.client.eye = target_move //if we don't do this, Byond only updates the eye every tick - required for smooth movement
			if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
				user.last_played_vent = world.time
				pick(playsound(src, 'sound/effects/alien_ventcrawl1.ogg', 25, 1), playsound(src, 'sound/effects/alien_ventcrawl2.ogg', 25, 1))
	else
		if((direction & initialize_directions) || is_type_in_list(src, ventcrawl_machinery) && can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
			if(ventcrawl_message_busy > world.time)
				return
			ventcrawl_message_busy = world.time + 20
			visible_message(SPAN_WARNING("You hear something squeezing through the ducts."))
			to_chat(user, SPAN_NOTICE("You begin to climb out of [src]"))
			if(do_after(user, 20, INTERRUPT_NO_NEEDHAND))
				user.remove_ventcrawl()
				user.forceMove(src.loc)
				user.visible_message(SPAN_WARNING("[user] climbs out of [src]."), \
				SPAN_NOTICE("You climb out of [src]."))
				pick(playsound(user, 'sound/effects/alien_ventpass1.ogg', 35, 1), playsound(user, 'sound/effects/alien_ventpass2.ogg', 35, 1))
	user.canmove = 0
	spawn(1)
		user.canmove = 1

/obj/structure/machinery/atmospherics/proc/can_crawl_through()
	return 1

//Find a connecting /obj/structure/machinery/atmospherics in specified direction.
/obj/structure/machinery/atmospherics/proc/findConnecting(var/direction)
	for(var/obj/structure/machinery/atmospherics/target in get_step(src,direction))
		if( (target.initialize_directions & get_dir(target,src)) && check_connect_types(target,src) )
			return target
