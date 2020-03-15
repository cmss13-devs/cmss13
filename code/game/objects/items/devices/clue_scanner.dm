/obj/item/device/clue_scanner
	name = "forensic scanner"
	desc = "A modern handheld scanner to gather fingerprints. Guaranteed increase of effectivity and almost perfect accuracy of results. DISCLAIMER: Incorrect results are not covered by insurance."
	icon_state = "forensic1"
	w_class = SIZE_MEDIUM
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST

	var/obj/effect/decal/prints/found_prints = null
	var/scanning = FALSE

/obj/item/device/clue_scanner/update_icon()
	overlays.Cut()

	if(scanning)
		overlays += "+scanning"

	if(found_prints)
		overlays += "+prints"

/obj/item/device/clue_scanner/attack_self(mob/user)
	. = ..()
	
	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	scanning = TRUE
	update_icon()
	user.visible_message(SPAN_NOTICE("[user] starts scanning the surroundings for prints..."), SPAN_NOTICE("You scan the surroundings for prints..."))
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		scanning = FALSE
		update_icon()
		return
	scanning = FALSE

	var/obj/effect/decal/prints/print_set 
	for(var/obj/effect/decal/prints/P in range(2))
		P = print_set
		break

	if(!print_set)
		to_chat(user, SPAN_WARNING("No prints located in the area..."))
		return

	print_set.loc = null
	found_prints = print_set
	update_icon()
	to_chat(user, SPAN_INFO("Print set found: [found_prints.generate_clue()]"))