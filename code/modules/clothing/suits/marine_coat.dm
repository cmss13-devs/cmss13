/obj/item/clothing/suit/storage/jacket/marine //BASE ITEM
	name = "marine jacket"
	//This really should not be spawned
	desc = "What the hell is this doing here?"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
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
		/obj/item/weapon/melee/baton,
		/obj/item/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK)

	//Buttons
	var/has_buttons = FALSE
	var/buttoned = TRUE
	var/initial_icon_state

/obj/item/clothing/suit/storage/jacket/marine/proc/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
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
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
		initial_icon_state = icon_state
	if(has_buttons)
		verbs += /obj/item/clothing/suit/storage/jacket/marine/proc/toggle

//Marine service & tanker jacket + MP themed variants
/obj/item/clothing/suit/storage/jacket/marine/service
	name = "marine service jacket"
	desc = "A service jacket typically worn by officers of the USCM. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	has_buttons = TRUE
	icon_state = "coat_officer"

/obj/item/clothing/suit/storage/jacket/marine/pilot
	name = "\improper M70B1 light flak jacket"
	desc = "A light flak jacket used by dropship pilots to protect themselves while flying in the cockpit. This specific flak jacket has been designed for style and comfort over protection, and it shows. Don't get hit by any stray bullets!"
	icon_state = "pilot_alt"
	has_buttons = TRUE
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "pilot_alt"

/obj/item/clothing/suit/storage/jacket/marine/service/mp
	name = "military police service jacket"
	desc = "A marine service jacket adopted for use by Military Police personnel on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty MPs. This variant is also available to regular Marines, if they are willing to bear the shame."
	has_buttons = TRUE
	icon_state = "coat_mp"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_mp"

/obj/item/clothing/suit/storage/jacket/marine/service/warden
	name = "military warden service jacket"
	desc = "A marine service jacket adopted for use by Military Wardens on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty Wardens. The jacket of choice for looking all night at a set of monitors, while cigarette butts pile around you."
	has_buttons = TRUE
	icon_state = "coat_warden"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_warden"

/obj/item/clothing/suit/storage/jacket/marine/service/cmp
	name = "chief military police service jacket"
	desc = "A marine service jacket adopted for use by Military Police personnel on board USCM ships. Ironically most ships require their MP departments to use full armor, making these barely used by on duty MPs. Very popular among those who want to inexplicably smell like donuts."
	has_buttons = TRUE
	icon_state = "coat_cmp"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_cmp"

/obj/item/clothing/suit/storage/jacket/marine/service/tanker
	name = "tanker jacket"
	desc = "A comfortable jacket provided to anyone expected to operate near or inside heavy machinery. Special material within the arms jams up any machinery it gets caught up in, protecting the wearer from injury."
	has_buttons = TRUE
	flags_atom = NO_SNOW_TYPE
	icon_state = "jacket_tanker"
	initial_icon_state = "jacket_tanker"

/obj/item/clothing/suit/storage/jacket/marine/chef
	name = "mess technician jacket"
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy."
	icon_state = "chef_jacket"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/dress
	name = "marine dress jacket"
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy, but it still gives off that unga vibe."
	icon_state = "marine_formal"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/dress/officer
	name = "marine officer dress jacket"
	desc = "Dress Jacket worn by Commanding Officers of the USCM."
	icon_state = "co_jacket"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

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

/obj/item/clothing/suit/storage/jacket/marine/dress/general
	name = "general's jacket"
	desc = "A black trench coat with gold metallic trim. Flashy, highly protective, and over-the-top. Fit for a king - or, in this case, a General. Has quite a few pockets."
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "general_jacket"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_0.dmi'
	)
	item_state = "general_jacket"
	storage_slots = 4
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/jacket/marine/dress/general/executive
	name = "director's jacket"
	desc = "A black trench coat with gold metallic trim. Flashy, highly protective, and over-the-top. Fit for a king - or, in this case, a Director. Has quite a few pockets."

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat
	name = "bridge coat"
	desc = "A heavy synthetic woolen coat issued to USCM Officers. Based on a classical design this coat is quite nice on cold nights in the Air conditioned CIC or a miserable cold night on a barren world. This one is a Dressy Blue for a Commanding officer."
	item_state = "bridge_coat"
	icon_state = "bridge_coat"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey
	name = "bridge coat"
	desc = "A heavy synthetic woolen coat issued to USCM Officers. Based on a classical design this coat is quite nice on cold nights in the Air conditioned CIC or a miserable cold night on a barren world. This one is Black."
	item_state = "bridge_coat_grey"
	icon_state = "bridge_coat_grey"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_MEDAL)



//=========================//PROVOST\\================================\\
//=======================================================================\\
/obj/item/clothing/suit/storage/jacket/marine/provost
	name = "\improper Provost Coat"
	desc = "The crisp coat of a Provost Officer."
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	icon_state = "provost_coat"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR)

/obj/item/clothing/suit/storage/jacket/marine/provost/advisor
	name = "\improper Provost Advisor Jacket"
	desc = "The crisp jacket of a Provost Advisor."
	icon_state = "provost_jacket"

/obj/item/clothing/suit/storage/jacket/marine/provost/inspector
	name = "\improper Provost Inspector Jacket"
	desc = "The crisp jacket of a Provost Inspector."
	icon_state = "provost_jacket"

/obj/item/clothing/suit/storage/jacket/marine/provost/marshal
	name = "\improper Provost Marshal Jacket"
	desc = "The crisp jacket of a Provost Marshal."
	icon_state = "provost_jacket"

/obj/item/clothing/suit/storage/jacket/marine/provost/marshal/chief
	name = "\improper Provost Chief Marshal Jacket"
	desc = "The crisp jacket of the Provost Chief Marshal."

//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/jacket/marine/dress/blues
	name = "marine enlisted dress blues jacket"
	desc = "The jacket of the legendary Marine dress blues, virtually unchanged since the 19th century. You're wearing history, Marine. Don't let your ancestors down."
	icon = 'icons/mob/humans/onmob/contained/marinedressblues.dmi'
	icon_state = "e_jacket"
	item_state = "e_jacket"
	item_state_slots = null
	contained_sprite = TRUE

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

//==================War Correspondent==================\\

/obj/item/clothing/suit/storage/jacket/marine/reporter
	name = "combat correspondent jacket"
	desc = "A jacket for the most fashionable war correspondents."
	icon = 'icons/mob/humans/onmob/contained/war_correspondent.dmi'
	icon_state = "wc_suit"
	item_state = "wc_suit"
	contained_sprite = TRUE
