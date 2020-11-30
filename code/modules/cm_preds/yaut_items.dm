//Items specific to yautja. Other people can use em, they're not restricted or anything.
//They can't, however, activate any of the special functions.

/proc/add_to_missing_pred_gear(var/obj/item/W)
	if(!(W in yautja_gear) && !(W in untracked_yautja_gear) && !(W.z in ADMIN_Z_LEVEL))
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
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_NONE
	min_cold_protection_temperature = ARMOR_min_cold_protection_temperature
	max_heat_protection_temperature = ARMOR_max_heat_protection_temperature
	siemens_coefficient = 0.1
	allowed = list(/obj/item/weapon/melee/harpoon,
			/obj/item/weapon/gun/launcher/spike,
			/obj/item/weapon/gun/energy/plasmarifle,
			/obj/item/weapon/gun/energy/plasmapistol,
			/obj/item/weapon/yautja_chain,
			/obj/item/weapon/melee/yautja_knife,
			/obj/item/weapon/melee/yautja_sword,
			/obj/item/weapon/melee/yautja_scythe,
			/obj/item/weapon/melee/combistick,
			/obj/item/weapon/melee/twohanded/glaive)
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
			/obj/item/weapon/gun/energy/plasmarifle,
			/obj/item/weapon/gun/energy/plasmapistol,
			/obj/item/weapon/yautja_chain,
			/obj/item/weapon/melee/yautja_knife,
			/obj/item/weapon/melee/yautja_sword,
			/obj/item/weapon/melee/yautja_scythe,
			/obj/item/weapon/melee/combistick,
			/obj/item/storage/backpack/yautja,
			/obj/item/weapon/melee/twohanded/glaive)

/obj/item/clothing/suit/armor/yautja/full/New(location)
	. = ..(location, 0)

/obj/item/clothing/suit/armor/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/suit/armor/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/suit/armor/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()


/obj/item/clothing/cape

/obj/item/clothing/cape/eldercape
	name = "\improper Yautja Cape"
	desc = "A battle-worn cape passed down by elder Yautja. Councillors who've proven themselves worthy may also be rewarded with one of these capes."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "cape_elder"
	flags_equip_slot = SLOT_BACK
	flags_item = ITEM_PREDATOR
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

/obj/item/clothing/cape/eldercape/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/clothing/shoes/yautja
	name = "clan greaves"
	icon_state = "y-boots1"
	desc = "A pair of armored, perfectly balanced boots. Perfect for running through the jungle."
	unacidable = TRUE
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_item = ITEM_PREDATOR
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
	items_allowed = list(/obj/item/weapon/melee/yautja_knife, /obj/item/weapon/gun/energy/plasmapistol)
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

/obj/item/clothing/shoes/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/clothing/under/chainshirt
	name = "body mesh"
	icon = 'icons/obj/items/clothing/uniforms.dmi'
	desc = "A set of very fine chainlink in a meshwork for comfort and utility."
	icon_state = "mesh_shirt"
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS //Does not cover the head though.
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS
	flags_item = ITEM_PREDATOR
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

/obj/item/clothing/under/chainshirt/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/clothing/under/chainshirt/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/under/chainshirt/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

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

	for(var/mob/living/carbon/hellhound/H in GLOB.player_list)
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
	flags_item = ITEM_PREDATOR
	storage_slots = 10
	max_storage_space = 30

/obj/item/storage/backpack/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

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
	flags_item = ITEM_PREDATOR
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	force = 1
	throwforce = 1
	unacidable = TRUE
	var/timer = 0

/obj/item/device/yautja_teleporter/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/device/yautja_teleporter/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/device/yautja_teleporter/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/device/yautja_teleporter/attack_self(mob/user)
	set waitfor = 0

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/ship_to_tele = list("Public" = CLAN_SHIP_PUBLIC, "Ooman Ship" = CLAN_SHIP_ALMAYER)

	if(!isYautja(H))
		to_chat(user, SPAN_WARNING("You fiddle with it, but nothing happens!"))
		return

	if(H.client && H.client.clan_info)
		var/datum/entity/clan_player/clan_info = H.client.clan_info
		if(clan_info.permissions & CLAN_PERMISSION_ADMIN_VIEW)
			var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)
			for(var/datum/view_record/clan_view/CV in CPV)
				if(!("[CV.clan_id]" in pred_ships))
					continue

				ship_to_tele += list("[CV.name]" = "[CV.clan_id]")
		else if(clan_info.clan_id)
			ship_to_tele += list("Your clan" = "[clan_info.clan_id]")

	var/clan = ship_to_tele[(input(H, "Select a ship to teleport to", "[src]") as null|anything in ship_to_tele)]

	if((!clan || !(clan in pred_ships)) && clan != CLAN_SHIP_ALMAYER)
		return

	playsound(src,'sound/ambience/signal.ogg', 25, 1)
	timer = 1
	user.visible_message(SPAN_INFO("[user] starts becoming shimmery and indistinct..."))

	if(do_after(user, SECONDS_10, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		// Teleport self.
		user.visible_message(SPAN_WARNING("[htmlicon(user, viewers(src))][user] disappears!"))
		var/tele_time = animation_teleport_quick_out(user)
		// Also teleport whoever you're pulling.
		var/mob/living/M = user.pulling
		if(istype(M))
			M.visible_message(SPAN_WARNING("[htmlicon(M, viewers(src))][M] disappears!"))
			animation_teleport_quick_out(M)
		sleep(tele_time)

		var/turf/end_turf
		if(clan != CLAN_SHIP_ALMAYER)
			end_turf = pick(get_clan_spawnpoints(clan))
		else
			end_turf = pick(yautja_almayer_loc)

		user.forceMove(end_turf)
		animation_teleport_quick_in(user)
		if(M && M.loc)
			M.forceMove(end_turf)
			animation_teleport_quick_in(M)
		timer = 0
	else
		addtimer(VARSET_CALLBACK(src, timer, FALSE), 1 SECONDS)

/obj/item/device/yautja_teleporter/verb/add_tele_loc()
	set name = "Add Teleporter Destination"
	set desc = "Adds this location to the teleporter."
	set category = "Yautja"

	if(!usr || usr.stat || usr.z != SURFACE_Z_LEVEL)
		return

	if(istype(usr.buckled, /obj/structure/bed/nest/))
		return

	if(loc && istype(usr.loc, /turf))
		var/turf/location = usr.loc
		yautja_teleport_loc += location
		var/name = input("What would you like to name this location?", "Text") as null|text
		if(!name)
			return
		yautja_teleport_desc += name + location.loc_to_string()
		to_chat(usr, SPAN_WARNING("You can now teleport to this location!"))
//=================//\\=================\\
//======================================\\

/*
			  MELEE WEAPONS
*/

//======================================\\
//=================\\//=================\\

/obj/item/weapon/melee/harpoon/yautja
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

/obj/item/weapon/melee/harpoon/yautja/New()
	. = ..()

	force = BULLET_DAMAGE_TIER_3
	throwforce = BULLET_DAMAGE_TIER_8

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
	force = BULLET_DAMAGE_TIER_5

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
	. = ..()

	force = BULLET_DAMAGE_TIER_12
	throwforce = BULLET_DAMAGE_TIER_2

/obj/item/weapon/yautja_chain/attack(mob/target, mob/living/user)
	. = ..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

/obj/item/weapon/yautja_chain/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()


/obj/item/weapon/melee/yautja_sword
	name = "clan sword"
	desc = "An expertly crafted Yautja blade carried by hunters who wish to fight up close. Razor sharp, and capable of cutting flesh into ribbons. Commonly carried by aggresive and lethal hunters."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "clansword"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_BACK
	sharp = 1
	edge = 1
	var/on = FALSE
	var/timer = FALSE
	embeddable = FALSE
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9
	unacidable = TRUE

/obj/item/weapon/melee/yautja_sword/New()
	. = ..()

	force = BULLET_DAMAGE_TIER_7 //More damage than other weapons like it. Considering how "strong" this sword is supposed to be, 38 damage was laughable.
	throwforce = BULLET_DAMAGE_TIER_3

/obj/item/weapon/melee/yautja_sword/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/melee/yautja_sword/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/yautja_sword/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

/obj/item/weapon/melee/yautja_sword/pickup(mob/living/user as mob)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/yautja_sword/unique_action(mob/living/user)
	if(user.get_active_hand() != src)
		return
	if(timer) return
	if(!on)
		on = !on
		timer = TRUE
		addtimer(CALLBACK(src, .proc/stop_parry), SECONDS_3)
		to_chat(user, SPAN_NOTICE("You get ready to parry with the [src]."))
		addtimer(CALLBACK(src, .proc/parry_cooldown), SECONDS_8)

	add_fingerprint(user)
	return

/obj/item/weapon/melee/yautja_sword/proc/stop_parry()
	if(on)
		on = !on
		if(isYautja(src.loc))
			var/mob/living/user = loc
			to_chat(user, SPAN_NOTICE("You lower the [src]."))

/obj/item/weapon/melee/yautja_sword/proc/parry_cooldown()
	timer = FALSE
	if(isYautja(src.loc))
		var/mob/living/user = loc
		to_chat(user, SPAN_NOTICE("You lower the [src]."))
/obj/item/weapon/melee/yautja_scythe
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

/obj/item/weapon/melee/yautja_scythe/New()
	. = ..()

	icon_state = pick("predscythe","predscythe_alt")
	force = BULLET_DAMAGE_TIER_8
	throwforce = BULLET_DAMAGE_TIER_4

/obj/item/weapon/melee/yautja_scythe/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/melee/yautja_scythe/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/yautja_scythe/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/yautja_scythe/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30


	if(prob(20))
		user.visible_message(SPAN_DANGER("An opening in combat presents itself!"),SPAN_DANGER("You manage to strike at your foe once more!"))
		..() //Do it again! CRIT! This will be replaced by a bleed effect.

	return

//Combistick
/obj/item/weapon/melee/combistick
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

/obj/item/weapon/melee/combistick/New()
	. = ..()

	throwforce = BULLET_DAMAGE_TIER_7
	force = BULLET_DAMAGE_TIER_5

/obj/item/weapon/melee/combistick/IsShield()
	return on

/obj/item/weapon/melee/combistick/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/melee/combistick/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/combistick/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/combistick/wield(var/mob/user)
	..()
	force = BULLET_DAMAGE_TIER_7
	update_icon()

/obj/item/weapon/melee/combistick/unwield(mob/user)
	..()
	force = BULLET_DAMAGE_TIER_5
	update_icon()

/obj/item/weapon/melee/combistick/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Activate or deactivate the combistick."

	unique_action(usr)

/obj/item/weapon/melee/combistick/attack_self(mob/user)
	..()
	if(on)
		if(flags_item & WIELDED) unwield(user)
		else 				wield(user)
	else
		to_chat(user, SPAN_WARNING("You need to extend the combi-stick before you can wield it."))

/obj/item/weapon/melee/combistick/update_icon()
	if(flags_item & WIELDED)
		item_state = "combistick_w"
	else item_state = "combistick"

/obj/item/weapon/melee/combistick/unique_action(mob/living/user)
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
		force = BULLET_DAMAGE_TIER_6
		throwforce = BULLET_DAMAGE_TIER_7
		attack_verb = list("speared", "stabbed", "impaled")
		timer = 1
		addtimer(VARSET_CALLBACK(src, timer, FALSE), 1 SECONDS)

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
		force = BULLET_DAMAGE_TIER_2
		throwforce = BULLET_DAMAGE_TIER_7 - BULLET_DAMAGE_TIER_7
		attack_verb = list("thwacked", "smacked")
		timer = 1
		addtimer(VARSET_CALLBACK(src, timer, FALSE), 1 SECONDS)
		overlays.Cut()

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)

	return

/obj/item/weapon/melee/combistick/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30
	..()

/obj/item/weapon/melee/combistick/attack_hand(mob/user) //Prevents marines from instantly picking it up via pickup macros.
	if(!isYautja(user))
		user.visible_message(SPAN_DANGER("[user] starts to untangle the chain on \the [src]..."), SPAN_NOTICE("You start to untangle the chain on \the [src]..."))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			..()
	else ..()

/obj/item/weapon/melee/combistick/launch_impact(atom/hit_atom)
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
			msg_admin_attack("[key_name(user)] primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		icon_state = initial(icon_state) + "_active"
		active = 1
		update_icon()
		addtimer(CALLBACK(src, .proc/prime), det_time)

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
		for(var/mob/living/carbon/hellhound/H in GLOB.hellhound_list)
			L += H.real_name
		L["Cancel"] = "Cancel"

		var/choice = input(user,"Which hellhound would you like to observe? (moving will drop the feed)","Camera View") as null|anything in L
		if(!choice || choice == "Cancel" || isnull(choice))
			user.unset_interaction()
			to_chat(user, "Stopping camera feed.")
			return

		for(var/mob/living/carbon/hellhound/Q in GLOB.hellhound_list)
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
	. = ..()

	force = BULLET_DAMAGE_TIER_4
	throwforce = BULLET_DAMAGE_TIER_8

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_set_interaction(mob/user)
	..()
	user.reset_view(current)

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_unset_interaction(mob/user)
	..()
	current = null
	user.reset_view(null)
