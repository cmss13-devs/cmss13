/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/items/clothing/glasses.dmi'
	w_class = SIZE_SMALL
	var/vision_flags = 0
	var/darkness_view = 0 //Base human is 2
	var/invisa_view = FALSE
	var/prescription = FALSE
	var/toggleable = FALSE
	var/toggle_on_sound = 'sound/machines/click.ogg'
	var/toggle_off_sound = 'sound/machines/click.ogg'
	var/active = TRUE
	flags_inventory = COVEREYES
	flags_equip_slot = SLOT_EYES
	flags_armor_protection = BODY_FLAG_EYES
	var/deactive_state
	var/has_tint = FALSE //whether it blocks vision like a welding helmet
	var/fullscreen_vision
	var/req_skill
	var/req_skill_level
	var/req_skill_explicit = FALSE
	var/hud_type //hud type the glasses gives

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	if(item_state_slots && item_state_slots[slot])
		return item_state_slots[slot]
	else
		return icon_state

/obj/item/clothing/glasses/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

/obj/item/clothing/glasses/update_icon()
	if(!deactive_state || active)
		icon_state = initial(icon_state)
	else
		icon_state = deactive_state
	..()

/obj/item/clothing/glasses/proc/can_use_active_effect(var/mob/living/carbon/human/user)
	if(req_skill && req_skill_level && !(!req_skill_explicit && skillcheck(user, req_skill, req_skill_level)) && !(req_skill_explicit && skillcheckexplicit(user, req_skill, req_skill_level)))
		return FALSE
	else
		return TRUE

/obj/item/clothing/glasses/proc/toggle_glasses_effect()
	active = !active
	update_icon()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.glasses == src)
			if(has_tint)
				H.update_tint()
			H.update_sight()
			H.update_glass_vision(src)
			update_clothing_icon()

			if(hud_type)
				var/datum/mob_hud/MH = huds[hud_type]
				if(active)
					MH.add_hud_to(H)
					playsound(H, 'sound/handling/hud_on.ogg', 25, 1)
				else
					MH.remove_hud_from(H)
					playsound(H, 'sound/handling/hud_off.ogg', 25, 1)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/glasses/equipped(mob/user, slot)
	if(active)
		if(!can_use_active_effect(user))
			toggle_glasses_effect()
			to_chat(user, SPAN_WARNING("You have no idea what any of the data means and power it off before it makes you nauseated."))

		else if(hud_type && slot == WEAR_EYES)
			var/datum/mob_hud/MH = huds[hud_type]
			MH.add_hud_to(user)
	..()

/obj/item/clothing/glasses/dropped(mob/living/carbon/human/user)
	if(hud_type && active && istype(user))
		if(src == user.glasses) //dropped is called before the inventory reference is updated.
			var/datum/mob_hud/H = huds[hud_type]
			H.remove_hud_from(user)
	..()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(!toggleable)
		return

	if(!can_use_active_effect(user))
		to_chat(user, SPAN_WARNING("You have no idea how to use [src]."))
		return

	if(active)
		to_chat(user, SPAN_NOTICE("You deactivate the optical matrix on [src]."))
		playsound_client(user.client, toggle_off_sound, null, 75)
	else
		to_chat(user, SPAN_NOTICE("You activate the optical matrix on [src]."))
		playsound_client(user.client, toggle_on_sound, null, 75)

	toggle_glasses_effect()


/obj/item/clothing/glasses/science
	name = "weird science goggles"
	desc = "These goggles are probably of use to someone who isn't holding a rifle and actively seeking to lower their combat life expectancy."
	icon_state = "purple"
	item_state = "glasses"

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Once worn by swashbucklers of old, now more commonly associated with a figure of legend. They say he was big AND a boss. Impressive no? Don't let the MPs see you wearing this non-regulation attire."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "With these you can see objects... just like you can with your un-aided eyes. Say why were these ever made again?"
	icon_state = "material"
	item_state = "glasses"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE

/obj/item/clothing/glasses/regular
	name = "Marine RPG glasses"
	desc = "The Corps may call them Regulation Prescription Glasses but you know them as Rut Prevention Glasses."
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = TRUE
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/regular/hipster
	name = "Sunglasses"
	desc = "They cut the sun and keep things fun. Why would you ever wear these indoors, or on a night operation. Are you trying to get yourself hurt?"
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state = "3d"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/mgoggles
	name = "marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes."
	icon_state = "mgoggles"
	item_state = "mgoggles"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/mgoggles/prescription
	name = "prescription marine ballistic goggles"
	desc = "Standard issue USCM goggles. Mostly used to decorate one's helmet. Contains prescription lenses in case you weren't sure if they were lame or not."
	icon_state = "mgoggles"
	item_state = "mgoggles"
	prescription = 1
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/mbcg
	name = "Prescription Marine RPG glasses"
	desc = "The Corps may call them Regulation Prescription Glasses but you know them as Rut Prevention Glasses. These ones actually have a proper prescribed lens."
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = 1
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/m42_goggles
	name = "\improper M42 scout sight"
	desc = "A headset and goggles system for the M42 Scout Rifle. Allows highlighted imaging of surroundings. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle)



//welding goggles

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	deactive_state = "welding-gup"
	actions_types = list(/datum/action/item_action/toggle)
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEYES
	eye_protection = 2
	has_tint = TRUE

/obj/item/clothing/glasses/welding/attack_self()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
		if(active)
			active = 0
			flags_inventory &= ~COVEREYES
			flags_inv_hide &= ~HIDEEYES
			flags_armor_protection &= ~BODY_FLAG_EYES
			update_icon()
			eye_protection = 0
			to_chat(usr, "You push [src] up out of your face.")
		else
			active = 1
			flags_inventory |= COVEREYES
			flags_inv_hide |= HIDEEYES
			flags_armor_protection |= BODY_FLAG_EYES
			update_icon()
			eye_protection = initial(eye_protection)
			to_chat(usr, "You flip [src] down to protect your eyes.")


		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.glasses == src)
				H.update_tint()

		update_clothing_icon()

		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"

//sunglasses

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	//vision_flags = BLIND  	// This flag is only supposed to be used if it causes permanent blindness, not temporary because of glasses

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 1
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviator shades"
	desc = "A pair of tan tinted sunglasses. You can faintly hear 80's music playing while wearing these."
	icon_state = "aviator"
	item_state = "aviator"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/sechud
	name = "Security HUD-Glasses"
	desc = "Sunglasses wired up with the best nano-tech the USCM can muster out on the frontier. Displays information about any person you decree worthy of your gaze."
	icon_state = "sunhud"
	eye_protection = 1
	hud_type = MOB_HUD_SECURITY_ADVANCED

/obj/item/clothing/glasses/sunglasses/sechud/eyepiece
	name = "Security HUD Sight"
	desc = "A standard eyepiece, but modified to display security information to the user visually. This makes it commonplace among military police, though other models exist."
	icon_state = "securityhud"
	item_state = "securityhud"
	eye_protection = 1


/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical SWAT HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"
