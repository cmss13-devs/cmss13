/obj/structure/prop/fishing
	name = "fishing pole"
	desc = "For god's sake I just want to fish."
	icon = 'icons/obj/structures/fishing.dmi'
	icon_state = "pole"
	density = FALSE
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/prop/fishing/pole_interactive
	var/time_to_fish = 30 SECONDS
	var/fishing_success = 'sound/misc/fishing_set_hook.ogg'// changed sound effects
	var/fishing_start = 'sound/misc/fishing_Line.ogg'
	var/fishing_failure = 'sound/misc/fishing_fail_splash.ogg'
	var/fishing_event = 'sound/misc/bobber_water_splash.ogg'

	// these can be modified per-rod to make one luckier than the others
	var/common_weight = 80
	var/uncommon_weight = 40
	var/rare_weight = 5
	var/ultra_rare_weight = 1

	var/fish_check_progress = FALSE
	var/waiting_for_fish = FALSE

	var/pole_type = /obj/item/fishing_pole
	var/obj/item/fish_bait/loaded_bait

/obj/structure/prop/fishing/pole_interactive/Destroy()
	QDEL_NULL(loaded_bait)
	return ..()

/obj/structure/prop/fishing/pole_interactive/examine(mob/user)
	. = ..()
	if(loaded_bait)
		to_chat(user, SPAN_NOTICE("It has [loaded_bait] loaded on its hook."))
	else
		to_chat(user, SPAN_WARNING("It doesn't have any bait attached!"))

/obj/structure/prop/fishing/pole_interactive/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/fish_bait))
		if(loaded_bait)
			to_chat(user, SPAN_WARNING("\The [src] already has bait loaded onto the hook!"))
			return
		if(user.drop_inv_item_to_loc(I, src))
			loaded_bait = I
			user.visible_message(SPAN_NOTICE("[user] loads \the [I] onto \the [src]'s hook."), SPAN_NOTICE("You load \the [I] onto \the [src]'s hook."))
			return
	return ..()

/obj/structure/prop/fishing/pole_interactive/MouseDrop(obj/over_object)
	if(CAN_PICKUP(usr, src) && over_object == usr)
		var/mob/user = over_object
		if(waiting_for_fish || fish_check_progress)
			to_chat(user, SPAN_WARNING("It is EXTREMELY disrespectful to pack up a rod while someone's fishing!"))
			return
		user.visible_message(SPAN_NOTICE("[user] starts packing up \the [src]..."), SPAN_NOTICE("You start packing up \the [src]..."))
		if(do_after(user, 3 SECONDS, show_busy_icon = BUSY_ICON_BUILD))
			var/obj/item/fishing_pole/FP = new pole_type(loc)
			FP.transfer_to_user(src, user)

/obj/structure/prop/fishing/pole_interactive/attack_hand(mob/user)
	if(waiting_for_fish)
		to_chat(user, SPAN_WARNING("You're already fishing."))
		return

	if(fish_check_progress)//are we doing the click minigame?
		fish_check_progress = FALSE//if so hit false
		remove_filter("fish_ready")
		spawn_loot(user)
		return

	playsound(src, fishing_start, 50, 1)
	waiting_for_fish = TRUE
	if(!do_after(user, rand(5 SECONDS, 10 SECONDS), INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		waiting_for_fish = FALSE
		return
	fish_check(user)

/obj/structure/prop/fishing/pole_interactive/proc/fish_check(mob/user)//this is some 5 head code
	waiting_for_fish = FALSE
	fish_check_progress = TRUE

	playsound(src, fishing_event, 50, 1)
	add_filter("fish_ready", 1, list("type" = "outline", "color" = "#26c9c64f", "size" = 2))

	if(do_after(user, rand(0.5 SECONDS, 2 SECONDS)) && fish_check_progress)
		fish_check_progress = FALSE
		playsound(src, fishing_failure, 50, 1)
		user.visible_message(SPAN_NOTICE("[user] fails to fish up anything."), SPAN_NOTICE("You don't seem to catch much of anything..."))
		remove_filter("fish_ready")

/obj/structure/prop/fishing/pole_interactive/proc/spawn_loot(mob/M)
	var/turf/T = get_step(get_step(src, dir), dir)//at least 2 tiles away, also add a temp_visual water splash when those are merged into the codebase
	var/area/A = get_area(T)

	var/obj/item/caught_item = get_fishing_loot(T, A, get_common_weight(), get_uncommon_weight(), get_rare_weight(), get_ultra_rare_weight())
	caught_item.throw_atom(get_turf(M), 2, 2, spin = TRUE, launch_type = HIGH_LAUNCH)
	playsound(src, fishing_success, 50, 1)
	M.visible_message(SPAN_NOTICE("[M] fishes up \the [caught_item]!"), SPAN_NOTICE("You fish up \the [caught_item]!"))

	QDEL_NULL(loaded_bait)

/obj/structure/prop/fishing/pole_interactive/proc/get_common_weight()
	. = common_weight
	if(loaded_bait)
		. += loaded_bait.common_mod

/obj/structure/prop/fishing/pole_interactive/proc/get_uncommon_weight()
	. = uncommon_weight
	if(loaded_bait)
		. += loaded_bait.uncommon_mod

/obj/structure/prop/fishing/pole_interactive/proc/get_rare_weight()
	. = rare_weight
	if(loaded_bait)
		. += loaded_bait.rare_mod

/obj/structure/prop/fishing/pole_interactive/proc/get_ultra_rare_weight()
	. = ultra_rare_weight
	if(loaded_bait)
		. += loaded_bait.ultra_rare_mod
