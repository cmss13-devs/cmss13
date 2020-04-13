/obj/structure/machinery/computer/demo_sim
	name = "demolitions simulator"
	desc = "A powerful simulator that can simulate explosions. Its processors need a cooldown of approximately 1 minute after each simulation."
	icon_state = "demo_sim"
	exproof = TRUE
	unacidable = TRUE
	var/obj/item/configuration
	var/obj/structure/machinery/camera/simulation/simulation
	var/list/dummy_spawn_locs = list()
	var/cooling = FALSE

/obj/structure/machinery/computer/demo_sim/Initialize()
	. = ..()
	add_timer(CALLBACK(src, .proc/post_Initialize), 20, TIMER_UNIQUE)

/obj/structure/machinery/computer/demo_sim/proc/post_Initialize()
	for(var/obj/effect/landmark/L in landmarks_list)
		switch(L.name)
			if("simulator_target")
				dummy_spawn_locs += L.loc
				qdel(L)
			if("simulator_camera")
				simulation = new /obj/structure/machinery/camera/simulation(L.loc)
				qdel(L)

/obj/structure/machinery/computer/demo_sim/examine(mob/user)
	..()
	if(cooling)
		to_chat(user, "Processors are currently cooling.")

/obj/structure/machinery/computer/demo_sim/attackby(obj/item/B, mob/living/user)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_OT))
		to_chat(user, SPAN_WARNING("You don't know how to configure [src]."))
		return
	if(configuration)
		to_chat(user, SPAN_WARNING("[src] already has an item for configuration! Eject that first!"))
		return
	if(istype(B, /obj/item/explosive) || istype(B, /obj/item/mortar_shell) || istype(B, /obj/item/ammo_magazine/rocket/custom))
		user.drop_held_item(B)
		B.forceMove(src)
		configuration = B
		to_chat(user, "You configure [src] to simulate [B].")
		start_watching(user)
	else
		to_chat(user, "[src] is not compatible with [B].")

/obj/structure/machinery/computer/demo_sim/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	start_watching(user)

/obj/structure/machinery/computer/demo_sim/proc/start_watching(mob/living/user)
	if(!simulation)
		to_chat(user, SPAN_WARNING("GPU damaged! Unable to start simulation."))
		return
	if(user.client.view != world.view)
		to_chat(user, SPAN_WARNING("You're too busy looking at something else."))
		return
	user.reset_view(simulation)
	check_response(alert(user,"Welcome to the simulation.","[src]","Detonate","Eject","Quit"), user)

/obj/structure/machinery/computer/demo_sim/proc/stop_watching(mob/living/user)
	user.unset_interaction()
	user.reset_view(null)
	user.cameraFollow = null

/obj/structure/machinery/computer/demo_sim/proc/check_response(var/response, mob/living/user)
	switch(response)
		if("Detonate")
			if(cooling)
				to_chat(user, SPAN_WARNING("Processors are cooling down"))
				stop_watching(user)
				return
			if(!configuration)
				to_chat(user, SPAN_NOTICE("No configuration set."))
				stop_watching(user)
				return
			simulate_detonation()
			check_response(alert(user,"Simulation for [configuration].","[src]","Detonate","Eject","Quit"), user)
		if("Quit")
			stop_watching(user)
		if("Eject")
			if(configuration)
				configuration.forceMove(loc)
				configuration = null
			else
				to_chat(user, SPAN_NOTICE("Nothing to eject."))
			stop_watching(user)

/obj/structure/machinery/computer/demo_sim/proc/simulate_detonation()
	cooling = TRUE

	for(var/spawn_loc in dummy_spawn_locs)
		var/var/mob/living/carbon/human/dummy = new /mob/living/carbon/human(spawn_loc)
		dummy.name = "simulated human"
		QDEL_IN(dummy,MINUTES_1)

	//Simply an explosive
	if(istype(configuration,/obj/item/explosive))
		make_and_prime_explosive(configuration)
	//Mortars
	else if(istype(configuration,/obj/item/mortar_shell))
		if(istype(configuration,/obj/item/mortar_shell/custom))//we only need the warhead
			var/obj/item/mortar_shell/custom/O = configuration
			if(O.warhead)
				make_and_prime_explosive(O.warhead)
		else
			var/obj/item/mortar_shell/O = new configuration.type(simulation.loc)
			O.detonate(simulation.loc)
	//Rockets (custom only because projectiles are spaghetti)
	else if(istype(configuration,/obj/item/ammo_magazine/rocket/custom))
		var/obj/item/ammo_magazine/rocket/custom/O = configuration
		if(O.warhead)
			make_and_prime_explosive(O.warhead)
			
	add_timer(CALLBACK(src, .proc/stop_cooling), MINUTES_2, TIMER_UNIQUE)

/obj/structure/machinery/computer/demo_sim/proc/make_and_prime_explosive(var/obj/item/explosive/O)
	var/obj/item/explosive/E = new O.type(simulation.loc)
	E.make_copy_of(O)
	E.prime(TRUE)
	var/turf/sourceturf = get_turf(simulation)
	sourceturf.chemexploded = FALSE //Make sure that this actually resets
	QDEL_IN(E,MINUTES_1)

/obj/structure/machinery/computer/demo_sim/proc/stop_cooling()
	cooling = FALSE