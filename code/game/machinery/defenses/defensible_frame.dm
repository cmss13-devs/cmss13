#define BASE_EMPTY			 0
#define BASE_MOVABLE		 1
#define BASE_MODULE_INSERTED 2

/obj/structure/machinery/defensible_frame
	name = "\improper defense frame"
	desc = "An unfinished turret frame. Insert a defense module and weld to complete."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "defense_base_preweld"
	health = 100
	anchored = FALSE
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	var/build_state = BASE_MOVABLE
	var/inserted_module = null

/obj/structure/machinery/defensible_frame/examine(var/mob/user)
	..()
	switch(build_state)
		if(BASE_EMPTY)
			to_chat(user, "It lacks a module.")
		if(BASE_MOVABLE)
			to_chat(user, "It is unscrewed from the floor.")
		if(BASE_MODULE_INSERTED)
			to_chat(user, "Weld to finish the defense.")

/obj/structure/machinery/defensible_frame/update_icon()
	overlays.Cut()
	if(build_state == BASE_MODULE_INSERTED)
		switch(inserted_module)
			if(DEFENSE_SENTRY_BASE)
				overlays += "uac_sentry_preweld"
			if(DEFENSE_SENTRY_FLAMER)
				overlays += "uac_flamer_preweld"
			if(DEFENSE_PLANTED_FLAG)
				overlays += "planted_flag_preweld"
			if(DEFENSE_BELL_TOWER)
				overlays += "bell_tower_preweld"
			if(DEFENSE_TESLA_COIL)
				var/image/I = image('icons/obj/structures/machinery/defenses.dmi', icon_state = "tesla_coil_preweld")
				I.pixel_y = 3
				overlays += I

/obj/structure/machinery/defensible_frame/attackby(var/obj/item/O, var/mob/user)
	switch(build_state)
		if(BASE_EMPTY)
			if(iswrench(O))
				user.visible_message(SPAN_NOTICE("[user] begins unsecuring [src] from the ground."),
				SPAN_NOTICE("You begin unsecuring [src] from the ground."))
				if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] unsecures [src] from the ground."),
				SPAN_NOTICE("You unsecure [src] from the ground."))

				anchored = FALSE
				build_state = BASE_MOVABLE
				return

			if(iscrowbar(O))
				disassemble(user)
				return

			insert_modules(O, user)
			return

		if(BASE_MODULE_INSERTED)
			if(iswelder(O))
				var/obj/item/tool/weldingtool/WT = O
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] begins welding [src]'s parts together."),
				SPAN_NOTICE("You begin welding [src]'s parts together."))
				if(!do_after(user,60, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return

				if(!src || !WT || !WT.isOn()) 
					return

				if(WT.remove_fuel(0, user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
					user.visible_message(SPAN_NOTICE("[user] welds [src]'s module to the frame."),
					SPAN_NOTICE("You weld [src]'s module to the frame."))
					make_defense(user)
					user.count_niche_stat(STATISTICS_NICHE_DEFENSES_BUILT)
					return
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
					return

		if(BASE_MOVABLE)
			if(iswrench(O))
				user.visible_message(SPAN_NOTICE("[user] begins securing [src] to the ground."),
				SPAN_NOTICE("You begin securing [src] to the ground."))
				if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] secures [src] to the ground."),
				SPAN_NOTICE("You secure [src] to the ground."))

				anchored = TRUE
				build_state = BASE_EMPTY
				return

			if(iscrowbar(O))
				disassemble(user)
				return
				
	return ..() //Just do normal stuff.

/obj/structure/machinery/defensible_frame/proc/insert_modules(var/obj/item/M, var/mob/user)
	if(istype(M, /obj/item/defense_module/sentry))
		inserted_module = DEFENSE_SENTRY_BASE
	else if(istype(M, /obj/item/defense_module/sentry_flamer))
		inserted_module = DEFENSE_SENTRY_FLAMER
	else if(istype(M, /obj/item/defense_module/planted_flag))
		inserted_module = DEFENSE_PLANTED_FLAG
	else if(istype(M, /obj/item/defense_module/bell_tower))
		inserted_module = DEFENSE_BELL_TOWER
	else if(istype(M, /obj/item/defense_module/tesla_coil))
		inserted_module = DEFENSE_TESLA_COIL

	if(inserted_module)
		build_state = BASE_MODULE_INSERTED
		user.visible_message(SPAN_NOTICE("[user] started inserting [M]."), SPAN_NOTICE("You begin inserting [M]"))
		if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			build_state = BASE_EMPTY
			inserted_module = null
			return

		user.visible_message(SPAN_NOTICE("[user] slots [M] into the base."), SPAN_NOTICE("You slot [M] into the base."))
		user.drop_held_item()
		qdel(M)
		update_icon()

/obj/structure/machinery/defensible_frame/proc/make_defense(mob/user as mob)
	var/obj/structure/machinery/defenses/T = null
	var/defense_type = /obj/structure/machinery/defenses/sentry
	switch(inserted_module)
		if(DEFENSE_SENTRY_BASE)
			defense_type = /obj/structure/machinery/defenses/sentry
		if(DEFENSE_SENTRY_FLAMER)
			defense_type = /obj/structure/machinery/defenses/sentry/flamer
		if(DEFENSE_PLANTED_FLAG)
			defense_type = /obj/structure/machinery/defenses/planted_flag
		if(DEFENSE_BELL_TOWER)
			defense_type = /obj/structure/machinery/defenses/bell_tower
		if(DEFENSE_TESLA_COIL)
			defense_type = /obj/structure/machinery/defenses/tesla_coil
	T = new defense_type(loc, user.faction)
	T.owner_mob = user
	T.dir = dir
	qdel(src)

/obj/structure/machinery/defensible_frame/proc/disassemble(mob/user as mob)
	user.visible_message(SPAN_NOTICE("[user] starts pulling [src] apart."), SPAN_NOTICE("You start pulling [src] apart."))
	playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)

	if(!do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return

	user.visible_message(SPAN_NOTICE("[user] pulls [src] apart."), SPAN_NOTICE("You pull [src] apart."))
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	new /obj/item/stack/sheet/metal(loc, DEFENSE_METAL_COST)
	qdel(src)


#undef BASE_EMPTY
#undef BASE_MOVABLE
#undef BASE_MODULE_INSERTED