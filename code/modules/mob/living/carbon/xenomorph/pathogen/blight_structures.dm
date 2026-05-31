#define PATHO_STRUCTURE_PLASMA_MULTIPLIER 10 //When using plasma to construct we need it to cost more.

/obj/effect/alien/weeds/node/pylon/cluster/pathogen
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/node/pylon/cluster/pathogen/set_parent_damaged()
	if(!resin_parent)
		return

	var/obj/effect/alien/resin/special/cluster/pathogen/parent_cluster = resin_parent
	parent_cluster.damaged = TRUE

/datum/construction_template/xenomorph/pathogen_cluster
	name = PATHOGEN_STRUCTURE_CLUSTER
	description = "Remote section of the confluence, grows confluence blight, and morphs into a blight pylon when placed near a communications tower."
	build_type = /obj/effect/alien/resin/special/cluster/pathogen
	build_icon_state = "hive_cluster"
	pixel_y = -8
	pixel_x = -8
	plasma_required = 50 * PATHO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/pathogen_cluster/set_structure_image()
	build_icon = 'icons/mob/pathogen/pathogen_structures48x48.dmi'


/obj/effect/alien/resin/special/cluster/pathogen
	name = PATHOGEN_STRUCTURE_CLUSTER
	desc = "A large clump of mycelium. It rhythmically pulses, as if its pumping something into the blight below..."
	icon = 'icons/mob/pathogen/pathogen_structures48x48.dmi'
	icon_state = "hive_cluster_idle"

	pixel_x = -8
	pixel_y = -8

	health = 1200
	block_range = 0

	node_type = /obj/effect/alien/weeds/node/pylon/cluster/pathogen

/obj/effect/alien/resin/special/cluster/pathogen/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, get_minimap_flag_for_faction(linked_hive?.hivenumber), image('icons/mob/pathogen/neo_blips.dmi', null, "cluster"))


/obj/effect/alien/weeds/node/pylon
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/resin/special/pylon/pathogen
	name = PATHOGEN_STRUCTURE_PYLON
	desc = "A towering spike of mycelium. Its base pulsates with large tendrils."
	icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
	forced_hive = TRUE
	hivenumber = XENO_HIVE_PATHOGEN
	lesser_drone_spawn_limit = 0

/obj/effect/alien/resin/special/pylon/endgame/pathogen
	name = PATHOGEN_STRUCTURE_PYLON
	desc = "A towering spike of mycelium. Its base pulsates with large tendrils."
	icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
	forced_hive = TRUE
	hivenumber = XENO_HIVE_PATHOGEN
	lesser_drone_spawn_limit = 0

/datum/construction_template/xenomorph/patho_plasma
	name = PATHOGEN_STRUCTURE_PLASMA
	description = "Gives out small bursts of plasma, replenishing the reserves of the sisters around it."
	build_type = /obj/effect/alien/resin/special/plasma_tree/pathogen
	build_icon_state = "recovery_plasma"


/datum/construction_template/xenomorph/patho_recovery
	name = PATHOGEN_STRUCTURE_RECOVERY
	description = "Hastily recovers the strength of sisters resting around it."
	build_type = /obj/effect/alien/resin/special/recovery/pathogen
	build_icon_state = "recovery"



#undef PATHO_STRUCTURE_PLASMA_MULTIPLIER
