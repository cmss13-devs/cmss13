//=========================//MARINES\\===================================//
//=======================================================================//


/obj/item/clothing/under/marine
	name = "\improper USCM uniform"
	desc = "Standard-issue Marine uniform. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
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
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	///Makes it so that we can see the right name in the vendor.
	var/specialty = "USCM"
	///List of map variants that use sleeve rolling on something else, like snow uniforms rolling the collar, and therefore shouldn't hide patches etc when rolled.
	var/list/map_variants_roll_accessories = list("s_")
	layer = UPPER_ITEM_LAYER

	//speciality does NOTHING if you have NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT), override_icon_state[] = null)
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow uniform"
		else
			name += " uniform"
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type, override_icon_state, new_protection)
	. = ..() //Done after above in case gamemode skin is missing sprites.

/obj/item/clothing/under/marine/set_sensors(mob/user)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("The sensors in \the [src] can't be modified."))
		return
	. = ..()

/obj/item/clothing/under/marine/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	for(var/i in map_variants_roll_accessories)
		if(findtext(icon_state, i, 1, 3))
			flags_jumpsuit |= UNIFORM_DO_NOT_HIDE_ACCESSORIES

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

/obj/item/clothing/under/marine/rto
	name = "\improper USCM radio telephone operator uniform"
	desc = "Standard-issue RTO fatigues. They have shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "marine_rto"
	item_state = "marine_rto"
	specialty = "marine Radio Telephone Operator"

/obj/item/clothing/under/marine/sniper
	name = "\improper USCM sniper uniform"
	flags_jumpsuit = FALSE
	specialty = "USCM Sniper"

/obj/item/clothing/under/marine/tanker
	name = "\improper USCM tanker uniform"
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	flags_jumpsuit = FALSE
	specialty = "USCM tanker"

/obj/item/clothing/under/marine/tanker/New(loc,
	new_protection = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT),
	override_icon_state = list(MAP_ICE_COLONY = "s_marine_tanker"))

	..(loc, new_protection, override_icon_state)

/obj/item/clothing/under/marine/chef
	name = "\improper USCM Mess Technician uniform"
	desc = "Standard-issue Mess Technician uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "chef_uniform"
	worn_state = "chef_uniform"
	flags_jumpsuit = FALSE
	specialty = "USCM mess technician"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/mp
	name = "military police jumpsuit"
	desc = "Standard-issue Military Police uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "MP_jumpsuit"
	worn_state = "MP_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	specialty = "military police"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/warden
	name = "military warden jumpsuit"
	desc = "Standard-issue Military Warden uniform. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/warden)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	specialty = "military warden"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer
	name = "marine officer uniform"
	desc = "Softer than silk. Lighter than feather. More protective than Kevlar. Fancier than a regular jumpsuit, too. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "officertanclothes"
	item_state = "officertanclothes"
	worn_state = "officertanclothes"
	suit_restricted = null //so most officers can wear whatever suit they want
	flags_jumpsuit = FALSE
	specialty = "marine officer"
	black_market_value = 25

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
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
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
	desc = "A bodysuit worn by pilot officers of the USCM, and is meant for survival in inhospitable conditions. Fly the marines onwards to glory. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "pilot_flightsuit"
	item_state = "pilot_flightsuit"
	worn_state = "pilot_flightsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	suit_restricted = list(/obj/item/clothing/suit/armor/vest/pilot, /obj/item/clothing/suit/storage/marine/light/vest/dcc, /obj/item/clothing/suit/storage/jacket/marine/pilot)

/obj/item/clothing/under/marine/officer/pilot/flight
	name = "tactical pilot officer flightsuit"
	desc = "A flightsuit worn by pilot officers of the USCM, with plenty of leather straps, pouches, and other essential gear you will never use. Looks badass."
	icon_state = "pilot_flightsuit_alt"
	item_state = "pilot_flightsuit_alt"
	worn_state = "pilot_flightsuit_alt"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/marine/officer/pilot/dcc
	name = "dropship crew chief bodysuit"
	desc = "A bodysuit worn by dropship crew chiefs of the USCM, and is meant for survival in inhospitable conditions. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "crewchief_flightsuit"
	item_state = "crewchief_flightsuit"
	worn_state = "crewchief_flightsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

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
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	specialty = "marine service"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/officer/exec
	name = "executive officer uniform"
	desc = "A uniform typically worn by a commander Executive Officer in the USCM. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	specialty = "executive officer"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/officer/command
	name = "\improper USCM officer uniform"
	desc = "The well-ironed utility uniform of a USCM officer. Even looking at it the wrong way could result in being court-martialed. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "CO_jumpsuit"
	worn_state = "CO_jumpsuit"
	specialty = "USCM officer"

/obj/item/clothing/under/marine/officer/general
	name = "general uniform"
	desc = "A uniform worn by a fleet general. It comes in a shade of deep black, and has a light shimmer to it. The weave looks strong enough to provide some light protections."
	item_state = "general_jumpsuit"
	worn_state = "general_jumpsuit"
	specialty = "general"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/ce
	name = "chief engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	icon_state = "EC_jumpsuit"
	worn_state = "EC_jumpsuit"
	specialty = "chief engineer"
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "EC_jumpsuit")

/obj/item/clothing/under/marine/officer/engi
	name = "engineer uniform"
	desc = "A uniform for a military engineer. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "mt_jumpsuit"
	worn_state = "mt_jumpsuit"
	specialty = "engineer"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
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
	desc = "A simple set of civilian clothes worn by researchers."
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "research_jumpsuit"
	worn_state = "research_jumpsuit"
	specialty = "researcher"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/servicedress
	name = "captain's dress shirt"
	desc = "The shirt and tie of a two-piece Navy service dress uniform for high-ranking officers. Wear with style and substance."
	specialty = "captain's service dress"
	icon_state = "CO_service"
	worn_state = "CO_service"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/white
	name = "captain's white formal uniform"
	desc = "A well-ironed USCM officer uniform in brilliant white with gold accents, intended for parades or hot weather. Wear this with pride."
	icon_state = "CO_formal_white"
	worn_state = "CO_formal_white"
	specialty = "captain's white formal"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/black
	name = "captain's gray formal uniform"
	desc = "A well-ironed USCM officer uniform in subdued gray with gold accents, intended for more formal or somber events. Wear this with pride."
	icon_state = "CO_formal_black"
	worn_state = "CO_formal_black"
	specialty = "captain's gray formal"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/dress
	name = "old marine dress uniform"
	desc = "A dress uniform typically worn by marines of the USCM. The Sergeant Major would kill you if you got this dirty."
	suit_restricted = list(/obj/item/clothing/suit/storage/jacket/marine/dress)
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	icon_state = "marine_formal"
	worn_state = "marine_formal"
	specialty = "marine dress"
	flags_atom = NO_SNOW_TYPE
	flags_jumpsuit = FALSE
	black_market_value = 15

/obj/item/clothing/under/marine/dress/command
	name = "old marine command dress uniform"
	desc = "A dress uniform typically worn by the most battle-hardened marines of the USCM. Shame on you if you get this dirty."
	icon_state = "command_formal"
	worn_state = "command_formal"
	specialty = "command dress"
	black_market_value = 20

//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/dress/blues
	name = "marine enlisted dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This unadorned variant is for enlisted personnel, E-1 thru E-3."
	icon = 'icons/mob/humans/onmob/contained/marinedressblues.dmi'
	icon_state = "enlisted"
	item_state = "enlisted"
	worn_state = "enlisted"
	contained_sprite = TRUE
	item_state_slots = null

/obj/item/clothing/under/marine/dress/blues/senior
	name = "marine senior dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This variant features the iconic Blood Stripe, worn by NCOs and officers."
	icon_state = "senior"
	item_state = "senior"
	worn_state = "senior"

/obj/item/clothing/under/marine/dress/blues/general
	name = "marine senior dress blues uniform"
	desc = "The undershirt and trousers of the legendary Marine dress blues, virtually unchanged since the 19th century. This variant features black trousers and a large Blood Stripe, worn by general officers."
	icon_state = "general"
	item_state = "general"
	worn_state = "general"

//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/mp/provost
	flags_jumpsuit = FALSE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

	name = "\improper Provost Uniform"
	desc = "The crisp uniform of a Provost Officer."
	icon_state = "provost"
	worn_state = "provost"

	specialty = "provost"

	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/MP,
		/obj/item/clothing/suit/armor/riot/marine,
		/obj/item/clothing/suit/storage/jacket/marine/provost,
	)

	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

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

/obj/item/clothing/under/marine/mp/provost/marshal
	name = "\improper Provost Marshal Uniform"
	desc = "The crisp uniform of a Provost Marshal."
	icon_state = "WO_jumpsuit"
	worn_state = "WO_jumpsuit"

/obj/item/clothing/under/marine/mp/provost/marshal/sector
	name = "\improper Provost Sector Marshal Uniform"
	desc = "The crisp uniform of a Provost Sector Marshal."

/obj/item/clothing/under/marine/mp/provost/marshal/chief
	name = "\improper Provost Chief Marshal Uniform"
	desc = "The crisp uniform of the Provost Chief Marshal."

//==================//UNITED AMERICAS ALLIED COMMAND\\===================\\
//=======================================================================\\

/obj/item/clothing/under/uaac/tis
	name = "\improper UAAC-TIS Special Agent Uniform"
	desc = "A modified USCM Provost uniform, with its original insignia replaced by those of the UAAC-TIS Intelligence Service. TIS Special Agents are often recruited from the upper echelons of law enforcement agencies in various UA armed forces. These recruits often take all their gear, uniform included with them and later modify them to include TIS and UAAC insignia."
	flags_jumpsuit = FALSE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	siemens_coefficient = 0.9
	icon_state = "tis"
	worn_state = "tis"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/uaac/tis/io
	name = "\improper UAAC-TIS Intelligence Officer uniform"
	desc = "Originally a USCM officer uniform, all insignia have been carefully removed and replaced by a simple TIS pin worn over the right breast. Like their Special Agent counterparts, TIS Intel Officers are typically transplants from UA aligned armed forces, often initially recruited on a temporary basis then transferred permanently. As such, officers are often forced to adapt their original uniforms."
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
//=========================//USCM Survivors\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/reconnaissance
	name = "\improper USCM uniform"
	desc = "Torn, Burned and blood stained. This uniform has seen much more than you could possibly imagine."
	icon_state = "recon_marine"
	worn_state = "recon_marine"
	flags_atom = NO_SNOW_TYPE

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
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.

//=========================//Marine Raiders\\================================\\

/obj/item/clothing/under/marine/veteran/marsoc
	name = "SOF Uniform"
	desc = "A black uniform for elite Marine personnel. Designed to be comfortable and help blend into dark enviorments."
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	icon_state = "marsoc"
	worn_state = "marsoc"
	specialty = "sof uniform"
	flags_item = NO_SNOW_TYPE

//=========================//PMC\\================================\\

/obj/item/clothing/under/marine/veteran/pmc
	name = "\improper PMC fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weyland-Yutani corporation is emblazed on the suit."
	icon_state = "pmc_jumpsuit"
	worn_state = "pmc_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	suit_restricted = list(
		/obj/item/clothing/suit/storage/marine/veteran/pmc,
		/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc,
		/obj/item/clothing/suit/armor/vest/security,
	)

/obj/item/clothing/under/marine/veteran/pmc/leader
	name = "\improper PMC command fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weyland-Yutani corporation is emblazed on the suit. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_jumpsuit"
	worn_state = "officer_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/commando
	name = "\improper PMC commando uniform"
	desc = "An armored uniform worn by Weyland-Yutani elite commandos. It is well protected while remaining light and comfortable."
	icon_state = "commando_jumpsuit"
	worn_state = "commando_jumpsuit"

/obj/item/clothing/under/marine/veteran/pmc/corporate
	name = "\improper WY corporate security uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by what are known as 'goons'."
	icon = 'icons/mob/humans/onmob/contained/wy_goons.dmi'
	icon_state = "uniform"
	item_state = "uniform"
	worn_state = "uniform"
	contained_sprite = TRUE
	item_state_slots = null
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/corporate/lead
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by the lead of the 'goonsquad', as they are colloquially known."
	icon_state = "lead_uniform"
	item_state = "lead_uniform"
	worn_state = "lead_uniform"

//=========================//UPP\\================================\\

/obj/item/clothing/under/marine/veteran/bear
	name = "\improper Iron Bear uniform"
	desc = "A uniform worn by Iron Bears mercenaries in the service of Mother Russia. Smells a little like an actual bear."
	icon_state = "bear_jumpsuit"
	worn_state = "bear_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/bear)


/obj/item/clothing/under/marine/veteran/UPP
	name = "\improper UPP fatigues"
	desc = "A set of UPP fatigues, mass produced for the armed-forces of the Union of Progressive Peoples. A rare sight, especially in ICC zones. This particular set sports the dark drab pattern of the UPP 17th battalion, 'Smoldering Sons', operating in the sparse UPP frontier in the Anglo-Japanese arm."
	icon_state = "upp_uniform"
	worn_state = "upp_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_UPP
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/UPP, /obj/item/clothing/suit/gimmick/jason, /obj/item/clothing/suit/storage/snow_suit/soviet, /obj/item/clothing/suit/storage/snow_suit/survivor)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

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

//=========================//Freelancer\\================================\\

/obj/item/clothing/under/marine/veteran/freelancer
	name = "\improper freelancer fatigues"
	desc = "A set of loose-fitting fatigues, perfect for an informal mercenary. Smells like gunpowder, apple pie, and covered in grease and sake stains."
	icon_state = "freelancer_uniform"
	worn_state = "freelancer_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/freelancer)

//=========================//Dutch Dozen\\================================\\

/obj/item/clothing/under/marine/veteran/dutch
	name = "\improper Dutch's Dozen uniform"
	desc = "A comfortable uniform worn by the Dutch's Dozen mercenaries. It's seen some definite wear and tear, but is still in good condition."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon_state = "dutch_jumpsuit"
	worn_state = "dutch_jumpsuit"
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/dutch, /obj/item/clothing/suit/armor/vest/dutch)


/obj/item/clothing/under/marine/veteran/dutch/ranger
	icon_state = "dutch_jumpsuit2"

/obj/item/clothing/under/marine/veteran/van_bandolier
	name = "hunting clothes"
	desc = "A set of tailored clothes, made from fine but sturdy reinforced fabrics. Protects from thorns, weather, and the cuts and scrapes that forever bedevil outdoorsmen."
	icon_state = "van_bandolier"
	worn_state = "van_bandolier"
	item_state = "van_bandolier_clothes"
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/under/marine/veteran/mercenary
	name = "\improper Mercenary fatigues"
	desc = "A thick, beige suit with a red armband. There is an unknown symbol is emblazed on the suit."
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
	icon_state = "ua_riot"
	worn_state = "ua_riot"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.
	flags_jumpsuit = FALSE
	suit_restricted = null

/obj/item/clothing/under/marine/ucf_clown
	name = "\improper UCF uniform"
	desc = "A Unified Clown Federation combat uniform. Features the latest in anti-mime technology."
	icon_state = "clown"
	worn_state = "clown"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.
	black_market_value = 25

/obj/item/clothing/under/pizza
	name = "pizza delivery uniform"
	desc = "An ill-fitting, slightly stained uniform for a pizza delivery pilot. Smells of cheese."
	icon_state = "redshirt2"
	item_state = "r_suit"
	worn_state = "redshirt2"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/souto
	name = "\improper Souto Man's cargo pants"
	desc = "The white cargo pants worn by the one and only Souto man. As cool as an ice cold can of Souto Grape!"
	icon_state = "souto_man"
	worn_state = "souto_man"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/colonist
	name = "colonist uniform"
	desc = "A stylish gray-green jumpsuit - standard issue for colonists."
	icon_state = "colonist"
	worn_state = "colonist"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_COLONIST

/obj/item/clothing/under/colonist/clf
	name = "\improper Colonial Liberation Front uniform"
	desc = "A stylish grey-green jumpsuit - standard issue for colonists. This version appears to have the symbol of the Colonial Liberation Front emblazoned in select areas."
	icon_state = "clf_uniform"
	worn_state = "clf_uniform"
	sensor_faction = FACTION_CLF

/obj/item/clothing/under/colonist/ua_civvies
	name = "gray utilities"
	desc = "A stylish gray jumpsuit - standard issue for UA civilian support personnel."
	icon_state = "ua_civvies"
	worn_state = "ua_civvies"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/colonist/wy_davisone
	name = "brown utilities"
	desc = "A stylish brown jumpsuit - standard issue for UA civilian support personnel."
	icon_state = "wy_davisone"
	worn_state = "wy_davisone"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/colonist/wy_joliet_shopsteward
	name = "steward utilities"
	desc = "A stylish brown vest and shorts - uniforms like this are often worn by clerks and shop stewards."
	icon_state = "wy_joliet_shopsteward"
	worn_state = "wy_joliet_shopsteward"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt
	name = "T-shirt parent object"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/tshirt/w_br
	name = "white T-shirt and brown pants"
	desc = "A comfortable white T-shirt and brown jeans."
	icon_state = "tshirt_w_br"
	worn_state = "tshirt_w_br"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt/gray_blu
	name = "gray T-shirt and jeans"
	desc = "A comfortable gray T-shirt and blue jeans."
	icon_state = "tshirt_gray_blu"
	worn_state = "tshirt_gray_blu"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt/r_bla
	name = "red T-shirt and black pants"
	desc = "A comfortable red T-shirt and black jeans."
	icon_state = "tshirt_r_bla"
	worn_state = "tshirt_r_bla"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/CM_uniform
	name = "\improper Colonial Marshal uniform"
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
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon_state = "liaison_regular"
	worn_state = "liaison_regular"

/obj/item/clothing/under/liaison_suit/outing
	name = "liaison's outfit"
	desc = "A casual outfit consisting of a collared shirt and a vest. Looks like something you might wear on the weekends, or on a visit to a derelict colony."
	icon_state = "liaison_outing"
	worn_state = "liaison_outing"

/obj/item/clothing/under/liaison_suit/formal
	name = "liaison's white suit"
	desc = "A formal, white suit. Looks like something you'd wear to a funeral, a Weyland-Yutani corporate dinner, or both. Stiff as a board, but makes you feel like rolling out of a Rolls-Royce."
	icon_state = "liaison_formal"
	worn_state = "liaison_formal"

/obj/item/clothing/under/liaison_suit/suspenders
	name = "liaison's attire"
	desc = "A collared shirt, complimented by a pair of suspenders. Worn by Weyland-Yutani employees who ask the tough questions. Smells faintly of cigars and bad acting."
	icon_state = "liaison_suspenders"
	worn_state = "liaison_suspenders"

/obj/item/clothing/under/marine/reporter
	name = "combat correspondent uniform"
	desc = "A relaxed and robust uniform fit for any potential reporting needs."
	icon = 'icons/mob/humans/onmob/contained/war_correspondent.dmi'
	icon_state = "wc_uniform"
	worn_state = "wc_uniform"
	contained_sprite = TRUE
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/under/twe_suit
	name = "representative's fine suit"
	desc = "A stiff, stylish blue suit commonly worn by gentlemen from the Three World Empire. Expertly crafted to make you look as important as possible."
	icon_state = "twe_suit"
	worn_state = "twe_suit"

/obj/item/clothing/under/stowaway
	name = "dirty suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon_state = "stowaway_uniform"
	worn_state = "stowaway_uniform"

/obj/item/clothing/under/rank/chef/exec
	name = "\improper Weyland-Yutani suit"
	desc = "A formal white undersuit."
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/ro_suit
	name = "requisition officer suit"
	desc = "A nicely-fitting military suit for a requisition officer. It has shards of light Kevlar to help protect against stabbing weapons and bullets."
	icon_state = "RO_jumpsuit"
	worn_state = "RO_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/synthetic
	name = "\improper USCM Support Uniform"
	desc = "A simple uniform made for Synthetic crewmembers."
	icon_state = "rdalt"
	worn_state = "rdalt"
	flags_jumpsuit = FALSE

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
