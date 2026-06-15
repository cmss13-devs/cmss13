/datum/cooking/recipe_step/use_machine
	var/time
	var/temperature
	var/obj/structure/machinery/cooking/machine_type
	var/cooker_surface_name

/datum/cooking/recipe_step/use_machine/New(temperature_, time_, options)
	temperature = temperature_
	time = time_

	..(options)

/datum/cooking/recipe_step/use_machine/Destroy()
	. = ..()
	QDEL_NULL(machine_type)

/datum/cooking/recipe_step/use_machine/proc/extra_machine_step(obj/structure/machinery/cooking/machine)
	return

/datum/cooking/recipe_step/use_machine/check_conditions_met(obj/used_item, datum/cooking/recipe_tracker/tracker)
	if(istype(used_item, machine_type))
		return PCWJ_CHECK_SILENT

	return PCWJ_CHECK_INVALID

/datum/cooking/recipe_step/use_machine/is_complete(obj/added_item, datum/cooking/recipe_tracker/tracker, list/step_data)
	var/obj/item/reagent_container/cooking/container = tracker.container_parent
	if(istype(container) && container.get_cooker_time(cooker_surface_name, temperature) >= time)
		return TRUE

	return FALSE

/datum/cooking/recipe_step/use_machine/follow_step(obj/used_item, datum/cooking/recipe_tracker/tracker, mob/user)
	var/list/step_data = list(target = used_item)
	var/obj/item/reagent_container/cooking/container = tracker.container_parent
	if(istype(container))
		step_data["cooker_data"] = container.cooker_data.Copy()

	if(istype(used_item, machine_type))
		var/obj/structure/machinery/cooking/machine = used_item
		step_data["rating"] = machine.quality_mod

	step_data["signal"] = COMSIG_COOK_MACHINE_STEP_COMPLETE

	return step_data

/datum/cooking/recipe_step/use_machine/oven
	machine_type = /obj/structure/machinery/cooking/oven
	cooker_surface_name = COOKER_SURFACE_OVEN

/datum/cooking/recipe_step/use_machine/oven/extra_machine_step(obj/structure/machinery/cooking/machine)
	var/obj/structure/machinery/cooking/oven/oven = machine
	oven.opened = FALSE

/datum/cooking/recipe_step/use_machine/stovetop
	machine_type = /obj/structure/machinery/cooking/stovetop
	cooker_surface_name = COOKER_SURFACE_STOVE

/datum/cooking/recipe_step/use_machine/ice_cream_mixer
	machine_type = /obj/structure/machinery/cooking/ice_cream_mixer
	cooker_surface_name = COOKER_SURFACE_ICE_CREAM_MIXER

/datum/cooking/recipe_step/use_machine/ice_cream_mixer/New(time_, options)
	..(J_LO, time_, options)

/datum/cooking/recipe_step/use_machine/grill
	machine_type = /obj/structure/machinery/cooking/grill
	cooker_surface_name = COOKER_SURFACE_GRILL

/datum/cooking/recipe_step/use_machine/deepfryer
	machine_type = /obj/structure/machinery/cooking/deepfryer
	cooker_surface_name = COOKER_SURFACE_DEEPFRYER

/datum/cooking/recipe_step/use_machine/deepfryer/New(time_, options)
	..(J_LO, time_, options)
