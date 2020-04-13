/obj/structure/machinery/sentry_holder
	name = "sentry deployment system"
	desc = "A box that deploys a sentry turret."
	density = 0
	anchored = 1
	unacidable = 1
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sentry_system_installed"
	active_power_usage = 5000
	idle_power_usage = 1000
	power_channel = 1
	use_power = 1
	machine_processing = 1
	var/deployment_cooldown
	var/turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable // Path of the turret used
	var/obj/structure/machinery/defenses/sentry/premade/deployable/deployed_turret
	var/ox = 0
	var/oy = 0
	var/ind = FALSE

/obj/structure/machinery/sentry_holder/Initialize()
	. = ..()
	if(!deployed_turret)
		deployed_turret = new turret_path(src)
		deployed_turret.deployment_system = src
		ox = pixel_x
		oy = pixel_y

/obj/structure/machinery/sentry_holder/examine(mob/user)
	..()
	if(!deployed_turret)
		to_chat(user, "Its offline.")

/obj/structure/machinery/sentry_holder/attack_hand(mob/user)
	if(deployed_turret)
		if(deployment_cooldown > world.time)
			to_chat(user, SPAN_WARNING("[src] is busy."))
			return //prevents spamming deployment/undeployment
		if(deployed_turret.loc == src) //not deployed
			if(stat & NOPOWER)
				to_chat(user, SPAN_WARNING("[src] is non-functional."))
			else
				to_chat(user, SPAN_NOTICE("You deploy [src]."))
				deploy_sentry()
		else
			to_chat(user, SPAN_NOTICE("You retract [src]."))
			undeploy_sentry()
	else
		to_chat(user, SPAN_WARNING("[src] is unresponsive."))

/obj/structure/machinery/sentry_holder/process()
	if(stat & NOPOWER)
		if(deployed_turret)
			undeploy_sentry()
			ind = FALSE
		else
			icon_state = "sentry_system_destroyed"
	else
		update_use_power(1)
		if(!ind)
			deploy_sentry()
			ind = TRUE

/obj/structure/machinery/sentry_holder/proc/deploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.turned_on = TRUE
	deployed_turret.loc = loc
	icon_state = "sentry_system_deployed"

	for(var/mob/M in deployed_turret.loc)
		if(deployed_turret.loc == src.loc)
			step(M, deployed_turret.dir)
		else
			step(M, get_dir(src,deployed_turret))

	deployed_turret.dir = dir
	deployed_turret.pixel_x = 0
	deployed_turret.pixel_y = 0

	deployed_turret.start_processing()
	deployed_turret.set_range()

/obj/structure/machinery/sentry_holder/proc/undeploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.loc = src
	deployed_turret.turned_on = FALSE
	deployed_turret.stop_processing()
	deployed_turret.unset_range()
	pixel_x = ox
	pixel_y = oy
	icon_state = "sentry_system_installed"

/obj/structure/machinery/sentry_holder/Dispose()
	if(deployed_turret)
		qdel(deployed_turret)
		deployed_turret = null

	. = ..()

/obj/structure/machinery/sentry_holder/colony
	desc = "A box that deploys a sentry turret for protection of the residents in the area."
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/colony

