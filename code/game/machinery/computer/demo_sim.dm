/obj/structure/machinery/computer/demo_sim
	name = "demolitions simulator"
	desc = "A powerful simulator that can simulate explosions. Its processors need a cooldown of approximately 1 minute after each simulation."
	icon_state = "demo_sim"
	exproof = TRUE
	unacidable = TRUE
	var/datum/simulator/simulation
	var/turf/sim_location
	var/obj/item/configuration

/obj/structure/machinery/computer/demo_sim/attackby(obj/item/B, mob/living/user)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know how to configure [src]."))
		return
	if(configuration)
		to_chat(user, SPAN_WARNING("[src] already has an item for configuration! Eject that first!"))
		return
	if(istype(B, /obj/item/explosive) || istype(B, /obj/item/mortar_shell) || istype(B, /obj/item/ammo_magazine/rocket/custom))
		user.drop_held_item(B)
		B.forceMove(src)
		configuration = B
		to_chat(user, SPAN_NOTICE("You configure \the [src] to simulate [B]."))
	else
		to_chat(user, "\The [src] is not compatible with [B].")

/obj/structure/machinery/computer/demo_sim/attack_hand(mob/user as mob)
	if(..())
		return

	tgui_interact(user)

/obj/structure/machinery/computer/demo_sim/Initialize()
	. = ..()
	simulation = new()

// DEMOLITIONS TGUI SHIT \\

/obj/structure/machinery/computer/demo_sim/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DemoSim", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/demo_sim/ui_state(mob/user) // we gotta do custom shit here so that it always closes instead of suspending
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/demo_sim/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/demo_sim/ui_data(mob/user)
	var/list/data = list()

	data["configuration"] = configuration
	data["dummy_mode"] = simulation.dummy_mode

	data["worldtime"] = world.time
	data["nextdetonationtime"] = simulation.detonation_cooldown
	data["detonation_cooldown"] = simulation.detonation_cooldown_time

	return data

/obj/structure/machinery/computer/demo_sim/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/user = ui.user

	switch(action)
		if("start_watching")
			simulation.start_watching(user)
			. = TRUE

		if("stop_watching")
			simulation.stop_watching(user)
			. = TRUE

		if("eject")
			if(configuration)
				configuration.forceMove(loc)
				configuration = null
			else
				to_chat(user, SPAN_NOTICE("Nothing to eject."))
			. = TRUE

		if("detonate")
			if(!configuration)
				to_chat(user, SPAN_NOTICE("No configuration set."))
				return
			simulate_detonation(user)
			. = TRUE

		if("switchmode")
			simulation.dummy_mode = tgui_input_list(user, "Select target type to simulate", "Target type", simulation.target_types, 30 SECONDS)
			if(!simulation.dummy_mode)
				simulation.dummy_mode = /mob/living/carbon/human
			. = TRUE

/obj/structure/machinery/computer/demo_sim/ui_close(mob/user)

	. = ..()
	simulation.stop_watching(user)

// DEMOLITIONS TGUI SHIT END \\


/obj/structure/machinery/computer/demo_sim/proc/simulate_detonation(mob/living/user)
	simulation.spawn_mobs(user)
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
			var/obj/item/mortar_shell/O = new configuration.type(get_turf(simulation.sim_camera))
			O.detonate(get_turf(simulation.sim_camera))
	//Rockets (custom only because projectiles are spaghetti)
	else if(istype(configuration,/obj/item/ammo_magazine/rocket/custom))
		var/obj/item/ammo_magazine/rocket/custom/O = configuration
		if(O.warhead)
			make_and_prime_explosive(O.warhead)

/obj/structure/machinery/computer/demo_sim/proc/make_and_prime_explosive(obj/item/explosive/O)
	var/obj/item/explosive/E = new O.type(get_turf(simulation.sim_camera))
	E.make_copy_of(O)
	E.prime(TRUE)
	sim_location = get_turf(simulation.sim_camera)
	sim_location.chemexploded = FALSE //Make sure that this actually resets
	QDEL_IN(E,1 MINUTES)
