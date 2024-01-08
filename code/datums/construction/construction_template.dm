//Construction template datums. Used by factions to build unique structures with a material resource requirement. Stores references to the build type path, icon, and icon_state for the purpose of overlaying the finished product wherever you place the construction marker.

/datum/construction_template
	var/name = "generic structure"
	var/description //Used to explain to the user what this structure does.

	var/atom/owner //Where it should refer to for completion and locations

	var/build_type = /obj/structure
	var/build_loc
	var/build_icon
	var/build_icon_state

	var/pixel_y = -16
	var/pixel_x = -16

	var/plasma_required = 0
	var/plasma_stored = 0
	var/materials_required = list() //Example resource requirements i.e. MATERIAL_METAL = 1
	var/extras_required = list() //Example extra requirements i.e. /obj/item = 1

/datum/construction_template/New()
	. = ..()
	set_structure_image()

/datum/construction_template/Destroy()
	owner = null
	build_loc = null
	return ..()

///runs in /obj/effect/alien/resin/construction/proc/set_template() for logic needed to occur then
/datum/construction_template/proc/on_template_creation()
	return

/datum/construction_template/proc/set_structure_image()
	return

/datum/construction_template/proc/get_structure_image()
	return image(build_icon, build_icon_state)

/datum/construction_template/proc/add_crystal(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return
	if(!xeno.plasma_max)
		return
	if(plasma_stored >= plasma_required)
		to_chat(xeno, SPAN_WARNING("\The [name] does not require plasma."))
		return
	to_chat(xeno, SPAN_NOTICE("We begin adding \the plasma to \the [name]."))
	xeno_attack_delay(xeno)
	if(!do_after(xeno, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	//double-check amount required
	if(plasma_stored >= plasma_required)
		to_chat(xeno, SPAN_WARNING("\The [name] has enough plasma."))
		return
	var/amount_to_use = min(xeno.plasma_stored, (plasma_required - plasma_stored))
	plasma_stored += amount_to_use
	xeno.plasma_stored -= amount_to_use
	to_chat(xeno, SPAN_WARNING("\The [name] requires [plasma_required - plasma_stored] more plasma."))
	check_completion()

/datum/construction_template/proc/add_material(mob/user, obj/item/I)
	if(isStack(I))
		var/obj/item/stack/S = I
		if(!(S.stack_id in materials_required))
			to_chat(user, SPAN_WARNING("\The [name] does not require [I.name]."))
			return
		if(!materials_required[S.stack_id])
			to_chat(user, SPAN_WARNING("\The [name] has enough [I.name]."))
			return
		to_chat(user, SPAN_NOTICE("You begin adding \the [I.name] to \the [name]."))
		if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		//double-check amount required
		if(!materials_required[S.stack_id])
			to_chat(user, SPAN_WARNING("\The [name] has enough [I.name]."))
			return
		var/amount_to_use = min(S.amount, materials_required[S.stack_id])
		materials_required[S.stack_id] -= amount_to_use
		S.use(amount_to_use)
	else if(I.type in extras_required)
		if(!extras_required[I.type])
			to_chat(user, SPAN_WARNING("\The [name] has enough [I.name]."))
			return
		to_chat(user, SPAN_NOTICE("You begin adding \the [I.name] to \the [name]."))
		if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		//double-check amount required
		if(!extras_required[I.type])
			to_chat(user, SPAN_WARNING("\The [name] has enough [I.name]."))
			return
		user.temp_drop_inv_item(I)
		extras_required[I.type]--
		qdel(I)
	else
		to_chat(user, SPAN_WARNING("\The [name] does not require [I.name]."))
		return
	check_completion()

/datum/construction_template/proc/check_completion()
	if(plasma_stored < plasma_required)
		return FALSE
	for(var/material_req in materials_required)
		if(materials_required[material_req] > 0)
			return FALSE
	for(var/extra_req in extras_required)
		if(extras_required[extra_req] > 0)
			return FALSE
	complete()
	return TRUE

/datum/construction_template/proc/complete()
	if(!build_loc)
		log_debug("Constuction template ([name]) completed construction without a build location")
		return
	new build_type(build_loc)
	qdel(src)
