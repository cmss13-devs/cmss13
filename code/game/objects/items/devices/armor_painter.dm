//proc that allow to repaint/change sprite for

GLOBAL_LIST_INIT(armor_paints_light, list("padded" = "L1", "padless" = "L2", "padless_lines" = "L3", "carrier" = "L4", "skull" = "L5", "smooth" = "L6"))
GLOBAL_LIST_INIT(armor_paints_medium, list("padded" = "1", "padless" = "2", "padless_lines" = "3", "carrier" = "4", "skull" = "5", "smooth" = "6"))
GLOBAL_LIST_INIT(armor_paints_heavy, list("padded" = "H1", "padless" = "H2", "padless_lines" = "H3", "carrier" = "H4", "skull" = "H5", "smooth" = "H6"))
/obj/item/device/armor_painter
	name = "armor painter"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "camo"
	item_state = "flight"
	var/list/modes_light
	var/list/modes_medium
	var/list/modes_heavy
	var/mode

/obj/item/device/armor_painter/New()
	..()

	modes_light = new()
	for(var/C in GLOB.armor_paints_light)
		modes_light += "[C]"
	mode = pick(modes_light)

	modes_medium = new()
	for(var/C in GLOB.armor_paints_medium)
		modes_medium += "[C]"
	mode = pick(modes_medium)

	modes_heavy = new()
	for(var/C in GLOB.armor_paints_heavy)
		modes_heavy += "[C]"
	mode = pick(modes_heavy)


/obj/item/device/armor_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		to_chat(user, "target isn't at proximity.")
		return

	if(!in_range(user, A))
		to_chat(user, "target isn't in range.")
		return

	if(istype(A,/obj/item/clothing/suit/storage/marine/light))
		to_chat(user, "it's an light armor.")
		A.icon_state = (GLOB.armor_paints_light[mode])
		return

	if(istype(A,/obj/item/clothing/suit/storage/marine/medium))
		to_chat(user, "it's an medium armor.")
		A.icon_state = (GLOB.armor_paints_medium[mode])
		return

	if(istype(A,/obj/item/clothing/suit/storage/marine/heavy))
		A.icon_state = (GLOB.armor_paints_heavy[mode])
		to_chat(user, "it's an heavy armor.")
		return

/obj/item/device/armor_painter/attack_self(mob/user)
	..()
	var/type = tgui_input_list(usr, "What type of armor?", "Armor painter", list("light", "medium", "heavy"))
	switch(type)
		if("light")
			mode = tgui_input_list(usr, "Which armor tag do you want to use?", "Armor painter", modes_light)
		if("medium")
			mode = tgui_input_list(usr, "Which armor tag do you want to use?", "Armor painter", modes_medium)
		if("heavy")
			mode = tgui_input_list(usr, "Which armor tag do you want to use?", "Armor painter", modes_heavy)

/obj/item/device/armor_painter/get_examine_text(mob/user)
	. = ..()
	. += "It is in [mode] mode."

