#define VISION_MODE_OFF 0
#define VISION_MODE_NVG 1

///parent type
/obj/item/clothing/mask/gas/yautja
	name = "alien mask"
	desc = "A beautifully designed metallic face mask, both ornate and functional."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "pred_mask1_ebony"
	item_state = "helmet"
	item_state_slots = list(WEAR_FACE = "pred_mask1_ebony")

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	unequip_sounds = list('sound/items/air_release.ogg')

	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_cold_protection = BODY_FLAG_HEAD
	flags_inventory = COVEREYES|COVERMOUTH|NOPRESSUREDMAGE|ALLOWINTERNALS|ALLOWREBREATH|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDELOWHAIR
	flags_item = ITEM_PREDATOR
	filtered_gases = list("phoron", "sleeping_agent", "carbon_dioxide")
	gas_filter_strength = 3
	eye_protection = EYE_PROTECTION_WELDING
	var/current_goggles = VISION_MODE_OFF
	vision_impair = VISION_IMPAIR_NONE
	unacidable = TRUE
	time_to_unequip = 20
	anti_hug = 5
	fire_intensity_resistance = 10
	black_market_value = 100
	var/list/mask_huds = list(MOB_HUD_XENO_STATUS, MOB_HUD_HUNTER, MOB_HUD_HUNTER_CLAN, MOB_HUD_MEDICAL_OBSERVER)
	var/thrall = FALSE //Used to affect icon generation.

	///A list of all intrinsic mask actions
	var/list/mask_actions = list(/datum/action/predator_action/mask/zoom, /datum/action/predator_action/mask/visor)

/obj/item/clothing/mask/gas/yautja/New(location, mask_number = rand(1,12), armor_material = "ebony", legacy = "None")
	..()
	forceMove(location)
	if(thrall)
		return

	if(legacy != "None")
		switch(legacy)
			if("Dragon")
				icon_state = "pred_mask_elder_tr"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_tr")
				return
			if("Swamp")
				icon_state = "pred_mask_elder_joshuu"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_joshuu")
				return
			if("Enforcer")
				icon_state = "pred_mask_elder_feweh"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_feweh")
				return
			if("Collector")
				icon_state = "pred_mask_elder_n"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_n")
				return

	if(mask_number > 12)
		mask_number = 1
	icon_state = "pred_mask[mask_number]_[armor_material]"
	LAZYSET(item_state_slots, WEAR_FACE, "pred_mask[mask_number]_[armor_material]")

/obj/item/clothing/mask/gas/yautja/pickup(mob/living/user)
	if(isyautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/mask/gas/yautja/process()
	if(!ishuman(loc))
		return PROCESS_KILL
	var/mob/living/carbon/human/human_holder = loc

	if(current_goggles && !drain_power(human_holder, 3))
		to_chat(human_holder, SPAN_WARNING("Your bracers lack sufficient power to operate the visor."))
		current_goggles = VISION_MODE_OFF
		var/obj/item/visor = human_holder.glasses
		if(istype(visor, /obj/item/clothing/glasses/night/yautja))//To change if any new vision modes are made
			human_holder.temp_drop_inv_item(visor)
			qdel(visor)
			human_holder.update_sight()
			add_vision(human_holder)

/obj/item/clothing/mask/gas/yautja/proc/drain_power(mob/living/carbon/human/human_holder, drain_amount)
	var/obj/item/clothing/gloves/yautja/bracer = human_holder.gloves
	if(!bracer || !istype(bracer))
		return FALSE
	if(!(bracer.drain_power(human_holder, drain_amount)))
		return FALSE
	return TRUE

/obj/item/clothing/mask/gas/yautja/verb/toggle_zoom()
	set name = "Toggle Mask Zoom"
	set desc = "Toggle your mask's zoom function."
	set src in usr
	if(!usr || usr.stat)
		return

	zoom(usr, 11, 12)
	update_zoom_action(src, usr)
	if(zoom)
		RegisterSignal(src, COMSIG_ITEM_UNZOOM, PROC_REF(update_zoom_action))
		return

/obj/item/clothing/mask/gas/yautja/proc/update_zoom_action(source, mob/living/user)
	UnregisterSignal(src, COMSIG_ITEM_UNZOOM)
	var/datum/action/predator_action/mask/zoom/zoom_action
	for(zoom_action as anything in user.actions)
		if(istypestrict(zoom_action, /datum/action/predator_action/mask/zoom))
			zoom_action.update_button_icon(zoom)
			break

/obj/item/clothing/mask/gas/yautja/verb/togglesight()
	set name = "Toggle Mask Visors"
	set desc = "Toggle your mask visor sights. You must only be wearing a type of Yautja visor for this to work."
	set src in usr
	if(!usr || usr.stat)
		return
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH) && !user.hunter_data.thralled)
		to_chat(user, SPAN_WARNING("You have no idea how to work this thing!"))
		return
	if(src != user.wear_mask) //sanity
		to_chat(user, SPAN_WARNING("You must wear \the [src]!"))
		return
	var/obj/item/clothing/gloves/yautja/bracer = user.gloves
	if(!bracer || !istype(bracer))
		to_chat(user, SPAN_WARNING("You must be wearing your bracers, as they have the power source."))
		return
	var/obj/item/visor = user.glasses
	if(visor)
		if(!istype(visor, /obj/item/clothing/glasses/night/yautja))
			to_chat(user, SPAN_WARNING("You need to remove your glasses first. Why are you even wearing these?"))
			return
		user.temp_drop_inv_item(visor) //Get rid of ye existing maicerinho goggles
		qdel(visor)
		user.update_inv_glasses()
		user.update_sight()
	switch_vision_mode()
	add_vision(user)

/obj/item/clothing/mask/gas/yautja/proc/switch_vision_mode() //switches to the next one
	switch(current_goggles)
		if(VISION_MODE_OFF)
			current_goggles = VISION_MODE_NVG
		if(VISION_MODE_NVG)
			current_goggles = VISION_MODE_OFF

/obj/item/clothing/mask/gas/yautja/proc/add_vision(mob/living/carbon/human/user) //applies current_goggles
	switch(current_goggles)
		if(VISION_MODE_NVG)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/yautja(user), WEAR_EYES)
			to_chat(user, SPAN_NOTICE("Low-light vision module: activated."))
		if(VISION_MODE_OFF)
			to_chat(user, SPAN_NOTICE("You deactivate your visor."))

	playsound(src, 'sound/effects/pred_vision.ogg', 15, 1)
	user.update_inv_glasses()

	var/datum/action/predator_action/mask/visor/visor_action
	for(visor_action as anything in user.actions)
		if(istypestrict(visor_action, /datum/action/predator_action/mask/visor))
			visor_action.update_button_icon(current_goggles)
			break

#undef VISION_MODE_OFF
#undef VISION_MODE_NVG

/obj/item/clothing/mask/gas/yautja/dropped(mob/living/carbon/human/user) //Clear the gogglors if the helmet is removed.
	STOP_PROCESSING(SSobj, src)
	if(istype(user) && user.wear_mask == src) //inventory reference is only cleared after dropped().
		for(var/datum/action/action as anything in mask_actions)
			remove_action(user, action)

		for(var/listed_hud in mask_huds)
			var/datum/mob_hud/H = GLOB.huds[listed_hud]
			H.remove_hud_from(user, src)
		var/obj/item/visor = user.glasses
		if(visor) //make your hud fuck off
			if(istype(visor, /obj/item/clothing/glasses/night/yautja))
				user.temp_drop_inv_item(visor)
				qdel(visor)
				user.update_inv_glasses()
				user.update_sight()
	..()

/obj/item/clothing/mask/gas/yautja/equipped(mob/living/carbon/human/user, slot)
	if(slot == WEAR_FACE)
		for(var/datum/action/action as anything in mask_actions)
			give_action(user, action)

		START_PROCESSING(SSobj, src)
		for(var/listed_hud in mask_huds)
			var/datum/mob_hud/H = GLOB.huds[listed_hud]
			H.add_hud_to(user, src)
		if(current_goggles)
			var/obj/item/clothing/gloves/yautja/bracer = user.gloves
			if(!bracer || !istype(bracer))
				return FALSE
			add_vision(user)
	..()

/obj/item/clothing/mask/gas/yautja/thrall
	name = "alien mask"
	desc = "A simplistic metallic face mask with advanced capabilities."
	icon_state = "thrall_mask"
	item_state = "thrall_mask"
	icon = 'icons/obj/items/hunter/thrall_gear.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/hunter/thrall_gear.dmi'
	)
	item_state_slots = list(WEAR_FACE = "thrall_mask")
	thrall = TRUE

/obj/item/clothing/mask/gas/yautja/thrall/toggle_zoom()
	set category = "Thrall.Utility"
	..()
/obj/item/clothing/mask/gas/yautja/thrall/togglesight()
	set category = "Thrall.Utility"
	..()

/obj/item/clothing/mask/gas/yautja/hunter
	name = "clan mask"
	desc = "A beautifully designed metallic face mask, both ornate and functional."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	eye_protection = EYE_PROTECTION_WELDING
	anti_hug = 100

/obj/item/clothing/mask/gas/yautja/hunter/toggle_zoom()
	set category = "Yautja.Utility"
	..()
/obj/item/clothing/mask/gas/yautja/hunter/togglesight()
	set category = "Yautja.Utility"
	if(!isyautja(usr))
		to_chat(usr, SPAN_WARNING("You have no idea how to work this thing!"))
		return
	..()

/obj/item/clothing/mask/gas/yautja/damaged
	name = "ancient alien mask"
	desc = "A beautifully designed metallic face mask, both ornate and functional. This one seems to be old and degraded."

//flavor, not a subtype
/obj/item/clothing/mask/yautja_flavor
	name = "alien stone mask"
	desc = "A beautifully designed face mask, ornate but non-functional and made entirely of stone."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "pred_mask1_ebony"

	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_cold_protection = BODY_FLAG_HEAD
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDELOWHAIR
	unacidable = TRUE
	item_state_slots = list(WEAR_FACE = "pred_mask1_ebony")
	var/map_random = FALSE

/obj/item/clothing/mask/yautja_flavor/Initialize(mapload, ...)
	. = ..()
	if(mapload && !map_random)
		return

	var/list/possible_masks = list(1,2,3,4,5,6,7,8,9,10,11) //12
	var/mask_number = rand(1,11)
	if(mask_number in possible_masks)
		icon_state = "pred_mask[mask_number]_ebony"
		LAZYSET(item_state_slots, WEAR_FACE, "pred_mask[mask_number]_ebony")

/obj/item/clothing/mask/yautja_flavor/map_random
	map_random = TRUE
