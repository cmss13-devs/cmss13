/obj/structure/machinery/computer/demo_sim
	name = "demolitions simulator"
	desc = "A powerful simulator that can simulate explosions. Its processors need a cooldown of approximately 1 minute after each simulation."
	icon_state = "demo_sim"
	exproof = TRUE
	unacidable = TRUE
	var/obj/item/configuration
	var/obj/structure/machinery/camera/simulation/simulation
	var/cooling = FALSE

/obj/effect/landmark/sim_target
	name = "simulator_target"

/obj/effect/landmark/sim_target/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_targets += src

/obj/effect/landmark/sim_target/Destroy()
	GLOB.simulator_targets -= src
	return ..()

/obj/effect/landmark/sim_camera
	name = "simulator_camera"
	color = "#FFFF00";

/obj/effect/landmark/sim_camera/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_cameras += src

/obj/effect/landmark/sim_camera/Destroy()
	GLOB.simulator_cameras -= src
	return ..()

/obj/structure/machinery/computer/demo_sim/examine(mob/user)
	..()
	if(cooling)
		to_chat(user, "Processors are currently cooling.")

/obj/structure/machinery/computer/demo_sim/attackby(obj/item/B, mob/living/user)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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
	if(inoperable())
		return
	start_watching(user)

/obj/structure/machinery/computer/demo_sim/proc/start_watching(mob/living/user)
	if(!simulation)
		simulation = SAFEPICK(GLOB.simulator_cameras)
	if(!simulation)
		to_chat(user, SPAN_WARNING("GPU damaged! Unable to start simulation."))
		return
	if(user.client.view != world_view_size)
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

	for(var/spawn_loc in GLOB.simulator_targets)
		var/mob/living/carbon/human/dummy = new /mob/living/carbon/human(get_turf(spawn_loc))
		dummy.name = "simulated human"
		QDEL_IN(dummy,1 MINUTES)

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

	addtimer(CALLBACK(src, .proc/stop_cooling), 2 MINUTES, TIMER_UNIQUE)

/obj/structure/machinery/computer/demo_sim/proc/make_and_prime_explosive(var/obj/item/explosive/O)
	var/obj/item/explosive/E = new O.type(simulation.loc)
	E.make_copy_of(O)
	E.prime(TRUE)
	var/turf/sourceturf = get_turf(simulation)
	sourceturf.chemexploded = FALSE //Make sure that this actually resets
	QDEL_IN(E,1 MINUTES)

/obj/structure/machinery/computer/demo_sim/proc/stop_cooling()
	cooling = FALSE
