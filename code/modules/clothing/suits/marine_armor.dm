#define DEBUG_ARMOR_PROTECTION 0

#if DEBUG_ARMOR_PROTECTION
/mob/living/carbon/human/verb/check_overall_protection()
	set name = "Get Armor Value"
	set category = "Debug"
	set desc = "Shows the armor value of the bullet category."

	var/armor = 0
	var/counter = 0
	for(var/X in H.limbs)
		var/obj/limb/E = X
		armor = getarmor_organ(E, ARMOR_BULLET)
		to_chat(src, SPAN_DEBUG("<b>[E.name]</b> is protected with <b>[armor]</b> armor against bullets."))
		counter += armor
	to_chat(src, SPAN_DEBUG("The overall armor score is: <b>[counter]</b>."))
#endif

//=======================================================================\\
//=======================================================================\\

#define ALPHA 1
#define BRAVO 2
#define CHARLIE 3
#define DELTA 4
#define ECHO 5
#define CRYO 6
#define SOF 7
#define NOSQUAD 8

// MARINE STORAGE ARMOR

/obj/item/clothing/suit/storage/marine
	name = "\improper M3 pattern marine armor"
	desc = "A standard Colonial Marines M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	flags_atom = FPRINT|CONDUCT
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 3
	siemens_coefficient = 0.7
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/prop/prop_gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_PONCHO)

	light_power = 3
	light_range = 4
	light_system = MOVABLE_LIGHT

	var/flashlight_cooldown = 0 //Cooldown for toggling the light
	var/locate_cooldown = 0 //Cooldown for SL locator
	var/armor_overlays[]
	actions_types = list(/datum/action/item_action/toggle)
	var/flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY
	var/specialty = "M3 pattern marine" //Same thing here. Give them a specialty so that they show up correctly in vendors. speciality does NOTHING if you have NO_NAME_OVERRIDE
	w_class = SIZE_HUGE
	uniform_restricted = list(/obj/item/clothing/under/marine)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	time_to_unequip = 20
	time_to_equip = 20
	pickup_sound = "armorequip"
	drop_sound = "armorequip"
	equip_sounds = list('sound/handling/putting_on_armor1.ogg')
	var/armor_variation = 0
	/// The dmi where the grayscale squad overlays are contained
	var/squad_overlay_icon = 'icons/mob/humans/onmob/suit_1.dmi'

	var/atom/movable/marine_light/light_holder

/obj/item/clothing/suit/storage/marine/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow armor" //Leave marine out so that armors don't have to have "Marine" appended (see: generals).
		else
			name += " armor"

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	armor_overlays = list("lamp") //Just one for now, can add more later.
	if(armor_variation && mapload)
		post_vendor_spawn_hook()
	update_icon()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

	light_holder = new(src)

/obj/item/clothing/suit/storage/marine/Destroy()
	QDEL_NULL(light_holder)
	return ..()

/obj/item/clothing/suit/storage/marine/update_icon(mob/user)
	var/image/I
	armor_overlays["lamp"] = null
	if(flags_marine_armor & ARMOR_LAMP_OVERLAY)
		if(flags_marine_armor & ARMOR_LAMP_ON)
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-on")
		else
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-off")
		armor_overlays["lamp"] = I
		overlays += I
	else armor_overlays["lamp"] = null
	if(user) user.update_inv_wear_suit()


/obj/item/clothing/suit/storage/marine/post_vendor_spawn_hook(mob/living/carbon/human/user) //used for randomizing/selecting a variant for armors.
	var/new_look //used for the icon_state text replacement.

	if(!user?.client?.prefs)
		new_look = rand(1,armor_variation)

	else if(user.client.prefs.preferred_armor == "Random")
		new_look = rand(1,armor_variation)

	else
		new_look = GLOB.armor_style_list[user.client.prefs.preferred_armor]

	icon_state = replacetext(icon_state,"1","[new_look]")
	update_icon(user)

/obj/item/clothing/suit/storage/marine/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You cannot turn the light [light_on ? "off" : "on"] while in [user.loc].")) //To prevent some lighting anomalies.
		return

	if(flashlight_cooldown > world.time)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	turn_light(user, !light_on)

/obj/item/clothing/suit/storage/marine/item_action_slot_check(mob/user, slot)
	if(!ishuman(user))
		return FALSE
	if(slot != WEAR_JACKET)
		return FALSE
	return TRUE //only give action button when armor is worn.

/obj/item/clothing/suit/storage/marine/turn_light(mob/user, toggle_on)
	. = ..()
	if(. != CHECKS_PASSED)
		return
	set_light_range(initial(light_range))
	set_light_power(FLOOR(initial(light_power) * 0.5, 1))
	set_light_on(toggle_on)
	flags_marine_armor ^= ARMOR_LAMP_ON

	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(initial(light_range))
	light_holder.set_light_power(initial(light_power))
	light_holder.set_light_on(toggle_on)

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/suit/storage/marine/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(issynth(M) && M.allow_gun_usage == FALSE && !(flags_marine_armor & SYNTH_ALLOWED))
			M.visible_message(SPAN_DANGER("Your programming prevents you from wearing this!"))
			return 0

/obj/item/clothing/suit/storage/marine/padded
	name = "M3 pattern padded marine armor"
	icon_state = "1"
	specialty = "M3 pattern padded marine"

/obj/item/clothing/suit/storage/marine/padless
	name = "M3 pattern padless marine armor"
	icon_state = "2"
	specialty = "M3 pattern padless marine"

/obj/item/clothing/suit/storage/marine/padless_lines
	name = "M3 pattern ridged marine armor"
	icon_state = "3"
	specialty = "M3 pattern ridged marine"

/obj/item/clothing/suit/storage/marine/carrier
	name = "M3 pattern carrier marine armor"
	icon_state = "4"
	specialty = "M3 pattern carrier marine"

/obj/item/clothing/suit/storage/marine/skull
	name = "M3 pattern skull marine armor"
	icon_state = "5"
	specialty = "M3 pattern skull marine"

/obj/item/clothing/suit/storage/marine/smooth
	name = "M3 pattern smooth marine armor"
	icon_state = "6"
	specialty = "M3 pattern smooth marine"

/obj/item/clothing/suit/storage/marine/rto
	icon_state = "io"
	name = "\improper M4 pattern marine armor"
	desc = "A well tinkered and crafted hybrid of Smart-Gunner mesh and M3 pattern plates. Robust, yet nimble, with room for all your pouches."
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 4
	light_range = 5 //slightly higher
	specialty = "M4 pattern marine"

/obj/item/clothing/suit/storage/marine/rto/intel
	name = "\improper XM4 pattern intelligence officer armor"
	uniform_restricted = list(/obj/item/clothing/under/marine/officer, /obj/item/clothing/under/rank/qm_suit, /obj/item/clothing/under/marine/officer/intel)
	specialty = "XM4 pattern intel"

/obj/item/clothing/suit/storage/marine/MP
	name = "\improper M2 pattern MP armor"
	desc = "A standard Colonial Marines M2 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "mp_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/hailer,
		/obj/item/storage/belt/gun,
		/obj/item/weapon/claymore/mercsword/ceremonial,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/mp)
	specialty = "M2 pattern MP"
	item_state_slots = list(WEAR_JACKET = "mp_armor")
	black_market_value = 20

/obj/item/clothing/suit/storage/marine/MP/warden
	icon_state = "warden"
	name = "\improper M3 pattern warden MP armor"
	desc = "A well-crafted suit of M3 Pattern Armor typically distributed to Wardens. Useful for letting your men know who is in charge."
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	uniform_restricted = list(/obj/item/clothing/under/marine/warden)
	specialty = "M3 pattern warden MP"
	item_state_slots = list(WEAR_JACKET = "warden")

/obj/item/clothing/suit/storage/marine/MP/WO
	icon_state = "warrant_officer"
	name = "\improper M3 pattern chief MP armor"
	desc = "A well-crafted suit of M3 Pattern Armor typically distributed to Chief MPs. Useful for letting your men know who is in charge."
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/warrant)
	specialty = "M3 pattern chief MP"
	item_state_slots = list(WEAR_JACKET = "warrant_officer")
	black_market_value = 30

/obj/item/clothing/suit/storage/marine/MP/general
	name = "\improper M3 pattern general officer armor"
	desc = "A well-crafted suit of M3 Pattern Armor with a gold shine. It looks very expensive, but shockingly fairly easy to carry and wear."
	icon_state = "general"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/general)
	specialty = "M3 pattern general"
	item_state_slots = list(WEAR_JACKET = "general")
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/marine/MP/SO
	name = "\improper M3 pattern officer armor"
	desc = "A well-crafted suit of M3 Pattern Armor typically found in the hands of higher-ranking officers. Useful for letting your men know who is in charge when taking to the field."
	icon_state = "officer"
	storage_slots = 3
	flags_atom = null
	uniform_restricted = list(/obj/item/clothing/under/marine/officer, /obj/item/clothing/under/rank/qm_suit, /obj/item/clothing/under/rank/chief_medical_officer, /obj/item/clothing/under/marine/dress)
	specialty = "M2 pattern officer"
	item_state_slots = list(WEAR_JACKET = "officer")

//Making a new object because we might want to edit armor values and such.
//Or give it its own sprite. It's more for the future.
/obj/item/clothing/suit/storage/marine/MP/CO
	name = "\improper M3 pattern commanding officer armor"
	desc = "A robust, well-polished suit of armor for the Commanding Officer. Custom-made to fit its owner with special straps to operate a smartgun. Show those Marines who's really in charge."
	icon_state = "co_officer"
	item_state = "co_officer"
	armor_bullet = CLOTHING_ARMOR_HIGH
	storage_slots = 3
	flags_atom = NO_SNOW_TYPE
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	uniform_restricted = list(/obj/item/clothing/under/marine, /obj/item/clothing/under/rank/qm_suit)
	specialty = "M3 pattern captain"
	item_state_slots = list(WEAR_JACKET = "co_officer")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_PONCHO)
	black_market_value = 35


/obj/item/clothing/suit/storage/marine/MP/CO/jacket
	name = "\improper M3 pattern commanding officer armored coat"
	desc = "A robust, well-polished suit of armor for the Commanding Officer. Custom-made to fit its owner with special straps to operate a smartgun. Show those Marines who's really in charge. This one has a coat over it for added warmth."
	icon_state = "bridge_coat_armored"
	item_state = "bridge_coat_armored"
	item_state_slots = list(WEAR_JACKET = "bridge_coat_armored")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK)


/obj/item/clothing/suit/storage/marine/smartgunner
	name = "\improper M56 combat harness"
	desc = "A heavy protective vest designed to be worn with the M56 Smartgun System. \nIt has specially designed straps and reinforcement to carry the Smartgun and accessories."
	icon_state = "8"
	item_state = "armor"
	armor_laser = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	allowed = list(
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/mine,
		/obj/item/attachable/bayonet,
		/obj/item/weapon/gun/smartgun,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/marine/smartgunner/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "M56 combat harness")
		name = "M56 snow combat harness"
	else
		name = "M56 combat harness"
	//select_gamemode_skin(type)

/obj/item/clothing/suit/storage/marine/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning = FALSE)
	. = ..()

	if(equipping_mob.back)
		to_chat(equipping_mob, SPAN_WARNING("You can't equip [src] while wearing a backpack."))
		return FALSE

/obj/item/clothing/suit/storage/marine/smartgunner/equipped(mob/user, slot, silent)
	. = ..()

	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP, PROC_REF(check_equipping))

/obj/item/clothing/suit/storage/marine/smartgunner/proc/check_equipping(mob/living/carbon/human/equipping_human, obj/item/equipping_item, slot)
	SIGNAL_HANDLER

	if(slot != WEAR_BACK)
		return

	. = COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP

	if(equipping_item.flags_equip_slot == SLOT_BACK)
		to_chat(equipping_human, SPAN_WARNING("You can't equip [equipping_item] on your back while wearing [src]."))
		return

/obj/item/clothing/suit/storage/marine/smartgunner/unequipped(mob/user, slot)
	. = ..()

	UnregisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP)

/obj/item/clothing/suit/storage/marine/leader
	name = "\improper B12 pattern marine armor"
	desc = "A lightweight suit of carbon fiber body armor built for quick movement. Designed in a lovely forest green. Use it to toggle the built-in flashlight."
	icon_state = "7"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "B12 pattern marine"

/obj/item/clothing/suit/storage/marine/tanker
	name = "\improper M3 pattern tanker armor"
	desc = "A modified and refashioned suit of M3 Pattern armor designed to be worn by the loader of a USCM vehicle crew. While the suit is a bit more encumbering to wear with the crewman uniform, it offers the loader a degree of protection that would otherwise not be enjoyed."
	icon_state = "tanker"
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/tanker)
	specialty = "M3 pattern tanker"
	storage_slots = 2

//===========================//PFC ARMOR CLASSES\\================================\\
//=================================================================================\\

/obj/item/clothing/suit/storage/marine/medium
	armor_variation = 6

/obj/item/clothing/suit/storage/marine/light
	name = "\improper M3-L pattern light armor"
	desc = "A lighter, cut down version of the standard M3 pattern armor. It sacrifices durability for more speed."
	specialty = "\improper M3-L pattern light"
	icon_state = "L1"
	armor_variation = 6
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/padded
	icon_state = "L1"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/padless
	icon_state = "L2"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/padless_lines
	icon_state = "L3"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/carrier
	icon_state = "L4"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/skull
	icon_state = "L5"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/smooth
	icon_state = "L6"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/vest
	name = "\improper M3-VL pattern ballistics vest"
	desc = "Up until 2182 USCM non-combat personnel were issued non-standardized ballistics vests, though the lack of IMP compatibility and suit lamps proved time and time again inefficient. This modified M3-L shell is the result of a 6-year R&D program; It provides utility, protection, AND comfort to all USCM non-combat personnel."
	icon_state = "VL"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_LAMP_OVERLAY //No squad colors when wearing this since it'd look funny.
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_VERYLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 1
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	siemens_coefficient = 0.7
	uniform_restricted = null

/obj/item/clothing/suit/storage/marine/light/vest/dcc
	name = "\improper M3-VL pattern flak vest"
	desc = "A combination of the standard non-combat M3-VL ballistics vest and M70 flak jacket, this piece of armor has been distributed to dropship crew to keep them safe from threats external and internal..."
	icon_state = "VL_FLAK"
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/synvest
	name = "\improper M3A1 Synthetic Utility Vest"
	desc = "This variant of the ubiquitous M3 pattern ballistics vest has been extensively modified, providing no protection in exchange for maximum mobility and storage space. Synthetic programming compliant."
	icon_state = "VL_syn_camo"
	flags_atom = NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_LAMP_OVERLAY|SYNTH_ALLOWED //No squad colors + can be worn by synths.
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	uniform_restricted = null

/obj/item/clothing/suit/storage/marine/light/synvest/grey
	icon_state = "VL_syn"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/jungle
	icon_state = "VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/snow
	icon_state = "s_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/desert
	icon_state = "d_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/dgrey
	icon_state = "c_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/heavy
	name = "\improper M3-EOD pattern heavy armor"
	desc = "A heavier version of the standard M3 pattern armor, the armor is primarily designed to withstand ballistic, explosive, and internal damage, with the drawback of increased bulk and thus reduced movement speed, alongside little additional protection from standard blunt force impacts and biological threats."
	desc_lore = "This configuration of the iconic armor was developed during the Canton War in 2160 between the UPP and USCM - Designed in response to a need for higher protection for ComTechs assigned as EODs during the conflict, this is the pinnacle of protection for your average marine. The shoulders and kneepads have both been expanded upon heavily, covering up the arteries on each limb. A special spall liner was developed for this suit, with the same technology being used in the M70 Flak Jacket being developed at the same time."
	specialty = "\improper M3-EOD pattern"
	icon_state = "H1"
	armor_variation = 6
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/marine/heavy/padded
	icon_state = "H1"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/padless
	icon_state = "H2"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/padless_lines
	icon_state = "H3"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/carrier
	icon_state = "H4"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/skull
	icon_state = "H5"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/smooth
	icon_state = "H6"
	armor_variation = 0

//===========================//SPECIALIST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/specialist
	name = "\improper B18 defensive armor"
	desc = "A heavy, rugged set of armor plates for when you really, really need to not die horribly. Slows you down though.\nComes with two tricord injectors in each arm guard."
	icon_state = "xarmor"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 2
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_HEAVY
	specialty = "B18 defensive"
	unacidable = TRUE
	var/injections = 4

/obj/item/clothing/suit/storage/marine/specialist/verb/inject()
	set name = "Create Injector"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return 0

	if(!injections)
		to_chat(usr, "Your armor is all out of injectors.")
		return 0

	if(usr.get_active_hand())
		to_chat(usr, "Your active hand must be empty.")
		return 0

	to_chat(usr, "You feel a faint hiss and an injector drops into your hand.")
	var/obj/item/reagent_container/hypospray/autoinjector/skillless/O = new(usr)
	usr.put_in_active_hand(O)
	injections--
	playsound(src,'sound/machines/click.ogg', 15, 1)
	return

/obj/item/clothing/suit/storage/marine/M3G
	name = "\improper M3-G4 grenadier armor"
	desc = "A custom set of M3 armor packed to the brim with padding, plating, and every form of ballistic protection under the sun. Used exclusively by USCM Grenadiers."
	icon_state = "grenadier"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_HEAVY
	specialty = "M3-G4 grenadier"
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/M3T
	name = "\improper M3-T light armor"
	desc = "A custom set of M3 armor designed for users of long-ranged explosive weaponry."
	icon_state = "demolitionist"
	armor_bomb = CLOTHING_ARMOR_HIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-T light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/M3S
	name = "\improper M3-S light armor"
	desc = "A custom set of M3 armor designed for USCM Scouts."
	icon_state = "scout_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-S light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	unacidable = TRUE

#define FIRE_SHIELD_CD 150

/obj/item/clothing/suit/storage/marine/M35
	name = "\improper M35 pyrotechnician armor"
	desc = "A custom set of M35 armor designed for use by USCM Pyrotechnicians."
	icon_state = "pyro_armor"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	specialty = "M35 pyrotechnician"
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/specialist/fire_shield)
	unacidable = TRUE
	var/fire_shield_on = FALSE
	var/can_activate = TRUE

/obj/item/clothing/suit/storage/marine/M35/equipped(mob/user, slot)
	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_LIVING_FLAMER_CROSSED, PROC_REF(flamer_fire_callback))
	..()

/obj/item/clothing/suit/storage/marine/M35/verb/fire_shield()
	set name = "Activate Fire Shield"
	set desc = "Activate your armor's FIREWALK protocol for a short duration."
	set category = "Pyro"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr

	if(H.wear_suit != src)
		to_chat(H, SPAN_WARNING("You must be wearing the M35 pyro armor to activate FIREWALK protocol!"))
		return

	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PYRO)
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(fire_shield_on)
		to_chat(H, SPAN_WARNING("You already have FIREWALK protocol activated!"))
		return

	if(!can_activate)
		to_chat(H, SPAN_WARNING("FIREWALK protocol was recently activated, wait before trying to activate it again."))
		return

	to_chat(H, SPAN_NOTICE("FIREWALK protocol has been activated. You will now be immune to fire for 6 seconds!"))
	RegisterSignal(H, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_shield_is_on))
	RegisterSignal(H, list(
		COMSIG_LIVING_FLAMER_FLAMED,
	), PROC_REF(flamer_fire_callback))
	fire_shield_on = TRUE
	can_activate = FALSE
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()
	addtimer(CALLBACK(src, PROC_REF(end_fire_shield), H), 6 SECONDS)

	H.add_filter("firewalk_on", 1, list("type" = "outline", "color" = "#03fcc6", "size" = 1))

/obj/item/clothing/suit/storage/marine/M35/proc/end_fire_shield(mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("FIREWALK protocol has finished."))
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	fire_shield_on = FALSE

	user.remove_filter("firewalk_on")

	addtimer(CALLBACK(src, PROC_REF(enable_fire_shield), user), FIRE_SHIELD_CD)

/obj/item/clothing/suit/storage/marine/M35/proc/enable_fire_shield(mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("FIREWALK protocol can be activated again."))
	can_activate = TRUE

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/// This proc is solely so that IgniteMob() fails
/obj/item/clothing/suit/storage/marine/M35/proc/fire_shield_is_on(mob/living/L)
	SIGNAL_HANDLER

	if(L.fire_reagent?.fire_penetrating)
		return

	return COMPONENT_CANCEL_IGNITION

/obj/item/clothing/suit/storage/marine/M35/proc/flamer_fire_callback(mob/living/L, datum/reagent/R)
	SIGNAL_HANDLER

	if(R.fire_penetrating)
		return

	. = COMPONENT_NO_IGNITE
	if(fire_shield_on)
		. |= COMPONENT_NO_BURN

/obj/item/clothing/suit/storage/marine/M35/dropped(mob/user)
	if (!istype(user))
		return
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_CROSSED,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	..()

#undef FIRE_SHIELD_CD

/datum/action/item_action/specialist/fire_shield
	ability_primacy = SPEC_PRIMARY_ACTION_2

/datum/action/item_action/specialist/fire_shield/New(mob/living/user, obj/item/holder)
	..()
	name = "Activate Fire Shield"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/cm_suits.dmi', button, "pyro_armor")
	button.overlays += IMG

/datum/action/item_action/specialist/fire_shield/action_cooldown_check()
	var/obj/item/clothing/suit/storage/marine/M35/armor = holder_item
	if (!istype(armor))
		return FALSE

	return !armor.can_activate

/datum/action/item_action/specialist/fire_shield/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && H.wear_suit == holder_item)
		return TRUE

/datum/action/item_action/specialist/fire_shield/action_activate()
	var/obj/item/clothing/suit/storage/marine/M35/armor = holder_item
	if (!istype(armor))
		return

	armor.fire_shield()

#define FULL_CAMOUFLAGE_ALPHA 15

/obj/item/clothing/suit/storage/marine/ghillie
	name = "\improper M45 pattern ghillie armor"
	desc = "A lightweight ghillie camouflage suit, used by USCM snipers on recon missions. Very lightweight, but doesn't protect much."
	icon_state = "ghillie_armor"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	flags_item = MOB_LOCK_ON_EQUIP
	specialty = "M45 pattern ghillie"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_PONCHO)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

	var/camo_active = FALSE
	var/hide_in_progress = FALSE
	var/full_camo_alpha = FULL_CAMOUFLAGE_ALPHA
	var/incremental_shooting_camo_penalty = 35
	var/current_camo = FULL_CAMOUFLAGE_ALPHA
	var/camouflage_break = 5 SECONDS
	var/camouflage_enter_delay = 4 SECONDS
	var/can_camo = TRUE

	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/specialist/prepare_position)

/obj/item/clothing/suit/storage/marine/ghillie/dropped(mob/user)
	if(ishuman(user) && !issynth(user))
		deactivate_camouflage(user, FALSE)

	. = ..()

/obj/item/clothing/suit/storage/marine/ghillie/verb/camouflage()
	set name = "Prepare Position"
	set desc = "Use the ghillie suit and the nearby environment to become near invisible."
	set category = "Object"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return

	if(!ishuman(usr) || hide_in_progress || !can_camo)
		return
	var/mob/living/carbon/human/H = usr
	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER && !(GLOB.character_traits[/datum/character_trait/skills/spotter] in H.traits))
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	if(H.wear_suit != src)
		to_chat(H, SPAN_WARNING("You must be wearing the ghillie suit to activate it!"))
		return

	if(camo_active)
		deactivate_camouflage(H)
		return

	H.visible_message(SPAN_DANGER("[H] goes prone, and begins adjusting \his ghillie suit!"), SPAN_NOTICE("You go prone, and begins adjusting your ghillie suit."), max_distance = 4)
	hide_in_progress = TRUE
	H.unset_interaction() // If we're sticking to a machine gun or what not.
	if(!do_after(H, camouflage_enter_delay, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		hide_in_progress = FALSE
		return
	hide_in_progress = FALSE
	RegisterSignal(H,  list(
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_FIRED_GUN_ATTACHMENT)
		, PROC_REF(fade_in))
	RegisterSignal(H, list(
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_EXTINGUISH
	), PROC_REF(deactivate_camouflage))
	RegisterSignal(H, COMSIG_MOB_POST_UPDATE_CANMOVE, PROC_REF(fix_density))
	camo_active = TRUE
	H.alpha = full_camo_alpha
	H.FF_hit_evade = 1000
	H.density = FALSE

	RegisterSignal(H, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.remove_from_hud(H)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.remove_from_hud(H)

	anim(H.loc, H, 'icons/mob/mob.dmi', null, "cloak", null, H.dir)


/obj/item/clothing/suit/storage/marine/ghillie/proc/deactivate_camouflage(mob/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE

	if(!camo_active)
		return

	UnregisterSignal(H, list(
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_FIRED_GUN_ATTACHMENT,
		COMSIG_MOB_DEATH,
		COMSIG_MOB_POST_UPDATE_CANMOVE,
		COMSIG_HUMAN_EXTINGUISH,
		COMSIG_MOB_MOVE_OR_LOOK
	))

	camo_active = FALSE
	animate(H, alpha = initial(H.alpha), flags = ANIMATION_END_NOW)
	H.FF_hit_evade = initial(H.FF_hit_evade)
	if(!H.lying)
		H.density = TRUE
	H.update_canmove()

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(H)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(H)

	H.visible_message(SPAN_DANGER("[H]'s camouflage fails!"), SPAN_WARNING("Your camouflage fails!"), max_distance = 4)

/obj/item/clothing/suit/storage/marine/ghillie/proc/fade_in(mob/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = user
	if(camo_active)
		if(current_camo < full_camo_alpha)
			current_camo = full_camo_alpha
		current_camo = Clamp(current_camo + incremental_shooting_camo_penalty, full_camo_alpha, 255)
		H.alpha = current_camo
		addtimer(CALLBACK(src, PROC_REF(fade_out_finish), H), camouflage_break, TIMER_OVERRIDE|TIMER_UNIQUE)
		animate(H, alpha = full_camo_alpha + 5, time = camouflage_break, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)

/obj/item/clothing/suit/storage/marine/ghillie/proc/fix_density(mob/user)
	SIGNAL_HANDLER
	if(camo_active)
		user.density = FALSE

/obj/item/clothing/suit/storage/marine/ghillie/proc/fade_out_finish(mob/living/carbon/human/H)
	if(camo_active && H.wear_suit == src)
		to_chat(H, SPAN_BOLDNOTICE("The smoke clears and your position is once again hidden completely!"))
		animate(H, alpha = full_camo_alpha)
		current_camo = full_camo_alpha

/obj/item/clothing/suit/storage/marine/ghillie/proc/handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(camo_active && actually_moving)
		deactivate_camouflage(mover)

/datum/action/item_action/specialist/prepare_position
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/prepare_position/New(mob/living/user, obj/item/holder)
	..()
	name = "Prepare Position"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "prepare_position")
	button.overlays += IMG

/datum/action/item_action/specialist/prepare_position/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.lying && holder_item == H.wear_suit)
		return TRUE

/datum/action/item_action/specialist/prepare_position/action_activate()
	var/obj/item/clothing/suit/storage/marine/ghillie/GS = holder_item
	GS.camouflage()

#undef FULL_CAMOUFLAGE_ALPHA

/obj/item/clothing/suit/storage/marine/ghillie/forecon
	name = "UDEP Thermal Poncho"
	desc = "UDEP or the Ultra Diffusive Environmental Poncho is a camouflaged rain-cover worn to protect against the elements and chemical spills. It's commonly treated with an infrared absorbing coating, making a marine almost invisible in the rain. Favoured by USCM specialists for it's comfort and practicality."
	icon_state = "mercenary_miner_armor"
	flags_atom = MOB_LOCK_ON_EQUIP|NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/sof
	name = "\improper SOF Armor"
	desc = "A heavily customized suit of M3 armor. Used by Marine Raiders."
	icon_state = "marsoc"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	unacidable = TRUE
	flags_atom = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE|NO_SNOW_TYPE
	storage_slots = 4

//=============================//pmcS\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make these keep their name and icon.

/obj/item/clothing/suit/storage/marine/veteran/pmc
	name = "\improper M4 pattern PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind."
	icon_state = "pmc_armor"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/tool/crowbar,
		/obj/item/storage/large_holster/katana,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/tool/crew_monitor,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc)
	item_state_slots = list(WEAR_JACKET = "pmc_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light
	name = "\improper M4 pattern light PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. Has some armor plating removed for extra mobility."
	icon_state = "pmc_sniper"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	item_state_slots = list(WEAR_JACKET = "pmc_sniper")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate
	name = "\improper M1 pattern corporate security armor"
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This is commonly worn by low-level guards protecting Weyland-Yutani facilities."
	icon = 'icons/mob/humans/onmob/contained/wy_goons.dmi'
	icon_state = "armor"
	item_state = "armor"
	item_state_slots = null
	contained_sprite = TRUE

	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST

	slowdown = SLOWDOWN_ARMOR_NONE // only protects chest, but enables rapid movement

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This variant is worn by low-level guards that have elevated in rank due to 'good conduct in the field', also known as corporate bootlicking."
	icon_state = "lead_armor"
	item_state = "lead_armor"

/obj/item/clothing/suit/storage/marine/veteran/pmc/leader
	name = "\improper M4 pattern PMC leader armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_armor"
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/leader)
	item_state_slots = list(WEAR_JACKET = "officer_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/sniper
	name = "\improper M4 pattern PMC sniper armor"
	icon_state = "pmc_sniper"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inv_hide = HIDELOWHAIR
	item_state_slots = list(WEAR_JACKET = "pmc_sniper")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth
	name = "\improper M4 synthetic PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. This variant was designed for PMC Support Units in the field, offering protection and storage while not restricting movement."
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	storage_slots = 3

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth/Initialize()
	flags_atom |= NO_NAME_OVERRIDE
	flags_marine_armor |= SYNTH_ALLOWED
	return ..()

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc
	name = "\improper PMC gunner armor"
	desc = "A modification of the standard Armat Systems M3 armor. Hooked up with harnesses and straps allowing the user to carry an M56 Smartgun."
	icon_state = "heavy_armor"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	item_state_slots = list(WEAR_JACKET = "heavy_armor")

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc/terminator
	name = "\improper M5Xg exoskeleton gunner armor"
	desc = "A complex system of overlapping plates intended to render the wearer all but impervious to small arms fire. A passive exoskeleton supports the weight of the armor, allowing a human to carry its massive bulk. This variant is designed to support a M56 Smartgun."
	icon_state = "commando_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/commando)
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/veteran/pmc/commando
	name = "\improper M5X exoskeleton armor"
	desc = "A complex system of overlapping plates intended to render the wearer all but impervious to small arms fire. A passive exoskeleton supports the weight of the armor, allowing a human to carry its massive bulk."
	icon_state = "commando_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/commando)
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	unacidable = TRUE

//===========================//DISTRESS\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/bear
	name = "\improper H1 Iron Bears vest"
	desc = "A protective vest worn by Iron Bears mercenaries."
	icon_state = "bear_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/bear)

/obj/item/clothing/suit/storage/marine/veteran/dutch
	name = "\improper D2 armored vest"
	desc = "A protective vest worn by some seriously experienced mercs."
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS //Makes no sense but they need leg/arm armor too.
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	light_range = 7
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/dutch)

/obj/item/clothing/suit/storage/marine/veteran/van_bandolier
	name = "safari jacket"
	desc = "A tailored hunting jacket, cunningly lined with segmented armor plates. Sometimes the game shoots back."
	icon_state = "van_bandolier"
	item_state = "van_bandolier_jacket"
	blood_overlay_type = "coat"
	flags_marine_armor = NO_FLAGS //No shoulder light.
	actions_types = list()
	slowdown = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 2
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/van_bandolier)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/shotgun/van_bandolier,
	)

//===========================//U.P.P\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT


/obj/item/clothing/suit/storage/marine/faction/UPP
	name = "\improper UM5 personal armor"
	desc = "Standard body armor of the UPP military, the UM5 (Union Medium MK5) is a medium body armor, roughly on par with the M3 pattern body armor in service with the USCM, specialized towards ballistics protection. Unlike the M3, however, the plate has a heavier neckplate. This has earned many UA members to refer to UPP soldiers as 'tin men'."
	icon_state = "upp_armor"
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	storage_slots = 1
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/under/marine/veteran/UPP/medic, /obj/item/clothing/under/marine/veteran/UPP/engi)

/obj/item/clothing/suit/storage/marine/faction/UPP/support
	name = "\improper UL6 personal armor"
	desc = "Standard body armor of the UPP military, the UL6 (Union Light MK6) is a light body armor, slightly weaker than the M3 pattern body armor in service with the USCM, specialized towards ballistics protection. This set of personal armor lacks the iconic neck piece and some of the armor in favor of user mobility."
	storage_slots = 3
	icon_state = "upp_armor_support"
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/suit/storage/marine/faction/UPP/commando
	name = "\improper UM5CU personal armor"
	desc = "A modification of the UM5, designed for stealth operations."
	icon_state = "upp_armor_commando"
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT

/obj/item/clothing/suit/storage/marine/faction/UPP/heavy
	name = "\improper UH7 heavy plated armor"
	desc = "An extremely heavy-duty set of body armor in service with the UPP military, the UH7 (Union Heavy MK7) is known for having powerful ballistic protection, alongside a noticeable neck guard, fortified in order to allow the wearer to endure the stresses of the bulky helmet."
	icon_state = "upp_armor_heavy"
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_HEAVY
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_ALL_BUT_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/suit/storage/marine/faction/UPP/heavy/Initialize()
	. = ..()
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/pkp,
		)

/obj/item/clothing/suit/storage/marine/faction/UPP/officer
	name = "\improper UL4 officer jacket"
	desc = "A lightweight jacket, issued to officers of the UPP's military. Slightly protective from incoming damage, best off with proper armor however."
	icon_state = "upp_coat_officer"
	slowdown = SLOWDOWN_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 3
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/kapitan
	name = "\improper UL4 senior officer jacket"
	desc = "A lightweight jacket, issued to senior officers of the UPP's military. Made of high-quality materials, even going as far as having the ranks and insignia of the Kapitan and their Company emblazoned on the shoulders and front of the jacket. Slightly protective from incoming damage, best off with proper armor however."
	icon_state = "upp_coat_kapitan"
	slowdown = SLOWDOWN_ARMOR_NONE
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/mp
	name = "\improper UL4 camouflaged jacket"
	desc = "A lightweight jacket, issued to troops when they're not expected to engage in combat. Still studded to the brim with kevlar shards, though the synthread construction reduces its effectiveness."
	icon_state = "upp_coat_mp"
	slowdown = SLOWDOWN_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/marine/faction/UPP/jacket/ivan
	name = "\improper UH4 Camo Jacket"
	desc = "An experimental heavily armored variant of the UL4 given to only the most elite units... usually."
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	storage_slots = 2


//===========================//FREELANCER\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction/freelancer
	name = "freelancer cuirass"
	desc = "An armored protective chestplate scrapped together from various plates. It keeps up remarkably well, as the craftsmanship is solid, and the design mirrors such armors in the UPP and the USCM. The many skilled craftsmen in the freelancers ranks produce these vests at a rate about one a month."
	icon_state = "freelancer_armor"
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/freelancer)

//this one is for CLF
/obj/item/clothing/suit/storage/militia
	name = "colonial militia hauberk"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "rebel_armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	uniform_restricted = list(/obj/item/clothing/under/colonist)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/militia/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/militia/vest
	name = "colonial militia vest"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This extremely light variant protects only the chest and abdomen."
	icon_state = "clf_2"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/brace
	name = "colonial militia brace"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This extremely light variant has some of the chest pieces removed."
	icon_state = "clf_3"
	flags_armor_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/partial
	name = "colonial militia partial hauberk"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This even lighter variant has some of the arm pieces removed."
	icon_state = "clf_4"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2

/obj/item/clothing/suit/storage/militia/smartgun
	name = "colonial militia harness"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This one has straps interweaved with the plates, that allow the user to fire a captured smartgun, if a bit uncomfortably."
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS

/obj/item/clothing/suit/storage/CMB
	name = "\improper CMB jacket"
	desc = "A black jacket worn by Colonial Marshals. The back is enscribed with the powerful letters of 'MARSHAL' representing justice, authority, and protection in the outer rim. The laws of the Earth stretch beyond the Sol."
	icon_state = "CMB_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/CMB/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/RO
	name = "quartermaster jacket"
	desc = "A green jacket worn by USCM personnel. The back has the flag of the United Americas on it."
	icon_state = "RO_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/mercenary
	name = "\improper K12 ceramic plated armor"
	desc = "A set of grey, heavy ceramic armor with dark blue highlights. It is the standard uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_heavy_armor"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/mercenary)
	item_state_slots = list(WEAR_JACKET = "mercenary_heavy_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/heavy
	name = "\improper Modified K12 ceramic plated armor"
	desc = "A set of grey, heavy ceramic armor with dark blue highlights. It has been modified with extra ceramic plates placed in its storage pouch, and seems intended to support an extremely heavy weapon."
	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGHPLUS
	storage_slots = 1

/obj/item/clothing/suit/storage/marine/veteran/mercenary/miner
	name = "\improper Y8 armored miner vest"
	desc = "A set of beige, light armor built for protection while mining. It is a specialized uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_miner_armor"
	storage_slots = 3
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/mercenary)
	item_state_slots = list(WEAR_JACKET = "mercenary_miner_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/support
	name = "\improper Z7 armored vest"
	desc = "A set of blue armor with yellow highlights built for protection while building or carrying out medical treatment in highly dangerous environments. It is a specialized uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_engineer_armor"
	item_state_slots = list(WEAR_JACKET = "mercenary_engineer_armor")

/obj/item/clothing/suit/storage/marine/M3G/hefa
	name = "\improper HEFA Knight armor"
	desc = "A thick piece of armor adorning a HEFA. Usually seen on a HEFA knight."
	specialty = "HEFA Knight"
	icon_state = "hefadier"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_item = NO_CRYO_STORE
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_GIGAHIGH


//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/MP/provost
	name = "\improper M3 pattern Provost armor"
	desc = "A lighter Provost M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "pvlight"
	item_state_slots = list(WEAR_JACKET = "pvlight")
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/marine/MP/provost/enforcer
	name = "\improper M3 pattern Provost armor"
	desc = "A standard Provost M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "pvmedium"
	item_state_slots = list(WEAR_JACKET = "pvmedium")
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/marine/MP/provost/tml
	name = "\improper M3 pattern Senior Provost armor"
	icon_state = "pvleader"
	item_state_slots = list(WEAR_JACKET = "pvleader")
	desc = "A more refined Provost M3 Pattern Chestplate for senior officers. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."

	slowdown = SLOWDOWN_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/suit/storage/marine/MP/provost/marshal
	icon_state = "pvmarshal"
	item_state_slots = list(WEAR_JACKET = "pvmarshal")
	name = "\improper M3 pattern Provost Marshal armor"
	desc = "A custom fit luxury armor suit for Provost Marshals. Useful for letting your men know who is in charge when taking to the field."

/obj/item/clothing/suit/storage/marine/MP/provost/marshal/chief
	name = "\improper M3 pattern Provost Chief Marshal armor"

//================//UNITED AMERICAS ALLIED COMMAND\\=====================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/uaac/tis/sa
	name = "\improper M3 pattern UAAC-TIS Special Agent Armor"
	desc = "A modified luxury armor, originally meant for a USCM Provost Marshall, modified to use the colors and insignia of the TIS. The Three Eyes is technically able to requisition any equipment or personnel to fulfill its mission and often uses this privilege to outfit their agents with high-quality gear from other UA military forces."
	icon_state = "tis"
	item_state_slots = list(WEAR_JACKET = "tis")
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/hailer,
		/obj/item/storage/belt/gun,
		/obj/item/weapon/claymore/mercsword/ceremonial,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/uaac/tis)

//================//UNITED AMERICAS RIOT CONTROL\\=====================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/ua_riot
	name = "\improper UA-M1 body armor"
	desc = "Based on the M-3 pattern employed by the USCM, the UA-M1 body armor is employed by UA security, riot control and union-busting teams. While robust against melee and bullet attacks, it critically lacks coverage of the legs and arms."
	icon_state = "ua_riot"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT  // it's lighter
	uniform_restricted = list(/obj/item/clothing/under/marine/ua_riot)
	flags_atom = NO_SNOW_TYPE

//==================War Correspondent==================\\

/obj/item/clothing/suit/storage/marine/light/reporter
	name = "press body armor"
	desc = "Body armor used by war correspondents in battles and wars across the universe."
	icon = 'icons/mob/humans/onmob/contained/war_correspondent.dmi'
	icon_state = "wc_armor"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	contained_sprite = TRUE


//=ROYAL MARINES=\\

/obj/item/clothing/suit/storage/marine/veteran/royal_marine
	name = "kestrel armoured vest"
	desc = "A customizable personal armor system used by the Three World Empire's Royal Marines Commandos. Designers from a Weyland Yutani subsidary, Lindenthal-Ehrenfeld Militärindustrie, iterated on the USCMC's M3 pattern personal armor in their Tokonigara lab to create an armor systemed to suit the unique needs of the Three World Empire's smaller but better equipped Royal Marines."
	icon_state = "rmc_light"
	item_state = "rmc_light"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/light //RMC Rifleman Armor
	icon_state = "rmc_light"
	item_state = "rmc_light"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	slowdown = SLOWDOWN_ARMOR_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/team_leader //RMC TL & LT Armor
	name = "kestrel armoured carry vest"
	icon_state = "rmc_light_padded"
	item_state = "rmc_light_padded"
	storage_slots = 7

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/smartgun //Smartgun Spec Armor
	name = "kestrel armoured smartgun harness"
	icon_state = "rmc_smartgun"
	item_state = "rmc_smartgun"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/pointman //Pointman Spec Armor
	name = "kestrel pointman armour"
	desc = "A heavier version of the armor system used by the Three World Empire's Royal Marines Commandos. Designers from a Weyland Yutani subsidary, Lindenthal-Ehrenfeld Militärindustrie, iterated on the USCMC's M3 pattern personal armor in their Tokonigara lab to create an armor systemed to suit the unique needs of the Three World Empire's smaller but better equipped Royal Marines."
	icon_state = "rmc_pointman"
	item_state = "rmc_pointman"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 7
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/atom/movable/marine_light
	light_system = DIRECTIONAL_LIGHT
