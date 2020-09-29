#define BUILDMODE_NONE 0
#define BUILDMODE_BUILD 1
#define BUILDMODE_VAREDIT 2
#define BUILDMODE_THROW 3
#define BUILDMODE_BUILD_NOCOPY 4

/datum/buildmode
    var/mode = BUILDMODE_NONE
    var/icon_state = "buildmode1"
    var/dir = NORTH

    var/obj/effect/buildholder/master

/datum/buildmode/New(obj/effect/buildholder/master)
    . = ..()

    if(!istype(master))
        qdel(src)

    src.master = master

/datum/buildmode/proc/change_dir() // Deprecated
    switch(dir)
        if(NORTH)
            dir = EAST
        if(EAST)
            dir = SOUTH
        if(SOUTH)
            dir = WEST
        if(WEST)
            dir = NORTH

/datum/buildmode/proc/send_help(usr)
    return

/datum/buildmode/proc/icon_clicked(mob/M, list/mods)
    return

/datum/buildmode/proc/object_click(mob/M, list/mods, obj/object)
    return

/datum/buildmode/build
    mode = BUILDMODE_BUILD
    icon_state = "buildmode2"

    var/atom/selected_object = /obj/structure/closet/
    var/list/copied_vars = list()

    var/list/ignore_vars = list("old_turf", "loc", "ckey", "key", "vars", "verbs", \
        "locs", "contents", "vis_locs", "vis_contents", "client", "linked_pylons", \
        "x", "y", "z", "disposed") 
    // Might be better to move to a whitelist system instead. If there are too many runtimes/issues, 
    // turn this into a whitelist system and whitelist vars like icon_state, overlays and ids

    var/list/ignore_types = list(/atom)

    var/list/must_include = list("icon_state", "dir")

/datum/buildmode/build/send_help()
    . = ..()

    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))
    to_chat(usr, SPAN_NOTICE(" Right Mouse Button on buildmode button = Set object type"))
    to_chat(usr, SPAN_NOTICE(" Middle Mouse Button on turf/obj        = Set object type"))
    to_chat(usr, SPAN_NOTICE(" Left Mouse Button on turf/obj          = Place objects"))
    to_chat(usr, SPAN_NOTICE(" Right Mouse Button                     = Delete objects"))
    to_chat(usr, SPAN_NOTICE(""))
    to_chat(usr, SPAN_NOTICE(" Shift + Left Mouse Button on turf/obj  = Place uncopied objects"))
    to_chat(usr, SPAN_NOTICE(" Shift + Right Mouse Button             = Delete all objects on tile"))
    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))

/datum/buildmode/build/icon_clicked(var/mob/M, var/list/mods)
    . = ..()
    selected_object = text2path(input(usr,"Enter typepath:" ,"Typepath", "/obj/structure/closet"))
    if(!ispath(selected_object))
        selected_object = /obj/structure/closet
        to_chat(M, SPAN_WARNING("That path is does not exist."))
    copied_vars = list()

/datum/buildmode/build/object_click(mob/M, list/mods, obj/object)
    . = ..()
    if(mods["left"])
        if(ispath(selected_object,/turf))
            var/turf/T = get_turf(object)
            if(T)
                var/turf/newTurf = T.ChangeTurf(selected_object, TRUE)
                
                if(!newTurf)
                    newTurf = T
                
                if(!mods["shift"])
                    apply_copied_vars_shallow(T)
                
        else
            var/atom/A = new selected_object(get_turf(object))
            if(!istype(A))
                return

            if(!mods["shift"])
                addtimer(CALLBACK(src, .proc/apply_copied_vars_shallow, A), 1)

            if(isobj(A))
                var/obj/O = A
                O.update_icon()

    else if(mods["middle"])
        selected_object = text2path("[object.type]")
        copied_vars = filter_vars(object)

        to_chat(usr, "Selected: [object.type]")
    else if(mods["right"])
        if(mods["shift"])
            for(var/atom/movable/AM in range(0, object))
                if(AM == object || isobserver(AM)) continue
                qdel(AM)
            
            var/turf/T = get_turf(object)
            if(T.contents)
                for(var/atom/movable/AM in T.contents)
                    if(isobserver(AM)) continue
                    qdel(AM)
            
            qdel(T)
        
        qdel(object)

/datum/buildmode/build/proc/filter_vars(var/atom/A)
    var/list/filtered_vars = list()

    for(var/variable in A.vars)
        if(!(variable in must_include))
            if(variable in ignore_vars) continue
            if(A.vars[variable] == initial(A.vars[variable])) continue

            for(var/type in ignore_types)
                if(istype(A.vars[variable], type)) continue

        filtered_vars += list("[variable]" = A.vars[variable])

    return filtered_vars

/datum/buildmode/build/proc/apply_copied_vars_shallow(var/atom/A)
    if(ismob(A)) // Mobs shouldn't be shallow copied for obvious reasons
        return

    for(var/variable in copied_vars)
        var/temp_value = copied_vars[variable]

        if(isdatum(temp_value)) // Don't bother with copying datums
            continue

        if(islist(temp_value))
            temp_value = copyListList(temp_value)

        A.vars[variable] = temp_value


/*
/datum/buildmode/build/proc/recursive_list_copy(var/list/L, var/list/already_copied = list())
    if(!istype(L))
        return

    if(L in already_copied)
        return L

    already_copied += L

    var/list/new_list = list()
    for(var/variable in L)
        if(islist(variable))
            new_list += list(recursive_list_copy(variable, already_copied))
        else if (istext(variable))
            if(islist(L[variable]))
                new_list += list("[variable]" = recursive_list_copy(L[variable], already_copied))
            else
                new_list += list("[variable]" = L[variable])

    return new_list
*/

/datum/buildmode/varedit
    mode = BUILDMODE_VAREDIT
    icon_state = "buildmode3"

    var/selected_key = "name"
    var/selected_value = "object"

/datum/buildmode/varedit/send_help()
    . = ..()
    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))
    to_chat(usr, SPAN_NOTICE(" Right Mouse Button on buildmode button = Select var(type) & value"))
    to_chat(usr, SPAN_NOTICE(" Left Mouse Button on turf/obj/mob      = Set var(type) & value"))
    to_chat(usr, SPAN_NOTICE(" Right Mouse Button on turf/obj/mob     = Reset var's value"))
    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))
    
/datum/buildmode/varedit/icon_clicked(mob/M, list/mods)
    . = ..()
    
    var/list/locked = list("vars", "key", "ckey", "client", "icon")

    selected_key = input(usr,"Enter variable name:" ,"Name", "name")
    if(selected_key in locked && !check_rights(R_DEBUG,0))
        return TRUE
    var/type = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference")

    if(!type) 
        return TRUE
    
    switch(type)
        if("text")
            selected_value = input(usr,"Enter variable value:" ,"Value", "value") as text
        if("number")
            selected_value = input(usr,"Enter variable value:" ,"Value", 0) as num
        if("mob-reference")
            selected_value = input(usr,"Enter variable value:" ,"Value") as mob in mob_list
        if("obj-reference")
            selected_value = input(usr,"Enter variable value:" ,"Value") as obj in object_list
        if("turf-reference")
            selected_value = input(usr,"Enter variable value:" ,"Value") as turf in turfs

/datum/buildmode/varedit/object_click(mob/M, list/mods, obj/object)
    . = ..()

    if(mods["left"]) //I cant believe this shit actually compiles.
        if(object.vars.Find(selected_key))
            log_admin("[key_name(usr)] modified [object.name]'s [selected_key] to [selected_value]")
            object.vars[selected_key] = selected_value
        else
            to_chat(usr, SPAN_DANGER("[initial(object.name)] does not have a var called '[selected_key]'"))

/datum/buildmode/throw
    mode = BUILDMODE_THROW
    icon_state = "buildmode4"

    var/atom/movable/throw_atom

/datum/buildmode/throw/send_help()
    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))
    to_chat(usr, SPAN_NOTICE(" Left Mouse Button on turf/obj/mob      = Select"))
    to_chat(usr, SPAN_NOTICE(" Right Mouse Button on turf/obj/mob     = Throw"))
    to_chat(usr, SPAN_NOTICE(" ***********************************************************"))

/datum/buildmode/throw/object_click(mob/M, list/mods, obj/object)
    . = ..()
    if(mods["left"])
        if(istype(object, /atom/movable))
            throw_atom = object
    if(mods["right"])
        if(throw_atom)
            throw_atom.throw_atom(object, 10, SPEED_FAST)

/datum/buildmode/build/nocopy
    mode = BUILDMODE_BUILD_NOCOPY
    icon_state = "buildmode1"


/datum/buildmode/build/nocopy/send_help()
    . = ..()
    to_chat(usr, SPAN_NOTICE("THIS WILL NOT SHALLOW COPY MOST VARIABLES ON THE OBJECT"))

/datum/buildmode/build/nocopy/object_click(mob/M, list/mods, obj/object)
    copied_vars = list()
    . = ..(M, mods, object)

/datum/buildmode/build/nocopy/icon_clicked(var/mob/M, var/list/mods)
    . = ..(M, mods)
    copied_vars = list() // Will prevent any vars from being copied over

var/list/build_modes = list(/datum/buildmode/build/, /datum/buildmode/varedit/, /datum/buildmode/throw/, /datum/buildmode/build/nocopy)
