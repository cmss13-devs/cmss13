#define XENO_STRUCTURE_PLASMA_MULTIPLIER 10 //When using plasma to construct we need it to cost more.

/datum/construction_template/xenomorph
	name = "xenomorph structure"
	build_type = /obj/effect/alien/resin/special
	build_icon = 'icons/mob/xenos/structures64x64.dmi'
	crystals_required = 45 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	var/datum/hive_status/hive_ref //Who gets what we build
	var/requires_node = TRUE

/datum/construction_template/xenomorph/complete() //Override because we need to pass the hive ref
	if(!build_loc)
		log_debug("Constuction template ([name]) completed construction without a build location")
		return
	if(hive_ref)
		hive_ref.remove_construction(owner)
	new build_type(build_loc, hive_ref)
	playsound(build_loc, "alien_resin_build", 25)
	qdel(owner)
	qdel(src)

/datum/construction_template/xenomorph/core
	name = XENO_STRUCTURE_CORE
	build_type = /obj/effect/alien/resin/special/pylon/core
	build_icon_state = "core"
	crystals_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	requires_node = FALSE

/datum/construction_template/xenomorph/pylon
	name = XENO_STRUCTURE_PYLON
	build_type = /obj/effect/alien/resin/special/pylon
	build_icon_state = "pylon"
	crystals_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	requires_node = FALSE

/datum/construction_template/xenomorph/pool
	name = XENO_STRUCTURE_POOL
	build_type = /obj/effect/alien/resin/special/pool
	build_icon_state = "pool_preview"
	crystals_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER

/datum/construction_template/xenomorph/evopod
	name = XENO_STRUCTURE_EVOPOD
	build_type = /obj/effect/alien/resin/special/evopod
	build_icon_state = "evopod"
	crystals_required = 50 * XENO_STRUCTURE_PLASMA_MULTIPLIER

/datum/construction_template/xenomorph/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	build_type = /obj/effect/alien/resin/special/eggmorph
	build_icon_state = "eggmorph_preview"

/datum/construction_template/xenomorph/recovery
	name = XENO_STRUCTURE_RECOVERY
	build_type = /obj/effect/alien/resin/special/recovery
	build_icon_state = "recovery"
