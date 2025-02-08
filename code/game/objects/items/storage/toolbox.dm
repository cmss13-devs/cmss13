/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/items/storage/toolbox.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/toolboxes_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/toolboxes_righthand.dmi',
	)
	icon_state = "red"
	item_state = "toolbox_red"
	pickup_sound = 'sound/handling/toolbox_pickup.ogg'
	drop_sound = 'sound/handling/toolbox_drop.ogg'
	flags_atom = FPRINT|CONDUCT|NO_GAMEMODE_SKIN
	force = 5
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 7
	w_class = SIZE_LARGE
	use_sound = "toolbox"

	attack_verb = list("robusted")

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/storage/toolbox/emergency/fill_preset_inventory()
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/tool/extinguisher/mini(src)
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/radio(src)

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/storage/toolbox/mechanical/green
	name = "mechanical toolbox"
	icon_state = "green"
	item_state = "toolbox_green"

/obj/item/storage/toolbox/mechanical/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/tool/wirecutters(src)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/storage/toolbox/electrical/fill_preset_inventory()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/circuitboard/apc(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/stack/cable_coil(src,30,color)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil(src,30,color)

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"

	force = 7

/obj/item/storage/toolbox/syndicate/fill_preset_inventory()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)
