/obj/item/clothing/suit/storage/jacket/marine //BASE ITEM
	name = "marine jacket"
	//This really should not be spawned
	desc = "What the hell is this doing here?"
	icon = 'icons/obj/items/clothing/suits/suits_by_map/jungle.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/jungle.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/backpack/general_belt,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
	)

	//Buttons
	var/has_buttons = FALSE
	var/buttoned = TRUE
	var/initial_icon_state

/obj/item/clothing/suit/storage/jacket/marine/proc/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(src.buttoned == TRUE)
		src.icon_state = "[initial_icon_state]_o"
		src.buttoned = FALSE
		to_chat(usr, SPAN_INFO("You unbutton \the [src]."))
	else
		src.icon_state = "[initial_icon_state]"
		src.buttoned = TRUE
		to_chat(usr, SPAN_INFO("You button \the [src]."))
	update_clothing_icon()

/obj/item/clothing/suit/storage/jacket/marine/Initialize()
	. = ..()
	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin(type)
		initial_icon_state = icon_state
	if(has_buttons)
		verbs += /obj/item/clothing/suit/storage/jacket/marine/proc/toggle

/obj/item/clothing/suit/storage/jacket/marine/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/suits/suits_by_map/jungle.dmi'
			item_icons[WEAR_JACKET] = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/suits/suits_by_map/classic.dmi'
			item_icons[WEAR_JACKET] = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/suits/suits_by_map/desert.dmi'
			item_icons[WEAR_JACKET] = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/suits/suits_by_map/snow.dmi'
			item_icons[WEAR_JACKET] = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/suits/suits_by_map/urban.dmi'
			item_icons[WEAR_JACKET] = 'icons/mob/humans/onmob/clothing/suits/suits_by_map/urban.dmi'

//Marine service & tanker jacket + MP themed variants
/obj/item/clothing/suit/storage/jacket/marine/service
	name = "marine service jacket"
	desc = "A service jacket typically worn by officers of the USCM. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	has_buttons = TRUE
	icon_state = "coat_officer"

/obj/item/clothing/suit/storage/jacket/marine/pilot/armor
	name = "\improper M70 flak jacket"
	desc = "A flak jacket used by dropship pilots to protect themselves while flying in the cockpit. Excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "pilot"
	has_buttons = TRUE
	initial_icon_state = "pilot"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/pilot)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')

/obj/item/clothing/suit/storage/jacket/marine/pilot
	name = "\improper M70B1 light flak jacket"
	desc = "A light flak jacket used by dropship pilots to protect themselves while flying in the cockpit. This specific flak jacket has been designed for style and comfort over protection, and it shows. Don't get hit by any stray bullets!"
	icon_state = "pilot_alt"
	has_buttons = TRUE
	initial_icon_state = "pilot_alt"

/obj/item/clothing/suit/storage/jacket/marine/RO
	name = "quartermaster jacket"
	desc = "A green jacket worn by USCM personnel. The back has the flag of the United Americas on it."
	icon_state = "RO_jacket"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/suit/storage/jacket/marine/service/mp
	name = "military police service jacket"
	desc = "A marine service jacket adopted for use by Military Police personnel on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty MPs. This variant is also available to regular Marines, if they are willing to bear the shame."
	has_buttons = TRUE
	icon_state = "coat_mp"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	initial_icon_state = "coat_mp"

/obj/item/clothing/suit/storage/jacket/marine/service/warden
	name = "military warden service jacket"
	desc = "A marine service jacket adopted for use by Military Wardens on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty Wardens. The jacket of choice for looking all night at a set of monitors, while cigarette butts pile around you."
	has_buttons = TRUE
	icon_state = "coat_warden"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	initial_icon_state = "coat_warden"

/obj/item/clothing/suit/storage/jacket/marine/service/cmp
	name = "chief military police service jacket"
	desc = "A marine service jacket adopted for use by Military Police personnel on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty MPs. Very popular among those who want to inexplicably smell like donuts."
	has_buttons = TRUE
	icon_state = "coat_cmp"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	initial_icon_state = "coat_cmp"

/obj/item/clothing/suit/storage/jacket/marine/service/tanker
	name = "tanker jacket"
	desc = "A comfortable jacket provided to anyone expected to operate near or inside heavy machinery. Special material within the arms jams up any machinery it gets caught up in, protecting the wearer from injury."
	has_buttons = TRUE
	flags_atom = NO_GAMEMODE_SKIN
	icon_state = "jacket_tanker"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi'
	)
	initial_icon_state = "jacket_tanker"

/obj/item/clothing/suit/storage/jacket/marine/chef
	name = "mess technician jacket"
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy."
	icon_state = "chef_jacket"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi'
	)
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/suit/storage/jacket/marine/dress
	name = "marine formal service jacket"
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy."
	icon_state = "coat_formal"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	initial_icon_state = "coat_formal"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_GAMEMODE_SKIN
	has_buttons = TRUE

/obj/item/clothing/suit/storage/jacket/marine/dress/officer
	name = "marine officer dress jacket"
	desc = "Dress Jacket worn by Commanding Officers of the USCM."
	icon_state = "co_jacket"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber
	name = "commanding officer bomber jacket"
	desc = "A bomber jacket resembling those worn by airmen of old. A classic, stylish choice for those in the higher ranks."
	has_buttons = TRUE
	icon_state = "co_bomber"
	initial_icon_state = "co_bomber"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white
	name = "commanding officer white dress jacket"
	desc = "A white dress tunic for hot-weather parades. Bright, unstained, and immaculate with gold accents."
	icon_state = "co_formal_white"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/black
	name = "commanding officer gray dress jacket"
	desc = "A gray dress tunic for those occasions that mandate darker, more subdued colors. Combines sleek and subdued with gold accents."
	icon_state = "co_formal_black"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit
	name = "commanding officer dress blue coat"
	desc = "A Navy regulation dress blues coat for high-ranking officers. For those who wish for style and authority."
	icon_state = "co_suit"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/patchless
	name = "commanding officer's jacket"
	desc = "A patchless version of the officer jacket, its presence is still domineering"
	icon_state = "co_plain"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander

	name = "commanding officer's jacket"
	desc = "The thought of looking even at the rank pins scare you with a court martial"
	icon_state = "co_falcon"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/falcon
	name = "commanding officer falcon jacket"
	desc = "A refurbished jacket liner tailor made for a senior officer. This liner has become more of a proper piece of attire, with a new layer of fabric, wrist cuffs, front pockets, and a custom embroidered falcon on the back. This jacket will keep its wearer warm no matter the circumstance, from a cool Sunday drive to chilly autumn's eve."
	icon_state = "co_falcon"

/obj/item/clothing/suit/storage/jacket/marine/dress/general
	name = "USCM service 'A' officer service jacket"
	desc = "A USCM Officer Service 'A' Jacket, often worn by Officers on official visits. Very fitting and neatly pressed for a job that needs to be well-done."
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	icon_state = "general_jacket"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	item_state = "general_jacket"
	has_buttons = FALSE
	storage_slots = 4
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/jacket/marine/dress/general/executive
	name = "director's jacket"
	desc = "A black trench coat with gold metallic trim. Flashy, highly protective, and over-the-top. Fit for a king - or, in this case, a Director. Has quite a few pockets."
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat
	name = "bridge coat"
	desc = "A heavy synthetic woolen coat issued to USCM Officers. Based on a classical design this coat is quite nice on cold nights in the Air conditioned CIC or a miserable cold night on a barren world. This one is a Dressy Blue for a Commanding officer."
	has_buttons = FALSE
	item_state = "bridge_coat"
	icon_state = "bridge_coat"

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey
	name = "bridge coat"
	desc = "A heavy synthetic woolen coat issued to USCM Officers. Based on a classical design this coat is quite nice on cold nights in the Air conditioned CIC or a miserable cold night on a barren world. This one is Black."
	has_buttons = FALSE
	item_state = "bridge_coat_grey"
	icon_state = "bridge_coat_grey"

/obj/item/clothing/suit/storage/jacket/marine/service/aso
	name = "auxiliary support officer jacket"
	desc = "A comfortable vest for officers who are expected to work long hours staring at rows of numbers and inspecting equipment from knives to torpedos to entire dropships."
	icon_state = "aso_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST
	has_buttons = FALSE


//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/jacket/marine/provost
	name = "\improper USCM service 'A' officer winter service jacket"
	desc = "A rarely-seen 'A' service jacket for USCM officers that do want to stay crisp and warm in a snowy warzone, this one coming in black."
	icon_state = "provost_jacket"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/jacket/marine/dress/blues
	name = "marine enlisted dress blues jacket"
	desc = "The jacket of the legendary Marine dress blues, virtually unchanged since the 19th century. You're wearing history, Marine. Don't let your ancestors down."
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	icon_state = "e_jacket"
	item_state = "e_jacket"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco
	name = "marine NCO dress blues jacket"
	desc = "The jacket of the legendary Marine dress blues, virtually unchanged since the 19th century. Features the adornments of a decorated non-commissioned officer. Heritage, embodied."
	icon_state = "nco_jacket"
	item_state = "nco_jacket"

/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer
	name = "marine officer dress blues jacket"
	desc = "The jacket of the legendary Marine dress blues, virtually unchanged since the 19th century. Features the sleek dark design of the uniform worn by a commissioned officer."
	icon_state = "o_jacket"
	item_state = "o_jacket"

//==================Combat Correspondent==================\\

/obj/item/clothing/suit/storage/jacket/marine/reporter
	name = "combat correspondent jacket"
	desc = "A jacket for the most fashionable war correspondents."
	icon_state = "cc_brown"
	item_state = "cc_brown"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/reporter/green
	icon_state = "cc_green"
	item_state = "cc_green"


/obj/item/clothing/suit/storage/jacket/marine/reporter/black
	icon_state = "cc_black"
	item_state = "cc_black"

/obj/item/clothing/suit/storage/jacket/marine/reporter/blue
	icon_state = "cc_blue"
	item_state = "cc_blue"
	icon = 'icons/obj/items/clothing/suits/vests_aprons.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/vests_aprons.dmi'
	)


//==================Corporate Liaison==================\\

/obj/item/clothing/suit/storage/jacket/marine/vest
	name = "brown vest"
	desc = "A casual brown vest."
	icon_state = "vest_brown"
	item_state = "vest_brown"
	icon = 'icons/obj/items/clothing/suits/vests_aprons.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/vests_aprons.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/vest/tan
	name = "tan vest"
	desc = "A casual tan vest."
	icon_state = "vest_tan"
	item_state = "vest_tan"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/vest/grey
	name = "grey vest"
	desc = "A casual grey vest."
	icon_state = "vest_grey"
	item_state = "vest_grey"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate
	name = "khaki suit jacket"
	desc = "A khaki suit jacket."
	icon_state = "corporate_ivy"
	item_state = "corporate_ivy"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/formal
	name = "formal suit jacket"
	desc = "An ivory suit jacket; a Weyland-Yutani corporate badge is attached to the right lapel."
	icon_state = "corporate_formal"
	item_state = "corporate_formal"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/black
	name = "black suit jacket"
	desc = "A black suit jacket."
	icon_state = "corporate_black"
	item_state = "corporate_black"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/brown
	name = "brown suit jacket"
	desc = "A brown suit jacket."
	icon_state = "corporate_brown"
	item_state = "corporate_brown"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/blue
	name = "blue suit jacket"
	desc = "A blue suit jacket."
	icon_state = "corporate_blue"
	item_state = "corporate_blue"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber
	name = "khaki bomber jacket"
	desc = "A khaki bomber jacket popular among stationeers and blue-collar workers everywhere."
	icon_state = "jacket_khaki"
	item_state = "jacket_khaki"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi'
	)
	flags_atom = NO_GAMEMODE_SKIN
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber/red
	name = "red bomber jacket"
	desc = "A reddish-brown bomber jacket popular among stationeers and blue-collar workers everywhere."
	icon_state = "jacket_red"
	item_state = "jacket_red"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber/grey
	name = "grey bomber jacket"
	desc = "A blue-grey bomber jacket popular among stationeers and blue-collar workers everywhere."
	icon_state = "jacket_grey"
	item_state = "jacket_grey"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/rmc/service
	name = "\improper Royal Marine Commando service jacket"
	desc = "A service jacket typically worn by officers of the RMC. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "rmc_service"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/TWE.dmi'
	)
	has_buttons = FALSE
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/suit/storage/jacket/marine/rmc/service/co
	name = "\improper Royal Marine Commando senior officer's service jacket"
	desc = "A service jacket worn by the senior officers of the RMC. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "rmc_service_co"

/obj/item/clothing/suit/storage/jacket/marine/rmc/service/black
	name = "\improper Royal Marine Commando service jacket"
	desc = "A service jacket typically worn by officers of the RMC. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "rmc_service_black"

/obj/item/clothing/suit/storage/jacket/marine/rmc/service/co/black
	name = "\improper Royal Marine Commando senior officer's service jacket"
	desc = "A service jacket worn by the senior officers of the RMC. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "rmc_service_black_co"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber/rmc
	name = "commanding officer bomber jacket"
	desc = "A bomber jacket worn by RMC officers. A classic, stylish choice for those in the higher ranks."
	has_buttons = TRUE
	icon_state = "rmc_bomber"
	initial_icon_state = "rmc_bomber"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/TWE.dmi'
	)
