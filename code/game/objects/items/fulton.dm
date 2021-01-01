// Fulton baloon deployment devices, used to gather and send crates, dead things, and other objective-based items into space for collection.

var/global/list/deployed_fultons = list()

/obj/item/stack/fulton
	name = "fulton recovery device"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "fulton"
	amount = 20
	max_amount = 20
	desc = "A system used by the USCM for retrieving objects of interest on the ground from a AUD-25 dropship. Can be used to extract unrevivable corpses, or crates, typically lasting around 3 minutes in the air."
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

/obj/item/stack/fulton/New(loc, amount, var/atom_to_attach)
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
	deployed_fultons -= src
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

/obj/item/stack/fulton/attack(mob/M as mob, mob/user as mob, def_zone)
	return

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

	if(target_atom.z != 1)
		to_chat(user, SPAN_WARNING("You can't attach [src] to something here."))
		return

	var/area/A = get_area(target_atom)
	if(A && A.ceiling >= CEILING_UNDERGROUND)
		to_chat(usr, SPAN_WARNING("You can't attach [src] to something when underground!"))
		return

	var/can_attach = FALSE

	if(isliving(target_atom))
		if(ishuman(target_atom))
			var/mob/living/carbon/human/H = target_atom
			if(isYautja(H) && H.stat == DEAD)
				can_attach = TRUE
			else if((H.mind && H.check_tod() && H.is_revivable()) || H.stat != DEAD)
				to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom], they still have a chance!"))
				return
			else
				can_attach = TRUE
		else if(isXeno(target_atom))
			var/mob/living/carbon/Xenomorph/X = target_atom
			if(X.stat != DEAD)
				to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom], kill it first!"))
				return
			else
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
		user.visible_message(SPAN_WARNING("[user] begins attaching [src] onto [target_atom]."), \
					SPAN_WARNING("You begin to attach [src] onto [target_atom]."))
		if(do_after(user, 50 * user.get_skill_duration_multiplier(), INTERRUPT_ALL, BUSY_ICON_GENERIC))
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
			F.deploy_fulton()
	else
		to_chat(user, SPAN_WARNING("You can't attach [src] to [target_atom]."))

/obj/item/stack/fulton/proc/deploy_fulton()
	if(!attached_atom)
		return
	var/image/I = image(icon, icon_state)
	if(isXeno(attached_atom))
		var/mob/living/carbon/Xenomorph/X = attached_atom
		I.pixel_x = (X.pixel_x * -1)
	attached_atom.overlays += I
	sleep(30)
	original_location = get_turf(attached_atom)
	playsound(loc, 'sound/items/fulton.ogg', 50, 1)
	var/turf/space_tile = pick(get_area_turfs(/area/space/highalt))
	if(!space_tile)
		visible_message(SPAN_WARNING("[src] begins beeping like crazy. Something is wrong!."))
		return

	icon_state = ""

	attached_atom.anchored = TRUE
	attached_atom.forceMove(space_tile)

	forceMove(attached_atom)
	deployed_fultons += src
	attached_atom.overlays -= I

	addtimer(CALLBACK(src, .proc/return_fulton, original_location), 150 SECONDS)

/obj/item/stack/fulton/proc/return_fulton(var/turf/return_turf)
	if(!istype(get_area(attached_atom), /area/space/highalt))
		return
	if(return_turf)
		attached_atom.forceMove(return_turf)
		attached_atom.anchored = FALSE
		playsound(attached_atom.loc,'sound/effects/bamf.ogg', 50, 1)

	if(intel_system)
		//Giving marines an objective to retrieve that fulton (so they'd know what they lost and where)
		var/datum/cm_objective/retrieve_item/fulton/objective = new /datum/cm_objective/retrieve_item/fulton(attached_atom)
		intel_system.store_single_objective(objective)

	qdel(src)
	return

