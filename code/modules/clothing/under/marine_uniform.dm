//=========================//MARINES\\===================================//
//=======================================================================//


/obj/item/clothing/under/marine
	name = "\improper USCM uniform"
	desc = "Standard-issue Marine uniform. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/jungle.dmi'
	worn_state = "marine_jumpsuit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	drop_sound = "armorequip"
	siemens_coefficient = 0.9
	///Makes it so that we can see the right name in the vendor.
	var/specialty = "USCM"
	var/snow_name = " snow uniform"
	layer = UPPER_ITEM_LAYER
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/jungle.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)

	//speciality does NOTHING if you have NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT), override_icon_state[] = null)
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += snow_name
		else
			name += " uniform"
	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin(type, override_icon_state, new_protection)
	return ..() //Done after above in case gamemode skin is missing sprites.

/obj/item/clothing/under/marine/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	if(flags_atom & MAP_COLOR_INDEX)
		return
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/jungle.dmi'
			item_icons[WEAR_BODY] = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/classic.dmi'
			item_icons[WEAR_BODY] = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/desert.dmi'
			item_icons[WEAR_BODY] = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/snow.dmi'
			item_icons[WEAR_BODY] = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/snow.dmi'
			flags_jumpsuit |= UNIFORM_DO_NOT_HIDE_ACCESSORIES
		if("urban")
			icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/urban.dmi'
			item_icons[WEAR_BODY] = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/urban.dmi'

/obj/item/clothing/under/marine/set_sensors(mob/user)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("The sensors in \the [src] can't be modified."))
		return
	. = ..()

/obj/item/clothing/under/marine/medic
	name = "\improper USCM corpsman uniform"
	desc = "Standard-issue Marine hospital corpsman fatigues. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_medic"
	worn_state = "marine_medic"
	specialty = "USCM Hospital Corpsman"

/obj/item/clothing/under/marine/engineer
	name = "\improper USCM ComTech uniform"
	desc = "Standard-issue Marine combat technician fatigues. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_engineer"
	worn_state = "marine_engineer"
	specialty = "USCM Combat Technician"

/obj/item/clothing/under/marine/engineer/standard
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/engineer/darker
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/desert.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/desert.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_righthand.dmi'
	)

/obj/item/clothing/under/marine/rto
	name = "\improper USCM radio telephone operator uniform"
	desc = "Standard-issue RTO fatigues. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_rto"
	item_state = "marine_rto"
	specialty = "marine Radio Telephone Operator"

/obj/item/clothing/under/marine/tanker
	name = "\improper USCM tanker uniform"
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	flags_jumpsuit = FALSE
	specialty = "USCM tanker"

/obj/item/clothing/under/marine/tanker/New(loc,
	new_protection = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))

	..(loc, new_protection)

/obj/item/clothing/under/marine/chef
	name = "\improper USCM Mess Technician uniform"
	desc = "Standard-issue Mess Technician uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "chef_uniform"
	worn_state = "chef_uniform"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	flags_jumpsuit = FALSE
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
	)

/obj/item/clothing/under/marine/mp
	name = "military police jumpsuit"
	desc = "Standard-issue Military Police uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "MP_jumpsuit"
	worn_state = "MP_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_SLEEVE_CUTTABLE|UNIFORM_JACKET_REMOVABLE
	specialty = "military police"

/obj/item/clothing/under/marine/mp/standard
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/mp/darker
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/desert.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/desert.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_righthand.dmi'
	)

/obj/item/clothing/under/marine/warden
	name = "military warden jumpsuit"
	desc = "Standard-issue Military Warden uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/warden)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_SLEEVE_CUTTABLE|UNIFORM_JACKET_REMOVABLE
	specialty = "military warden"

/obj/item/clothing/under/marine/officer
	name = "marine officer uniform"
	desc = "Softer than silk. Lighter than feather. More protective than Kevlar. Fancier than a regular jumpsuit, too. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = ""
	item_state = ""
	worn_state = ""
	suit_restricted = null //so most officers can wear whatever suit they want
	flags_jumpsuit = FALSE
	specialty = "marine officer"
	black_market_value = 25
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

/obj/item/clothing/under/marine/officer/intel
	name = "\improper marine intelligence officer sweatsuit"
	desc = "Tighter than a vice. Slicker than beard oil. Covered from head to toe in pouches, pockets, bags, straps, and belts. Clearly, you are not only the most intelligent of intelligence officers, but the most fashionable as well. This suit took an entire R&D team five days to develop. It is more expensive than the entire Almayer... probably."
	icon_state = "io"
	item_state = "io"
	worn_state = "io"
	specialty = "marine intelligence officer"

/obj/item/clothing/under/marine/officer/warrant
	name = "\improper chief MP uniform"
	desc = "A uniform typically worn by a Chief MP of the USCM. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions. This uniform includes a small EMF distributor to help nullify energy-based weapon fire, along with a hazmat chemical filter woven throughout the material to ward off biological and radiation hazards."
	icon_state = "WO_jumpsuit"
	item_state = "WO_jumpsuit"
	worn_state = "WO_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/cmp)
	flags_jumpsuit = FALSE
	specialty = "chief MP"

/obj/item/clothing/under/marine/officer/pilot
	name = "pilot officer bodysuit"
	desc = "A bodysuit worn by pilot officers of the USCM, and is meant for survival in inhospitable conditions. Fly the marines onwards to glory. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "pilot_flightsuit"
	item_state = "pilot_flightsuit"
	worn_state = "pilot_flightsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	specialty = "pilot officer"
	snow_name = " snow bodysuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/jacket/marine/pilot/armor, /obj/item/clothing/suit/storage/marine/light/vest/dcc, /obj/item/clothing/suit/storage/jacket/marine/pilot, /obj/item/clothing/suit/storage/marine/light/vest)
	flags_atom = FPRINT

/obj/item/clothing/under/marine/officer/pilot/flight
	name = "tactical pilot officer flightsuit"
	desc = "A flightsuit worn by pilot officers of the USCM, with plenty of leather straps, pouches, and other essential gear you will never use. Looks badass."
	icon_state = "pilot_flightsuit_alt"
	worn_state = "pilot_flightsuit_alt"
	item_state = "pilot_flightsuit_alt"
	flags_jumpsuit = UNIFORM_JACKET_REMOVABLE
	flags_atom = NO_NAME_OVERRIDE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/marine/officer/pilot/dcc
	name = "dropship crew chief bodysuit"
	desc = "A bodysuit worn by dropship crew chiefs of the USCM, and is meant for survival in inhospitable conditions. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "crewchief_flightsuit"
	worn_state = "crewchief_flightsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)

/obj/item/clothing/under/marine/officer/tanker
	name = "vehicle crewman uniform"
	desc = "A uniform worn by vehicle crewmen of the USCM. Do the corps proud. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/tanker, /obj/item/clothing/suit/storage/jacket/marine/service/tanker)
	specialty = "vehicle crewman"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	item_state_slots = list(WEAR_BODY = "marine_tanker")

/obj/item/clothing/under/marine/officer/bridge
	name = "marine service uniform"
	desc = "A service uniform worn by members of the USCM. Do the corps proud. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/boiler
	name = "marine operations uniform"
	desc = "An operations uniform worn by members of the USCM. Do the corps proud. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "uscmboiler"
	worn_state = "uscmboiler"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE
	specialty = "marine operations"
	flags_atom = FPRINT

/obj/item/clothing/under/marine/officer/command
	name = "\improper USCM officer uniform"
	desc = "The well-ironed utility uniform of a USCM officer. Even looking at it the wrong way could result in being court-martialed. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "CO_jumpsuit"
	worn_state = "CO_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi'
	)
	specialty = "USCM officer"
	flags_atom = FPRINT && NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/general
	name = "USCM Service 'C' Officer Uniform"
	desc = "A standard-issue USCM Officer 'C' service uniform, comes with a short sleeve buttoned-up tan shirt and green trousers."
	icon_state = "general_jumpsuit"
	worn_state = "general_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/ce
	name = "chief engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	icon_state = "EC_jumpsuit"
	worn_state = "EC_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/engineering.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/engineering.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	item_state_slots = list(WEAR_BODY = "EC_jumpsuit")

/obj/item/clothing/under/marine/officer/engi
	name = "engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "mt_jumpsuit"
	worn_state = "mt_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/engineering.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/engineering.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	specialty = "engineer"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_GAMEMODE_SKIN
	item_state_slots = list(WEAR_BODY = "mt_jumpsuit")

/obj/item/clothing/under/marine/officer/engi/OT
	name = "ordnance engineer uniform"
	desc = "A uniform for a professional bomb maker. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions. Padded with extra plates to take the brunt force of an explosion."
	armor_bomb = CLOTHING_ARMOR_LOW
	icon_state = "ot_jumpsuit"
	worn_state = "ot_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/engineering.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/engineering.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	item_state_slots = list(WEAR_BODY = "ot_jumpsuit")

/obj/item/clothing/under/marine/officer/researcher
	name = "researcher clothes"
	desc = "A simple set of civilian clothes worn by researchers."
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "research_jumpsuit"
	worn_state = "research_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/research.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/research.dmi',
	)
	specialty = "researcher"
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/formal
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/formal/servicedress
	name = "commanding officer's dress shirt"
	desc = "The shirt and tie of a two-piece Navy service dress uniform for high-ranking officers. Wear with style and substance."
	specialty = "captain's service dress"
	icon_state = "CO_service"
	worn_state = "CO_service"
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/formal/gray
	name = "Commanding Officer's gray formal uniform"
	desc = "A well-ironed USCM officer uniform  intended for parades or hot weather. Wear this with pride."
	icon_state = "co_gray"
	worn_state = "co_gray"
	specialty = "captain's gray formal"
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/officer/formal/turtleneck
	name = "Commanding Officer's turtleneck uniform"
	desc = "A well-ironed USCM officer uniform intended for more formal or somber events. Wear this with pride."
	icon_state = "co_turtleneck"
	worn_state = "co_turtleneck"
	specialty = "captain's turtleneck"
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/dress
	name = "marine formal service uniform"
	desc = "A formal service uniform typically worn by marines of the USCM. Still practicable while still being more formal than the standard service uniform."
	icon_state = "formal_jumpsuit"
	worn_state = "formal_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	flags_jumpsuit = FALSE
	black_market_value = 15

/obj/item/clothing/under/marine/dress/command
	name = "marine officer formal service uniform"
	desc = "A formal service uniform typically worn by marines of the USCM. Still practicable while still being more formal than the standard service uniform. This one belongs to an officer."
	icon_state = "formal_jumpsuit"
	worn_state = "formal_jumpsuit"
	specialty = "command formal"
	black_market_value = 20

//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/dress/blues
	name = "marine enlisted dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This unadorned variant is for enlisted personnel, E-1 thru E-3."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "enlisted"
	worn_state = "enlisted"

/obj/item/clothing/under/marine/dress/blues/senior
	name = "marine senior dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This variant features the iconic Blood Stripe, worn by NCOs and officers."
	icon_state = "senior"
	worn_state = "senior"

/obj/item/clothing/under/marine/dress/blues/general
	name = "marine senior dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This variant features black trousers and a large Blood Stripe, worn by general officers."
	icon_state = "general"
	worn_state = "general"

//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/mp/provost
	flags_jumpsuit = FALSE
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

	name = "\improper USCM military police utility uniform"
	desc = "The standard-issue uniform of most Military Police on USCM military stations and bases. Officers wearing this uniform are usually part of the USCM provost office."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "provost"
	worn_state = "provost"

	specialty = "provost"

	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/MP,
		/obj/item/clothing/suit/armor/riot/marine,
		/obj/item/clothing/suit/storage/jacket/marine/provost,
	)

	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/marine/mp/provost/chief
	name = "\improper service 'A' officer winter uniform"
	desc = "The winter version of the Service A uniform, often worn by officers of the provost office."
	icon_state = "provost_ci"
	worn_state = "provost_ci"


//=========================//USCM Survivors\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/reconnaissance
	name = "\improper USCM uniform"
	desc = "Torn, Burned and blood stained. This uniform has seen much more than you could possibly imagine."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "recon_marine"
	worn_state = "recon_marine"
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/reconnaissance/Initialize(mapload)
	. = ..()
	var/R = rand(1,4)
	switch(R) //this is no longer shitcode, courtesy of stan_albatross
		if(1)
			roll_suit_sleeves(FALSE)
		if(2)
			roll_suit_jacket(FALSE)
		if(3)
			cut_suit_jacket(FALSE)


//=========================//RESPONDERS\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/veteran
	flags_jumpsuit = FALSE
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make them keep their original name.

//=========================//Marine Raiders\\================================\\

/obj/item/clothing/under/marine/veteran/marsoc
	name = "SOF Uniform"
	desc = "A black uniform for elite Marine personnel. Designed to be comfortable and help blend into dark enviorments."
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "marsoc"
	worn_state = "marsoc"
	specialty = "sof uniform"
	flags_item = NO_GAMEMODE_SKIN

//=========================//PMC\\================================\\

/obj/item/clothing/under/marine/veteran/pmc
	name = "\improper PMC fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weyland-Yutani corporation is emblazed on the suit."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/WY.dmi',
	)
	icon_state = "pmc_jumpsuit"
	worn_state = "pmc_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/veteran/pmc,
		/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc,
		/obj/item/clothing/suit/armor/vest/security,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/jacket/marine,
		/obj/item/clothing/suit/storage/CMB/trenchcoat,
		/obj/item/clothing/suit/storage/windbreaker,
		/obj/item/clothing/suit/storage/snow_suit,
	) //if you remove this, it allows you to wear the marine M3 armor over the pmc fatigues

/obj/item/clothing/under/marine/veteran/pmc/leader
	name = "\improper PMC command fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weyland-Yutani corporation is emblazed on the suit. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_jumpsuit"
	worn_state = "officer_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/leader/commando
	name = "\improper W-Y Commando fatigues"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/leader/commando/leader
	name = "\improper W-Y Commando leader fatigues"
	icon_state = "commando_leader"
	worn_state = "commando_leader"
	flags_jumpsuit = null

/obj/item/clothing/under/marine/veteran/pmc/engineer
	name = "\improper PMC engineer fatigues"
	desc = "A black and orange set of fatigues, designed for private security technicians. The symbol of the Weyland-Yutani corporation is emblazed on the suit."
	icon_state = "engineer_jumpsuit"
	worn_state = "engineer_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/guard
	name = "\improper PMC guard fatigues"
	desc = "A black and orange set of fatigues, designed for private security enforcer personnel. The symbol of the Weyland-Yutani corporation is emblazed on the suit."
	icon_state = "guard_jumpsuit"
	worn_state = "guard_jumpsuit"

/obj/item/clothing/under/marine/veteran/pmc/apesuit
	name = "\improper W-Y commando Apesuit uniform"
	desc = "An armored uniform worn by Weyland-Yutani elite commandos. It is well protected while remaining light and comfortable."
	icon_state = "ape_jumpsuit"
	worn_state = "ape_jumpsuit"

/obj/item/clothing/under/marine/veteran/pmc/combat_android
	name = "\improper W-Y android combat uniform"
	desc = "An armored uniform worn by Weyland-Yutani combat androids. It is well protected while remaining light and comfortable."
	icon_state = "combat_android_uniform"
	worn_state = "combat_android_uniform"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/veteran/pmc/combat_android/dark
	desc = "An armored uniform compatible with optical camouflage, worn by Weyland-Yutani combat androids. It is well protected while remaining light and comfortable."
	icon_state = "invis_android_uniform"
	worn_state = "invis_android_uniform"

/obj/item/clothing/under/marine/veteran/pmc/corporate
	name = "\improper W-Y corporate security uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by what are known as 'goons'."
	icon_state = "sec_uniform"
	worn_state = "sec_uniform"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/corporate/medic //TODO: make this an armband accessory instead of a jumpsuit
	name = "\improper W-Y corporate security medic uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant has a red armband denoting the wearer's medical purpose."
	icon_state = "med_uniform"
	item_state = "med_uniform"
	worn_state = "med_uniform"

/obj/item/clothing/under/marine/veteran/pmc/corporate/engineer //TODO: make this an armband accessory instead of a jumpsuit
	name = "\improper W-Y corporate security engineer uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant has a yellow armband denoting the wearer's technical purpose."
	icon_state = "eng_uniform"
	item_state = "eng_uniform"
	worn_state = "eng_uniform"

/obj/item/clothing/under/marine/veteran/pmc/corporate/lead
	name = "\improper W-Y corporate security leader uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by the lead of the 'goonsquad', as they are colloquially known."
	icon_state = "sec_lead_uniform"
	item_state = "sec_lead_uniform"
	worn_state = "sec_lead_uniform"

/obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is more breathable for use in hot, dry environments."
	icon_state = "sec_kutjevo_uniform"
	item_state = "sec_kutjevo_uniform"
	worn_state = "sec_kutjevo_uniform"

/obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo/lead
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is more breathable for use in hot, dry environments and has gold armbands denoting the team leader."
	icon_state = "sec_lead_kutjevo_uniform"
	item_state = "sec_lead_kutjevo_uniform"
	worn_state = "sec_lead_kutjevo_uniform"

//=========================//UPP\\================================\\

/obj/item/clothing/under/marine/veteran/bear
	name = "\improper Iron Bear uniform"
	desc = "A uniform worn by Iron Bears mercenaries in the service of Mother Russia. Smells a little like an actual bear."
	icon_state = "bear_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/misc_ert_colony.dmi'
	worn_state = "bear_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/bear)

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
	)

/obj/item/clothing/under/marine/veteran/UPP
	name = "\improper UPP fatigues"
	desc = "A set of UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform"
	worn_state = "upp_uniform"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UPP.dmi'
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_HAS_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/UPP, /obj/item/clothing/suit/gimmick/jason, /obj/item/clothing/suit/storage/snow_suit/soviet, /obj/item/clothing/suit/storage/snow_suit/survivor, /obj/item/clothing/suit/storage/webbing)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UPP.dmi'
	)

/obj/item/clothing/under/marine/veteran/UPP/medic
	name = "\improper UPP medic fatigues"
	desc = "A set of medic UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform_medic"
	worn_state = "upp_uniform_medic"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/UPP/engi
	name = "\improper UPP engineer fatigues"
	desc = "A set of Engineer UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform_engi"
	worn_state = "upp_uniform_engi"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/UPP/mp
	name = "\improper UPP Military Police fatigues"
	desc = "A set of Military Police UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform_mp"
	worn_state = "upp_uniform_mp"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/UPP/officer
	name = "\improper UPP Officer fatigues"
	desc = "A set of Officer UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform_officer"
	worn_state = "upp_uniform_officer"

/obj/item/clothing/under/marine/veteran/UPP/civi1
	name = "\improper UPP Civilian-style Orange overalls"
	desc = "A set of Civilian-style Orange Overalls with a dark tan undershirt. The material is of a poor quality, however it's better than nothing. Clothing of this style is typically given out to those who work laborious jobs."
	icon_state = "upp_uniform_civi1"
	worn_state = "upp_uniform_civi1"

/obj/item/clothing/under/marine/veteran/UPP/civi2
	name = "\improper UPP Civilian-style tan overalls"
	desc = "A set of Civilian-style Tan Overalls with a Blue undershirt. The material is of a poor quality, however it's better than nothing. Clothing of this style is typically given to those who work laborious jobs."
	icon_state = "upp_uniform_civi2"
	worn_state = "upp_uniform_civi2"

/obj/item/clothing/under/marine/veteran/UPP/civi3
	name = "\improper UPP Civilian-style shirt and pants"
	desc = "A set of Civilian-style tan shirt and jeans. The material, while poor, is comfortable enough to be worn during all periods of the day."
	icon_state = "upp_uniform_civi3"
	worn_state = "upp_uniform_civi3"

/obj/item/clothing/under/marine/veteran/UPP/civi4
	name = "\improper UPP Civilian-style Vest and pants"
	desc = "A set of Civilian-style Brown vest and orange pants. The material is surprisingly decent, something not often worn by the civilians of the UPP for two reasons: They typically can't afford such clothing, and if they can, it paints a target on their back."
	icon_state = "upp_uniform_civi4"
	worn_state = "upp_uniform_civi4"

//=========================//CMB\\================================\\


/obj/item/clothing/under/marine/veteran/cmb
	name = "\improper CMB Riot Control uniform"
	desc = "A dark set of tactical uniform utilized by the Colonial Marshals, designed to be used by units of riot supression on the distant worlds, under colonial jurisdiction."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/CMB.dmi',
	)
	icon_state = "cmb_swat_uniform"
	worn_state = "cmb_swat_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_HAS_SENSORS
	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/veteran/cmb,
		/obj/item/clothing/suit/storage/marine/MP,
		/obj/item/clothing/suit/storage/CMB,
		/obj/item/clothing/suit/armor/riot/marine,
		/obj/item/clothing/suit/armor/vest/security,
		/obj/item/clothing/suit/storage/hazardvest,
	)

/obj/item/clothing/under/marine/veteran/cmb/marshal
	name = "\improper CMB Riot Control Marshal uniform"
	desc = "A dark set of tactical uniform utilized by the Colonial Marshals, the gold insignia on this one suggests it being used by a commanding personnel during riot control."
	icon_state = "cmb_swatleader_uniform"
	worn_state = "cmb_swatleader_uniform"


//=========================//Freelancer\\================================\\

/obj/item/clothing/under/marine/veteran/freelancer
	name = "\improper freelancer fatigues"
	desc = "A set of loose-fitting fatigues, perfect for an informal mercenary. Smells like gunpowder, apple pie, and covered in grease and sake stains."
	icon_state = "freelancer_uniform"
	worn_state = "freelancer_uniform"
	icon = 'icons/obj/items/clothing/uniforms/misc_ert_colony.dmi'
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/freelancer, /obj/item/clothing/suit/storage/webbing, /obj/item/clothing/suit/storage/utility_vest)
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
	)


//=========================//Dutch Dozen\\================================\\

/obj/item/clothing/under/marine/veteran/dutch
	name = "\improper Dutch's Dozen uniform"
	desc = "A comfortable uniform worn by the Dutch's Dozen mercenaries. It's seen some definite wear and tear, but is still in good condition."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon = 'icons/obj/items/clothing/uniforms/misc_ert_colony.dmi'
	icon_state = "dutch_jumpsuit"
	worn_state = "dutch_jumpsuit"
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/dutch, /obj/item/clothing/suit/armor/vest/dutch)
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
	)

/obj/item/clothing/under/marine/veteran/dutch/ranger
	icon_state = "dutch_jumpsuit2"

/obj/item/clothing/under/marine/veteran/van_bandolier
	name = "hunting clothes"
	desc = "A set of tailored clothes, made from fine but sturdy reinforced fabrics. Protects from thorns, weather, and the cuts and scrapes that forever bedevil outdoorsmen."
	icon = 'icons/obj/items/clothing/uniforms/misc_ert_colony.dmi'
	icon_state = "van_bandolier"
	worn_state = "van_bandolier"
	item_state = "van_bandolier_clothes"
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)

//=========================//OWLF\\================================\\

/obj/item/clothing/under/marine/veteran/owlf
	name = "\improper OWLF thermal field uniform"
	desc = "A high-tech uniform with built-in thermal cloaking technology. It looks like it's worth more than your life."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS //This is all a copy and paste of the Dutch's stuff for now.
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon = 'icons/obj/items/clothing/uniforms/misc_ert_colony.dmi'
	icon_state = "owlf_uniform"
	worn_state = "owlf_uniform"
	has_sensor = UNIFORM_NO_SENSORS
	hood_state = /obj/item/clothing/head/owlf_hood
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
	)

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/under/marine/veteran/mercenary
	name = "\improper Mercenary fatigues"
	desc = "A thick, beige suit with a red armband. There is an unknown symbol is emblazed on the suit."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/CLF.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/CLF.dmi',
	)
	icon_state = "mercenary_heavy_uniform"
	worn_state = "mercenary_heavy_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/mercenary)

/obj/item/clothing/under/marine/veteran/mercenary/miner
	name = "\improper Mercenary miner fatigues"
	desc = "A beige suit with a red armband. It looks a little thin, like it wasn't designed for protection. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_miner_uniform"
	worn_state = "mercenary_miner_uniform"

/obj/item/clothing/under/marine/veteran/mercenary/support
	name = "\improper Mercenary engineer fatigues"
	desc = "A blue suit with yellow accents, used by engineers. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_engineer_uniform"
	worn_state = "mercenary_engineer_uniform"


////// Civilians /////////

/obj/item/clothing/under/marine/ua_riot
	name = "\improper United American security uniform"
	desc = "Overalls made of kevlon cover a snazzy blue dress shirt. UA branded security uniforms are notorious for their association with anti-union riot control teams."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "ua_riot"
	worn_state = "ua_riot"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make them keep their original name.
	flags_jumpsuit = FALSE
	suit_restricted = null

/obj/item/clothing/under/pizza
	name = "pizza delivery uniform"
	desc = "An ill-fitting, slightly stained uniform for a pizza delivery pilot. Smells of cheese."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/security.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/security.dmi',
	)
	icon_state = "redshirt2"
	worn_state = "redshirt2"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/souto
	name = "\improper Souto Man's cargo pants"
	desc = "The white cargo pants worn by the one and only Souto man. As cool as an ice cold can of Souto Grape!"
	icon_state = "souto_man"
	worn_state = "souto_man"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/colonist
	name = "colonist jumpsuit"
	desc = "A stylish gray-green jumpsuit. Standard issue for unspecialized Wey-Yu colonists."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/WY.dmi',
	)
	icon_state = "colonist"
	worn_state = "colonist"
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/colonist/administrator
	name = "administrator uniform"
	desc = "An office grey polo with a Wey-Yu badge on the chest. Worn by administrators on colonies owned by the Company."
	icon_state = "colony_admin"
	worn_state = "colony_admin"

/obj/item/clothing/under/colonist/workwear
	name = "grey workwear"
	desc = "A pair of black slacks and a short-sleeve grey workshirt. Standard uniform for Weyland Yutani employees working in colony operations and administration."
	icon = 'icons/obj/items/clothing/uniforms/workwear.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/workwear.dmi',
	)
	icon_state = "workwear_grey"
	worn_state = "workwear_grey"

/obj/item/clothing/under/colonist/workwear/khaki
	name = "khaki workwear"
	desc = "A pair of jeans paired with a khaki workshirt. A common pairing among blue-collar workers due to its drab look."
	icon_state = "workwear_khaki"
	worn_state = "workwear_khaki"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/pink
	name = "pink workwear"
	desc = "A pair of jeans paired with a pink workshirt. Pink? Your wife might not think so, but such outlandish attire deserves questioning by corporate security. What are you, some kind of free-thinking anarchist?"
	icon_state = "workwear_pink"
	worn_state = "workwear_pink"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/blue
	name = "blue workwear"
	desc = "A pair of brown canvas workpants paired with a dark blue workshirt. A common pairing among blue-collar workers."
	icon_state = "workwear_blue"
	worn_state = "workwear_blue"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/green
	name = "green workwear"
	desc = "A pair of brown canvas workpants paired with a green workshirt. An common pairing among blue-collar workers."
	icon_state = "workwear_green"
	worn_state = "workwear_green"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/clf
	name = "\improper Colonial Liberation Front uniform"
	desc = "A stylish grey-green jumpsuit - standard issue for colonists. This version appears to have the symbol of the Colonial Liberation Front emblazoned in select areas."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/CLF.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/CLF.dmi',
	)
	icon_state = "clf_uniform"
	worn_state = "clf_uniform"

/obj/item/clothing/under/colonist/white_service
	name = "white service uniform"
	desc = "A white dress shirt and tie with sleek pants. Standard clothing for anyone on professional business."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "CO_service"
	worn_state = "CO_service"
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/colonist/steward
	name = "steward utilities"
	desc = "A stylish brown vest and shorts - uniforms like this are often worn by clerks and shop stewards."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "steward"
	worn_state = "steward"
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/tshirt
	name = "T-shirt parent object"
	icon = 'icons/obj/items/clothing/uniforms/workwear.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/workwear.dmi',
	)
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/tshirt/w_br
	name = "white T-shirt and brown pants"
	desc = "A comfortable white T-shirt and brown jeans."
	icon_state = "tshirt_w_br"
	worn_state = "tshirt_w_br"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/tshirt/gray_blu
	name = "gray T-shirt and jeans"
	desc = "A comfortable gray T-shirt and blue jeans."
	icon_state = "tshirt_gray_blu"
	worn_state = "tshirt_gray_blu"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/tshirt/r_bla
	name = "red T-shirt and black pants"
	desc = "A comfortable red T-shirt and black jeans."
	icon_state = "tshirt_r_bla"
	worn_state = "tshirt_r_bla"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/CM_uniform
	name = "\improper Colonial Marshal uniform"
	desc = "A pair of off-white slacks and a blue button-down shirt with a dark brown tie; the standard uniform of the Colonial Marshals."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/CMB.dmi',
	)
	icon_state = "marshal"
	worn_state = "marshal"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/liaison_suit
	name = "liaison's tan suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/WY.dmi',
	)
	icon_state = "liaison_regular"
	worn_state = "liaison_regular"

/obj/item/clothing/under/liaison_suit/charcoal
	name = "liaison's charcoal suit"
	desc = "A stiff, stylish charcoal suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon_state = "liaison_charcoal"
	worn_state = "liaison_charcoal"

/obj/item/clothing/under/liaison_suit/outing
	name = "liaison's outfit"
	desc = "A casual outfit consisting of a collared shirt and a vest. Looks like something you might wear on the weekends, or on a visit to a derelict colony."
	icon_state = "liaison_outing"
	worn_state = "liaison_outing"

/obj/item/clothing/under/liaison_suit/outing/red
	icon_state = "liaison_outing_red"
	worn_state = "liaison_outing_red"

/obj/item/clothing/under/liaison_suit/formal
	name = "liaison's white suit"
	desc = "A formal, white suit. Looks like something you'd wear to a funeral, a Weyland-Yutani corporate dinner, or both. Stiff as a board, but makes you feel like rolling out of a Rolls-Royce."
	icon_state = "liaison_formal"
	worn_state = "liaison_formal"

/obj/item/clothing/under/liaison_suit/suspenders
	name = "liaison's suspenders"
	desc = "A collared shirt, complimented by a pair of suspenders. Worn by Weyland-Yutani employees who ask the tough questions. Smells faintly of cigars and bad acting."
	icon_state = "liaison_suspenders"
	worn_state = "liaison_suspenders"

/obj/item/clothing/under/liaison_suit/blazer
	name = "liaison's blue blazer"
	desc = "A stiff but casual blue blazer. Similar can be found in any Weyland-Yutani office. Only the finest wear for the galaxy's most cunning."
	icon_state = "liaison_blue_blazer"
	worn_state = "liaison_blue_blazer"

/obj/item/clothing/under/liaison_suit/field
	name = "corporate casual"
	desc = "A pair of dark brown slacks paired with a dark blue button-down shirt. A popular look among those in the corporate world that conduct the majority of their business from night clubs."
	icon_state = "corporate_field"
	worn_state = "corporate_field"

/obj/item/clothing/under/liaison_suit/ivy
	name = "country club outfit"
	desc = "A pair of khaki slacks paired with a light blue button-down shirt. A popular look with those in the corporate world that conduct the majority of their business from country clubs."
	icon_state = "corporate_ivy"
	worn_state = "corporate_ivy"

/obj/item/clothing/under/liaison_suit/orange
	name = "orange outfit"
	desc = "A pair of black pants paired with a very Wey-Yu orange shirt. A popular look with those in the corporate world that conduct the majority of their business from Weyland Yutani offices."
	icon_state = "corporate_orange"
	worn_state = "corporate_orange"

/obj/item/clothing/under/liaison_suit/corporate_formal
	name = "white suit pants"
	desc = "A pair of ivory slacks paired with a white shirt. A popular pairing for formal corporate events."
	icon_state = "corporate_formal"
	worn_state = "corporate_formal"

/obj/item/clothing/under/liaison_suit/black
	name = "black suit pants"
	desc = "A pair of black slacks paired with a white shirt. The most common pairing among corporate workers."
	icon_state = "corporate_black"
	worn_state = "corporate_black"

/obj/item/clothing/under/liaison_suit/brown
	name = "brown suit pants"
	desc = "A pair of brown slacks paired with a white shirt. A common pairing among corporate workers."
	icon_state = "corporate_brown"
	worn_state = "corporate_brown"

/obj/item/clothing/under/liaison_suit/blue
	name = "blue suit pants"
	desc = "A pair of blue slacks paired with a white shirt. A common pairing among corporate workers."
	icon_state = "corporate_blue"
	worn_state = "corporate_blue"

/obj/item/clothing/under/marine/reporter
	name = "combat correspondent uniform"
	desc = "A relaxed and robust uniform fit for any potential reporting needs."
	icon_state = "cc_white"
	worn_state = "cc_white"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)

/obj/item/clothing/under/marine/reporter/black
	icon_state = "cc_black"
	worn_state = "cc_black"

/obj/item/clothing/under/marine/reporter/orange
	icon_state = "cc_orange"
	worn_state = "cc_orange"

/obj/item/clothing/under/marine/reporter/red
	icon_state = "cc_red"
	worn_state = "cc_red"

/obj/item/clothing/under/twe_suit
	name = "representative's fine suit"
	desc = "A stiff, stylish blue suit commonly worn by gentlemen from the Three World Empire. Expertly crafted to make you look as important as possible."
	icon_state = "twe_suit"
	worn_state = "twe_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/TWE.dmi',
	)

/obj/item/clothing/under/stowaway
	name = "dirty suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon_state = "stowaway_uniform"
	worn_state = "stowaway_uniform"
	icon = 'icons/obj/items/clothing/uniforms/formal_uniforms.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/formal_uniforms.dmi',
	)

/obj/item/clothing/under/rank/chef/exec
	name = "\improper Weyland-Yutani suit"
	desc = "A formal white undersuit."
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/qm_suit
	name = "quartermaster suit"
	desc = "A nicely-fitting military suit for a quartermaster. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "RO_jumpsuit"
	worn_state = "RO_jumpsuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/cargo.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/cargo.dmi',
	)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/synthetic
	name = "\improper USCM Support Uniform"
	desc = "A simple uniform made for Synthetic crewmembers."
	icon_state = "rdalt"
	worn_state = "rdalt"
	icon = 'icons/obj/items/clothing/uniforms/synthetic_uniforms.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/synthetic_uniforms.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/synthetic/synth_k9
	name = "\improper W-Y K9 serial identification collar"
	desc = "Contains a serialized manufacturing number related to this unit's manufacturing date and time."
	icon = 'icons/mob/humans/species/synth_k9/onmob/synth_k9_overlays.dmi'
	flags_item = NODROP
	icon_state = "k9_dogtags"
	worn_state = "k9_dogtags"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/frontier
	name = "\improper frontier jumpsuit"
	desc = "A cargo jumpsuit dressed down for full range of motion and state-of-the-art frontier temperature control. It's the best thing an engineer can wear in the Outer Veil."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "cargo_light"
	worn_state = "cargo_light"
	displays_id = FALSE

/obj/item/clothing/under/rank/utility
	name = "\improper Green utility uniform"
	desc = "A green-on-green utility uniform, popularly issued to UA contract workers on the frontier."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)
	icon_state = "green_utility"
	worn_state = "green_utility"
	displays_id = FALSE

/obj/item/clothing/under/rank/utility/yellow
	name = "\improper Yellow utility uniform"
	desc = "A grey utility uniform with yellow suspenders, made for shipside crew."
	icon_state = "yellow_utility"
	worn_state = "yellow_utility"

/obj/item/clothing/under/rank/utility/red
	name = "\improper Red utility uniform"
	desc = "A grey utility uniform with red suspenders and blue jeans, the sign of a veteran laborer, or someone not paid by the hour."
	icon_state = "red_utility"
	worn_state = "red_utility"

/obj/item/clothing/under/rank/utility/blue
	name = "\improper Blue utility uniform"
	desc = "A blue utility uniform with teal suspenders and rugged pants."
	icon_state = "blue_utility"
	worn_state = "blue_utility"

/obj/item/clothing/under/rank/utility/gray
	name = "\improper Gray utility uniform"
	desc = "A stylish gray jumpsuit, popularly issued to UA contract workers on the frontier."
	icon_state = "grey_utility"
	worn_state = "grey_utility"

/obj/item/clothing/under/rank/utility/brown
	name = "\improper Brown utility uniform"
	desc = "A stylish brown jumpsuit, popularly issued to UA contract workers on the frontier."
	icon_state = "brown_utility"
	worn_state = "brown_utility"
	has_sensor = UNIFORM_HAS_SENSORS

/obj/item/clothing/under/rank/synthetic/councillor
	name = "\improper USCM Pristine Support Uniform"
	desc = "A nicely handcrafted uniform made for Synthetic crewmembers."
	icon_state = "synth_councillor"
	worn_state = "synth_councillor"
	displays_id = FALSE

/obj/item/clothing/under/rank/synthetic/flight
	name = "tactical flightsuit"
	desc = "A flightsuit with plenty of leather straps, pouches, and other essential gear."
	icon_state = "pilot_flightsuit_alt"
	worn_state = "pilot_flightsuit_alt"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_map/jungle.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_map/jungle.dmi',
	)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/rank/synthetic/old
	icon_state = "rdalt_s"
	worn_state = "rdalt_s"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/research.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/research.dmi',
	)

/obj/item/clothing/under/rank/synthetic/upp_joe
	name = "android suit"
	desc = "Uniform designed for UPP security synthetics."
	icon_state = "upp_joe"
	worn_state = "upp_joe"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UPP.dmi',
	)
	flags_item = NO_CRYO_STORE

/obj/item/clothing/under/rank/synthetic/joe
	name = "\improper Working Joe Uniform"
	desc = "A cheap uniform made for Synthetic labor. Tomorrow, Together."
	icon_state = "working_joe"
	worn_state = "working_joe"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/SEEGSON.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/SEEGSON.dmi',
	)
	flags_item = NO_CRYO_STORE
	var/obj/structure/machinery/camera/camera

/obj/item/clothing/under/rank/synthetic/joe/Initialize()
	. = ..()
	camera = new /obj/structure/machinery/camera/autoname/almayer/containment/ares(src)

/obj/item/clothing/under/rank/synthetic/joe/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/clothing/under/rank/synthetic/joe/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	..()

/obj/item/clothing/under/rank/synthetic/joe/dropped(mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "3RR0R"
	..()

/obj/item/clothing/under/rank/synthetic/joe/get_examine_text(mob/user)
	. = ..()
	if(camera)
		. += SPAN_ORANGE("There is a small camera mounted to the front.")

/obj/item/clothing/under/rank/synthetic/joe/engi
	name = "\improper Working Joe Hazardous Uniform"
	desc = "A reinforced uniform used for Synthetic labor in hazardous areas. Tomorrow, Together."
	icon_state = "working_joe_engi"
	worn_state = "working_joe_engi"
	flags_inventory = CANTSTRIP
	armor_melee = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/synthetic/joe/engi/overalls
	name = "\improper Working Joe Hazardous Uniform"
	desc = "A reinforced uniform used for Synthetic labor in hazardous areas. Comes with an additional layer for liquid hazards. Tomorrow, Together."
	icon_state = "working_joe_overalls"
	worn_state = "working_joe_overalls"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	unacidable = TRUE

//=ROYAL MARINES=\\

/obj/item/clothing/under/marine/veteran/royal_marine
	name = "royal marines commando uniform"
	desc = "The field uniform of the royal marines commando. They have shards of light Kevlar to help protect against stabbing weapons and bullets. Onpar with similar USCM equipment"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/TWE.dmi',
	)
	icon_state = "rmc_uniform"
	worn_state = "rmc_uniform"
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN

/obj/item/clothing/under/marine/veteran/royal_marine/tl
	icon_state = "rmc_uniform_teaml"
	worn_state = "rmc_uniform_teaml"

/obj/item/clothing/under/marine/veteran/royal_marine/lt
	name = "royal marines commando officers uniform"
	desc = "The officers uniform of the royal marines commando. They have shards of light Kevlar to help protect against stabbing weapons and bullets. Onpar with similar USCM equipment"
	icon_state = "rmc_uniform_lt"
	worn_state = "rmc_uniform_lt"

/obj/item/clothing/under/marine/officer/royal_marine
	name = "royal marines commando service uniform"
	desc = "The service uniform of the royal marines commando. They have shards of light Kevlar to help protect against stabbing weapons and bullets. Onpar with similar USCM equipment. Wear your uniform with honour, Commando."
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/TWE.dmi',
	)
	icon_state = "rmc_uniform_service"
	worn_state = "rmc_uniform_service"

/obj/item/clothing/under/marine/officer/royal_marine/black
	icon_state = "rmc_uniform_service_alt"
	worn_state = "rmc_uniform_service_alt"

/obj/item/clothing/under/marine/cbrn //CBRN MOPP suit
	name = "\improper M3 MOPP suit"
	desc = "M3 MOPP suits are specially designed and engineered to protect the wearer from unshielded exposure to any Chemical, Biological, Radiological, or Nuclear (CBRN) threats in the field. The suit has a recommended lifespan of twenty-four hours once contact with a toxic environment is made, but depending on the severity this can be shortened to eight hours or less."
	desc_lore = "Since the outbreak of the New Earth Plague in 2157 and the subsequent Interstellar Commerce Commission (ICC) sanctioned decontamination of the colony and its 40 million inhabitants, the abandoned colony has been left under a strict quarantine blockade to prevent any potential scavengers from spreading what’s left of the highly-durable airborne flesh-eating bacteria. Following those events, the three major superpowers have been investing heavily in the development and procurement of CBRN equipment, in no small part due to the extensive damage that the plague and other similar bioweapons could do. The \"Marine 70\" upgrade package and the launch of the M3 pattern armor series saw the first M3-M prototypes approved for CBRN usage."
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	icon_state = "cbrn"
	worn_state = "cbrn"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_faction/UA.dmi'
	flags_jumpsuit = NO_FLAGS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_VERYLOW
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_ULTRAHIGHPLUS
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	actions_types = list(/datum/action/item_action/specialist/toggle_cbrn_hood)

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_faction/UA.dmi',
	)

	///Whether the hood and gas mask were worn through the hood toggle verb
	var/hood_enabled = FALSE
	///Whether enabling the hood protects you from fire
	var/supports_fire_protection = TRUE
	///Typepath of the attached hood
	var/hood_type = /obj/item/clothing/head/helmet/marine/cbrn_hood
	///The head clothing that the suit uses as a hood
	var/obj/item/clothing/head/linked_hood

/obj/item/clothing/under/marine/cbrn/Initialize()
	linked_hood = new hood_type(src)
	. = ..()

/obj/item/clothing/under/marine/cbrn/Destroy()
	. = ..()
	if(linked_hood)
		qdel(linked_hood)

/obj/item/clothing/under/marine/cbrn/verb/hood_toggle()
	set name = "Toggle Hood"
	set desc = "Pull your hood and gasmask up over your face and head."
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr

	if(user.w_uniform != src)
		to_chat(user, SPAN_WARNING("You must be wearing [src] to put on [linked_hood] attached to it!"))
		return

	if(!linked_hood)
		to_chat(user, SPAN_BOLDWARNING("You are missing a linked_hood! This should not be possible."))
		CRASH("[user] attempted to toggle hood on [src] that was missing a linked_hood.")

	playsound(user.loc, "armorequip", 25, 1)
	if(hood_enabled)
		disable_hood(user, FALSE)
		return
	enable_hood(user)

/obj/item/clothing/under/marine/cbrn/proc/enable_hood(mob/living/carbon/human/user)
	if(!istype(user))
		user = usr

	if(!linked_hood.mob_can_equip(user, WEAR_HEAD))
		to_chat(user, SPAN_WARNING("You are unable to equip [linked_hood]."))
		return

	user.equip_to_slot(linked_hood, WEAR_HEAD)

	hood_enabled = TRUE
	RegisterSignal(src, COMSIG_ITEM_UNEQUIPPED, PROC_REF(disable_hood))
	RegisterSignal(linked_hood, COMSIG_ITEM_UNEQUIPPED, PROC_REF(disable_hood))

	if(!supports_fire_protection)
		return
	to_chat(user, SPAN_NOTICE("You raise [linked_hood] over your head. You will no longer catch fire."))
	toggle_fire_protection(user, TRUE)

/obj/item/clothing/under/marine/cbrn/proc/disable_hood(mob/living/carbon/human/user, forced = TRUE)
	if(!istype(user))
		user = usr

	UnregisterSignal(src, COMSIG_ITEM_UNEQUIPPED)
	UnregisterSignal(linked_hood, COMSIG_ITEM_UNEQUIPPED)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon/human, drop_inv_item_to_loc), linked_hood, src), 1) //0.1s delay cause you can grab the hood
	addtimer(CALLBACK(src, PROC_REF(check_remove_headgear)), 2) //Checks if it is still not in contents, incase it was dropped

	hood_enabled = FALSE
	if(!forced)
		to_chat(user, SPAN_NOTICE("You take off [linked_hood]."))

	if(supports_fire_protection)
		toggle_fire_protection(user, FALSE)

/obj/item/clothing/under/marine/cbrn/proc/check_remove_headgear(obj/item/clothing/under/marine/cbrn/uniform = src)
	for(var/current_atom in contents)
		if(current_atom == linked_hood)
			return
	linked_hood.forceMove(uniform)

/obj/item/clothing/under/marine/cbrn/proc/toggle_fire_protection(mob/living/carbon/user, enable_fire_protection)
	if(enable_fire_protection)
		RegisterSignal(user, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_shield_is_on))
		RegisterSignal(user, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(flamer_fire_callback))
		return
	UnregisterSignal(user, list(COMSIG_LIVING_PREIGNITION, COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED))

/obj/item/clothing/under/marine/cbrn/proc/fire_shield_is_on(mob/living/burning_mob) //Stealing it from the pyro spec armor
	SIGNAL_HANDLER

	if(burning_mob.fire_reagent?.fire_penetrating)
		return

	return COMPONENT_CANCEL_IGNITION

/obj/item/clothing/under/marine/cbrn/proc/flamer_fire_callback(mob/living/burning_mob, datum/reagent/fire_reagent)
	SIGNAL_HANDLER

	if(fire_reagent.fire_penetrating)
		return

	. = COMPONENT_NO_IGNITE|COMPONENT_NO_BURN

/datum/action/item_action/specialist/toggle_cbrn_hood
	ability_primacy = SPEC_PRIMARY_ACTION_2

/datum/action/item_action/specialist/toggle_cbrn_hood/New(obj/item/clothing/under/marine/cbrn/armor, obj/item/holder)
	..()
	name = "Toggle Hood"
	button.name = name
	button.overlays.Cut()
	var/image/button_overlay = image(armor.linked_hood.icon, armor, armor.linked_hood.icon_state)
	button.overlays += button_overlay

/datum/action/item_action/specialist/toggle_cbrn_hood/action_activate()
	. = ..()
	var/obj/item/clothing/under/marine/cbrn/armor = holder_item
	if(!istype(armor))
		return
	armor.hood_toggle()

/obj/item/clothing/under/marine/cbrn/advanced
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	hood_type = /obj/item/clothing/head/helmet/marine/cbrn_hood/advanced

