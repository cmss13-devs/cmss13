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

    var/crystals_required = 0
    var/crystals_stored = 0
    var/materials_required = list() //Example resource requirements i.e. MATERIAL_METAL = 1
    var/extras_required = list() //Example extra requirements i.e. /obj/item = 1

/datum/construction_template/Dispose()
    owner = null
    build_loc = null
    ..()

/datum/construction_template/proc/get_structure_image()
    return image(build_icon, build_icon_state)

/datum/construction_template/proc/add_crystal(var/mob/living/carbon/Xenomorph/M)
    if(!istype(M))
        return
    if(crystals_stored >= crystals_required)
        to_chat(M, SPAN_WARNING("\The [name] does not require plasma."))
        return
    to_chat(M, SPAN_NOTICE("You begin adding \the plasma to \the [name]."))
    if(!do_after(M, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
        return
    //double-check amount required
    if(crystals_stored >= crystals_required)
        to_chat(M, SPAN_WARNING("\The [name] has enough plasma."))
        return
    var/amount_to_use = min(M.plasma_stored, (crystals_required - crystals_stored))
    crystals_stored += amount_to_use
    M.plasma_stored -= amount_to_use
    to_chat(M, SPAN_WARNING("\The [name] requires [crystals_required - crystals_stored] more plasma."))
    check_completion()

// Xeno ressource collection
/*
/datum/construction_template/proc/add_crystal(var/mob/living/carbon/Xenomorph/M)
    if(!istype(M))
        return
    if(!M.crystal_stored)
        to_chat(M, SPAN_WARNING("You have no [MATERIAL_CRYSTAL] stored."))
        return
    if(crystals_stored >= crystals_required)
        to_chat(M, SPAN_WARNING("\The [name] does not require [MATERIAL_CRYSTAL]."))
        return
    to_chat(M, SPAN_NOTICE("You begin adding \the [MATERIAL_CRYSTAL] to \the [name]."))
    if(!do_after(M, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
        return
    //double-check amount required
    if(crystals_stored >= crystals_required)
        to_chat(M, SPAN_WARNING("\The [name] has enough [MATERIAL_CRYSTAL]."))
        return
    var/amount_to_use = min(M.crystal_stored, (crystals_required - crystals_stored))
    crystals_stored += amount_to_use
    M.crystal_stored -= amount_to_use
    to_chat(M, SPAN_WARNING("\The [name] requires [crystals_required - crystals_stored] more [MATERIAL_CRYSTAL]."))
    check_completion() */

/datum/construction_template/proc/add_material(var/mob/user, var/obj/item/I)
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
        extras_required[I.type] -= 1
        qdel(I)
    else
        to_chat(user, SPAN_WARNING("\The [name] does not require [I.name]."))
        return
    check_completion()

/datum/construction_template/proc/check_completion()
    if(crystals_stored < crystals_required)
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
