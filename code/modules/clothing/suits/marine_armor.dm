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

#define ALPHA		1
#define BRAVO		2
#define CHARLIE		3
#define DELTA		4
#define ECHO		5
#define CRYO		6
#define SOF		7
#define NOSQUAD 	8

var/list/armormarkings = list()
var/list/armormarkings_sql = list()
var/list/helmetmarkings = list()
var/list/helmetmarkings_sql = list()
var/list/glovemarkings = list()
var/list/squad_colors = list(rgb(230,25,25), rgb(255,195,45), rgb(200,100,200), rgb(65,72,200), rgb(103,214,146), rgb(196, 122, 80), rgb(64, 0, 0))
var/list/squad_colors_chat = list(rgb(230,125,125), rgb(255,230,80), rgb(255,150,255), rgb(130,140,255), rgb(103,214,146), rgb(196, 122, 80), rgb(64, 0, 0))

/proc/initialize_marine_armor()
	var/i
	for(i=1, i<(length(squad_colors) + 1), i++)
		var/squad_color = squad_colors[i]
		var/armor_color = rgb(hex2num(copytext(squad_color, 2, 4)), hex2num(copytext(squad_color, 4, 6)), hex2num(copytext(squad_color, 6, 8)), 125)

		var/image/armor
		var/image/helmet
		var/image/glove

		armor = image('icons/mob/humans/onmob/suit_1.dmi',icon_state = "std-armor")
		armor.color = armor_color
		armormarkings += armor
		armor = image('icons/mob/humans/onmob/suit_1.dmi',icon_state = "sql-armor")
		armor.color = armor_color
		armormarkings_sql += armor

		helmet = image('icons/mob/humans/onmob/head_1.dmi',icon_state = "std-helmet")
		helmet.color = armor_color
		helmetmarkings += helmet
		helmet = image('icons/mob/humans/onmob/head_1.dmi',icon_state = "sql-helmet")
		helmet.color = armor_color
		helmetmarkings_sql += helmet

		glove = image('icons/mob/humans/onmob/hands_garb.dmi',icon_state = "std-gloves")
		glove.color = armor_color
		glovemarkings += glove



// MARINE STORAGE ARMOR

/obj/item/clothing/suit/storage/marine
	name = "\improper M3 Personal Body Armor"
	desc = "The standard configuration M3 Pattern Body Armor. What else do you need to know about it? Well, since you asked - With design inspiration drawn off the French cuirasse, the M3 is built out of a light-weight titanium alloy, with several layers to account for spalling. Robust, and designed to function as the perfect armor for the shock-and-awe of the Colonial Marines. A TNR-Shoulder Lamp rests off its side, illuminating the way forward for you. Scratches and dents litter the armor, it's served many a marine before it's come to you. Oorah."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	flags_atom = FPRINT|CONDUCT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = ARMOR_min_cold_protection_temperature
	max_heat_protection_temperature = ARMOR_max_heat_protection_temperature
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
	allowed = list(/obj/item/weapon/gun/,
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
		/obj/item/device/walkman
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_PONCHO)

	var/brightness_on = 6 //Average attachable pocket light
	var/flashlight_cooldown = 0 //Cooldown for toggling the light
	var/locate_cooldown = 0 //Cooldown for SL locator
	var/armor_overlays[]
	actions_types = list(/datum/action/item_action/toggle)
	var/flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY
	var/specialty = "M3 pattern marine" //Same thing here. Give them a specialty so that they show up correctly in vendors.
	w_class = SIZE_HUGE
	uniform_restricted = list(/obj/item/clothing/under/marine)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	time_to_unequip = 20
	time_to_equip = 20
	equip_sounds = list('sound/handling/putting_on_armor1.ogg')
	var/armor_variation = 0

	//speciality does NOTHING if you have NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/Initialize()
	. = ..()
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow armor" //Leave marine out so that armors don't have to have "Marine" appended (see: generals).
		else
			name += " armor"
	if(armor_variation)
		icon_state = replacetext(icon_state,"1","[rand(1,armor_variation)]")

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	armor_overlays = list("lamp") //Just one for now, can add more later.
	update_icon()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

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

/obj/item/clothing/suit/storage/marine/pickup(mob/user)
	if(flags_marine_armor & ARMOR_LAMP_ON)
		user.SetLuminosity(brightness_on, FALSE, src)
		SetLuminosity(0)
	..()

/obj/item/clothing/suit/storage/marine/dropped(mob/user)
	if(loc != user)
		turn_off_light(user)
	..()


/obj/item/clothing/suit/storage/marine/proc/is_light_on()
	return flags_marine_armor & ARMOR_LAMP_ON

/obj/item/clothing/suit/storage/marine/proc/turn_off_light(mob/wearer)
	if(is_light_on())
		if(wearer)
			wearer.SetLuminosity(0, FALSE, src)
		SetLuminosity(brightness_on)
		toggle_armor_light() //turn the light off
		return 1
	return 0

/obj/item/clothing/suit/storage/marine/Destroy()
	if(ismob(src.loc))
		src.loc.SetLuminosity(0, FALSE, src)
	else
		SetLuminosity(0)
	return ..()

/obj/item/clothing/suit/storage/marine/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You cannot turn the light on while in [user.loc].")) //To prevent some lighting anomalities.
		return
	if(flashlight_cooldown > world.time)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	toggle_armor_light(user)

/obj/item/clothing/suit/storage/marine/item_action_slot_check(mob/user, slot)
	if(!ishuman(user)) return FALSE
	if(slot != WEAR_JACKET) return FALSE
	return TRUE //only give action button when armor is worn.

/obj/item/clothing/suit/storage/marine/proc/toggle_armor_light(mob/user)
	flashlight_cooldown = world.time + 20 //2 seconds cooldown every time the light is toggled
	if(is_light_on()) //Turn it off.
		if(user) user.SetLuminosity(0, FALSE, src)
		else SetLuminosity(0)
		playsound(src,'sound/handling/click_2.ogg', 50, 1)
	else //Turn it on.
		if(user) user.SetLuminosity(brightness_on, FALSE, src)
		else SetLuminosity(brightness_on)

	flags_marine_armor ^= ARMOR_LAMP_ON

	playsound(src,'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/suit/storage/marine/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(isSynth(M) && M.allow_gun_usage == FALSE && !(flags_marine_armor & SYNTH_ALLOWED))
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

/obj/item/clothing/suit/storage/marine/xm4
	icon_state = "io"
	name = "\improper XM4 Pattern Armor"
	desc = "The XM4 Pattern Armor is one of the newer armors to hit the fleet, it's being field tested nowadays by units on the edge of UA space. Developed alongside the B-Pattern Armors, the XM4 bolsters a different philosophy for increasing survival rates among the Colonial Marines. A further development on the concept started with Recon-configuration armor, XM4 is made out of the same mesh used in smartgunner-rigs in order to provide higher protection to marines while increasing flexibility. At request of FORECON, more thought has been put into a better designed storage system on the XM4 - Featuring a more expansive leather pouch attached to the armor."
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 4
	brightness_on = 7 //slightly higher
	specialty = "M4 pattern marine"

/obj/item/clothing/suit/storage/marine/MP
	name = "\improper M3 Peacekeeping Pattern Armor"
	desc = "Produced in 2173, this variant of M3 armor is made for general use by marines tasked with peacekeeping duties. Being utilised both byshore patrol catching up with rowdy marines on Arcturus, or military policemen enforcing order on standard USCM vessels. It differs little from the standard M3 configuration armor, other than having a mesh, similar to that of a stab-vest being built into the armor to protect from puncturing weapons alongside the hefty ballistic protection."
	icon_state = "mp"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_SNOW_TYPE
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/hailer,
		/obj/item/storage/belt/gun,
		/obj/item/weapon/melee/claymore/mercsword/ceremonial,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
	specialty = "M3 Peacekeeping Pattern Armor"
	item_state_slots = list(WEAR_JACKET = "mp")

/obj/item/clothing/suit/storage/marine/MP/jacket
	name = "\improper M3 Ceremonial Pattern Armor"
	desc = "It's the same M3-Peacekeeping armor found ontop of normal military police men and women. Nothing's changed about the actual M3-P itself, it's uncomfortable while worn atop the black service jacket. This configuration is only ever seen being worn on honor guards or for MPs providing security at formal events for the United Americas."
	icon_state = "mp_jacket"
	specialty = "M3 Ceremonial Pattern Armor"
	item_state_slots = list(WEAR_JACKET = "mp_jacket")

//Making a new object because we might want to edit armor values and such.
//Or give it its own sprite. It's more for the future.
/obj/item/clothing/suit/storage/marine/CO
	name = "\improper M3 pattern captain armor"
	desc = "A robust, well-polished suit of armor for the Commanding Officer. Custom-made to fit its owner with special straps to operate a smartgun. Show those Marines who's really in charge."
	icon_state = "co_officer"
	item_state = "co_officer"
	armor_bullet = CLOTHING_ARMOR_HIGH
	storage_slots = 3
	flags_atom = NO_SNOW_TYPE
	flags_inventory = SMARTGUN_HARNESS
	uniform_restricted = list(/obj/item/clothing/under/marine, /obj/item/clothing/under/rank/ro_suit)
	specialty = "M3 pattern captain"
	item_state_slots = list(WEAR_JACKET = "co_officer")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_PONCHO)


/obj/item/clothing/suit/storage/marine/CO/jacket
	name = "\improper M3 pattern captain armored coat"
	desc = "A robust, well-polished suit of armor for the Commanding Officer. Custom-made to fit its owner with special straps to operate a smartgun. Show those Marines who's really in charge. This one has a coat over it for added warmth."
	icon_state = "bridge_coat_armored"
	item_state = "bridge_coat_armored"
	item_state_slots = list(WEAR_JACKET = "bridge_coat_armored")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK)


/obj/item/clothing/suit/storage/marine/smartgunner
	name = "M56 Combat Harness"
	desc = "Drawing the line between a set of armor and weapon system, the M56 Combat Harness is a truly fascinating piece of equipment within the expansive arsenal of the USCM. It was the first among USCM equipment to use a special mash, in order to maximize protection and minimize further weight with the already hefty smartgun. With a power supply built into the armor for it's sight, this connects seamlessly to a powerpack. Besides that, of note is a 'arm' attached to the front of the system meant to attach the M56A2 Smartgun. Since it's design, several other weapon systems have been conceptualized that use this same system."
	icon_state = "8"
	item_state = "armor"
	armor_laser = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_inventory = SMARTGUN_HARNESS
	allowed = list(/obj/item/tank/emergency_oxygen,
					/obj/item/device/flashlight,
					/obj/item/ammo_magazine,
					/obj/item/explosive/mine,
					/obj/item/attachable/bayonet,
					/obj/item/weapon/gun/smartgun,
					/obj/item/storage/backpack/general_belt,
					/obj/item/device/motiondetector,
					/obj/item/device/walkman)

/obj/item/clothing/suit/storage/marine/smartgunner/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "M56 combat harness")
		name = "M56 snow combat harness"
	else
		name = "M56 combat harness"
	//select_gamemode_skin(type)


/obj/item/clothing/suit/storage/marine/leader
	name = "\improper B12 Pattern Armor"
	desc = "Coming from the same program that resulted in the XM4 Pattern Armor, the B12 Pattern Armor takes a different design philosophy than that of the XM4 pattern armor - Rather than optimizing to increase vision and stowage capacity to try and increase the average survival rate, B12 takes a simple approach to how to increase marine life expectancy by simply slapping more armor atop them. Despite that, it's been carefully made out of the expensive smartgunner mesh in order to keep marines from being too encumbered after complaints from the M3-EOD armor."
	icon_state = "7"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "B12 pattern marine"

/obj/item/clothing/suit/storage/marine/tanker
	name = "\improper M3 Tanker Pattern Armor"
	desc = "A modified and refashioned suit of M3 Pattern armor designed to be worn by vehicle crewmen throughout the USCM. Many reports have come back about the discomfort caused by wearing the M3 Tanker Pattern Armor in vehicles like the Longstreet, leading to many crewmen to unofficially ditch it for their tanker jackets in the field. Nonetheless, for the crews that do keep it, there's not much of a difference from standard M3 configuration armor; other than some armor being shaved in order to allow crewmen more flexibility while manning their vehicles.
	icon_state = "tanker"
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/tanker)
	specialty = "M3 pattern tanker"
	storage_slots = 2

//===========================//PFC ARMOR CLASSES\\================================\\
//=================================================================================\\

/obj/item/clothing/suit/storage/marine/medium
	armor_variation = 6

/obj/item/clothing/suit/storage/marine/light
	name = "\improper M3-R Reconnaissance Pattern Armor"
	desc = "The M3-R is a configuration of the iconic M3 Personal Body Armor meant to be issued out towards specialised recon units - In practice, due to it's cheap manufacturing cost and the high flexibility offered by the M3-R, it's become a favourite within front-line units. While still being made up of the same ultra-light titanium alloy, the M3-R configuration removes the groin-padding, and overall has had armor shaved off to maximise speed."
	specialty = "\improper M3-R Recce Pattern Armor"
	icon_state = "L1"
	armor_variation = 6
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/vest
	name = "\improper M3-RB Ballistics Pattern Vest"
	desc = "Up until 2189 USCM non-combat personnel were issued non-standardized ballistics vests, though the lack of IMP compatibility and suit lamps proved time and time again inefficient. This modified M3-R shell is the result of a 6-year R&D program; It provides utility, protection, AND comfort to all USCM non-combat personnel, while serving to protect all vital organs."
	icon_state = "VL"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_LAMP_OVERLAY //No squad colors when wearing this since it'd look funny.
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 1
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	siemens_coefficient = 0.7
	uniform_restricted = null

/obj/item/clothing/suit/storage/marine/light/vest/dcc
	name = "\improper M3-VL Flak Vest"
	desc = "A combination of the standard non-combat M3-RB Ballistics Vest and the dated V70 Flak Jacket, the M3-VL Flak Jacket is the pinnacle of both designs. A development that's only just hit the fleet - It borrows the lightweight, titanium-alloy from the M3 Pattern Armor to protect it's wearers, alongside the TNR-Shoulder Lamp and several features unique to the V70 to serve it's wearers. The M3-VL is meant, in tandem with the pilot's bodysuit to protect against the high Gs encountered piloting a Cheyenne, as well as that, a more complex sensor system is built into the armor directly."
	icon_state = "VL_FLAK"
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/synvest
	name = "\improper M3A1 Synthetic Utility Vest"
	desc = "This variant of the ubiquitous M3 pattern ballistics vest has been extensively modified, providing no protection in exchange for maximum mobility and storage space. There's not much that's different from the standard M3-VL in this suit, other than it being compliant with synthetic programming and the rules of war."
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
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	uniform_restricted = null

/obj/item/clothing/suit/storage/marine/light/synvest/vanilla
	icon_state = "VL_syn"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/heavy
	name = "\improper M3-EOD Pattern Armor"
	desc = "A heavier version of the standard M3 pattern armor, this configuration of the iconic armor was developed during the Canton War in 2160 between the UPP and USCM - Designed in response to a need for higher protection for ComTechs assigned as EODs during the conflict, this is the pinnacle of protection for your average marine. The shoulders and kneepads have both been expanded upon heavily, covering up the arteries on each limb. A special spall liner was developed for this suit, with the same technology being used in the M70 Flak Jacket being developed at the same time."
	specialty = "\improper M3-EOD Pattern Armor"
	icon_state = "H1"
	armor_variation = 6
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

//===========================//SPECIALIST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/M3G
	name = "\improper M3-G4 grenadier armor"
	desc = "A further development upon the already bulky set of armor made during the Canton war for EODs. This armor is not meant for EOD techs, rather, but for grenadiers operating across the many frontiers of the Americas. It expands across the significant coverage with a neck guard, meant to protect the vital carotid arteries. While bulky, it'll defintely save your life from shrapnel, bullets, you name it, really."
	icon_state = "grenadier"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCK_KNOCKDOWN
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_HEAVY
	specialty = "M3-G4 grenadier"
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/M3T
	name = "\improper M3-T light armor"
	desc = "One of the many, many offshoots that've come off M3-R Recce Armor, the M3-T was designed for hunter-killer units of the USMC. These teams are meant to take out enemy armor, and were a revisiting of a 21st century concept, brought into relevance once again by the Canton war. It's lightweight, and honestly, doesn't seem like what you'd expect for a rocketeer's armor. More magnets have been designed into the armor to overall better disperse the weight of a SADAR upon an operator."
	icon_state = "demolitionist"
	armor_bomb = CLOTHING_ARMOR_HIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-T light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/M3S
	name = "\improper M3-S light armor"
	desc = "M3-S, an interesting design, if any marine designs are. Rumors say it's been reverse engineered from UPP Special Operating Forces, who allegedly all using stealthing techonlogy. Whatever the case, it's made out of a mix of smartgunner mesh, and a classified alloy in order to keep it lightweight while protecting the wearer. This armor is meant to be worn with their issued out cloaks, and allegedly limits their signature heavily on infared. "
	icon_state = "scout_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-S light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	unacidable = TRUE

#define FIRE_SHIELD_CD 150

/obj/item/clothing/suit/storage/marine/M35
	name = "\improper M35 pyrotechnician armor"
	desc = "With the discovery of the XX-121 specimen, 'Xenomorphs', pyrotechnicians have held a revitalized role within the USCM. These technicians are often called upon to clear the thick resin hives created by Xenomorphs. Their armor is made out of a mesh that protects the body from flames, this nomex-fiber protecting them from their flames. Like a compression suit, funnily enough, the M35 has complete temperature regulation within the suit."
	icon_state = "pyro_armor"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = FIRESUIT_max_heat_protection_temperature
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
		RegisterSignal(user, COMSIG_LIVING_FLAMER_CROSSED, .proc/flamer_fire_callback)
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
	RegisterSignal(H, COMSIG_LIVING_PREIGNITION, .proc/fire_shield_is_on)
	RegisterSignal(H, list(
		COMSIG_LIVING_FLAMER_FLAMED,
	), .proc/flamer_fire_callback)
	fire_shield_on = TRUE
	can_activate = FALSE
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()
	addtimer(CALLBACK(src, .proc/end_fire_shield, H), 6 SECONDS)

	H.add_filter("firewalk_on", 1, list("type" = "outline", "color" = "#03fcc6", "size" = 1))

/obj/item/clothing/suit/storage/marine/M35/proc/end_fire_shield(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("FIREWALK protocol has finished."))
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	fire_shield_on = FALSE

	user.remove_filter("firewalk_on")

	addtimer(CALLBACK(src, .proc/enable_fire_shield, user), FIRE_SHIELD_CD)

/obj/item/clothing/suit/storage/marine/M35/proc/enable_fire_shield(var/mob/living/carbon/human/user)
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

/obj/item/clothing/suit/storage/marine/M35/dropped(var/mob/user)
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

/datum/action/item_action/specialist/fire_shield/New(var/mob/living/user, var/obj/item/holder)
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
	desc = "A rite of passage for all scout-snipers within the USCM, one that's been going on for longer than the USCM itself has. Each ghillie suit is custom made by the sniper themselves, with usually several being made for the different enviorments they may find themselves within. Beneath the suit, is a military made fiber made to reduce it's signature on radar. A heat sink is connected into the armor, though is not integral for functionality."
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
	if(ishuman(user) && !isSynth(user))
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
		, .proc/fade_in)
	RegisterSignal(H, list(
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_EXTINGUISH
	), .proc/deactivate_camouflage)
	RegisterSignal(H, COMSIG_MOB_POST_UPDATE_CANMOVE, .proc/fix_density)
	camo_active = TRUE
	H.alpha = full_camo_alpha
	H.FF_hit_evade = 1000
	H.density = FALSE

	RegisterSignal(H, COMSIG_MOB_MOVE_OR_LOOK, .proc/handle_mob_move_or_look)

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
		addtimer(CALLBACK(src, .proc/fade_out_finish, H), camouflage_break, TIMER_OVERRIDE|TIMER_UNIQUE)
		animate(H, alpha = full_camo_alpha + 5, time = camouflage_break, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)

/obj/item/clothing/suit/storage/marine/ghillie/proc/fix_density(mob/user)
	SIGNAL_HANDLER
	if(camo_active)
		user.density = FALSE

/obj/item/clothing/suit/storage/marine/ghillie/proc/fade_out_finish(var/mob/living/carbon/human/H)
	if(camo_active && H.wear_suit == src)
		to_chat(H, SPAN_BOLDNOTICE("The smoke clears and your position is once again hidden completely!"))
		animate(H, alpha = full_camo_alpha)
		current_camo = full_camo_alpha

/obj/item/clothing/suit/storage/marine/ghillie/proc/handle_mob_move_or_look(mob/living/mover, var/actually_moving, var/direction, var/specific_direction)
	SIGNAL_HANDLER

	if(camo_active && actually_moving)
		deactivate_camouflage(mover)

/datum/action/item_action/specialist/prepare_position
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/prepare_position/New(var/mob/living/user, var/obj/item/holder)
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

/obj/item/clothing/suit/storage/marine/sof
	name = "\improper SOF Armor"
	desc = "A heavily customized suit of M3 armor. Used by Marine Raiders. This uses many techonologies spearheaded by USCM scout-snipers in order to enhance the performance of marine special forces. A temperature regulator is built into the armor in order to keep the wearer matching their surrounding temperature, and provide extra comfort levels in their extreme enviorments. While unknown publicly, whatever material this is made out of is surely worth the hefty price tag - As M3 SOF is able to protect from a massive amount of trauma. A pinnacle of USCM design."
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

//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make these keep their name and icon.

/obj/item/clothing/suit/storage/marine/veteran/PMC
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
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/melee/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/PMC)
	item_state_slots = list(WEAR_JACKET = "pmc_armor")

/obj/item/clothing/suit/storage/marine/veteran/PMC/light
	name = "\improper M4 pattern light PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. Has some armour plating removed for extra mobility."
	icon_state = "pmc_sniper"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	item_state_slots = list(WEAR_JACKET = "pmc_sniper")

/obj/item/clothing/suit/storage/marine/veteran/PMC/light/corporate
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

/obj/item/clothing/suit/storage/marine/veteran/PMC/light/corporate/lead
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This variant is worn by low-level guards that have elevated in rank due to 'good conduct in the field', also known as corporate bootlicking."
	icon_state = "lead_armor"
	item_state = "lead_armor"

/obj/item/clothing/suit/storage/marine/veteran/PMC/leader
	name = "\improper M4 pattern PMC leader armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_armor"
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/PMC/leader)
	item_state_slots = list(WEAR_JACKET = "officer_armor")

/obj/item/clothing/suit/storage/marine/veteran/PMC/sniper
	name = "\improper M4 pattern PMC sniper armor"
	icon_state = "pmc_sniper"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDELOWHAIR
	item_state_slots = list(WEAR_JACKET = "pmc_sniper")

/obj/item/clothing/suit/storage/marine/veteran/PMC/light/synth
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

/obj/item/clothing/suit/storage/marine/veteran/PMC/light/synth/Initialize()
	flags_atom |= NO_NAME_OVERRIDE
	flags_marine_armor |= SYNTH_ALLOWED
	return ..()

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC
	name = "\improper PMC gunner armor"
	desc = "A modification of the standard Armat Systems M3 armor. Hooked up with harnesses and straps allowing the user to carry an M56 Smartgun."
	icon_state = "heavy_armor"
	flags_inventory = BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	item_state_slots = list(WEAR_JACKET = "heavy_armor")

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC/terminator
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
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/PMC/commando)
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/veteran/PMC/commando
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
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/PMC/commando)
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
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	brightness_on = 9
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/dutch)

/obj/item/clothing/suit/storage/marine/veteran/van_bandolier
	name = "safari jacket"
	desc = "A tailored hunting jacket, cunningly lined with segmented armour plates. Sometimes the game shoots back."
	icon_state = "van_bandolier"
	item_state = "van_bandolier_jacket"
	blood_overlay_type = "coat"
	flags_marine_armor = NO_FLAGS //No shoulder light.
	actions_types = list()
	slowdown = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 2
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/van_bandolier)
	allowed = list(/obj/item/weapon/gun,
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
		/obj/item/storage/belt/shotgun/van_bandolier
	)

//===========================//U.P.P\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = ARMOR_min_cold_protection_temperature
	max_heat_protection_temperature = ARMOR_max_heat_protection_temperature
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

/obj/item/clothing/suit/storage/marine/faction/support
	name = "\improper UM5B personal armor"
	desc = "Standard body armor of the UPP military, the UM5B (Union Medium MK5 Beta) is a light body armor, slightly weaker than the M3 pattern body armor in service with the USCM, specialized towards ballistics protection. This set of personal armor lacks the iconic neck piece and some of the armor in favor of user mobility."
	icon_state = "upp_armor_support"
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

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
	slowdown = SLOWDOWN_ARMOR_HEAVY
	flags_inventory = BLOCK_KNOCKDOWN
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
		/obj/item/ammo_magazine/minigun
		)

/obj/item/clothing/suit/storage/marine/faction/UPP/officer
	name = "\improper UL6 officers jacket"
	desc = "A lightweight jacket, issued to officers of the UPP's military. Still studded to the brim with kevlar shards, though the synthread construction reduces its effectiveness."
	icon_state = "upp_coat_officer"
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 3
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/kapitan
	name = "\improper UL6 Kapitan's jacket"
	desc = "A lightweight jacket, issued to the Kapitans of the UPP's military. Made of high-quality materials, even going as far as having the ranks and insignia of the Kapitan and their Company emblazoned on the shoulders and front of the jacket."
	icon_state = "upp_coat_kapitan"
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/mp
	name = "\improper UL6 camouflaged jacket"
	desc = "A lightweight jacket, issued to troops when they're not expected to engage in combat. Still studded to the brim with kevlar shards, though the synthread construction reduces its effectiveness."
	icon_state = "upp_coat_mp"
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/marine/faction/UPP/jacket/ivan
	name = "\improper UH6 Camo Jacket"
	desc = "An experimental heavily armored variant of the UL6 given to only the most elite units.. usually."
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
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/melee/baseballbat,
		/obj/item/weapon/melee/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_min_cold_protection_temperature
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
	flags_inventory = SMARTGUN_HARNESS

/obj/item/clothing/suit/storage/CMB
	name = "\improper CMB jacket"
	desc = "A green jacket worn by crew on the Colonial Marshals."
	icon_state = "CMB_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	allowed = list(/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/melee/baton,
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
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman
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
	name = "\improper RO jacket"
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
	flags_inventory = BLOCK_KNOCKDOWN
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/melee/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
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
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/melee/claymore/mercsword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
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
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/hailer,
		/obj/item/storage/belt/gun,
		/obj/item/weapon/melee/claymore/mercsword/ceremonial,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
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
