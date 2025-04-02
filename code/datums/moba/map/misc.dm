GLOBAL_LIST_EMPTY(uninitialized_moba_reuse_object_spawners)

/// Dict of "map id" : list(spawners)
GLOBAL_LIST_EMPTY(moba_reuse_object_spawners)

/obj/effect/landmark/moba_tunnel_spawner

/obj/effect/landmark/moba_base
	var/right_side = FALSE
	var/map_id = 0

/obj/effect/landmark/moba_minion_spawner
	var/top = FALSE
	var/left = FALSE

/obj/effect/landmark/moba_hive_core
	var/right_side = FALSE

/obj/effect/landmark/moba_hive_core_turret

/obj/effect/landmark/moba_left_boss_spawn

/obj/effect/landmark/moba_right_boss_spawn

/obj/effect/moba_reuse_object_spawner
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE
	unacidable = TRUE
	var/path_to_spawn

/obj/effect/moba_reuse_object_spawner/Initialize(mapload, path_to_spawn)
	. = ..()
	src.path_to_spawn = path_to_spawn
	GLOB.uninitialized_moba_reuse_object_spawners += src

/obj/effect/moba_unslashinator

/obj/effect/moba_unslashinator/Initialize(mapload)
	. = ..()
	if(mapload)
		return INITIALIZE_HINT_LATELOAD
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, LateInitialize)), 2 SECONDS) // gross hack to make sure everything else on the turf is loaded first

/obj/effect/moba_unslashinator/LateInitialize()
	. = ..()
	for(var/obj/structure/thing in loc.contents)
		thing.unslashable = TRUE
		thing.unacidable = TRUE
		thing.explo_proof = TRUE
	qdel(src)

/obj/effect/moba_instakiller
	invisibility = INVISIBILITY_MAXIMUM
	var/bad_hivenumber = XENO_HIVE_MOBA_RIGHT

/obj/effect/moba_instakiller/Initialize()
	. = ..()
	var/turf/our_turf = get_turf(src)
	RegisterSignal(our_turf, COMSIG_TURF_ENTERED, PROC_REF(on_enter))

/obj/effect/moba_instakiller/proc/on_enter(datum/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(isxeno(mover))
		var/mob/living/carbon/xenomorph/xeno = mover
		if(xeno.hivenumber == bad_hivenumber)
			xeno.gib(create_cause_data("enemy team fountain gibbing"))

/obj/effect/moba_instakiller/right
	bad_hivenumber = XENO_HIVE_MOBA_LEFT

/obj/structure/flora/grass/tallgrass/jungle/moba
	cut_level = 1 // Magic number because we don't have the defines in this file
	desc = "A clump of vibrant jungle grasses. They look like they would hide someone pretty well."
	var/list/connected_bushes
	var/static/list/client_image_dict = list()

/obj/structure/flora/grass/tallgrass/jungle/moba/Initialize()
	. = ..()
	var/turf/our_turf = get_turf(src)
	RegisterSignal(our_turf, COMSIG_TURF_ENTERED, PROC_REF(on_enter))

/obj/structure/flora/grass/tallgrass/jungle/moba/proc/on_enter(datum/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(isliving(mover))
		var/mob/living/living_mover = mover
		living_mover.invisibility = INVISIBILITY_LEVEL_TWO // zonenote check if this works against everything
		living_mover.see_invisible = SEE_INVISIBLE_LEVEL_TWO
		ADD_TRAIT(mover, TRAIT_CLOAKED, "bush")
		RegisterSignal(mover, COMSIG_MOVABLE_MOVED, PROC_REF(on_move), TRUE)

		if(!length(connected_bushes))
			var/list/return_list = list()
			get_connected_bushes(return_list)
			for(var/obj/structure/flora/grass/tallgrass/jungle/moba/bush as anything in return_list)
				bush.connected_bushes = return_list

		if(living_mover.client)
			var/client_ref_str = REF(living_mover.client)
			for(var/obj/structure/flora/grass/tallgrass/jungle/moba/bush as anything in connected_bushes)
				var/image/low_alpha = new(bush)
				low_alpha.loc = bush
				low_alpha.override = TRUE
				low_alpha.alpha = 60
				living_mover.client.images += low_alpha
				if(!client_image_dict[client_ref_str])
					client_image_dict[client_ref_str] = list()
				client_image_dict[client_ref_str] += low_alpha

			RegisterSignal(living_mover.client, COMSIG_PARENT_QDELETING, PROC_REF(on_client_delete), TRUE)

/obj/structure/flora/grass/tallgrass/jungle/moba/attack_alien(mob/living/carbon/xenomorph/M) // We do this so that players can still be easily attacked in bushes
	var/mob/living/located_living = locate() in get_turf(src)
	if(located_living)
		//to_chat(M, SPAN_XENOWARNING("You swing through [src], hitting [located_living]!")) // don't really need this line since there's an attack message already
		located_living.attack_alien(M)
		return XENO_ATTACK_ACTION
	else
		to_chat(M, SPAN_XENOWARNING("You swing through [src], hitting nothing but foliage."))
		if(HAS_TRAIT_FROM(M, TRAIT_CLOAKED, "bush"))
			return XENO_NO_DELAY_ACTION
		else
			return XENO_ATTACK_ACTION // Slash-checking bushes from outside inflicts a penalty

// Zonenote: The above doesn't work for shit like tailstab because of how click code works. Maybe come back to eventually.
// /mob/living/carbon/xenomorph/click() btw

/obj/structure/flora/grass/tallgrass/jungle/moba/proc/on_client_delete(client/deleting, force)
	SIGNAL_HANDLER

	client_image_dict -= REF(deleting)
	UnregisterSignal(deleting, COMSIG_PARENT_QDELETING)

/obj/structure/flora/grass/tallgrass/jungle/moba/proc/on_move(mob/living/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(locate(/obj/structure/flora/grass/tallgrass/jungle/moba) in source.loc)
		return

	source.invisibility = 0 // We assume that nobody can actually be invisible, this might need to be reworked though
	source.see_invisible = initial(source.see_invisible) // surely won't cause problems
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	REMOVE_TRAIT(source, TRAIT_CLOAKED, "bush")
	if(source.client)
		var/client_text_ref = REF(source.client)
		for(var/image/low_alpha as anything in client_image_dict[client_text_ref])
			source.client.images -= low_alpha
			qdel(low_alpha)
		client_image_dict -= client_text_ref
		UnregisterSignal(source.client, COMSIG_PARENT_QDELETING)

/obj/structure/flora/grass/tallgrass/jungle/moba/proc/get_connected_bushes(list/return_list)
	for(var/obj/structure/flora/grass/tallgrass/jungle/moba/grass in range(1, get_turf(src)))
		if(grass in return_list)
			continue

		return_list += grass
		grass.get_connected_bushes(return_list)

// used for bosses
/obj/effect/moba_camptarget_trigger
	invisibility = INVISIBILITY_MAXIMUM
	icon = 'icons/landmarks.dmi'
	icon_state = "x"

/obj/effect/moba_camptarget_trigger/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(get_turf(src), COMSIG_TURF_ENTERED, PROC_REF(on_enter))

/obj/effect/moba_camptarget_trigger/proc/on_enter(datum/source, atom/entering_atom)
	SIGNAL_HANDLER

	if(!isxeno(entering_atom) || HAS_TRAIT(entering_atom, TRAIT_MOBA_CAMP_TARGET))
		return

	var/mob/living/carbon/xenomorph/xeno = entering_atom
	ADD_TRAIT(xeno, TRAIT_MOBA_CAMP_TARGET, TRAIT_SOURCE_INHERENT)
	RegisterSignal(xeno, COMSIG_MOVABLE_MOVED, PROC_REF(on_xeno_move))

/obj/effect/moba_camptarget_trigger/proc/on_xeno_move(mob/living/carbon/xenomorph/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	var/turf/xeno_turf = get_turf(source)
	if(locate(/obj/effect/moba_camptarget_trigger) in xeno_turf)
		return

	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	REMOVE_TRAIT(source, TRAIT_MOBA_CAMP_TARGET, TRAIT_SOURCE_INHERENT)
