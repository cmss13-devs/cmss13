
/obj/item/device/control_headset_xeno
	name = "X993A1-X Control Headset"
	desc = "This disturbing apparatus is designed to be surgically grafted onto live, braindead XX-121 specimen, allowing an user to remotely control their body at will."
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	icon_state = "cam_gear_off"
	var/obj/structure/machinery/camera/camera

/obj/item/device/control_headset_xeno/Initialize(mapload, ...)
	. = ..()
	camera = new /obj/structure/machinery/camera(src)

/obj/item/device/control_headset_xeno/Destroy()
	QDEL_NULL(camera)
	return ..()

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
	if(!do_after(owner, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(owner, SPAN_WARNING("You were interrupted!"))
		return

	SEND_SIGNAL(picked_xeno, COMSIG_XENO_CONTROL_HEADSET_CONTROL, owner)

/datum/action/item_action/control_xenomorph/can_use_action()
	var/mob/living/carbon/human/human = owner
	if(istype(human) && !human.is_mob_incapacitated())
		return TRUE

/datum/action/item_action/lose_control/New(Target, obj/item/holder)
	. = ..()
	name = name
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions_xeno.dmi', button, "rav_enrage")
	button.overlays += IMG

/datum/action/lose_control/action_activate()
	..()
	SEND_SIGNAL(owner, COMSIG_XENO_CONTROL_HEADSET_UNCONTROL, owner)
