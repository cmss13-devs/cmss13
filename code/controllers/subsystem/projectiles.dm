SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 1
	init_order = SS_INIT_PROJECTILES
	flags = SS_TICKER
	priority = SS_PRIORITY_PROJECTILES

	/// List of projectiles handled by the subsystem
	VAR_PRIVATE/list/obj/projectile/projectiles
	/// List of projectiles on hold due to sleeping
	VAR_PRIVATE/list/obj/projectile/sleepers
	/// List of projectiles handled this controller firing
	VAR_PRIVATE/list/obj/projectile/flying

	/*
	 * Scheduling notes:
	 *  We have three different types of projectile collisions:
	 *
	 *   1. Travel hit: moving the bullet resulted in a scan collision.
	 *   This can be resolved immediately, on Subsystem time.
	 *   2. Passive hit: something else triggered Collide/Crossed()
	 *   -- This is scheduled on caller time for simplicity. --
	 *   It includes impacts as a direct result of firing the gun.
	 *   3. Chain hit: Collide/Crossed() is triggered on SS time.
	 *   This can happen eg. if a rocket knocks someone on a bullet.
	 *
	 * Aside from performance, this can matter for order of operations.
	 */

/datum/controller/subsystem/projectiles/stat_entry(msg)
	msg = " | #Proj: [length(projectiles)]"
	return ..()

/datum/controller/subsystem/projectiles/Initialize(start_timeofday)
	projectiles = list()
	flying = list()
	sleepers = list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/projectiles/fire(resumed = FALSE)
	if(!resumed)
		flying = projectiles.Copy()
		flying -= sleepers
	while(length(flying))
		var/obj/projectile/projectile = flying[length(flying)]
		flying.len--
		var/delta_time = wait * world.tick_lag * (1 SECONDS)
		handle_projectile_flight(projectile, delta_time)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/projectiles/proc/handle_projectile_flight(obj/projectile/projectile, delta_time)
	PRIVATE_PROC(TRUE)
	set waitfor = FALSE
	// We're in double-check land here because there ARE rulebreakers.
	if(QDELETED(projectile))
		log_debug("SSprojectiles: projectile '[projectile.name]' shot by '[projectile.firer]' is scheduled despite being deleted.")
	else if(projectile.speed > 0)
		. = process_wrapper(projectile, delta_time)
	else
		log_debug("SSprojectiles: projectile '[projectile.name]' shot by '[projectile.firer]' discarded due to invalid speed.")
	if(. == PROC_RETURN_SLEEP)
		log_debug("SSprojectiles: projectile '[projectile.name]' shot by '[projectile.firer]' at ([projectile.x],[projectile.y],[projectile.z]) found sleeping despite all the sleep prevention! Putting on hold.")
		sleepers += projectile
	else if(.)
		stop_projectile(projectile) // Ideally this was already done thru process()
		qdel(projectile)

/datum/controller/subsystem/projectiles/proc/process_wrapper(obj/projectile/projectile, delta_time)
	// set waitfor=TRUE
	. = PROC_RETURN_SLEEP
	. = projectile.process(delta_time)
	sleepers -= projectile // Recover from sleep

/datum/controller/subsystem/projectiles/proc/queue_projectile(obj/projectile/projectile)
	projectiles |= projectile
/datum/controller/subsystem/projectiles/proc/stop_projectile(obj/projectile/projectile)
	projectiles -= projectile
	flying -= projectile // avoids problems with deleted projs
	projectile.speed = 0
