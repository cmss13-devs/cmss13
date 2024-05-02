/obj/structure/machinery/nuclearbomb/crash
	name = "\improper Nuclear Fission Explosive"
	desc = "This is nuclear bomb, need three disks to activate."
	crash_nuke = TRUE
	var/obj/item/disk/nuclear/red/r_auth
	var/obj/item/disk/nuclear/green/g_auth
	var/obj/item/disk/nuclear/blue/b_auth

/obj/structure/machinery/nuclearbomb/crash/Initialize(mapload, ...)
	GLOB.nuke_list += src
	. = ..()

/obj/structure/machinery/nuclearbomb/crash/attackby(obj/item/O, mob/user)
	if(!istype(O, /obj/item/disk/nuclear))
		return
	if(!user.drop_inv_item_to_loc(O, src))
		return
	switch(O.type)
		if(/obj/item/disk/nuclear/red)
			r_auth = O
		if(/obj/item/disk/nuclear/green)
			g_auth = O
		if(/obj/item/disk/nuclear/blue)
			b_auth = O
	if(r_auth && g_auth && b_auth)
		has_auth = TRUE
	..()

/obj/structure/machinery/nuclearbomb/crash/disable()
	timing = FALSE
	GLOB.bomb_set = FALSE
	explosion_time = null
	announce_to_players()

/obj/structure/machinery/nuclearbomb/crash/Destroy()
	GLOB.nuke_list -= src
	return ..()
