/obj/item/storage/robot_parts_kit
	name = "Набор синтетических конечностей"
	desc = "Содержит полный набор роботизированных конечностей. Сделано с применением переработанных материалов"
	icon = 'modular/limb_case/icons/limb_kit.dmi'
	item_icons = list(
		WEAR_L_HAND = 'modular/limb_case/icons/limb_kit_lefthand.dmi',
		WEAR_R_HAND = 'modular/limb_case/icons/limb_kit_righthand.dmi',
	)
	icon_state = "limb_kit"
	item_state = "limb_kit"
	use_sound = "toolbox"
	var/empty_icon = "limb_kit_e"
	var/icon_full = "limb_kit"
	var/possible_icons_full
	can_hold = list(
		/obj/item/robot_parts/arm/l_arm,
		/obj/item/robot_parts/arm/r_arm,
		/obj/item/robot_parts/leg/r_leg,
		/obj/item/robot_parts/leg/l_leg,
	)

	var/has_overlays = TRUE

	storage_flags = STORAGE_FLAGS_BOX
	required_skill_for_nest_opening = SKILL_MEDICAL
	required_skill_level_for_nest_opening = SKILL_MEDICAL_MEDIC

	storage_slots = 4
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_MEDIUM

	var/list/types_and_overlays = list(
	/obj/item/robot_parts/arm/l_arm = "l_arm_overlay",
	/obj/item/robot_parts/arm/r_arm = "r_arm_overlay",
	/obj/item/robot_parts/leg/r_leg = "r_leg_overlay",
	/obj/item/robot_parts/leg/l_leg = "l_leg_overlay",
	)

/obj/item/storage/robot_parts_kit/Initialize()
	. = ..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/robot_parts_kit/update_icon()
	overlays.Cut()
	if(content_watchers)
		icon_state = empty_icon
		if(!has_overlays)
			return
		for(var/obj/item/overlayed_item in contents)
			if(types_and_overlays[overlayed_item.type])
				overlays += types_and_overlays[overlayed_item.type]
	else if(!length(contents))
		icon_state = empty_icon
		return
	else
		icon_state = icon_full

/obj/item/storage/robot_parts_kit/attack_self(mob/living/user)
	..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)



/obj/item/storage/robot_parts_kit/fill_preset_inventory()
	new /obj/item/robot_parts/arm/l_arm(src)
	new /obj/item/robot_parts/arm/r_arm(src)
	new /obj/item/robot_parts/leg/r_leg(src)
	new /obj/item/robot_parts/leg/l_leg(src)

/obj/item/storage/robot_parts_kit/empty/fill_preset_inventory()
	return


