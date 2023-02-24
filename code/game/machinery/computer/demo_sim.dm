#define HUMAN_MODE "Unarmoured Humans"
#define UPP_MODE "UPP Conscripts"
#define CLF_MODE "CLF Guerillas"
#define RUNNER_MODE "Xenomorph Runners"
#define SPITTER_MODE "Xenomorph Spitters"
#define DEFENDER_MODE "Xenomorph Defenders"
#define RAVAGER_MODE "Xenomorph Ravagers"
#define CRUSHER_MODE "Xenomorph Crushers"

/obj/structure/machinery/computer/demo_sim
	name = "demolitions simulator"
	desc = "A powerful simulator that can simulate explosions. Its processors need a cooldown of approximately 1 minute after each simulation."
	icon_state = "demo_sim"
	exproof = TRUE
	unacidable = TRUE
	var/obj/item/configuration
	var/obj/structure/machinery/camera/simulation/simulation
	// is the ui user actually looking at the simulation?
	var/looking_at_simulation = FALSE

	COOLDOWN_DECLARE(detonation_cooldown)
	var/detonation_cooldown_time = 1 MINUTES

	var/dummy_mode = HUMAN_MODE

	var/list/target_types = list(
		HUMAN_MODE = /mob/living/carbon/human,
		UPP_MODE = /mob/living/carbon/human,
		CLF_MODE = /mob/living/carbon/human,
		RUNNER_MODE = /mob/living/carbon/xenomorph/runner,
		SPITTER_MODE = /mob/living/carbon/xenomorph/spitter,
		DEFENDER_MODE = /mob/living/carbon/xenomorph/defender,
		RAVAGER_MODE = /mob/living/carbon/xenomorph/ravager,
		CRUSHER_MODE = /mob/living/carbon/xenomorph/crusher,
	)

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

/obj/structure/machinery/computer/demo_sim/get_examine_text(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, detonation_cooldown))
		. += SPAN_WARNING("The processors are currently cooling, [COOLDOWN_TIMELEFT(src, detonation_cooldown)/10] seconds remaining")

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
		to_chat(user, SPAN_NOTICE("You configure \the [src] to simulate [B]."))
	else
		to_chat(user, "\The [src] is not compatible with [B].")

/obj/structure/machinery/computer/demo_sim/attack_hand(mob/user as mob)
	if(..())
		return
	tgui_interact(user)

// TGUI SHIT \\

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
	data["looking"] = looking_at_simulation
	data["dummy_mode"] = dummy_mode

	data["worldtime"] = world.time
	data["nextdetonationtime"] = detonation_cooldown
	data["detonation_cooldown"] = detonation_cooldown_time

	return data

/obj/structure/machinery/computer/demo_sim/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("start_watching")
			start_watching(usr)
			. = TRUE

		if("stop_watching")
			stop_watching(usr)
			. = TRUE

		if("eject")
			if(configuration)
				configuration.forceMove(loc)
				configuration = null
			else
				to_chat(usr, SPAN_NOTICE("Nothing to eject."))
			. = TRUE

		if("detonate")
			if(!configuration)
				to_chat(usr, SPAN_NOTICE("No configuration set."))
				return
			simulate_detonation(usr)
			. = TRUE

		if("switchmode")
			dummy_mode = tgui_input_list(usr, "Select target type to simulate", "Target type", target_types, 30 SECONDS)
			if(!dummy_mode)
				dummy_mode = HUMAN_MODE
			. = TRUE

/obj/structure/machinery/computer/demo_sim/ui_close(mob/user)
	. = ..()
	if(looking_at_simulation)
		stop_watching(user)

// TGUI SHIT END \\

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
	looking_at_simulation = TRUE

/obj/structure/machinery/computer/demo_sim/proc/stop_watching(mob/living/user)
	user.unset_interaction()
	user.reset_view(null)
	user.cameraFollow = null
	looking_at_simulation = FALSE

/obj/structure/machinery/computer/demo_sim/proc/simulate_detonation(mob/living/user)
	COOLDOWN_START(src, detonation_cooldown, detonation_cooldown_time)

	var/spawn_path = target_types[dummy_mode]
	var/spawning_humans = FALSE
	if(dummy_mode == HUMAN_MODE || dummy_mode == CLF_MODE || dummy_mode == UPP_MODE)
		spawning_humans = TRUE

	for(var/spawn_loc in GLOB.simulator_targets)
		if(spawning_humans)
			var/mob/living/carbon/human/dummy = new /mob/living/carbon/human(get_turf(spawn_loc))
			switch(dummy_mode)
				if(CLF_MODE)
					user.client.cmd_admin_dress_human(dummy, "CLF Soldier", no_logs = TRUE)
				if(UPP_MODE)
					user.client.cmd_admin_dress_human(dummy, "UPP Conscript", no_logs = TRUE)
			dummy.name = "simulated human"
			QDEL_IN(dummy, detonation_cooldown_time - 10 SECONDS)
		else
			var/mob/living/carbon/xenomorph/xeno_dummy = new spawn_path(get_turf(spawn_loc))
			xeno_dummy.hardcore = TRUE
			QDEL_IN(xeno_dummy, detonation_cooldown_time - 10 SECONDS)

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

/obj/structure/machinery/computer/demo_sim/proc/make_and_prime_explosive(obj/item/explosive/O)
	var/obj/item/explosive/E = new O.type(simulation.loc)
	E.make_copy_of(O)
	E.prime(TRUE)
	var/turf/sourceturf = get_turf(simulation)
	sourceturf.chemexploded = FALSE //Make sure that this actually resets
	QDEL_IN(E,1 MINUTES)
