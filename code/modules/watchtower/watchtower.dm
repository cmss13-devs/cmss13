/obj/structure/watchtower
	name = "watchtower"
	icon = 'icons/obj/structures/watchtower.dmi'
	icon_state = "stage1"

	density = FALSE
	bound_width = 64
	bound_height = 96

	var/stage = 1
	var/image/roof_image

/obj/structure/watchtower/Initialize()
	var/list/turf/blocked_turfs = CORNER_BLOCK(get_turf(src), 2, 1) + CORNER_BLOCK_OFFSET(get_turf(src), 2, 1, 0, 2)

	var/atom/west_blocker = new /obj/structure/blocker/watchtower(locate(x, y+1, z))
	var/atom/east_blocker = new /obj/structure/blocker/watchtower(locate(x+1, y+1, z))
	west_blocker.dir = WEST
	east_blocker.dir = EAST

	for(var/turf/current_turf in blocked_turfs)
		new /obj/structure/blocker/watchtower/full_tile(current_turf)

	update_icon()

	return ..()

/obj/structure/watchtower/Destroy()
	playsound(src, 'sound/effects/metal_crash.ogg', 50, 1)
	var/list/turf/all_turfs = CORNER_BLOCK(get_turf(src), 2, 3)

	for(var/turf/current_turf in all_turfs)
		for(var/obj/structure/blocker/invisible_wall in current_turf.contents)
			qdel(invisible_wall)

	var/list/turf/top_turfs = CORNER_BLOCK_OFFSET(get_turf(src), 2, 1, 0, 1)

	for(var/turf/current_turf in top_turfs)
		for(var/mob/falling_mob in current_turf.contents)
			if(falling_mob.client)
				falling_mob.client.change_view(falling_mob.client.view - 2)
			var/atom/movable/screen/plane_master/roof/roof_plane = falling_mob.hud_used.plane_masters["[ROOF_PLANE]"]
			roof_plane?.invisibility = 0
			falling_mob.ex_act(100, 0)
			UnregisterSignal(falling_mob, COMSIG_ITEM_PICKUP)
			UnregisterSignal(falling_mob, COMSIG_MOVABLE_PRE_MOVE)

	new /obj/structure/girder(get_turf(src))
	new /obj/structure/girder/broken(locate(x+1, y, z))
	new /obj/structure/girder/broken(locate(x, y+1, z))
	new /obj/item/stack/sheet/metal(locate(x+1, y+1, z), 10)
	new /obj/item/stack/rods(locate(x+1, y+1, z), 20)

	return ..()

/obj/structure/watchtower/update_icon()
	. = ..()
	icon_state = "stage[stage]"

	overlays.Cut()

	if(stage >= 5)
		overlays += image(icon=icon, icon_state="railings", layer=ABOVE_MOB_LAYER, pixel_y=25)

	if (stage == 7)
		roof_image = image(icon=icon, icon_state="roof", layer=ABOVE_MOB_LAYER, pixel_y=51)
		roof_image.plane = ROOF_PLANE
		roof_image.appearance_flags = KEEP_APART
		overlays += roof_image

/obj/structure/watchtower/attackby(obj/item/W, mob/user)
	if(istool(W) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
		to_chat(user, SPAN_WARNING("You are not trained to configure [src]..."))
		return TRUE

	switch(stage)
		if(1)
			if(!istype(W, /obj/item/stack/rods))
				return

			var/obj/item/stack/rods/rods = W

			if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				return

			if(rods.use(60))
				to_chat(user, SPAN_NOTICE("You add connection rods to the watchtower."))
				stage = 2
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You failed to construct the connection rods. You need more rods."))

			return
		if(2)
			if(!iswelder(W))
				return

			if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
				return

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			to_chat(user, SPAN_NOTICE("You weld the connection rods to the frame."))
			stage = 2.5

			return
		if(2.5)
			if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				return

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			to_chat(user, SPAN_NOTICE("You elevate the the frame and screw it up top."))
			stage = 3
			update_icon()

			return
		if(3)
			if(!HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				return

			var/obj/item/stack/sheet/metal/metal = user.get_inactive_hand()
			if(!istype(metal))
				to_chat(user, SPAN_BOLDWARNING("You need metal sheets in your offhand to continue construction of the watchtower."))
				return FALSE

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			if(metal.use(50))
				to_chat(user, SPAN_NOTICE("You construct the watchtower platform."))
				stage = 4
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You failed to construct the watchtower platform, you need more metal sheets in your offhand."))

			return
		if(4)
			if(!HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				return

			var/obj/item/stack/sheet/plasteel/plasteel = user.get_inactive_hand()
			if(!istype(plasteel))
				to_chat(user, SPAN_BOLDWARNING("You need plasteel sheets in your offhand to continue construction of the watchtower."))
				return FALSE

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			if(plasteel.use(25))
				to_chat(user, SPAN_NOTICE("You construct the watchtower railing."))
				stage = 5
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You failed to construct the watchtower railing, you need more plasteel sheets in your offhand."))

			return
		if(5)
			if (!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				return

			var/obj/item/stack/rods/rods = user.get_inactive_hand()
			if(!istype(rods))
				to_chat(user, SPAN_BOLDWARNING("You need metal rods in your offhand to continue construction of the watchtower."))
				return FALSE

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			if(rods.use(60))
				to_chat(user, SPAN_NOTICE("You construct the watchtower support rods."))
				stage = 6
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You failed to construct the watchtower support rods, you need more metal rods in your offhand."))

			return
		if(6)
			if (!iswelder(W))
				return

			if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
				return

			var/obj/item/stack/sheet/plasteel/plasteel = user.get_inactive_hand()
			if(!istype(plasteel))
				to_chat(user, SPAN_BOLDWARNING("You need plasteel sheets in your offhand to continue construction of the watchtower."))
				return FALSE

			if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return

			if(plasteel.use(25))
				to_chat(user, SPAN_NOTICE("You complete the watchtower."))
				stage = 7
				update_icon()


			else
				to_chat(user, SPAN_NOTICE("You failed to complete the watchtower, you need more plasteel sheets in your offhand."))

			return

/obj/structure/watchtower/attack_hand(mob/user)
	if(get_turf(user) == locate(x, y-1, z))
		if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		var/turf/actual_turf = locate(x, y+1, z)
		ADD_TRAIT(user, TRAIT_ON_WATCHTOWER, "watchtower")
		user.forceMove(actual_turf)
		user.client.change_view(user.client.view + 2)
		var/atom/movable/screen/plane_master/roof/roof_plane = user.hud_used.plane_masters["[ROOF_PLANE]"]
		roof_plane?.invisibility = INVISIBILITY_MAXIMUM
		add_trait_to_all_guns(user)
		RegisterSignal(user, COMSIG_ITEM_PICKUP, PROC_REF(item_picked_up))
		RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_can_move))
	else if(get_turf(user) == locate(x, y+1, z))
		if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		REMOVE_TRAIT(user, TRAIT_ON_WATCHTOWER, "watchtower")
		var/turf/actual_turf = locate(x, y-1, z)
		user.forceMove(actual_turf)
		user.client.change_view(user.client.view - 2)
		var/atom/movable/screen/plane_master/roof/roof_plane = user.hud_used.plane_masters["[ROOF_PLANE]"]
		roof_plane?.invisibility = 0
		UnregisterSignal(user, COMSIG_ITEM_PICKUP)
		UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)

/obj/structure/watchtower/proc/add_trait_to_all_guns(mob/user)
	for(var/obj/item/weapon/gun/gun in user)
		gun.add_bullet_traits(list(BULLET_TRAIT_ENTRY_ID("watchtower_arc", /datum/element/bullet_trait_direct_only/watchtower)))

	for(var/obj/item/storage/storage in user)
		for(var/obj/item/weapon/gun/gun in storage.contents)
			gun.add_bullet_traits(list(BULLET_TRAIT_ENTRY_ID("watchtower_arc", /datum/element/bullet_trait_direct_only/watchtower)))

/obj/structure/watchtower/proc/item_picked_up(obj/item/picked_up_item, mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if(!istype(picked_up_item, /obj/item/weapon/gun))
		return
	
	var/obj/item/weapon/gun/gun = picked_up_item
	gun.add_bullet_traits(list(BULLET_TRAIT_ENTRY_ID("watchtower_arc", /datum/element/bullet_trait_direct_only/watchtower)))

/obj/structure/watchtower/proc/check_can_move(mob/mover, turf/new_loc)
	SIGNAL_HANDLER
	var/found = FALSE
	for(var/turf/current_turf in CORNER_BLOCK_OFFSET(get_turf(src), 2, 1, 0, 1))
		if (current_turf.x == new_loc.x && current_turf.y == new_loc.y && current_turf.z == new_loc.z)
			found = TRUE
			break

	if(!found)	
		return COMPONENT_CANCEL_MOVE

	return	

/obj/structure/watchtower/attack_alien(mob/living/carbon/xenomorph/xeno)
	if (xeno.mob_size < MOB_SIZE_BIG)
		return

	if(!do_after(xeno, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	qdel(src)

// For Mappers
/obj/structure/watchtower/stage1
	stage = 1
	icon_state = "stage1"
/obj/structure/watchtower/stage2
	stage = 2
	icon_state = "stage2"
/obj/structure/watchtower/stage3
	stage = 3
	icon_state = "stage3"
/obj/structure/watchtower/stage4
	stage = 4
	icon_state = "stage4"
/obj/structure/watchtower/stage5
	stage = 5
	icon_state = "stage5"
/obj/structure/watchtower/stage6
	stage = 6
	icon_state = "stage6"
/obj/structure/watchtower/complete
	stage = 7
	icon_state = "stage7"
