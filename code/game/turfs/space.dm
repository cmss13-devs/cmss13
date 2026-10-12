/turf/open/space
	icon = 'icons/turf/floors/space.dmi'
	name = "\proper space"
	icon_state = "0"
	can_bloody = FALSE
	layer = UNDER_TURF_LAYER
	supports_surgery = FALSE
	minimap_color = MINIMAP_BLACK
	is_weedable = NOT_WEEDABLE

/turf/open/space/basic/New() //Do not convert to Initialize
	//This is used to optimize the map loader
	return

// override for space turfs, since they should never hide anything
/turf/open/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(FALSE)

/turf/open/space/Initialize(mapload, ...)
	. = ..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

	if(is_mainship_level(z))
		if(SShijack.in_ftl)
			SShijack.set_ftl_turf(src)
		else if(SShijack.crashed)
			SShijack.set_ftl_turf_open(src)

/turf/open/space/attack_hand(mob/user)
	if ((user.is_mob_restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/open/space/attackby(obj/item/C, mob/user)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, SPAN_NOTICE("Constructing support lattice ..."))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_DANGER("The plating is going to need some support."))
	return

/turf/open/space/Entered(atom/movable/A, atom/OldLoc)
	..()
	if(isnewplayer(A))
		return
	inertial_drift(A)
