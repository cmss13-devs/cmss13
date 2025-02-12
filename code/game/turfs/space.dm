





/turf/open/space
	icon = 'icons/turf/floors/space.dmi'
	name = "\proper space"
	icon_state = "0"
	can_bloody = FALSE
	layer = UNDER_TURF_LAYER
	supports_surgery = FALSE

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
	if(!istype(src, /turf/open/space/transit))
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

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
			to_chat(user, SPAN_NOTICE(" Constructing support lattice ..."))
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


// Ported from unstable r355

/turf/open/space/Entered(atom/movable/A)
	..()
	if(isnewplayer(A))
		return

	if ((!(A) || src != A.loc)) return

	inertial_drift(A)

	if(SSticker.mode)


		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(ticker.mode.name == "nuclear emergency") return
		if(A.z > 6)
			return
		if(A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))

			if(istype(A, /obj/item/disk/nuclear)) // Don't let nuke disks travel Z levels  ... And moving this shit down here so it only fires when they're actually trying to change z-level.
				qdel(A) //The disk's Dispose() proc ensures a new one is created
				return

			var/list/disk_search = A.search_contents_for(/obj/item/disk/nuclear)
			if(length(disk_search))
				if(istype(A, /mob/living))
					var/mob/living/MM = A
					if(MM.client && !MM.stat)
						to_chat(MM, SPAN_WARNING("Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."))
						if(MM.x <= TRANSITIONEDGE)
							MM.inertia_dir = 4
						else if(MM.x >= world.maxx -TRANSITIONEDGE)
							MM.inertia_dir = 8
						else if(MM.y <= TRANSITIONEDGE)
							MM.inertia_dir = 1
						else if(MM.y >= world.maxy -TRANSITIONEDGE)
							MM.inertia_dir = 2
					else
						for(var/obj/item/disk/nuclear/N in disk_search)
							disk_search -= N
							qdel(N)//Make the disk respawn it is on a clientless mob or corpse
				else
					for(var/obj/item/disk/nuclear/N in disk_search)
						disk_search -= N
						qdel(N)//Make the disk respawn if it is floating on its own
				return

			var/move_to_z = src.z
			var/safety = 1

			while(move_to_z == src.z)
				move_to_z = pick(SSmapping.levels_by_trait(ZTRAIT_GROUND))
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			A.z = move_to_z

			if(src.x <= TRANSITIONEDGE)
				A.x = world.maxx - TRANSITIONEDGE - 2
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
				A.x = TRANSITIONEDGE + 1
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (src.y <= TRANSITIONEDGE)
				A.y = world.maxy - TRANSITIONEDGE -2
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
				A.y = TRANSITIONEDGE + 1
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)




			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
