SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 1
	flags = SS_TICKER
	priority = SS_PRIORITY_PROJECTILES

	/// List of projectiles handled by the subsystem
	VAR_PRIVATE/list/obj/item/projectile/projectiles
	/// List of projectiles handled this controller firing
	VAR_PRIVATE/list/obj/item/projectile/flying

	/*
	 * Scheduling notes:
	 *  We have three different types of projectile collisions:
	 *
	 *   1. Travel hit: moving the bullet resulted in a scan collision.
	 *      This can be resolved immediately, on Subsystem time.
	 *   2. Passive hit: something else triggered Collide/Crossed()
	 *      -- This is scheduled on caller time for simplicity. --
	 *      It includes impacts as a direct result of firing the gun.
	 *   3. Chain hit: Collide/Crossed() is triggered on SS time.
	 *      This can happen eg. if a rocket knocks someone on a bullet.
	 *
	 * Aside from performance, this can matter for order of operations.
	 */

/datum/controller/subsystem/projectiles/stat_entry(msg)
	msg = " | #Proj: [projectiles.len]"
	return ..()

/datum/controller/subsystem/projectiles/Initialize(start_timeofday)
	projectiles = list()
	flying = list()
	return ..()

/datum/controller/subsystem/projectiles/fire(resumed = FALSE)
	if(!resumed)
		flying = projectiles.Copy()
	while(flying.len)
		var/obj/item/projectile/projectile = flying[flying.len]
		flying.len--
		var/delta_time = wait * world.tick_lag * (1 SECONDS)
		handle_projectile_flight(projectile, delta_time)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/projectiles/proc/handle_projectile_flight(obj/item/projectile/projectile, delta_time)
	set waitfor = FALSE
	. = projectile.process(delta_time)
	if(. == PROC_RETURN_SLEEP)
		log_debug("SSprojectiles: projectile '[projectile.name]' found sleeping despite all the sleep prevention. Discarding it.")
	if(.) // PROCESS_KILL basically
		projectiles -= projectile
		qdel(projectile)

/// Helper proc for direct projectile encounters
/datum/controller/subsystem/projectiles/proc/handle_projectile_hit(obj/item/projectile/projectile, atom/affected)
	SHOULD_NOT_SLEEP(TRUE)
	if(!projectile?.speed)
		return
	if(isobj(affected))
		return projectile.handle_object(affected)
	if(isliving(affected))
		return projectile.handle_mob(affected)

/datum/controller/subsystem/projectiles/proc/queue_projectile(obj/item/projectile/projectile)
	projectiles |= projectile
/datum/controller/subsystem/projectiles/proc/stop_projectile(obj/item/projectile/projectile)
	projectiles -= projectile
	flying -= projectile // avoids problems with deleted projs
