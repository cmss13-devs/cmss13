/obj/structure/compound_silo
	name = "compound silo"
	desc = "A large silo containing a compound used to speed up dropship engine cooldowns."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank_old"
	density = TRUE
	anchored = TRUE
	health = 250

	var/compound_type = COMPOUND_PHI

	var/obj/item/nozzle/attached_to
	var/atom/tether_holder
	var/tether_range = 12

/obj/structure/compound_silo/omega
	compound_type = COMPOUND_OMEGA

/obj/structure/compound_silo/tau
	compound_type = COMPOUND_TAU

/obj/structure/compound_silo/epsilon
	compound_type = COMPOUND_EPSILON

/obj/structure/compound_silo/Initialize()
	. = ..()

	name = "[compound_type] silo"
	attached_to = new /obj/item/nozzle(src, compound_type)
	RegisterSignal(attached_to, COMSIG_PARENT_PREQDELETED, .proc/override_delete)

/obj/structure/compound_silo/proc/override_delete()
	SIGNAL_HANDLER
	recall_nozzle()
	return COMPONENT_ABORT_QDEL

/obj/structure/compound_silo/forceMove(atom/dest)
	recall_nozzle()
	return ..()

/obj/structure/compound_silo/proc/recall_nozzle()
	if(ismob(attached_to.loc))
		var/mob/M = attached_to.loc
		M.drop_held_item(attached_to)

	attached_to.forceMove(src)

/obj/structure/compound_silo/attack_hand(mob/user)
	. = ..()

	if(!attached_to || attached_to.loc != src)
		return

	if(!ishuman(user))
		return

	playsound(user.loc, 'sound/handling/multitool_pickup.ogg', vol = 15, vary = TRUE)
	user.put_in_active_hand(attached_to)

/obj/structure/compound_silo/attackby(obj/item/W, mob/user)
	if(W == attached_to)
		playsound(user.loc, 'sound/handling/multitool_drop.ogg', vol = 15, vary = TRUE)
		recall_nozzle()
		return
	return ..()


/obj/item/nozzle
	name = "nozzle"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "rcd"

	w_class = SIZE_LARGE

	var/obj/structure/compound_silo/attached_to
	var/datum/effects/tethering/tether_effect

	var/zlevel_transfer = FALSE
	var/zlevel_transfer_timer = TIMER_ID_NULL
	var/zlevel_transfer_timeout = 5 SECONDS

	var/compound_type

/obj/item/nozzle/Initialize(mapload, var/set_compound_type)
	. = ..()
	compound_type = set_compound_type
	if(istype(loc, /obj/structure/compound_silo))
		attach_to(loc)

/obj/item/nozzle/Destroy()
	remove_attached()
	return ..()

/obj/item/nozzle/proc/attach_to(var/obj/structure/compound_silo/to_attach)
	if(!istype(to_attach))
		return

	remove_attached()

	attached_to = to_attach

/obj/item/nozzle/proc/remove_attached()
	attached_to = null
	reset_tether()

/obj/item/nozzle/proc/reset_tether()
	SIGNAL_HANDLER
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null
	if(!do_zlevel_check())
		on_beam_removed()

/obj/item/nozzle/attack_hand(mob/user)
	if(attached_to && get_dist(user, attached_to) > attached_to.tether_range)
		return FALSE
	return ..()


/obj/item/nozzle/proc/on_beam_removed()
	if(!attached_to)
		return

	if(loc == attached_to)
		return

	if(get_dist(attached_to, src) > attached_to.tether_range)
		attached_to.recall_nozzle()

	var/atom/tether_to = src

	if(loc != get_turf(src))
		tether_to = loc
		if(tether_to.loc != get_turf(tether_to))
			attached_to.recall_nozzle()
			return

	var/atom/tether_from = attached_to

	if(attached_to.tether_holder)
		tether_from = attached_to.tether_holder

	if(tether_from == tether_to)
		return

	var/list/tether_effects = apply_tether(tether_from, tether_to, range = attached_to.tether_range, icon = "chain", always_face = FALSE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, .proc/reset_tether)

/obj/item/nozzle/on_enter_storage(obj/item/storage/S)
	. = ..()
	if(attached_to)
		attached_to.recall_nozzle()

/obj/item/nozzle/forceMove(atom/dest)
	. = ..()
	if(.)
		reset_tether()

/obj/item/nozzle/proc/do_zlevel_check()
	if(!attached_to || !loc.z || !attached_to.z)
		return FALSE

	if(zlevel_transfer)
		if(loc.z == attached_to.z)
			zlevel_transfer = FALSE
			if(zlevel_transfer_timer)
				deltimer(zlevel_transfer_timer)
			UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
			return FALSE
		return TRUE

	if(attached_to && loc.z != attached_to.z)
		zlevel_transfer = TRUE
		zlevel_transfer_timer = addtimer(CALLBACK(src, .proc/try_doing_tether), zlevel_transfer_timeout, TIMER_UNIQUE|TIMER_STOPPABLE)
		RegisterSignal(attached_to, COMSIG_MOVABLE_MOVED, .proc/silo_move_handler)
		return TRUE
	return FALSE

/obj/item/nozzle/proc/silo_move_handler(var/datum/source)
	SIGNAL_HANDLER
	zlevel_transfer = FALSE
	if(zlevel_transfer_timer)
		deltimer(zlevel_transfer_timer)
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

/obj/item/nozzle/proc/try_doing_tether()
	zlevel_transfer_timer = TIMER_ID_NULL
	zlevel_transfer = FALSE
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()
