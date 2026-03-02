// Fulton baloon deployment devices, used to gather and send crates, dead things, and other objective-based items into space for collection.

/// A list of fultons currently airborne.
GLOBAL_LIST_EMPTY(deployed_fultons)

/obj/item/stack/fulton
	name = "fulton recovery device"
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	icon_state = "fulton"
	amount = 20
	max_amount = 20
	desc = "A system used by the USCM for retrieving objects of interest on the ground from an AUD-25 dropship. Can be used to extract unrevivable corpses, or crates, typically lasting around 3 minutes in the air."
	throwforce = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 5
	matter = list("metal" = 50)
	flags_equip_slot = SLOT_WAIST
	item_state = "fulton"
	stack_id = "fulton"
	singular_name = "use"
	var/atom/movable/attached_atom = null
	var/turf/original_location = null
	var/attachable_atoms = list(/obj/structure/closet/crate)
	var/datum/turf_reservation/reservation
	var/faction

/obj/item/stack/fulton/New(loc, amount, atom_to_attach)
	..()
	if(amount)
		src.amount = amount
	attached_atom = atom_to_attach
	update_icon()

/obj/item/stack/fulton/Destroy()
	if(attached_atom)
		attached_atom = null
	if(original_location)
		original_location = null
	GLOB.deployed_fultons -= src
	. = ..()

/obj/item/stack/fulton/update_icon()
	..()
	if (attached_atom)
		if(istype(attached_atom, /obj/structure/closet/crate))
			icon_state = "fulton_crate"
		else
			icon_state = "fulton_attached"
	else
		icon_state = "fulton"

/obj/item/stack/fulton/afterattack(atom/target, mob/user, flag)
	if(!flag)
		return FALSE
	if(isobj(target) || isliving(target))
		attach(target, user)
		return

/obj/item/stack/fulton/attack(mob/M as mob, mob/user as mob)
	return ATTACKBY_HINT_UPDATE_NEXT_MOVE

/obj/item/stack/fulton/attack_hand(mob/user as mob)
	if (attached_atom)
		to_chat(user, SPAN_WARNING("It's firmly secured to [attached_atom], and there's no way to remove it now!"))
		return
	else
		..()

/obj/item/stack/fulton/proc/attach(atom/target_atom, mob/user)
	if(!isturf(target_atom.loc) || target_atom == user)
		return

	if(get_dist(target_atom,user) > 1)
		to_chat(user, SPAN_WARNING("You can't attach [src] to something that far away."))
		return

	if(!is_ground_level(target_atom.z))
		to_chat(user, SPAN_WARNING("You can't attach [src] to something here."))
		return

	var/area/A = get_area(target_atom)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, SPAN_WARNING("You can't attach [src] to something when underground!"))
		return

	var/can_attach = FALSE

	if(isliving(target_atom))
		if(ishuman(target_atom))
			var/mob/living/carbon/human/H = target_atom
			if(isyautja(H) && H.stat == DEAD)
				can_attach = TRUE
			else if((H.stat != DEAD || H.check_tod() && H.is_revivable()))
				to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom], they still have a chance!"))
				return
			else
				can_attach = TRUE
		else if(isxeno(target_atom))
			var/mob/living/carbon/xenomorph/X = target_atom
			if(X.stat != DEAD)
				to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom], kill it first!"))
				return
			can_attach = TRUE
		else
			can_attach = TRUE

	if(isobj(target_atom))
		var/obj/target_obj = target_atom
		for(var/attachables in attachable_atoms)
			if(istype(target_obj, attachables))
				can_attach = TRUE
				break

	if(can_attach)
		user.visible_message(SPAN_WARNING("[user] begins attaching [src] onto [target_atom]."),
					SPAN_WARNING("You begin to attach [src] onto [target_atom]."))
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_INTEL), INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(!amount || get_dist(target_atom,user) > 1)
				return
			for(var/obj/item/stack/fulton/F in get_turf(target_atom))
				return
			var/obj/item/stack/fulton/F = new /obj/item/stack/fulton(get_turf(target_atom), 1, target_atom)
			transfer_fingerprints_to(F)
			src.add_fingerprint(user)
			F.add_fingerprint(user)
			user.count_niche_stat(STATISTICS_NICHE_FULTON)
			use(1)
			F.faction = user.faction
			F.deploy_fulton()
	else
		to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom]."))

/obj/item/stack/fulton/proc/deploy_fulton()
	if(!attached_atom)
		return
	var/image/I = image(icon, icon_state)
	var/image/cables = image('icons/obj/structures/droppod_32x64.dmi', attached_atom, "chute_cables_static")
	var/image/chute = image('icons/obj/structures/droppod_64x64.dmi', attached_atom, "chute_static")
	var/corr_x = (attached_atom.pixel_x * -1)//This fixes a pixel offset bug with big sprites
	I.pixel_x = corr_x
	cables.pixel_x = corr_x
	chute.pixel_x = corr_x - 16
	chute.pixel_y = 16
	icon_state = ""
	attached_atom.overlays += list(cables, chute, I)
	var/originalLayer = attached_atom.layer
	var/originalAlpha = attached_atom.alpha
	attached_atom.layer = 100 //You want this above everything else because it flies up into the sky
	animate(attached_atom, pixel_y = 10, time = 30, easing = BOUNCE_EASING)
	playsound(loc, 'sound/items/fulton.ogg', 50, 1)
	sleep(30)
	animate(attached_atom, pixel_y = 500, time = 50, alpha = 0, easing = CIRCULAR_EASING|EASE_OUT)
	playsound(loc, 'sound/items/fulton_takeoff.ogg', 50, 1)
	sleep(50)
	original_location = get_turf(attached_atom)



	reservation = SSmapping.request_turf_block_reservation(3, 3, 1, turf_type_override = /turf/open/space)
	var/turf/bottom_left_turf = reservation.bottom_left_turfs[1]
	var/turf/top_right_turf = reservation.top_right_turfs[1]
	var/middle_x = bottom_left_turf.x + floor((top_right_turf.x - bottom_left_turf.x) / 2)
	var/middle_y = bottom_left_turf.y + floor((top_right_turf.y - bottom_left_turf.y) / 2)
	var/turf/space_tile = locate(middle_x, middle_y, bottom_left_turf.z)
	if(!space_tile)
		visible_message(SPAN_WARNING("[src] begins beeping like crazy. Something is wrong!"))
		return

	attached_atom.anchored = TRUE
	attached_atom.forceMove(space_tile)
	attached_atom.pixel_y = 0

	forceMove(attached_atom)
	GLOB.deployed_fultons += src
	attached_atom.overlays -= I
	attached_atom.overlays -= cables
	attached_atom.overlays -= chute
	attached_atom.layer = originalLayer
	attached_atom.alpha = originalAlpha
	addtimer(CALLBACK(src, PROC_REF(return_fulton), original_location), 150 SECONDS)

/obj/item/stack/fulton/proc/return_fulton(turf/return_turf)

	// Fulton is not in reservation, it must have been collected.
	if(!(get_turf(src) in reservation.reserved_turfs))
		return

	attached_atom.forceMove(return_turf)
	attached_atom.anchored = FALSE
	playsound(attached_atom.loc,'sound/effects/bamf.ogg', 50, 1)

	if(GLOB.intel_system)
		if (!LAZYISIN(GLOB.failed_fultons, attached_atom))
			//Giving marines an objective to retrieve that fulton (so they'd know what they lost and where)
			var/datum/cm_objective/retrieve_item/fulton/objective = new /datum/cm_objective/retrieve_item/fulton(attached_atom)
			GLOB.intel_system.store_single_objective(objective)

	qdel(reservation)
	qdel(src)
	return
