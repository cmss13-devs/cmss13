/*
** PRESETS SPAWNERS
*/
//These help spawning vehicles that don't end up as subtypes, causing problems later with various checks
//as well as allowing customizations, like properly turning on mapped in direction and so on.

/obj/effect/vehicle_spawner
	name = "Vehicle Spawner"
	var/spawn_type = /obj/vehicle/multitile
	var/spawn_damaged = FALSE

/obj/effect/vehicle_spawner/Initialize()
	. = ..()
	return INITIALIZE_HINT_QDEL

//Main proc which handles spawning and adding hardpoints/damaging the vehicle
/obj/effect/vehicle_spawner/proc/spawn_vehicle()
	var/obj/vehicle/multitile/V = new spawn_type(loc)

	load_hardpoints(V)
	load_misc(V)
	if(spawn_damaged)
		deal_damage(V)
	handle_direction(V)
	V.update_icon()
	return V

//Installation of modules kit
/obj/effect/vehicle_spawner/proc/load_hardpoints(obj/vehicle/multitile/V)
	return

//Miscellaneous additions
/obj/effect/vehicle_spawner/proc/load_misc(obj/vehicle/multitile/V)

	V.load_role_reserved_slots()
	V.initialize_cameras()
	//transfer mapped in edits
	if(color)
		V.color = color
	if(name != initial(name))
		V.name = name
	if(desc)
		V.desc = desc

//Dealing enough damage to destroy the vehicle
/obj/effect/vehicle_spawner/proc/deal_damage(obj/vehicle/multitile/V)
	V.take_damage_type(1e8, "abstract")
	V.take_damage_type(1e8, "abstract")
	V.healthcheck()

/obj/effect/vehicle_spawner/proc/handle_direction(obj/vehicle/multitile/M)
	switch(dir)
		if(EAST)
			M.try_rotate(90)
		if(WEST)
			M.try_rotate(-90)
		if(NORTH)
			M.try_rotate(90)
			M.try_rotate(90)
