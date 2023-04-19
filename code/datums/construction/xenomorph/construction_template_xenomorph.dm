#define XENO_STRUCTURE_PLASMA_MULTIPLIER 10 //When using plasma to construct we need it to cost more.

/datum/construction_template/xenomorph
	name = "xenomorph structure"
	build_type = /obj/effect/alien/resin/special
	crystals_required = 45 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	var/datum/hive_status/hive_ref //Who gets what we build
	var/block_range = 1

/datum/construction_template/xenomorph/set_structure_image()
	build_icon = 'icons/mob/xenos/structures64x64.dmi'

/datum/construction_template/xenomorph/complete() //Override because we need to pass the hive ref
	if(!owner || !get_turf(owner))
		log_debug("Constuction template ([name]) completed construction without a build location")
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
	build_type = /obj/effect/alien/resin/special/pylon/core
	build_icon_state = "core"
	crystals_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/cluster
	name = XENO_STRUCTURE_CLUSTER
	build_type = /obj/effect/alien/resin/special/cluster
	build_icon_state = "hive_cluster"
	pixel_y = -8
	pixel_x = -8
	crystals_required = 50 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/cluster/set_structure_image()
	build_icon = 'icons/mob/xenos/structures48x48.dmi'

/datum/construction_template/xenomorph/pylon
	name = XENO_STRUCTURE_PYLON
	build_type = /obj/effect/alien/resin/special/pylon
	build_icon_state = "pylon"
	crystals_required = 100 * XENO_STRUCTURE_PLASMA_MULTIPLIER
	block_range = 0

/datum/construction_template/xenomorph/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	build_type = /obj/effect/alien/resin/special/eggmorph
	build_icon_state = "eggmorph_preview"

/datum/construction_template/xenomorph/recovery
	name = XENO_STRUCTURE_RECOVERY
	build_type = /obj/effect/alien/resin/special/recovery
	build_icon_state = "recovery"

/datum/construction_template/xenomorph/nest
	name = XENO_STRUCTURE_NEST
	build_type = /obj/effect/alien/resin/special/nest
	build_icon_state = "reinforced_nest"

	block_range = 0

	pixel_y = -8
	pixel_x = -8

	/// This will be used to orient the nest that will be built
	var/direction_to_put_nest

/datum/construction_template/xenomorph/nest/complete() //overrided for unique build logic
	if(!owner || !get_turf(owner))
		log_debug("Constuction template ([name]) completed construction without a build location")
		return
	if(hive_ref)
		hive_ref.remove_construction(owner)
	build_loc = get_turf(owner)
	var/obj/effect/alien/resin/special/nest/newly_builtor = new build_type(build_loc, hive_ref)
	playsound(build_loc, "alien_resin_build", 25)
	if(newly_builtor)
		newly_builtor.pred_nest.dir = direction_to_put_nest
		newly_builtor.pred_nest.pixel_x = newly_builtor.pred_nest.buckling_x["[direction_to_put_nest]"]
		newly_builtor.pred_nest.pixel_y = newly_builtor.pred_nest.buckling_y["[direction_to_put_nest]"]
	qdel(owner)
	qdel(src)

/datum/construction_template/xenomorph/nest/set_structure_image()
	build_icon = 'icons/mob/xenos/structures48x48.dmi'

/datum/construction_template/xenomorph/nest/on_template_creation()
	var/turf/home_turf = get_turf(owner)
	if(!home_turf.density)
		for(var/i in GLOB.cardinals)
			var/turf/stepped_turf = get_step(home_turf, i)
			if(stepped_turf.density)
				direction_to_put_nest = get_dir(stepped_turf, owner)
				return
	xeno_message(SPAN_XENOWARNING("This structure needs to be built directly next to an vertical surface."), 7, XENO_HIVE_NORMAL)
	qdel(owner)
	qdel(src)
