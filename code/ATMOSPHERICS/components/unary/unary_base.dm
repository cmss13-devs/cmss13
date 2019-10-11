/obj/structure/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH
	health = 0

	var/gas_type = GAS_TYPE_AIR
	var/temperature = T20C
	var/pressure = ONE_ATMOSPHERE

	var/obj/structure/machinery/atmospherics/node

	var/datum/pipe_network/network

/obj/structure/machinery/atmospherics/unary/New()
	..()
	initialize_directions = dir

// Housekeeping and pipe network stuff below
/obj/structure/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/structure/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/structure/machinery/atmospherics/unary/Dispose()
	if(node)
		node.disconnect(src)
		del(network)
	node = null
	. = ..()

/obj/structure/machinery/atmospherics/unary/initialize()
	if(node) return

	var/node_connect = dir

	for(var/obj/structure/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			var/c = check_connect_types(target,src)
			if (c)
				target.connected_to = c
				src.connected_to = c
				node = target
				break

	update_icon()
	update_underlays()

/obj/structure/machinery/atmospherics/unary/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)


/obj/structure/machinery/atmospherics/unary/return_network(obj/structure/machinery/atmospherics/reference)
	build_network()

	if(reference == node || reference == src)
		return network

	return null

/obj/structure/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/structure/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	return results

/obj/structure/machinery/atmospherics/unary/disconnect(obj/structure/machinery/atmospherics/reference)
	if(reference==node)
		del(network)
		node = null

	update_icon()
	update_underlays()
	start_processing()
	return null


/obj/structure/machinery/atmospherics/unary/return_air()
	return list(gas_type, temperature, pressure)

/obj/structure/machinery/atmospherics/unary/return_pressure()
	return pressure

/obj/structure/machinery/atmospherics/unary/return_temperature()
	return temperature

/obj/structure/machinery/atmospherics/unary/return_gas()
	return gas_type
