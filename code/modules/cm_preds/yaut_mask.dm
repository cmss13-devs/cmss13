
/obj/item/clothing/mask/gas/yautja
	name = "clan mask"
	desc = "A beautifully designed metallic face mask, both ornate and functional."
	icon = 'icons/obj/items/clothing/masks.dmi'
	icon_state = "pred_mask1"
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
	item_state_slots = list(WEAR_FACE = "pred_mask1")
	time_to_unequip = 20
	unequip_sounds = list('sound/items/air_release.ogg')

/obj/item/clothing/mask/gas/yautja/New(location, mask_number = rand(1,12), elder_restricted = 0)
	..()
	forceMove(location)

	var/mask_input[] = list(1,2,3,4,5,6,7,8,9,10,11,12)
	if(mask_number in mask_input)
		icon_state = "pred_mask[mask_number]"
		item_state_slots = list(WEAR_FACE = "pred_mask[mask_number]")
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
	set category = "Yautja"
	set src in usr
	if(!usr || usr.stat)
		return

	zoom(usr, 11, 12)

/obj/item/clothing/mask/gas/yautja/verb/togglesight()
	set name = "Toggle Mask Visors"
	set desc = "Toggle your mask visor sights. You must only be wearing a type of Yautja visor for this to work."
	set category = "Yautja"
	set src in usr
	if(!usr || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(M.species && M.species.name != "Yautja")
		to_chat(M, SPAN_WARNING("You have no idea how to work these things!"))
		return
	current_goggles++
	if(current_goggles > 3) current_goggles = 0
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

/obj/item/clothing/mask/gas/yautja/dropped(mob/living/carbon/human/mob) //Clear the gogglors if the helmet is removed.
	if(istype(mob) && mob.wear_mask == src) //inventory reference is only cleared after dropped().
		var/obj/item/G = mob.glasses
		if(G)
			if(istype(G,/obj/item/clothing/glasses/night/yautja) || istype(G,/obj/item/clothing/glasses/meson/yautja) || istype(G,/obj/item/clothing/glasses/thermal/yautja))
				mob.temp_drop_inv_item(G)
				qdel(G)
				mob.update_inv_glasses()
		var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_OBSERVER]
		H.remove_hud_from(mob)
		H = huds[MOB_HUD_XENO_STATUS]
		H.remove_hud_from(mob)
		H = huds[MOB_HUD_HUNTER_CLAN]
		H.remove_hud_from(mob)
		H = huds[MOB_HUD_HUNTER]
		H.remove_hud_from(mob)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()
