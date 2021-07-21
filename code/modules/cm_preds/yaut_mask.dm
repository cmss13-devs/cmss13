
/obj/item/clothing/mask/gas/yautja
	name = "clan mask"
	desc = "A beautifully designed metallic face mask, both ornate and functional."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "pred_mask1_ebony"
	item_state = "helmet"

	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	min_cold_protection_temperature = SPACE_HELMET_min_cold_protection_temperature
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_cold_protection = BODY_FLAG_HEAD
	flags_inventory = COVEREYES|COVERMOUTH|NOPRESSUREDMAGE|ALLOWINTERNALS|ALLOWREBREATH|BLOCKGASEFFECT|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDELOWHAIR
	flags_item = ITEM_PREDATOR
	filtered_gases = list("phoron", "sleeping_agent", "carbon_dioxide")
	gas_filter_strength = 3
	eye_protection = 2
	var/current_goggles = 0 //0: OFF. 1: NVG. 2: Thermals. 3: Mesons
	vision_impair = VISION_IMPAIR_NONE
	unacidable = TRUE
	anti_hug = 100
	item_state_slots = list(WEAR_FACE = "pred_mask1_ebony")
	time_to_unequip = 20
	unequip_sounds = list('sound/items/air_release.ogg')

/obj/item/clothing/mask/gas/yautja/New(location, mask_number = rand(1,12), armor_material = "ebony", elder_restricted = 0)
	..()
	forceMove(location)

	if(mask_number > 12)
		mask_number = 1
	icon_state = "pred_mask[mask_number]_[armor_material]"
	item_state_slots = list(WEAR_FACE = "pred_mask[mask_number]_[armor_material]")
	if(elder_restricted) //Not possible for non-elders.
		switch(mask_number)
			if(1341)
				name = "\improper 'Mask of the Dragon'"
				icon_state = "pred_mask_elder_tr"
				item_state_slots = list(WEAR_FACE = "pred_mask_elder_tr")
			if(7128)
				name = "\improper 'Mask of the Swamp Horror'"
				icon_state = "pred_mask_elder_joshuu"
				item_state_slots = list(WEAR_FACE = "pred_mask_elder_joshuu")
			if(4879)
				name = "\improper 'Mask of the Ambivalent Collector'"
				icon_state = "pred_mask_elder_n"
				item_state_slots = list(WEAR_FACE = "pred_mask_elder_n")

/obj/item/clothing/mask/gas/yautja/verb/toggle_zoom()
	set name = "Toggle Mask Zoom"
	set desc = "Toggle your mask's zoom function."
	set category = "Yautja.Utility"
	set src in usr
	if(!usr || usr.stat)
		return

	zoom(usr, 11, 12)

/obj/item/clothing/mask/gas/yautja/verb/togglesight()
	set name = "Toggle Mask Visors"
	set desc = "Toggle your mask visor sights. You must only be wearing a type of Yautja visor for this to work."
	set category = "Yautja.Utility"
	set src in usr
	if(!usr || usr.stat)
		return
	var/mob/living/carbon/human/M = usr
	if(!istype(M))
		return
	if(!HAS_TRAIT(M, TRAIT_YAUTJA_TECH))
		to_chat(M, SPAN_WARNING("You have no idea how to work these things!"))
		return
	current_goggles++
	if(current_goggles > 3)
		current_goggles = 0
	add_vision(M)

/obj/item/clothing/mask/gas/yautja/proc/add_vision(mob/living/carbon/human/user)
	var/obj/item/clothing/gloves/yautja/Y = user.gloves //Doesn't actually reduce power, but needs the bracers anyway.
	if(!Y || !istype(Y))
		to_chat(user, SPAN_WARNING("You must be wearing your bracers, as they have the power source."))
		return
	var/obj/item/G = user.glasses
	if(G)
		if(!istype(G,/obj/item/clothing/glasses/night/yautja) && !istype(G,/obj/item/clothing/glasses/meson/yautja) && !istype(G,/obj/item/clothing/glasses/thermal/yautja))
			to_chat(user, SPAN_WARNING("You need to remove your glasses first. Why are you even wearing these?"))
			return
		user.temp_drop_inv_item(G) //Get rid of ye existinge gogglors
		qdel(G)
	switch(current_goggles)
		if(1)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/yautja(user), WEAR_EYES)
			to_chat(user, SPAN_NOTICE("Low-light vision module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(2)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/yautja(user), WEAR_EYES)
			to_chat(user, SPAN_NOTICE("Thermal sight module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(3)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson/yautja(user), WEAR_EYES)
			to_chat(user, SPAN_NOTICE("Material vision module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(0)
			to_chat(user, SPAN_NOTICE("You deactivate your visor."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
	user.update_inv_glasses()

/obj/item/clothing/mask/gas/yautja/equipped(mob/living/carbon/human/user, slot)
	if(slot == WEAR_FACE)
		var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_OBSERVER]
		H.add_hud_to(user)
		H = huds[MOB_HUD_XENO_STATUS]
		H.add_hud_to(user)
		H = huds[MOB_HUD_HUNTER_CLAN]
		H.add_hud_to(user)
		H = huds[MOB_HUD_HUNTER]
		H.add_hud_to(user)
		add_vision(user)
	..()

/obj/item/clothing/mask/gas/yautja/dropped(mob/living/carbon/human/user) //Clear the gogglors if the helmet is removed.
	if(istype(user) && user.wear_mask == src) //inventory reference is only cleared after dropped().
		var/obj/item/G = user.glasses
		if(G)
			if(istype(G,/obj/item/clothing/glasses/night/yautja) || istype(G,/obj/item/clothing/glasses/meson/yautja) || istype(G,/obj/item/clothing/glasses/thermal/yautja))
				user.temp_drop_inv_item(G)
				qdel(G)
				user.update_inv_glasses()
		var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_OBSERVER]
		H.remove_hud_from(user)
		H = huds[MOB_HUD_XENO_STATUS]
		H.remove_hud_from(user)
		H = huds[MOB_HUD_HUNTER_CLAN]
		H.remove_hud_from(user)
		H = huds[MOB_HUD_HUNTER]
		H.remove_hud_from(user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

//flavor, not a subtype
/obj/item/clothing/mask/yautja_flavor
	name = "stone clan mask"
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
	flags_item = ITEM_PREDATOR
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
		item_state_slots = list(WEAR_FACE = "pred_mask[mask_number]_ebony")

/obj/item/clothing/mask/yautja_flavor/map_random
	map_random = TRUE
