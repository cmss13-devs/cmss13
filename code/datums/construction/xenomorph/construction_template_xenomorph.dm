#define XENO_STRUCTURE_PLASMA_MULTIPLIER 10 //When using plasma to construct we need it to cost more.

/datum/construction_template/xenomorph
	name = "xenomorph structure"
	build_type = /obj/effect/alien/resin/special
	plasma_required = 45 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	/// The hive that this structure belongs to.
	var/datum/hive_status/hive_ref
	/// The range around this structure which needs to be clear for it to be constructed.
	var/block_range = 1

/datum/construction_template/xenomorph/set_structure_image()
	build_icon = 'icons/mob/xenos/structures64x64.dmi'

/datum/construction_template/xenomorph/complete() //Override because we need to pass the hive ref
	if(!owner || !get_turf(owner))
		log_debug("Construction template ([name]) completed construction without a build location")
		return
	if(hive_ref)
		hive_ref.remove_construction(owner)
	build_loc = get_turf(owner)
	new build_type(build_loc, hive_ref)
	playsound(build_loc, "alien_resin_build", 25)
	qdel(owner)
	qdel(src)

/datum/construction_template/xenomorph/core
	name = XENO_STRUCTURE_CORE
	description = "Heart of the hive, grows hive weeds (which are necessary for other structures), stores larva, spawns lesser drones, and protects the hive from skyfire."
	build_type = /obj/effect/alien/resin/special/pylon/core
	build_icon_state = "core"
	plasma_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/cluster
	name = XENO_STRUCTURE_CLUSTER
	description = "Remote section of the hive, grows hive weeds, and morphs into a hive pylon when placed near a communications tower."
	build_type = /obj/effect/alien/resin/special/cluster
	build_icon_state = "hive_cluster"
	pixel_y = -8
	pixel_x = -8
	plasma_required = 50 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/cluster/set_structure_image()
	build_icon = 'icons/mob/xenos/structures48x48.dmi'

/datum/construction_template/xenomorph/pylon
	name = XENO_STRUCTURE_PYLON
	description = "Remote section of the hive, grows hive weeds, spawns lesser drones, and protects sisters from air strikes."
	build_type = /obj/effect/alien/resin/special/pylon
	build_icon_state = "pylon"
	plasma_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	description = "Processes hatched hosts into new facehuggers."
	build_type = /obj/effect/alien/resin/special/eggmorph
	build_icon_state = "eggmorph_preview"

/datum/construction_template/xenomorph/plasma_tree
	name = XENO_STRUCTURE_PLASMA_TREE
	description = "Gives out small bursts of plasma, replenishing the reserves of the sisters around it."
	build_type = /obj/effect/alien/resin/special/plasma_tree
	build_icon_state = "recovery_plasma"


/datum/construction_template/xenomorph/recovery
	name = XENO_STRUCTURE_RECOVERY
	description = "Hastily recovers the strength of sisters resting around it."
	build_type = /obj/effect/alien/resin/special/recovery
	build_icon_state = "recovery"

#undef XENO_STRUCTURE_PLASMA_MULTIPLIER
