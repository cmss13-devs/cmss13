/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/items/clothing/glasses.dmi'
	w_class = SIZE_SMALL
	var/vision_flags = 0
	var/darkness_view = 0 //Base human is 2
	/// The amount of nightvision these glasses have. This should be a number between 0 and 1.
	var/lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
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

/obj/item/clothing/glasses/Initialize(mapload, ...)
	. = ..()
	if(prescription)
		AddElement(/datum/element/poor_eyesight_correction)

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	var/item_state_slot_state = LAZYACCESS(item_state_slots, slot)
	if(item_state_slot_state)
		return item_state_slot_state
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
	clothing_traits_active = !clothing_traits_active
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
			if(active) //turning it on? then add the traits
				for(var/trait in clothing_traits)
					ADD_TRAIT(H, trait, TRAIT_SOURCE_EQUIPMENT(flags_equip_slot))
			else //turning it off - take away its traits
				for(var/trait in clothing_traits)
					REMOVE_TRAIT(H, trait, TRAIT_SOURCE_EQUIPMENT(flags_equip_slot))

	for(var/X in actions)
		var/datum/action/A = X
		if(istype(A, /datum/action/item_action/toggle))
			A.update_button_icon()

/obj/item/clothing/glasses/equipped(mob/user, slot)
	if(active && slot == WEAR_EYES)
		if(!can_use_active_effect(user))
			toggle_glasses_effect()
			to_chat(user, SPAN_WARNING("You have no idea what any of the data means and power it off before it makes you nauseated."))

		else if(hud_type)
			var/datum/mob_hud/MH = huds[hud_type]
			MH.add_hud_to(user)
	user.update_sight()
	..()

/obj/item/clothing/glasses/dropped(mob/living/carbon/human/user)
	if(hud_type && active && istype(user))
		if(src == user.glasses) //dropped is called before the inventory reference is updated.
			var/datum/mob_hud/H = huds[hud_type]
			H.remove_hud_from(user)
			user.glasses = null
			user.update_inv_glasses()
	user.update_sight()
	return ..()

/obj/item/clothing/glasses/attack_self(mob/user)
	..()

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
	name = "reagent scanner HUD goggles" //science goggles
	desc = "These goggles are probably of use to someone who isn't holding a rifle and actively seeking to lower their combat life expectancy."
	icon_state = "purple"
	item_state = "glasses"
	deactive_state = "purple_off"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE
	flags_inventory = COVEREYES
	req_skill = SKILL_RESEARCH
	req_skill_level = SKILL_RESEARCH_TRAINED
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/science/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("While wearing them, you can examine items to see their reagent contents.")

/obj/item/clothing/glasses/kutjevo
	name = "kutjevo goggles"
	desc = "Goggles used to shield the eyes of workers on Kutjevo. N95Z Rated Goggles."
	icon_state = "kutjevo_goggles"
	item_state = "kutjevo_goggles"

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
	desc = "A long time ago, people used these glasses to makes images from screens three-dimensional."
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

/obj/item/clothing/glasses/jensen
	name = "Augmented sunglasses"
	desc = "Augmented sunglasses with the HUD removed"
	icon_state = "jensenshades"
	item_state = "jensenshades"
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

/obj/item/clothing/glasses/disco_fever
	name = "malfunctioning AR visor"
	desc = "Someone tried to watch a black-market Arcturian blue movie on this augmented-reality headset and now it's useless. Unlike you, Disco will never die.\nThere's some kind of epilepsy warning sticker on the side."
	icon_state = "discovision"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

	//These three vars are so that the flashing of the obj and onmob match what the wearer is seeing. They're actually vis_contents rather than overlays,
	//strictly speaking, since overlays can't be animate()-ed.
	var/list/onmob_colors
	var/obj/obj_glass_overlay
	var/obj/mob_glass_overlay

/obj/item/clothing/glasses/disco_fever/Initialize(mapload, ...)
	. = ..()

	obj_glass_overlay = new()
	obj_glass_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_ICON
	obj_glass_overlay.icon_state = "discovision_glass"
	obj_glass_overlay.layer = FLOAT_LAYER
	vis_contents += obj_glass_overlay

	mob_glass_overlay = new()
	mob_glass_overlay.icon = icon
	mob_glass_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	mob_glass_overlay.icon_state = "discovision_glass_onmob"
	mob_glass_overlay.layer = FLOAT_LAYER

	//The overlays are painted in shades of pure red. These matrices convert them to various shades of the new colour.
	onmob_colors = list(
		"base" = color_matrix_recolor_red("#5D5D5D"),
		"yellow" = color_matrix_recolor_red("#D4C218"),
		"green" = color_matrix_recolor_red("#0DB347"),
		"cyan" = color_matrix_recolor_red("#2AC1DB"),
		"blue" = color_matrix_recolor_red("#005BF7"),
		"indigo" = color_matrix_recolor_red("#9608D4"),
		)

	obj_glass_overlay.color = onmob_colors["base"]
	mob_glass_overlay.color = onmob_colors["base"]

/obj/item/clothing/glasses/disco_fever/equipped(mob/living/carbon/human/user, slot)
	. = ..()

	if(!ishuman(user) || slot != WEAR_EYES && slot != WEAR_FACE)
		return

	RegisterSignal(user, COMSIG_MOB_RECALCULATE_CLIENT_COLOR, .proc/apply_discovision_handler)
	apply_discovision_handler(user)

	//Add the onmob overlay. Normal onmob images are handled by static overlays.
	//It's added to the head object so that glasses/mask overlays on the mob render above it, since vis_contents and overlays appear to use different layerings.
	var/obj/limb/head/user_head = user.get_limb("head")
	user_head?.vis_contents += mob_glass_overlay

///Ends existing animations in preparation for the funny. Looping animations don't seem to properly end if a new one is started on the same tick.
/obj/item/clothing/glasses/disco_fever/proc/apply_discovision_handler(mob/user)
	SIGNAL_HANDLER

	//User client has its looping animation ended by the login matrix update when ghosting.
	//For some reason the obj overlay doesn't end the loop properly when set to 0 seconds, but as long as the previous loop is ended the new one should
	//transition smoothly from whatever colour it current has.
	animate(obj_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)
	animate(mob_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)

	addtimer(CALLBACK(src, .proc/apply_discovision, user), 0.1 SECONDS)

///Handles disco-vision. Normal client colour matrix handling isn't set up for a continuous animation like this, so this is applied afterwards.
/obj/item/clothing/glasses/disco_fever/proc/apply_discovision(mob/user)
	//Caramelldansen HUD overlay.
	//Use of this filter in armed conflict is in direct contravention of the Geneva Suggestions (2120 revision)
	//Colours are based on a bit of the music video. Original version was a rainbow with #c20000 and #db6c03 as well.

	//Animate the obj and onmob in sync with the client.
	for(var/I in list(obj_glass_overlay, mob_glass_overlay))
		animate(I, color = onmob_colors["indigo"], time = 0.3 SECONDS, loop = -1)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["cyan"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["yellow"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["green"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["blue"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["yellow"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)

	if(!user.client) //Shouldn't happen but can't hurt to check.
		return

	var/base_colour
	if(!user.client.color) //No set client colour.
		base_colour = color_matrix_saturation(1.35) //Crank up the saturation and get ready to party.
	else if(istext(user.client.color)) //Hex colour string.
		base_colour = color_matrix_multiply(color_matrix_from_string(user.client.color), color_matrix_saturation(1.35))
	else //Colour matrix.
		base_colour = color_matrix_multiply(user.client.color, color_matrix_saturation(1.35))

	var/list/colours = list(
		"yellow" = color_matrix_multiply(base_colour, color_matrix_from_string("#d4c218")),
		"green" = color_matrix_multiply(base_colour, color_matrix_from_string("#2dc404")),
		"cyan" = color_matrix_multiply(base_colour, color_matrix_from_string("#2ac1db")),
		"blue" = color_matrix_multiply(base_colour, color_matrix_from_string("#005BF7")),
		"indigo" = color_matrix_multiply(base_colour, color_matrix_from_string("#b929f7"))
		)

	//Animate the victim's client.
	animate(user.client, color = colours["indigo"], time = 0.3 SECONDS, loop = -1)
	animate(color = base_colour, time = 0.3 SECONDS)
	animate(color = colours["cyan"], time = 0.3 SECONDS)
	animate(color = base_colour, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colour, time = 0.3 SECONDS)
	animate(color = colours["green"], time = 0.3 SECONDS)
	animate(color = base_colour, time = 0.3 SECONDS)
	animate(color = colours["blue"], time = 0.3 SECONDS)
	animate(color = base_colour, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colour, time = 0.3 SECONDS)

/obj/item/clothing/glasses/disco_fever/dropped(mob/living/carbon/human/user)
	. = ..()

	if(!ishuman(user))
		return

	UnregisterSignal(user, COMSIG_MOB_RECALCULATE_CLIENT_COLOR)

	animate(obj_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)
	animate(mob_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)

	user.update_client_color_matrices(0.3 SECONDS)
	var/obj/limb/head/user_head = user.get_limb("head")
	user_head?.vis_contents -= mob_glass_overlay

/obj/item/clothing/glasses/mgoggles
	name = "marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes."
	icon_state = "mgoggles"
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	var/activated = FALSE
	var/active_icon_state = "mgoggles_down"
	var/inactive_icon_state = "mgoggles"

	var/datum/action/item_action/activation
	var/obj/item/attached_item
	garbage = FALSE

/obj/item/clothing/glasses/mgoggles/prescription
	name = "prescription marine ballistic goggles"
	desc = "Standard issue USCM goggles. Mostly used to decorate one's helmet. Contains prescription lenses in case you weren't sure if they were lame or not."
	icon_state = "mgoggles"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/black
	name = "black marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has black tinted lenses."
	icon_state = "mgogglesblk"
	active_icon_state = "mgogglesblk_down"
	inactive_icon_state = "mgogglesblk"

/obj/item/clothing/glasses/mgoggles/orange
	name = "orange marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has amber colored day lenses."
	icon_state = "mgogglesorg"
	active_icon_state = "mgogglesorg_down"
	inactive_icon_state = "mgogglesorg"

/obj/item/clothing/glasses/mgoggles/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S))
		return

	remove_attached_item()

	attached_item = S.master_object
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, .proc/remove_attached_item)
	RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, .proc/wear_check)
	activation = new /datum/action/item_action/toggle(src, S.master_object)

	if(ismob(S.master_object.loc))
		activation.give_to(S.master_object.loc)

/obj/item/clothing/glasses/mgoggles/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()

/obj/item/clothing/glasses/mgoggles/proc/remove_attached_item()
	SIGNAL_HANDLER
	if(!attached_item)
		return

	UnregisterSignal(attached_item, COMSIG_PARENT_QDELETING)
	qdel(activation)
	attached_item = null

/obj/item/clothing/glasses/mgoggles/ui_action_click(var/mob/owner, var/obj/item/holder)
	toggle_goggles(owner)
	activation.update_button_icon()

/obj/item/clothing/glasses/mgoggles/proc/wear_check(var/obj/item/I, var/mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_HEAD && prescription == TRUE && activated)
		ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription)) //Checks if dropped/unequipped for prescription.
	else
		REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription)) //Looks messy but potential for adding other cases for goggle types other than prescription in the future such as welding or helmet HUD attachments.

/obj/item/clothing/glasses/mgoggles/proc/toggle_goggles(mob/living/carbon/human/user)
	if(user.is_mob_incapacitated())
		return

	if(!attached_item)
		return

	activated = !activated
	if(activated)
		to_chat(user, SPAN_NOTICE("You pull the goggles down."))
		icon_state = active_icon_state
		if(prescription == TRUE && user.head == attached_item)
			ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))
	else
		to_chat(user, SPAN_NOTICE("You push the goggles up."))
		icon_state = inactive_icon_state
		if(prescription == TRUE)
			REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))

	attached_item.update_icon()

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
	vision_impair = VISION_IMPAIR_MAX
	var/vision_impair_on = VISION_IMPAIR_MAX
	var/vision_impair_off = VISION_IMPAIR_NONE

/obj/item/clothing/glasses/welding/attack_self()
	..()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
		if(active)
			active = 0
			vision_impair = vision_impair_off
			flags_inventory &= ~COVEREYES
			flags_inv_hide &= ~HIDEEYES
			flags_armor_protection &= ~BODY_FLAG_EYES
			update_icon()
			eye_protection = 0
			to_chat(usr, "You push [src] up out of your face.")
		else
			active = 1
			vision_impair = vision_impair_on
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
			if(istype(A, /datum/action/item_action/toggle))
				A.update_button_icon()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	vision_impair = VISION_IMPAIR_WEAK
	vision_impair_on = VISION_IMPAIR_WEAK
	vision_impair_off = VISION_IMPAIR_NONE

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
	//vision_flags = DISABILITY_BLIND  	// This flag is only supposed to be used if it causes permanent blindness, not temporary because of glasses

/obj/item/clothing/glasses/sunglasses/prescription
	desc = "A mixture of coolness and the inherent nerdiness of a prescription. Somehow manages to conceal both."
	name = "prescription sunglasses"
	prescription = TRUE
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/big
	name = "shades"
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

/obj/item/clothing/glasses/sunglasses/sechud/prescription
	name = "Prescription Security HUD-Glasses"
	desc = "Sunglasses wired up with the best nano-tech the USCM can muster out on the frontier. Displays information about any person you decree worthy of your gaze. Contains prescription lenses."
	prescription = TRUE

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
