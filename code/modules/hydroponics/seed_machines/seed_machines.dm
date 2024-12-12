/obj/structure/machinery/botany
	icon = 'icons/obj/structures/machinery/hydroponics.dmi'
	icon_state = "hydrotray3"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE

	var/obj/item/seeds/seed // Currently loaded seed packet.
	var/obj/item/disk/botany/loaded_disk //Currently loaded data disk.

	var/open = FALSE
	var/disk_needs_genes = FALSE


/obj/structure/machinery/botany/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/botany/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/structure/machinery/botany/proc/eject_disk()
	if(!loaded_disk)
		return
	loaded_disk.forceMove(get_turf(src))
	playsound(src, 'sound/machines/terminal_eject.ogg', 25, TRUE)
	loaded_disk = null

/obj/structure/machinery/botany/proc/eject_seed()
	if(!seed)
		return
	seed.forceMove(get_turf(src))

	if(seed.seed.name == "new line" || isnull(GLOB.seed_types[seed.seed.name]))
		seed.seed.uid = length(GLOB.seed_types) + 1
		seed.seed.name = "[seed.seed.uid]"
		GLOB.seed_types[seed.seed.name] = seed.seed

	seed.update_seed()
	playsound(src, 'sound/machines/terminal_eject.ogg', 25, TRUE)
	seed = null

/obj/structure/machinery/botany/proc/fail_task()
	visible_message("[icon2html(src, viewers(src))] [src] pings unhappily, flashing a red warning light.")
	playsound(src, 'sound/machines/buzz-two.ogg', 25, TRUE)

/obj/structure/machinery/botany/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/seeds))
		if(seed)
			to_chat(user, SPAN_WARNING("There is already a seed loaded."))
			return
		var/obj/item/seeds/S = W
		if(S.seed && S.seed.immutable > 0)
			to_chat(user, SPAN_WARNING("That seed is not compatible with our genetics technology."))
		else
			user.drop_held_item()
			W.forceMove(src)
			seed = W
			to_chat(user, "You load [W] into \the [src].")
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] the maintenance panel."))
		return

	if(open)
		if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
			dismantle()
			return

	if(istype(W,/obj/item/disk/botany))
		if(loaded_disk)
			to_chat(user, SPAN_WARNING("There is already a data disk loaded."))
			return
		else
			var/obj/item/disk/botany/B = W

			if(LAZYLEN(B.genes))
				if(!disk_needs_genes)
					to_chat(user, SPAN_WARNING("That disk already has gene data loaded."))
					return
			else
				if(disk_needs_genes)
					to_chat(user, SPAN_WARNING("That disk does not have any gene data loaded."))
					return

			user.drop_held_item()
			W.forceMove(src)
			loaded_disk = W
			to_chat(user, SPAN_NOTICE("You load \the [W] into [src]."))

		return
	. = ..()
