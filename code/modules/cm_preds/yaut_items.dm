//Items specific to yautja. Other people can use em, they're not restricted or anything.
//They can't, however, activate any of the special functions.
//Thrall subtypes are located in /code/modules/cm_preds/thrall_items.dm

/proc/add_to_missing_pred_gear(var/obj/item/W)
	if(!is_admin_level(W.z))
		GLOB.loose_yautja_gear |= W

/proc/remove_from_missing_pred_gear(var/obj/item/W)
	GLOB.loose_yautja_gear -= W

//=================//\\=================\\
//======================================\\

/*
				 EQUIPMENT
*/

//======================================\\
//=================\\//=================\\

/obj/item/clothing/suit/armor/yautja
	name = "ancient alien armor"
	desc = "Ancient armor made from a strange alloy. It feels cold with an alien weight."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "halfarmor1_ebony"
	item_state = "armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_item = ITEM_PREDATOR
	slowdown = SLOWDOWN_ARMOR_NONE
	min_cold_protection_temperature = ARMOR_min_cold_protection_temperature
	max_heat_protection_temperature = ARMOR_max_heat_protection_temperature
	siemens_coefficient = 0.1
	allowed = list(/obj/item/weapon/melee/harpoon,
			/obj/item/weapon/gun/launcher/spike,
			/obj/item/weapon/gun/energy/yautja,
			/obj/item/weapon/melee/yautja,
			/obj/item/weapon/melee/twohanded/yautja)
	unacidable = TRUE
	item_state_slots = list(WEAR_JACKET = "halfarmor1")
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	var/thrall = FALSE//Used to affect icon generation.
	fire_intensity_resistance = 10

/obj/item/clothing/suit/armor/yautja/Initialize(mapload, armor_number = rand(1,7), armor_material = "ebony", elder_restricted = 0)
	. = ..()
	if(thrall)
		return
	if(elder_restricted)
		switch(armor_number)
			if(1341)
				name = "\improper 'Armor of the Dragon'"
				icon_state = "halfarmor_elder_tr"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_tr")
			if(7128)
				name = "\improper 'Armor of the Swamp Horror'"
				icon_state = "halfarmor_elder_joshuu"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_joshuu")
			if(9867)
				name = "\improper 'Armor of the Enforcer'"
				icon_state = "halfarmor_elder_feweh"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_feweh")
			if(4879)
				name = "\improper 'Armor of the Ambivalent Collector'"
				icon_state = "halfarmor_elder_n"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_n")
			else
				name = "clan elder's armor"
				icon_state = "halfarmor_elder"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder")
	else
		if(armor_number > 7)
			armor_number = 1
		if(armor_number) //Don't change full armor number
			icon_state = "halfarmor[armor_number]_[armor_material]"
			LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor[armor_number]_[armor_material]")

	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

/obj/item/clothing/suit/armor/yautja/hunter
	name = "clan armor"
	desc = "A suit of armor with light padding. It looks old, yet functional."

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH


/obj/item/clothing/suit/armor/yautja/hunter/full
	name = "heavy clan armor"
	desc = "A suit of armor with heavy padding. It looks old, yet functional."
	icon_state = "fullarmor_ebony"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HEAD|BODY_FLAG_LEGS
	flags_item = ITEM_PREDATOR
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	slowdown = 1
	var/speed_timer = 0
	item_state_slots = list(WEAR_JACKET = "fullarmor")
	allowed = list(/obj/item/weapon/melee/harpoon,
			/obj/item/weapon/gun/launcher/spike,
			/obj/item/weapon/gun/energy/yautja,
			/obj/item/weapon/melee/yautja,
			/obj/item/storage/backpack/yautja,
			/obj/item/weapon/melee/twohanded/yautja)
	fire_intensity_resistance = 20

/obj/item/clothing/suit/armor/yautja/hunter/full/Initialize(mapload, armor_number, armor_material = "ebony")
	. = ..(mapload, 0)
	icon_state = "fullarmor_[armor_material]"
	LAZYSET(item_state_slots, WEAR_JACKET, "fullarmor_[armor_material]")


/obj/item/clothing/yautja_cape
	name = PRED_YAUTJA_CAPE
	desc = "A battle-worn cape passed down by elder Yautja."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "fullcape"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	flags_equip_slot = SLOT_BACK
	flags_item = ITEM_PREDATOR
	unacidable = TRUE
	var/clan_rank_required = CLAN_RANK_LEADER_INT
	var/councillor_override = FALSE

/obj/item/clothing/yautja_cape/Initialize(mapload, var/new_color = "#654321")
	. = ..()
	color = new_color

/obj/item/clothing/yautja_cape/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/yautja_cape/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/yautja_cape/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/clothing/yautja_cape/ceremonial
	name = PRED_YAUTJA_CEREMONIAL_CAPE
	icon_state = "ceremonialcape"
	councillor_override = TRUE

/obj/item/clothing/yautja_cape/third
	name = PRED_YAUTJA_THIRD_CAPE
	icon_state = "thirdcape"
	clan_rank_required = CLAN_RANK_ELDER_INT

/obj/item/clothing/yautja_cape/half
	name = PRED_YAUTJA_HALF_CAPE
	icon_state = "halfcape"
	clan_rank_required = CLAN_RANK_ELITE_INT

/obj/item/clothing/yautja_cape/quarter
	name = PRED_YAUTJA_QUARTER_CAPE
	icon_state = "quartercape"
	clan_rank_required = CLAN_RANK_BLOODED_INT

/obj/item/clothing/yautja_cape/poncho
	name = PRED_YAUTJA_PONCHO
	icon_state = "councilor_poncho"
	clan_rank_required = CLAN_RANK_ADMIN_INT
	councillor_override = TRUE

/obj/item/clothing/shoes/yautja
	name = "ancient alien greaves"
	desc = "Greaves made from scraps of cloth and a strange alloy. They feel cold with an alien weight."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "y-boots1_ebony"

	unacidable = TRUE
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_item = ITEM_PREDATOR

	siemens_coefficient = 0.2
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	items_allowed = list(
		/obj/item/weapon/melee/yautja/knife,
		/obj/item/weapon/gun/energy/yautja/plasmapistol
		)


	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	var/thrall = FALSE//Used to affect icon generation.
	fire_intensity_resistance = 10

/obj/item/clothing/shoes/yautja/New(location, boot_number = rand(1,4), armor_material = "ebony")
	..()
	if(thrall)
		return
	if(boot_number > 4)
		boot_number = 1
	icon_state = "y-boots[boot_number]_[armor_material]"

	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

/obj/item/clothing/shoes/yautja/hunter
	name = "clan greaves"
	desc = "A pair of armored, perfectly balanced boots. Perfect for running through the jungle."

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/shoes/yautja/hunter/knife/New()
	..()
	stored_item = new /obj/item/weapon/melee/yautja/knife(src)
	update_icon()
/obj/item/clothing/under/chainshirt
	name = "ancient alien mesh suit"
	desc = "A strange alloy weave in the form of a vest. It feels cold with an alien weight."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "mesh_shirt"
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS //Does not cover the head though.
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS
	flags_item = ITEM_PREDATOR
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_YAUTJA
	siemens_coefficient = 0.9
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/under/chainshirt/hunter
	name = "body mesh"
	desc = "A set of very fine chainlink in a meshwork for comfort and utility."

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

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

/obj/item/device/radio/headset/yautja/talk_into(mob/living/M as mob, message, channel, var/verb = "commands", var/datum/language/speaking)
	if(!isYautja(M)) //Nope.
		to_chat(M, SPAN_WARNING("You try to talk into the headset, but just get a horrible shrieking in your ears!"))
		return

	for(var/mob/living/carbon/Xenomorph/Hellhound/hellhound as anything in GLOB.hellhound_list)
		if(!hellhound.stat)
			to_chat(hellhound, "\[Radio\]: [M.real_name] [verb], '<B>[message]</b>'.")
	..()

/obj/item/device/radio/headset/yautja/attackby()
	return

/obj/item/device/radio/headset/yautja/elder //primarily for use in another MR
	name = "\improper Elder Communicator"
	volume_settings = list(RADIO_VOLUME_QUIET_STR, RADIO_VOLUME_RAISED_STR, RADIO_VOLUME_IMPORTANT_STR, RADIO_VOLUME_CRITICAL_STR)

/obj/item/device/encryptionkey/yautja
	name = "\improper Yautja encryption key"
	desc = "A complicated encryption device."
	icon_state = "cypherkey"
	channels = list(RADIO_CHANNEL_YAUTJA = 1)

//Yes, it's a backpack that goes on the belt. I want the backpack noises. Deal with it (tm)
/obj/item/storage/backpack/yautja
	name = "hunting pouch"
	desc = "A Yautja hunting pouch worn around the waist, made from a thick tanned hide. Capable of holding various devices and tools and used for the transport of trophies."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "beltbag"
	item_state = "beltbag_w"
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	flags_equip_slot = SLOT_WAIST
	max_w_class = SIZE_MEDIUM
	flags_item = ITEM_PREDATOR
	storage_slots = 12
	max_storage_space = 30


/obj/item/device/yautja_teleporter
	name = "relay beacon"
	desc = "A device covered in sacred text. It whirrs and beeps every couple of seconds."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "teleporter"

	flags_item = ITEM_PREDATOR
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	force = 1
	throwforce = 1
	unacidable = TRUE
	var/timer = 0

/obj/item/device/yautja_teleporter/attack_self(mob/user)
	set waitfor = FALSE

	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/ship_to_tele = list("Public" = -1, "Human Ship" = "Human")

	if(!isYautja(H) || is_admin_level(H.z))
		to_chat(user, SPAN_WARNING("You fiddle with it, but nothing happens!"))
		return

	if(H.client && H.client.clan_info)
		var/datum/entity/clan_player/clan_info = H.client.clan_info
		if(clan_info.permissions & CLAN_PERMISSION_ADMIN_VIEW)
			var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)
			for(var/datum/view_record/clan_view/CV in CPV)
				if(!SSpredships.is_clanship_loaded(CV?.clan_id))
					continue
				ship_to_tele += list("[CV.name]" = "[CV.clan_id]: [CV.name]")
		if(SSpredships.is_clanship_loaded(clan_info?.clan_id))
			ship_to_tele += list("Your clan" = "[clan_info.clan_id]")

	var/clan = ship_to_tele[tgui_input_list(H, "Select a ship to teleport to", "[src]", ship_to_tele)]
	if(clan != "Human" && !SSpredships.is_clanship_loaded(clan))
		return // Checking ship is valid

	// Getting an arrival point
	var/turf/target_turf
	if(clan == "Human")
		var/obj/effect/landmark/yautja_teleport/pickedYT = pick(GLOB.mainship_yautja_teleports)
		target_turf = get_turf(pickedYT)
	else
		target_turf = SAFEPICK(SSpredships.get_clan_spawnpoints(clan))
	if(!istype(target_turf))
		return

	// Let's go
	playsound(src,'sound/ambience/signal.ogg', 25, 1, sound_range = 6)
	timer = 1
	user.visible_message(SPAN_INFO("[user] starts becoming shimmery and indistinct..."))

	if(do_after(user, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		// Display fancy animation for you and the person you might be pulling (Legacy)
		user.visible_message(SPAN_WARNING("[icon2html(user, viewers(src))][user] disappears!"))
		var/tele_time = animation_teleport_quick_out(user)
		var/mob/living/M = user.pulling
		if(istype(M)) // Pulled person
			M.visible_message(SPAN_WARNING("[icon2html(M, viewers(src))][M] disappears!"))
			animation_teleport_quick_out(M)

		sleep(tele_time) // Animation delay
		user.trainteleport(target_turf) // Actually teleports everyone, not just you + pulled

		// Undo animations
		animation_teleport_quick_in(user)
		if(istype(M) && !QDELETED(M))
			animation_teleport_quick_in(M)
		timer = 0
	else
		addtimer(VARSET_CALLBACK(src, timer, FALSE), 1 SECONDS)

/obj/item/device/yautja_teleporter/verb/add_tele_loc()
	set name = "Add Teleporter Destination"
	set desc = "Adds this location to the teleporter."
	set category = "Yautja.Utility"
	set src in usr
	if(!usr || usr.stat || !is_ground_level(usr.z))
		return

	if(istype(usr.buckled, /obj/structure/bed/nest/))
		return

	if(loc && istype(usr.loc, /turf))
		var/turf/location = usr.loc
		GLOB.yautja_teleports += location
		var/name = input("What would you like to name this location?", "Text") as null|text
		if(!name)
			return
		GLOB.yautja_teleport_descs[name + location.loc_to_string()] = location
		to_chat(usr, SPAN_WARNING("You can now teleport to this location!"))
		log_game("[usr] ([usr.key]) has created a new teleport location at [get_area(usr)]")
		message_all_yautja("[usr.real_name] has created a new teleport location, [name], at [usr.loc] in [get_area(usr)]")

//=================//\\=================\\
//======================================\\

/*
			   OTHER THINGS
*/

//======================================\\
//=================\\//=================\\

/obj/item/scalp
	name = "scalp"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "scalp_1"
	item_state = "scalp"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	var/true_desc = "This is the scalp of a" //humans and Yautja see different things when examining these.
	appearance_flags = NO_FLAGS //So that the blood overlay renders separately and isn't affected by the hair colour matrix.

/obj/item/scalp/Initialize(mapload, mob/living/carbon/human/scalpee, mob/living/carbon/human/user)
	. = ..()

	var/variant = rand(1, 4) //Random sprite variant.
	icon_state = "scalp_[variant]"
	blood_color =  "#A10808" //So examine describes it as 'bloody'. Synths can't be scalped so it'll always be human blood.
	flags_atom = FPRINT|NOBLOODY //Don't want the ugly item blood overlay ending up on this. We'll use our own blood overlay.

	var/image/blood_overlay = image('icons/obj/items/hunter/pred_gear.dmi', "scalp_[variant]_blood")
	blood_overlay.appearance_flags = RESET_COLOR
	overlays += blood_overlay

	if(!scalpee) //Presumably spawned as map decoration.
		true_desc = "This is the scalp of an irrelevant human."
		color = list(null, null, null, null, rgb(rand(0,255), rand(0,255), rand(0,255)))
		return

	name = "\proper [scalpee.real_name]'s scalp"
	color = list(null, null, null, null, rgb(scalpee.r_hair, scalpee.g_hair, scalpee.b_hair)) //Hair colour.

	var/they = "they"
	var/their = "their"
	var/them = "them"
	var/themselves = "themselves"

	//Gender?
	switch(scalpee.gender)
		if(MALE)
			their = "his"
			they = "he"
			them = "him"
			themselves = "himself"

		if(FEMALE)
			their = "her"
			they = "she"
			them = "her"
			themselves = "herself"

	//What did this person do?
	var/list/biography = list()
	//Did they disgrace themselves more than humans usually do?
	var/dishonourable = FALSE
	//Did they distinguish themselves?
	var/honourable = FALSE

	if(scalpee.hunter_data.thralled)
		biography += "enthralled by [scalpee.hunter_data.thralled_set.real_name] for '[scalpee.hunter_data.thralled_reason]'"
		honourable = TRUE

	if(scalpee.hunter_data.honored)
		biography += "honored for '[scalpee.hunter_data.honored_reason]'"
		honourable = TRUE

	if(scalpee.hunter_data.dishonored)
		biography +=  "marked as dishonorable for '[scalpee.hunter_data.dishonored_reason]'"
		dishonourable = TRUE

	if(scalpee.hunter_data.gear)
		biography +=  "killed after [scalpee.hunter_data.gear_set.real_name] marked [them] as a thief of Yautja equipment"
		dishonourable = TRUE

	//How impressive a trophy is this?
	var/worth = 1
	switch(scalpee.life_kills_total)
		if(0)
			if(dishonourable)
				true_desc += " human who was even more shameful than usual."
				worth = -1
			else if(honourable) //They weren't marked as killing anyone but otherwise distinguished themselves.
				true_desc += " human."
			else
				true_desc += "n irrelevant human."
				worth = 0

		if(1 to 4)
			if(dishonourable)
				true_desc += " human who could have been worthy, had [they] not insisted on disgracing [themselves]."
				worth = -1
			else
				true_desc += " respectable human with blood on [their] hands."

		if(5 to 9)
			true_desc += "n uncommonly destructive human."
			if(!dishonourable)
				worth = 2 //Even if they did do something dishonourable, this person is worth at least grudging respect.

		if(10 to INFINITY)
			true_desc += " truly worthy human, no doubt descended from many storied warriors. [capitalize(their)] arms were soaked to the elbows with the life-blood of many."
			worth = 2

	if(length(biography))
		true_desc += " [scalpee.real_name] was [english_list(biography, final_comma_text = ",")]."

	if(scalpee.hunter_data.hunter == user) //You don't get your name on it unless you hunted them yourself.
		switch(worth)
			if(-1)
				true_desc += SPAN_BLUE("\n[user.real_name] had the unpleasant duty of running [them] to ground.")
			if(0) //You hunted someone with no kills for no real reason.
				true_desc += SPAN_BLUE("\nAn honourable first trophy for a truly precocious child. [user.real_name]'s parents must be so proud.")
			if(1)
				true_desc += SPAN_BLUE("\nThis trophy was taken by [user.real_name] after a successful hunt.")
			if(2)
				true_desc += SPAN_BLUE("\nThis fine trophy was taken by [user.real_name] after a successful hunt.")

/obj/item/scalp/get_examine_text(mob/user)
	. = ..()
	if(isYautja(user) || isobserver(user))
		. += true_desc
	else
		. += SPAN_WARNING("Scalp-collecting is supposed to be a <i>joke</i>. Has someone been going around doing this shit for real? What next, a necklace of severed ears? Jesus Christ.")

/obj/item/explosive/grenade/spawnergrenade/hellhound
	name = "hellhound caller"
	spawner_type = /mob/living/carbon/Xenomorph/Hellhound
	deliveryamt = 1
	desc = "A strange piece of alien technology. It seems to call forth a hellhound."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "hellnade"
	w_class = SIZE_TINY
	det_time = 30
	var/obj/structure/machinery/camera/current = null
	var/turf/activated_turf = null

/obj/item/explosive/grenade/spawnergrenade/hellhound/dropped(mob/user)
	check_eye(user)
	return ..()

/obj/item/explosive/grenade/spawnergrenade/hellhound/attack_self(mob/living/carbon/human/user)
	..()
	if(!active)
		if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			to_chat(user, SPAN_WARNING("What's this thing?"))
			return
		to_chat(user, SPAN_WARNING("You activate the hellhound beacon!"))
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/explosive/grenade/spawnergrenade/hellhound/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name(user)] primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	icon_state = initial(icon_state) + "_active"
	active = 1
	update_icon()
	addtimer(CALLBACK(src, .proc/prime), det_time)

/obj/item/explosive/grenade/spawnergrenade/hellhound/prime()
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		if(ispath(spawner_type))
			new spawner_type(T)
	return

/obj/item/explosive/grenade/spawnergrenade/hellhound/check_eye(mob/user)
	if (user.is_mob_incapacitated() || user.blinded )
		user.unset_interaction()
	else if ( !current || get_turf(user) != activated_turf || src.loc != user ) //camera doesn't work, or we moved.
		user.unset_interaction()

/obj/item/explosive/grenade/spawnergrenade/hellhound/New()
	. = ..()

	force = 20
	throwforce = 40

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_set_interaction(mob/user)
	..()
	user.reset_view(current)

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_unset_interaction(mob/user)
	..()
	current = null
	user.reset_view(null)


// Hunting traps
/obj/item/hunting_trap
	name = "hunting trap"
	throw_speed = SPEED_FAST
	throw_range = 2
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "yauttrap0"
	desc = "A bizarre Yautja device used for trapping and killing prey."
	var/armed = 0
	var/datum/effects/tethering/tether_effect
	var/tether_range = 5
	var/mob/trapped_mob
	layer = LOWER_ITEM_LAYER

/obj/item/hunting_trap/Destroy()
	cleanup_tether()
	trapped_mob = null
	. = ..()

/obj/item/hunting_trap/dropped(var/mob/living/carbon/human/mob) //Changes to "camouflaged" icons based on where it was dropped.
	if(armed && isturf(mob.loc))
		var/turf/T = mob.loc
		if(istype(T,/turf/open/gm/dirt))
			icon_state = "yauttrapdirt"
		else if (istype(T,/turf/open/gm/grass))
			icon_state = "yauttrapgrass"
		else
			icon_state = "yauttrap1"
	..()

/obj/item/hunting_trap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		var/wait_time = 3 SECONDS
		if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			wait_time = rand(5 SECONDS, 10 SECONDS)
		if(!do_after(user, wait_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return
		armed = TRUE
		anchored = TRUE
		icon_state = "yauttrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now armed."))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has armed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has armed \a [src] at [get_location_in_text(user)].")
		user.drop_held_item()

/obj/item/hunting_trap/attack_hand(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		disarm(user)
	//Humans and synths don't know how to handle those traps!
	if(isHumanSynthStrict(user) && armed)
		to_chat(user, SPAN_WARNING("You foolishly reach out for \the [src]..."))
		trapMob(user)
		return
	. = ..()

/obj/item/hunting_trap/proc/trapMob(var/mob/living/carbon/C)
	if(!armed)
		return

	armed = FALSE
	anchored = TRUE

	var/list/tether_effects = apply_tether(src, C, range = tether_range, resistable = TRUE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, .proc/disarm)

	trapped_mob = C

	icon_state = "yauttrap0"
	playsound(C,'sound/weapons/tablehit1.ogg', 25, 1)
	to_chat(C, "[icon2html(src, C)] \red <B>You get caught in \the [src]!</B>")

	C.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].</font>")
	log_attack("[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].")

	if(ishuman(C))
		C.emote("pain")
	if(isXeno(C))
		var/mob/living/carbon/Xenomorph/X = C
		C.emote("needhelp")
		X.interference = 100 // Some base interference to give pred time to get some damage in, if it cannot land a single hit during this time pred is cheeks
		RegisterSignal(X, COMSIG_XENO_PRE_HEAL, .proc/block_heal)
	message_all_yautja("A hunting trap has caught something in [get_area_name(loc)]!")

/obj/item/hunting_trap/proc/block_heal(mob/living/carbon/Xenomorph/xeno)
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_XENO_HEAL

/obj/item/hunting_trap/Crossed(atom/movable/AM)
	if(armed && ismob(AM))
		var/mob/M = AM
		if(!M.buckled)
			if(iscarbon(AM) && isturf(src.loc))
				var/mob/living/carbon/H = AM
				if(isYautja(H))
					to_chat(H, SPAN_NOTICE("You carefully avoid stepping on the trap."))
					return
				trapMob(H)
				for(var/mob/O in viewers(H, null))
					if(O == H)
						continue
					O.show_message(SPAN_WARNING("[icon2html(src, O)] <B>[H] gets caught in \the [src].</B>"), 1)
			else if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot))
				armed = FALSE
				var/mob/living/simple_animal/SA = AM
				SA.health -= 20
	..()

/obj/item/hunting_trap/proc/cleanup_tether()
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		qdel(tether_effect)
		tether_effect = null

/obj/item/hunting_trap/proc/disarm(var/mob/user)
	SIGNAL_HANDLER
	armed = FALSE
	anchored = FALSE
	icon_state = "yauttrap[armed]"
	if (user)
		to_chat(user, SPAN_NOTICE("[src] is now disarmed."))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has disarmed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has disarmed \a [src] at [get_location_in_text(user)].")
	if (trapped_mob)
		if (isXeno(trapped_mob))
			var/mob/living/carbon/Xenomorph/X = trapped_mob
			UnregisterSignal(X, COMSIG_XENO_PRE_HEAL)
		trapped_mob = null
	cleanup_tether()

/obj/item/hunting_trap/verb/configure_trap()
	set name = "Configure Hunting Trap"
	set category = "Object"

	var/mob/living/carbon/human/H = usr
	if(!HAS_TRAIT(H, TRAIT_YAUTJA_TECH))
		to_chat(H, SPAN_WARNING("You do not know how to configure the trap."))
		return
	var/range = tgui_input_list(H, "Which range would you like to set the hunting trap to?", "Hunting Trap Range", list(2, 3, 4, 5, 6, 7))
	if(isnull(range))
		return
	tether_range = range
	to_chat(H, SPAN_NOTICE("You set the hunting trap's tether range to [range]."))

//flavor armor & greaves, not a subtype
/obj/item/clothing/suit/armor/yautja_flavor
	name = "alien stone armor"
	desc = "A suit of armor made entirely out of stone. Looks incredibly heavy."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "fullarmor_ebony"
	item_state = "armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HEAD|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_HEAVY
	siemens_coefficient = 0.1
	allowed = list(/obj/item/weapon/melee/harpoon,
			/obj/item/weapon/gun/launcher/spike,
			/obj/item/weapon/gun/energy/yautja,
			/obj/item/weapon/melee/yautja,
			/obj/item/weapon/melee/twohanded/yautja)
	unacidable = TRUE
	item_state_slots = list(WEAR_JACKET = "fullarmor")

/obj/item/clothing/shoes/yautja_flavor
	name = "alien stone greaves"
	desc = "A pair of armored, perfectly balanced boots. Perfect for running through cement because they're incredibly heavy."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "y-boots2_ebony"

	unacidable = TRUE
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/card/id/bracer_chip
	name = "bracer ID chip"
	desc = "A complex cypher chip embedded within a set of clan bracers."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "upp_key"
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_ID
	flags_item = ITEM_PREDATOR|DELONDROP|NODROP
	paygrade = null

/obj/item/storage/medicomp
	name = "medicomp"
	desc = "A complex kit of alien tools and medicines."
	icon_state = "medicomp"
	use_sound = "toolbox"
	w_class = SIZE_SMALL
	storage_flags = STORAGE_FLAGS_DEFAULT
	flags_item = ITEM_PREDATOR
	storage_slots = 12
	can_hold = list(
					/obj/item/tool/surgery/stabilizer_gel,
					/obj/item/tool/surgery/healing_gun,
					/obj/item/tool/surgery/wound_clamp,
					/obj/item/reagent_container/hypospray/autoinjector/yautja,
					/obj/item/device/healthanalyzer/alien,
					/obj/item/tool/surgery/healing_gel
					)

/obj/item/storage/medicomp/full/fill_preset_inventory()
	new /obj/item/tool/surgery/stabilizer_gel(src)
	new /obj/item/tool/surgery/healing_gun(src)
	new /obj/item/tool/surgery/wound_clamp(src)
	new	/obj/item/device/healthanalyzer/alien(src)
	new	/obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new	/obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new	/obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new	/obj/item/tool/surgery/healing_gel/(src)
	new	/obj/item/tool/surgery/healing_gel/(src)
	new	/obj/item/tool/surgery/healing_gel/(src)

/obj/item/storage/medicomp/update_icon()
	if(!contents.len)
		icon_state = "medicomp_open"
	else
		icon_state = "medicomp"
