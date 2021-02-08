//=========================//MARINES\\===================================//
//=======================================================================//


/obj/item/clothing/under/marine
	name = "\improper USCM uniform"
	desc = "A standard-issue Marine uniform. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	siemens_coefficient = 0.9
	icon_state = "marine_jumpsuit"
	worn_state = "marine_jumpsuit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	rollable_sleeves = TRUE
	var/specialty = "USCM" //Makes it so that we can see the right name in the vendor.
	layer = UPPER_ITEM_LAYER

/obj/item/clothing/under/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature), override_icon_state[] 	= null)
	. = ..()
	if(!(flags_atom & UNIQUE_ITEM_TYPE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow uniform"
		else
			name += " uniform"
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type, override_icon_state, new_protection)

/obj/item/clothing/under/marine/set_sensors(mob/user)
	if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
		to_chat(user, SPAN_WARNING("The sensors in your uniform can't be modified."))
		return
	. = ..()

/obj/item/clothing/under/marine/medic
	name = "\improper USCM medic uniform"
	desc = "A standard-issue Marine Medic fatigues. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "marine_medic"
	worn_state = "marine_medic"
	specialty = "USCM medic"

/obj/item/clothing/under/marine/engineer
	name = "\improper USCM engineer uniform"
	desc = "A standard-issue Marine Engineer fatigues. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "marine_engineer"
	worn_state = "marine_engineer"
	specialty = "USCM engineer"

/obj/item/clothing/under/marine/sniper
	name = "\improper USCM sniper uniform"
	rollable_sleeves = FALSE
	specialty = "USCM sniper"

/obj/item/clothing/under/marine/tanker
	name = "\improper USCM tanker uniform"
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	rollable_sleeves = FALSE
	specialty = "USCM tanker"
	flags_atom = NO_SNOW_TYPE//it has object sprites but no on mobbies, someone get around to fixing this

/*
/obj/item/clothing/under/marine/tanker/New(loc,expected_type 		= type,
	new_name[] 			= list(MAP_ICE_COLONY = "\improper USCM tanker snow uniform"),
	new_protection[] 	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature),
	override_icon_state[]		= list(MAP_ICE_COLONY = "s_marine_tanker")
	)
	..(loc,expected_type, override_icon_state, new_name, new_protection)
*/

/obj/item/clothing/under/marine/chef
	name = "\improper USCM mess sergeant uniform"
	desc = "A standard-issue Marine Engineer fatigues. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "chef_uniform"
	worn_state = "chef_uniform"
	rollable_sleeves = FALSE
	specialty = "USCM mess sergeant"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/mp
	name = "military police jumpsuit"
	desc = "A standard-issue Military Police uniform. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "MP_jumpsuit"
	worn_state = "MP_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine)
	rollable_sleeves = FALSE
	specialty = "military police"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/warden
	name = "military warden jumpsuit"
	desc = "A standard-issue Military Warden uniform. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine)
	rollable_sleeves = FALSE
	specialty = "military warden"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer
	name = "marine officer uniform"
	desc = "Softer than silk. Lighter than feather. More protective than Kevlar. Fancier than a regular jumpsuit, too. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "officertanclothes"
	item_state = "officertanclothes"
	worn_state = "officertanclothes"
	suit_restricted = null //so most officers can wear whatever suit they want
	rollable_sleeves = FALSE
	specialty = "marine officer"

/obj/item/clothing/under/marine/officer/intel
	name = "\improper marine intelligence officer sweatsuit"
	desc = "Tighter than a vice. Slicker than beard oil. Covered from head to toe in pouches, pockets, bags, straps, and belts. Clearly, you are not only the most intelligent of intelligence officers, but the most fashionable as well. This suit took an entire R&D team five days to develop. It is more expensive than the entire Almayer... probably."
	icon_state = "io"
	item_state = "io"
	worn_state = "io"
	rollable_sleeves = FALSE
	specialty = "marine intelligence officer"

/obj/item/clothing/under/marine/officer/warrant
	name = "\improper chief MP uniform"
	desc = "A uniform typically worn by a Chief MP of the USCM. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions. This uniform includes a small EMF distributor to help nullify energy-based weapon fire, along with a hazmat chemical filter woven throughout the material to ward off biological and radiation hazards."
	icon_state = "WO_jumpsuit"
	item_state = "WO_jumpsuit"
	worn_state = "WO_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine)
	specialty = "chief MP"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/technical
	name = "technical officer uniform"
	icon_state = "johnny"
	worn_state = "johnny"
	specialty = "technical officer"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/pilot
	name = "pilot officer bodysuit"
	desc = "A bodysuit worn by pilot officers of the USCM, and is meant for survival in inhospitable conditions. Fly the marines onwards to glory. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "pilot_flightsuit"
	worn_state = "pilot_flightsuit"
	flags_cold_protection = ICE_PLANET_min_cold_protection_temperature
	suit_restricted = list(/obj/item/clothing/suit/armor/vest/pilot)

/obj/item/clothing/under/marine/officer/pilot/New()
	select_gamemode_skin(type)
	return //This way we keep it as a bodysuit across all maps.

/obj/item/clothing/under/marine/officer/tanker
	name = "vehicle crewman uniform"
	desc = "A uniform worn by vehicle crewmen of the USCM. Do the corps proud. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/tanker)
	specialty = "vehicle crewman"
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "marine_tanker")

/obj/item/clothing/under/marine/officer/bridge
	name = "marine service uniform"
	desc = "A service uniform worn by members of the USCM. Do the corps proud. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	specialty = "marine service"
	rollable_sleeves = TRUE

/obj/item/clothing/under/marine/officer/exec
	name = "executive officer uniform"
	desc = "A uniform typically worn by a commander Executive Officer in the USCM. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	specialty = "executive officer"
	rollable_sleeves = TRUE

/obj/item/clothing/under/marine/officer/command
	name = "\improper USCM officer uniform"
	desc = "The well-ironed utility uniform of a USCM officer. Even looking at it the wrong way could result in being court-marshalled. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "CO_jumpsuit"
	worn_state = "CO_jumpsuit"
	specialty = "USCM officer"

/obj/item/clothing/under/marine/officer/admiral
	name = "admiral uniform"
	desc = "A uniform worn by a fleet admiral. It comes in a shade of deep black, and has a light shimmer to it. The weave looks strong enough to provide some light protections."
	item_state = "admiral_jumpsuit"
	worn_state = "admiral_jumpsuit"
	specialty = "admiral"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/ce
	name = "chief engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	icon_state = "EC_jumpsuit"
	worn_state = "EC_jumpsuit"
	specialty = "chief engineer"
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "EC_jumpsuit")

/obj/item/clothing/under/marine/officer/engi
	name = "engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	icon_state = "mt_jumpsuit"
	worn_state = "mt_jumpsuit"
	specialty = "engineer"
	rollable_sleeves = TRUE
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "mt_jumpsuit")

/obj/item/clothing/under/marine/officer/engi/OT
	name = "ordnance engineer uniform"
	desc = "A uniform for a professional bomb maker. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions. Padded with extra plates to take the brunt force of an explosion."
	armor_bomb = CLOTHING_ARMOR_LOW
	icon_state = "ot_jumpsuit"
	worn_state = "ot_jumpsuit"
	item_state_slots = list(WEAR_BODY = "ot_jumpsuit")

/obj/item/clothing/under/marine/officer/researcher
	name = "researcher clothes"
	desc = "A simple set of civilian clothes worn by researchers. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	icon_state = "research_jumpsuit"
	worn_state = "research_jumpsuit"
	specialty = "researcher"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/white
	name = "formal commanding officer's white uniform"
	desc = "The well-ironed formal uniform of a USCM officer. Even looking at it the wrong way could result in you, and your platoon being court-marshalled. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "CO_formal_white"
	worn_state = "CO_formal_white"
	specialty = "USCM officer"
	flags_atom = NO_SNOW_TYPE
	rollable_sleeves = TRUE

/obj/item/clothing/under/marine/officer/formal/black
	name = "formal commanding officer's black uniform"
	desc = "The well-ironed formal uniform of a USCM officer. Even looking at it the wrong way could result in you, and your platoon being court-marshalled. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "CO_formal_black"
	worn_state = "CO_formal_black"
	specialty = "USCM officer"
	flags_atom = NO_SNOW_TYPE
	rollable_sleeves = TRUE

/obj/item/clothing/under/marine/officer/dining
	name = "dining commanding officer uniform"
	desc = "The well-ironed dining uniform of a USCM officer. This uniform is saved for dining, that way you and the years-old stain upon the collar look sharp during your most important meals."
	icon_state = "CO_dining"
	worn_state = "CO_dining"
	specialty = "USCM officer"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/casual
	name = "casual commanding officer uniform"
	desc = "Casual clothing you brought aboard to show the marines you do in fact have style. Should only be worn during downtime, or special occasions."
	icon_state = "CO_casual"
	worn_state = "CO_casual"
	specialty = "USCM officer"
	flags_atom = NO_SNOW_TYPE
	rollable_sleeves = TRUE

/obj/item/clothing/under/marine/dress
	name = "marine dress uniform"
	desc = "A dress uniform typically worn marines of the USCM. The Sergeant Major would kill you if you got this dirty."
	suit_restricted = list(/obj/item/clothing/suit/storage/jacket/marine/dress)
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	icon_state = "marine_formal"
	worn_state = "marine_formal"
	specialty = "marine dress"
	flags_atom = NO_SNOW_TYPE

//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/mp/provost
	rollable_sleeves = FALSE
	flags_atom = NO_SNOW_TYPE|UNIQUE_ITEM_TYPE

	name = "\improper Provost Uniform"
	desc = "The crisp uniform of a Provost Officer."
	icon_state = "provost"
	worn_state = "provost"

	specialty = "provost"

	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/MP,
		/obj/item/clothing/suit/armor/riot/marine,
		/obj/item/clothing/suit/storage/jacket/marine/provost
	)

	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/marine/mp/provost/enforcer
	name = "\improper Provost Enforcer Uniform"
	desc = "The crisp uniform of a Provost Enforcer."

/obj/item/clothing/under/marine/mp/provost/tml
	name = "\improper Provost Team Leader Uniform"
	desc = "The crisp uniform of a Provost Team Leader."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"

/obj/item/clothing/under/marine/mp/provost/advisor
	name = "\improper Provost Advisor Uniform"
	desc = "The crisp uniform of a Provost Advisor."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"

/obj/item/clothing/under/marine/mp/provost/inspector
	name = "\improper Provost Inspector Uniform"
	desc = "The crisp uniform of a Provost Inspector."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"

/obj/item/clothing/under/marine/mp/provost/marshall
	name = "\improper Provost Marshall Uniform"
	desc = "The crisp uniform of a Provost Marshall."
	icon_state = "WO_jumpsuit"
	worn_state = "WO_jumpsuit"

/obj/item/clothing/under/marine/mp/provost/marshall/sector
	name = "\improper Provost Sector Marshall Uniform"
	desc = "The crisp uniform of a Provost Sector Marshall."

/obj/item/clothing/under/marine/mp/provost/marshall/chief
	name = "\improper Provost Chief Marshall Uniform"
	desc = "The crisp uniform of the Provost Chief Marshall."

//=========================//RESPONDERS\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/veteran
	rollable_sleeves = FALSE
	flags_atom = NO_SNOW_TYPE|UNIQUE_ITEM_TYPE //Let's make them keep their original name.

/obj/item/clothing/under/marine/veteran/PMC
	name = "\improper PMC fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weston-Yamada corporation is emblazed on the suit."
	icon_state = "pmc_jumpsuit"
	worn_state = "pmc_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/PMC,
							/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC,
							/obj/item/clothing/suit/armor/vest/security)//For survivors.

/obj/item/clothing/under/marine/veteran/PMC/leader
	name = "\improper PMC command fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weston-Yamada corporation is emblazed on the suit. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_jumpsuit"
	worn_state = "officer_jumpsuit"

/obj/item/clothing/under/marine/veteran/PMC/commando
	name = "\improper PMC commando uniform"
	desc = "An armored uniform worn by Weston-Yamada elite commandos. It is well protected while remaining light and comfortable."
	icon_state = "commando_jumpsuit"
	worn_state = "commando_jumpsuit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/marine/veteran/bear
	name = "\improper Iron Bear uniform"
	desc = "A uniform worn by Iron Bears mercenaries in the service of Mother Russia. Smells a little like an actual bear."
	icon_state = "bear_jumpsuit"
	worn_state = "bear_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	has_sensor = 0
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/bear)


/obj/item/clothing/under/marine/veteran/UPP
	name = "\improper UPP fatigues"
	desc = "A set of UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform"
	worn_state = "upp_uniform"
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	has_sensor = 0
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/UPP, /obj/item/clothing/suit/storage/marine/smartgunner/UPP, /obj/item/clothing/suit/gimmick/jason)

/obj/item/clothing/under/marine/veteran/UPP/medic
	name = "\improper UPP medic fatigues"
	icon_state = "upp_uniform_medic"
	worn_state = "upp_uniform_medic"

/obj/item/clothing/under/marine/veteran/freelancer
	name = "\improper freelancer fatigues"
	desc = "A set of loose fitting fatigues, perfect for an informal mercenary. Smells like gunpowder, apple pie, and covered in grease and sake stains."
	icon_state = "freelancer_uniform"
	worn_state = "freelancer_uniform"
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	has_sensor = 0
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/freelancer)

/obj/item/clothing/under/marine/veteran/dutch
	name = "\improper Dutch's Dozen uniform"
	desc = "A comfortable uniform worn by the Dutch's Dozen mercenaries. It's seen some definite wear and tear, but is still in good condition."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon_state = "dutch_jumpsuit"
	worn_state = "dutch_jumpsuit"
	has_sensor = 0
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/dutch, /obj/item/clothing/suit/armor/vest/dutch)


/obj/item/clothing/under/marine/veteran/dutch/ranger
	icon_state = "dutch_jumpsuit2"

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/under/marine/veteran/mercenary
	name = "\improper Mercenary fatigues"
	desc = "A thick, beige suit with a red armband. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_heavy_uniform"
	worn_state = "mercenary_heavy_uniform"
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/mercenary)

/obj/item/clothing/under/marine/veteran/mercenary/miner
	name = "\improper Mercenary miner fatigues"
	desc = "A beige suit with a red armband. It looks a little thin, like it wasn't designed for protection. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_miner_uniform"
	worn_state = "mercenary_miner_uniform"

/obj/item/clothing/under/marine/veteran/mercenary/engineer
	name = "\improper Mercenary engineer fatigues"
	desc = "A blue suit with yellow accents, used by engineers. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_engineer_uniform"
	worn_state = "mercenary_engineer_uniform"


////// Civilians /////////

/obj/item/clothing/under/marine/ua_riot
	name = "\improper United American security uniform"
	desc = "Overalls made of kevlon cover a snazzy blue dress shirt. UA branded security uniforms are notorious for their association with anti-union riot control teams."
	icon_state = "ua_riot"
	worn_state = "ua_riot"
	flags_atom = NO_SNOW_TYPE
	rollable_sleeves = FALSE
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/ua_riot)

/obj/item/clothing/under/pizza
	name = "pizza delivery uniform"
	desc = "An ill-fitting, slightly stained uniform for a pizza delivery pilot. Smells of cheese."
	icon_state = "redshirt2"
	item_state = "r_suit"
	worn_state = "redshirt2"
	has_sensor = 0

/obj/item/clothing/under/souto
	name = "\improper Souto Man's cargo pants"
	desc = "The white cargo pants worn by the one and only Souto man. As cool as an ice cold can of Souto Grape!"
	icon_state = "souto_man"
	worn_state = "souto_man"
	has_sensor = 0

/obj/item/clothing/under/colonist
	name = "colonist uniform"
	desc = "A stylish grey-green jumpsuit - standard issue for colonists."
	icon_state = "colonist"
	worn_state = "colonist"
	has_sensor = 0

/obj/item/clothing/under/colonist/clf
	name = "\improper Colonial Liberation Front uniform"
	desc = "A stylish grey-green jumpsuit - standard issue for colonists. This version appears to have the symbol of the Colonial Liberation Front emblazoned in select areas."
	icon_state = "clf_uniform"
	worn_state = "clf_uniform"

/obj/item/clothing/under/CM_uniform
	name = "colonial marshal uniform"
	desc = "A blue shirt and tan trousers - the official uniform for a Colonial Marshal."
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


/obj/item/clothing/under/liaison_suit
	name = "liaison's tan suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weston-Yamada corporation. Expertly crafted to make you look like a prick."
	icon_state = "liaison_regular"
	worn_state = "liaison_regular"

/obj/item/clothing/under/liaison_suit/outing
	name = "liaison's outfit"
	desc = "A casual outfit consisting of a collared shirt and a vest. Looks like something you might wear on the weekends, or on a visit to a derelict colony."
	icon_state = "liaison_outing"
	worn_state = "liaison_outing"

/obj/item/clothing/under/liaison_suit/formal
	name = "liaison's white suit"
	desc = "A formal, white suit. Looks like something you'd wear to a funeral, a Weston-Yamada corporate dinner, or both. Stiff as a board, but makes you feel like rolling out of a Rolls-Royce."
	icon_state = "liaison_formal"
	worn_state = "liaison_formal"

/obj/item/clothing/under/liaison_suit/suspenders
	name = "liaison's attire"
	desc = "A collared shirt, complimented by a pair of suspenders. Worn by Weston-Yamada employees who ask the tough questions. Smells faintly of cigars and bad acting."
	icon_state = "liaison_suspenders"
	worn_state = "liaison_suspenders"

/obj/item/clothing/under/ress_suit
	name = "representative's fine suit"
	desc = "A stiff, stylish blue suit commonly worn by gentlemen from the Royal Empire of the Rising Sun. Expertly crafted to make you look as important as possible."
	icon_state = "ress_suit"
	worn_state = "ress_suit"

/obj/item/clothing/under/stowaway
	name = "dirty suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weston-Yamada corporation. Expertly crafted to make you look like a prick."
	icon_state = "stowaway_uniform"
	worn_state = "stowaway_uniform"

/obj/item/clothing/under/rank/chef/exec
	name = "\improper Weston-Yamada suit"
	desc = "A formal white undersuit."
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/ro_suit
	name = "requisition officer suit."
	desc = "A nicely-fitting military suit for a requisition officer. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon_state = "RO_jumpsuit"
	worn_state = "RO_jumpsuit"
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/synthetic
	name = "\improper USCM Support Uniform"
	desc = "A simple uniform made for Synthetic crewmembers."
	icon_state = "rdalt"
	worn_state = "rdalt"
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/synthetic/councillor
	name = "\improper USCM Pristine Support Uniform"
	desc = "A nicely handcrafted uniform made for Synthetic crewmembers."
	icon_state = "synth_councillor"
	worn_state = "synth_councillor"
	displays_id = FALSE

/obj/item/clothing/under/rank/synthetic/old
	icon_state = "rdalt_s"
	worn_state = "rdalt_s"

/obj/item/clothing/under/rank/synthetic/joe
	name = "\improper Working Joe Uniform"
	desc = "A cheap uniform made for Synthetic labor."
	icon_state = "working_joe"
	worn_state = "working_joe"
