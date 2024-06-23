/obj/structure/machinery/colony_selfdestruct
	name = "self-destruct mechanism"
	desc = "Weyland-Yutani produced SelDest-15 low-yield nuclear bomb. Guaranteed to destroy all corporate secrets along with personnel or your money back!"
	icon_state = "selfdestruct"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE
	var/obj/item/disk/nuclear/dat_disk
	var/timeleft = 2 MINUTES
	var/explosiontime
	var/explosionpower = 1200

/obj/structure/machinery/colony_selfdestruct/attack_hand(mob/user)
	if(user.is_mob_incapacitated() || get_dist(src, user) > 1 || isRemoteControlling(user))
		return

	if(!dat_disk)
		to_chat(user, SPAN_WARNING("[src] can't be activated without the nuclear disk!"))
		return
	else
		user.visible_message(SPAN_WARNING("[user] starts to pull the disk out of [src]..."), SPAN_WARNING("You start to pull the disk out of [src]... you hope it's not stuck."))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()

/obj/structure/machinery/colony_selfdestruct/proc/enable()
	playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
	explosiontime = world.time + timeleft
	start_processing()
	marine_announcement("Colony low-yield nuclear self-destruct mechanism has been activated in [get_area_name(loc)]. Detonation in T-[floor(timeleft/10)] seconds.", "[MAIN_AI_SYSTEM] Nuclear Tracker", 'sound/misc/notice1.ogg')
	xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have activated self-boom rock at [get_area_name(loc)]! Avoid it!"), "everything", XENO_GENERAL_ANNOUNCE)

/obj/structure/machinery/colony_selfdestruct/proc/disable()
	var/turf/nuke_turf = get_turf(src)
	dat_disk.forceMove(nuke_turf)
	timeleft = initial(timeleft)
	explosiontime = null
	marine_announcement("Colony low-yield nuclear self-destruct mechanism has been deactivated in [get_area_name(loc)]. Detonation averted.", "[MAIN_AI_SYSTEM] Nuclear Tracker", 'sound/misc/notice1.ogg')
	xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have deactivated self-boom rock at [get_area_name(loc)]! The area is safe now."), "everything", XENO_GENERAL_ANNOUNCE)
	stop_processing()

/obj/structure/machinery/colony_selfdestruct/proc/explode()
	stop_processing()
	cell_explosion(loc, explosionpower, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)))//wall clear
	cell_explosion(loc, explosionpower, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)))//fuck up.
	dat_disk = null
	qdel(dat_disk)
	qdel(src)

/obj/structure/machinery/colony_selfdestruct/process()
	. = ..()
	if(!dat_disk)
		return PROCESS_KILL

	timeleft = explosiontime - world.time
	if(world.time >= explosiontime)
		explode()
		return

	update_icon()

/obj/structure/machinery/colony_selfdestruct/update_icon()
	if(!dat_disk)
		icon_state = initial(icon_state)
		return

	var/stage_1 = timeleft / 1.3
	var/stage_2 = timeleft / 2
	var/stage_3 = timeleft / 4

	if(timeleft < initial(timeleft) && timeleft > stage_1)
		icon_state = "selfdestruct1"

	if(timeleft < stage_1 && timeleft > stage_2)
		icon_state = "selfdestruct2"

	if(timeleft < stage_2 && timeleft > stage_3)
		icon_state = "selfdestruct3"

	if(timeleft < stage_3 && timeleft > 0)
		icon_state = "selfdestruct4"

	if(timeleft <= 0)
		icon_state = "selfdestructboom"

/obj/structure/machinery/colony_selfdestruct/attackby(obj/item/weapon, mob/living/user)
	if(istype(weapon, /obj/item/disk/nuclear) && !dat_disk)
		user.visible_message(SPAN_WARNING("[user] begins to put [weapon] inside [src]..."), SPAN_WARNING("You begin to put [weapon] inside [src]. Ooh boy..."))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			user.temp_drop_inv_item(weapon)
			weapon.forceMove(src)
			dat_disk = weapon
			enable()
			return
	..()
