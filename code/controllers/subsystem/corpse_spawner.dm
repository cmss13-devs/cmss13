SUBSYSTEM_DEF(corpse_spawner)
	name = "Corpse Spawner"
	init_order   = SS_INIT_CORPSESPAWNER
	priority = SS_PRIORITY_CORPSESPAWNER

	flags = SS_NO_FIRE
	can_fire = FALSE

	var/corpses = 15

/datum/controller/subsystem/corpse_spawner/Initialize()
	objectives_controller.generate_corpses(corpses)
	return ..()
