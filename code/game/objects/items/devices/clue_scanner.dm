/obj/item/device/clue_scanner
	name = "forensic scanner"
	desc = "A modern handheld scanner to gather fingerprints. Must be analyzed at a security records terminal after prints are gathered."
	icon_state = "forensic1"
	w_class = SIZE_MEDIUM
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST

	var/list/print_list
	var/scanning = FALSE
	var/newlyfound

/obj/item/device/clue_scanner/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("Print sets stored: [length(print_list)]")

/obj/item/device/clue_scanner/update_icon()
	overlays.Cut()

	if(scanning)
		overlays += "+scanning"

	if(print_list)
		overlays += "+prints"

/obj/item/device/clue_scanner/attack_self(mob/user)
	. = ..()

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
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

	newlyfound = 0
	for(var/obj/effect/decal/prints/P in range(2))
		newlyfound++
		LAZYADD(print_list, P)
		P.moveToNullspace()

	update_icon()

	if(!newlyfound)
		to_chat(user, SPAN_INFO("No new print sets found!"))
	else
		to_chat(user, SPAN_INFO("New print sets found: [newlyfound], total stored amount: [length(print_list)]"))
