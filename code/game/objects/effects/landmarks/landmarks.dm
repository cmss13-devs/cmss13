/obj/effect/landmark
	name = "landmark"
	icon = 'icons/landmarks.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = TRUE

/obj/effect/landmark/New()
	..()
	tag = "landmark*[name]"
	invisibility = 101

	landmarks_list += src

	switch(name)			//some of these are probably obsolete
		if("start")
			newplayer_start += loc
			qdel(src)

		if("latewhiskey")
			latewhiskey += loc
			qdel(src)

		if("SupplyElevator")
			SupplyElevator = loc
			qdel(src)

		if("VehicleElevator")
			VehicleElevator = loc
			qdel(src)
		if("HangarUpperElevator")
			HangarUpperElevator = loc
			qdel(src)

		if("HangarLowerElevator")
			HangarLowerElevator = loc
			qdel(src)

		if("tdome1")
			tdome1	+= loc
			qdel(src)

		if("tdome2")
			tdome2 += loc
			qdel(src)

		if("tdomeadmin")
			tdomeadmin	+= loc
			qdel(src)

		if("tdomeobserve")
			tdomeobserve += loc
			qdel(src)

		if("xeno_spawn")
			xeno_spawn += loc
			qdel(src)

		if("xeno_hive_spawn")
			xeno_hive_spawn += loc
			qdel(src)

		if("surv_spawn")
			surv_spawn += loc
			qdel(src)

		if("pred_spawn")
			pred_spawn += loc
			qdel(src)

		if("pred_elder_spawn")
			pred_elder_spawn += loc
			qdel(src)

		if("yautja_teleport_loc")
			if(z == MAIN_SHIP_Z_LEVEL)
				yautja_almayer_loc += loc
				if(loc && istype(loc, /turf))
					var/turf/location = loc
					yautja_almayer_desc += loc.name + location.loc_to_string()
			else
				yautja_teleport_loc += loc
				if(loc && istype(loc, /turf))
					var/turf/location = loc
					yautja_teleport_desc += loc.name + location.loc_to_string()
			qdel(src)



	return 1

/obj/effect/landmark/Destroy()
	landmarks_list -= src
	. = ..()


/obj/effect/landmark/queen_spawn
	name = "queen spawn"
	icon_state = "queen_spawn"

/obj/effect/landmark/queen_spawn/Initialize(mapload, ...)
	. = ..()
	
	queen_spawn_list += loc
	return INITIALIZE_HINT_QDEL


/obj/effect/landmark/start
	name = "start"
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/start/New()
	..()

	if(name != "start")
		tag = "start*[name]"
		invisibility = 101

/obj/effect/landmark/start/marine
	name = JOB_SQUAD_MARINE
	icon_state = "marine_spawn"

/obj/effect/landmark/start/marine/engineer
	name = JOB_SQUAD_ENGI
	icon_state = "engi_spawn"

/obj/effect/landmark/start/marine/medic
	name = JOB_SQUAD_MEDIC
	icon_state = "medic_spawn"

/obj/effect/landmark/start/marine/spec
	name = JOB_SQUAD_SPECIALIST
	icon_state = "spec_spawn"

/obj/effect/landmark/start/marine/smartgunner
	name = JOB_SQUAD_SMARTGUN
	icon_state = "smartgunner_spawn"

/obj/effect/landmark/start/marine/leader
	name = JOB_SQUAD_LEADER
	icon_state = "leader_spawn"

/obj/effect/landmark/start/AISloc
	name = "AI"

/obj/effect/landmark/start/whiskey
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle"


/obj/effect/landmark/late_join
	name = "late join"
	icon_state = "x2"

/obj/effect/landmark/late_join/Initialize(mapload, ...)
	. = ..()

	latejoin += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/map_tag
	name = "mapping tag"

/obj/effect/landmark/map_tag/New()
	map_tag = name
	qdel(src)
	return
