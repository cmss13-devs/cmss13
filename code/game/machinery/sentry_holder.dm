/obj/structure/machinery/sentry_holder
	name = "sentry deployment system"
	desc = "A box that deploys a sentry turret."
	density = FALSE
	anchored = TRUE
	unacidable = 1
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sentry_system_installed"
	active_power_usage = 5000
	idle_power_usage = 1000
	power_channel = 1
	use_power = USE_POWER_IDLE
	machine_processing = 1
	var/deployment_cooldown
	var/turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable // Path of the turret used
	var/obj/structure/machinery/defenses/sentry/premade/deployable/deployed_turret
	var/ox = 0
	var/oy = 0
	var/ind = FALSE
	var/require_red_alert = FALSE

/obj/structure/machinery/sentry_holder/Initialize()
	. = ..()
	if(!deployed_turret)
		deployed_turret = new turret_path(src)
		deployed_turret.deployment_system = src
		ox = pixel_x
		oy = pixel_y

/obj/structure/machinery/sentry_holder/Destroy()
	QDEL_NULL(deployed_turret)
	. = ..()

/obj/structure/machinery/sentry_holder/get_examine_text(mob/user)
	. = ..()
	if(!deployed_turret)
		. += "It's offline."

/obj/structure/machinery/sentry_holder/attack_hand(mob/user)
	if(!deployed_turret)
		to_chat(user, SPAN_WARNING("[src] is unresponsive."))
		return

	if(deployment_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src] is busy."))
		return

	if(deployed_turret.loc == src) //not deployed
		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNING("[src] is non-functional."))
			return

		if(require_red_alert && (seclevel2num(get_security_level()) < SEC_LEVEL_RED))
			to_chat(user, SPAN_WARNING("[src] can only be activated in emergencies."))
			return

		to_chat(user, SPAN_NOTICE("You deploy [src]."))
		deploy_sentry()
		return

	to_chat(user, SPAN_NOTICE("You retract [src]."))
	undeploy_sentry()
	return


/obj/structure/machinery/sentry_holder/process()
	if(stat & NOPOWER)
		if(deployed_turret)
			undeploy_sentry()
			ind = FALSE
		else
			icon_state = "sentry_system_destroyed"
	else
		update_use_power(USE_POWER_IDLE)
		if(!ind)
			deploy_sentry()
			ind = TRUE

/obj/structure/machinery/sentry_holder/proc/deploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.turned_on = TRUE
	deployed_turret.forceMove(loc)
	icon_state = "sentry_system_deployed"

	for(var/mob/M in deployed_turret.loc)
		if(deployed_turret.loc == src.loc)
			step(M, deployed_turret.dir)
		else
			step(M, get_dir(src,deployed_turret))

	deployed_turret.setDir(dir)
	deployed_turret.pixel_x = 0
	deployed_turret.pixel_y = 0

	deployed_turret.start_processing()
	deployed_turret.set_range()

/obj/structure/machinery/sentry_holder/proc/undeploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.forceMove(src)
	deployed_turret.turned_on = FALSE
	deployed_turret.stop_processing()
	deployed_turret.unset_range()
	pixel_x = ox
	pixel_y = oy
	icon_state = "sentry_system_installed"

/obj/structure/machinery/sentry_holder/Destroy()
	QDEL_NULL(deployed_turret)

	. = ..()

/obj/structure/machinery/sentry_holder/colony
	desc = "A box that deploys a sentry turret for protection of the residents in the area."
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/colony

/obj/structure/machinery/sentry_holder/almayer
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/almayer
	require_red_alert = TRUE
