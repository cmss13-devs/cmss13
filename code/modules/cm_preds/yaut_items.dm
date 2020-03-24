//Items specific to yautja. Other people can use em, they're not restricted or anything.
//They can't, however, activate any of the special functions.

/proc/add_to_missing_pred_gear(var/obj/item/W)
	if(!(W in yautja_gear))
		yautja_gear += W

/proc/remove_from_missing_pred_gear(var/obj/item/W)
	if(W in yautja_gear)
		yautja_gear -= W

//=================//\\=================\\
//======================================\\

/*
				 EQUIPMENT
*/

//======================================\\
//=================\\//=================\\

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

/obj/item/clothing/mask/gas/yautja/New(location, mask_number = rand(1,11), elder_restricted = 0)
	..()
	loc = location

	var/mask_input[] = list(1,2,3,4,5,6,7,8,9,10,11)
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

	if(!usr || usr.stat)
		return

	zoom(usr, 11, 12)

/obj/item/clothing/mask/gas/yautja/verb/togglesight()
	set name = "Toggle Mask Visors"
	set desc = "Toggle your mask visor sights. You must only be wearing a type of Yautja visor for this to work."
	set category = "Yautja"

	if(!usr || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(M.species && M.species.name != "Yautja")
		to_chat(M, SPAN_WARNING("You have no idea how to work these things!"))
		return
	var/obj/item/clothing/gloves/yautja/Y = M.gloves //Doesn't actually reduce power, but needs the bracers anyway.
	if(!Y || !istype(Y))
		to_chat(M, SPAN_WARNING("You must be wearing your bracers, as they have the power source."))
		return
	var/obj/item/G = M.glasses
	if(G)
		if(!istype(G,/obj/item/clothing/glasses/night/yautja) && !istype(G,/obj/item/clothing/glasses/meson/yautja) && !istype(G,/obj/item/clothing/glasses/thermal/yautja))
			to_chat(M, SPAN_WARNING("You need to remove your glasses first. Why are you even wearing these?"))
			return
		M.temp_drop_inv_item(G) //Get rid of ye existinge gogglors
		qdel(G)
	switch(current_goggles)
		if(0)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/yautja(M), WEAR_EYES)
			to_chat(M, SPAN_NOTICE("Low-light vision module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(1)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/yautja(M), WEAR_EYES)
			to_chat(M, SPAN_NOTICE("Thermal sight module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(2)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson/yautja(M), WEAR_EYES)
			to_chat(M, SPAN_NOTICE("Material vision module: activated."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
		if(3)
			to_chat(M, SPAN_NOTICE("You deactivate your visor."))
			if(prob(50)) playsound(src,'sound/effects/pred_vision.ogg', 15, 1)
	M.update_inv_glasses()
	current_goggles++
	if(current_goggles > 3) current_goggles = 0


/obj/item/clothing/mask/gas/yautja/equipped(mob/living/carbon/human/user, slot)
	if(slot == WEAR_FACE)
		var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_ADVANCED]
		H.add_hud_to(user)
		H = huds[MOB_HUD_XENO_STATUS]
		H.add_hud_to(user)
	..()

/obj/item/clothing/mask/gas/yautja/dropped(mob/living/carbon/human/mob) //Clear the gogglors if the helmet is removed.
	if(istype(mob) && mob.wear_mask == src) //inventory reference is only cleared after dropped().
		var/obj/item/G = mob.glasses
		if(G)
			if(istype(G,/obj/item/clothing/glasses/night/yautja) || istype(G,/obj/item/clothing/glasses/meson/yautja) || istype(G,/obj/item/clothing/glasses/thermal/yautja))
				mob.temp_drop_inv_item(G)
				qdel(G)
				mob.update_inv_glasses()
		var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_ADVANCED]
		H.remove_hud_from(mob)
		H = huds[MOB_HUD_XENO_STATUS]
		H.remove_hud_from(mob)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/mask/gas/yautja/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/suit/armor/yautja
	name = "clan armor"
	desc = "A suit of armor with light padding. It looks old, yet functional."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "halfarmor1"
	item_state = "armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	min_cold_protection_temperature = ARMOR_min_cold_protection_temperature
	max_heat_protection_temperature = ARMOR_max_heat_protection_temperature
	siemens_coefficient = 0.1
	allowed = list(/obj/item/weapon/harpoon,
			/obj/item/weapon/gun/launcher/spike,
			/obj/item/weapon/gun/energy/plasmarifle,
			/obj/item/weapon/gun/energy/plasmapistol,
			/obj/item/weapon/yautja_chain,
			/obj/item/weapon/yautja_knife,
			/obj/item/weapon/yautja_sword,
			/obj/item/weapon/yautja_scythe,
			/obj/item/weapon/combistick,
			/obj/item/weapon/twohanded/glaive)
	unacidable = TRUE
	item_state_slots = list(WEAR_JACKET = "halfarmor1")

/obj/item/clothing/suit/armor/yautja/New(location, armor_number = rand(1,6), elder_restricted = 0)
	..()
	loc = location

	if(elder_restricted)
		armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
		armor_bullet = CLOTHING_ARMOR_HIGH
		armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
		armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
		armor_bomb = CLOTHING_ARMOR_HIGH
		armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
		armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
		armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
		switch(armor_number)
			if(1341)
				name = "\improper 'Armor of the Dragon'"
				icon_state = "halfarmor_elder_tr"
				item_state_slots = list(WEAR_JACKET = "halfarmor_elder_tr")
			if(7128)
				name = "\improper 'Armor of the Swamp Horror'"
				icon_state = "halfarmor_elder_joshuu"
				item_state_slots = list(WEAR_JACKET = "halfarmor_elder_joshuu")
			if(9867)
				name = "\improper 'Armor of the Enforcer'"
				icon_state = "halfarmor_elder_feweh"
				item_state_slots = list(WEAR_JACKET = "halfarmor_elder_feweh")
			if(4879)
				name = "\improper 'Armor of the Ambivalent Collector'"
				icon_state = "halfarmor_elder_n"
				item_state_slots = list(WEAR_JACKET = "halfarmor_elder_n")
			else
				name = "clan elder's armor"
				icon_state = "halfarmor_elder"
				item_state_slots = list(WEAR_JACKET = "halfarmor_elder")
	else
		if(armor_number > 6)
			armor_number = 1
		if(armor_number) //Don't change full armor number
			icon_state = "halfarmor[armor_number]"
			item_state_slots = list(WEAR_JACKET = "halfarmor[armor_number]")

	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

/obj/item/clothing/suit/armor/yautja/full
	name = "heavy clan armor"
	desc = "A suit of armor with heavy padding. It looks old, yet functional."
	icon_state = "fullarmor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HEAD|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	slowdown = 1
	item_state_slots = list(WEAR_JACKET = "fullarmor")

/obj/item/clothing/suit/armor/yautja/full/New(location)
	. = ..(location, 0)

/obj/item/clothing/suit/armor/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/suit/armor/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/suit/armor/yautja/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/cape

/obj/item/clothing/cape/eldercape
	name = "clan elder cape"
	desc = "A dusty, yet powerful cape worn and passed down by elder Yautja."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "cape_elder"
	flags_equip_slot = SLOT_BACK
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	unacidable = TRUE

/obj/item/clothing/cape/eldercape/New(location, cape_number)
	..()
	switch(cape_number)
		if(1341)
			name = "\improper 'Mantle of the Dragon'"
			icon_state = "cape_elder_tr"
			item_state_slots = list(WEAR_JACKET = "cape_elder_tr")
		if(7128)
			name = "\improper 'Mantle of the Swamp Horror'"
			icon_state = "cape_elder_joshuu"
			item_state_slots = list(WEAR_JACKET = "cape_elder_joshuu")
		if(9867)
			name = "\improper 'Mantle of the Enforcer'"
			icon_state = "cape_elder_feweh"
			item_state_slots = list(WEAR_JACKET = "cape_elder_feweh")
		if(4879)
			name = "\improper 'Mantle of the Ambivalent Collector'"
			icon_state = "cape_elder_n"
			item_state_slots = list(WEAR_JACKET = "cape_elder_n")

/obj/item/clothing/cape/eldercape/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/cape/eldercape/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/cape/eldercape/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/shoes/yautja
	name = "clan greaves"
	icon_state = "y-boots1"
	desc = "A pair of armored, perfectly balanced boots. Perfect for running through the jungle."
	unacidable = TRUE
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	siemens_coefficient = 0.2
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	items_allowed = list(/obj/item/weapon/yautja_knife, /obj/item/weapon/gun/energy/plasmapistol)
	var/bootnumber = 1

/obj/item/clothing/shoes/yautja/New(location, boot_number = rand(1,3))
	..()
	var/boot_input[] = list(1,2,3)
	if(boot_number in boot_input)
		icon_state = "y-boots[boot_number]"

	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

/obj/item/clothing/shoes/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/shoes/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/shoes/yautja/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/under/chainshirt
	name = "body mesh"
	icon = 'icons/obj/items/clothing/uniforms.dmi'
	desc = "A set of very fine chainlink in a meshwork for comfort and utility."
	icon_state = "mesh_shirt"
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS //Does not cover the head though.
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS
	has_sensor = 0
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	siemens_coefficient = 0.9
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature

/obj/item/clothing/under/chainshirt/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/under/chainshirt/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/under/chainshirt/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/gloves/yautja
	name = "clan bracers"
	desc = "An extremely complex, yet simple-to-operate set of armored bracers worn by the Yautja. It has many functions, activate them to use some."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "bracer"

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_item = 0
	flags_armor_protection = BODY_FLAG_HANDS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	unacidable = TRUE
	var/obj/item/weapon/gun/energy/plasma_caster/caster
	var/charge = 3000
	var/charge_max = 3000
	var/cloaked = 0
	var/blades_active = 0
	var/caster_active = 0
	var/exploding = 0
	var/inject_timer = 0
	var/disc_timer = 0
	var/cloak_timer = 0
	var/upgrades = 0 //Set to two, so admins can give preds shittier ones for young blood events or whatever. //Changed it back to 0 since it was breaking spawn-equipment and the translator -retrokinesis
	var/explosion_type = 0 //0 is BIG explosion, 1 ONLY gibs the user.
	var/combistick_cooldown = 0 //Let's add a cooldown for Yank Combistick so that it can't be spammed.
	var/notification_sound = TRUE	// Whether the bracer pings when a message comes or not

/obj/item/clothing/gloves/yautja/New()
	..()
	caster = new(src)

/obj/item/clothing/gloves/yautja/emp_act(severity)
	charge -= (severity * 500)
	if(charge < 0) charge = 0
	if(usr)
		usr.visible_message(SPAN_DANGER("You hear a hiss and crackle!"),SPAN_DANGER("Your bracers hiss and spark!"))
		if(cloaked)
			decloak(usr)

/obj/item/clothing/gloves/yautja/equipped(mob/user, slot)
	..()
	if(slot == WEAR_HANDS)
		flags_item = NODROP
		processing_objects.Add(src)
		if(isYautja(user))
			to_chat(user, SPAN_WARNING("The bracer clamps securely around your forearm and beeps in a comfortable, familiar way."))
		else
			to_chat(user, SPAN_WARNING("The bracer clamps painfully around your forearm and beeps angrily. It won't come off!"))

/obj/item/clothing/gloves/yautja/Dispose()
	processing_objects.Remove(src)
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	processing_objects.Remove(src)
	add_to_missing_pred_gear(src)
	flags_item = initial(flags_item)
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		processing_objects.Remove(src)
		return
	var/mob/living/carbon/human/H = loc
	if(cloak_timer)
		cloak_timer--
	if(cloaked)
		H.alpha = 10
		charge = max(charge - 10, 0)
		if(charge <= 0)
			decloak(loc)
		//Non-Yautja have a chance to get stunned with each power drain
		if(!isYautja(H))
			if(prob(15))
				shock_user(H)
				decloak(loc)
	else
		charge = min(charge + 30, charge_max)
	var/perc_charge = (charge / charge_max * 100)
	H.update_power_display(perc_charge)


//This is the main proc for checking AND draining the bracer energy. It must have M passed as an argument.
//It can take a negative value in amount to restore energy.
//Also instantly updates the yautja power HUD display.
/obj/item/clothing/gloves/yautja/proc/drain_power(var/mob/living/carbon/human/M, var/amount)
	if(!M) return 0
	if(charge < amount)
		to_chat(M, SPAN_WARNING("Your bracers lack the energy. They have only <b>[charge]/[charge_max]</b> remaining and need <B>[amount]</b>."))
		return 0
	charge -= amount
	var/perc = (charge / charge_max * 100)
	M.update_power_display(perc)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!isYautja(M))
		if(prob(15))
			shock_user(M)
	return 1

/obj/item/clothing/gloves/yautja/proc/shock_user(var/mob/living/carbon/human/M)
	if(!isYautja(M))
		//Spark
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		M.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [M]'s body!"))
		//Stun and knock out, scream in pain
		M.Stun(2)
		M.KnockDown(2)
		M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)


/obj/item/clothing/gloves/yautja/examine(mob/user)
	..()
	to_chat(user, "They currently have [charge] out of [charge_max] charge.")


//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/proc/activate_random_verb()
	var/option = rand(1, 11)
	//we have options from 1 to 8, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = wristblades_internal(TRUE)
		if(2)
			. = track_gear_internal(TRUE)
		if(3)
			. = cloaker_internal(TRUE)
		if(4)
			. = caster_internal(TRUE)
		if(5)
			. = injectors_internal(TRUE)
		if(6)
			. = call_disk_internal(TRUE)
		if(7)
			. = translate_internal(TRUE)
		if(8)
			. = call_combi(TRUE)
		else
			. = delimb_user()
			//Council did not want this to ever happen
			//activate_suicide_internal(TRUE)
	return

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/proc/should_activate_random_or_this_function()
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return 0

	var/workingProbability = 20
	var/randomProbability = 10
	if (isSynth(user))
		//Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else
		//Researchers are sort of smart, they can sort of figure this out
		if (isResearcher(user))
			workingProbability = 25
			randomProbability = 7


	to_chat(user, SPAN_NOTICE("You press a few buttons..."))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(usr, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		var/chance = rand(1, 100)
		if(chance <= randomProbability)
			return 1
		chance-=randomProbability
		if(chance <= workingProbability)
			return 2
	return 0


//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/proc/delimb_user()
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(isYautja(usr)) return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("The device emits a strange noise and falls off... Along with your arms!"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return 1

// Toggle the notification sound
/obj/item/clothing/gloves/yautja/verb/toggle_notification_sound()
	set name = "Toggle Bracer Sound"
	set desc = "Toggle your bracer's notification sound."
	set category = "Yautja"

	notification_sound = !notification_sound
	to_chat(usr, SPAN_NOTICE("The bracer's sound is now turned [notification_sound ? "on" : "off"]."))

//Should put a cool menu here, like ninjas.
/obj/item/clothing/gloves/yautja/verb/wristblades()
	set name = "Use Wrist Blades"
	set desc = "Extend your wrist blades. They cannot be dropped, but can be retracted."
	set category = "Yautja"
	. = wristblades_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/wristblades_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/wristblades/R = user.get_active_hand()
	if(R && istype(R)) //Turn it off.
		to_chat(user, SPAN_NOTICE("You retract your wrist blades."))
		playsound(user.loc,'sound/weapons/wristblades_off.ogg', 15, 1)
		blades_active = 0
		qdel(R)
		return
	else
		if(!drain_power(user,50)) return

		if(R)
			to_chat(user, SPAN_WARNING("Your hand must be free to activate your wrist blade!"))
			return

		var/obj/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("You can't hold that!"))
			return
		var/obj/item/weapon/wristblades/N
		N = new /obj/item/weapon/wristblades

		user.put_in_active_hand(N)
		blades_active = 1
		to_chat(user, SPAN_NOTICE("You activate your wrist blades."))
		playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)

	return 1

/obj/item/clothing/gloves/yautja/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "Find Yauja Gear."
	set category = "Yautja"
	. = track_gear_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/track_gear_internal(var/forced = FALSE)
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/I in yautja_gear)
		var/atom/loc = get_true_location(I)
		if (isYautja(loc))
			//it's actually yautja holding the item, ignore!
			continue
		switch(loc.z)
			if(LOW_ORBIT_Z_LEVEL)
				gear_low_orbit++
			if(MAIN_SHIP_Z_LEVEL)
				gear_on_almayer++
			if(1)
				gear_on_planet++
		if(M.z == loc.z)
			var/dist = get_dist(M,loc)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,loc)
				areaLoc = loc
	for(var/mob/living/carbon/human/Y in yautja_mob_list)
		if(Y.stat != DEAD) continue
		switch(Y.z)
			if(LOW_ORBIT_Z_LEVEL)
				dead_low_orbit++
			if(MAIN_SHIP_Z_LEVEL)
				dead_on_almayer++
			if(1)
				dead_on_planet++
		if(M.z == Y.z)
			var/dist = get_dist(M,Y)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,Y)
				areaLoc = loc

	var/output = 0
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of deceased Yautja bio signatures, [dead_on_planet] in the hunting grounds, [dead_on_almayer] in orbit, [dead_low_orbit] in low orbit."))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of Yautja technology signatures, [gear_on_planet] in the hunting grounds, [gear_on_almayer] in orbit, [gear_low_orbit] in low orbit."))
	if(closest < 900)
		var/areaName = get_area(areaLoc).name
		to_chat(M, SPAN_NOTICE("The closest signature is approximately [round(closest,10)] paces [dir2text(direction)] in [areaName]."))
	if(!output)
		to_chat(M, SPAN_NOTICE("There are no signatures that require your attention."))
	return 1


/obj/item/clothing/gloves/yautja/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "Activate your suit's cloaking device. It will malfunction if the suit takes damage or gets excessively wet."
	set category = "Yautja"
	. = cloaker_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/cloaker_internal(var/forced = FALSE)
	if(!usr || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			if(cloaked) //Turn it off.
				//We're going to be nice here and say you can turn off the cloak without an issue
				//Otherwise, humans wouldn't have any use for the cloak without being shocked every time they turn it on
				//Since they couldn't turn it off in time afterwards with consistency
				decloak(usr)
				return 1
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(cloaked) //Turn it off.
		decloak(usr)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("Your bracer is much too busy violently exploding to activate the cloaking device."))
			return 0
		if(cloak_timer)
			if(prob(50))
				to_chat(M, SPAN_WARNING("Your cloaking device is still recharging! Time left: <B>[cloak_timer]</b> ticks."))
			return 0
		if(!drain_power(M,50)) return
		cloaked = 1
		to_chat(M, SPAN_NOTICE("You are now invisible to normal detection."))
		for(var/mob/O in oviewers(M))
			O.show_message("[M] vanishes into thin air!",1)
		playsound(M.loc,'sound/effects/pred_cloakon.ogg', 15, 1)
		M.alpha = 25

		var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		spawn(1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	return 1

/obj/item/clothing/gloves/yautja/proc/decloak(var/mob/user)
	if(!user) return
	to_chat(user, "Your cloaking device deactivates.")
	cloaked = 0
	for(var/mob/O in oviewers(user))
		O.show_message("[user.name] shimmers into existence!",1)
	playsound(user.loc,'sound/effects/pred_cloakoff.ogg', 15, 1)
	user.alpha = initial(user.alpha)
	cloak_timer = 5

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	spawn(1)
		if(user)
			anim(user.loc,user,'icons/mob/mob.dmi',,"uncloak",,user.dir)


/obj/item/clothing/gloves/yautja/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "Activate your plasma caster. If it is dropped it will retract back into your armor."
	set category = "Yautja"
	. = caster_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/caster_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/gun/energy/plasma_caster/R = usr.r_hand
	var/obj/item/weapon/gun/energy/plasma_caster/L = usr.l_hand
	if(!istype(R) && !istype(L))
		caster_active = 0
	if(caster_active) //Turn it off.
		var/found = 0
		if(R && istype(R))
			found = 1
			usr.r_hand = null
			if(R)
				M.temp_drop_inv_item(R)
				R.forceMove(src)
			M.update_inv_r_hand()
		if(L && istype(L))
			found = 1
			usr.l_hand = null
			if(L)
				M.temp_drop_inv_item(L)
				L.forceMove(src)
			M.update_inv_l_hand()
		if(found)
			to_chat(usr, SPAN_NOTICE("You deactivate your plasma caster."))
			playsound(src,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
			caster_active = 0
		return
	else //Turn it on!
		if(usr.get_active_hand())
			to_chat(usr, SPAN_WARNING("Your hand must be free to activate your caster!"))
			return
		if(!drain_power(usr,50)) return

		var/obj/item/weapon/gun/energy/plasma_caster/W = caster
		if(!istype(W))
			W = new(usr)
		usr.put_in_active_hand(W)
		W.source = src
		caster_active = 1
		to_chat(usr, SPAN_NOTICE("You activate your plasma caster."))
		playsound(src,'sound/weapons/pred_plasmacaster_on.ogg', 15, 1)
	return 1


/obj/item/clothing/gloves/yautja/proc/explodey(var/mob/living/carbon/victim)
	set waitfor = 0

	if (exploding)
		return

	exploding = 1
	var/mob/user = usr
	var/source_mob = user

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	var/turf/T = get_turf(victim)
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim) victim.gib() //Let's make sure they actually gib.
		if(explosion_type == 0 && z in SURFACE_Z_LEVELS)
			cell_explosion(T, 600, 50, null, "yautja self destruct", source_mob) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, null, "yautja self destruct", source_mob)

/obj/item/clothing/gloves/yautja/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "Activate the explosive device implanted into your bracers. You have failed! Show some honor!"
	set category = "Yautja"
	. = activate_suicide_internal(FALSE)

/obj/item/clothing/gloves/yautja/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "Changes your bracer explosion to either only gib you or be a big explosion."
	set category = "Yautja"
	if(alert("Which explosion type do you want?","Explosive Bracers", "Small", "Big") == "Big")
		explosion_type = 0
	else explosion_type = 1


/obj/item/clothing/gloves/yautja/proc/activate_suicide_internal(var/forced = FALSE)
	if(!usr) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(cloaked)
		to_chat(M, SPAN_WARNING("Not while you're cloaked. It might disrupt the sequence."))
		return
	if(!M.stat == CONSCIOUS)
		to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
		return
	if(M.stat == DEAD)
		to_chat(M, SPAN_WARNING("Little too late for that now!"))
		return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

		//Council did not want the humans to trigger SD EVER
		. = delimb_user()
		return

	var/obj/item/grab/G = M.get_active_hand()
	if(istype(G))
		var/mob/living/carbon/human/comrade = G.grabbed_thing
		if(isYautja(comrade) && comrade.stat == DEAD)
			var/obj/item/clothing/gloves/yautja/bracer = comrade.gloves
			if(istype(bracer))
				if(forced || alert("Are you sure you want to send this Yautja into the great hunting grounds?","Explosive Bracers", "Yes", "No") == "Yes")
					if(M.get_active_hand() == G && comrade && comrade.gloves == bracer && !bracer.exploding)
						var/area/A = get_area(M)
						var/turf/T = get_turf(M)
						if(A)
							message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered the predator self-destruct sequence of [comrade] ([comrade.key]) in [A.name] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)</font>"))
							log_attack("[usr.name] ([usr.ckey]) triggered the predator self-destruct sequence of [comrade] ([comrade.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explodey(comrade)
						M.visible_message(SPAN_WARNING("[M] presses a few buttons on [comrade]'s wrist bracer."),SPAN_DANGER("You activate the timer. May [comrade]'s final hunt be swift."))
						message_all_yautja("[M] has triggered [comrade]'s bracer's self-destruction sequence.")
			else
				to_chat(M, SPAN_WARNING("Your fallen comrade does not have a bracer. <b>Report this to your elder so that it's fixed.</b>"))
			return

	if(M.gloves != src)
		return

	if(exploding)
		if(forced || alert("Are you sure you want to stop the countdown?","Bracers", "Yes", "No") == "Yes")
			if(M.gloves != src)
				return
			if(M.stat == DEAD)
				to_chat(M, SPAN_WARNING("Little too late for that now!"))
				return
			if(!M.stat == CONSCIOUS)
				to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
				return
			exploding = 0
			to_chat(M, SPAN_NOTICE("Your bracers stop beeping."))
		return
	if((M.wear_mask && istype(M.wear_mask,/obj/item/clothing/mask/facehugger)) || M.status_flags & XENO_HOST)
		to_chat(M, SPAN_WARNING("Strange...something seems to be interfering with your bracer functions..."))
		return
	if(forced || alert("Detonate the bracers? Are you sure?","Explosive Bracers", "Yes", "No") == "Yes")
		if(M.gloves != src)
			return
		if(M.stat == DEAD)
			to_chat(M, SPAN_WARNING("Little too late for that now!"))
			return
		if(!M.stat == CONSCIOUS)
			to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
			return
		if(exploding)
			return
		to_chat(M, SPAN_DANGER("You set the timer. May your journey to the great hunting grounds be swift."))
		var/area/A = get_area(M)
		var/turf/T = get_turf(M)
		message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)"))
		log_attack("[usr.name] ([usr.ckey]) triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")

		explodey(M)
	return 1



/obj/item/clothing/gloves/yautja/verb/injectors()
	set name = "Create Self-Heal Crystal"
	set category = "Yautja"
	set desc = "Create a focus crystal to energize your natural healing processes."
	. = injectors_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/injectors_internal(var/forced = FALSE)
	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(usr.get_active_hand())
		to_chat(usr, SPAN_WARNING("Your active hand must be empty!"))
		return 0

	if(inject_timer)
		to_chat(usr, SPAN_WARNING("You recently activated the healing crystal. Be patient."))
		return

	if(!drain_power(usr,1000)) return

	inject_timer = 1
	spawn(1200)
		if(usr && src.loc == usr)
			to_chat(usr, SPAN_NOTICE(" Your bracers beep faintly and inform you that a new healing crystal is ready to be created."))
			inject_timer = 0

	to_chat(usr, SPAN_NOTICE(" You feel a faint hiss and a crystalline injector drops into your hand."))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(usr)
	usr.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return 1

/obj/item/clothing/gloves/yautja/verb/call_disk()
	set name = "Call Smart-Disc"
	set category = "Yautja"
	set desc = "Call back your smart-disc, if it's in range. If not you'll have to go retrieve it."
	. = call_disk_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/call_disk_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(disc_timer)
		to_chat(usr, SPAN_WARNING("Your bracers need some time to recuperate first."))
		return 0

	if(!drain_power(usr,70)) return
	disc_timer = 1
	spawn(100)
		disc_timer = 0

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(usr, SPAN_WARNING("The [S] skips back towards you!"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		D.launch_towards(usr, 10, SPEED_FAST, usr)
	return 1

/obj/item/clothing/gloves/yautja/verb/call_combi()
	set name = "Yank Combi-stick"
	set category = "Yautja"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."
	. = call_combi_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/call_combi_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(combistick_cooldown)
		to_chat(usr, SPAN_WARNING("Wait a bit before yanking the chain again!"))
		return



	for(var/obj/item/weapon/combistick/C in range(7))
		if(usr.get_active_hand() == C || usr.get_inactive_hand() == C) //Check if THIS combistick is in our hands already.
			continue
		else if(usr.put_in_active_hand(C))//Try putting it in our active hand, or, if it's full...
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
			combistick_cooldown = 1
		else if(usr.put_in_inactive_hand(C))///...Try putting it in our inactive hand.
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
			combistick_cooldown = 1
		else //If neither hand can hold it, you must not have a free hand.
			to_chat(usr, SPAN_WARNING("You need a free hand to do this!</b>"))

	if(combistick_cooldown)
		spawn(30)
		combistick_cooldown = 0

/obj/item/clothing/gloves/yautja/proc/translate()
	set name = "Translator"
	set desc = "Emit a message from your bracer to those nearby."
	set category = "Yautja"
	. = translate_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/translate_internal(var/forced = FALSE)
	if(!usr || usr.stat) return

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	var/msg = input(usr,"Your bracer beeps and waits patiently for you to input your message.","Translator","") as text
	if(!msg || !usr.client) return

	msg = sanitize(msg)
	msg = replacetext(msg, "a", "@")
	msg = replacetext(msg, "e", "3")
	msg = replacetext(msg, "i", "1")
	msg = replacetext(msg, "o", "0")
	//msg = replacetext(msg, "u", "^")
	//msg = replacetext(msg, "y", "7")
	//msg = replacetext(msg, "r", "9")
	msg = replacetext(msg, "s", "5")
	//msg = replacetext(msg, "t", "7")
	msg = replacetext(msg, "l", "1")
	//msg = replacetext(msg, "n", "*")
	   //Preds now speak in bastardized 1337speak BECAUSE. -because abby is retarded -spookydonut

	spawn(10)
		if(!drain_power(usr,50)) 
			return //At this point they've upgraded.

		log_say("Yautja Translator/[usr.client.ckey] : [msg]")

		for(var/mob/Q in hearers(usr))
			if(Q.stat && !isobserver(Q)) 
				continue //Unconscious
			to_chat(Q, "[SPAN_INFO("A strange voice says")] <span class='prefix'>'[msg]'</span>.")



//=================//\\=================\\
//======================================\\

/*
				   GEAR
*/

//======================================\\
//=================\\//=================\\

//Yautja channel. Has to delete stock encryption key so we don't receive sulaco channel.
/obj/item/device/radio/headset/yautja
	name = "\improper Communicator"
	desc = "A strange Yautja device used for projecting the Yautja's voice to the others in its pack. Similar in function to a standard human radio."
	icon_state = "communicator"
	item_state = "headset"
	frequency = YAUT_FREQ
	unacidable = TRUE
	ignore_z = TRUE
/obj/item/device/radio/headset/yautja/talk_into(mob/living/M as mob, message, channel, var/verb = "commands", var/datum/language/speaking = "Sainja")
	if(!isYautja(M)) //Nope.
		to_chat(M, SPAN_WARNING("You try to talk into the headset, but just get a horrible shrieking in your ears!"))
		return

	for(var/mob/living/carbon/hellhound/H in player_list)
		if(istype(H) && !H.stat)
			to_chat(H, "\[Radio\]: [M.real_name] [verb], '<B>[message]</b>'.")
	..()

/obj/item/device/radio/headset/yautja/attackby()
	return

/obj/item/device/encryptionkey/yautja
	name = "\improper Yautja encryption key"
	desc = "A complicated encryption device."
	icon_state = "cypherkey"
	channels = list("Yautja" = 1)

//Yes, it's a backpack that goes on the belt. I want the backpack noises. Deal with it (tm)
/obj/item/storage/backpack/yautja
	name = "hunting pouch"
	desc = "A Yautja hunting pouch worn around the waist, made from a thick tanned hide. Capable of holding various devices and tools and used for the transport of trophies."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "beltbag"
	flags_equip_slot = SLOT_WAIST
	max_w_class = SIZE_MEDIUM
	storage_slots = 10
	max_storage_space = 30

/obj/item/storage/backpack/yautja/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/storage/backpack/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/storage/backpack/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()


/obj/item/device/yautja_teleporter
	name = "relay beacon"
	desc = "A device covered in sacred text. It whirrs and beeps every couple of seconds."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "teleporter"

	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	force = 1
	throwforce = 1
	unacidable = TRUE
	var/timer = 0

/obj/item/device/yautja_teleporter/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/device/yautja_teleporter/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/device/yautja_teleporter/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/device/yautja_teleporter/attack_self(mob/user)
	set waitfor = 0
	if(istype(get_area(user),/area/yautja))
		var/almayer = alert("Travel to the ooman ship?","Sure?","Yes","No")
		if(almayer == "No" || !almayer) return
		playsound(src,'sound/ambience/signal.ogg', 25, 1)
		timer = 1
		user.visible_message(SPAN_INFO("[user] starts becoming shimmery and indistinct..."))
		if(do_after(user,100, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			// Teleport self.
			user.visible_message(SPAN_WARNING("[htmlicon(user, viewers(src))][user] disappears!"))
			var/tele_time = animation_teleport_quick_out(user)
			// Also teleport whoever you're pulling.
			var/mob/living/M = user.pulling
			if(istype(M))
				M.visible_message(SPAN_WARNING("[htmlicon(M, viewers(src))][M] disappears!"))
				animation_teleport_quick_out(M)
			sleep(tele_time)

			var/turf/end_turf = pick(yautja_almayer_loc)
			user.forceMove(end_turf)
			animation_teleport_quick_in(user)
			if(M && M.loc)
				M.forceMove(end_turf)
				animation_teleport_quick_in(M)
			timer = 0
		else
			sleep(10)
			if(loc) timer = 0
		return
	var/mob/living/carbon/human/H = user
	var/sure = alert("Really trigger it?","Sure?","Yes","No")
	if(!isYautja(H))
		to_chat(user, SPAN_WARNING("The screen angrily flashes three times!"))
		playsound(user, 'sound/effects/EMPulse.ogg', 25, 1)
		do_after(user, 30, INTERRUPT_NONE, 1)
		explosion(loc,-1,-1,2)
		if(loc)
			if(ismob(loc))
				user = loc
				user.temp_drop_inv_item(src)
			qdel(src)
		return

	if(sure == "No" || !sure) return
	playsound(src,'sound/ambience/signal.ogg', 25, 1)
	timer = 1
	user.visible_message(SPAN_INFO("[user] starts becoming shimmery and indistinct..."))
	if(do_after(user,100, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		// Teleport self.
		user.visible_message(SPAN_WARNING("[htmlicon(user, viewers(src))][user] disappears!"))
		var/tele_time = animation_teleport_quick_out(user)
		// Also teleport whoever you're pulling.
		var/mob/living/M = user.pulling
		if(istype(M))
			M.visible_message(SPAN_WARNING("[htmlicon(M, viewers(src))][M] disappears!"))
			animation_teleport_quick_out(M)
		sleep(tele_time)

		var/turf/end_turf = pick(pred_spawn)
		user.forceMove(end_turf)
		animation_teleport_quick_in(user)
		if(M && M.loc)
			M.forceMove(end_turf)
			animation_teleport_quick_in(M)
		timer = 0
	else
		sleep(10)
		if(loc) timer = 0

//=================//\\=================\\
//======================================\\

/*
			  MELEE WEAPONS
*/

//======================================\\
//=================\\//=================\\

/obj/item/weapon/harpoon/yautja
	name = "large harpoon"
	desc = "A huge metal spike, with a hook at the end. It's carved with mysterious alien writing."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "spike"
	item_state = "harpoon"
	embeddable = FALSE
	attack_verb = list("jabbed","stabbed","ripped", "skewered")
	unacidable = TRUE
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = IS_SHARP_ITEM_BIG

/obj/item/weapon/harpoon/yautja/New()
	force = config.min_hit_damage
	throwforce = config.high_hit_damage
	
/obj/item/weapon/wristblades
	name = "wrist blades"
	desc = "A pair of huge, serrated blades extending from a metal gauntlet."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "wrist"
	item_state = "wristblade"
	w_class = SIZE_HUGE
	edge = 1
	sharp = 2
	flags_item = NOSHIELD|NODROP|ITEM_PREDATOR
	flags_equip_slot = NO_FLAGS
	hitsound = 'sound/weapons/wristblades_hit.ogg'
	attack_speed = 6
	pry_capable = IS_PRY_CAPABLE_FORCE

/obj/item/weapon/wristblades/New()
	..()
	if(usr)
		var/obj/item/weapon/wristblades/W = usr.get_inactive_hand()
		if(istype(W)) //wristblade in usr's other hand.
			attack_speed = attack_speed - attack_speed/3
	attack_verb = list("sliced", "slashed", "jabbed", "torn", "gored")
	force = config.hlmed_hit_damage

/obj/item/weapon/wristblades/Dispose()
	. = ..()
	return GC_HINT_RECYCLE

/obj/item/weapon/wristblades/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/wristblades_off.ogg', 15, 1)
	if(M)
		var/obj/item/weapon/wristblades/W = M.get_inactive_hand()
		if(istype(W))
			W.attack_speed = initial(attack_speed)
	..()

/obj/item/weapon/wristblades/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !user) return
	if(user)
		var/obj/item/weapon/wristblades/W = user.get_inactive_hand()
		attack_speed = (istype(W)) ? 4 : initial(attack_speed)

	if (istype(A, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/D = A
		if(D.operating || !D.density) return
		to_chat(user, SPAN_NOTICE("You jam [src] into [D] and strain to rip it open."))
		playsound(user,'sound/weapons/wristblades_hit.ogg', 15, 1)
		if(do_after(user,30, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && D.density)
			D.open(1)

/obj/item/weapon/wristblades/attack_self(mob/user)
	for(var/obj/item/clothing/gloves/yautja/Y in user.contents)
		Y.wristblades()

//I need to go over these weapons and balance them out later. Right now they're pretty all over the place.
/obj/item/weapon/yautja_chain
	name = "chainwhip"
	desc = "A segmented, lightweight whip made of durable, acid-resistant metal. Not very common among Yautja Hunters, but still a dangerous weapon capable of shredding prey."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "whip"
	item_state = "whip"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_WAIST
	embeddable = FALSE
	w_class = SIZE_MEDIUM
	unacidable = TRUE
	sharp = 0
	edge = 0
	attack_verb = list("whipped", "slashed","sliced","diced","shredded")
	hitsound = 'sound/weapons/chain_whip.ogg'


/obj/item/weapon/yautja_chain/New()
	force = config.buckshot_hit_damage
	throwforce = config.base_hit_damage

/obj/item/weapon/yautja_chain/attack(mob/target, mob/living/user)
	. = ..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30
	if(. && user.zone_selected == "r_leg" || user.zone_selected == "l_leg" || user.zone_selected == "l_foot" || user.zone_selected == "r_foot")
		if(prob(35) && !target.lying)
			if(isXeno(target))
				if(target.mob_size == MOB_SIZE_BIG) //Can't trip the big ones.
					return
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1)
			user.visible_message(SPAN_DANGER("[src] lashes out and [target] goes down!"),SPAN_DANGER("<b>You trip [target]!</b>"))
			target.KnockDown(5)

/obj/item/weapon/yautja_chain/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()


/obj/item/weapon/yautja_sword
	name = "clan sword"
	desc = "An expertly crafted Yautja blade carried by hunters who wish to fight up close. Razor sharp, and capable of cutting flesh into ribbons. Commonly carried by aggresive and lethal hunters."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "clansword"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_BACK
	sharp = 1
	edge = 1
	embeddable = FALSE
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9
	unacidable = TRUE

/obj/item/weapon/yautja_sword/New()
	force = config.med_hit_damage //More damage than other weapons like it. Considering how "strong" this sword is supposed to be, 38 damage was laughable.
	throwforce = config.min_hit_damage

/obj/item/weapon/yautja_sword/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_sword/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_sword/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(isYautja(user))
		if(isXeno(target))
			var/mob/living/carbon/Xenomorph/X = target
			X.interference = 30
		force = config.med_hit_damage
		if(prob(22) && !target.lying)
			user.visible_message(SPAN_DANGER("[user] slashes [target] so hard, they go flying!"))
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1)
			target.KnockDown(3)
			step_away(target,user,1)
	else
		to_chat(user, SPAN_WARNING("You aren't strong enough to swing the sword properly!"))
		force = round(config.med_hit_damage/2)
		if(prob(50)) user.make_dizzy(80)

/obj/item/weapon/yautja_sword/pickup(mob/living/user as mob)
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You struggle to pick up the huge, unwieldy sword. It makes you dizzy just trying to hold it!"))
		user.make_dizzy(50)
	else
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_scythe
	name = "double war scythe"
	desc = "A huge, incredibly sharp double blade used for hunting dangerous prey. This weapon is commonly carried by Yautja who wish to disable and slice apart their foes.."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "predscythe"
	item_state = "scythe"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_WAIST
	sharp = 1
	embeddable = FALSE
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	unacidable = TRUE

/obj/item/weapon/yautja_scythe/New()
	icon_state = pick("predscythe","predscythe_alt")
	force = config.hmed_hit_damage
	throwforce = config.mlow_hit_damage

/obj/item/weapon/yautja_scythe/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_scythe/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_scythe/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/yautja_scythe/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(!isYautja(user))
		if(prob(20))
			user.visible_message(SPAN_WARNING("[src] slips out of your hands!"))
			user.drop_inv_item_on_ground(src)
			return
	..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30
	if(ishuman(target)) //Slicey dicey!
		if(prob(14))
			var/obj/limb/affecting
			var/mob/living/carbon/human/H = target
			affecting = H.get_limb(ran_zone(user.zone_selected,60))
			if(!affecting)
				affecting = H.get_limb(ran_zone(user.zone_selected,90)) //No luck? Try again.
			if(affecting)
				if(affecting.body_part != BODY_FLAG_CHEST && affecting.body_part != BODY_FLAG_GROIN) //as hilarious as it is
					user.visible_message(SPAN_DANGER("The limb is sliced clean off!"),SPAN_DANGER("You slice off a limb!"))
					affecting.droplimb(1, 0, initial(name)) //the second 1 is  amputation. This amputates.
	else //Probably an alien
		if(prob(14))
			..() //Do it again! CRIT!

	return

//Combistick
/obj/item/weapon/combistick
	name = "combi-stick"
	desc = "A compact yet deadly personal weapon. Can be concealed when folded. Functions well as a throwing weapon or defensive tool. A common sight in Yautja packs due to its versatility."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "combistick"
	flags_atom = FPRINT|CONDUCT|ITEM_UNCATCHABLE
	flags_equip_slot = SLOT_BACK
	flags_item = TWOHANDED|ITEM_PREDATOR
	w_class = SIZE_LARGE
	embeddable = FALSE //It shouldn't embed so that the Yautja can actually use the yank combi verb, and so that it's not useless upon throwing it at someone.
	throw_speed = SPEED_VERY_FAST
	unacidable = TRUE
	sharp = IS_SHARP_ITEM_ACCURATE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("speared", "stabbed", "impaled")
	var/on = 1
	var/timer = 0

/obj/item/weapon/combistick/New()
	throwforce = config.med_hit_damage
	force = config.hlmed_hit_damage

/obj/item/weapon/combistick/IsShield()
	return on

/obj/item/weapon/combistick/Dispose()
	remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/combistick/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/combistick/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/combistick/wield(var/mob/user)
	..()
	force = config.lmed_plus_hit_damage
	update_icon()

/obj/item/weapon/combistick/unwield(mob/user)
	..()
	force = config.hlmed_hit_damage
	update_icon()

/obj/item/weapon/combistick/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Activate or deactivate the combistick."

	unique_action(usr)

/obj/item/weapon/combistick/attack_self(mob/user)
	..()
	if(on)
		if(flags_item & WIELDED) unwield(user)
		else 				wield(user)
	else
		to_chat(user, SPAN_WARNING("You need to extend the combi-stick before you can wield it."))

/obj/item/weapon/combistick/update_icon()
	if(flags_item & WIELDED)
		item_state = "combistick_w"
	else item_state = "combistick"

/obj/item/weapon/combistick/unique_action(mob/living/user)
	if(user.get_active_hand() != src)
		return
	if(timer) return
	on = !on
	if(on)
		user.visible_message(SPAN_INFO("With a flick of their wrist, [user] extends [src]."),\
		SPAN_NOTICE("You extend [src]."),\
		"You hear blades extending.")
		playsound(src,'sound/handling/combistick_open.ogg', 50, 1, 3)
		icon_state = initial(icon_state)
		flags_equip_slot = initial(flags_equip_slot)
		flags_item |= TWOHANDED
		w_class = SIZE_LARGE
		force = config.lmed_hit_damage
		throwforce = config.med_hit_damage
		attack_verb = list("speared", "stabbed", "impaled")
		timer = 1
		spawn(10)
			timer = 0

		if(blood_overlay && blood_color)
			overlays.Cut()
			add_blood(blood_color)
	else
		unwield(user)
		to_chat(user, SPAN_NOTICE("You collapse [src] for storage."))
		playsound(src, 'sound/handling/combistick_close.ogg', 50, 1, 3)
		icon_state = initial(icon_state) + "_f"
		flags_equip_slot = SLOT_STORE
		flags_item &= ~TWOHANDED
		w_class = SIZE_TINY
		force = config.base_hit_damage
		throwforce = config.med_hit_damage - config.lmed_plus_hit_damage
		attack_verb = list("thwacked", "smacked")
		timer = 1
		spawn(10)
			timer = 0
		overlays.Cut()

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)

	return

/obj/item/weapon/combistick/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30
	..()

/obj/item/weapon/combistick/attack_hand(mob/user) //Prevents marines from instantly picking it up via pickup macros.
	if(!isYautja(user))
		user.visible_message(SPAN_NOTICE("You start to untangle the chain on \the [src]..."))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			..()
	else ..()

/obj/item/weapon/combistick/launch_impact(atom/hit_atom)
	if(isYautja(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(H.put_in_hands(src))
			hit_atom.visible_message(SPAN_NOTICE(" [hit_atom] expertly catches [src] out of the air. "), \
				SPAN_NOTICE(" You easily catch [src]. "))
			return
	..()

//=================//\\=================\\
//======================================\\

/*
			   OTHER THINGS
*/

//======================================\\
//=================\\//=================\\

/obj/item/explosive/grenade/spawnergrenade/hellhound
	name = "hellhound caller"
	spawner_type = /mob/living/carbon/hellhound
	deliveryamt = 1
	desc = "A strange piece of alien technology. It seems to call forth a hellhound."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "hellnade"
	w_class = SIZE_TINY
	det_time = 30
	var/obj/structure/machinery/camera/current = null
	var/turf/activated_turf = null

	dropped(mob/user)
		check_eye(user)
		return ..()

	attack_self(mob/user)
		if(!active)
			if(!isYautja(user))
				to_chat(user, "What's this thing?")
				return
			to_chat(user, SPAN_WARNING("You activate the hellhound beacon!"))
			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.toggle_throw_mode(THROW_MODE_NORMAL)
		else
			if(!isYautja(user)) return
			activated_turf = get_turf(user)
			display_camera(user)
		return

	activate(mob/user)
		if(active)
			return

		if(user)
			msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		icon_state = initial(icon_state) + "_active"
		active = 1
		update_icon()
		add_timer(CALLBACK(src, .proc/prime), det_time)

	prime()
		if(spawner_type && deliveryamt)
			// Make a quick flash
			var/turf/T = get_turf(src)
			if(ispath(spawner_type))
				new spawner_type(T)
//		qdel(src)
		return

	check_eye(mob/user)
		if (user.is_mob_incapacitated() || user.blinded )
			user.unset_interaction()
		else if ( !current || get_turf(user) != activated_turf || src.loc != user ) //camera doesn't work, or we moved.
			user.unset_interaction()


	proc/display_camera(var/mob/user as mob)
		var/list/L = list()
		for(var/mob/living/carbon/hellhound/H in mob_list)
			L += H.real_name
		L["Cancel"] = "Cancel"

		var/choice = input(user,"Which hellhound would you like to observe? (moving will drop the feed)","Camera View") as null|anything in L
		if(!choice || choice == "Cancel" || isnull(choice))
			user.unset_interaction()
			to_chat(user, "Stopping camera feed.")
			return

		for(var/mob/living/carbon/hellhound/Q in mob_list)
			if(Q.real_name == choice)
				current = Q.camera
				break

		if(istype(current))
			to_chat(user, "Switching feed..")
			user.set_interaction(current)

		else
			to_chat(user, "Something went wrong with the camera feed.")
		return

/obj/item/explosive/grenade/spawnergrenade/hellhound/New()
	force = config.mlow_hit_damage
	throwforce = config.hmed_hit_damage

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_set_interaction(mob/user)
	..()
	user.reset_view(current)

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_unset_interaction(mob/user)
	..()
	current = null
	user.reset_view(null)
