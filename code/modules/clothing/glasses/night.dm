// nightvision goggles

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	toggle_on_sound = 'sound/handling/toggle_nv1.ogg'
	toggle_off_sound = 'sound/handling/toggle_nv2.ogg'
	darkness_view = 12
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	fullscreen_vision = /obj/screen/fullscreen/nvg

/obj/item/clothing/glasses/night/helmet //for the integrated NVGs that are in helmetgarb code
	name = "\improper M2 night vision goggles"
	desc = "The actual goggle part of the M2 night vision system."
	icon_state = "stub" //our actual icon is a part of our helmet.
	item_state = null
	vision_flags = SEE_TURFS
	darkness_view = 12
	flags_item = NODROP|DELONDROP|ITEM_ABSTRACT
	flags_inventory = CANTSTRIP

/obj/item/clothing/glasses/night/M4RA
	name = "\improper M4RA Battle sight"
	desc = "A headset and night vision goggles system for the M4RA Battle Rifle. Allows highlighted imaging of surroundings, as well as the ability to view the suit sensor health status readouts of other marines. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	hud_type = MOB_HUD_MEDICAL_BASIC
	darkness_view = 12
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/glasses/night/medhud
	name = "\improper Mark 4 Battle Medic sight"
	desc = "A headset and night vision goggles system for the M4RA Battle Rifle. Allows highlighted imaging of surroundings, as well as the ability to view the health statuses of others. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	darkness_view = 12
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/night/m42_night_goggles
	name = "\improper M42 scout sight"
	desc = "A headset and night vision goggles system for the M42 Scout Rifle. Allows highlighted imaging of surroundings. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	darkness_view = 12
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/glasses/night/m42_night_goggles/upp
	name = "\improper Type 9 commando goggles"
	desc = "A headset and night vision goggles system used by UPP forces. Allows highlighted imaging of surroundings. Click it to toggle."
	icon_state = "upp_goggles"
	deactive_state = "upp_goggles_0"
	req_skill = null
	req_skill_level = null

/obj/item/clothing/glasses/night/m56_goggles
	name = "\improper M56 head mounted sight"
	desc = "A headset and goggles system for the M56 Smartgun. Has a low-res short range imager, allowing for view of terrain."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	darkness_view = 5
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/m56_goggles/far_sight)
	vision_flags = SEE_TURFS
	fullscreen_vision = null
	req_skill = SKILL_SPEC_WEAPONS
	req_skill_level = SKILL_SPEC_SMARTGUN

	var/far_sight = FALSE
	var/powerpack = null

/obj/item/clothing/glasses/night/m56_goggles/Destroy()
	powerpack = null
	disable_far_sight()
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/proc/link_powerpack(var/mob/user)
	if(!QDELETED(user) && !QDELETED(user.back))
		if(istype(user.back, /obj/item/smartgun_powerpack))
			powerpack = user.back
			return TRUE
	return FALSE

/obj/item/clothing/glasses/night/m56_goggles/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!istype(H.back, /obj/item/smartgun_powerpack))
				to_chat(user, "You must be wearing an M56 Powerpack on your back to wear these.")
				return FALSE
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/equipped(mob/user, slot)
	if(slot != SLOT_EYES)
		disable_far_sight(user)
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/dropped(mob/living/carbon/human/user)
	disable_far_sight(user)
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/proc/set_far_sight(mob/living/carbon/human/user, var/set_to_state = TRUE)
	if(set_to_state)
		if(user.glasses != src)
			to_chat(user, SPAN_WARNING("You can't activate far sight without wearing \the [src]!"))
			return
		if(!link_powerpack(user))
			to_chat(user, SPAN_WARNING("You can't use this without a powerpack!"))
			return
		far_sight = TRUE
		if(user)
			if(user.client)
				user.client.change_view(8, src)
			to_chat(user, SPAN_NOTICE("You enable the far sight system."))
		START_PROCESSING(SSobj, src)
	else
		powerpack = null
		far_sight = FALSE
		if(user)
			if(user.client)
				user.client.change_view(world_view_size, src)
			to_chat(user, SPAN_NOTICE("You disable the far sight system."))
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/glasses/night/m56_goggles/proc/disable_far_sight(mob/living/carbon/human/user)
	if(!istype(user))
		user = loc
		if(!istype(user))
			user = null
	set_far_sight(user, FALSE)

/obj/item/clothing/glasses/night/m56_goggles/process(delta_time)
	var/mob/living/carbon/human/user = loc
	if(!istype(user))
		set_far_sight(null, FALSE)
		return PROCESS_KILL
	if(powerpack != user.back)
		set_far_sight(user, FALSE)
		return PROCESS_KILL
	var/obj/item/smartgun_powerpack/pp = user.back
	if(istype(pp))
		var/obj/item/cell/c = pp.pcell
		if(!pp.drain_powerpack(25 * delta_time, c))
			set_far_sight(user, FALSE)

/datum/action/item_action/m56_goggles/far_sight
	action_icon_state = "m56_goggles"

/datum/action/item_action/m56_goggles/far_sight/New()
	..()
	name = "Toggle Far Sight"
	button.name = name

/datum/action/item_action/m56_goggles/far_sight/action_activate()
	if(target)
		var/obj/item/clothing/glasses/night/m56_goggles/G = target
		G.set_far_sight(owner, !G.far_sight)

/obj/item/clothing/glasses/night/yautja
	name = "bio-mask nightvision"
	desc = "A vision overlay generated by the Bio-Mask. Used for low-light conditions."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "visor_nvg"
	item_state = "securityhud"
	darkness_view = 5 //Not quite as good as regular NVG.
	flags_inventory = COVEREYES
	flags_item = NODROP|DELONDROP
	fullscreen_vision = null

/obj/item/clothing/glasses/night/cultist
	name = "\improper Unusual Thermal Imaging Goggles"
	desc = "Seems to be thermal imaging goggles, except they have an unusual design. Looking at it makes you nauseous."
	icon_state = "thermal"
	item_state = "glasses"
	w_class = SIZE_SMALL
	vision_flags = SEE_MOBS
	darkness_view = 7
	fullscreen_vision = null

/obj/item/clothing/glasses/night/cultist/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(iscarbon(user))
			var/mob/living/carbon/H = user
			if(!H.hivenumber)
				to_chat(user, SPAN_WARNING("You do not want to put these on, they're making you nauseous."))
				return FALSE
	return ..()

/obj/item/clothing/glasses/night/experimental_mesons
	name = "\improper Experimental Meson Goggles"
	desc = "An improved but experimental version of the standard issue meson goggles, due to increased complexity these can only be worn by synthetics. Allows for full night vision and viewing of the surroundings. Click it to toggle."
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "refurb_meson"
	deactive_state = "degoggles"
	vision_flags = SEE_TURFS
	darkness_view = 12
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/night/experimental_mesons/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(!isSynth(user))
			to_chat(user, "The experimental meson goggles start probing at your eyes, searching for an attachment point, and you immediately take them off.")
			return FALSE
	return ..()
