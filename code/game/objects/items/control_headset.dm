
/obj/item/clothing/head/control_headset_xeno
	name = "X993A1-X Control Headset"
	desc = "This disturbing apparatus is designed to be surgically grafted onto live, braindead XX-121 specimen, allowing an user to remotely control their body at will."
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	icon_state = "cam_gear_off"
	xeno_icon_state = "headset"
	xeno_types = list(/mob/living/carbon/xenomorph/drone)
	var/obj/structure/machinery/camera/camera

/obj/item/clothing/head/control_headset_xeno/Initialize(mapload, ...)
	. = ..()
	camera = new /obj/structure/machinery/camera(src)

/obj/item/clothing/head/control_headset_xeno/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/clothing/head/control_headset_xeno/attack(mob/living/M, mob/living/user)
	if(!isxeno(M))
		return ..()
	to_chat(user, SPAN_NOTICE("You can't just shove the headset onto a xenomorph! You need to graft the neural connections in place."))
	return

/obj/item/clothing/head/control_headset_xeno/equipped(mob/living/carbon/xenomorph/xuser, slot, silent)
	. = ..()
	if(!isxeno(xuser))
		if(!(slot == SLOT_HEAD))
			return
		dropped(xuser)
		xuser.visible_message(SPAN_WARNING("[src] falls off [xuser]'s head."))
		return
	playsound(xuser, 'sound/machines/screen_output1.ogg', 50)
	xuser.visible_message(SPAN_NOTICE("Sensors start to beep and mechanisms whirr as the control headset is grafted onto [xuser]'s head."))
	xuser.AddComponent(/datum/component/xeno_control_headset)
	xuser.set_hive_and_update(XENO_HIVE_CONTROLLED)
	// Create their vis object if needed
	if(!xuser.head_icon_holder)
		xuser.head_icon_holder = new(null, xuser)
		xuser.vis_contents += xuser.head_icon_holder

/obj/item/clothing/head/control_headset_marine
	name = "X993A1-M Control Headset"
	desc = "This device allows remote control of XX-121 specimens that have been grafted with a compatible control headset. Looks like a VR helmet."
	icon_state = "discovision"
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
	)
	armor_melee = CLOTHING_ARMOR_LOW
	actions_types = list(/datum/action/item_action/control_xenomorph)
	vision_impair = VISION_IMPAIR_HIGH
	// Connected in its own dm
	var/obj/structure/machinery/relay_tower/connected_tower

/obj/item/clothing/head/control_headset_marine/get_examine_text(mob/user)
	. = ..()
	if(connected_tower)
		. += SPAN_NOTICE("It is currently linked to a relay tower, extending its range and generating combat data.")

/obj/item/clothing/head/control_headset_marine/equipped(mob/user, slot, silent)
	. = ..()
	if(slot == WEAR_HEAD)
		RegisterSignal(user, COMSIG_ATOM_EMP_ACT, PROC_REF(lose_control))

/obj/item/clothing/head/control_headset_marine/unequipped(mob/user, slot)
	. = ..()

	UnregisterSignal(user, COMSIG_ATOM_EMP_ACT)

/obj/item/clothing/head/control_headset_marine/proc/lose_control(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_CONTROL_HEADSET_UNCONTROL)

/datum/action/item_action/control_xenomorph/New(mob/living/user, obj/item/holder)
	..()
	name = name
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions_xeno.dmi', button, "rav_enrage")
	button.overlays += IMG

/datum/action/item_action/control_xenomorph/action_activate()
	..()
	if(!can_use_action())
		return

	if(!length(GLOB.controlled_xenos))
		to_chat(owner, SPAN_WARNING("There are no controllable xenomorphs."))
		return

	var/mob/living/carbon/xenomorph/picked_xeno = tgui_input_list(owner, "Available Xenomorphs", "Control", GLOB.controlled_xenos, theme = "hive_status")
	if(!picked_xeno)
		return

	to_chat(owner, SPAN_NOTICE("You start connecting to [picked_xeno]'s headset..."))
	if(!do_after(owner, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(owner, SPAN_WARNING("You were interrupted!"))
		return

	var/obj/item/clothing/head/control_headset_marine/headset_holder = holder_item
	SEND_SIGNAL(picked_xeno, COMSIG_XENO_CONTROL_HEADSET_CONTROL, owner, headset_holder.connected_tower)

/datum/action/item_action/control_xenomorph/can_use_action()
	var/mob/living/carbon/human/human = owner

	if(!istype(human) || human.is_mob_incapacitated())
		return FALSE

	if(human.head != holder_item)
		to_chat(owner, SPAN_WARNING("You should probably wear the headest first."))
		return FALSE

	return TRUE

/datum/action/lose_control
	name = "Disconnect"
	action_icon_state = "hologram_exit"

/datum/action/lose_control/action_activate()
	..()
	SEND_SIGNAL(owner, COMSIG_XENO_CONTROL_HEADSET_UNCONTROL, owner)

/mob/living/carbon/xenomorph/proc/add_hat()
	ADD_TRAIT(src, TRAIT_XENO_BRAINDEAD, REF(src))
	var/obj/item/clothing/head/control_headset_xeno/headset = new(src)
	xeno_put_in_slot(headset, WEAR_HEAD)
	update_inv_head()

