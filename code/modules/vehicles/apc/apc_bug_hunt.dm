/obj/vehicle/multitile/apc/command/bug_hunt
	name = "M577-RECON Armored Personnel Carrier"
	desc = "A Force Reconnaissance variant of the M577 command APC, combining a field command station with a surgical and triage bay. Entrances on the sides."
	interior_map = /datum/map_template/interior/apc_bughunt
	passengers_slots = 20
	revivable_dead_slots = 6

/obj/vehicle/multitile/apc/command/bug_hunt/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(block_core_roof))

/obj/vehicle/multitile/apc/command/bug_hunt/proc/block_core_roof(atom/movable/source, turf/target_turf)
	SIGNAL_HANDLER
	for(var/obj/effect/alien/resin/special/pylon/core/core in target_turf.linked_pylons)
		if(!QDELETED(core))
			return COMPONENT_TURF_DENY_MOVEMENT

/obj/vehicle/multitile/apc/command/bug_hunt/load_role_reserved_slots()
	return

/obj/effect/vehicle_spawner/apc_cmd/fixed/bug_hunt
	name = "APC RECON Spawner"

/obj/effect/vehicle_spawner/apc_cmd/fixed/bug_hunt/spawn_vehicle()
	var/obj/vehicle/multitile/apc/command/bug_hunt/apc = new(loc)
	load_misc(apc)
	load_hardpoints(apc)
	handle_direction(apc)
	apc.update_icon()

/obj/effect/vehicle_spawner/apc_cmd/fixed/bug_hunt/load_hardpoints(obj/vehicle/multitile/apc/command/bug_hunt/apc)
	..()

	for(var/obj/item/hardpoint/hardpoint in apc.get_hardpoints_with_ammo())
		for(var/i in 1 to hardpoint.max_clips)
			LAZYADD(hardpoint.backup_clips, new hardpoint.ammo.type(hardpoint))
