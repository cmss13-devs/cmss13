/obj/item/clothing/glasses
	name = "glasses"
	gender = PLURAL
	icon = 'icons/obj/items/clothing/glasses/glasses.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)
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

/obj/item/clothing/glasses/proc/can_use_active_effect(mob/living/carbon/human/user)
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
				var/datum/mob_hud/MH = GLOB.huds[hud_type]
				if(active)
					MH.add_hud_to(H, src)
					playsound(H, 'sound/handling/hud_on.ogg', 25, 1)
				else
					MH.remove_hud_from(H, src)
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

/obj/item/clothing/glasses/proc/try_make_offhand_prescription(mob/user)
	if(!prescription)
		return FALSE

	var/obj/item/clothing/glasses/offhand = user.get_inactive_hand()
	if(istype(offhand) && !offhand.prescription)
		if(tgui_alert(user, "Do you wish to take out the prescription lenses and put them in [offhand]?", "Insert Prescription Lenses", list("Yes", "No")) == "Yes")
			if(QDELETED(src) || offhand != user.get_inactive_hand())
				return FALSE
			offhand.prescription = TRUE
			offhand.AddElement(/datum/element/poor_eyesight_correction)
			offhand.desc += " Fitted with prescription lenses."
			user.visible_message(SPAN_DANGER("[user] takes the lenses out of [src] and puts them in [offhand]."), SPAN_NOTICE("You take the lenses out of [src] and put them in [offhand]."))
			qdel(src)
			return TRUE

	return FALSE

/obj/item/clothing/glasses/sunglasses/prescription/attack_self(mob/user)
	if(try_make_offhand_prescription(user))
		return

	return ..()

/obj/item/clothing/glasses/regular/attack_self(mob/user)
	if(try_make_offhand_prescription(user))
		return

	return ..()

/obj/item/clothing/glasses/equipped(mob/user, slot)
	if(active && slot == WEAR_EYES)
		if(!can_use_active_effect(user))
			toggle_glasses_effect()
			to_chat(user, SPAN_WARNING("You have no idea what any of the data means and power it off before it makes you nauseated."))

		else if(hud_type)
			var/datum/mob_hud/MH = GLOB.huds[hud_type]
			MH.add_hud_to(user, src)
	user.update_sight()
	..()

/obj/item/clothing/glasses/dropped(mob/living/carbon/human/user)
	if(istype(user) && src == user.glasses)
		if(hud_type && active)
			var/datum/mob_hud/H = GLOB.huds[hud_type]
			H.remove_hud_from(user, src)
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
	icon = 'icons/obj/items/clothing/glasses/huds.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/huds.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
	)
	icon_state = "purple"
	item_state = "glasses"
	deactive_state = "purple_off"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE
	flags_inventory = COVEREYES
	req_skill = SKILL_RESEARCH
	req_skill_level = SKILL_RESEARCH_TRAINED
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/science/prescription
	name = "prescription reagent scanner HUD goggles"
	desc = "These goggles are probably of use to someone who isn't holding a rifle and actively seeking to lower their combat life expectancy. Contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/science/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("While wearing them, you can examine items to see their reagent contents.")

/obj/item/clothing/glasses/kutjevo
	name = "kutjevo goggles"
	desc = "Goggles used to shield the eyes of workers on Kutjevo. N95Z Rated Goggles."
	icon = 'icons/obj/items/clothing/glasses/goggles.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
	)
	icon_state = "kutjevo_goggles"
	item_state = "kutjevo_goggles"

/obj/item/clothing/glasses/kutjevo/safety
	name = "safety goggles"
	desc = "Goggles used to shield the eyes of workers. N95Z Rated."

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	gender = NEUTER
	desc = "Once worn by swashbucklers of old, now more commonly associated with a figure of legend. They say he was big AND a boss. Impressive no? Don't let the MPs see you wearing this non-regulation attire."
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)
	icon_state = "eyepatch"
	item_state = "eyepatch"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB
	var/toggled = FALSE
	var/original_state = "eyepatch"
	var/toggled_state = "eyepatch_left"
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/eyepatch/ui_action_click()
	toggle_state()

/obj/item/clothing/glasses/eyepatch/verb/toggle_state()
	set name = "Toggle Eyepatch State"
	set category = "Object"
	set src in usr
	if(usr.stat == DEAD)
		return

	toggled = !toggled
	if(toggled)
		icon_state = toggled_state
		item_state = toggled_state
		to_chat(usr, SPAN_NOTICE("You flip the eyepatch to the left side."))
	else
		icon_state = original_state
		item_state = original_state
		to_chat(usr, SPAN_NOTICE("You flip the eyepatch to the right side."))

	update_clothing_icon(src) // Updates the on-mob appearance

/obj/item/clothing/glasses/eyepatch/left
	parent_type = /obj/item/clothing/glasses/eyepatch
	icon_state = "eyepatch_left"
	item_state = "eyepatch_left"
	original_state = "eyepatch"
	toggled_state = "eyepatch_left"

/obj/item/clothing/glasses/eyepatch/white
	icon_state = "eyepatch_white"
	item_state = "eyepatch_white"
	original_state = "eyepatch_white"
	toggled_state = "eyepatch_white_left"

/obj/item/clothing/glasses/eyepatch/white/left
	parent_type = /obj/item/clothing/glasses/eyepatch/white
	icon_state = "eyepatch_white_left"
	item_state = "eyepatch_white_left"

/obj/item/clothing/glasses/eyepatch/green
	icon_state = "eyepatch_green"
	item_state = "eyepatch_green"
	original_state = "eyepatch_green"
	toggled_state = "eyepatch_green_left"

/obj/item/clothing/glasses/eyepatch/green/left
	parent_type = /obj/item/clothing/glasses/eyepatch/green
	icon_state = "eyepatch_green_left"
	item_state = "eyepatch_green_left"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	gender = NEUTER
	desc = "Such a dapper eyepiece!"
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	icon_state = "monocle"
	item_state = "headset" // lol
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/material
	name = "Optical Material Scanners"
	desc = "With these you can see objects... just like you can with your un-aided eyes. Say why were these ever made again?"
	icon = 'icons/obj/items/clothing/glasses/goggles.dmi'
	icon_state = "material"
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
	)
	item_state = "glasses"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE

/obj/item/clothing/glasses/regular
	name = "Marine RPG glasses"
	desc = "The Corps may call them Regulation Prescription Glasses but you know them as Rut Prevention Glasses."
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
	)
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = TRUE
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	desc = "Boring glasses, makes you look smart and potentially reputable."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/regular/hippie
	name = "Rounded Prescription Glasses"
	desc = "Rounded glasses, makes you look smart and potentially reputable."
	icon_state = "hippie_glasses"
	item_state = "hippie_glasses"
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
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
	)
	icon_state = "jensenshades"
	item_state = "jensenshades"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/mbcg
	name = "Prescription Marine RPG glasses"
	desc = "The Corps may call them Regulation Prescription Glasses but you know them as Rut Prevention Glasses. These ones actually have a proper prescribed lens."
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = TRUE
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/m42_goggles
	name = "\improper M42 scout sight"
	desc = "A headset and goggles system for the M42 Scout Rifle. Allows highlighted imaging of surroundings. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses/night_vision.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/night_vision.dmi',
	)
	icon_state = "m56_goggles"
	gender = NEUTER
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/disco_fever
	name = "malfunctioning AR visor"
	desc = "Someone tried to watch a black-market Arcturian blue movie on this augmented-reality headset and now it's useless. Unlike you, Disco will never die.\nThere's some kind of epilepsy warning sticker on the side."
	icon_state = "discovision"
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
	)
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	gender = NEUTER
	black_market_value = 25

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
	mob_glass_overlay.icon = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi'
	mob_glass_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	mob_glass_overlay.icon_state = "discovision_glass"
	mob_glass_overlay.layer = FLOAT_LAYER

	//The overlays are painted in shades of pure red. These matrices convert them to various shades of the new color.
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

	RegisterSignal(user, COMSIG_MOB_RECALCULATE_CLIENT_COLOR, PROC_REF(apply_discovision_handler))
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
	//transition smoothly from whatever color it current has.
	animate(obj_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)
	animate(mob_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(apply_discovision), user), 0.1 SECONDS)

///Handles disco-vision. Normal client color matrix handling isn't set up for a continuous animation like this, so this is applied afterwards.
/obj/item/clothing/glasses/disco_fever/proc/apply_discovision(mob/user)
	//Caramelldansen HUD overlay.
	//Use of this filter in armed conflict is in direct contravention of the Geneva Suggestions (2120 revision)
	//Colors are based on a bit of the music video. Original version was a rainbow with #c20000 and #db6c03 as well.

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

	if(!user.client.prefs?.allow_flashing_lights_pref)
		to_chat(user, SPAN_NOTICE("Your preferences don't allow the effect from [src]."))
		return

	var/base_colors
	if(!user.client.color) //No set client color.
		base_colors = color_matrix_saturation(1.35) //Crank up the saturation and get ready to party.
	else if(istext(user.client.color)) //Hex color string.
		base_colors = color_matrix_multiply(color_matrix_from_string(user.client.color), color_matrix_saturation(1.35))
	else //Color matrix.
		base_colors = color_matrix_multiply(user.client.color, color_matrix_saturation(1.35))

	var/list/colours = list(
		"yellow" = color_matrix_multiply(base_colors, color_matrix_from_string("#d4c218")),
		"green" = color_matrix_multiply(base_colors, color_matrix_from_string("#2dc404")),
		"cyan" = color_matrix_multiply(base_colors, color_matrix_from_string("#2ac1db")),
		"blue" = color_matrix_multiply(base_colors, color_matrix_from_string("#005BF7")),
		"indigo" = color_matrix_multiply(base_colors, color_matrix_from_string("#b929f7"))
		)

	//Animate the victim's client.
	animate(user.client, color = colours["indigo"], time = 0.3 SECONDS, loop = -1)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["cyan"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["green"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["blue"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)

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
	icon = 'icons/obj/items/clothing/glasses/goggles.dmi'
	icon_state = "mgoggles"
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/goggles.dmi',
	)
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB
	eye_protection = EYE_PROTECTION_FLAVOR
	var/activated = FALSE
	var/active_icon_state = "mgoggles_down"
	var/inactive_icon_state = "mgoggles"

	var/datum/action/item_action/activation
	var/obj/item/attached_item
	var/message_up = "You push the goggles up."
	var/message_down = "You pull the goggles down."
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

/obj/item/clothing/glasses/mgoggles/black/prescription
	name = "prescription black marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has black tinted lenses. ntop of that, these ones contain prescription lenses."
	icon_state = "mgogglesblk"
	active_icon_state = "mgogglesblk_down"
	inactive_icon_state = "mgogglesblk"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/orange
	name = "orange marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has amber colored day lenses."
	icon_state = "mgogglesorg"
	active_icon_state = "mgogglesorg_down"
	inactive_icon_state = "mgogglesorg"

/obj/item/clothing/glasses/mgoggles/orange/prescription
	name = "prescription orange marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has amber colored day lenses."
	icon_state = "mgogglesorg"
	active_icon_state = "mgogglesorg_down"
	inactive_icon_state = "mgogglesorg"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/v2
	name = "M1A1 marine ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger lenses."
	icon_state = "mgoggles2"
	active_icon_state = "mgoggles2_down"
	inactive_icon_state = "mgoggles2"

/obj/item/clothing/glasses/mgoggles/v2/prescription
	name = "prescription M1A1 marine ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger lenses."
	icon_state = "mgoggles2"
	active_icon_state = "mgoggles2_down"
	inactive_icon_state = "mgoggles2"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/red
	name = "red marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has scarlet colored day lenses."
	icon_state = "mgogglesred"
	active_icon_state = "mgogglesred_down"
	inactive_icon_state = "mgogglesred"

/obj/item/clothing/glasses/mgoggles/red/prescription
	name = "prescription red marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has scarlet colored day lenses."
	icon_state = "mgogglesred"
	active_icon_state = "mgogglesred_down"
	inactive_icon_state = "mgogglesred"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/blue
	name = "blue marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has blue colored day lenses."
	icon_state = "mgogglesblue"
	active_icon_state = "mgogglesblue_down"
	inactive_icon_state = "mgogglesblue"

/obj/item/clothing/glasses/mgoggles/blue/prescription
	name = "prescription blue marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has blue colored day lenses."
	icon_state = "mgogglesblue"
	active_icon_state = "mgogglesblue_down"
	inactive_icon_state = "mgogglesblue"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/purple
	name = "purple marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has purple colored day lenses."
	icon_state = "mgogglespurple"
	active_icon_state = "mgogglespurple_down"
	inactive_icon_state = "mgogglespurple"

/obj/item/clothing/glasses/mgoggles/purple/prescription
	name = "prescription purple marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has purple colored day lenses."
	icon_state = "mgogglespurple"
	active_icon_state = "mgogglespurple_down"
	inactive_icon_state = "mgogglespurple"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/yellow
	name = "yellow marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has yellow colored day lenses."
	icon_state = "mgogglesyellow"
	active_icon_state = "mgogglesyellow_down"
	inactive_icon_state = "mgogglesyellow"

/obj/item/clothing/glasses/mgoggles/yellow/prescription
	name = "prescription yellow marine ballistic goggles"
	desc = "Standard issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This one has yellow colored day lenses."
	icon_state = "mgogglesyellow"
	active_icon_state = "mgogglesyellow_down"
	inactive_icon_state = "mgogglesyellow"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/v2/blue
	name = "M1A1 marine ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger lenses."
	icon_state = "m2gogglesblue"
	active_icon_state = "m2gogglesblue_down"
	inactive_icon_state = "m2gogglesblue"

/obj/item/clothing/glasses/mgoggles/v2/blue/prescription
	name = "prescription M1A1 marine ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger lenses."
	icon_state = "m2gogglesblue"
	active_icon_state = "m2gogglesblue_down"
	inactive_icon_state = "m2gogglesblue"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/v2/polarized_blue
	name = "M1A1 marine polarized ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger polarized lenses."
	icon_state = "polarizedblue"
	active_icon_state = "polarizedblue_down"
	inactive_icon_state = "polarizedblue"

/obj/item/clothing/glasses/mgoggles/v2/polarized_blue/prescription
	name = "prescription M1A1 marine polarized ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger polarized lenses."
	icon_state = "polarizedblue"
	active_icon_state = "polarizedblue_down"
	inactive_icon_state = "polarizedblue"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/v2/polarized_orange
	name = "M1A1 marine polarized ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger polarized lenses."
	icon_state = "polarizedorange"
	active_icon_state = "polarizedorange_down"
	inactive_icon_state = "polarizedorange"

/obj/item/clothing/glasses/mgoggles/v2/polarized_orange/prescription
	name = "prescription M1A1 marine polarized ballistic goggles"
	desc = "Newer issue USCM goggles. While commonly found mounted atop M10 pattern helmets, they are also capable of preventing insects, dust, and other things from getting into one's eyes. This version has larger polarized lenses."
	icon_state = "polarizedorange"
	active_icon_state = "polarizedorange_down"
	inactive_icon_state = "polarizedorange"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S))
		return

	remove_attached_item()

	attached_item = S.master_object
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, PROC_REF(wear_check))
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
	UnregisterSignal(attached_item, COMSIG_ITEM_EQUIPPED)
	qdel(activation)
	attached_item = null

/obj/item/clothing/glasses/mgoggles/ui_action_click(mob/owner, obj/item/holder)
	toggle_goggles(owner)
	activation.update_button_icon()

/obj/item/clothing/glasses/mgoggles/proc/wear_check(obj/item/I, mob/living/carbon/human/user, slot)
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
		to_chat(user, SPAN_NOTICE(message_down))
		icon_state = active_icon_state
		if(prescription == TRUE && user.head == attached_item)
			ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))
	else
		to_chat(user, SPAN_NOTICE(message_up))
		icon_state = inactive_icon_state
		if(prescription == TRUE)
			REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))

	attached_item.update_icon()

/obj/item/clothing/glasses/mgoggles/cmb_riot_shield
	name = "\improper TC2 CMB riot shield"
	desc = "Yellowish protective glass piece, can be lifted up when needed, makes you see everything in yellow."
	icon_state = "swat_shield"
	icon = 'icons/obj/items/clothing/helmet_garb.dmi'
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/visors.dmi',
	)
	active_icon_state = "swat_shield"
	inactive_icon_state = "swat_shield_up"
	activated = TRUE
	message_up = "You lift the visor up."
	message_down = "You lower the visor down."
	flags_equip_slot = null

//welding goggles

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon = 'icons/obj/items/clothing/glasses/goggles.dmi'
	icon_state = "welding-g"
	item_state = "welding-g"
	deactive_state = "welding-gup"
	item_state_slots = list(WEAR_AS_GARB = "welding-h")
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/goggles.dmi',
	)
	actions_types = list(/datum/action/item_action/toggle)
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEYES
	eye_protection = EYE_PROTECTION_WELDING
	has_tint = TRUE
	vision_impair = VISION_IMPAIR_ULTRA
	var/vision_impair_on = VISION_IMPAIR_ULTRA
	var/vision_impair_off = VISION_IMPAIR_NONE

/obj/item/clothing/glasses/welding/attack_self()
	..()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(active)
		active = 0
		vision_impair = vision_impair_off
		flags_inventory &= ~COVEREYES
		flags_inv_hide &= ~HIDEEYES
		flags_armor_protection &= ~BODY_FLAG_EYES
		update_icon()
		eye_protection = EYE_PROTECTION_NONE
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

/obj/item/clothing/glasses/welding/superior/prescription
	desc = "Welding goggles made from more expensive materials. There are barely visible prescription lenses connected to the frame, allowing vision even when the goggles are raised."
	prescription = TRUE

//sunglasses

/obj/item/clothing/glasses/sunglasses
	desc = "Generic off-brand eyewear, used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sun"
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)
	darkness_view = -1
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB
	eye_protection = EYE_PROTECTION_FLAVOR

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	gender = NEUTER
	desc = "Covers the eyes, preventing sight."
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)
	icon_state = "blindfold"
	item_state = "blindfold"
	vision_impair = VISION_IMPAIR_MAX

/obj/item/clothing/glasses/sunglasses/prescription
	desc = "A mixture of coolness and the inherent nerdiness of a prescription. Somehow manages to conceal both."
	name = "prescription sunglasses"
	prescription = TRUE
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/sunglasses/big
	name = "\improper BiMex personal shades"
	desc = "These are an expensive pair of BiMex sunglasses. This brand is popular with USCM foot sloggers because its patented mirror refraction has been said to offer protection from atomic flash, solar radiation, and targeting lasers. To top it all off, everyone seems to know a guy who knows a guy who knows a guy that had a laser pistol reflect off of his shades. BiMex came into popularity with the Marines after its 'Save the Colonies and Look Cool Doing It' ad campaign."
	icon_state = "bigsunglasses"
	item_state = "sunglasses"
	eye_protection = EYE_PROTECTION_FLASH
	clothing_traits = list(TRAIT_BIMEX)
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/sunglasses/big/fake
	name = "\improper BiMax personal shades"
	desc = "These are a bargain-bin pair of BiMex-style sunglasses—emphasis on the style."
	desc_lore = "Marketed as 'BiMax,' with an 'A' to sidestep copyright, these knockoffs are popular with penny-pinching spacers and wannabe badasses. While the real deal boasts patented mirror refraction for atomic flash, solar radiation, and targeting laser protection, these cut-rate imitations barely keep UV rays at bay. As for that famous story of a laser pistol reflecting off the originals? Good luck finding anyone who believes these could pull it off. But hey, they’re cheap, and their 'Save the Budget and Look Cool Doing It' slogan really sells it."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"
	eye_protection = FALSE
	clothing_traits = FALSE

/obj/item/clothing/glasses/sunglasses/big/fake/red
	icon_state = "bigsunglasses_red"
	item_state = "bigsunglasses_red"

/obj/item/clothing/glasses/sunglasses/big/fake/orange
	icon_state = "bigsunglasses_orange"
	item_state = "bigsunglasses_orange"

/obj/item/clothing/glasses/sunglasses/big/fake/yellow
	icon_state = "bigsunglasses_yellow"
	item_state = "bigsunglasses_yellow"

/obj/item/clothing/glasses/sunglasses/big/fake/green
	icon_state = "bigsunglasses_green"
	item_state = "bigsunglasses_green"

/obj/item/clothing/glasses/sunglasses/big/fake/blue
	icon_state = "bigsunglasses_blue"
	item_state = "bigsunglasses_blue"

// Hippie

/obj/item/clothing/glasses/sunglasses/hippie
	name = "\improper Suntex-Sightware rounded shades"
	desc = "Colorful, rounded shades from Suntex-Sightware, embraced by free spirits and those who march to the beat of their own drum. These vibrant, retro-inspired shades offer adequate protection against flashes while adding a touch of laid-back, bohemian style to any look."
	icon_state = "hippie_glasses_pink"
	item_state = "hippie_glasses_pink"

/obj/item/clothing/glasses/sunglasses/hippie/green
	icon_state = "hippie_glasses_green"
	item_state = "hippie_glasses_green"

/obj/item/clothing/glasses/sunglasses/hippie/sunrise
	icon_state = "hippie_glasses_sunrise"
	item_state = "hippie_glasses_sunrise"

/obj/item/clothing/glasses/sunglasses/hippie/sunset
	icon_state = "hippie_glasses_sunset"
	item_state = "hippie_glasses_sunset"

/obj/item/clothing/glasses/sunglasses/hippie/nightblue
	icon_state = "hippie_glasses_nightblue"
	item_state = "hippie_glasses_nightblue"

/obj/item/clothing/glasses/sunglasses/hippie/midnight
	icon_state = "hippie_glasses_midnight"
	item_state = "hippie_glasses_midnight"

/obj/item/clothing/glasses/sunglasses/hippie/bloodred
	icon_state = "hippie_glasses_bloodred"
	item_state = "hippie_glasses_bloodred"

/obj/item/clothing/glasses/sunglasses/big/new_bimex
	name = "\improper BiMex Polarized Shades"
	desc = "Sleek, angular shades designed for the modern operator."
	desc_lore = "BiMex's latest 'TactOptix' line comes with advanced polarization and lightweight ballistic lenses capable of shrugging off small shrapnel impacts. A favorite among frontline operators and deep-space scouts, these shades are marketed as 'combat-tested and action-approved.' Rumors abound of lucky users surviving close-range laser shots thanks to the multi-reflective lens coating, though BiMex's official stance is to 'Stop standing in front of lasers.'"
	icon_state = "bimex_polarized_yellow"
	item_state = "bimex_polarized_yellow"
	eye_protection = EYE_PROTECTION_FLASH
	clothing_traits = list(TRAIT_BIMEX)
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/sunglasses/big/new_bimex/black
	name = "\improper BiMex Tactical Shades"
	icon_state = "bimex_black"
	item_state = "bimex_black"

/obj/item/clothing/glasses/sunglasses/big/new_bimex/bronze
	icon_state = "bimex_polarized_bronze"
	item_state = "bimex_polarized_bronze"

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviator shades"
	desc = "A pair of tan tinted sunglasses. You can faintly hear 80's music playing while wearing these."
	icon_state = "aviator"
	item_state = "aviator"
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/sunglasses/aviator/silver
	name = "aviator shades"
	desc = "A pair of silver tinted sunglasses. You can faintly hear 80's music playing while wearing these."
	icon_state = "aviator_silver"
	item_state = "aviator_silver"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "Security HUD-Glasses"
	desc = "Sunglasses wired up with the best nano-tech the USCM can muster out on the frontier. Displays information about any person you decree worthy of your gaze."
	icon_state = "sunhud"
	eye_protection = EYE_PROTECTION_FLASH
	hud_type = MOB_HUD_SECURITY_ADVANCED
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/glasses/sunglasses/sechud/blue
	name = "Security HUD-Glasses"
	desc = "Sunglasses wired up with the best nano-tech the USCM can muster out on the frontier. Displays information about any person you decree worthy of your gaze."
	icon_state = "sunhud_blue"

/obj/item/clothing/glasses/sunglasses/sechud/prescription
	name = "Prescription Security HUD-Glasses"
	desc = "Sunglasses wired up with the best nano-tech the USCM can muster out on the frontier. Displays information about any person you decree worthy of your gaze. Contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical SWAT HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon = 'icons/obj/items/clothing/glasses/goggles.dmi'
	icon_state = "swatgoggles"
	gender = NEUTER
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/goggles.dmi',
	)
