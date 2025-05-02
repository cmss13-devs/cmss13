/obj/structure/droppod/equipment
	name = "\improper USCM droppod"
	var/obj/equipment_to_spawn

/obj/structure/droppod/equipment/Initialize(mapload, equipment, mob/M)
	if(!equipment)
		return INITIALIZE_HINT_QDEL
	spawn_equipment(equipment, M)
	return ..()

/obj/structure/droppod/equipment/proc/spawn_equipment(equipment, mob/M)
	equipment_to_spawn = new equipment(src)
	return equipment_to_spawn

/obj/structure/droppod/equipment/Destroy()
	QDEL_NULL(equipment_to_spawn)
	return ..()

/obj/structure/droppod/equipment/open()
	. = ..()
	move_equipment()
	equipment_to_spawn = null
	qdel(src)

/obj/structure/droppod/equipment/proc/move_equipment()
	if(equipment_to_spawn)
		equipment_to_spawn.forceMove(loc)

/obj/structure/droppod/equipment/sentry/spawn_equipment(equipment, mob/M)
	var/obj/structure/machinery/defenses/sentry/sentry = ..()
	sentry.owner_mob = M
	return sentry

/obj/structure/droppod/equipment/sentry/move_equipment()
	..()
	var/obj/structure/machinery/defenses/sentry/sentry = equipment_to_spawn
	sentry.power_on()

/obj/structure/droppod/equipment/sentry_holder/spawn_equipment(equipment, mob/M)
	var/obj/structure/machinery/sentry_holder/holder = ..()
	var/obj/structure/machinery/defenses/sentry/sentry = holder.deployed_turret
	sentry.owner_mob = M
	return holder

/obj/structure/droppod/equipment/sentry_holder/move_equipment()
	..()
	var/obj/structure/machinery/sentry_holder/holder = equipment_to_spawn
	holder.deploy_sentry()
