/proc/togglebuildmode(mob/M as mob in player_list)
    set name = "Toggle Build Mode"
    set category = "Special Verbs"
    if(M.client)
        if(M.client.buildmode)
            log_admin("[key_name(usr)] has left build mode.")
            qdel(M.client.buildmode.master)

            M.client.show_popup_menus = TRUE
        else
            log_admin("[key_name(usr)] has entered build mode.")
            M.client.show_popup_menus = FALSE

            new /obj/effect/buildholder(M, M.client)

/obj/effect/bmode//Cleaning up the tree a bit
    density = 1
    anchored = 1
    layer = ABOVE_HUD_LAYER
    dir = NORTH
    icon = 'icons/old_stuff/buildmode.dmi'
    var/obj/effect/buildholder/master
    var/client/cl

/obj/effect/bmode/Initialize(loc, obj/effect/buildholder/H, client/C)
    . = ..(loc)
    if(!istype(H))
        qdel(src)

    cl = C

    src.master = H
    C.screen += src

/obj/effect/bmode/Destroy()
    master = null
    cl.screen -= src

    loc = null
    cl = null
    

/obj/effect/bmode/builddir // Deprecated
    icon_state = "build"
    screen_loc = "NORTH,WEST"

/obj/effect/bmode/builddir/clicked()
    master.buildmode.change_dir()
    dir = master.dir
    return TRUE

/obj/effect/bmode/buildhelp
    icon = 'icons/old_stuff/buildmode.dmi'
    icon_state = "buildhelp"
    screen_loc = "NORTH,WEST"

/obj/effect/bmode/buildhelp/clicked()
    master.buildmode.send_help(usr)
    return TRUE

/obj/effect/bmode/buildquit
    icon_state = "buildquit"
    screen_loc = "NORTH,WEST+2"

/obj/effect/bmode/buildquit/clicked()
    togglebuildmode(master.cl.mob)
    return TRUE

/obj/effect/buildholder
    density = 0
    anchored = 1
    layer = ABOVE_HUD_LAYER
    dir = NORTH
    icon = 'icons/old_stuff/buildmode.dmi'

    var/current_mode = 1

    var/datum/buildmode/buildmode = null

    var/client/cl = null
    var/obj/effect/bmode/buildhelp/bm_help = null
    var/obj/effect/bmode/buildmode/bm_build = null
    var/obj/effect/bmode/buildquit/bm_quit = null
    var/atom/movable/throw_atom = null

/obj/effect/buildholder/Initialize(loc, client/C)
    . = ..(loc)

    cl = C

    bm_help = new /obj/effect/bmode/buildhelp(src, src, cl)
    bm_build = new /obj/effect/bmode/buildmode(src, src, cl)
    bm_quit = new /obj/effect/bmode/buildquit(src, src, cl)

    var/type = build_modes[1]

    var/datum/buildmode/BM = new type(src) // get the first element
    cl.buildmode = BM
    buildmode = BM

/obj/effect/buildholder/Destroy()
    . = ..()

    qdel(bm_help)
    qdel(bm_help)
    qdel(bm_quit)

    bm_help = null
    bm_build = null
    bm_quit = null

    cl.buildmode = null
    buildmode.master = null
    buildmode = null
    qdel(buildmode)


/obj/effect/buildholder/proc/next_mode()

    cl.buildmode = null
    buildmode.master = null
    buildmode = null
    qdel(buildmode)

    if(build_modes.len > current_mode)
        current_mode++
    else
        current_mode = 1

    var/type = build_modes[current_mode]

    var/datum/buildmode/BM = new type(src)
    cl.buildmode = BM
    buildmode = BM

/obj/effect/bmode/buildmode
    icon_state = "buildmode2"
    screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/buildmode/proc/switch_buildmode()
    master.next_mode()
    icon_state = master.buildmode.icon_state

/obj/effect/bmode/buildmode/clicked(var/mob/M, var/list/mods)

    if(mods["left"])
        switch_buildmode()
    else if(mods["right"])
        master.buildmode.icon_clicked(M, mods)

    return TRUE

/proc/build_click(var/mob/user, var/datum/buildmode/buildmode, var/list/mods, var/obj/object)
    buildmode.object_click(user, mods, object)

